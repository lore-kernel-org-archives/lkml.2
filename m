Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759472Ab2EKGfA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 02:35:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57131 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278Ab2EKGe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 02:34:58 -0400
Date: Thu, 10 May 2012 23:34:40 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-7706f966323f32f3ea13121b5918851432876ae5@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, penberg@kernel.org, namhyung.kim@lge.com,
        namhyung@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        penberg@kernel.org, namhyung.kim@lge.com, tglx@linutronix.de,
        namhyung@gmail.com
In-Reply-To: <1335761711-31403-3-git-send-email-namhyung.kim@lge.com>
References: <1335761711-31403-3-git-send-email-namhyung.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf ui gtk: Drop arg[cv]
  arguments from perf_gtk_setup_browser()
Git-Commit-ID: 7706f966323f32f3ea13121b5918851432876ae5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 10 May 2012 23:34:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7706f966323f32f3ea13121b5918851432876ae5
Gitweb:     http://git.kernel.org/tip/7706f966323f32f3ea13121b5918851432876ae5
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Mon, 30 Apr 2012 13:55:06 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 2 May 2012 16:17:25 -0300

perf ui gtk: Drop arg[cv] arguments from perf_gtk_setup_browser()

As perf doesn't allow to specify gtk command-line option, drop the
arguments and pass NULL to gtk_init().

This makes the function easier to be called from setup_browser().

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1335761711-31403-3-git-send-email-namhyung.kim@lge.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c |    2 +-
 tools/perf/ui/gtk/browser.c |    5 ++---
 tools/perf/util/cache.h     |    4 ++--
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index cec2b8c..2b20001 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -678,7 +678,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 
 	if (strcmp(report.input_name, "-") != 0) {
 		if (report.use_gtk)
-			perf_gtk_setup_browser(argc, argv, true);
+			perf_gtk_setup_browser(true);
 		else
 			setup_browser(true);
 	} else {
diff --git a/tools/perf/ui/gtk/browser.c b/tools/perf/ui/gtk/browser.c
index 258352a..a1a83de 100644
--- a/tools/perf/ui/gtk/browser.c
+++ b/tools/perf/ui/gtk/browser.c
@@ -9,10 +9,9 @@
 
 #define MAX_COLUMNS			32
 
-void perf_gtk_setup_browser(int argc, const char *argv[],
-			    bool fallback_to_pager __used)
+void perf_gtk_setup_browser(bool fallback_to_pager __used)
 {
-	gtk_init(&argc, (char ***)&argv);
+	gtk_init(NULL, NULL);
 }
 
 void perf_gtk_exit_browser(bool wait_for_ok __used)
diff --git a/tools/perf/util/cache.h b/tools/perf/util/cache.h
index 8dd224d..d22ca68 100644
--- a/tools/perf/util/cache.h
+++ b/tools/perf/util/cache.h
@@ -46,14 +46,14 @@ void exit_browser(bool wait_for_ok);
 #endif
 
 #ifdef NO_GTK2_SUPPORT
-static inline void perf_gtk_setup_browser(int argc __used, const char *argv[] __used, bool fallback_to_pager)
+static inline void perf_gtk_setup_browser(bool fallback_to_pager)
 {
 	if (fallback_to_pager)
 		setup_pager();
 }
 static inline void perf_gtk_exit_browser(bool wait_for_ok __used) {}
 #else
-void perf_gtk_setup_browser(int argc, const char *argv[], bool fallback_to_pager);
+void perf_gtk_setup_browser(bool fallback_to_pager);
 void perf_gtk_exit_browser(bool wait_for_ok);
 #endif
 
