Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097Ab2GDQNE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 12:13:04 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50401 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750986Ab2GDQNA (ORCPT
	<rfc822;linux-kernel@Vger.kernel.org>);
	Wed, 4 Jul 2012 12:13:00 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/4] gpiolib: wm8994: Use irq_domain mappings for gpios
Date: Wed,  4 Jul 2012 17:12:55 +0100
Message-Id: <1341418378-26251-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has no practical impact at present since we don't support device tree
so any user must have set an irq_base but this will in future allow a
transition to device tree with minimal invasiveness.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/gpio/gpio-wm8994.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpio-wm8994.c b/drivers/gpio/gpio-wm8994.c
index 92ea535..a1c7ba9 100644
--- a/drivers/gpio/gpio-wm8994.c
+++ b/drivers/gpio/gpio-wm8994.c
@@ -19,6 +19,7 @@
 #include <linux/mfd/core.h>
 #include <linux/platform_device.h>
 #include <linux/seq_file.h>
+#include <linux/regmap.h>
 
 #include <linux/mfd/wm8994/core.h>
 #include <linux/mfd/wm8994/pdata.h>
@@ -109,10 +110,7 @@ static int wm8994_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
 	struct wm8994_gpio *wm8994_gpio = to_wm8994_gpio(chip);
 	struct wm8994 *wm8994 = wm8994_gpio->wm8994;
 
-	if (!wm8994->irq_base)
-		return -EINVAL;
-
-	return wm8994->irq_base + offset;
+	return regmap_irq_get_virq(wm8994->irq_data, offset);
 }
 
 
-- 
1.7.10

