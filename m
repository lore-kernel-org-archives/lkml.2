Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab0HBWR2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 18:17:28 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:58859
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754018Ab0HBWR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 18:17:26 -0400
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzzz2dh2a8h63h)
X-Spam-TCS-SCL: 2:0
Date: Mon, 2 Aug 2010 17:17:18 -0500
From: Scott Wood <scottwood@freescale.com>
To: Paul Mackerras <paulus@samba.org>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org
Subject: [PATCH] perf, powerpc: fsl_emb: Restore setting
 perf_sample_data.period
Message-ID: <20100802221718.GA11003@schlenkerla.am.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 02 Aug 2010 22:17:19.0039 (UTC) FILETIME=[789C74F0:01CB3290]
X-Reverse-DNS: az33egw02.freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 6b95ed345b9faa4ab3598a82991968f2e9f851bb changed from
a struct initializer to perf_sample_data_init(), but the setting
of the .period member was left out.

Signed-off-by: Scott Wood <scottwood@freescale.com>
---
 arch/powerpc/kernel/perf_event_fsl_emb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kernel/perf_event_fsl_emb.c b/arch/powerpc/kernel/perf_event_fsl_emb.c
index babccee..4339d20 100644
--- a/arch/powerpc/kernel/perf_event_fsl_emb.c
+++ b/arch/powerpc/kernel/perf_event_fsl_emb.c
@@ -569,6 +569,7 @@ static void record_and_restart(struct perf_event *event, unsigned long val,
 		struct perf_sample_data data;
 
 		perf_sample_data_init(&data, 0);
+		data.period = event->hw.last_period;
 
 		if (perf_event_overflow(event, nmi, &data, regs)) {
 			/*
-- 
1.7.0.4

