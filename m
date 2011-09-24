Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab1IXCWg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 22:22:36 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:33135 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312Ab1IXCWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 22:22:35 -0400
From: jgq516@gmail.com
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: jgq516@gmail.com
Subject: [PATCH 1/2] net/fec: replace hardcoded irq num with macro.
Date: Sat, 24 Sep 2011 10:19:43 +0800
Message-Id: <1316830784-17108-1-git-send-email-jgq516@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiao Jiang <jgq516@gmail.com>

Don't use hardcoded irq num and replace it with
FEC_IRQ_NUM macro.

Signed-off-by: Xiao Jiang <jgq516@gmail.com>
---
 drivers/net/fec.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/fec.c b/drivers/net/fec.c
index e8266cc..5705def 100644
--- a/drivers/net/fec.c
+++ b/drivers/net/fec.c
@@ -170,6 +170,8 @@ MODULE_PARM_DESC(macaddr, "FEC Ethernet MAC address");
 #define PKT_MINBUF_SIZE		64
 #define PKT_MAXBLR_SIZE		1520
 
+/* This device has up to three irqs on some platforms */
+#define FEC_IRQ_NUM			3
 
 /*
  * The 5270/5271/5280/5282/532x RX control register also contains maximum frame
@@ -1503,8 +1505,7 @@ fec_probe(struct platform_device *pdev)
 
 	fec_reset_phy(pdev);
 
-	/* This device has up to three irqs on some platforms */
-	for (i = 0; i < 3; i++) {
+	for (i = 0; i < FEC_IRQ_NUM; i++) {
 		irq = platform_get_irq(pdev, i);
 		if (i && irq < 0)
 			break;
@@ -1549,7 +1550,7 @@ failed_init:
 	clk_disable(fep->clk);
 	clk_put(fep->clk);
 failed_clk:
-	for (i = 0; i < 3; i++) {
+	for (i = 0; i < FEC_IRQ_NUM; i++) {
 		irq = platform_get_irq(pdev, i);
 		if (irq > 0)
 			free_irq(irq, ndev);
-- 
1.7.0.4

