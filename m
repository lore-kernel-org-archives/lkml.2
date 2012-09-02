Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab2IBD7O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 23:59:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49927 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab2IBD7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 23:59:05 -0400
Message-ID: <1346558339.7253.1.camel@phoenix>
Subject: [PATCH 2/2] gpio: wm8350: Convert to use devm_kzalloc API
From: Axel Lin <axel.lin@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Date: Sun, 02 Sep 2012 11:58:59 +0800
In-Reply-To: <1346558287.7253.0.camel@phoenix>
References: <1346558287.7253.0.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/gpio/gpio-wm8350.c |   19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/gpio/gpio-wm8350.c b/drivers/gpio/gpio-wm8350.c
index a06af51..fb42938 100644
--- a/drivers/gpio/gpio-wm8350.c
+++ b/drivers/gpio/gpio-wm8350.c
@@ -116,7 +116,8 @@ static int __devinit wm8350_gpio_probe(struct platform_device *pdev)
 	struct wm8350_gpio_data *wm8350_gpio;
 	int ret;
 
-	wm8350_gpio = kzalloc(sizeof(*wm8350_gpio), GFP_KERNEL);
+	wm8350_gpio = devm_kzalloc(&pdev->dev, sizeof(*wm8350_gpio),
+				   GFP_KERNEL);
 	if (wm8350_gpio == NULL)
 		return -ENOMEM;
 
@@ -131,30 +132,20 @@ static int __devinit wm8350_gpio_probe(struct platform_device *pdev)
 
 	ret = gpiochip_add(&wm8350_gpio->gpio_chip);
 	if (ret < 0) {
-		dev_err(&pdev->dev, "Could not register gpiochip, %d\n",
-			ret);
-		goto err;
+		dev_err(&pdev->dev, "Could not register gpiochip, %d\n", ret);
+		return ret;
 	}
 
 	platform_set_drvdata(pdev, wm8350_gpio);
 
 	return ret;
-
-err:
-	kfree(wm8350_gpio);
-	return ret;
 }
 
 static int __devexit wm8350_gpio_remove(struct platform_device *pdev)
 {
 	struct wm8350_gpio_data *wm8350_gpio = platform_get_drvdata(pdev);
-	int ret;
-
-	ret = gpiochip_remove(&wm8350_gpio->gpio_chip);
-	if (ret == 0)
-		kfree(wm8350_gpio);
 
-	return ret;
+	return gpiochip_remove(&wm8350_gpio->gpio_chip);
 }
 
 static struct platform_driver wm8350_gpio_driver = {
-- 
1.7.9.5



