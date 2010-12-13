Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329Ab0LMMcn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 07:32:43 -0500
Received: from fw.wantstofly.org ([80.101.37.227]:41588 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757484Ab0LMMbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 07:31:11 -0500
Date: Mon, 13 Dec 2010 13:31:10 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 14/20] mfd: tc6393xb: irq_data conversion.
Message-ID: <20101213123110.GX15575@mail.wantstofly.org>
References: <cover.1292241952.git.buytenh@wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1292241952.git.buytenh@wantstofly.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lennert Buytenhek <buytenh@secretlab.ca>
---
 drivers/mfd/tc6393xb.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/mfd/tc6393xb.c b/drivers/mfd/tc6393xb.c
index 1ea80d8..e150d91 100644
--- a/drivers/mfd/tc6393xb.c
+++ b/drivers/mfd/tc6393xb.c
@@ -527,41 +527,41 @@ tc6393xb_irq(unsigned int irq, struct irq_desc *desc)
 		}
 }
 
-static void tc6393xb_irq_ack(unsigned int irq)
+static void tc6393xb_irq_ack(struct irq_data *d)
 {
 }
 
-static void tc6393xb_irq_mask(unsigned int irq)
+static void tc6393xb_irq_mask(struct irq_data *d)
 {
-	struct tc6393xb *tc6393xb = get_irq_chip_data(irq);
+	struct tc6393xb *tc6393xb = irq_data_get_irq_chip_data(d);
 	unsigned long flags;
 	u8 imr;
 
 	spin_lock_irqsave(&tc6393xb->lock, flags);
 	imr = tmio_ioread8(tc6393xb->scr + SCR_IMR);
-	imr |= 1 << (irq - tc6393xb->irq_base);
+	imr |= 1 << (d->irq - tc6393xb->irq_base);
 	tmio_iowrite8(imr, tc6393xb->scr + SCR_IMR);
 	spin_unlock_irqrestore(&tc6393xb->lock, flags);
 }
 
-static void tc6393xb_irq_unmask(unsigned int irq)
+static void tc6393xb_irq_unmask(struct irq_data *d)
 {
-	struct tc6393xb *tc6393xb = get_irq_chip_data(irq);
+	struct tc6393xb *tc6393xb = irq_data_get_irq_chip_data(d);
 	unsigned long flags;
 	u8 imr;
 
 	spin_lock_irqsave(&tc6393xb->lock, flags);
 	imr = tmio_ioread8(tc6393xb->scr + SCR_IMR);
-	imr &= ~(1 << (irq - tc6393xb->irq_base));
+	imr &= ~(1 << (d->irq - tc6393xb->irq_base));
 	tmio_iowrite8(imr, tc6393xb->scr + SCR_IMR);
 	spin_unlock_irqrestore(&tc6393xb->lock, flags);
 }
 
 static struct irq_chip tc6393xb_chip = {
-	.name	= "tc6393xb",
-	.ack	= tc6393xb_irq_ack,
-	.mask	= tc6393xb_irq_mask,
-	.unmask	= tc6393xb_irq_unmask,
+	.name		= "tc6393xb",
+	.irq_ack	= tc6393xb_irq_ack,
+	.irq_mask	= tc6393xb_irq_mask,
+	.irq_unmask	= tc6393xb_irq_unmask,
 };
 
 static void tc6393xb_attach_irq(struct platform_device *dev)
-- 
1.7.1

