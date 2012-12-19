Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075Ab2LSASd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 19:18:33 -0500
Received: from [213.199.154.140] ([213.199.154.140]:28308 "EHLO
	db3outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754977Ab2LSASb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 19:18:31 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzzz1de0h1202h1e76h1d1ah1d2ahzz8275bhz2fh95h668h839hd24hf0ah119dh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h906i1155h)
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: <linux-kernel@vger.kernel.org>, Michal Simek <michal.simek@xilinx.com>,
        <monstr@monstr.eu>, John Linn <john.linn@xilinx.com>
CC: <git@xilinx.com>, <josh.cartwright@ni.com>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH 2/7] arm: zynq: timer: Remove unnecessary register write
Date: Tue, 18 Dec 2012 16:16:34 -0800
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1355876199-23788-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1355876199-23788-1-git-send-email-soren.brinkmann@xilinx.com>
X-RCIS-Action: ALLOW
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <26c7059f-09d2-4b0a-83a8-e27d10fbd100@DB3EHSMHS008.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acknowedging an interrupt requires to read the interrupt register
only. The write was only required to work around a bug in
the QEMU implementation of the TTC, which is fixed.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
Acked-by: Peter Crosthwaite <peter.crosthwaite@xilinx.com>
---
@Peter: I took over your ACK, since it's the same change we applied to the
Xilinx tree a couple of weeks ago. Let me know if this should be removed.

 arch/arm/mach-zynq/timer.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm/mach-zynq/timer.c b/arch/arm/mach-zynq/timer.c
index 570491d..f1d224b 100644
--- a/arch/arm/mach-zynq/timer.c
+++ b/arch/arm/mach-zynq/timer.c
@@ -121,8 +121,7 @@ static irqreturn_t xttcps_clock_event_interrupt(int irq, void *dev_id)
 	struct xttcps_timer *timer = &xttce->xttc;
 
 	/* Acknowledge the interrupt and call event handler */
-	__raw_writel(__raw_readl(timer->base_addr + XTTCPS_ISR_OFFSET),
-			timer->base_addr + XTTCPS_ISR_OFFSET);
+	__raw_readl(timer->base_addr + XTTCPS_ISR_OFFSET);
 
 	xttce->ce.event_handler(&xttce->ce);
 
-- 
1.8.0.2


