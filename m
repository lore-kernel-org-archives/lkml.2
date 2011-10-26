Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933882Ab1JZRvJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 13:51:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:54962 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933734Ab1JZRso (ORCPT
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
Subject: [PATCH 08/11] perf hists browser: Use K_TIMER
Date: Wed, 26 Oct 2011 15:48:31 -0200
Message-Id: <1319651314-29404-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1319651314-29404-1-git-send-email-acme@infradead.org>
References: <1319651314-29404-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

In the switch case entry for the timer routine.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-ypw3i9kmxoq28skx7jy914it@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/browsers/hists.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index 4663dcb..44210d4 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -314,8 +314,7 @@ static int hist_browser__run(struct hist_browser *self, const char *ev_name,
 		key = ui_browser__run(&self->b, delay_secs);
 
 		switch (key) {
-		case -1:
-			/* FIXME we need to check if it was es.reason == NEWT_EXIT_TIMER */
+		case K_TIMER:
 			timer(arg);
 			ui_browser__update_nr_entries(&self->b, self->hists->nr_entries);
 			hists__browser_title(self->hists, title, sizeof(title),
@@ -914,7 +913,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 					"C             Collapse all callchains\n"
 					"E             Expand all callchains\n"
 					"d             Zoom into current DSO\n"
-					"t             Zoom into current Thread\n");
+					"t             Zoom into current Thread");
 			continue;
 		case K_ENTER:
 		case K_RIGHT:
-- 
1.6.2.5

