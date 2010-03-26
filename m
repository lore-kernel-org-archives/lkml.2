Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab0CZUij (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 16:38:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:47889 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117Ab0CZUif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 16:38:35 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 3/3] perf tools: Move the prototypes in util/string.h to util.h
Date: Fri, 26 Mar 2010 17:38:19 -0300
Message-Id: <1269635899-3221-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1269635899-3221-1-git-send-email-acme@infradead.org>
References: <1269635899-3221-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

So that we avoid conflict with libc's string.h header.

Suggested-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile            |    1 -
 tools/perf/bench/mem-memcpy.c  |    1 -
 tools/perf/builtin-annotate.c  |    1 -
 tools/perf/builtin-record.c    |    1 -
 tools/perf/builtin-report.c    |    1 -
 tools/perf/builtin-timechart.c |    1 -
 tools/perf/perf.c              |    1 -
 tools/perf/util/string.h       |   16 ----------------
 tools/perf/util/util.h         |   11 +++++++++++
 9 files changed, 11 insertions(+), 23 deletions(-)
 delete mode 100644 tools/perf/util/string.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 6903645..b474641 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -377,7 +377,6 @@ LIB_H += util/header.h
 LIB_H += util/help.h
 LIB_H += util/session.h
 LIB_H += util/strbuf.h
-LIB_H += util/string.h
 LIB_H += util/strlist.h
 LIB_H += util/svghelper.h
 LIB_H += util/run-command.h
diff --git a/tools/perf/bench/mem-memcpy.c b/tools/perf/bench/mem-memcpy.c
index 8977317..52e646e 100644
--- a/tools/perf/bench/mem-memcpy.c
+++ b/tools/perf/bench/mem-memcpy.c
@@ -10,7 +10,6 @@
 #include "../perf.h"
 #include "../util/util.h"
 #include "../util/parse-options.h"
-#include "../util/string.h"
 #include "../util/header.h"
 #include "bench.h"
 
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 887e8e0..ee0d917 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -14,7 +14,6 @@
 #include "util/cache.h"
 #include <linux/rbtree.h>
 #include "util/symbol.h"
-#include "util/string.h"
 
 #include "perf.h"
 #include "util/debug.h"
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 60ecdd3..99f6978 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -15,7 +15,6 @@
 #include "util/util.h"
 #include "util/parse-options.h"
 #include "util/parse-events.h"
-#include "util/string.h"
 
 #include "util/header.h"
 #include "util/event.h"
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 6ab1698..3ab6d9e 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -14,7 +14,6 @@
 #include "util/cache.h"
 #include <linux/rbtree.h>
 #include "util/symbol.h"
-#include "util/string.h"
 #include "util/callchain.h"
 #include "util/strlist.h"
 #include "util/values.h"
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 0d4d8ff..266e7aa 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -21,7 +21,6 @@
 #include "util/cache.h"
 #include <linux/rbtree.h>
 #include "util/symbol.h"
-#include "util/string.h"
 #include "util/callchain.h"
 #include "util/strlist.h"
 
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 2826e70..d4be55b 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -13,7 +13,6 @@
 #include "util/quote.h"
 #include "util/run-command.h"
 #include "util/parse-events.h"
-#include "util/string.h"
 #include "util/debugfs.h"
 
 bool use_browser;
diff --git a/tools/perf/util/string.h b/tools/perf/util/string.h
deleted file mode 100644
index 7005824..0000000
--- a/tools/perf/util/string.h
+++ /dev/null
@@ -1,16 +0,0 @@
-#ifndef __PERF_STRING_H_
-#define __PERF_STRING_H_
-
-#include <stdbool.h>
-#include "types.h"
-
-s64 perf_atoll(const char *str);
-char **argv_split(const char *str, int *argcp);
-void argv_free(char **argv);
-bool strglobmatch(const char *str, const char *pat);
-bool strlazymatch(const char *str, const char *pat);
-
-#define _STR(x) #x
-#define STR(x) _STR(x)
-
-#endif /* __PERF_STRING_H */
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 5270108..da450f0 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -48,6 +48,7 @@
 #include <sys/stat.h>
 #include <sys/statfs.h>
 #include <fcntl.h>
+#include <stdbool.h>
 #include <stddef.h>
 #include <stdlib.h>
 #include <stdarg.h>
@@ -78,6 +79,7 @@
 #include <pwd.h>
 #include <inttypes.h>
 #include "../../../include/linux/magic.h"
+#include "types.h"
 
 
 #ifndef NO_ICONV
@@ -415,4 +417,13 @@ void git_qsort(void *base, size_t nmemb, size_t size,
 int mkdir_p(char *path, mode_t mode);
 int copyfile(const char *from, const char *to);
 
+s64 perf_atoll(const char *str);
+char **argv_split(const char *str, int *argcp);
+void argv_free(char **argv);
+bool strglobmatch(const char *str, const char *pat);
+bool strlazymatch(const char *str, const char *pat);
+
+#define _STR(x) #x
+#define STR(x) _STR(x)
+
 #endif
-- 
1.6.2.5

