Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822Ab2H2BhD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 21:37:03 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62870 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab2H2BhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 21:37:01 -0400
Message-ID: <1346204214.13176.2.camel@phoenix>
Subject: [PATCH 2/2] gpio: mc9s08dz60: Use devm_kzalloc API
From: Axel Lin <axel.lin@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Wu Guoxing <b39297@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>, linux-kernel@vger.kernel.org
Date: Wed, 29 Aug 2012 09:36:54 +0800
In-Reply-To: <1346204124.13176.0.camel@phoenix>
References: <1346204124.13176.0.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/gpio/gpio-mc9s08dz60.c |   21 +++------------------
 1 file changed, 3 insertions(+), 18 deletions(-)

diff --git a/drivers/gpio/gpio-mc9s08dz60.c b/drivers/gpio/gpio-mc9s08dz60.c
index 2738cc4..0ab7000 100644
--- a/drivers/gpio/gpio-mc9s08dz60.c
+++ b/drivers/gpio/gpio-mc9s08dz60.c
@@ -91,10 +91,9 @@ static int mc9s08dz60_direction_output(struct gpio_chip *gc,
 static int mc9s08dz60_probe(struct i2c_client *client,
 			    const struct i2c_device_id *id)
 {
-	int ret = 0;
 	struct mc9s08dz60 *mc9s;
 
-	mc9s = kzalloc(sizeof(*mc9s), GFP_KERNEL);
+	mc9s = devm_kzalloc(&client->dev, sizeof(*mc9s), GFP_KERNEL);
 	if (!mc9s)
 		return -ENOMEM;
 
@@ -110,30 +109,16 @@ static int mc9s08dz60_probe(struct i2c_client *client,
 	mc9s->client = client;
 	i2c_set_clientdata(client, mc9s);
 
-	ret = gpiochip_add(&mc9s->chip);
-	if (ret)
-		goto error;
-
-	return 0;
-
- error:
-	kfree(mc9s);
-	return ret;
+	return gpiochip_add(&mc9s->chip);
 }
 
 static int mc9s08dz60_remove(struct i2c_client *client)
 {
 	struct mc9s08dz60 *mc9s;
-	int ret;
 
 	mc9s = i2c_get_clientdata(client);
 
-	ret = gpiochip_remove(&mc9s->chip);
-	if (!ret)
-		kfree(mc9s);
-
-	return ret;
-
+	return gpiochip_remove(&mc9s->chip);
 }
 
 static const struct i2c_device_id mc9s08dz60_id[] = {
-- 
1.7.9.5



