Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417Ab0LMMD6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 07:03:58 -0500
Received: from fw.wantstofly.org ([80.101.37.227]:37208 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757374Ab0LMMDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 07:03:00 -0500
Date: Mon, 13 Dec 2010 13:02:59 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Rabin Vincent <rabin.vincent@stericsson.com>,
        Luotao Fu <l.fu@pengutronix.de>,
        Linus Walleij <linus.walleij@stericsson.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 06/10] gpio: stmpe-gpio: irq_data conversion.
Message-ID: <20101213120259.GE15575@mail.wantstofly.org>
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
 drivers/gpio/stmpe-gpio.c |   36 ++++++++++++++++++------------------
 1 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/gpio/stmpe-gpio.c b/drivers/gpio/stmpe-gpio.c
index 7c9e6a0..eb2901f 100644
--- a/drivers/gpio/stmpe-gpio.c
+++ b/drivers/gpio/stmpe-gpio.c
@@ -122,10 +122,10 @@ static struct gpio_chip template_chip = {
 	.can_sleep		= 1,
 };
 
-static int stmpe_gpio_irq_set_type(unsigned int irq, unsigned int type)
+static int stmpe_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 {
-	struct stmpe_gpio *stmpe_gpio = get_irq_chip_data(irq);
-	int offset = irq - stmpe_gpio->irq_base;
+	struct stmpe_gpio *stmpe_gpio = irq_data_get_irq_chip_data(d);
+	int offset = d->irq - stmpe_gpio->irq_base;
 	int regoffset = offset / 8;
 	int mask = 1 << (offset % 8);
 
@@ -145,16 +145,16 @@ static int stmpe_gpio_irq_set_type(unsigned int irq, unsigned int type)
 	return 0;
 }
 
-static void stmpe_gpio_irq_lock(unsigned int irq)
+static void stmpe_gpio_irq_lock(struct irq_data *d)
 {
-	struct stmpe_gpio *stmpe_gpio = get_irq_chip_data(irq);
+	struct stmpe_gpio *stmpe_gpio = irq_data_get_irq_chip_data(d);
 
 	mutex_lock(&stmpe_gpio->irq_lock);
 }
 
-static void stmpe_gpio_irq_sync_unlock(unsigned int irq)
+static void stmpe_gpio_irq_sync_unlock(struct irq_data *d)
 {
-	struct stmpe_gpio *stmpe_gpio = get_irq_chip_data(irq);
+	struct stmpe_gpio *stmpe_gpio = irq_data_get_irq_chip_data(d);
 	struct stmpe *stmpe = stmpe_gpio->stmpe;
 	int num_banks = DIV_ROUND_UP(stmpe->num_gpios, 8);
 	static const u8 regmap[] = {
@@ -180,20 +180,20 @@ static void stmpe_gpio_irq_sync_unlock(unsigned int irq)
 	mutex_unlock(&stmpe_gpio->irq_lock);
 }
 
-static void stmpe_gpio_irq_mask(unsigned int irq)
+static void stmpe_gpio_irq_mask(struct irq_data *d)
 {
-	struct stmpe_gpio *stmpe_gpio = get_irq_chip_data(irq);
-	int offset = irq - stmpe_gpio->irq_base;
+	struct stmpe_gpio *stmpe_gpio = irq_data_get_irq_chip_data(d);
+	int offset = d->irq - stmpe_gpio->irq_base;
 	int regoffset = offset / 8;
 	int mask = 1 << (offset % 8);
 
 	stmpe_gpio->regs[REG_IE][regoffset] &= ~mask;
 }
 
-static void stmpe_gpio_irq_unmask(unsigned int irq)
+static void stmpe_gpio_irq_unmask(struct irq_data *d)
 {
-	struct stmpe_gpio *stmpe_gpio = get_irq_chip_data(irq);
-	int offset = irq - stmpe_gpio->irq_base;
+	struct stmpe_gpio *stmpe_gpio = irq_data_get_irq_chip_data(d);
+	int offset = d->irq - stmpe_gpio->irq_base;
 	int regoffset = offset / 8;
 	int mask = 1 << (offset % 8);
 
@@ -202,11 +202,11 @@ static void stmpe_gpio_irq_unmask(unsigned int irq)
 
 static struct irq_chip stmpe_gpio_irq_chip = {
 	.name			= "stmpe-gpio",
-	.bus_lock		= stmpe_gpio_irq_lock,
-	.bus_sync_unlock	= stmpe_gpio_irq_sync_unlock,
-	.mask			= stmpe_gpio_irq_mask,
-	.unmask			= stmpe_gpio_irq_unmask,
-	.set_type		= stmpe_gpio_irq_set_type,
+	.irq_bus_lock		= stmpe_gpio_irq_lock,
+	.irq_bus_sync_unlock	= stmpe_gpio_irq_sync_unlock,
+	.irq_mask		= stmpe_gpio_irq_mask,
+	.irq_unmask		= stmpe_gpio_irq_unmask,
+	.irq_set_type		= stmpe_gpio_irq_set_type,
 };
 
 static irqreturn_t stmpe_gpio_irq(int irq, void *dev)
-- 
1.7.1

