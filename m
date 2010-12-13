Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472Ab0LMMdH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 07:33:07 -0500
Received: from fw.wantstofly.org ([80.101.37.227]:36152 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757427Ab0LMMbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 07:31:06 -0500
Date: Mon, 13 Dec 2010 13:31:05 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Ian Molton <spyro@f2s.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 12/20] mfd: t7l66xb: irq_data conversion.
Message-ID: <20101213123105.GV15575@mail.wantstofly.org>
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
 drivers/mfd/t7l66xb.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/mfd/t7l66xb.c b/drivers/mfd/t7l66xb.c
index 006c121..2a770b6 100644
--- a/drivers/mfd/t7l66xb.c
+++ b/drivers/mfd/t7l66xb.c
@@ -199,37 +199,37 @@ static void t7l66xb_irq(unsigned int irq, struct irq_desc *desc)
 				generic_handle_irq(irq_base + i);
 }
 
-static void t7l66xb_irq_mask(unsigned int irq)
+static void t7l66xb_irq_mask(struct irq_data *d)
 {
-	struct t7l66xb *t7l66xb = get_irq_chip_data(irq);
-	unsigned long			flags;
+	struct t7l66xb *t7l66xb = irq_data_get_irq_chip_data(d);
+	unsigned long flags;
 	u8 imr;
 
 	spin_lock_irqsave(&t7l66xb->lock, flags);
 	imr = tmio_ioread8(t7l66xb->scr + SCR_IMR);
-	imr |= 1 << (irq - t7l66xb->irq_base);
+	imr |= 1 << (d->irq - t7l66xb->irq_base);
 	tmio_iowrite8(imr, t7l66xb->scr + SCR_IMR);
 	spin_unlock_irqrestore(&t7l66xb->lock, flags);
 }
 
-static void t7l66xb_irq_unmask(unsigned int irq)
+static void t7l66xb_irq_unmask(struct irq_data *d)
 {
-	struct t7l66xb *t7l66xb = get_irq_chip_data(irq);
+	struct t7l66xb *t7l66xb = irq_data_get_irq_chip_data(d);
 	unsigned long flags;
 	u8 imr;
 
 	spin_lock_irqsave(&t7l66xb->lock, flags);
 	imr = tmio_ioread8(t7l66xb->scr + SCR_IMR);
-	imr &= ~(1 << (irq - t7l66xb->irq_base));
+	imr &= ~(1 << (d->irq - t7l66xb->irq_base));
 	tmio_iowrite8(imr, t7l66xb->scr + SCR_IMR);
 	spin_unlock_irqrestore(&t7l66xb->lock, flags);
 }
 
 static struct irq_chip t7l66xb_chip = {
-	.name	= "t7l66xb",
-	.ack	= t7l66xb_irq_mask,
-	.mask	= t7l66xb_irq_mask,
-	.unmask	= t7l66xb_irq_unmask,
+	.name		= "t7l66xb",
+	.irq_ack	= t7l66xb_irq_mask,
+	.irq_mask	= t7l66xb_irq_mask,
+	.irq_unmask	= t7l66xb_irq_unmask,
 };
 
 /*--------------------------------------------------------------------------*/
-- 
1.7.1

