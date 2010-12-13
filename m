Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757424Ab0LMMDU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 07:03:20 -0500
Received: from fw.wantstofly.org ([80.101.37.227]:37218 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757309Ab0LMMDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 07:03:17 -0500
Date: Mon, 13 Dec 2010 13:03:15 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Richard =?iso-8859-1?Q?R=F6jfors?= 
	<richard.rojfors@mocean-labs.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 09/10] gpio: timbgpio: irq_data conversion.
Message-ID: <20101213120315.GH15575@mail.wantstofly.org>
References: <cover.1292240053.git.buytenh@wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1292240053.git.buytenh@wantstofly.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lennert Buytenhek <buytenh@secretlab.ca>
---
 drivers/gpio/timbgpio.c |   30 +++++++++++++++---------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/gpio/timbgpio.c b/drivers/gpio/timbgpio.c
index 4529366..349131e 100644
--- a/drivers/gpio/timbgpio.c
+++ b/drivers/gpio/timbgpio.c
@@ -109,10 +109,10 @@ static int timbgpio_to_irq(struct gpio_chip *gpio, unsigned offset)
 /*
  * GPIO IRQ
  */
-static void timbgpio_irq_disable(unsigned irq)
+static void timbgpio_irq_disable(struct irq_data *d)
 {
-	struct timbgpio *tgpio = get_irq_chip_data(irq);
-	int offset = irq - tgpio->irq_base;
+	struct timbgpio *tgpio = irq_data_get_irq_chip_data(d);
+	int offset = d->irq - tgpio->irq_base;
 	unsigned long flags;
 
 	spin_lock_irqsave(&tgpio->lock, flags);
@@ -121,10 +121,10 @@ static void timbgpio_irq_disable(unsigned irq)
 	spin_unlock_irqrestore(&tgpio->lock, flags);
 }
 
-static void timbgpio_irq_enable(unsigned irq)
+static void timbgpio_irq_enable(struct irq_data *d)
 {
-	struct timbgpio *tgpio = get_irq_chip_data(irq);
-	int offset = irq - tgpio->irq_base;
+	struct timbgpio *tgpio = irq_data_get_irq_chip_data(d);
+	int offset = d->irq - tgpio->irq_base;
 	unsigned long flags;
 
 	spin_lock_irqsave(&tgpio->lock, flags);
@@ -133,10 +133,10 @@ static void timbgpio_irq_enable(unsigned irq)
 	spin_unlock_irqrestore(&tgpio->lock, flags);
 }
 
-static int timbgpio_irq_type(unsigned irq, unsigned trigger)
+static int timbgpio_irq_type(struct irq_data *d, unsigned trigger)
 {
-	struct timbgpio *tgpio = get_irq_chip_data(irq);
-	int offset = irq - tgpio->irq_base;
+	struct timbgpio *tgpio = irq_data_get_irq_chip_data(d);
+	int offset = d->irq - tgpio->irq_base;
 	unsigned long flags;
 	u32 lvr, flr, bflr = 0;
 	u32 ver;
@@ -193,13 +193,13 @@ out:
 	return ret;
 }
 
-static void timbgpio_irq(unsigned int irq, struct irq_desc *desc)
+static void timbgpio_irq(struct irq_data *d, struct irq_desc *desc)
 {
-	struct timbgpio *tgpio = get_irq_data(irq);
+	struct timbgpio *tgpio = irq_data_get_irq_data(d);
 	unsigned long ipr;
 	int offset;
 
-	desc->chip->ack(irq);
+	desc->irq_data.chip->ack(irq_get_irq_data(d));
 	ipr = ioread32(tgpio->membase + TGPIO_IPR);
 	iowrite32(ipr, tgpio->membase + TGPIO_ICR);
 
@@ -217,9 +217,9 @@ static void timbgpio_irq(unsigned int irq, struct irq_desc *desc)
 
 static struct irq_chip timbgpio_irqchip = {
 	.name		= "GPIO",
-	.enable		= timbgpio_irq_enable,
-	.disable	= timbgpio_irq_disable,
-	.set_type	= timbgpio_irq_type,
+	.irq_enable	= timbgpio_irq_enable,
+	.irq_disable	= timbgpio_irq_disable,
+	.irq_set_type	= timbgpio_irq_type,
 };
 
 static int __devinit timbgpio_probe(struct platform_device *pdev)
-- 
1.7.1

