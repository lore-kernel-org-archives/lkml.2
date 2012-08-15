Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021Ab2HOO6z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 10:58:55 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49026 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874Ab2HOO6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 10:58:53 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Pekka Enberg <penberg@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/5] perf ui/gtk: Use helpline API in browser
Date: Wed, 15 Aug 2012 23:57:34 +0900
Message-Id: <1345042655-27862-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1345042655-27862-1-git-send-email-namhyung@kernel.org>
References: <1345042655-27862-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As we now have a helpline implementation, use it for displaying help
messages.

Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/gtk/browser.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/perf/ui/gtk/browser.c b/tools/perf/ui/gtk/browser.c
index ec12e0b4ded6..26b5b652a8cd 100644
--- a/tools/perf/ui/gtk/browser.c
+++ b/tools/perf/ui/gtk/browser.c
@@ -3,6 +3,7 @@
 #include "../evsel.h"
 #include "../sort.h"
 #include "../hist.h"
+#include "../helpline.h"
 #include "gtk.h"
 
 #include <signal.h>
@@ -166,7 +167,7 @@ static GtkWidget *perf_gtk__setup_statusbar(void)
 }
 
 int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist,
-				  const char *help __used,
+				  const char *help,
 				  void (*timer) (void *arg)__used,
 				  void *arg __used, int delay_secs __used)
 {
@@ -233,6 +234,8 @@ int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist,
 
 	gtk_window_set_position(GTK_WINDOW(window), GTK_WIN_POS_CENTER);
 
+	ui_helpline__push(help);
+
 	gtk_main();
 
 	perf_gtk__deactivate_context(&pgctx);
-- 
1.7.9.2

