Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676Ab2EBT0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 15:26:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:56712 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756350Ab2EBTZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 15:25:15 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 12/15] perf ui gtk: Drop arg[cv] arguments from perf_gtk_setup_browser()
Date: Wed,  2 May 2012 16:24:59 -0300
Message-Id: <1335986702-9408-13-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1335986702-9408-1-git-send-email-acme@infradead.org>
References: <1335986702-9408-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

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
 
-- 
1.7.9.2.358.g22243

