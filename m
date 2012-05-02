Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695Ab2EBT0V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 15:26:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:56711 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756336Ab2EBTZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 15:25:15 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 13/15] perf ui gtk: Rename functions for consistency
Date: Wed,  2 May 2012 16:25:00 -0300
Message-Id: <1335986702-9408-14-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1335986702-9408-1-git-send-email-acme@infradead.org>
References: <1335986702-9408-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

We use double underscore characters to distinguish its subsystem and
actual function name.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1335761711-31403-4-git-send-email-namhyung.kim@lge.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c |    2 +-
 tools/perf/ui/gtk/browser.c |   24 ++++++++++++------------
 tools/perf/util/cache.h     |    8 ++++----
 3 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 2b20001..06115ff 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -678,7 +678,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 
 	if (strcmp(report.input_name, "-") != 0) {
 		if (report.use_gtk)
-			perf_gtk_setup_browser(true);
+			perf_gtk__setup_browser(true);
 		else
 			setup_browser(true);
 	} else {
diff --git a/tools/perf/ui/gtk/browser.c b/tools/perf/ui/gtk/browser.c
index a1a83de..5eafd9b 100644
--- a/tools/perf/ui/gtk/browser.c
+++ b/tools/perf/ui/gtk/browser.c
@@ -9,23 +9,23 @@
 
 #define MAX_COLUMNS			32
 
-void perf_gtk_setup_browser(bool fallback_to_pager __used)
+void perf_gtk__setup_browser(bool fallback_to_pager __used)
 {
 	gtk_init(NULL, NULL);
 }
 
-void perf_gtk_exit_browser(bool wait_for_ok __used)
+void perf_gtk__exit_browser(bool wait_for_ok __used)
 {
 	gtk_main_quit();
 }
 
-static void perf_gtk_signal(int sig)
+static void perf_gtk__signal(int sig)
 {
 	psignal(sig, "perf");
 	gtk_main_quit();
 }
 
-static void perf_gtk_resize_window(GtkWidget *window)
+static void perf_gtk__resize_window(GtkWidget *window)
 {
 	GdkRectangle rect;
 	GdkScreen *screen;
@@ -45,7 +45,7 @@ static void perf_gtk_resize_window(GtkWidget *window)
 	gtk_window_resize(GTK_WINDOW(window), width, height);
 }
 
-static void perf_gtk_show_hists(GtkWidget *window, struct hists *hists)
+static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists)
 {
 	GType col_types[MAX_COLUMNS];
 	GtkCellRenderer *renderer;
@@ -141,11 +141,11 @@ int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist,
 	GtkWidget *notebook;
 	GtkWidget *window;
 
-	signal(SIGSEGV, perf_gtk_signal);
-	signal(SIGFPE,  perf_gtk_signal);
-	signal(SIGINT,  perf_gtk_signal);
-	signal(SIGQUIT, perf_gtk_signal);
-	signal(SIGTERM, perf_gtk_signal);
+	signal(SIGSEGV, perf_gtk__signal);
+	signal(SIGFPE,  perf_gtk__signal);
+	signal(SIGINT,  perf_gtk__signal);
+	signal(SIGQUIT, perf_gtk__signal);
+	signal(SIGTERM, perf_gtk__signal);
 
 	window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
 
@@ -167,7 +167,7 @@ int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist,
 							GTK_POLICY_AUTOMATIC,
 							GTK_POLICY_AUTOMATIC);
 
-		perf_gtk_show_hists(scrolled_window, hists);
+		perf_gtk__show_hists(scrolled_window, hists);
 
 		tab_label = gtk_label_new(evname);
 
@@ -178,7 +178,7 @@ int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist,
 
 	gtk_widget_show_all(window);
 
-	perf_gtk_resize_window(window);
+	perf_gtk__resize_window(window);
 
 	gtk_window_set_position(GTK_WINDOW(window), GTK_WIN_POS_CENTER);
 
diff --git a/tools/perf/util/cache.h b/tools/perf/util/cache.h
index d22ca68..3428b77 100644
--- a/tools/perf/util/cache.h
+++ b/tools/perf/util/cache.h
@@ -46,15 +46,15 @@ void exit_browser(bool wait_for_ok);
 #endif
 
 #ifdef NO_GTK2_SUPPORT
-static inline void perf_gtk_setup_browser(bool fallback_to_pager)
+static inline void perf_gtk__setup_browser(bool fallback_to_pager)
 {
 	if (fallback_to_pager)
 		setup_pager();
 }
-static inline void perf_gtk_exit_browser(bool wait_for_ok __used) {}
+static inline void perf_gtk__exit_browser(bool wait_for_ok __used) {}
 #else
-void perf_gtk_setup_browser(bool fallback_to_pager);
-void perf_gtk_exit_browser(bool wait_for_ok);
+void perf_gtk__setup_browser(bool fallback_to_pager);
+void perf_gtk__exit_browser(bool wait_for_ok);
 #endif
 
 char *alias_lookup(const char *alias);
-- 
1.7.9.2.358.g22243

