Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979Ab2HUQXJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 12:23:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32777 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217Ab2HUQXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 12:23:05 -0400
Date: Tue, 21 Aug 2012 09:22:50 -0700
From: tip-bot for Namhyung Kim <namhyung@kernel.org>
Message-ID: <tip-ed70c609ae92e0cb03b746ab566c3cf8f2aaede4@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        penberg@kernel.org, namhyung@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        penberg@kernel.org, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1345104894-14205-4-git-send-email-namhyung@kernel.org>
References: <1345104894-14205-4-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf ui/gtk: Use helpline API in browser
Git-Commit-ID: ed70c609ae92e0cb03b746ab566c3cf8f2aaede4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 09:22:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ed70c609ae92e0cb03b746ab566c3cf8f2aaede4
Gitweb:     http://git.kernel.org/tip/ed70c609ae92e0cb03b746ab566c3cf8f2aaede4
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Thu, 16 Aug 2012 17:14:53 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 17 Aug 2012 12:37:36 -0300

perf ui/gtk: Use helpline API in browser

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
