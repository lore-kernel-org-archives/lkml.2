Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab2K2Rgv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 12:36:51 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52909 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244Ab2K2Rgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 12:36:49 -0500
Date: Thu, 29 Nov 2012 09:36:44 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: linux-input@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Alexander Shiyan <shc_work@mail.ru>, linux-kernel@vger.kernel.org
Subject: [PATCH] Input: gpio_keys_polled - switch to using gpio_request_one()
Message-ID: <20121129173642.GA8035@core.coreip.homeip.net>
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
 drivers/input/keyboard/gpio_keys_polled.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/input/keyboard/gpio_keys_polled.c b/drivers/input/keyboard/gpio_keys_polled.c
index d72d0e5..f686fd9 100644
--- a/drivers/input/keyboard/gpio_keys_polled.c
+++ b/drivers/input/keyboard/gpio_keys_polled.c
@@ -270,22 +270,14 @@ static int gpio_keys_polled_probe(struct platform_device *pdev)
 			goto err_free_gpio;
 		}
 
-		error = gpio_request(gpio,
-				     button->desc ? button->desc : DRV_NAME);
+		error = gpio_request_one(gpio, GPIOF_IN,
+					 button->desc ?: DRV_NAME);
 		if (error) {
 			dev_err(dev, "unable to claim gpio %u, err=%d\n",
 				gpio, error);
 			goto err_free_gpio;
 		}
 
-		error = gpio_direction_input(gpio);
-		if (error) {
-			dev_err(dev,
-				"unable to set direction on gpio %u, err=%d\n",
-				gpio, error);
-			goto err_free_gpio;
-		}
-
 		bdata->can_sleep = gpio_cansleep(gpio);
 		bdata->last_state = -1;
 		bdata->threshold = DIV_ROUND_UP(button->debounce_interval,
-- 
1.7.11.7


-- 
Dmitry
