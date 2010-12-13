Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315Ab0LMMC6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 07:02:58 -0500
Received: from fw.wantstofly.org ([80.101.37.227]:37203 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757374Ab0LMMCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 07:02:55 -0500
Date: Mon, 13 Dec 2010 13:02:54 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Alek Du <alek.du@intel.com>, Alan Cox <alan@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 04/10] gpio: pca953x: irq_data conversion.
Message-ID: <20101213120254.GC15575@mail.wantstofly.org>
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
 drivers/gpio/pca953x.c |   38 +++++++++++++++++++-------------------
 1 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/gpio/pca953x.c b/drivers/gpio/pca953x.c
index 5018666..a261972 100644
--- a/drivers/gpio/pca953x.c
+++ b/drivers/gpio/pca953x.c
@@ -228,30 +228,30 @@ static int pca953x_gpio_to_irq(struct gpio_chip *gc, unsigned off)
 	return chip->irq_base + off;
 }
 
-static void pca953x_irq_mask(unsigned int irq)
+static void pca953x_irq_mask(struct irq_data *d)
 {
-	struct pca953x_chip *chip = get_irq_chip_data(irq);
+	struct pca953x_chip *chip = irq_data_get_irq_chip_data(d);
 
-	chip->irq_mask &= ~(1 << (irq - chip->irq_base));
+	chip->irq_mask &= ~(1 << (d->irq - chip->irq_base));
 }
 
-static void pca953x_irq_unmask(unsigned int irq)
+static void pca953x_irq_unmask(struct irq_data *d)
 {
-	struct pca953x_chip *chip = get_irq_chip_data(irq);
+	struct pca953x_chip *chip = irq_data_get_irq_chip_data(d);
 
-	chip->irq_mask |= 1 << (irq - chip->irq_base);
+	chip->irq_mask |= 1 << (d->irq - chip->irq_base);
 }
 
-static void pca953x_irq_bus_lock(unsigned int irq)
+static void pca953x_irq_bus_lock(struct irq_data *d)
 {
-	struct pca953x_chip *chip = get_irq_chip_data(irq);
+	struct pca953x_chip *chip = irq_data_get_irq_chip_data(d);
 
 	mutex_lock(&chip->irq_lock);
 }
 
-static void pca953x_irq_bus_sync_unlock(unsigned int irq)
+static void pca953x_irq_bus_sync_unlock(struct irq_data *d)
 {
-	struct pca953x_chip *chip = get_irq_chip_data(irq);
+	struct pca953x_chip *chip = irq_data_get_irq_chip_data(d);
 	uint16_t new_irqs;
 	uint16_t level;
 
@@ -268,15 +268,15 @@ static void pca953x_irq_bus_sync_unlock(unsigned int irq)
 	mutex_unlock(&chip->irq_lock);
 }
 
-static int pca953x_irq_set_type(unsigned int irq, unsigned int type)
+static int pca953x_irq_set_type(struct irq_data *d, unsigned int type)
 {
-	struct pca953x_chip *chip = get_irq_chip_data(irq);
-	uint16_t level = irq - chip->irq_base;
+	struct pca953x_chip *chip = irq_data_get_irq_chip_data(d);
+	uint16_t level = d->irq - chip->irq_base;
 	uint16_t mask = 1 << level;
 
 	if (!(type & IRQ_TYPE_EDGE_BOTH)) {
 		dev_err(&chip->client->dev, "irq %d: unsupported type %d\n",
-			irq, type);
+			d->irq, type);
 		return -EINVAL;
 	}
 
@@ -295,11 +295,11 @@ static int pca953x_irq_set_type(unsigned int irq, unsigned int type)
 
 static struct irq_chip pca953x_irq_chip = {
 	.name			= "pca953x",
-	.mask			= pca953x_irq_mask,
-	.unmask			= pca953x_irq_unmask,
-	.bus_lock		= pca953x_irq_bus_lock,
-	.bus_sync_unlock	= pca953x_irq_bus_sync_unlock,
-	.set_type		= pca953x_irq_set_type,
+	.irq_mask		= pca953x_irq_mask,
+	.irq_unmask		= pca953x_irq_unmask,
+	.irq_bus_lock		= pca953x_irq_bus_lock,
+	.irq_bus_sync_unlock	= pca953x_irq_bus_sync_unlock,
+	.irq_set_type		= pca953x_irq_set_type,
 };
 
 static uint16_t pca953x_irq_pending(struct pca953x_chip *chip)
-- 
1.7.1

