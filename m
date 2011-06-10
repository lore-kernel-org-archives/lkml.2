Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab1FJJf1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 05:35:27 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:48318 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754498Ab1FJJfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 05:35:24 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Richard Purdie <rpurdie@rpsys.net>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] leds/lp5521: provide section tagging
Date: Fri, 10 Jun 2011 11:35:13 +0200
Message-ID: <1307698513-1622-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

Tag the probe() and remove() function as __devinit and __devexit
respectively.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/leds/leds-lp5521.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index c0cff64..7c00294 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -637,8 +637,8 @@ static int __init lp5521_init_led(struct lp5521_led *led,
 	return 0;
 }
 
-static int lp5521_probe(struct i2c_client *client,
-			const struct i2c_device_id *id)
+static int __devinit lp5521_probe(struct i2c_client *client,
+				  const struct i2c_device_id *id)
 {
 	struct lp5521_chip		*chip;
 	struct lp5521_platform_data	*pdata;
@@ -744,7 +744,7 @@ fail1:
 	return ret;
 }
 
-static int lp5521_remove(struct i2c_client *client)
+static int __devexit lp5521_remove(struct i2c_client *client)
 {
 	struct lp5521_chip *chip = i2c_get_clientdata(client);
 	int i;
@@ -775,7 +775,7 @@ static struct i2c_driver lp5521_driver = {
 		.name	= "lp5521",
 	},
 	.probe		= lp5521_probe,
-	.remove		= lp5521_remove,
+	.remove		= __devexit_p(lp5521_remove),
 	.id_table	= lp5521_id,
 };
 
-- 
1.7.3.2

