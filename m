Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203Ab2GDQNG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 12:13:06 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50404 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754467Ab2GDQNC (ORCPT
	<rfc822;linux-kernel@Vger.kernel.org>);
	Wed, 4 Jul 2012 12:13:02 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/4] gpiolib: wm8994: Convert to devm_kzalloc()
Date: Wed,  4 Jul 2012 17:12:56 +0100
Message-Id: <1341418378-26251-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1341418378-26251-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1341418378-26251-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/gpio/gpio-wm8994.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/gpio/gpio-wm8994.c b/drivers/gpio/gpio-wm8994.c
index a1c7ba9..f2b3d19 100644
--- a/drivers/gpio/gpio-wm8994.c
+++ b/drivers/gpio/gpio-wm8994.c
@@ -249,7 +249,8 @@ static int __devinit wm8994_gpio_probe(struct platform_device *pdev)
 	struct wm8994_gpio *wm8994_gpio;
 	int ret;
 
-	wm8994_gpio = kzalloc(sizeof(*wm8994_gpio), GFP_KERNEL);
+	wm8994_gpio = devm_kzalloc(&pdev->dev, sizeof(*wm8994_gpio),
+				   GFP_KERNEL);
 	if (wm8994_gpio == NULL)
 		return -ENOMEM;
 
@@ -274,20 +275,14 @@ static int __devinit wm8994_gpio_probe(struct platform_device *pdev)
 	return ret;
 
 err:
-	kfree(wm8994_gpio);
 	return ret;
 }
 
 static int __devexit wm8994_gpio_remove(struct platform_device *pdev)
 {
 	struct wm8994_gpio *wm8994_gpio = platform_get_drvdata(pdev);
-	int ret;
-
-	ret = gpiochip_remove(&wm8994_gpio->gpio_chip);
-	if (ret == 0)
-		kfree(wm8994_gpio);
 
-	return ret;
+	return gpiochip_remove(&wm8994_gpio->gpio_chip);
 }
 
 static struct platform_driver wm8994_gpio_driver = {
-- 
1.7.10

