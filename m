Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab2BMJFP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 04:05:15 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:65458 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515Ab2BMJFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 04:05:13 -0500
Message-ID: <1329123903.13995.1.camel@phoenix>
Subject: [PATCH] i2c: convert drivers/i2c/* to use module_i2c_driver()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <w.sang@pengutronix.de>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Jean Delvare <khali@linux-fr.org>, Michael Lawnick <ml.lawnick@gmx.de>,
        Ben Dooks <ben-linux@fluff.org>, linux-i2c@vger.kernel.org
Date: Mon, 13 Feb 2012 17:05:03 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the drivers in drivers/i2c/* to use the
module_i2c_driver() macro which makes the code smaller and a bit simpler.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Michael Lawnick <ml.lawnick@gmx.de>
Cc: Ben Dooks <ben-linux@fluff.org>
---
 drivers/i2c/i2c-smbus.c     |   13 +------------
 drivers/i2c/muxes/pca9541.c |   13 +------------
 drivers/i2c/muxes/pca954x.c |   13 +------------
 3 files changed, 3 insertions(+), 36 deletions(-)

diff --git a/drivers/i2c/i2c-smbus.c b/drivers/i2c/i2c-smbus.c
index f61ccc1..9316705 100644
--- a/drivers/i2c/i2c-smbus.c
+++ b/drivers/i2c/i2c-smbus.c
@@ -244,18 +244,7 @@ int i2c_handle_smbus_alert(struct i2c_client *ara)
 }
 EXPORT_SYMBOL_GPL(i2c_handle_smbus_alert);
 
-static int __init i2c_smbus_init(void)
-{
-	return i2c_add_driver(&smbalert_driver);
-}
-
-static void __exit i2c_smbus_exit(void)
-{
-	i2c_del_driver(&smbalert_driver);
-}
-
-module_init(i2c_smbus_init);
-module_exit(i2c_smbus_exit);
+module_i2c_driver(smbalert_driver);
 
 MODULE_AUTHOR("Jean Delvare <khali@linux-fr.org>");
 MODULE_DESCRIPTION("SMBus protocol extensions support");
diff --git a/drivers/i2c/muxes/pca9541.c b/drivers/i2c/muxes/pca9541.c
index ed699c5..e0df9b6 100644
--- a/drivers/i2c/muxes/pca9541.c
+++ b/drivers/i2c/muxes/pca9541.c
@@ -393,18 +393,7 @@ static struct i2c_driver pca9541_driver = {
 	.id_table = pca9541_id,
 };
 
-static int __init pca9541_init(void)
-{
-	return i2c_add_driver(&pca9541_driver);
-}
-
-static void __exit pca9541_exit(void)
-{
-	i2c_del_driver(&pca9541_driver);
-}
-
-module_init(pca9541_init);
-module_exit(pca9541_exit);
+module_i2c_driver(pca9541_driver);
 
 MODULE_AUTHOR("Guenter Roeck <guenter.roeck@ericsson.com>");
 MODULE_DESCRIPTION("PCA9541 I2C master selector driver");
diff --git a/drivers/i2c/muxes/pca954x.c b/drivers/i2c/muxes/pca954x.c
index 6f89536..0e37ef2 100644
--- a/drivers/i2c/muxes/pca954x.c
+++ b/drivers/i2c/muxes/pca954x.c
@@ -284,18 +284,7 @@ static struct i2c_driver pca954x_driver = {
 	.id_table	= pca954x_id,
 };
 
-static int __init pca954x_init(void)
-{
-	return i2c_add_driver(&pca954x_driver);
-}
-
-static void __exit pca954x_exit(void)
-{
-	i2c_del_driver(&pca954x_driver);
-}
-
-module_init(pca954x_init);
-module_exit(pca954x_exit);
+module_i2c_driver(pca954x_driver);
 
 MODULE_AUTHOR("Rodolfo Giometti <giometti@linux.it>");
 MODULE_DESCRIPTION("PCA954x I2C mux/switch driver");
-- 
1.7.5.4



