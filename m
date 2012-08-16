Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab2HPIXd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 04:23:33 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:49617 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756239Ab2HPIVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 04:21:44 -0400
X-AuditID: 9c93016f-b7cc0ae000000e9f-f1-502cad96c73f
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@kernel.org>
Subject: [PATCH v2 4/5] perf ui/gtk: Use helpline API in browser
Date: Thu, 16 Aug 2012 17:14:53 +0900
Message-Id: <1345104894-14205-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1345104894-14205-1-git-send-email-namhyung@kernel.org>
References: <1345104894-14205-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As we now have a helpline implementation, use it for displaying help
messages.

Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/gtk/browser.c | 5 ++++-
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
1.7.11.2

