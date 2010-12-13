Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354Ab0LMMCr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 07:02:47 -0500
Received: from fw.wantstofly.org ([80.101.37.227]:37193 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757290Ab0LMMCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 07:02:44 -0500
Date: Mon, 13 Dec 2010 13:02:43 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Alan Cox <alan@linux.intel.com>, Yin Kangkai <kangkai.yin@intel.com>,
        Alek Du <alek.du@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 02/10] gpio: langwell_gpio: irq_data conversion.
Message-ID: <20101213120243.GA15575@mail.wantstofly.org>
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
 drivers/gpio/langwell_gpio.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/gpio/langwell_gpio.c b/drivers/gpio/langwell_gpio.c
index 64db9dc..d81cc74 100644
--- a/drivers/gpio/langwell_gpio.c
+++ b/drivers/gpio/langwell_gpio.c
@@ -134,10 +134,10 @@ static int lnw_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
 	return lnw->irq_base + offset;
 }
 
-static int lnw_irq_type(unsigned irq, unsigned type)
+static int lnw_irq_type(struct irq_data *d, unsigned type)
 {
-	struct lnw_gpio *lnw = get_irq_chip_data(irq);
-	u32 gpio = irq - lnw->irq_base;
+	struct lnw_gpio *lnw = irq_data_get_irq_chip_data(d);
+	u32 gpio = d->irq - lnw->irq_base;
 	unsigned long flags;
 	u32 value;
 	void __iomem *grer = gpio_reg(&lnw->chip, gpio, GRER);
@@ -162,19 +162,19 @@ static int lnw_irq_type(unsigned irq, unsigned type)
 	return 0;
 }
 
-static void lnw_irq_unmask(unsigned irq)
+static void lnw_irq_unmask(struct irq_data *d)
 {
 }
 
-static void lnw_irq_mask(unsigned irq)
+static void lnw_irq_mask(struct irq_data *d)
 {
 }
 
 static struct irq_chip lnw_irqchip = {
 	.name		= "LNW-GPIO",
-	.mask		= lnw_irq_mask,
-	.unmask		= lnw_irq_unmask,
-	.set_type	= lnw_irq_type,
+	.irq_mask	= lnw_irq_mask,
+	.irq_unmask	= lnw_irq_unmask,
+	.irq_set_type	= lnw_irq_type,
 };
 
 static DEFINE_PCI_DEVICE_TABLE(lnw_gpio_ids) = {   /* pin number */
-- 
1.7.1

