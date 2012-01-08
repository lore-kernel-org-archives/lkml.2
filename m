Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab2AHLrP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 06:47:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39151 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283Ab2AHLrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 06:47:12 -0500
Date: Sun, 8 Jan 2012 03:46:34 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-azsgomr5h4dmaudoogw48w49@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        efault@gmx.de, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists: Rename total_session to total_period
Git-Commit-ID: 13d3ee5402970216291d2c514c2ba33ef8a0e8c1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 08 Jan 2012 03:46:40 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  13d3ee5402970216291d2c514c2ba33ef8a0e8c1
Gitweb:     http://git.kernel.org/tip/13d3ee5402970216291d2c514c2ba33ef8a0e8c1
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 4 Jan 2012 11:37:15 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 6 Jan 2012 15:42:08 -0200

perf hists: Rename total_session to total_period

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
 
