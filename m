Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab2FEQW0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 12:22:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56221 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754176Ab2FEQWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 12:22:24 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] gpiolib: wm8994: Convert to devm_kzalloc()
Date: Tue,  5 Jun 2012 17:22:09 +0100
Message-Id: <1338913329-24245-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
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

