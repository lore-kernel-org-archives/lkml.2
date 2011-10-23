Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137Ab1JWVSU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 17:18:20 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:40799 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab1JWVSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 17:18:18 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH 1/5] m68k/net: Remove obsolete IRQ_FLG_* users
Date: Sun, 23 Oct 2011 23:18:02 +0200
Message-Id: <1319404686-10800-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The m68k core irq code stopped honoring these flags during the irq
restructuring in 2006.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
---
This is a split-up of "m68k/irq: Remove obsolete IRQ_FLG_* definitions and
users", to reduce conflicts and dependencies.

diff --git a/drivers/net/ethernet/natsemi/macsonic.c b/drivers/net/ethernet/natsemi/macsonic.c
index c93679e..aae4cfc 100644
--- a/drivers/net/ethernet/natsemi/macsonic.c
+++ b/drivers/net/ethernet/natsemi/macsonic.c
@@ -142,8 +142,7 @@ static int macsonic_open(struct net_device* dev)
 {
 	int retval;
 
-	retval = request_irq(dev->irq, sonic_interrupt, IRQ_FLG_FAST,
-				"sonic", dev);
+	retval = request_irq(dev->irq, sonic_interrupt, 0, "sonic", dev);
 	if (retval) {
 		printk(KERN_ERR "%s: unable to get IRQ %d.\n",
 				dev->name, dev->irq);
@@ -154,8 +153,8 @@ static int macsonic_open(struct net_device* dev)
 	 * rupt as well, which must prevent re-entrance of the sonic handler.
 	 */
 	if (dev->irq == IRQ_AUTO_3) {
-		retval = request_irq(IRQ_NUBUS_9, macsonic_interrupt,
-					IRQ_FLG_FAST, "sonic", dev);
+		retval = request_irq(IRQ_NUBUS_9, macsonic_interrupt, 0,
+				     "sonic", dev);
 		if (retval) {
 			printk(KERN_ERR "%s: unable to get IRQ %d.\n",
 					dev->name, IRQ_NUBUS_9);
