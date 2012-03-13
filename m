Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760147Ab2CMWfx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 18:35:53 -0400
Received: from irongate.mail.utexas.edu ([146.6.25.6]:21838 "EHLO
	irongate.mail.utexas.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755927Ab2CMWfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 18:35:51 -0400
X-Greylist: delayed 575 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Mar 2012 18:35:51 EDT
X-Utexas-Sender-Group: RELAYLIST-AEMS
X-IronPort-MID: 166941591
X-Utexas-Seen-Inbound: true
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApwEAF/JX0+sEEdW/2dsb2JhbABDtnaCN1KBPg4FiAquCIRLiQeNVIMiBIhVjHuQI4MD
X-IronPort-AV: E=Sophos;i="4.73,579,1325484000"; 
   d="scan'208";a="166941591"
From: Ashay Rane <ashay.rane@tacc.utexas.edu>
To: <linux-perf-users@vger.kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        <linux-kernel@vger.kernel.org>,
        Ashay Rane <ashay.rane@tacc.utexas.edu>
Subject: [PATCH 1/1] Fix number of events displayed in header
Date: Tue, 13 Mar 2012 17:24:57 -0500
Message-ID: <1331677497-23525-1-git-send-email-ashay.rane@tacc.utexas.edu>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

