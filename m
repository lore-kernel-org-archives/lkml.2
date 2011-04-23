Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167Ab1DWQbq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 12:31:46 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:35132 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757256Ab1DWQ34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 12:29:56 -0400
From: Borislav Petkov <bp@amd64.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 11/18] perf: Export cpumap.[ch]
Date: Sat, 23 Apr 2011 18:28:13 +0200
Message-Id: <1303576100-425-12-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1303576100-425-1-git-send-email-bp@amd64.org>
References: <1303576100-425-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Put it into the generic part of the lib since it is tool-agnostic.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 tools/lib/lk/Makefile                |    3 +++
 tools/{perf/util => lib/lk}/cpumap.c |    2 +-
 tools/{perf/util => lib/lk}/cpumap.h |    6 +++---
 tools/perf/Makefile                  |    4 ----
 tools/perf/builtin-record.c          |    2 +-
 tools/perf/builtin-stat.c            |    2 +-
 tools/perf/builtin-test.c            |    2 +-
 tools/perf/builtin-top.c             |    2 +-
 tools/perf/util/evlist.c             |    2 +-
 tools/perf/util/evsel.c              |    2 +-
 tools/perf/util/python.c             |    2 +-
 tools/perf/util/setup.py             |    4 ++--
 tools/perf/util/top.c                |    2 +-
 13 files changed, 17 insertions(+), 18 deletions(-)
 rename tools/{perf/util => lib/lk}/cpumap.c (99%)
 rename tools/{perf/util => lib/lk}/cpumap.h (70%)

diff --git a/tools/lib/lk/Makefile b/tools/lib/lk/Makefile
index b192853..49f7a64 100644
--- a/tools/lib/lk/Makefile
+++ b/tools/lib/lk/Makefile
@@ -7,12 +7,15 @@ LIB_OBJS=
 LIB_H += debugfs.h
 LIB_H += util.h
 LIB_H += types.h
+LIB_H += cpumap.h
 
 LIB_OBJS += debugfs.o
 LIB_OBJS += usage.o
 LIB_OBJS += util.o
+LIB_OBJS += cpumap.o
 
 PYRF_OBJS += util.o
+PYRF_OBJS += cpumap.o
 
 LIBFILE = $(LIB_OUTPUT)liblk.a
 
diff --git a/tools/perf/util/cpumap.c b/tools/lib/lk/cpumap.c
similarity index 99%
rename from tools/perf/util/cpumap.c
rename to tools/lib/lk/cpumap.c
index 02755d5..85a5d38 100644
--- a/tools/perf/util/cpumap.c
+++ b/tools/lib/lk/cpumap.c
@@ -1,5 +1,5 @@
 #include <lk/util.h>
-#include "../perf.h"
+#include "../../perf/perf.h"
 #include "cpumap.h"
 #include <assert.h>
 #include <stdio.h>
diff --git a/tools/perf/util/cpumap.h b/tools/lib/lk/cpumap.h
similarity index 70%
rename from tools/perf/util/cpumap.h
rename to tools/lib/lk/cpumap.h
index 072c0a3..9558051 100644
--- a/tools/perf/util/cpumap.h
+++ b/tools/lib/lk/cpumap.h
@@ -1,5 +1,5 @@
-#ifndef __PERF_CPUMAP_H
-#define __PERF_CPUMAP_H
+#ifndef __LK_CPUMAP_H
+#define __LK_CPUMAP_H
 
 struct cpu_map {
 	int nr;
@@ -10,4 +10,4 @@ struct cpu_map *cpu_map__new(const char *cpu_list);
 struct cpu_map *cpu_map__dummy_new(void);
 void cpu_map__delete(struct cpu_map *map);
 
-#endif /* __PERF_CPUMAP_H */
+#endif /* __LK_CPUMAP_H */
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 692b1ad..44688ce 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -131,7 +131,6 @@ BASIC_LDFLAGS =
 BUILTIN_OBJS =
 LIB_H =
 LIB_OBJS =
-PYRF_OBJS =
 SCRIPT_SH =
 EXTRA_LIBS =
 
@@ -241,7 +240,6 @@ LIB_H += util/thread_map.h
 LIB_H += util/probe-finder.h
 LIB_H += util/probe-event.h
 LIB_H += util/pstack.h
-LIB_H += util/cpumap.h
 LIB_H += util/top.h
 LIB_H += $(ARCH_INCLUDE)
 LIB_H += util/cgroup.h
@@ -292,7 +290,6 @@ LIB_OBJS += $(OUTPUT)util/sort.o
 LIB_OBJS += $(OUTPUT)util/hist.o
 LIB_OBJS += $(OUTPUT)util/probe-event.o
 LIB_OBJS += $(OUTPUT)util/xyarray.o
-LIB_OBJS += $(OUTPUT)util/cpumap.o
 LIB_OBJS += $(OUTPUT)util/cgroup.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
@@ -334,7 +331,6 @@ PERFLIBS = $(LIB_FILE) $(EXTRA_LIBS)
 # This has to be in sync with what is in the 'sources' variable in
 # tools/perf/util/setup.py
 
-PYRF_OBJS += $(OUTPUT)util/cpumap.o
 PYRF_OBJS += $(OUTPUT)util/ctype.o
 PYRF_OBJS += $(OUTPUT)util/evlist.o
 PYRF_OBJS += $(OUTPUT)util/evsel.o
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 9ebfc4d..2f0bf69 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -23,7 +23,7 @@
 #include "util/debug.h"
 #include "util/session.h"
 #include "util/symbol.h"
-#include "util/cpumap.h"
+#include <lk/cpumap.h>
 #include "util/thread_map.h"
 
 #include <unistd.h>
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 8a9b057..9e0ae80 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -47,7 +47,7 @@
 #include "util/evsel.h"
 #include "util/debug.h"
 #include "util/header.h"
-#include "util/cpumap.h"
+#include <lk/cpumap.h>
 #include "util/thread.h"
 #include "util/thread_map.h"
 
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 11e3c84..2674fd6 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -235,7 +235,7 @@ out:
 	return err;
 }
 
-#include "util/cpumap.h"
+#include <lk/cpumap.h>
 #include "util/evsel.h"
 #include <sys/types.h>
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 22f4528..1c5626d 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -34,7 +34,7 @@
 #include <linux/rbtree.h>
 #include "util/parse-options.h"
 #include "util/parse-events.h"
-#include "util/cpumap.h"
+#include <lk/cpumap.h>
 #include "util/xyarray.h"
 
 #include "util/debug.h"
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 7a270ed..ed16c89 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -7,7 +7,7 @@
  * Released under the GPL v2. (and only v2, not any later version)
  */
 #include <poll.h>
-#include "cpumap.h"
+#include <lk/cpumap.h>
 #include "thread_map.h"
 #include "evlist.h"
 #include "evsel.h"
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index e76773c..6dca3e6 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -10,7 +10,7 @@
 #include "evsel.h"
 #include "evlist.h"
 #include <lk/util.h>
-#include "cpumap.h"
+#include <lk/cpumap.h>
 #include "thread_map.h"
 
 void perf_evsel__init(struct perf_evsel *evsel,
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index f5e3845..14d2006 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -5,7 +5,7 @@
 #include "evlist.h"
 #include "evsel.h"
 #include "event.h"
-#include "cpumap.h"
+#include <lk/cpumap.h>
 #include "thread_map.h"
 
 /* Define PyVarObject_HEAD_INIT for python 2.5 */
diff --git a/tools/perf/util/setup.py b/tools/perf/util/setup.py
index 78a9b98..9e25da0 100644
--- a/tools/perf/util/setup.py
+++ b/tools/perf/util/setup.py
@@ -8,9 +8,9 @@ cflags += getenv('CFLAGS', '').split()
 
 perf = Extension('perf',
 		  sources = ['util/python.c', 'util/ctype.c', 'util/evlist.c',
-			     'util/evsel.c', 'util/cpumap.c', 'util/thread_map.c',
+			     'util/evsel.c', '../lib/lk/cpumap.c', 'util/thread_map.c',
 			     '../lib/lk/util.c', 'util/xyarray.c', 'util/cgroup.c'],
-		  include_dirs = ['util/include'],
+		  include_dirs = ['util/include', '../lib'],
 		  extra_compile_args = cflags,
                  )
 
diff --git a/tools/perf/util/top.c b/tools/perf/util/top.c
index a11f607..0b027aa 100644
--- a/tools/perf/util/top.c
+++ b/tools/perf/util/top.c
@@ -6,7 +6,7 @@
  * Released under the GPL v2. (and only v2, not any later version)
  */
 
-#include "cpumap.h"
+#include <lk/cpumap.h>
 #include "event.h"
 #include "evlist.h"
 #include "evsel.h"
-- 
1.7.4.rc2

