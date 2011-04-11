Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083Ab1DKQXi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 12:23:38 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50642 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab1DKQXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 12:23:37 -0400
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, Jamie Iles <jamie@jamieiles.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH] basic_mmio_gpio: convert to non-__raw* accessors
Date: Mon, 11 Apr 2011 17:11:26 +0100
Message-Id: <1302538286-3547-1-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.7.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __raw_* accessors don't include memory barriers and can cause
problems when writes get stuck in write buffers.

Suggested-by: Linus Walleij <linus.walleij@linaro.org>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Jamie Iles <jamie@jamieiles.com>
---

Note: This patch is based on top of my other series to extend
basic_mmio_gpio.

 drivers/gpio/basic_mmio_gpio.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/gpio/basic_mmio_gpio.c b/drivers/gpio/basic_mmio_gpio.c
index f4afd96..b2ec45f 100644
--- a/drivers/gpio/basic_mmio_gpio.c
+++ b/drivers/gpio/basic_mmio_gpio.c
@@ -101,43 +101,43 @@ static struct bgpio_chip *to_bgpio_chip(struct gpio_chip *gc)
 
 static void bgpio_write8(void __iomem *reg, unsigned long data)
 {
-	__raw_writeb(data, reg);
+	writeb(data, reg);
 }
 
 static unsigned long bgpio_read8(void __iomem *reg)
 {
-	return __raw_readb(reg);
+	return readb(reg);
 }
 
 static void bgpio_write16(void __iomem *reg, unsigned long data)
 {
-	__raw_writew(data, reg);
+	writew(data, reg);
 }
 
 static unsigned long bgpio_read16(void __iomem *reg)
 {
-	return __raw_readw(reg);
+	return readw(reg);
 }
 
 static void bgpio_write32(void __iomem *reg, unsigned long data)
 {
-	__raw_writel(data, reg);
+	writel(data, reg);
 }
 
 static unsigned long bgpio_read32(void __iomem *reg)
 {
-	return __raw_readl(reg);
+	return readl(reg);
 }
 
 #if BITS_PER_LONG >= 64
 static void bgpio_write64(void __iomem *reg, unsigned long data)
 {
-	__raw_writeq(data, reg);
+	writeq(data, reg);
 }
 
 static unsigned long bgpio_read64(void __iomem *reg)
 {
-	return __raw_readq(reg);
+	return readq(reg);
 }
 #endif /* BITS_PER_LONG >= 64 */
 
-- 
1.7.4.2

