Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376Ab0LMMaF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 07:30:05 -0500
Received: from fw.wantstofly.org ([80.101.37.227]:36129 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab0LMMaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 07:30:01 -0500
Date: Mon, 13 Dec 2010 13:30:00 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 04/20] mfd: asic3: irq_data conversion.
Message-ID: <20101213123000.GN15575@mail.wantstofly.org>
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
 drivers/mfd/asic3.c |   60 +++++++++++++++++++++++++-------------------------
 1 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
index 7de708d..3cab1a9 100644
--- a/drivers/mfd/asic3.c
+++ b/drivers/mfd/asic3.c
@@ -143,9 +143,9 @@ static void asic3_irq_demux(unsigned int irq, struct irq_desc *desc)
 	unsigned long flags;
 	struct asic3 *asic;
 
-	desc->chip->ack(irq);
+	desc->irq_data.chip->irq_ack(&desc->irq_data);
 
-	asic = desc->handler_data;
+	asic = get_irq_data(irq);
 
 	for (iter = 0 ; iter < MAX_ASIC_ISR_LOOPS; iter++) {
 		u32 status;
@@ -226,14 +226,14 @@ static inline int asic3_irq_to_index(struct asic3 *asic, int irq)
 	return (irq - asic->irq_base) & 0xf;
 }
 
-static void asic3_mask_gpio_irq(unsigned int irq)
+static void asic3_mask_gpio_irq(struct irq_data *d)
 {
-	struct asic3 *asic = get_irq_chip_data(irq);
+	struct asic3 *asic = irq_data_get_irq_chip_data(d);
 	u32 val, bank, index;
 	unsigned long flags;
 
-	bank = asic3_irq_to_bank(asic, irq);
-	index = asic3_irq_to_index(asic, irq);
+	bank = asic3_irq_to_bank(asic, d->irq);
+	index = asic3_irq_to_index(asic, d->irq);
 
 	spin_lock_irqsave(&asic->lock, flags);
 	val = asic3_read_register(asic, bank + ASIC3_GPIO_MASK);
@@ -242,9 +242,9 @@ static void asic3_mask_gpio_irq(unsigned int irq)
 	spin_unlock_irqrestore(&asic->lock, flags);
 }
 
-static void asic3_mask_irq(unsigned int irq)
+static void asic3_mask_irq(struct irq_data *d)
 {
-	struct asic3 *asic = get_irq_chip_data(irq);
+	struct asic3 *asic = irq_data_get_irq_chip_data(d);
 	int regval;
 	unsigned long flags;
 
@@ -254,7 +254,7 @@ static void asic3_mask_irq(unsigned int irq)
 				     ASIC3_INTR_INT_MASK);
 
 	regval &= ~(ASIC3_INTMASK_MASK0 <<
-		    (irq - (asic->irq_base + ASIC3_NUM_GPIOS)));
+		    (d->irq - (asic->irq_base + ASIC3_NUM_GPIOS)));
 
 	asic3_write_register(asic,
 			     ASIC3_INTR_BASE +
@@ -263,14 +263,14 @@ static void asic3_mask_irq(unsigned int irq)
 	spin_unlock_irqrestore(&asic->lock, flags);
 }
 
-static void asic3_unmask_gpio_irq(unsigned int irq)
+static void asic3_unmask_gpio_irq(struct irq_data *d)
 {
-	struct asic3 *asic = get_irq_chip_data(irq);
+	struct asic3 *asic = irq_data_get_irq_chip_data(d);
 	u32 val, bank, index;
 	unsigned long flags;
 
-	bank = asic3_irq_to_bank(asic, irq);
-	index = asic3_irq_to_index(asic, irq);
+	bank = asic3_irq_to_bank(asic, d->irq);
+	index = asic3_irq_to_index(asic, d->irq);
 
 	spin_lock_irqsave(&asic->lock, flags);
 	val = asic3_read_register(asic, bank + ASIC3_GPIO_MASK);
@@ -279,9 +279,9 @@ static void asic3_unmask_gpio_irq(unsigned int irq)
 	spin_unlock_irqrestore(&asic->lock, flags);
 }
 
-static void asic3_unmask_irq(unsigned int irq)
+static void asic3_unmask_irq(struct irq_data *d)
 {
-	struct asic3 *asic = get_irq_chip_data(irq);
+	struct asic3 *asic = irq_data_get_irq_chip_data(d);
 	int regval;
 	unsigned long flags;
 
@@ -291,7 +291,7 @@ static void asic3_unmask_irq(unsigned int irq)
 				     ASIC3_INTR_INT_MASK);
 
 	regval |= (ASIC3_INTMASK_MASK0 <<
-		   (irq - (asic->irq_base + ASIC3_NUM_GPIOS)));
+		   (d->irq - (asic->irq_base + ASIC3_NUM_GPIOS)));
 
 	asic3_write_register(asic,
 			     ASIC3_INTR_BASE +
@@ -300,15 +300,15 @@ static void asic3_unmask_irq(unsigned int irq)
 	spin_unlock_irqrestore(&asic->lock, flags);
 }
 
-static int asic3_gpio_irq_type(unsigned int irq, unsigned int type)
+static int asic3_gpio_irq_type(struct irq_data *d, unsigned int type)
 {
-	struct asic3 *asic = get_irq_chip_data(irq);
+	struct asic3 *asic = irq_data_get_irq_chip_data(d);
 	u32 bank, index;
 	u16 trigger, level, edge, bit;
 	unsigned long flags;
 
-	bank = asic3_irq_to_bank(asic, irq);
-	index = asic3_irq_to_index(asic, irq);
+	bank = asic3_irq_to_bank(asic, d->irq);
+	index = asic3_irq_to_index(asic, d->irq);
 	bit = 1<<index;
 
 	spin_lock_irqsave(&asic->lock, flags);
@@ -318,7 +318,7 @@ static int asic3_gpio_irq_type(unsigned int irq, unsigned int type)
 				   bank + ASIC3_GPIO_EDGE_TRIGGER);
 	trigger = asic3_read_register(asic,
 				      bank + ASIC3_GPIO_TRIGGER_TYPE);
-	asic->irq_bothedge[(irq - asic->irq_base) >> 4] &= ~bit;
+	asic->irq_bothedge[(d->irq - asic->irq_base) >> 4] &= ~bit;
 
 	if (type == IRQ_TYPE_EDGE_RISING) {
 		trigger |= bit;
@@ -328,11 +328,11 @@ static int asic3_gpio_irq_type(unsigned int irq, unsigned int type)
 		edge &= ~bit;
 	} else if (type == IRQ_TYPE_EDGE_BOTH) {
 		trigger |= bit;
-		if (asic3_gpio_get(&asic->gpio, irq - asic->irq_base))
+		if (asic3_gpio_get(&asic->gpio, d->irq - asic->irq_base))
 			edge &= ~bit;
 		else
 			edge |= bit;
-		asic->irq_bothedge[(irq - asic->irq_base) >> 4] |= bit;
+		asic->irq_bothedge[(d->irq - asic->irq_base) >> 4] |= bit;
 	} else if (type == IRQ_TYPE_LEVEL_LOW) {
 		trigger &= ~bit;
 		level &= ~bit;
@@ -359,17 +359,17 @@ static int asic3_gpio_irq_type(unsigned int irq, unsigned int type)
 
 static struct irq_chip asic3_gpio_irq_chip = {
 	.name		= "ASIC3-GPIO",
-	.ack		= asic3_mask_gpio_irq,
-	.mask		= asic3_mask_gpio_irq,
-	.unmask		= asic3_unmask_gpio_irq,
-	.set_type	= asic3_gpio_irq_type,
+	.irq_ack	= asic3_mask_gpio_irq,
+	.irq_mask	= asic3_mask_gpio_irq,
+	.irq_unmask	= asic3_unmask_gpio_irq,
+	.irq_set_type	= asic3_gpio_irq_type,
 };
 
 static struct irq_chip asic3_irq_chip = {
 	.name		= "ASIC3",
-	.ack		= asic3_mask_irq,
-	.mask		= asic3_mask_irq,
-	.unmask		= asic3_unmask_irq,
+	.irq_ack	= asic3_mask_irq,
+	.irq_mask	= asic3_mask_irq,
+	.irq_unmask	= asic3_unmask_irq,
 };
 
 static int __init asic3_irq_probe(struct platform_device *pdev)
-- 
1.7.1

