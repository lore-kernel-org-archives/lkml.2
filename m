Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300Ab2CZIwL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 04:52:11 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:65100 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755736Ab2CZIvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 04:51:41 -0400
X-AuditID: 9c93016f-b7cc6ae00000317e-20-4f702e190f75
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 4/5] perf gtk: Rename functions for consistency
Date: Mon, 26 Mar 2012 17:51:35 +0900
Message-Id: <1332751896-11210-5-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1332751896-11210-1-git-send-email-namhyung.kim@lge.com>
References: <1332751896-11210-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use double underscore characters to distinguish its subsystem
and actual function name.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/ui/setup.c         |    4 ++--
 tools/perf/util/cache.h       |    8 ++++----
 tools/perf/util/gtk/browser.c |   24 ++++++++++++------------
 3 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/tools/perf/ui/setup.c b/tools/perf/ui/setup.c
index 228221a11830..ee4916fc8157 100644
--- a/tools/perf/ui/setup.c
+++ b/tools/perf/ui/setup.c
@@ -11,7 +11,7 @@ void setup_browser(bool fallback_to_pager)
 
 	switch (use_browser) {
 	case 2:
-		perf_gtk_setup_browser(fallback_to_pager);
+		perf_gtk__setup_browser(fallback_to_pager);
 		break;
 
 	case 1:
@@ -29,7 +29,7 @@ void exit_browser(bool wait_for_ok)
 {
 	switch (use_browser) {
 	case 2:
-		perf_gtk_exit_browser(wait_for_ok);
+		perf_gtk__exit_browser(wait_for_ok);
 		break;
 
 	case 1:
diff --git a/tools/perf/util/cache.h b/tools/perf/util/cache.h
index 60ad454e9a8b..845571f53121 100644
--- a/tools/perf/util/cache.h
+++ b/tools/perf/util/cache.h
@@ -58,15 +58,15 @@ void ui__exit(bool wait_for_ok);
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
 #endif /* NO_NEWT_SUPPORT && NO_GTK2_SUPPORT */
 
diff --git a/tools/perf/util/gtk/browser.c b/tools/perf/util/gtk/browser.c
index a1a83de3f459..5eafd9b3b783 100644
--- a/tools/perf/util/gtk/browser.c
+++ b/tools/perf/util/gtk/browser.c
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
 
-- 
1.7.7.6

