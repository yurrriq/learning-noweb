IDR_NW    := $(wildcard src/idris/*.nw)
IDR       := ${IDR_NW:.nw=.idr}
IDR_HTML  := ${IDR_NW:.nw=.html}
IDR_TEX   := ${IDR_NW:.nw=.tex}
IDR_PDF   := ${IDR_NW:.nw=.pdf}
IDR_SRCS  := ${IDR} ${IDR_TEX} ${IDR_PDF} ${IDR_HTML}
IDR_DOCS  := $(patsubst src/%,docs/%,${IDR_HTML} ${IDR_PDF})
IDR_ALL   := ${IDR_SRCS} ${IDR_DOCS}

ERL_NW    := $(wildcard src/erlang/*.nw)
ERL       := ${ERL_NW:.nw=.erl}
ERL_HTML  := ${ERL_NW:.nw=.html}
ERL_TEX   := ${ERL_NW:.nw=.tex}
ERL_PDF   := ${ERL_NW:.nw=.pdf}
ERL_SRCS  := ${ERL} ${ERL_TEX} ${ERL_PDF} ${ERL_HTML}
ERL_DOCS  := $(patsubst src/%,docs/%,${ERL_HTML} ${ERL_PDF})
ERL_ALL   := ${ERL_SRCS} ${ERL_DOCS}

# http://stackoverflow.com/a/17807510
dirname    = $(patsubst %/,%,$(dir $1))

.SUFFIXES: .nw .erl .idr .html .pdf .tex
.nw.erl: ; notangle -R'$(basename $(notdir $<))' -filter btdefn $< >$@
.nw.idr: ; notangle -R'$(basename $(notdir $<))' -filter btdefn $< >$@
# NOTE: requires latex2html
.nw.html: ; noweave -filter btdefn -filter l2h -index -html $< >$@
.nw.tex:  ; noweave -filter btdefn -n -delay -index $< >$@
.tex.pdf: ; latexmk -pdf -outdir=$(call dirname,$<) $<

all: idris erlang
	@ ln -sf idris/hello.html docs/index.html

.PHONY: idris erlang

idris: ${IDR_ALL}
erlang: ${ERL_ALL}

docs/%.html: src/%.html
	@ mkdir -p $(dir $@)
	@ mv $< $@

docs/%.pdf: src/%.pdf
	@ mkdir -p $(dir $@)
	@ mv $< $@

.PHONY: clean clean-docs clobber

keep_regex := '.*.[erl|idr|nw|tex]'

clean:
	@ find src -type f \! -regex ${keep_regex} -delete

clean-docs:
	@ rm -fr docs

clobber:
	@ find src \! -name '*.nw' -type f -delete
