Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463Ab0LMMaz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 07:30:55 -0500
Received: from fw.wantstofly.org ([80.101.37.227]:36143 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449Ab0LMMay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 07:30:54 -0500
Date: Mon, 13 Dec 2010 13:30:53 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 09/20] mfd: max8925: irq_data conversion.
Message-ID: <20101213123052.GS15575@mail.wantstofly.org>
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
 drivers/mfd/max8925-core.c |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/mfd/max8925-core.c b/drivers/mfd/max8925-core.c
index 44695f5..78046ae 100644
--- a/drivers/mfd/max8925-core.c
+++ b/drivers/mfd/max8925-core.c
@@ -407,16 +407,16 @@ static irqreturn_t max8925_tsc_irq(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static void max8925_irq_lock(unsigned int irq)
+static void max8925_irq_lock(struct irq_data *d)
 {
-	struct max8925_chip *chip = get_irq_chip_data(irq);
+	struct max8925_chip *chip = irq_data_get_irq_chip_data(d);
 
 	mutex_lock(&chip->irq_lock);
 }
 
-static void max8925_irq_sync_unlock(unsigned int irq)
+static void max8925_irq_sync_unlock(struct irq_data *d)
 {
-	struct max8925_chip *chip = get_irq_chip_data(irq);
+	struct max8925_chip *chip = irq_data_get_irq_chip_data(d);
 	struct max8925_irq_data *irq_data;
 	static unsigned char cache_chg[2] = {0xff, 0xff};
 	static unsigned char cache_on[2] = {0xff, 0xff};
@@ -492,25 +492,25 @@ static void max8925_irq_sync_unlock(unsigned int irq)
 	mutex_unlock(&chip->irq_lock);
 }
 
-static void max8925_irq_enable(unsigned int irq)
+static void max8925_irq_enable(struct irq_data *d)
 {
-	struct max8925_chip *chip = get_irq_chip_data(irq);
-	max8925_irqs[irq - chip->irq_base].enable
-		= max8925_irqs[irq - chip->irq_base].offs;
+	struct max8925_chip *chip = irq_data_get_irq_chip_data(d);
+	max8925_irqs[d->irq - chip->irq_base].enable
+		= max8925_irqs[d->irq - chip->irq_base].offs;
 }
 
-static void max8925_irq_disable(unsigned int irq)
+static void max8925_irq_disable(struct irq_data *d)
 {
-	struct max8925_chip *chip = get_irq_chip_data(irq);
-	max8925_irqs[irq - chip->irq_base].enable = 0;
+	struct max8925_chip *chip = irq_data_get_irq_chip_data(d);
+	max8925_irqs[d->irq - chip->irq_base].enable = 0;
 }
 
 static struct irq_chip max8925_irq_chip = {
-	.name		= "max8925",
-	.bus_lock	= max8925_irq_lock,
-	.bus_sync_unlock = max8925_irq_sync_unlock,
-	.enable		= max8925_irq_enable,
-	.disable	= max8925_irq_disable,
+	.name			= "max8925",
+	.irq_bus_lock		= max8925_irq_lock,
+	.irq_bus_sync_unlock	= max8925_irq_sync_unlock,
+	.irq_enable		= max8925_irq_enable,
+	.irq_disable		= max8925_irq_disable,
 };
 
 static int max8925_irq_init(struct max8925_chip *chip, int irq,
-- 
1.7.1

