Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459Ab0LMMar (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 07:30:47 -0500
Received: from fw.wantstofly.org ([80.101.37.227]:36140 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449Ab0LMMao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 07:30:44 -0500
Date: Mon, 13 Dec 2010 13:30:43 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 08/20] mfd: jz4740-adc: irq_data conversion.
Message-ID: <20101213123043.GR15575@mail.wantstofly.org>
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
 drivers/mfd/jz4740-adc.c |   25 +++++++++++++------------
 1 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/mfd/jz4740-adc.c b/drivers/mfd/jz4740-adc.c
index 9dd1b33..955b0d0 100644
--- a/drivers/mfd/jz4740-adc.c
+++ b/drivers/mfd/jz4740-adc.c
@@ -84,31 +84,32 @@ static inline void jz4740_adc_irq_set_masked(struct jz4740_adc *adc, int irq,
 	spin_unlock_irqrestore(&adc->lock, flags);
 }
 
-static void jz4740_adc_irq_mask(unsigned int irq)
+static void jz4740_adc_irq_mask(struct irq_data *d)
 {
-	struct jz4740_adc *adc = get_irq_chip_data(irq);
-	jz4740_adc_irq_set_masked(adc, irq, true);
+	struct jz4740_adc *adc = irq_data_get_irq_chip_data(d);
+	jz4740_adc_irq_set_masked(adc, d->irq, true);
 }
 
-static void jz4740_adc_irq_unmask(unsigned int irq)
+static void jz4740_adc_irq_unmask(struct irq_data *d)
 {
-	struct jz4740_adc *adc = get_irq_chip_data(irq);
-	jz4740_adc_irq_set_masked(adc, irq, false);
+	struct jz4740_adc *adc = irq_data_get_irq_chip_data(d);
+	jz4740_adc_irq_set_masked(adc, d->irq, false);
 }
 
-static void jz4740_adc_irq_ack(unsigned int irq)
+static void jz4740_adc_irq_ack(struct irq_data *d)
 {
-	struct jz4740_adc *adc = get_irq_chip_data(irq);
+	struct jz4740_adc *adc = irq_data_get_irq_chip_data(d);
+	unsigned int irq;
 
-	irq -= adc->irq_base;
+	irq = d->irq - adc->irq_base;
 	writeb(BIT(irq), adc->base + JZ_REG_ADC_STATUS);
 }
 
 static struct irq_chip jz4740_adc_irq_chip = {
 	.name = "jz4740-adc",
-	.mask = jz4740_adc_irq_mask,
-	.unmask = jz4740_adc_irq_unmask,
-	.ack = jz4740_adc_irq_ack,
+	.irq_mask = jz4740_adc_irq_mask,
+	.irq_unmask = jz4740_adc_irq_unmask,
+	.irq_ack = jz4740_adc_irq_ack,
 };
 
 static void jz4740_adc_irq_demux(unsigned int irq, struct irq_desc *desc)
-- 
1.7.1

