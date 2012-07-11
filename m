Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab2GKJup (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 05:50:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61529 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148Ab2GKJuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 05:50:44 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Bryan Wu <bryan.wu@canonical.com>, Richard Purdie <rpurdie@rpsys.net>,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH] leds/leds-s3c24xx: use devm_gpio_request
Date: Wed, 11 Jul 2012 15:35:32 +0545
Message-Id: <1342000232-10105-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

why?
because if the led_classdev_register fails we wont do gpio free
because using devm_ functions, there is no need for error paths

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
Bryan,

	This patch is not even compile tested, since my machine crashed, and
didn't have the ARM toolchain, sorry ..

	And i think this patch is legit not as that pci_set_drvdata one :(
 drivers/leds/leds-s3c24xx.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/leds/leds-s3c24xx.c b/drivers/leds/leds-s3c24xx.c
index e120640..942f0ea 100644
--- a/drivers/leds/leds-s3c24xx.c
+++ b/drivers/leds/leds-s3c24xx.c
@@ -65,7 +65,6 @@ static int s3c24xx_led_remove(struct platform_device *dev)
 	struct s3c24xx_gpio_led *led = pdev_to_gpio(dev);
 
 	led_classdev_unregister(&led->cdev);
-	gpio_free(led->pdata->gpio);
 
 	return 0;
 }
@@ -92,7 +91,7 @@ static int s3c24xx_led_probe(struct platform_device *dev)
 
 	led->pdata = pdata;
 
-	ret = gpio_request(pdata->gpio, "S3C24XX_LED");
+	ret = devm_gpio_request(&dev->dev, pdata->gpio, "S3C24XX_LED");
 	if (ret < 0)
 		return ret;
 
-- 
1.7.9.5

