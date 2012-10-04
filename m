Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab2JDSPM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 14:15:12 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:59018 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391Ab2JDSPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 14:15:06 -0400
From: Michal Simek <monstr@monstr.eu>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
        Anirudha Sarangi <anirudh@xilinx.com>,
        John Linn <John.Linn@xilinx.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 03/11] net: axienet: Do not use NO_IRQ
Date: Thu,  4 Oct 2012 20:14:49 +0200
Message-Id: <1349374497-9540-3-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1349374497-9540-1-git-send-email-monstr@monstr.eu>
References: <1349374497-9540-1-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NO_IRQ is not longer used by Microblaze.

Signed-off-by: Michal Simek <monstr@monstr.eu>
CC: Anirudha Sarangi <anirudh@xilinx.com>
CC: John Linn <John.Linn@xilinx.com>
CC: Grant Likely <grant.likely@secretlab.ca>
CC: Rob Herring <rob.herring@calxeda.com>
CC: David S. Miller <davem@davemloft.net>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index a5b41cd..8d1db13 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1599,7 +1599,7 @@ static int __devinit axienet_of_probe(struct platform_device *op)
 	lp->rx_irq = irq_of_parse_and_map(np, 1);
 	lp->tx_irq = irq_of_parse_and_map(np, 0);
 	of_node_put(np);
-	if ((lp->rx_irq == NO_IRQ) || (lp->tx_irq == NO_IRQ)) {
+	if ((!lp->rx_irq) || (!lp->tx_irq)) {
 		dev_err(&op->dev, "could not determine irqs\n");
 		ret = -ENOMEM;
 		goto err_iounmap_2;
-- 
1.7.0.4

