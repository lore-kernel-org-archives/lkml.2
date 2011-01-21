Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab1AUPIM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 10:08:12 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:58522 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158Ab1AUPIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 10:08:09 -0500
From: Borislav Petkov <bp@amd64.org>
To: <peterz@infradead.org>, <mingo@elte.hu>
Cc: <tony.luck@intel.com>, <acme@infradead.org>, <rostedt@goodmis.org>,
        <fweisbec@gmail.com>, <linux-edac@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 09/12] perf: Export util.ch into library
Date: Fri, 21 Jan 2011 16:09:32 +0100
Message-Id: <1295622575-18607-10-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1295622575-18607-1-git-send-email-bp@amd64.org>
References: <1295622575-18607-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

This is needed for shared common functionality.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 tools/lib/lk/Makefile              |    1 +
 tools/{perf/util => lib/lk}/util.c |    0
 tools/lib/perf/Makefile            |    1 +
 tools/lib/perf/util.h              |    8 ++++++++
 tools/perf/Makefile                |    1 -
 tools/perf/perf.h                  |    3 ---
 tools/perf/util/cpumap.c           |    2 +-
 tools/perf/util/parse-events.h     |    1 +
 8 files changed, 12 insertions(+), 5 deletions(-)
 rename tools/{perf/util => lib/lk}/util.c (100%)
 create mode 100644 tools/lib/perf/util.h

diff --git a/tools/lib/lk/Makefile b/tools/lib/lk/Makefile
index 0d58c28..2e7e02c 100644
--- a/tools/lib/lk/Makefile
+++ b/tools/lib/lk/Makefile
@@ -10,6 +10,7 @@ LIB_H += types.h
 
 LIB_OBJS += debugfs.o
 LIB_OBJS += usage.o
+LIB_OBJS += util.o
 
 LIBFILE = $(LIB_OUTPUT)liblk.a
 
diff --git a/tools/perf/util/util.c b/tools/lib/lk/util.c
similarity index 100%
rename from tools/perf/util/util.c
rename to tools/lib/lk/util.c
diff --git a/tools/lib/perf/Makefile b/tools/lib/perf/Makefile
index 2ae7e8d..68def92 100644
--- a/tools/lib/perf/Makefile
+++ b/tools/lib/perf/Makefile
@@ -5,6 +5,7 @@ LIB_H=
 LIB_OBJS=
 
 LIB_H += mmap.h
+LIB_H += util.h
 
 LIB_OBJS += mmap.o
 
diff --git a/tools/lib/perf/util.h b/tools/lib/perf/util.h
new file mode 100644
index 0000000..4b774b9
--- /dev/null
+++ b/tools/lib/perf/util.h
@@ -0,0 +1,8 @@
+#ifndef __PERF_UTIL_H
+#define __PERF_UTIL_H
+
+#define MAX_COUNTERS			256
+#define MAX_NR_CPUS			256
+
+#endif /* __PERF_UTIL_H */
+
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index bab175d..2edc5d9 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -430,7 +430,6 @@ LIB_OBJS += $(OUTPUT)util/svghelper.o
 LIB_OBJS += $(OUTPUT)util/sort.o
 LIB_OBJS += $(OUTPUT)util/hist.o
 LIB_OBJS += $(OUTPUT)util/probe-event.o
-LIB_OBJS += $(OUTPUT)util/util.o
 LIB_OBJS += $(OUTPUT)util/xyarray.o
 LIB_OBJS += $(OUTPUT)util/cpumap.o
 
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 4bfd513..785a200 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -136,9 +136,6 @@ sys_perf_event_open(struct perf_event_attr *attr,
 		       group_fd, flags);
 }
 
-#define MAX_COUNTERS			256
-#define MAX_NR_CPUS			256
-
 struct ip_callchain {
 	u64 nr;
 	u64 ips[0];
diff --git a/tools/perf/util/cpumap.c b/tools/perf/util/cpumap.c
index 92a09cb..76f3de5 100644
--- a/tools/perf/util/cpumap.c
+++ b/tools/perf/util/cpumap.c
@@ -1,5 +1,5 @@
 #include <lk/util.h>
-#include "../perf.h"
+#include <perf/util.h>
 #include "cpumap.h"
 #include <assert.h>
 #include <stdio.h>
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index b82cafb..c29c407 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -3,6 +3,7 @@
 /*
  * Parse symbolic events/counts passed in as options:
  */
+#include <perf/util.h>
 
 #include "../../../include/linux/perf_event.h"
 
-- 
1.7.4.rc2

