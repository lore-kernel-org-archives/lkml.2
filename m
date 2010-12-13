Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447Ab0LMMa0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 07:30:26 -0500
Received: from fw.wantstofly.org ([80.101.37.227]:36137 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757042Ab0LMMaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 07:30:22 -0500
Date: Mon, 13 Dec 2010 13:30:21 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Cory Maccarrone <darkstar6262@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 07/20] mfd: htc-i2cpld: irq_data conversion.
Message-ID: <20101213123021.GQ15575@mail.wantstofly.org>
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
 drivers/mfd/htc-i2cpld.c |   31 ++++++++++++++++---------------
 1 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/mfd/htc-i2cpld.c b/drivers/mfd/htc-i2cpld.c
index 594c9a8..c4f3fb7 100644
--- a/drivers/mfd/htc-i2cpld.c
+++ b/drivers/mfd/htc-i2cpld.c
@@ -82,25 +82,26 @@ struct htcpld_data {
 /* There does not appear to be a way to proactively mask interrupts
  * on the htcpld chip itself.  So, we simply ignore interrupts that
  * aren't desired. */
-static void htcpld_mask(unsigned int irq)
+static void htcpld_mask(struct irq_data *d)
 {
-	struct htcpld_chip *chip = get_irq_chip_data(irq);
-	chip->irqs_enabled &= ~(1 << (irq - chip->irq_start));
-	pr_debug("HTCPLD mask %d %04x\n", irq, chip->irqs_enabled);
+	struct htcpld_chip *chip = irq_data_get_irq_chip_data(d);
+	chip->irqs_enabled &= ~(1 << (d->irq - chip->irq_start));
+	pr_debug("HTCPLD mask %d %04x\n", d->irq, chip->irqs_enabled);
 }
-static void htcpld_unmask(unsigned int irq)
+
+static void htcpld_unmask(struct irq_data *d)
 {
-	struct htcpld_chip *chip = get_irq_chip_data(irq);
-	chip->irqs_enabled |= 1 << (irq - chip->irq_start);
-	pr_debug("HTCPLD unmask %d %04x\n", irq, chip->irqs_enabled);
+	struct htcpld_chip *chip = irq_data_get_irq_chip_data(d);
+	chip->irqs_enabled |= 1 << (d->irq - chip->irq_start);
+	pr_debug("HTCPLD unmask %d %04x\n", d->irq, chip->irqs_enabled);
 }
 
-static int htcpld_set_type(unsigned int irq, unsigned int flags)
+static int htcpld_set_type(struct irq_data *d, unsigned int flags)
 {
-	struct irq_desc *d = irq_to_desc(irq);
+	struct irq_desc *d = irq_to_desc(d->irq);
 
 	if (!d) {
-		pr_err("HTCPLD invalid IRQ: %d\n", irq);
+		pr_err("HTCPLD invalid IRQ: %d\n", d->irq);
 		return -EINVAL;
 	}
 
@@ -118,10 +119,10 @@ static int htcpld_set_type(unsigned int irq, unsigned int flags)
 }
 
 static struct irq_chip htcpld_muxed_chip = {
-	.name     = "htcpld",
-	.mask     = htcpld_mask,
-	.unmask   = htcpld_unmask,
-	.set_type = htcpld_set_type,
+	.name         = "htcpld",
+	.irq_mask     = htcpld_mask,
+	.irq_unmask   = htcpld_unmask,
+	.irq_set_type = htcpld_set_type,
 };
 
 /* To properly dispatch IRQ events, we need to read from the
-- 
1.7.1

