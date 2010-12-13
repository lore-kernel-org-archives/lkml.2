Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490Ab0LMMbH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 07:31:07 -0500
Received: from fw.wantstofly.org ([80.101.37.227]:36150 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757289Ab0LMMbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 07:31:03 -0500
Date: Mon, 13 Dec 2010 13:31:02 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Rabin Vincent <rabin.vincent@stericsson.com>,
        Luotao Fu <l.fu@pengutronix.de>,
        Linus Walleij <linus.walleij@stericsson.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 11/20] mfd: stmpe: irq_data conversion.
Message-ID: <20101213123102.GU15575@mail.wantstofly.org>
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
 drivers/mfd/stmpe.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
index b11487f..f319818 100644
--- a/drivers/mfd/stmpe.c
+++ b/drivers/mfd/stmpe.c
@@ -699,16 +699,16 @@ static irqreturn_t stmpe_irq(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static void stmpe_irq_lock(unsigned int irq)
+static void stmpe_irq_lock(struct irq_data *d)
 {
-	struct stmpe *stmpe = get_irq_chip_data(irq);
+	struct stmpe *stmpe = irq_data_get_irq_chip_data(d);
 
 	mutex_lock(&stmpe->irq_lock);
 }
 
-static void stmpe_irq_sync_unlock(unsigned int irq)
+static void stmpe_irq_sync_unlock(struct irq_data *d)
 {
-	struct stmpe *stmpe = get_irq_chip_data(irq);
+	struct stmpe *stmpe = irq_data_get_irq_chip_data(d);
 	struct stmpe_variant_info *variant = stmpe->variant;
 	int num = DIV_ROUND_UP(variant->num_irqs, 8);
 	int i;
@@ -727,20 +727,20 @@ static void stmpe_irq_sync_unlock(unsigned int irq)
 	mutex_unlock(&stmpe->irq_lock);
 }
 
-static void stmpe_irq_mask(unsigned int irq)
+static void stmpe_irq_mask(struct irq_data *d)
 {
-	struct stmpe *stmpe = get_irq_chip_data(irq);
-	int offset = irq - stmpe->irq_base;
+	struct stmpe *stmpe = irq_data_get_irq_chip_data(d);
+	int offset = d->irq - stmpe->irq_base;
 	int regoffset = offset / 8;
 	int mask = 1 << (offset % 8);
 
 	stmpe->ier[regoffset] &= ~mask;
 }
 
-static void stmpe_irq_unmask(unsigned int irq)
+static void stmpe_irq_unmask(struct irq_data *d)
 {
-	struct stmpe *stmpe = get_irq_chip_data(irq);
-	int offset = irq - stmpe->irq_base;
+	struct stmpe *stmpe = irq_data_get_irq_chip_data(d);
+	int offset = d->irq - stmpe->irq_base;
 	int regoffset = offset / 8;
 	int mask = 1 << (offset % 8);
 
@@ -749,10 +749,10 @@ static void stmpe_irq_unmask(unsigned int irq)
 
 static struct irq_chip stmpe_irq_chip = {
 	.name			= "stmpe",
-	.bus_lock		= stmpe_irq_lock,
-	.bus_sync_unlock	= stmpe_irq_sync_unlock,
-	.mask			= stmpe_irq_mask,
-	.unmask			= stmpe_irq_unmask,
+	.irq_bus_lock		= stmpe_irq_lock,
+	.irq_bus_sync_unlock	= stmpe_irq_sync_unlock,
+	.irq_mask		= stmpe_irq_mask,
+	.irq_unmask		= stmpe_irq_unmask,
 };
 
 static int __devinit stmpe_irq_init(struct stmpe *stmpe)
-- 
1.7.1

