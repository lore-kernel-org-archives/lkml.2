Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834Ab2K2Rhj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 12:37:39 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55295 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340Ab2K2Rhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 12:37:38 -0500
Date: Thu, 29 Nov 2012 09:37:34 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: linux-input@vger.kernel.org
Cc: Alexander Shiyan <shc_work@mail.ru>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Input: gpio_keys - switch to using gpio_request_one()
Message-ID: <20121129173732.GA8078@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This saves us a few lines of code.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/keyboard/gpio_keys.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/input/keyboard/gpio_keys.c b/drivers/input/keyboard/gpio_keys.c
index 79435de..d327f5a 100644
--- a/drivers/input/keyboard/gpio_keys.c
+++ b/drivers/input/keyboard/gpio_keys.c
@@ -440,21 +440,13 @@ static int gpio_keys_setup_key(struct platform_device *pdev,
 
 	if (gpio_is_valid(button->gpio)) {
 
-		error = gpio_request(button->gpio, desc);
+		error = gpio_request_one(button->gpio, GPIOF_IN, desc);
 		if (error < 0) {
 			dev_err(dev, "Failed to request GPIO %d, error %d\n",
 				button->gpio, error);
 			return error;
 		}
 
-		error = gpio_direction_input(button->gpio);
-		if (error < 0) {
-			dev_err(dev,
-				"Failed to configure direction for GPIO %d, error %d\n",
-				button->gpio, error);
-			goto fail;
-		}
-
 		if (button->debounce_interval) {
 			error = gpio_set_debounce(button->gpio,
 					button->debounce_interval * 1000);
-- 
1.7.11.7


-- 
Dmitry
