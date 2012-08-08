Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757573Ab2HHDVz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 23:21:55 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37489 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757221Ab2HHDVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 23:21:12 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/8] perf tools: Add dump_stack function
Date: Wed,  8 Aug 2012 00:20:51 -0300
Message-Id: <1344396057-10540-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1344396057-10540-1-git-send-email-acme@infradead.org>
References: <1344396057-10540-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

To help in debugging the tools, provides functionality roughly similar
to the function with the same name in the kernel.

Copied from glibc backtrace function man page.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-6nw2sak21bqy8h1m2syyo816@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/util.c |   19 +++++++++++++++++++
 tools/perf/util/util.h |    2 ++
 2 files changed, 21 insertions(+)

diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index d03599f..1b8775c 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -1,6 +1,9 @@
 #include "../perf.h"
 #include "util.h"
 #include <sys/mman.h>
+#include <execinfo.h>
+#include <stdio.h>
+#include <stdlib.h>
 
 /*
  * XXX We need to find a better place for these things...
@@ -158,3 +161,19 @@ size_t hex_width(u64 v)
 
 	return n;
 }
+
+/* Obtain a backtrace and print it to stdout. */
+void dump_stack(void)
+{
+	void *array[16];
+	size_t size = backtrace(array, ARRAY_SIZE(array));
+	char **strings = backtrace_symbols(array, size);
+	size_t i;
+
+	printf("Obtained %zd stack frames.\n", size);
+
+	for (i = 0; i < size; i++)
+		printf("%s\n", strings[i]);
+
+	free(strings);
+}
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index b13c733..00a93a9 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -266,4 +266,6 @@ size_t hex_width(u64 v);
 
 char *rtrim(char *s);
 
+void dump_stack(void);
+
 #endif
-- 
1.7.9.2.358.g22243

