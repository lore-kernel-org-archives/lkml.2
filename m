Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436Ab0LMMDW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 07:03:22 -0500
Received: from fw.wantstofly.org ([80.101.37.227]:37215 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757398Ab0LMMDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 07:03:06 -0500
Date: Mon, 13 Dec 2010 13:03:05 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Rabin Vincent <rabin.vincent@stericsson.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 08/10] gpio: tc35892-gpio: irq_data conversion.
Message-ID: <20101213120305.GG15575@mail.wantstofly.org>
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
 drivers/gpio/tc35892-gpio.c |   36 ++++++++++++++++++------------------
 1 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/gpio/tc35892-gpio.c b/drivers/gpio/tc35892-gpio.c
index 7e10c93..867e44b 100644
--- a/drivers/gpio/tc35892-gpio.c
+++ b/drivers/gpio/tc35892-gpio.c
@@ -110,10 +110,10 @@ static struct gpio_chip template_chip = {
 	.can_sleep		= 1,
 };
 
-static int tc35892_gpio_irq_set_type(unsigned int irq, unsigned int type)
+static int tc35892_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 {
-	struct tc35892_gpio *tc35892_gpio = get_irq_chip_data(irq);
-	int offset = irq - tc35892_gpio->irq_base;
+	struct tc35892_gpio *tc35892_gpio = irq_data_get_irq_chip_data(d);
+	int offset = d->irq - tc35892_gpio->irq_base;
 	int regoffset = offset / 8;
 	int mask = 1 << (offset % 8);
 
@@ -137,16 +137,16 @@ static int tc35892_gpio_irq_set_type(unsigned int irq, unsigned int type)
 	return 0;
 }
 
-static void tc35892_gpio_irq_lock(unsigned int irq)
+static void tc35892_gpio_irq_lock(struct irq_data *d)
 {
-	struct tc35892_gpio *tc35892_gpio = get_irq_chip_data(irq);
+	struct tc35892_gpio *tc35892_gpio = irq_data_get_irq_chip_data(d);
 
 	mutex_lock(&tc35892_gpio->irq_lock);
 }
 
-static void tc35892_gpio_irq_sync_unlock(unsigned int irq)
+static void tc35892_gpio_irq_sync_unlock(struct irq_data *d)
 {
-	struct tc35892_gpio *tc35892_gpio = get_irq_chip_data(irq);
+	struct tc35892_gpio *tc35892_gpio = irq_data_get_irq_chip_data(d);
 	struct tc35892 *tc35892 = tc35892_gpio->tc35892;
 	static const u8 regmap[] = {
 		[REG_IBE]	= TC35892_GPIOIBE0,
@@ -172,20 +172,20 @@ static void tc35892_gpio_irq_sync_unlock(unsigned int irq)
 	mutex_unlock(&tc35892_gpio->irq_lock);
 }
 
-static void tc35892_gpio_irq_mask(unsigned int irq)
+static void tc35892_gpio_irq_mask(struct irq_data *d)
 {
-	struct tc35892_gpio *tc35892_gpio = get_irq_chip_data(irq);
-	int offset = irq - tc35892_gpio->irq_base;
+	struct tc35892_gpio *tc35892_gpio = irq_data_get_irq_chip_data(d);
+	int offset = d->irq - tc35892_gpio->irq_base;
 	int regoffset = offset / 8;
 	int mask = 1 << (offset % 8);
 
 	tc35892_gpio->regs[REG_IE][regoffset] &= ~mask;
 }
 
-static void tc35892_gpio_irq_unmask(unsigned int irq)
+static void tc35892_gpio_irq_unmask(struct irq_data *d)
 {
-	struct tc35892_gpio *tc35892_gpio = get_irq_chip_data(irq);
-	int offset = irq - tc35892_gpio->irq_base;
+	struct tc35892_gpio *tc35892_gpio = irq_data_get_irq_chip_data(d);
+	int offset = d->irq - tc35892_gpio->irq_base;
 	int regoffset = offset / 8;
 	int mask = 1 << (offset % 8);
 
@@ -194,11 +194,11 @@ static void tc35892_gpio_irq_unmask(unsigned int irq)
 
 static struct irq_chip tc35892_gpio_irq_chip = {
 	.name			= "tc35892-gpio",
-	.bus_lock		= tc35892_gpio_irq_lock,
-	.bus_sync_unlock	= tc35892_gpio_irq_sync_unlock,
-	.mask			= tc35892_gpio_irq_mask,
-	.unmask			= tc35892_gpio_irq_unmask,
-	.set_type		= tc35892_gpio_irq_set_type,
+	.irq_bus_lock		= tc35892_gpio_irq_lock,
+	.irq_bus_sync_unlock	= tc35892_gpio_irq_sync_unlock,
+	.irq_mask		= tc35892_gpio_irq_mask,
+	.irq_unmask		= tc35892_gpio_irq_unmask,
+	.irq_set_type		= tc35892_gpio_irq_set_type,
 };
 
 static irqreturn_t tc35892_gpio_irq(int irq, void *dev)
-- 
1.7.1

