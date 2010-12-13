Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371Ab0LMMCx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 07:02:53 -0500
Received: from fw.wantstofly.org ([80.101.37.227]:37197 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757317Ab0LMMCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 07:02:51 -0500
Date: Mon, 13 Dec 2010 13:02:50 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Marc Zyngier <maz@misterjones.org>, Eric Miao <eric.y.miao@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 03/10] gpio: max732x: irq_data conversion.
Message-ID: <20101213120250.GB15575@mail.wantstofly.org>
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
 drivers/gpio/max732x.c |   38 +++++++++++++++++++-------------------
 1 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/gpio/max732x.c b/drivers/gpio/max732x.c
index 9cad60f..9e1d01f 100644
--- a/drivers/gpio/max732x.c
+++ b/drivers/gpio/max732x.c
@@ -327,40 +327,40 @@ static int max732x_gpio_to_irq(struct gpio_chip *gc, unsigned off)
 	return chip->irq_base + off;
 }
 
-static void max732x_irq_mask(unsigned int irq)
+static void max732x_irq_mask(struct irq_data *d)
 {
-	struct max732x_chip *chip = get_irq_chip_data(irq);
+	struct max732x_chip *chip = irq_data_get_irq_chip_data(d);
 
-	chip->irq_mask_cur &= ~(1 << (irq - chip->irq_base));
+	chip->irq_mask_cur &= ~(1 << (d->irq - chip->irq_base));
 }
 
-static void max732x_irq_unmask(unsigned int irq)
+static void max732x_irq_unmask(struct irq_data *d)
 {
-	struct max732x_chip *chip = get_irq_chip_data(irq);
+	struct max732x_chip *chip = irq_data_get_irq_chip_data(d);
 
-	chip->irq_mask_cur |= 1 << (irq - chip->irq_base);
+	chip->irq_mask_cur |= 1 << (d->irq - chip->irq_base);
 }
 
-static void max732x_irq_bus_lock(unsigned int irq)
+static void max732x_irq_bus_lock(struct irq_data *d)
 {
-	struct max732x_chip *chip = get_irq_chip_data(irq);
+	struct max732x_chip *chip = irq_data_get_irq_chip_data(d);
 
 	mutex_lock(&chip->irq_lock);
 	chip->irq_mask_cur = chip->irq_mask;
 }
 
-static void max732x_irq_bus_sync_unlock(unsigned int irq)
+static void max732x_irq_bus_sync_unlock(struct irq_data *d)
 {
-	struct max732x_chip *chip = get_irq_chip_data(irq);
+	struct max732x_chip *chip = irq_data_get_irq_chip_data(d);
 
 	max732x_irq_update_mask(chip);
 	mutex_unlock(&chip->irq_lock);
 }
 
-static int max732x_irq_set_type(unsigned int irq, unsigned int type)
+static int max732x_irq_set_type(struct irq_data *d, unsigned int type)
 {
-	struct max732x_chip *chip = get_irq_chip_data(irq);
-	uint16_t off = irq - chip->irq_base;
+	struct max732x_chip *chip = irq_data_get_irq_chip_data(d);
+	uint16_t off = d->irq - chip->irq_base;
 	uint16_t mask = 1 << off;
 
 	if (!(mask & chip->dir_input)) {
@@ -371,7 +371,7 @@ static int max732x_irq_set_type(unsigned int irq, unsigned int type)
 
 	if (!(type & IRQ_TYPE_EDGE_BOTH)) {
 		dev_err(&chip->client->dev, "irq %d: unsupported type %d\n",
-			irq, type);
+			d->irq, type);
 		return -EINVAL;
 	}
 
@@ -390,11 +390,11 @@ static int max732x_irq_set_type(unsigned int irq, unsigned int type)
 
 static struct irq_chip max732x_irq_chip = {
 	.name			= "max732x",
-	.mask			= max732x_irq_mask,
-	.unmask			= max732x_irq_unmask,
-	.bus_lock		= max732x_irq_bus_lock,
-	.bus_sync_unlock	= max732x_irq_bus_sync_unlock,
-	.set_type		= max732x_irq_set_type,
+	.irq_mask		= max732x_irq_mask,
+	.irq_unmask		= max732x_irq_unmask,
+	.irq_bus_lock		= max732x_irq_bus_lock,
+	.irq_bus_sync_unlock	= max732x_irq_bus_sync_unlock,
+	.irq_set_type		= max732x_irq_set_type,
 };
 
 static uint8_t max732x_irq_pending(struct max732x_chip *chip)
-- 
1.7.1

