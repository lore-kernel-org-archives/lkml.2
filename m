Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947Ab2LSSUd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 13:20:33 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:36521
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753134Ab2LSSTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 13:19:08 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzzz1de0h1202h1e76h1d1ah1d2ahzz8275bhz2fh95h668h839hd24hf0ah119dh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h906i1155h)
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>, <monstr@monstr.eu>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        John Linn <john.linn@xilinx.com>, Arnd Bergmann <arnd@arndb.de>,
        <git@xilinx.com>, <nbowler@elliptictech.com>, <josh.cartwright@ni.com>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH v2 2/7] arm: zynq: timer: Remove unnecessary register write
Date: Wed, 19 Dec 2012 10:18:37 -0800
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <ab760e55-61c2-46b0-b899-1935c213536e@CO1EHSMHS026.ehs.local>
References: <ab760e55-61c2-46b0-b899-1935c213536e@CO1EHSMHS026.ehs.local>
X-RCIS-Action: ALLOW
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <9a66d197-21b2-478d-9439-6f6b121a0d9e@VA3EHSMHS024.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acknowedging an interrupt requires to read the interrupt register
only. The write was only required to work around a bug in
the QEMU implementation of the TTC, which is fixed.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
Acked-by: Peter Crosthwaite <peter.crosthwaite@xilinx.com>
Reviewed-by: Josh Cartwright <josh.cartwright@ni.com>
---
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


