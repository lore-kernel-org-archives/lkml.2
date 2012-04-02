Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375Ab2DBSWy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 14:22:54 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:44685
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753904Ab2DBST6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 14:19:58 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M1V6X2-02-33G-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 03/12] perf/x86-ibs: Enable ibs op micro-ops counting mode
Date: Mon, 2 Apr 2012 20:19:09 +0200
Message-ID: <1333390758-10893-4-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1333390758-10893-1-git-send-email-robert.richter@amd.com>
References: <1333390758-10893-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow enabling ibs op micro-ops counting mode.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event_amd_ibs.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
index 74b663c..6f00ee3 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -468,6 +468,8 @@ static __init int perf_event_ibs_init(void)
 		return -ENODEV;	/* ibs not supported by the cpu */
 
 	perf_ibs_pmu_init(&perf_ibs_fetch, "ibs_fetch");
+	if (ibs_caps & IBS_CAPS_OPCNT)
+		perf_ibs_op.config_mask |= IBS_OP_CNT_CTL;
 	perf_ibs_pmu_init(&perf_ibs_op, "ibs_op");
 	register_nmi_handler(NMI_LOCAL, &perf_ibs_nmi_handler, 0, "perf_ibs");
 	printk(KERN_INFO "perf: AMD IBS detected (0x%08x)\n", ibs_caps);
-- 
1.7.8.4


