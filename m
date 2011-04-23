Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302Ab1DWQaK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 12:30:10 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:40187 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757249Ab1DWQaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 12:30:05 -0400
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
Subject: [PATCH 12/18] perf: Export thread_map.[ch]
Date: Sat, 23 Apr 2011 18:28:14 +0200
Message-Id: <1303576100-425-13-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1303576100-425-1-git-send-email-bp@amd64.org>
References: <1303576100-425-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Export into generic code since tool-agnostic and reusable.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 tools/lib/lk/Makefile                    |    3 +++
 tools/{perf/util => lib/lk}/thread_map.c |    0
 tools/{perf/util => lib/lk}/thread_map.h |    6 +++---
 tools/perf/Makefile                      |    3 ---
 tools/perf/builtin-record.c              |    2 +-
 tools/perf/builtin-stat.c                |    2 +-
 tools/perf/builtin-test.c                |    2 +-
 tools/perf/builtin-top.c                 |    2 +-
 tools/perf/util/event.c                  |    2 +-
 tools/perf/util/evlist.c                 |    2 +-
 tools/perf/util/evsel.c                  |    2 +-
 tools/perf/util/python.c                 |    2 +-
 tools/perf/util/setup.py                 |    2 +-
 13 files changed, 15 insertions(+), 15 deletions(-)
 rename tools/{perf/util => lib/lk}/thread_map.c (100%)
 rename tools/{perf/util => lib/lk}/thread_map.h (76%)

diff --git a/tools/lib/lk/Makefile b/tools/lib/lk/Makefile
index 49f7a64..e3c5282 100644
--- a/tools/lib/lk/Makefile
+++ b/tools/lib/lk/Makefile
@@ -8,14 +8,17 @@ LIB_H += debugfs.h
 LIB_H += util.h
 LIB_H += types.h
 LIB_H += cpumap.h
+LIB_H += thread_map.h
 
 LIB_OBJS += debugfs.o
 LIB_OBJS += usage.o
 LIB_OBJS += util.o
 LIB_OBJS += cpumap.o
+LIB_OBJS += thread_map.o
 
 PYRF_OBJS += util.o
 PYRF_OBJS += cpumap.o
+PYRF_OBJS += thread_map.o
 
 LIBFILE = $(LIB_OUTPUT)liblk.a
 
diff --git a/tools/perf/util/thread_map.c b/tools/lib/lk/thread_map.c
similarity index 100%
rename from tools/perf/util/thread_map.c
rename to tools/lib/lk/thread_map.c
diff --git a/tools/perf/util/thread_map.h b/tools/lib/lk/thread_map.h
similarity index 76%
rename from tools/perf/util/thread_map.h
rename to tools/lib/lk/thread_map.h
index 3cb9073..9c88019 100644
--- a/tools/perf/util/thread_map.h
+++ b/tools/lib/lk/thread_map.h
@@ -1,5 +1,5 @@
-#ifndef __PERF_THREAD_MAP_H
-#define __PERF_THREAD_MAP_H
+#ifndef __LK_THREAD_MAP_H
+#define __LK_THREAD_MAP_H
 
 #include <sys/types.h>
 
@@ -12,4 +12,4 @@ struct thread_map *thread_map__new_by_pid(pid_t pid);
 struct thread_map *thread_map__new_by_tid(pid_t tid);
 struct thread_map *thread_map__new(pid_t pid, pid_t tid);
 void thread_map__delete(struct thread_map *threads);
-#endif	/* __PERF_THREAD_MAP_H */
+#endif	/* __LK_THREAD_MAP_H */
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 44688ce..05c4eef 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -236,7 +236,6 @@ LIB_H += util/values.h
 LIB_H += util/sort.h
 LIB_H += util/hist.h
 LIB_H += util/thread.h
-LIB_H += util/thread_map.h
 LIB_H += util/probe-finder.h
 LIB_H += util/probe-event.h
 LIB_H += util/pstack.h
@@ -283,7 +282,6 @@ LIB_OBJS += $(OUTPUT)util/map.o
 LIB_OBJS += $(OUTPUT)util/pstack.o
 LIB_OBJS += $(OUTPUT)util/session.o
 LIB_OBJS += $(OUTPUT)util/thread.o
-LIB_OBJS += $(OUTPUT)util/thread_map.o
 LIB_OBJS += $(OUTPUT)util/trace-event-scripting.o
 LIB_OBJS += $(OUTPUT)util/svghelper.o
 LIB_OBJS += $(OUTPUT)util/sort.o
@@ -335,7 +333,6 @@ PYRF_OBJS += $(OUTPUT)util/ctype.o
 PYRF_OBJS += $(OUTPUT)util/evlist.o
 PYRF_OBJS += $(OUTPUT)util/evsel.o
 PYRF_OBJS += $(OUTPUT)util/python.o
-PYRF_OBJS += $(OUTPUT)util/thread_map.o
 PYRF_OBJS += $(OUTPUT)util/xyarray.o
 
 #
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 2f0bf69..7011ef3 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -24,7 +24,7 @@
 #include "util/session.h"
 #include "util/symbol.h"
 #include <lk/cpumap.h>
-#include "util/thread_map.h"
+#include <lk/thread_map.h>
 
 #include <unistd.h>
 #include <sched.h>
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 9e0ae80..e2d57dd 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -49,7 +49,7 @@
 #include "util/header.h"
 #include <lk/cpumap.h>
 #include "util/thread.h"
-#include "util/thread_map.h"
+#include <lk/thread_map.h>
 
 #include <sys/prctl.h>
 #include <math.h>
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 2674fd6..e471fe9 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -11,7 +11,7 @@
 #include "util/parse-options.h"
 #include "util/parse-events.h"
 #include "util/symbol.h"
-#include "util/thread_map.h"
+#include <lk/thread_map.h>
 
 static long page_size;
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 1c5626d..2cd2e8c 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -28,7 +28,7 @@
 #include "util/session.h"
 #include "util/symbol.h"
 #include "util/thread.h"
-#include "util/thread_map.h"
+#include <lk/thread_map.h>
 #include "util/top.h"
 #include <lk/util.h>
 #include <linux/rbtree.h>
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 1023f67..922f9c6 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -6,7 +6,7 @@
 #include "string.h"
 #include "strlist.h"
 #include "thread.h"
-#include "thread_map.h"
+#include <lk/thread_map.h>
 
 static const char *perf_event__names[] = {
 	[0]			 = "TOTAL",
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index ed16c89..1f35fec 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -8,7 +8,7 @@
  */
 #include <poll.h>
 #include <lk/cpumap.h>
-#include "thread_map.h"
+#include <lk/thread_map.h>
 #include "evlist.h"
 #include "evsel.h"
 #include "debug.h"
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 6dca3e6..3a63422 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -11,7 +11,7 @@
 #include "evlist.h"
 #include <lk/util.h>
 #include <lk/cpumap.h>
-#include "thread_map.h"
+#include <lk/thread_map.h>
 
 void perf_evsel__init(struct perf_evsel *evsel,
 		      struct perf_event_attr *attr, int idx)
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index 14d2006..756f50c 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -6,7 +6,7 @@
 #include "evsel.h"
 #include "event.h"
 #include <lk/cpumap.h>
-#include "thread_map.h"
+#include <lk/thread_map.h>
 
 /* Define PyVarObject_HEAD_INIT for python 2.5 */
 #ifndef PyVarObject_HEAD_INIT
diff --git a/tools/perf/util/setup.py b/tools/perf/util/setup.py
index 9e25da0..32d8049 100644
--- a/tools/perf/util/setup.py
+++ b/tools/perf/util/setup.py
@@ -8,7 +8,7 @@ cflags += getenv('CFLAGS', '').split()
 
 perf = Extension('perf',
 		  sources = ['util/python.c', 'util/ctype.c', 'util/evlist.c',
-			     'util/evsel.c', '../lib/lk/cpumap.c', 'util/thread_map.c',
+			     'util/evsel.c', '../lib/lk/cpumap.c', '../lib/lk/thread_map.c',
 			     '../lib/lk/util.c', 'util/xyarray.c', 'util/cgroup.c'],
 		  include_dirs = ['util/include', '../lib'],
 		  extra_compile_args = cflags,
-- 
1.7.4.rc2

