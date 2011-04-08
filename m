Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757988Ab1DHVRV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 17:17:21 -0400
Received: from wnohang.net ([178.79.154.173]:33252 "EHLO mail.wnohang.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753397Ab1DHVRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 17:17:19 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 mail.wnohang.net 5239324425
X-DKIM: Sendmail DKIM Filter v2.8.3 mail.wnohang.net ADF022400E
Date: Sat, 9 Apr 2011 02:47:09 +0530
From: Raghavendra D Prabhu <rprabhu@wnohang.net>
To: Michael Witten <mfwitten@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Use the environment variable PYTHON if defined
Message-ID: <20110408211709.GA5155@Xye>
References: <20110326224408.GA1336@Xye>
 <20110328144721.GB17872@ghostprotocols.net>
 <e987828e-87ec-4973-95e7-47f10f5d9bab-mfwitten@gmail.com>
 <20110329181524.GA5140@Xye>
 <AANLkTi=3Wq3Xt-QFR-FLRQ1kBjpWjaBZNFpOiE_T15WH@mail.gmail.com>
 <20110329204024.GA20824@ghostprotocols.net>
 <3a97df19-e376-412a-95be-37ffde765cc3-mfwitten@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k1lZvvs/B4yU6o8G"
Content-Disposition: inline
In-Reply-To: <3a97df19-e376-412a-95be-37ffde765cc3-mfwitten@gmail.com>
X-Operating-System: Arch linux x86_64 2.6.38.2-bldit-db-FAE
X-Editor: VIM - Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

* On Thu, Mar 31, 2011 at 03:37:40PM +0000, Michael Witten <mfwitten@gmail.com> wrote:
>On Tue, 2011-03-29 17:40:25 -0300, Arnaldo Carvalho de Melo wrote:
>>Em Tue, Mar 29, 2011 at 02:15:30PM -0500, Michael Witten escreveu:
>>> On Tue, Mar 29, 2011 at 13:15, Raghavendra D Prabhu <rprabhu@wnohang.net> wrote:
>>>> the patch submitted by Michael seems to be taking care of far
>>>> more cases than mine, so that is much better.

>>> One major issue with my current patch is that I opted to stop the
>>> build with an error message even when using the default python command
>>> names; is this undesirable? Is it better to fail silently as before
>>> (via the somewhat cryptic Python.h message), or is it better to force
>>> the user to specify that no python support should be built?

>> I think that the best course of action is to emit a warning and go, i.e.
>> we don't have to make it harder for people that don't want $FOO support
>> to make that clear.
>
>The following patch implements the above requested behavior,
>and it is also a bit more robust than the previous patch.
>
>However, consider running this command:
>
> make clean NO_LIBPYTHON=1
>
>and the resulting output:
>
>  Python support won't be built
>  PERF_VERSION = 2.6.38.8823.gf4ad7d
>  Python support won't be built
>  rm -f {*.o,*/*.o,*/*/*.o,*/*/*/*.o,libperf.a,perf-archive}
>  rm -f perf perf-archive perf
>  rm -f *.spec *.pyc *.pyo */*.pyc */*.pyo common-cmds.h TAGS tags cscope*
>  make -C Documentation/ clean
>  make[1]: Entering directory `/usr/src/vanilla/git/linux-2.6/repo/tools/perf/Documentation'
>  Python support won't be built
>  make[2]: Entering directory `/usr/src/vanilla/git/linux-2.6/repo/tools/perf'
>  make[2]: `PERF-VERSION-FILE' is up to date.
>  make[2]: Leaving directory `/usr/src/vanilla/git/linux-2.6/repo/tools/perf'
>  rm -f *.xml *.xml+ *.html *.html+ *.1 *.5 *.7
>  rm -f *.texi *.texi+ *.texi++ perf.info perfman.info
>  rm -f howto-index.txt howto/*.html doc.dep
>  rm -f technical/api-*.html technical/api-index.txt
>  rm -f cmds-ancillaryinterrogators.txt cmds-ancillarymanipulators.txt cmds-mainporcelain.txt cmds-plumbinginterrogators.txt cmds-plumbingmanipulators.txt cmds-synchingrepositories.txt cmds-synchelpers.txt cmds-purehelpers.txt cmds-foreignscminterface.txt *.made
>  make[1]: Leaving directory `/usr/src/vanilla/git/linux-2.6/repo/tools/perf/Documentation'
>  rm -f PERF-VERSION-FILE PERF-CFLAGS
>  '/usr/bin/python' util/setup.py clean --build-lib='python' --build-temp='python/temp'
>  running clean
>
>You'll notice that the line:
>
>  Python support won't be built
>
>is repeated thrice. This is annoying, but I think it
>could be fixed by restructuring the Makefile to avoid
>unnecessary re-processing by GNU Make; as a boon, if
>such a restructuring is possible, then it would also
>improve the efficiency of running `make'.
>
>Thus, I wouldn't worry about it now.
>
>Sincerely,
>Michael Witten
>
>8<--------8<--------8<--------8<--------8<--------8<--------8<--------8<------
>Subject: [PATCH] perf tools: Makefile: PYTHON{,_CONFIG} to bandage python3 incompatibility
>Date: Thu, 31 Mar 2011 13:52:07 +0000
>Currently, python3 is not supported by perf's code; this
>can cause the build to fail for systems that have python3
>installed as the default python:
>
>  python{,-config}
>
>The Correct Solution is to write compatibility code so that
>python3 works out-of-the-box.
>
>However, users often have an ancillary python2 installed:
>
>  python2{,-config}
>
>Therefore, a quick fix is to allow the user to specify those
>ancillary paths as the python binaries that Makefile should
>use, thereby avoiding python3 altogether; as an added benefit,
>python may be installed in non-standard locations without
>the need for updating any PATH variable.
>
>This commit adds the ability to set PYTHON and/or PYTHON_CONFIG
>either as environment variables or as make variables on the
>command line; the paths may be relative, and usually only
>PYTHON is necessary in order for PYTHON_CONFIG to be defined
>implicitly. Some rudimentary error checking is performed when
>the user explicitly specifies a value for any of these variables.
>
>Thanks to:
>
>  Raghavendra D Prabhu <rprabhu@wnohang.net>
>
>for motivating this patch.
>
>See:
>
>  Message-ID: <e987828e-87ec-4973-95e7-47f10f5d9bab-mfwitten@gmail.com>
>
>Signed-off-by: Michael Witten <mfwitten@gmail.com>
>---
> tools/perf/Makefile          |   77 ++++++++++++++++++++++++++++++-----------
> tools/perf/feature-tests.mak |   46 +++++++++++++++++++++++++
> 2 files changed, 102 insertions(+), 21 deletions(-)
>
>diff --git a/tools/perf/Makefile b/tools/perf/Makefile
>index 158c30e..3ef8a28 100644
>--- a/tools/perf/Makefile
>+++ b/tools/perf/Makefile
>@@ -13,6 +13,12 @@ endif
>
> # Define V to have a more verbose compile.

>+# Define PYTHON to point to the python binary if the default
>+# `python' is not correct; for example: PYTHON=python2
>+#
>+# Define PYTHON_CONFIG to point to the python-config binary if
>+# the default `$(PYTHON)-config' is not correct.
>+#
> # Define ASCIIDOC8 if you want to format documentation with AsciiDoc 8

> # Define DOCBOOK_XSL_172 if you want to format man pages with DocBook XSL v1.72.
>@@ -165,8 +171,9 @@ grep-libs = $(filter -l%,$(1))
> strip-libs = $(filter-out -l%,$(1))
>
> $(OUTPUT)python/perf.so: $(PYRF_OBJS)
>-	$(QUIET_GEN)python util/setup.py --quiet  build_ext --build-lib='$(OUTPUT)python' \
>-						--build-temp='$(OUTPUT)python/temp'
>+	$(QUIET_GEN)'$(PYTHON)' util/setup.py --quiet  build_ext            \
>+	                                      --build-lib='$(OUTPUT)python' \
>+	                                      --build-temp='$(OUTPUT)python/temp'

> # No Perl scripts right now:

>@@ -471,24 +478,53 @@ else
> 	endif
> endif
>
>-ifdef NO_LIBPYTHON
>-	BASIC_CFLAGS += -DNO_LIBPYTHON
>-else
>-       PYTHON_EMBED_LDOPTS = $(shell python-config --ldflags 2>/dev/null)
>-       PYTHON_EMBED_LDFLAGS = $(call strip-libs,$(PYTHON_EMBED_LDOPTS))
>-       PYTHON_EMBED_LIBADD = $(call grep-libs,$(PYTHON_EMBED_LDOPTS))
>-	PYTHON_EMBED_CCOPTS = `python-config --cflags 2>/dev/null`
>-	FLAGS_PYTHON_EMBED=$(PYTHON_EMBED_CCOPTS) $(PYTHON_EMBED_LDOPTS)
>-	ifneq ($(call try-cc,$(SOURCE_PYTHON_EMBED),$(FLAGS_PYTHON_EMBED)),y)
>-		msg := $(warning No Python.h found, install python-dev[el] to have python support in 'perf script' and to build the python bindings)
>-		BASIC_CFLAGS += -DNO_LIBPYTHON
>-	else
>-               ALL_LDFLAGS += $(PYTHON_EMBED_LDFLAGS)
>-               EXTLIBS += $(PYTHON_EMBED_LIBADD)
>-		LIB_OBJS += $(OUTPUT)util/scripting-engines/trace-event-python.o
>-		LIB_OBJS += $(OUTPUT)scripts/python/Perf-Trace-Util/Context.o
>-		LANG_BINDINGS += $(OUTPUT)python/perf.so
>-	endif
>-endif
>+disable-python = $(eval $(call disable-python_code,$(1)))
>+define disable-python_code
>+  BASIC_CFLAGS += -DNO_LIBPYTHON
>+  $(if $(1),$(warning No $(1) was found))
>+  $(info Python support won't be built)
>+endef
>+
>+override PYTHON := \
>+  $(call get-executable-or-default,PYTHON,python)
>+
>+ifndef PYTHON
>+  $(call disable-python,python interpreter)
>+  python-clean=
>+else
>+
>+  python-clean = '$(PYTHON)' util/setup.py clean \
>+    --build-lib='$(OUTPUT)python'                \
>+    --build-temp='$(OUTPUT)python/temp'
>+
>+  ifdef NO_LIBPYTHON
>+    $(call disable-python)
>+  else
>+
>+    override PYTHON_CONFIG := \
>+      $(call get-executable-or-default,PYTHON_CONFIG,$(PYTHON)-config)
>+
>+    ifndef PYTHON_CONFIG
>+      $(call disable-python,python-config tool)
>+    else
>+
>+      PYTHON_EMBED_LDOPTS  = $(shell sh -c "'$(PYTHON_CONFIG)' --ldflags 2>/dev/null")
>+      PYTHON_EMBED_LDFLAGS = $(call strip-libs,$(PYTHON_EMBED_LDOPTS))
>+      PYTHON_EMBED_LIBADD  = $(call grep-libs,$(PYTHON_EMBED_LDOPTS))
>+      PYTHON_EMBED_CCOPTS  = $(shell sh -c "'$(PYTHON_CONFIG)' --cflags 2>/dev/null")
>+      FLAGS_PYTHON_EMBED   = $(PYTHON_EMBED_CCOPTS) $(PYTHON_EMBED_LDOPTS)
>+
>+      ifneq ($(call try-cc,$(SOURCE_PYTHON_EMBED),$(FLAGS_PYTHON_EMBED)),y)
>+        $(call disable-python,Python.h)
>+      else
>+        ALL_LDFLAGS += $(PYTHON_EMBED_LDFLAGS)
>+        EXTLIBS += $(PYTHON_EMBED_LIBADD)
>+        LIB_OBJS += $(OUTPUT)util/scripting-engines/trace-event-python.o
>+        LIB_OBJS += $(OUTPUT)scripts/python/Perf-Trace-Util/Context.o
>+        LANG_BINDINGS += $(OUTPUT)python/perf.so
>+      endif
>+    endif
>+  endif
>+endif
>
> ifdef NO_DEMANGLE
>@@ -829,8 +865,7 @@ clean:
> 	$(RM) *.spec *.pyc *.pyo */*.pyc */*.pyo $(OUTPUT)common-cmds.h TAGS tags cscope*
> 	$(MAKE) -C Documentation/ clean
> 	$(RM) $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)PERF-CFLAGS
>-	@python util/setup.py clean --build-lib='$(OUTPUT)python' \
>-				   --build-temp='$(OUTPUT)python/temp'
>+	$(python-clean)
>
> .PHONY: all install clean strip
> .PHONY: shell_compatibility_test please_set_SHELL_PATH_to_a_more_modern_shell
>diff --git a/tools/perf/feature-tests.mak b/tools/perf/feature-tests.mak
>index b041ca6..01e1fb1 100644
>--- a/tools/perf/feature-tests.mak
>+++ b/tools/perf/feature-tests.mak
>@@ -128,3 +128,49 @@ try-cc = $(shell sh -c						  \
> 	 echo "$(1)" |						  \
> 	 $(CC) -x c - $(2) -o "$$TMP" > /dev/null 2>&1 && echo y; \
> 	 rm -f "$$TMP"')
>+
>+# is-absolute
>+# Usage: bool-value = $(call is-absolute,path)
>+#
>+define is-absolute
>+$(shell sh -c "echo '$(1)' | grep ^/")
>+endef
>+
>+# lookup
>+# Usage: absolute-executable-path-or-empty = $(call lookup,path)
>+#
>+define lookup
>+$(shell sh -c "command -v '$(1)'")
>+endef
>+
>+# is-executable
>+# Usage: bool-value = $(call is-executable,path)
>+#
>+define is-executable
>+$(shell sh -c "test -f '$(1)' -a -x '$(1)' && echo y")
>+endef
>+
>+# get-executable
>+# Usage: absolute-executable-path-or-empty = $(call get-executable,path)
>+#
>+# The goal is to get an absolute path for an executable;
>+# the `command -v' is defined by POSIX, but it's not
>+# necessarily very portable, so it's only used if
>+# relative path resolution is requested, as determined
>+# by the presence of a leading `/'.
>+#
>+define get-executable
>+$(if $(1),$(if $(call is-absolute,$(1)),$(if $(call is-executable,$(1)),$(1)),$(call lookup,$(1))))
>+endef
>+
>+# get-supplied-or-default-executable
>+# Usage: absolute-executable-path-or-empty = $(call get-executable-or-default,variable,default)
>+#
>+define get-executable-or-default
>+$(if $($(1)),$(call _ge_attempt,$($(1)),$(1)),$(call _ge_attempt,$(2)))
>+endef
>+define _ge_attempt
>+$(or $(call get-executable,$(1)),$(call _gea_warn,$(1)),$(call _gea_err,$(2)))
>+endef
>+_gea_warn = $(warning The path '$(1)' is not executable.)
>+_gea_err  = $(if $(1),$(error Please set '$(1)' appropriately))

Apologies for the delay. I am getting a merge conflict with master now,
it may need to be rebased after the 1b7155f7de119870f0d3fad89f125de2ff6c16be commit.

--k1lZvvs/B4yU6o8G
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNn3tVAAoJEKYW3KHXK+l3K6IH/iC6l6/UYOo1HlRXV9xqHGbM
VNF/5+iJh9PQhhDHtq3SszNxgACUOlmusYLEJvPwUZdo1n14QNfRhoU2zSHoMr/H
/ZDE9JjuJXX0O+YGLaJ+f4AI7ZRN/zoCFBB3i10mCnp35PddnqZ9UU4H7/drVT9A
fL+9H3MWlmwUpQ012LvYYWirZITiLry2JntCXM6RFnTqtOSNTSpCPXx1H4OgKlBF
NI+V7jKA7uNPv7U6bclTay5hbqFWZlnLuPVFm3A1Z2CCooE0LekQ6DVFOuPEQw5l
TOEYwI42I3CfTTQqZEN1awhZAqo9NZgIzq7ILMwqaR4QiEz+E7qbYcO4XEt13rY=
=QtvS
-----END PGP SIGNATURE-----

--k1lZvvs/B4yU6o8G--
