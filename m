Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272Ab2JDSPS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 14:15:18 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:36233 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649Ab2JDSPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 14:15:04 -0400
From: Michal Simek <monstr@monstr.eu>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
        Anirudha Sarangi <anirudh@xilinx.com>,
        John Linn <John.Linn@xilinx.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 01/11] net: axienet: Remove NETIF_F_SG dropping for no checksum feature
Date: Thu,  4 Oct 2012 20:14:47 +0200
Message-Id: <1349374497-9540-1-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Warning message:
eth0: Dropping NETIF_F_SG since no checksum feature.

Signed-off-by: Michal Simek <monstr@monstr.eu>
CC: Anirudha Sarangi <anirudh@xilinx.com>
CC: John Linn <John.Linn@xilinx.com>
CC: Grant Likely <grant.likely@secretlab.ca>
CC: Rob Herring <rob.herring@calxeda.com>
CC: David S. Miller <davem@davemloft.net>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 0793299..50167ab 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1494,7 +1494,7 @@ static int __devinit axienet_of_probe(struct platform_device *op)
 
 	SET_NETDEV_DEV(ndev, &op->dev);
 	ndev->flags &= ~IFF_MULTICAST;  /* clear multicast */
-	ndev->features = NETIF_F_SG | NETIF_F_FRAGLIST;
+	ndev->features = NETIF_F_FRAGLIST;
 	ndev->netdev_ops = &axienet_netdev_ops;
 	ndev->ethtool_ops = &axienet_ethtool_ops;
 
@@ -1519,14 +1519,14 @@ static int __devinit axienet_of_probe(struct platform_device *op)
 				XAE_FEATURE_PARTIAL_TX_CSUM;
 			lp->features |= XAE_FEATURE_PARTIAL_TX_CSUM;
 			/* Can checksum TCP/UDP over IPv4. */
-			ndev->features |= NETIF_F_IP_CSUM;
+			ndev->features |= NETIF_F_IP_CSUM | NETIF_F_SG;
 			break;
 		case 2:
 			lp->csum_offload_on_tx_path =
 				XAE_FEATURE_FULL_TX_CSUM;
 			lp->features |= XAE_FEATURE_FULL_TX_CSUM;
 			/* Can checksum TCP/UDP over IPv4. */
-			ndev->features |= NETIF_F_IP_CSUM;
+			ndev->features |= NETIF_F_IP_CSUM | NETIF_F_SG;
 			break;
 		default:
 			lp->csum_offload_on_tx_path = XAE_NO_CSUM_OFFLOAD;
-- 
1.7.0.4

