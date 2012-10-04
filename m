Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452Ab2JDSPr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 14:15:47 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:38022 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755238Ab2JDSPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 14:15:18 -0400
From: Michal Simek <monstr@monstr.eu>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
        Anirudha Sarangi <anirudh@xilinx.com>,
        John Linn <John.Linn@xilinx.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 11/11] net: xilinx: Show csum in bootlog
Date: Thu,  4 Oct 2012 20:14:57 +0200
Message-Id: <1349374497-9540-11-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1349374497-9540-1-git-send-email-monstr@monstr.eu>
References: <1349374497-9540-1-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just show current setting in bootlog.

Signed-off-by: Michal Simek <monstr@monstr.eu>
CC: Anirudha Sarangi <anirudh@xilinx.com>
CC: John Linn <John.Linn@xilinx.com>
CC: Grant Likely <grant.likely@secretlab.ca>
CC: Rob Herring <rob.herring@calxeda.com>
CC: David S. Miller <davem@davemloft.net>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c       |    2 ++
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 58b2869..8c31fcd 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -1052,12 +1052,14 @@ static int __devinit temac_of_probe(struct platform_device *op)
 	/* Setup checksum offload, but default to off if not specified */
 	lp->temac_features = 0;
 	p = (__be32 *)of_get_property(op->dev.of_node, "xlnx,txcsum", NULL);
+	dev_info(&op->dev, "TX_CSUM %d\n", be32_to_cpup(p));
 	if (p && be32_to_cpu(*p)) {
 		lp->temac_features |= TEMAC_FEATURE_TX_CSUM;
 		/* Can checksum TCP/UDP over IPv4. */
 		ndev->features |= NETIF_F_IP_CSUM;
 	}
 	p = (__be32 *)of_get_property(op->dev.of_node, "xlnx,rxcsum", NULL);
+	dev_info(&op->dev, "RX_CSUM %d\n", be32_to_cpup(p));
 	if (p && be32_to_cpu(*p))
 		lp->temac_features |= TEMAC_FEATURE_RX_CSUM;
 
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 4ef148f..9ea5be6 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1528,6 +1528,7 @@ static int __devinit axienet_of_probe(struct platform_device *op)
 	lp->features = 0;
 
 	p = (__be32 *) of_get_property(op->dev.of_node, "xlnx,txcsum", NULL);
+	dev_info(&op->dev, "TX_CSUM %d\n", be32_to_cpup(p));
 	if (p) {
 		switch (be32_to_cpup(p)) {
 		case 1:
@@ -1549,6 +1550,7 @@ static int __devinit axienet_of_probe(struct platform_device *op)
 		}
 	}
 	p = (__be32 *) of_get_property(op->dev.of_node, "xlnx,rxcsum", NULL);
+	dev_info(&op->dev, "RX_CSUM %d\n", be32_to_cpup(p));
 	if (p) {
 		switch (be32_to_cpup(p)) {
 		case 1:
-- 
1.7.0.4

