Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab2D3E5u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 00:57:50 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:61445 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab2D3E4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 00:56:15 -0400
X-AuditID: 9c930197-b7ca1ae0000069e6-6f-4f9e1b6c6d8e
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 2/7] perf ui: Drop arg[cv] arguments from perf_gtk_setup_browser()
Date: Mon, 30 Apr 2012 13:55:06 +0900
Message-Id: <1335761711-31403-3-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1335761711-31403-1-git-send-email-namhyung.kim@lge.com>
References: <1335761711-31403-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As perf doesn't allow to specify gtk command-line option,
drop the arguments and pass NULL to gtk_init(). This makes
the function easier to be called from setup_browser().

Acked-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/builtin-report.c |    2 +-
 tools/perf/ui/gtk/browser.c |    5 ++---
 tools/perf/util/cache.h     |    4 ++--
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index cec2b8cee80c..2b20001848f5 100644
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
index 258352a2356c..a1a83de3f459 100644
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
index 8dd224df3e54..d22ca689fb15 100644
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
 
-- 
1.7.10

