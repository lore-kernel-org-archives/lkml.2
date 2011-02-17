Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994Ab1BQU67 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 15:58:59 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46312 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab1BQU6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 15:58:55 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] leds-gpio: minor style fixes
Date: Thu, 17 Feb 2011 21:58:52 +0100
Message-Id: <1297976332-12877-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported-by: Lothar Waßmann <LW@KARO-electronics.de>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/leds/leds-gpio.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/leds/leds-gpio.c b/drivers/leds/leds-gpio.c
index 4d9fa38..8cb7936 100644
--- a/drivers/leds/leds-gpio.c
+++ b/drivers/leds/leds-gpio.c
@@ -16,8 +16,7 @@
 #include <linux/leds.h>
 #include <linux/slab.h>
 #include <linux/workqueue.h>
-
-#include <asm/gpio.h>
+#include <linux/gpio.h>
 
 struct gpio_led_data {
 	struct led_classdev cdev;
@@ -129,7 +128,7 @@ static int __devinit create_gpio_led(const struct gpio_led *template,
 	ret = gpio_direction_output(led_dat->gpio, led_dat->active_low ^ state);
 	if (ret < 0)
 		goto err;
-		
+
 	INIT_WORK(&led_dat->work, gpio_led_work);
 
 	ret = led_classdev_register(parent, &led_dat->cdev);
@@ -256,7 +255,7 @@ static int __devinit of_gpio_leds_probe(struct platform_device *ofdev,
 		if (state) {
 			if (!strcmp(state, "keep"))
 				led.default_state = LEDS_GPIO_DEFSTATE_KEEP;
-			else if(!strcmp(state, "on"))
+			else if (!strcmp(state, "on"))
 				led.default_state = LEDS_GPIO_DEFSTATE_ON;
 			else
 				led.default_state = LEDS_GPIO_DEFSTATE_OFF;
@@ -318,7 +317,7 @@ static int __init gpio_led_init(void)
 {
 	int ret = 0;
 
-#ifdef CONFIG_LEDS_GPIO_PLATFORM	
+#ifdef CONFIG_LEDS_GPIO_PLATFORM
 	ret = platform_driver_register(&gpio_led_driver);
 	if (ret)
 		return ret;
@@ -326,7 +325,7 @@ static int __init gpio_led_init(void)
 #ifdef CONFIG_LEDS_GPIO_OF
 	ret = of_register_platform_driver(&of_gpio_leds_driver);
 #endif
-#ifdef CONFIG_LEDS_GPIO_PLATFORM	
+#ifdef CONFIG_LEDS_GPIO_PLATFORM
 	if (ret)
 		platform_driver_unregister(&gpio_led_driver);
 #endif
-- 
1.7.2.3

