Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162Ab2IDN6m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 09:58:42 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56454 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192Ab2IDN6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 09:58:41 -0400
Message-ID: <1346767113.3160.1.camel@phoenix>
Subject: [PATCH] gpio: em: Use irq_data_get_irq_chip_data() at appropriate
 places
From: Axel Lin <axel.lin@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: Magnus Damm <damm@opensource.se>, linux-kernel@vger.kernel.org
Date: Tue, 04 Sep 2012 21:58:33 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Then we can remove irq_to_priv() function.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/gpio/gpio-em.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/gpio/gpio-em.c b/drivers/gpio/gpio-em.c
index ec48ed5..efb4c2d 100644
--- a/drivers/gpio/gpio-em.c
+++ b/drivers/gpio/gpio-em.c
@@ -85,22 +85,16 @@ static inline void em_gio_write(struct em_gio_priv *p, int offs,
 		iowrite32(value, p->base1 + (offs - GIO_IDT0));
 }
 
-static inline struct em_gio_priv *irq_to_priv(struct irq_data *d)
-{
-	struct irq_chip *chip = irq_data_get_irq_chip(d);
-	return container_of(chip, struct em_gio_priv, irq_chip);
-}
-
 static void em_gio_irq_disable(struct irq_data *d)
 {
-	struct em_gio_priv *p = irq_to_priv(d);
+	struct em_gio_priv *p = irq_data_get_irq_chip_data(d);
 
 	em_gio_write(p, GIO_IDS, BIT(irqd_to_hwirq(d)));
 }
 
 static void em_gio_irq_enable(struct irq_data *d)
 {
-	struct em_gio_priv *p = irq_to_priv(d);
+	struct em_gio_priv *p = irq_data_get_irq_chip_data(d);
 
 	em_gio_write(p, GIO_IEN, BIT(irqd_to_hwirq(d)));
 }
@@ -118,7 +112,7 @@ static unsigned char em_gio_sense_table[IRQ_TYPE_SENSE_MASK + 1] = {
 static int em_gio_irq_set_type(struct irq_data *d, unsigned int type)
 {
 	unsigned char value = em_gio_sense_table[type & IRQ_TYPE_SENSE_MASK];
-	struct em_gio_priv *p = irq_to_priv(d);
+	struct em_gio_priv *p = irq_data_get_irq_chip_data(d);
 	unsigned int reg, offset, shift;
 	unsigned long flags;
 	unsigned long tmp;
-- 
1.7.9.5



