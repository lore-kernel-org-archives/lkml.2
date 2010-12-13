Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450Ab0LMMDf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 07:03:35 -0500
Received: from fw.wantstofly.org ([80.101.37.227]:37221 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757417Ab0LMMDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 07:03:20 -0500
Date: Mon, 13 Dec 2010 13:03:19 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Yoichi Yuasa <yuasa@linux-mips.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 10/10] gpio: vr41xx_giu: irq_data conversion.
Message-ID: <20101213120319.GI15575@mail.wantstofly.org>
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
 drivers/gpio/vr41xx_giu.c |   48 ++++++++++++++++++++++----------------------
 1 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/gpio/vr41xx_giu.c b/drivers/gpio/vr41xx_giu.c
index b16c9a8..cffa3bd 100644
--- a/drivers/gpio/vr41xx_giu.c
+++ b/drivers/gpio/vr41xx_giu.c
@@ -111,69 +111,69 @@ static inline u16 giu_clear(u16 offset, u16 clear)
 	return data;
 }
 
-static void ack_giuint_low(unsigned int irq)
+static void ack_giuint_low(struct irq_data *d)
 {
-	giu_write(GIUINTSTATL, 1 << GPIO_PIN_OF_IRQ(irq));
+	giu_write(GIUINTSTATL, 1 << GPIO_PIN_OF_IRQ(d->irq));
 }
 
-static void mask_giuint_low(unsigned int irq)
+static void mask_giuint_low(struct irq_data *d)
 {
-	giu_clear(GIUINTENL, 1 << GPIO_PIN_OF_IRQ(irq));
+	giu_clear(GIUINTENL, 1 << GPIO_PIN_OF_IRQ(d->irq));
 }
 
-static void mask_ack_giuint_low(unsigned int irq)
+static void mask_ack_giuint_low(struct irq_data *d)
 {
 	unsigned int pin;
 
-	pin = GPIO_PIN_OF_IRQ(irq);
+	pin = GPIO_PIN_OF_IRQ(d->irq);
 	giu_clear(GIUINTENL, 1 << pin);
 	giu_write(GIUINTSTATL, 1 << pin);
 }
 
-static void unmask_giuint_low(unsigned int irq)
+static void unmask_giuint_low(struct irq_data *d)
 {
-	giu_set(GIUINTENL, 1 << GPIO_PIN_OF_IRQ(irq));
+	giu_set(GIUINTENL, 1 << GPIO_PIN_OF_IRQ(d->irq));
 }
 
 static struct irq_chip giuint_low_irq_chip = {
 	.name		= "GIUINTL",
-	.ack		= ack_giuint_low,
-	.mask		= mask_giuint_low,
-	.mask_ack	= mask_ack_giuint_low,
-	.unmask		= unmask_giuint_low,
+	.irq_ack	= ack_giuint_low,
+	.irq_mask	= mask_giuint_low,
+	.irq_mask_ack	= mask_ack_giuint_low,
+	.irq_unmask	= unmask_giuint_low,
 };
 
-static void ack_giuint_high(unsigned int irq)
+static void ack_giuint_high(struct irq_data *d)
 {
 	giu_write(GIUINTSTATH,
-		  1 << (GPIO_PIN_OF_IRQ(irq) - GIUINT_HIGH_OFFSET));
+		  1 << (GPIO_PIN_OF_IRQ(d->irq) - GIUINT_HIGH_OFFSET));
 }
 
-static void mask_giuint_high(unsigned int irq)
+static void mask_giuint_high(struct irq_data *d)
 {
-	giu_clear(GIUINTENH, 1 << (GPIO_PIN_OF_IRQ(irq) - GIUINT_HIGH_OFFSET));
+	giu_clear(GIUINTENH, 1 << (GPIO_PIN_OF_IRQ(d->irq) - GIUINT_HIGH_OFFSET));
 }
 
-static void mask_ack_giuint_high(unsigned int irq)
+static void mask_ack_giuint_high(struct irq_data *d)
 {
 	unsigned int pin;
 
-	pin = GPIO_PIN_OF_IRQ(irq) - GIUINT_HIGH_OFFSET;
+	pin = GPIO_PIN_OF_IRQ(d->irq) - GIUINT_HIGH_OFFSET;
 	giu_clear(GIUINTENH, 1 << pin);
 	giu_write(GIUINTSTATH, 1 << pin);
 }
 
-static void unmask_giuint_high(unsigned int irq)
+static void unmask_giuint_high(struct irq_data *d)
 {
-	giu_set(GIUINTENH, 1 << (GPIO_PIN_OF_IRQ(irq) - GIUINT_HIGH_OFFSET));
+	giu_set(GIUINTENH, 1 << (GPIO_PIN_OF_IRQ(d->irq) - GIUINT_HIGH_OFFSET));
 }
 
 static struct irq_chip giuint_high_irq_chip = {
 	.name		= "GIUINTH",
-	.ack		= ack_giuint_high,
-	.mask		= mask_giuint_high,
-	.mask_ack	= mask_ack_giuint_high,
-	.unmask		= unmask_giuint_high,
+	.irq_ack	= ack_giuint_high,
+	.irq_mask	= mask_giuint_high,
+	.irq_mask_ack	= mask_ack_giuint_high,
+	.irq_unmask	= unmask_giuint_high,
 };
 
 static int giu_get_irq(unsigned int irq)
-- 
1.7.1
