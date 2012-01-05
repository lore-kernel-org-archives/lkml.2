Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757618Ab2AERJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 12:09:19 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60208 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab2AERJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 12:09:18 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/3] perf hists: Rename total_session to total_period
Date: Thu,  5 Jan 2012 15:09:00 -0200
Message-Id: <1325783342-20273-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.8.rc0.35.gee6df
In-Reply-To: <1325783342-20273-1-git-send-email-acme@infradead.org>
References: <1325783342-20273-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Nowadays we do it per evsel, not per session (that may have multiple
evsels), so rename it to avoid confusion.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-azsgomr5h4dmaudoogw48w49@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index abef270..20059d1 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -733,7 +733,7 @@ void hists__output_recalc_col_len(struct hists *hists, int max_rows)
 static int hist_entry__pcnt_snprintf(struct hist_entry *self, char *s,
 				     size_t size, struct hists *pair_hists,
 				     bool show_displacement, long displacement,
-				     bool color, u64 session_total)
+				     bool color, u64 total_period)
 {
 	u64 period, total, period_sys, period_us, period_guest_sys, period_guest_us;
 	u64 nr_events;
@@ -754,7 +754,7 @@ static int hist_entry__pcnt_snprintf(struct hist_entry *self, char *s,
 	} else {
 		period = self->period;
 		nr_events = self->nr_events;
-		total = session_total;
+		total = total_period;
 		period_sys = self->period_sys;
 		period_us = self->period_us;
 		period_guest_sys = self->period_guest_sys;
@@ -812,8 +812,8 @@ static int hist_entry__pcnt_snprintf(struct hist_entry *self, char *s,
 
 		if (total > 0)
 			old_percent = (period * 100.0) / total;
-		if (session_total > 0)
-			new_percent = (self->period * 100.0) / session_total;
+		if (total_period > 0)
+			new_percent = (self->period * 100.0) / total_period;
 
 		diff = new_percent - old_percent;
 
@@ -864,7 +864,7 @@ int hist_entry__snprintf(struct hist_entry *he, char *s, size_t size,
 
 int hist_entry__fprintf(struct hist_entry *he, size_t size, struct hists *hists,
 			struct hists *pair_hists, bool show_displacement,
-			long displacement, FILE *fp, u64 session_total)
+			long displacement, FILE *fp, u64 total_period)
 {
 	char bf[512];
 	int ret;
@@ -874,14 +874,14 @@ int hist_entry__fprintf(struct hist_entry *he, size_t size, struct hists *hists,
 
 	ret = hist_entry__pcnt_snprintf(he, bf, size, pair_hists,
 					show_displacement, displacement,
-					true, session_total);
+					true, total_period);
 	hist_entry__snprintf(he, bf + ret, size - ret, hists);
 	return fprintf(fp, "%s\n", bf);
 }
 
 static size_t hist_entry__fprintf_callchain(struct hist_entry *self,
 					    struct hists *hists, FILE *fp,
-					    u64 session_total)
+					    u64 total_period)
 {
 	int left_margin = 0;
 
@@ -892,7 +892,7 @@ static size_t hist_entry__fprintf_callchain(struct hist_entry *self,
 		left_margin -= thread__comm_len(self->thread);
 	}
 
-	return hist_entry_callchain__fprintf(fp, self, session_total,
+	return hist_entry_callchain__fprintf(fp, self, total_period,
 					     left_margin);
 }
 
-- 
1.7.8.rc0.35.gee6df

