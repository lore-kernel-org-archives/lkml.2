Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983Ab1FLTlF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 15:41:05 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:41593 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751904Ab1FLTlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 15:41:03 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: netdev@vger.kernel.org
Subject: 3c503: fix broken IRQ autoprobing
Date: Sun, 12 Jun 2011 21:40:49 +0200
User-Agent: KMail/1.9.10
Cc: Kernel development list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201106122140.51776.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix broken IRQ autoprobing in 3c503 driver:
 - improper IRQ freeing (does not free IRQs causes WARN)
 - missing break when an working IRQ is found

The driver works with this patch.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-2.6.39-rc2-orig/drivers/net/3c503.c	2011-04-06 03:30:43.000000000 +0200
+++ linux-2.6.39-rc2/drivers/net/3c503.c	2011-06-12 21:29:47.000000000 +0200
@@ -412,7 +412,7 @@ el2_open(struct net_device *dev)
 		outb_p(0x04 << ((*irqp == 9) ? 2 : *irqp), E33G_IDCFR);
 		outb_p(0x00, E33G_IDCFR);
 		msleep(1);
-		free_irq(*irqp, el2_probe_interrupt);
+		free_irq(*irqp, &seen);
 		if (!seen)
 			continue;
 
@@ -422,6 +422,7 @@ el2_open(struct net_device *dev)
 			continue;
 		if (retval < 0)
 			goto err_disable;
+		break;
 	} while (*++irqp);
 
 	if (*irqp == 0) {


-- 
Ondrej Zary
