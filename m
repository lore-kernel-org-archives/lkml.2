Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab2HUPTW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:19:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59594 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754980Ab2HUPTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:19:16 -0400
Date: Tue, 21 Aug 2012 08:18:56 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-6nw2sak21bqy8h1m2syyo816@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add dump_stack function
Git-Commit-ID: dc4552bf7176573ccf79af04ab8648b015738f4a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 08:19:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dc4552bf7176573ccf79af04ab8648b015738f4a
Gitweb:     http://git.kernel.org/tip/dc4552bf7176573ccf79af04ab8648b015738f4a
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 7 Aug 2012 23:32:05 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 7 Aug 2012 23:32:05 -0300

perf tools: Add dump_stack function

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
 2 files changed, 21 insertions(+), 0 deletions(-)

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
