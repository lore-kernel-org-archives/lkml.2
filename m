Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271Ab2LSATu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 19:19:50 -0500
Received: from [213.199.154.205] ([213.199.154.205]:22305 "EHLO
	am1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755096Ab2LSASl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 19:18:41 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzzz1de0h1202h1e76h1d1ah1d2ahzz8275bhz2fh95h668h839hd24hf0ah119dh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h906i1155h)
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: <linux-kernel@vger.kernel.org>, Michal Simek <michal.simek@xilinx.com>,
        <monstr@monstr.eu>, John Linn <john.linn@xilinx.com>
CC: <git@xilinx.com>, <josh.cartwright@ni.com>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH 7/7] arm: zynq: timer: Set clock_event cpumask
Date: Tue, 18 Dec 2012 16:16:39 -0800
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1355876199-23788-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1355876199-23788-1-git-send-email-soren.brinkmann@xilinx.com>
X-RCIS-Action: ALLOW
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <cdaebde8-aad5-4854-bc8d-e0d95c5a444d@AM1EHSMHS013.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The timers are common to both A9 cores, so let's set the clock
event struct's cpumask accordingly, to all possible CPUs.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 arch/arm/mach-zynq/timer.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-zynq/timer.c b/arch/arm/mach-zynq/timer.c
index 7b2e047..f9fbc9c 100644
--- a/arch/arm/mach-zynq/timer.c
+++ b/arch/arm/mach-zynq/timer.c
@@ -267,6 +267,7 @@ static void __init zynq_ttc_setup_clockevent(struct device_node *np,
 	ttcce->ce.set_mode = xttcps_set_mode;
 	ttcce->ce.rating = 200;
 	ttcce->ce.irq = irq;
+	ttcce->ce.cpumask = cpu_possible_mask;
 
 	__raw_writel(0x23, ttcce->xttc.base_addr + XTTCPS_CNT_CNTRL_OFFSET);
 	__raw_writel(CLK_CNTRL_PRESCALE | CLK_CNTRL_PRESCALE_EN,
-- 
1.8.0.2


