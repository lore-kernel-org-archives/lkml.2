Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620Ab0LMMe0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 07:34:26 -0500
Received: from fw.wantstofly.org ([80.101.37.227]:41614 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631Ab0LMMeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 07:34:24 -0500
Date: Mon, 13 Dec 2010 13:34:23 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Florian Fainelli <florian@openwrt.org>, openwrt-devel@lists.openwrt.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] vlynq: irq_data conversion.
Message-ID: <20101213123423.GE15575@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lennert Buytenhek <buytenh@secretlab.ca>
---
 drivers/vlynq/vlynq.c |   44 ++++++++++++++++++++++----------------------
 1 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/vlynq/vlynq.c b/drivers/vlynq/vlynq.c
index f885c86..c9f22c8 100644
--- a/drivers/vlynq/vlynq.c
+++ b/drivers/vlynq/vlynq.c
@@ -135,40 +135,40 @@ static void vlynq_reset(struct vlynq_device *dev)
 	msleep(5);
 }
 
-static void vlynq_irq_unmask(unsigned int irq)
+static void vlynq_irq_unmask(struct irq_data *d)
 {
 	u32 val;
-	struct vlynq_device *dev = get_irq_chip_data(irq);
+	struct vlynq_device *dev = irq_data_get_irq_chip_data(d);
 	int virq;
 
 	BUG_ON(!dev);
-	virq = irq - dev->irq_start;
+	virq = d->irq - dev->irq_start;
 	val = readl(&dev->remote->int_device[virq >> 2]);
 	val |= (VINT_ENABLE | virq) << VINT_OFFSET(virq);
 	writel(val, &dev->remote->int_device[virq >> 2]);
 }
 
-static void vlynq_irq_mask(unsigned int irq)
+static void vlynq_irq_mask(struct irq_data *d)
 {
 	u32 val;
-	struct vlynq_device *dev = get_irq_chip_data(irq);
+	struct vlynq_device *dev = irq_data_get_irq_chip_data(d);
 	int virq;
 
 	BUG_ON(!dev);
-	virq = irq - dev->irq_start;
+	virq = d->irq - dev->irq_start;
 	val = readl(&dev->remote->int_device[virq >> 2]);
 	val &= ~(VINT_ENABLE << VINT_OFFSET(virq));
 	writel(val, &dev->remote->int_device[virq >> 2]);
 }
 
-static int vlynq_irq_type(unsigned int irq, unsigned int flow_type)
+static int vlynq_irq_type(struct irq_data *d, unsigned int flow_type)
 {
 	u32 val;
-	struct vlynq_device *dev = get_irq_chip_data(irq);
+	struct vlynq_device *dev = irq_data_get_irq_chip_data(d);
 	int virq;
 
 	BUG_ON(!dev);
-	virq = irq - dev->irq_start;
+	virq = d->irq - dev->irq_start;
 	val = readl(&dev->remote->int_device[virq >> 2]);
 	switch (flow_type & IRQ_TYPE_SENSE_MASK) {
 	case IRQ_TYPE_EDGE_RISING:
@@ -192,9 +192,9 @@ static int vlynq_irq_type(unsigned int irq, unsigned int flow_type)
 	return 0;
 }
 
-static void vlynq_local_ack(unsigned int irq)
+static void vlynq_local_ack(struct irq_data *d)
 {
-	struct vlynq_device *dev = get_irq_chip_data(irq);
+	struct vlynq_device *dev = irq_data_get_irq_chip_data(d);
 
 	u32 status = readl(&dev->local->status);
 
@@ -203,9 +203,9 @@ static void vlynq_local_ack(unsigned int irq)
 	writel(status, &dev->local->status);
 }
 
-static void vlynq_remote_ack(unsigned int irq)
+static void vlynq_remote_ack(struct irq_data *d)
 {
-	struct vlynq_device *dev = get_irq_chip_data(irq);
+	struct vlynq_device *dev = irq_data_get_irq_chip_data(d);
 
 	u32 status = readl(&dev->remote->status);
 
@@ -238,23 +238,23 @@ static irqreturn_t vlynq_irq(int irq, void *dev_id)
 
 static struct irq_chip vlynq_irq_chip = {
 	.name = "vlynq",
-	.unmask = vlynq_irq_unmask,
-	.mask = vlynq_irq_mask,
-	.set_type = vlynq_irq_type,
+	.irq_unmask = vlynq_irq_unmask,
+	.irq_mask = vlynq_irq_mask,
+	.irq_set_type = vlynq_irq_type,
 };
 
 static struct irq_chip vlynq_local_chip = {
 	.name = "vlynq local error",
-	.unmask = vlynq_irq_unmask,
-	.mask = vlynq_irq_mask,
-	.ack = vlynq_local_ack,
+	.irq_unmask = vlynq_irq_unmask,
+	.irq_mask = vlynq_irq_mask,
+	.irq_ack = vlynq_local_ack,
 };
 
 static struct irq_chip vlynq_remote_chip = {
 	.name = "vlynq local error",
-	.unmask = vlynq_irq_unmask,
-	.mask = vlynq_irq_mask,
-	.ack = vlynq_remote_ack,
+	.irq_unmask = vlynq_irq_unmask,
+	.irq_mask = vlynq_irq_mask,
+	.irq_ack = vlynq_remote_ack,
 };
 
 static int vlynq_setup_irq(struct vlynq_device *dev)
-- 
1.7.1
