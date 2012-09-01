Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab2IAJeZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 05:34:25 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35259 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab2IAJeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 05:34:24 -0400
Message-ID: <1346492055.10234.1.camel@phoenix>
Subject: [PATCH] gpio: da9052: Convert to use devm_kzalloc API
From: Axel Lin <axel.lin@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        linux-kernel@vger.kernel.org
Date: Sat, 01 Sep 2012 17:34:15 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/gpio/gpio-da9052.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/gpio/gpio-da9052.c b/drivers/gpio/gpio-da9052.c
index 56dd047..24b8c29 100644
--- a/drivers/gpio/gpio-da9052.c
+++ b/drivers/gpio/gpio-da9052.c
@@ -207,7 +207,7 @@ static int __devinit da9052_gpio_probe(struct platform_device *pdev)
 	struct da9052_pdata *pdata;
 	int ret;
 
-	gpio = kzalloc(sizeof(*gpio), GFP_KERNEL);
+	gpio = devm_kzalloc(&pdev->dev, sizeof(*gpio), GFP_KERNEL);
 	if (gpio == NULL)
 		return -ENOMEM;
 
@@ -221,28 +221,19 @@ static int __devinit da9052_gpio_probe(struct platform_device *pdev)
 	ret = gpiochip_add(&gpio->gp);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Could not register gpiochip, %d\n", ret);
-		goto err_mem;
+		return ret;
 	}
 
 	platform_set_drvdata(pdev, gpio);
 
 	return 0;
-
-err_mem:
-	kfree(gpio);
-	return ret;
 }
 
 static int __devexit da9052_gpio_remove(struct platform_device *pdev)
 {
 	struct da9052_gpio *gpio = platform_get_drvdata(pdev);
-	int ret;
-
-	ret = gpiochip_remove(&gpio->gp);
-	if (ret == 0)
-		kfree(gpio);
 
-	return ret;
+	return gpiochip_remove(&gpio->gp);
 }
 
 static struct platform_driver da9052_gpio_driver = {
-- 
1.7.9.5



