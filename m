Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697Ab2LNQWV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 11:22:21 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:43723 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932260Ab2LNQUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 11:20:09 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 14/21] gpio: ab8500: Remove ENUMs from linux/mfd/abx500/ab8500-gpio.h
Date: Fri, 14 Dec 2012 16:19:32 +0000
Message-Id: <1355501979-1157-15-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355501979-1157-1-git-send-email-lee.jones@linaro.org>
References: <1355501979-1157-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are no longer used and will be replaced by a simple macro.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/gpio/gpio-ab8500.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpio/gpio-ab8500.c b/drivers/gpio/gpio-ab8500.c
index 200c605..ab6ceac 100644
--- a/drivers/gpio/gpio-ab8500.c
+++ b/drivers/gpio/gpio-ab8500.c
@@ -585,9 +585,9 @@ static int __devexit ab8500_gpio_remove(struct platform_device *pdev)
 }
 
 int ab8500_config_pulldown(struct device *dev,
-				enum ab8500_pin gpio, bool enable)
+				int gpio, bool enable)
 {
-	u8 offset =  gpio - AB8500_PIN_GPIO1;
+	u8 offset =  gpio - AB8500_PIN_GPIO(1);
 	u8 pos = offset % 8;
 	u8 val = enable ? 0 : 1;
 	u8 reg = AB8500_GPIO_PUD1_REG + (offset / 8);
@@ -610,9 +610,9 @@ EXPORT_SYMBOL(ab8500_config_pulldown);
  * @gpio_select: true if the pin should be used as GPIO
  */
 int ab8500_gpio_config_select(struct device *dev,
-				enum ab8500_pin gpio, bool gpio_select)
+				int gpio, bool gpio_select)
 {
-	u8 offset = gpio - AB8500_PIN_GPIO1;
+	u8 offset = gpio - AB8500_PIN_GPIO(1);
 	u8 reg = AB8500_GPIO_SEL1_REG + (offset / 8);
 	u8 pos = offset % 8;
 	u8 val = gpio_select ? 1 : 0;
@@ -638,9 +638,9 @@ int ab8500_gpio_config_select(struct device *dev,
  * @gpio_select: pointer to pin selection status
  */
 int ab8500_gpio_config_get_select(struct device *dev,
-					enum ab8500_pin gpio, bool *gpio_select)
+					int gpio, bool *gpio_select)
 {
-	u8 offset =  gpio - AB8500_PIN_GPIO1;
+	u8 offset =  gpio - AB8500_PIN_GPIO(1);
 	u8 reg = AB8500_GPIO_SEL1_REG + (offset / 8);
 	u8 pos = offset % 8;
 	u8 val;
-- 
1.7.9.5

