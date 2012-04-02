Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab2DBSUB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 14:20:01 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:43033 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754004Ab2DBST7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 14:19:59 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M1V6X2-02-33L-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 07/12] perf/x86-ibs: Rename some variables
Date: Mon, 2 Apr 2012 20:19:13 +0200
Message-ID: <1333390758-10893-8-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1333390758-10893-1-git-send-email-robert.richter@amd.com>
References: <1333390758-10893-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simple patch that just renames some variables for better
understanding.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event_amd_ibs.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
index 05a359f..6591b77 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -62,7 +62,7 @@ struct perf_ibs_data {
 };
 
 static int
-perf_event_set_period(struct hw_perf_event *hwc, u64 min, u64 max, u64 *count)
+perf_event_set_period(struct hw_perf_event *hwc, u64 min, u64 max, u64 *hw_period)
 {
 	s64 left = local64_read(&hwc->period_left);
 	s64 period = hwc->sample_period;
@@ -91,7 +91,7 @@ perf_event_set_period(struct hw_perf_event *hwc, u64 min, u64 max, u64 *count)
 	if (left > max)
 		left = max;
 
-	*count = (u64)left;
+	*hw_period = (u64)left;
 
 	return overflow;
 }
@@ -264,13 +264,13 @@ static int perf_ibs_init(struct perf_event *event)
 static int perf_ibs_set_period(struct perf_ibs *perf_ibs,
 			       struct hw_perf_event *hwc, u64 *period)
 {
-	int ret;
+	int overflow;
 
 	/* ignore lower 4 bits in min count: */
-	ret = perf_event_set_period(hwc, 1<<4, perf_ibs->max_period, period);
+	overflow = perf_event_set_period(hwc, 1<<4, perf_ibs->max_period, period);
 	local64_set(&hwc->prev_count, 0);
 
-	return ret;
+	return overflow;
 }
 
 static u64 get_ibs_fetch_count(u64 config)
-- 
1.7.8.4


