Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710Ab2JDSWn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 14:22:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:39697 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843Ab2JDSJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 14:09:02 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 24/42] perf record: Don't use globals where not needed to
Date: Thu,  4 Oct 2012 15:08:24 -0300
Message-Id: <1349374122-27806-25-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1349374122-27806-1-git-send-email-acme@infradead.org>
References: <1349374122-27806-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Some variables were global but used in just one function, so move it to
where it belongs.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-2ce3v9qheiobs3sz6pxf4tud@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 8c029fe..e923165 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -31,15 +31,6 @@
 #include <sched.h>
 #include <sys/mman.h>
 
-#define CALLCHAIN_HELP "do call-graph (stack chain/backtrace) recording: "
-
-#ifdef LIBUNWIND_SUPPORT
-static unsigned long default_stack_dump_size = 8192;
-static char callchain_help[] = CALLCHAIN_HELP "[fp] dwarf";
-#else
-static char callchain_help[] = CALLCHAIN_HELP "[fp]";
-#endif
-
 enum write_mode_t {
 	WRITE_FORCE,
 	WRITE_APPEND
@@ -868,6 +859,8 @@ parse_callchain_opt(const struct option *opt __maybe_unused, const char *arg,
 #ifdef LIBUNWIND_SUPPORT
 		/* Dwarf style */
 		} else if (!strncmp(name, "dwarf", sizeof("dwarf"))) {
+			const unsigned long default_stack_dump_size = 8192;
+
 			ret = 0;
 			rec->opts.call_graph = CALLCHAIN_DWARF;
 			rec->opts.stack_dump_size = default_stack_dump_size;
@@ -930,6 +923,14 @@ static struct perf_record record = {
 	.file_new   = true,
 };
 
+#define CALLCHAIN_HELP "do call-graph (stack chain/backtrace) recording: "
+
+#ifdef LIBUNWIND_SUPPORT
+static const char callchain_help[] = CALLCHAIN_HELP "[fp] dwarf";
+#else
+static const char callchain_help[] = CALLCHAIN_HELP "[fp]";
+#endif
+
 /*
  * XXX Will stay a global variable till we fix builtin-script.c to stop messing
  * with it and switch to use the library functions in perf_evlist that came
-- 
1.7.1

