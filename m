Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab2EBWjI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 18:39:08 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:55259 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443Ab2EBWjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 18:39:06 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-131.messagelabs.com!1335998329!21155894!13
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] Extcon: fix section mismatch in extcon_gpio.c
Date: Wed, 2 May 2012 15:38:44 -0700
User-Agent: KMail/1.9.9
CC: <myungjoo.ham@samsung.com>, <broonie@opensource.wolfsonmicro.com>,
        <gregkh@linuxfoundation.org>, <kyungmin.park@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205021538.45056.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the section mismatch be renaming the struct platform_driver
variable.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kyungmin Park <kyungmin.park@samsung.com>

---

diff --git a/drivers/extcon/extcon_gpio.c b/drivers/extcon/extcon_gpio.c
index 5c0f085..fe7a07b 100644
--- a/drivers/extcon/extcon_gpio.c
+++ b/drivers/extcon/extcon_gpio.c
@@ -153,7 +153,7 @@ static int __devexit gpio_extcon_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static struct platform_driver gpio_extcon = {
+static struct platform_driver gpio_extcon_driver = {
 	.probe		= gpio_extcon_probe,
 	.remove		= __devexit_p(gpio_extcon_remove),
 	.driver		= {
@@ -162,7 +162,7 @@ static struct platform_driver gpio_extcon = {
 	},
 };
 
-module_platform_driver(gpio_extcon);
+module_platform_driver(gpio_extcon_driver);
 
 MODULE_AUTHOR("Mike Lockwood <lockwood@android.com>");
 MODULE_DESCRIPTION("GPIO extcon driver");
