Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab1LUOcZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 09:32:25 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:38104 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab1LUOcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 09:32:20 -0500
From: Michal Simek <monstr@monstr.eu>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Michal Simek <monstr@monstr.eu>,
        "David S. Miller" <davem@davemloft.net> (commit_signer:7/10=70%),
        Stephen Rothwell <sfr@canb.auug.org.au> (commit_signer:1/10=10%),
        Grant Likely <grant.likely@secretlab.ca>,
        Ryan Mallon <rmallon@gmail.com>
Subject: [PATCH 2/4] net: ethernet: xilinx: Don't use NO_IRQ in xilinx
Date: Wed, 21 Dec 2011 15:32:10 +0100
Message-Id: <1324477932-19262-2-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1324477932-19262-1-git-send-email-monstr@monstr.eu>
References: <1324477932-19262-1-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix ll_temac and emaclite drivers. Only Microblaze and Xilinx PPC
use then and both use NO_IRQ as 0. It will be removed in near future.

Signed-off-by: Michal Simek <monstr@monstr.eu>
CC: "David S. Miller" <davem@davemloft.net> (commit_signer:7/10=70%)
CC: Stephen Rothwell <sfr@canb.auug.org.au> (commit_signer:1/10=10%)
CC: Grant Likely <grant.likely@secretlab.ca>
CC: Ryan Mallon <rmallon@gmail.com>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c   |    2 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 2681b53..87775d7 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -1077,7 +1077,7 @@ static int __devinit temac_of_probe(struct platform_device *op)
 
 	of_node_put(np); /* Finished with the DMA node; drop the reference */
 
-	if ((lp->rx_irq == NO_IRQ) || (lp->tx_irq == NO_IRQ)) {
+	if (!lp->rx_irq || !lp->tx_irq) {
 		dev_err(&op->dev, "could not determine irqs\n");
 		rc = -ENOMEM;
 		goto err_iounmap_2;
diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index 8018d7d..252edf7 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -1129,7 +1129,7 @@ static int __devinit xemaclite_of_probe(struct platform_device *ofdev)
 
 	/* Get IRQ for the device */
 	rc = of_irq_to_resource(ofdev->dev.of_node, 0, &r_irq);
-	if (rc == NO_IRQ) {
+	if (!rc) {
 		dev_err(dev, "no IRQ found\n");
 		return rc;
 	}
-- 
1.7.5.4

