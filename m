Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab2IBAIJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 20:08:09 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41424 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab2IBAIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 20:08:07 -0400
Message-ID: <1346544481.3355.3.camel@phoenix>
Subject: [PATCH] gpio: adp5588: Use module_i2c_driver
From: Axel Lin <axel.lin@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        Michael Hennerich <michael.hennerich@analog.com>
Date: Sun, 02 Sep 2012 08:08:01 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/gpio/gpio-adp5588.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/gpio/gpio-adp5588.c b/drivers/gpio/gpio-adp5588.c
index ae5d7f1..eeedad4 100644
--- a/drivers/gpio/gpio-adp5588.c
+++ b/drivers/gpio/gpio-adp5588.c
@@ -483,19 +483,7 @@ static struct i2c_driver adp5588_gpio_driver = {
 	.id_table = adp5588_gpio_id,
 };
 
-static int __init adp5588_gpio_init(void)
-{
-	return i2c_add_driver(&adp5588_gpio_driver);
-}
-
-module_init(adp5588_gpio_init);
-
-static void __exit adp5588_gpio_exit(void)
-{
-	i2c_del_driver(&adp5588_gpio_driver);
-}
-
-module_exit(adp5588_gpio_exit);
+module_i2c_driver(adp5588_gpio_driver);
 
 MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
 MODULE_DESCRIPTION("GPIO ADP5588 Driver");
-- 
1.7.9.5



