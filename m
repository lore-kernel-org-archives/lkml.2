Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab2IBD6S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 23:58:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42650 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab2IBD6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 23:58:16 -0400
Message-ID: <1346558287.7253.0.camel@phoenix>
Subject: [PATCH 1/2] gpio: wm831x: Convert to use devm_kzalloc API
From: Axel Lin <axel.lin@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Date: Sun, 02 Sep 2012 11:58:07 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/gpio/gpio-wm831x.c |   19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/gpio/gpio-wm831x.c b/drivers/gpio/gpio-wm831x.c
index e56a216..b6eda35 100644
--- a/drivers/gpio/gpio-wm831x.c
+++ b/drivers/gpio/gpio-wm831x.c
@@ -250,7 +250,8 @@ static int __devinit wm831x_gpio_probe(struct platform_device *pdev)
 	struct wm831x_gpio *wm831x_gpio;
 	int ret;
 
-	wm831x_gpio = kzalloc(sizeof(*wm831x_gpio), GFP_KERNEL);
+	wm831x_gpio = devm_kzalloc(&pdev->dev, sizeof(*wm831x_gpio),
+				   GFP_KERNEL);
 	if (wm831x_gpio == NULL)
 		return -ENOMEM;
 
@@ -265,30 +266,20 @@ static int __devinit wm831x_gpio_probe(struct platform_device *pdev)
 
 	ret = gpiochip_add(&wm831x_gpio->gpio_chip);
 	if (ret < 0) {
-		dev_err(&pdev->dev, "Could not register gpiochip, %d\n",
-			ret);
-		goto err;
+		dev_err(&pdev->dev, "Could not register gpiochip, %d\n", ret);
+		return ret;
 	}
 
 	platform_set_drvdata(pdev, wm831x_gpio);
 
 	return ret;
-
-err:
-	kfree(wm831x_gpio);
-	return ret;
 }
 
 static int __devexit wm831x_gpio_remove(struct platform_device *pdev)
 {
 	struct wm831x_gpio *wm831x_gpio = platform_get_drvdata(pdev);
-	int ret;
-
-	ret = gpiochip_remove(&wm831x_gpio->gpio_chip);
-	if (ret == 0)
-		kfree(wm831x_gpio);
 
-	return ret;
+	return  gpiochip_remove(&wm831x_gpio->gpio_chip);
 }
 
 static struct platform_driver wm831x_gpio_driver = {
-- 
1.7.9.5



