Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285Ab2HTQ1H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 12:27:07 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56312 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325Ab2HTQ0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 12:26:39 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 12/24] perf ui/gtk: Use helpline API in browser
Date: Mon, 20 Aug 2012 13:26:13 -0300
Message-Id: <1345479985-18669-13-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1345479985-18669-1-git-send-email-acme@infradead.org>
References: <1345479985-18669-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

As we now have a helpline implementation, use it for displaying help
messages.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1345104894-14205-4-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/gtk/browser.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/tools/perf/ui/gtk/browser.c b/tools/perf/ui/gtk/browser.c
index ec12e0b..26b5b65 100644
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
1.7.1

