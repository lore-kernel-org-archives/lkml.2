Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932882Ab0JRPxs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 11:53:48 -0400
Received: from mx1.spunky.mail.dreamhost.com ([208.97.132.47]:47810 "EHLO
	homiemail-a62.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932167Ab0JRPxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 11:53:47 -0400
Subject: [PATCH] gpio led: properly initialize return value
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: rpurdie@rpsys.net, raph@8d.com, tpiepho@freescale.com
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Oct 2010 12:53:39 -0300
Message-ID: <1287417219.4214.5.camel@cowboy>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gpio led: properly initialize return value in gpio_led_init()

In the event that none of the configs are set (CONFIG_LEDS_GPIO_PLATFORM, CONFIG_LEDS_GPIO_OF, 
CONFIG_LEDS_GPIO_PLATFORM), we will return bogus when initializing the module.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 drivers/leds/leds-gpio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/leds/leds-gpio.c b/drivers/leds/leds-gpio.c
index ea57e05..4d9fa38 100644
--- a/drivers/leds/leds-gpio.c
+++ b/drivers/leds/leds-gpio.c
@@ -316,7 +316,7 @@ static struct of_platform_driver of_gpio_leds_driver = {
 
 static int __init gpio_led_init(void)
 {
-	int ret;
+	int ret = 0;
 
 #ifdef CONFIG_LEDS_GPIO_PLATFORM	
 	ret = platform_driver_register(&gpio_led_driver);
-- 
1.7.0.4



