Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab1A3Noo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 08:44:44 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56139 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504Ab1A3Non (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 08:44:43 -0500
Date: Sun, 30 Jan 2011 11:44:29 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Clark Williams <williams@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH 7/7] perf tools: Initial python binding
Message-ID: <20110130134429.GF13616@ghostprotocols.net>
References: <1296339559-20914-1-git-send-email-acme@infradead.org> <1296339559-20914-8-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296339559-20914-8-git-send-email-acme@infradead.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Jan 29, 2011 at 08:19:19PM -0200, Arnaldo Carvalho de Melo escreveu:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> First clarifying that this kind of binding is not a replacement or an
> equivalent to the 'perf script' way of using python with perf.
> 
> The 'perf script' way is to process events and look at a given script
> for some python function that matches the events to pass each event for
> processing.

Ooops, forgot to add this to this cset, fixed it up and force pushed it
there.

- Arnaldo

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index eedcf95..36ff73c 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -315,6 +315,7 @@ COMPAT_CFLAGS =
 COMPAT_OBJS =
 LIB_H =
 LIB_OBJS =
+PYRF_OBJS =
 SCRIPT_PERL =
 SCRIPT_SH =
 TEST_PROGRAMS =
@@ -324,6 +325,9 @@ SCRIPT_SH += perf-archive.sh
 grep-libs = $(filter -l%,$(1))
 strip-libs = $(filter-out -l%,$(1))
 
+pyrf: $(PYRF_OBJS)
+	python util/setup.py build --build-base='$(OUTPUT)'
+
 #
 # No Perl scripts right now:
 #
@@ -349,7 +353,7 @@ PROGRAMS += $(OUTPUT)perf
 #
 
 # what 'all' will build and 'install' will install, in perfexecdir
-ALL_PROGRAMS = $(PROGRAMS) $(SCRIPTS)
+ALL_PROGRAMS = $(PROGRAMS) $(SCRIPTS) pyrf
 
 # what 'all' will build but not install in perfexecdir
 OTHER_PROGRAMS = $(OUTPUT)perf$X
@@ -520,6 +524,20 @@ BUILTIN_OBJS += $(OUTPUT)builtin-inject.o
 
 PERFLIBS = $(LIB_FILE)
 
+# Files needed for the python binding, perf.so
+# pyrf is just an internal name needed for all those wrappers.
+# This has to be in sync with what is in the 'sources' variable in
+# tools/perf/util/setup.py
+
+PYRF_OBJS += $(OUTPUT)util/cpumap.o
+PYRF_OBJS += $(OUTPUT)util/ctype.o
+PYRF_OBJS += $(OUTPUT)util/evlist.o
+PYRF_OBJS += $(OUTPUT)util/evsel.o
+PYRF_OBJS += $(OUTPUT)util/python.o
+PYRF_OBJS += $(OUTPUT)util/thread_map.o
+PYRF_OBJS += $(OUTPUT)util/util.o
+PYRF_OBJS += $(OUTPUT)util/xyarray.o
+
 #
 # Platform specific tweaks
 #
