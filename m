Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760049Ab2J2QcH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 12:32:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52623 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760005Ab2J2QcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 12:32:01 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 1/9] perf python: add ui stubs file
Date: Mon, 29 Oct 2012 10:31:41 -0600
Message-Id: <1351528309-87705-2-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1351528309-87705-1-git-send-email-dsahern@gmail.com>
References: <1351528309-87705-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

stdio based implementations of ui_xxxx based functions for the python
library. Needed for patch 3 - consolidating open counters method.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 tools/perf/util/python-ext-sources |    1 +
 tools/perf/util/python_stubs.c     |   54 ++++++++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+)
 create mode 100644 tools/perf/util/python_stubs.c

diff --git a/tools/perf/util/python-ext-sources b/tools/perf/util/python-ext-sources
index c40c2d3..92d9e05 100644
--- a/tools/perf/util/python-ext-sources
+++ b/tools/perf/util/python-ext-sources
@@ -19,3 +19,4 @@ util/debugfs.c
 util/rblist.c
 util/strlist.c
 ../../lib/rbtree.c
+util/python_stubs.c
diff --git a/tools/perf/util/python_stubs.c b/tools/perf/util/python_stubs.c
new file mode 100644
index 0000000..7b31880
--- /dev/null
+++ b/tools/perf/util/python_stubs.c
@@ -0,0 +1,54 @@
+/*
+ * stubs for various ui-specific functions for the python library
+ */
+
+#include <stdio.h>
+#include "debug.h"
+
+#if !defined(NEWT_SUPPORT) && !defined(GTK2_SUPPORT)
+#undef ui__error
+#endif
+
+int verbose;
+
+int ui__warning(const char *format, ...)
+{
+	va_list args;
+
+	va_start(args, format);
+	vfprintf(stderr, format, args);
+	va_end(args);
+	return 0;
+}
+
+int ui__error(const char *format, ...)
+{
+	va_list args;
+
+	va_start(args, format);
+	vfprintf(stderr, format, args);
+	va_end(args);
+	return 0;
+}
+
+int ui__error_paranoid(void)
+{
+	return ui__error("Permission error - are you root?\n"
+			 "Consider tweaking /proc/sys/kernel/perf_event_paranoid:\n"
+			 " -1 - Not paranoid at all\n"
+			 "  0 - Disallow raw tracepoint access for unpriv\n"
+			 "  1 - Disallow cpu events for unpriv\n"
+			 "  2 - Disallow kernel profiling for unpriv\n");
+}
+
+int eprintf(int level, const char *fmt, ...)
+{
+	va_list args;
+	int ret = 0;
+
+	va_start(args, fmt);
+	ret = vfprintf(stderr, fmt, args);
+	va_end(args);
+
+	return ret;
+}
-- 
1.7.10.1

