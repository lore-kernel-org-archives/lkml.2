Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148Ab1DWQbd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 12:31:33 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:40197 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755927Ab1DWQaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 12:30:08 -0400
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
Subject: [PATCH 14/18] perf: Export cgroup.[ch]
Date: Sat, 23 Apr 2011 18:28:16 +0200
Message-Id: <1303576100-425-15-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1303576100-425-1-git-send-email-bp@amd64.org>
References: <1303576100-425-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

This is pulled in by the previous evsel.[ch] export.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 tools/lib/perf/Makefile                |    2 ++
 tools/{perf/util => lib/perf}/cgroup.c |    6 +++---
 tools/{perf/util => lib/perf}/cgroup.h |    6 +++---
 tools/lib/perf/evsel.h                 |    2 +-
 tools/perf/Makefile                    |    2 --
 5 files changed, 9 insertions(+), 9 deletions(-)
 rename tools/{perf/util => lib/perf}/cgroup.c (96%)
 rename tools/{perf/util => lib/perf}/cgroup.h (76%)

diff --git a/tools/lib/perf/Makefile b/tools/lib/perf/Makefile
index 8b7b288..e43008d 100644
--- a/tools/lib/perf/Makefile
+++ b/tools/lib/perf/Makefile
@@ -5,8 +5,10 @@ LIB_H=
 LIB_OBJS=
 
 LIB_H += evsel.h
+LIB_H += cgroup.h
 
 LIB_OBJS += evsel.o
+LIB_OBJS += cgroup.o
 
 PYRF_OBJS += evsel.o
 
diff --git a/tools/perf/util/cgroup.c b/tools/lib/perf/cgroup.c
similarity index 96%
rename from tools/perf/util/cgroup.c
rename to tools/lib/perf/cgroup.c
index eae7d6b..5c9c554 100644
--- a/tools/perf/util/cgroup.c
+++ b/tools/lib/perf/cgroup.c
@@ -1,10 +1,10 @@
 #include <lk/util.h>
-#include "../perf.h"
-#include "parse-options.h"
+#include "../../perf/perf.h"
+#include "../../perf/util/parse-options.h"
 #include <perf/evsel.h>
 #include "cgroup.h"
 #include <lk/debugfs.h> /* MAX_PATH, STR() */
-#include "evlist.h"
+#include "../../perf/util/evlist.h"
 
 int nr_cgroups;
 
diff --git a/tools/perf/util/cgroup.h b/tools/lib/perf/cgroup.h
similarity index 76%
rename from tools/perf/util/cgroup.h
rename to tools/lib/perf/cgroup.h
index 89acd6d..a17f2b5 100644
--- a/tools/perf/util/cgroup.h
+++ b/tools/lib/perf/cgroup.h
@@ -1,5 +1,5 @@
-#ifndef __CGROUP_H__
-#define __CGROUP_H__
+#ifndef __PERF_CGROUP_H__
+#define __PERF_CGROUP_H__
 
 struct option;
 
@@ -14,4 +14,4 @@ extern int nr_cgroups; /* number of explicit cgroups defined */
 extern void close_cgroup(struct cgroup_sel *cgrp);
 extern int parse_cgroups(const struct option *opt, const char *str, int unset);
 
-#endif /* __CGROUP_H__ */
+#endif /* __PERF_CGROUP_H__ */
diff --git a/tools/lib/perf/evsel.h b/tools/lib/perf/evsel.h
index 48e5906..ec5f121 100644
--- a/tools/lib/perf/evsel.h
+++ b/tools/lib/perf/evsel.h
@@ -6,7 +6,7 @@
 #include "../../../include/linux/perf_event.h"
 #include <lk/types.h>
 #include <lk/xyarray.h>
-#include "../../perf/util/cgroup.h"
+#include "cgroup.h"
 #include "../../perf/util/hist.h"
 
 struct perf_counts_values {
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index af2bd00..d134897 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -239,7 +239,6 @@ LIB_H += util/probe-event.h
 LIB_H += util/pstack.h
 LIB_H += util/top.h
 LIB_H += $(ARCH_INCLUDE)
-LIB_H += util/cgroup.h
 
 LIB_OBJS += $(OUTPUT)util/abspath.o
 LIB_OBJS += $(OUTPUT)util/alias.o
@@ -284,7 +283,6 @@ LIB_OBJS += $(OUTPUT)util/svghelper.o
 LIB_OBJS += $(OUTPUT)util/sort.o
 LIB_OBJS += $(OUTPUT)util/hist.o
 LIB_OBJS += $(OUTPUT)util/probe-event.o
-LIB_OBJS += $(OUTPUT)util/cgroup.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 
-- 
1.7.4.rc2

