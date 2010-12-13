Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326Ab0LMM3p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 07:29:45 -0500
Received: from fw.wantstofly.org ([80.101.37.227]:36123 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756858Ab0LMM3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 07:29:43 -0500
Date: Mon, 13 Dec 2010 13:29:41 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Mattias Wallin <mattias.wallin@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 02/20] mfd: ab3550: irq_data conversion.
Message-ID: <20101213122941.GL15575@mail.wantstofly.org>
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
 drivers/mfd/ab3550-core.c |   32 +++++++++++++++++---------------
 1 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/mfd/ab3550-core.c b/drivers/mfd/ab3550-core.c
index 8a98739..0fefb54 100644
--- a/drivers/mfd/ab3550-core.c
+++ b/drivers/mfd/ab3550-core.c
@@ -1159,15 +1159,16 @@ static void ab3550_mask_work(struct work_struct *work)
 	}
 }
 
-static void ab3550_mask(unsigned int irq)
+static void ab3550_mask(struct irq_data *d)
 {
 	unsigned long flags;
 	struct ab3550 *ab;
 	struct ab3550_platform_data *plf_data;
+	unsigned int irq;
 
-	ab = get_irq_chip_data(irq);
+	ab = irq_data_get_irq_chip_data(d);
 	plf_data = ab->i2c_client[0]->dev.platform_data;
-	irq -= plf_data->irq.base;
+	irq = d->irq - plf_data->irq.base;
 
 	spin_lock_irqsave(&ab->event_lock, flags);
 	ab->event_mask[irq / 8] |= BIT(irq % 8);
@@ -1176,15 +1177,16 @@ static void ab3550_mask(unsigned int irq)
 	schedule_work(&ab->mask_work);
 }
 
-static void ab3550_unmask(unsigned int irq)
+static void ab3550_unmask(struct irq_data *d)
 {
 	unsigned long flags;
 	struct ab3550 *ab;
 	struct ab3550_platform_data *plf_data;
+	unsigned int irq;
 
-	ab = get_irq_chip_data(irq);
+	ab = irq_data_get_irq_chip_data(d);
 	plf_data = ab->i2c_client[0]->dev.platform_data;
-	irq -= plf_data->irq.base;
+	irq = d->irq - plf_data->irq.base;
 
 	spin_lock_irqsave(&ab->event_lock, flags);
 	ab->event_mask[irq / 8] &= ~BIT(irq % 8);
@@ -1193,20 +1195,20 @@ static void ab3550_unmask(unsigned int irq)
 	schedule_work(&ab->mask_work);
 }
 
-static void noop(unsigned int irq)
+static void noop(struct irq_data *d)
 {
 }
 
 static struct irq_chip ab3550_irq_chip = {
 	.name		= "ab3550-core", /* Keep the same name as the request */
-	.startup	= NULL, /* defaults to enable */
-	.shutdown	= NULL, /* defaults to disable */
-	.enable		= NULL, /* defaults to unmask */
-	.disable	= ab3550_mask, /* No default to mask in chip.c */
-	.ack		= noop,
-	.mask		= ab3550_mask,
-	.unmask		= ab3550_unmask,
-	.end		= NULL,
+	.irq_startup	= NULL, /* defaults to enable */
+	.irq_shutdown	= NULL, /* defaults to disable */
+	.irq_enable	= NULL, /* defaults to unmask */
+	.irq_disable	= ab3550_mask, /* No default to mask in chip.c */
+	.irq_ack	= noop,
+	.irq_mask	= ab3550_mask,
+	.irq_unmask	= ab3550_unmask,
+	.irq_end	= NULL,
 };
 
 struct ab_family_id {
-- 
1.7.1

