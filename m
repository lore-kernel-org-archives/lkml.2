Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751321Ab2JVIvl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 04:51:41 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:41064 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab2JVIvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 04:51:40 -0400
MIME-Version: 1.0
Date: Mon, 22 Oct 2012 16:51:38 +0800
Message-ID: <CAPgLHd8NZkYSkZm22FpZxiEh6HcA0q-V=29vdnheiDhgrJZ+yw@mail.gmail.com>
Subject: [PATCH] perf/x86: remove unused variable in nhmex_rbox_alter_er()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, tglx@linutronix.de, hpa@zytor.com
Cc: yongjun_wei@trendmicro.com.cn, x86@kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The variable port is initialized but never used
otherwise, so remove the unused variable.

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 99d96a4..e7d4061 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -1547,7 +1547,6 @@ void nhmex_rbox_alter_er(struct intel_uncore_box *box, struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
 	struct hw_perf_event_extra *reg1 = &hwc->extra_reg;
-	int port;
 
 	/* adjust the main event selector and extra register index */
 	if (reg1->idx % 2) {
@@ -1559,7 +1558,6 @@ void nhmex_rbox_alter_er(struct intel_uncore_box *box, struct perf_event *event)
 	}
 
 	/* adjust extra register config */
-	port = reg1->idx / 6 + box->pmu->pmu_idx * 4;
 	switch (reg1->idx % 6) {
 	case 2:
 		/* shift the 8~15 bits to the 0~7 bits */

