Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933893Ab1JZRvK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 13:51:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:54964 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933731Ab1JZRso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 13:48:44 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 07/11] perf ui: Rename ui__warning_paranoid to ui__error_paranoid
Date: Wed, 26 Oct 2011 15:48:30 -0200
Message-Id: <1319651314-29404-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1319651314-29404-1-git-send-email-acme@infradead.org>
References: <1319651314-29404-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

As it will exit the tool after the user is notified.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-vy06m8xzlvkhr8tk7nylhbng@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |    2 +-
 tools/perf/builtin-top.c    |    2 +-
 tools/perf/util/debug.c     |    4 ++--
 tools/perf/util/debug.h     |    6 ++++--
 4 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 40088a5..6ab58cc 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -298,7 +298,7 @@ try_again:
 			int err = errno;
 
 			if (err == EPERM || err == EACCES) {
-				ui__warning_paranoid();
+				ui__error_paranoid();
 				exit(EXIT_FAILURE);
 			} else if (err ==  ENODEV && cpu_list) {
 				die("No such device - did you specify"
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index d2fc754..31aa82c 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -871,7 +871,7 @@ try_again:
 			int err = errno;
 
 			if (err == EPERM || err == EACCES) {
-				ui__warning_paranoid();
+				ui__error_paranoid();
 				goto out_err;
 			}
 			/*
diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index 155749d..5563403 100644
--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -57,9 +57,9 @@ void ui__warning(const char *format, ...)
 }
 #endif
 
-void ui__warning_paranoid(void)
+void ui__error_paranoid(void)
 {
-	ui__warning("Permission error - are you root?\n"
+	ui__error("Permission error - are you root?\n"
 		    "Consider tweaking /proc/sys/kernel/perf_event_paranoid:\n"
 		    " -1 - Not paranoid at all\n"
 		    "  0 - Disallow raw tracepoint access for unpriv\n"
diff --git a/tools/perf/util/debug.h b/tools/perf/util/debug.h
index 9c59b95..16cc752 100644
--- a/tools/perf/util/debug.h
+++ b/tools/perf/util/debug.h
@@ -21,14 +21,16 @@ static inline int ui_helpline__show_help(const char *format __used, va_list ap _
 
 static inline void ui_progress__update(u64 curr __used, u64 total __used,
 				       const char *title __used) {}
+
+#define ui__error(format, arg...) ui__warning(format, ##arg)
 #else
 extern char ui_helpline__last_msg[];
 int ui_helpline__show_help(const char *format, va_list ap);
 #include "ui/progress.h"
+void ui__error(const char *format, ...) __attribute__((format(printf, 1, 2)));
 #endif
 
 void ui__warning(const char *format, ...) __attribute__((format(printf, 1, 2)));
-void ui__warning_paranoid(void);
-void ui__error(const char *format, ...) __attribute__((format(printf, 1, 2)));
+void ui__error_paranoid(void);
 
 #endif	/* __PERF_DEBUG_H */
-- 
1.6.2.5

