Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475Ab0LMMbA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 07:31:00 -0500
Received: from fw.wantstofly.org ([80.101.37.227]:36146 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757427Ab0LMMa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 07:30:59 -0500
Date: Mon, 13 Dec 2010 13:30:58 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Joonyoung Shim <jy0922.shim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 10/20] mfd: max8998: irq_data conversion.
Message-ID: <20101213123058.GT15575@mail.wantstofly.org>
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
 drivers/mfd/max8998-irq.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/mfd/max8998-irq.c b/drivers/mfd/max8998-irq.c
index 45bfe77..dca3c65 100644
--- a/drivers/mfd/max8998-irq.c
+++ b/drivers/mfd/max8998-irq.c
@@ -102,16 +102,16 @@ irq_to_max8998_irq(struct max8998_dev *max8998, int irq)
 	return &max8998_irqs[irq - max8998->irq_base];
 }
 
-static void max8998_irq_lock(unsigned int irq)
+static void max8998_irq_lock(struct irq_data *d)
 {
-	struct max8998_dev *max8998 = get_irq_chip_data(irq);
+	struct max8998_dev *max8998 = irq_data_get_irq_chip_data(d);
 
 	mutex_lock(&max8998->irqlock);
 }
 
-static void max8998_irq_sync_unlock(unsigned int irq)
+static void max8998_irq_sync_unlock(struct irq_data *d)
 {
-	struct max8998_dev *max8998 = get_irq_chip_data(irq);
+	struct max8998_dev *max8998 = irq_data_get_irq_chip_data(d);
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(max8998->irq_masks_cur); i++) {
@@ -129,28 +129,28 @@ static void max8998_irq_sync_unlock(unsigned int irq)
 	mutex_unlock(&max8998->irqlock);
 }
 
-static void max8998_irq_unmask(unsigned int irq)
+static void max8998_irq_unmask(struct irq_data *d)
 {
-	struct max8998_dev *max8998 = get_irq_chip_data(irq);
-	struct max8998_irq_data *irq_data = irq_to_max8998_irq(max8998, irq);
+	struct max8998_dev *max8998 = irq_data_get_irq_chip_data(d);
+	struct max8998_irq_data *irq_data = irq_to_max8998_irq(max8998, d->irq);
 
 	max8998->irq_masks_cur[irq_data->reg - 1] &= ~irq_data->mask;
 }
 
-static void max8998_irq_mask(unsigned int irq)
+static void max8998_irq_mask(struct irq_data *d)
 {
-	struct max8998_dev *max8998 = get_irq_chip_data(irq);
-	struct max8998_irq_data *irq_data = irq_to_max8998_irq(max8998, irq);
+	struct max8998_dev *max8998 = irq_data_get_irq_chip_data(d);
+	struct max8998_irq_data *irq_data = irq_to_max8998_irq(max8998, d->irq);
 
 	max8998->irq_masks_cur[irq_data->reg - 1] |= irq_data->mask;
 }
 
 static struct irq_chip max8998_irq_chip = {
 	.name = "max8998",
-	.bus_lock = max8998_irq_lock,
-	.bus_sync_unlock = max8998_irq_sync_unlock,
-	.mask = max8998_irq_mask,
-	.unmask = max8998_irq_unmask,
+	.irq_bus_lock = max8998_irq_lock,
+	.irq_bus_sync_unlock = max8998_irq_sync_unlock,
+	.irq_mask = max8998_irq_mask,
+	.irq_unmask = max8998_irq_unmask,
 };
 
 static irqreturn_t max8998_irq_thread(int irq, void *data)
-- 
1.7.1

