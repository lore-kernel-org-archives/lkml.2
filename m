Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab0LMM3f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 07:29:35 -0500
Received: from fw.wantstofly.org ([80.101.37.227]:36119 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164Ab0LMM3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 07:29:33 -0500
Date: Mon, 13 Dec 2010 13:29:32 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 01/20] mfd: 88pm860x-core: irq_data conversion.
Message-ID: <20101213122932.GK15575@mail.wantstofly.org>
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
 drivers/mfd/88pm860x-core.c |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/mfd/88pm860x-core.c b/drivers/mfd/88pm860x-core.c
index 20895e7..5995015 100644
--- a/drivers/mfd/88pm860x-core.c
+++ b/drivers/mfd/88pm860x-core.c
@@ -388,16 +388,16 @@ static irqreturn_t pm860x_irq(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static void pm860x_irq_lock(unsigned int irq)
+static void pm860x_irq_lock(struct irq_data *d)
 {
-	struct pm860x_chip *chip = get_irq_chip_data(irq);
+	struct pm860x_chip *chip = irq_data_get_irq_chip_data(d);
 
 	mutex_lock(&chip->irq_lock);
 }
 
-static void pm860x_irq_sync_unlock(unsigned int irq)
+static void pm860x_irq_sync_unlock(struct irq_data *d)
 {
-	struct pm860x_chip *chip = get_irq_chip_data(irq);
+	struct pm860x_chip *chip = irq_data_get_irq_chip_data(d);
 	struct pm860x_irq_data *irq_data;
 	struct i2c_client *i2c;
 	static unsigned char cached[3] = {0x0, 0x0, 0x0};
@@ -439,25 +439,25 @@ static void pm860x_irq_sync_unlock(unsigned int irq)
 	mutex_unlock(&chip->irq_lock);
 }
 
-static void pm860x_irq_enable(unsigned int irq)
+static void pm860x_irq_enable(struct irq_data *d)
 {
-	struct pm860x_chip *chip = get_irq_chip_data(irq);
-	pm860x_irqs[irq - chip->irq_base].enable
-		= pm860x_irqs[irq - chip->irq_base].offs;
+	struct pm860x_chip *chip = irq_data_get_irq_chip_data(d);
+	pm860x_irqs[d->irq - chip->irq_base].enable
+		= pm860x_irqs[d->irq - chip->irq_base].offs;
 }
 
-static void pm860x_irq_disable(unsigned int irq)
+static void pm860x_irq_disable(struct irq_data *d)
 {
-	struct pm860x_chip *chip = get_irq_chip_data(irq);
-	pm860x_irqs[irq - chip->irq_base].enable = 0;
+	struct pm860x_chip *chip = irq_data_get_irq_chip_data(d);
+	pm860x_irqs[d->irq - chip->irq_base].enable = 0;
 }
 
 static struct irq_chip pm860x_irq_chip = {
-	.name		= "88pm860x",
-	.bus_lock	= pm860x_irq_lock,
-	.bus_sync_unlock = pm860x_irq_sync_unlock,
-	.enable		= pm860x_irq_enable,
-	.disable	= pm860x_irq_disable,
+	.name			= "88pm860x",
+	.irq_bus_lock		= pm860x_irq_lock,
+	.irq_bus_sync_unlock	= pm860x_irq_sync_unlock,
+	.irq_enable		= pm860x_irq_enable,
+	.irq_disable		= pm860x_irq_disable,
 };
 
 static int __devinit device_gpadc_init(struct pm860x_chip *chip,
-- 
1.7.1

