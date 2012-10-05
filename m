Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab2JEIvI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:51:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32778 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754313Ab2JEIvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:51:05 -0400
Date: Fri, 5 Oct 2012 01:50:46 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-2ce3v9qheiobs3sz6pxf4tud@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf record: Don'
 t use globals where not needed to
Git-Commit-ID: 61eaa3be152afcbfb862a10f81341f96371c3ce3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 05 Oct 2012 01:50:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  61eaa3be152afcbfb862a10f81341f96371c3ce3
Gitweb:     http://git.kernel.org/tip/61eaa3be152afcbfb862a10f81341f96371c3ce3
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 1 Oct 2012 15:20:58 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 2 Oct 2012 18:36:40 -0300

perf record: Don't use globals where not needed to

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
index 8c029fe..e9231659 100644
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
