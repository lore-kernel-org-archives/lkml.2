Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480Ab0KDPls (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 11:41:48 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:42005 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834Ab0KDPjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 11:39:36 -0400
From: Borislav Petkov <bp@amd64.org>
To: <acme@infradead.org>, <fweisbec@gmail.com>, <mingo@elte.hu>,
        <peterz@infradead.org>, <rostedt@goodmis.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 13/20] perf: Export compiler.h to the generic library
Date: Thu,  4 Nov 2010 16:36:49 +0100
Message-Id: <1288885016-18295-14-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1288885016-18295-1-git-send-email-bp@amd64.org>
References: <1288885016-18295-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Sucked in by other utils later.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 tools/lib/lk/Makefile                    |    1 +
 tools/lib/lk/compiler.h                  |   12 ++++++++++++
 tools/perf/Makefile                      |    1 -
 tools/perf/bench/bench.h                 |    2 +-
 tools/perf/util/cache.h                  |    2 +-
 tools/perf/util/include/linux/compiler.h |   12 ------------
 tools/perf/util/map.h                    |    2 +-
 7 files changed, 16 insertions(+), 16 deletions(-)
 create mode 100644 tools/lib/lk/compiler.h
 delete mode 100644 tools/perf/util/include/linux/compiler.h

diff --git a/tools/lib/lk/Makefile b/tools/lib/lk/Makefile
index f074216..d62e898 100644
--- a/tools/lib/lk/Makefile
+++ b/tools/lib/lk/Makefile
@@ -13,6 +13,7 @@ LIB_H += rbtree.h
 LIB_H += bitops.h
 LIB_H += bitmap.h
 LIB_H += kernel.h
+LIB_H += compiler.h
 
 LIB_OBJS += debugfs.o
 LIB_OBJS += usage.o
diff --git a/tools/lib/lk/compiler.h b/tools/lib/lk/compiler.h
new file mode 100644
index 0000000..8e8cc91
--- /dev/null
+++ b/tools/lib/lk/compiler.h
@@ -0,0 +1,12 @@
+#ifndef __LK_COMPILER_H
+#define __LK_COMPILER_H
+
+#ifndef __always_inline
+#define __always_inline	inline
+#endif
+#define __user
+#define __attribute_const__
+
+#define __used		__attribute__((__unused__))
+
+#endif /* __LK_COMPILER_H */
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 6a4a4f5..2e18b37 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -334,7 +334,6 @@ LIB_H += ../../include/linux/perf_event.h
 LIB_H += ../../include/linux/list.h
 LIB_H += ../../include/linux/hash.h
 LIB_H += ../../include/linux/stringify.h
-LIB_H += util/include/linux/compiler.h
 LIB_H += util/include/linux/ctype.h
 LIB_H += util/include/linux/list.h
 LIB_H += util/include/linux/module.h
diff --git a/tools/perf/bench/bench.h b/tools/perf/bench/bench.h
index 0c7ee07..565fce8 100644
--- a/tools/perf/bench/bench.h
+++ b/tools/perf/bench/bench.h
@@ -1,7 +1,7 @@
 #ifndef BENCH_H
 #define BENCH_H
 
-#include <linux/compiler.h>
+#include <lk/compiler.h>
 
 extern int bench_sched_messaging(int argc, const char **argv, const char *prefix);
 extern int bench_sched_pipe(int argc, const char **argv, const char *prefix);
diff --git a/tools/perf/util/cache.h b/tools/perf/util/cache.h
index ce83e82..720f2de 100644
--- a/tools/perf/util/cache.h
+++ b/tools/perf/util/cache.h
@@ -5,7 +5,7 @@
 #include <lk/util.h>
 #include "strbuf.h"
 #include "../perf.h"
-#include <linux/compiler.h>
+#include <lk/compiler.h>
 
 #define CMD_EXEC_PATH "--exec-path"
 #define CMD_PERF_DIR "--perf-dir="
diff --git a/tools/perf/util/include/linux/compiler.h b/tools/perf/util/include/linux/compiler.h
deleted file mode 100644
index 791f9dd..0000000
--- a/tools/perf/util/include/linux/compiler.h
+++ /dev/null
@@ -1,12 +0,0 @@
-#ifndef _PERF_LINUX_COMPILER_H_
-#define _PERF_LINUX_COMPILER_H_
-
-#ifndef __always_inline
-#define __always_inline	inline
-#endif
-#define __user
-#define __attribute_const__
-
-#define __used		__attribute__((__unused__))
-
-#endif
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index a00d888..efbff5b 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -1,7 +1,7 @@
 #ifndef __PERF_MAP_H
 #define __PERF_MAP_H
 
-#include <linux/compiler.h>
+#include <lk/compiler.h>
 #include <linux/list.h>
 #include <stdio.h>
 #include <stdbool.h>
-- 
1.7.3.1

