Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559Ab2CTTY7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 15:24:59 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55041 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756179Ab2CTTY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 15:24:57 -0400
From: Ashay Rane <ashay.r@gmail.com>
To: linux-perf-users@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, Ashay Rane <ashay.rane@tacc.utexas.edu>
Subject: [PATCH 1/1] Fix number of events displayed in header
Date: Tue, 20 Mar 2012 14:23:16 -0500
Message-Id: <1332271396-21756-1-git-send-email-ashay.r@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ashay Rane <ashay.rane@tacc.utexas.edu>

Signed-off-by: Ashay Rane <ashay.rane@tacc.utexas.edu>
---
 tools/perf/builtin-report.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 25d34d4..58a20cf 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -202,11 +202,9 @@ static size_t hists__fprintf_nr_sample_events(struct hists *self,
 					      const char *evname, FILE *fp)
 {
 	size_t ret;
-	char unit;
-	unsigned long nr_events = self->stats.nr_events[PERF_RECORD_SAMPLE];
+	u64 total_period = self->stats.total_period;
 
-	nr_events = convert_unit(nr_events, &unit);
-	ret = fprintf(fp, "# Events: %lu%c", nr_events, unit);
+	ret = fprintf(fp, "# Events: %llu", total_period);
 	if (evname != NULL)
 		ret += fprintf(fp, " %s", evname);
 	return ret + fprintf(fp, "\n#\n");
-- 
1.7.4.1

