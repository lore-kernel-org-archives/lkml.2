Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421Ab0LMMaT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 07:30:19 -0500
Received: from fw.wantstofly.org ([80.101.37.227]:36134 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757042Ab0LMMaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 07:30:16 -0500
Date: Mon, 13 Dec 2010 13:30:15 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Philipp Zabel <philipp.zabel@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 06/20] mfd: htc-egpio: irq_data conversion.
Message-ID: <20101213123015.GP15575@mail.wantstofly.org>
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
 drivers/mfd/htc-egpio.c |   27 ++++++++++++++-------------
 1 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/mfd/htc-egpio.c b/drivers/mfd/htc-egpio.c
index d3e74f8..a420a76 100644
--- a/drivers/mfd/htc-egpio.c
+++ b/drivers/mfd/htc-egpio.c
@@ -70,31 +70,32 @@ static inline void ack_irqs(struct egpio_info *ei)
 			ei->ack_write, ei->ack_register << ei->bus_shift);
 }
 
-static void egpio_ack(unsigned int irq)
+static void egpio_ack(struct irq_data *d)
 {
 }
 
 /* There does not appear to be a way to proactively mask interrupts
  * on the egpio chip itself.  So, we simply ignore interrupts that
  * aren't desired. */
-static void egpio_mask(unsigned int irq)
+static void egpio_mask(struct irq_data *d)
 {
-	struct egpio_info *ei = get_irq_chip_data(irq);
-	ei->irqs_enabled &= ~(1 << (irq - ei->irq_start));
-	pr_debug("EGPIO mask %d %04x\n", irq, ei->irqs_enabled);
+	struct egpio_info *ei = irq_data_get_irq_chip_data(d);
+	ei->irqs_enabled &= ~(1 << (d->irq - ei->irq_start));
+	pr_debug("EGPIO mask %d %04x\n", d->irq, ei->irqs_enabled);
 }
-static void egpio_unmask(unsigned int irq)
+
+static void egpio_unmask(struct irq_data *d)
 {
-	struct egpio_info *ei = get_irq_chip_data(irq);
-	ei->irqs_enabled |= 1 << (irq - ei->irq_start);
-	pr_debug("EGPIO unmask %d %04x\n", irq, ei->irqs_enabled);
+	struct egpio_info *ei = irq_data_get_irq_chip_data(d);
+	ei->irqs_enabled |= 1 << (d->irq - ei->irq_start);
+	pr_debug("EGPIO unmask %d %04x\n", d->irq, ei->irqs_enabled);
 }
 
 static struct irq_chip egpio_muxed_chip = {
-	.name   = "htc-egpio",
-	.ack	= egpio_ack,
-	.mask   = egpio_mask,
-	.unmask = egpio_unmask,
+	.name		= "htc-egpio",
+	.irq_ack	= egpio_ack,
+	.irq_mask	= egpio_mask,
+	.irq_unmask	= egpio_unmask,
 };
 
 static void egpio_handler(unsigned int irq, struct irq_desc *desc)
-- 
1.7.1

