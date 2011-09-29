Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987Ab1I2WuE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 18:50:04 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60158 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756947Ab1I2WsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 18:48:22 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 14/16] perf report: Fix stdio event name header printing
Date: Thu, 29 Sep 2011 19:48:08 -0300
Message-Id: <1317336490-19437-15-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1317336490-19437-1-git-send-email-acme@infradead.org>
References: <1317336490-19437-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

In the past we tried to avoid printing the name of the event when just
one event was found in the perf.data file, after some refactorings it
ended up not printing the event name if just one hist_entry was found in
one of the events.

Fix it by always printing the name of the event, even if just one is
found.

Reported-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-kikr0c7ou55bd9caok8569rf@git.kernel.org
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index a0673ee..3d58334 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -229,10 +229,7 @@ static int perf_evlist__tty_browse_hists(struct perf_evlist *evlist,
 
 	list_for_each_entry(pos, &evlist->entries, node) {
 		struct hists *hists = &pos->hists;
-		const char *evname = NULL;
-
-		if (rb_first(&hists->entries) != rb_last(&hists->entries))
-			evname = event_name(pos);
+		const char *evname = event_name(pos);
 
 		hists__fprintf_nr_sample_events(hists, evname, stdout);
 		hists__fprintf(hists, NULL, false, stdout);
-- 
1.6.2.5

