Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab1I2MRf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 08:17:35 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:57505 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab1I2MRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 08:17:33 -0400
From: jgq516@gmail.com
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, jgq516@gmail.com
Subject: [PATCH v2 1/2] net/fec: replace hardcoded irq num with macro
Date: Thu, 29 Sep 2011 20:15:56 +0800
Message-Id: <1317298557-2878-1-git-send-email-jgq516@gmail.com>
X-Mailer: git-send-email 1.7.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiao Jiang <jgq516@gmail.com>

Don't use hardcoded irq num and replace it with
FEC_IRQ_NUM macro.

Signed-off-by: Xiao Jiang <jgq516@gmail.com>
---
The two patches are based on git://github.com/davem330/net-next.git
pls correct me if I still used wrong tree.

Thanks,
Xiao Jiang

 drivers/net/ethernet/freescale/fec.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec.c b/drivers/net/ethernet/freescale/fec.c
index cce78ce..1794ea4 100644
--- a/drivers/net/ethernet/freescale/fec.c
+++ b/drivers/net/ethernet/freescale/fec.c
@@ -177,6 +177,8 @@ MODULE_PARM_DESC(macaddr, "FEC Ethernet MAC address");
 #define PKT_MINBUF_SIZE		64
 #define PKT_MAXBLR_SIZE		1520
 
+/* This device has up to three irqs on some platforms */
+#define FEC_IRQ_NUM		3
 
 /*
  * The 5270/5271/5280/5282/532x RX control register also contains maximum frame
@@ -1540,8 +1542,7 @@ fec_probe(struct platform_device *pdev)
 
 	fec_reset_phy(pdev);
 
-	/* This device has up to three irqs on some platforms */
-	for (i = 0; i < 3; i++) {
+	for (i = 0; i < FEC_IRQ_NUM; i++) {
 		irq = platform_get_irq(pdev, i);
 		if (i && irq < 0)
 			break;
@@ -1586,7 +1587,7 @@ failed_init:
 	clk_disable(fep->clk);
 	clk_put(fep->clk);
 failed_clk:
-	for (i = 0; i < 3; i++) {
+	for (i = 0; i < FEC_IRQ_NUM; i++) {
 		irq = platform_get_irq(pdev, i);
 		if (irq > 0)
 			free_irq(irq, ndev);
-- 
1.7.6.1

