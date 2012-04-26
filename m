Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759235Ab2DZUJf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 16:09:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53336 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751522Ab2DZUJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 16:09:34 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kyungmin Park <kyungmin.park@samsung.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] extcon: Pacify the section mismatch checker
Date: Thu, 26 Apr 2012 21:09:28 +0100
Message-Id: <1335470968-10920-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The section mismatch checker can't figure out that it's safe for
extcon_gpio to reference gpio_extcon_remove() without a _driver on
the end of the name of the struct so add one to avoid warnings.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon_gpio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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
-- 
1.7.10

