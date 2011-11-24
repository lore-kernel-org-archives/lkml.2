Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163Ab1KXIIh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 03:08:37 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53788 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592Ab1KXIIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 03:08:36 -0500
Message-ID: <1322122108.10476.3.camel@phoenix>
Subject: [PATCH 2/3] leds: Convert led i2c drivers to module_i2c_driver
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Kim Kyuwon <q1.kim@samsung.com>,
        Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com>,
        Antonio Ospite <ospite@studenti.unina.it>,
        Samu Onkalo <samu.p.onkalo@nokia.com>,
        Mathias Nyman <mathias.nyman@nokia.com>,
        Riku Voipio <riku.voipio@iki.fi>, Nate Case <ncase@xes-inc.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 24 Nov 2011 16:08:28 +0800
In-Reply-To: <1322122004.10476.1.camel@phoenix>
References: <1322122004.10476.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out some boilerplate code for i2c driver registration
into module_i2c_driver.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/leds/leds-bd2802.c  |   12 +-----------
 drivers/leds/leds-lm3530.c  |   13 +------------
 drivers/leds/leds-lp3944.c  |   13 +------------
 drivers/leds/leds-lp5521.c  |   20 +-------------------
 drivers/leds/leds-lp5523.c  |   20 +-------------------
 drivers/leds/leds-pca9532.c |   14 +-------------
 drivers/leds/leds-pca955x.c |   13 +------------
 7 files changed, 7 insertions(+), 98 deletions(-)

diff --git a/drivers/leds/leds-bd2802.c b/drivers/leds/leds-bd2802.c
index ea21855..10e40971 100644
--- a/drivers/leds/leds-bd2802.c
+++ b/drivers/leds/leds-bd2802.c
@@ -813,17 +813,7 @@ static struct i2c_driver bd2802_i2c_driver = {
 	.id_table	= bd2802_id,
 };
 
-static int __init bd2802_init(void)
-{
-	return i2c_add_driver(&bd2802_i2c_driver);
-}
-module_init(bd2802_init);
-
-static void __exit bd2802_exit(void)
-{
-	i2c_del_driver(&bd2802_i2c_driver);
-}
-module_exit(bd2802_exit);
+module_i2c_driver(bd2802_i2c_driver);
 
 MODULE_AUTHOR("Kim Kyuwon <q1.kim@samsung.com>");
 MODULE_DESCRIPTION("BD2802 LED driver");
diff --git a/drivers/leds/leds-lm3530.c b/drivers/leds/leds-lm3530.c
index 0630e4f..45e6878 100644
--- a/drivers/leds/leds-lm3530.c
+++ b/drivers/leds/leds-lm3530.c
@@ -457,18 +457,7 @@ static struct i2c_driver lm3530_i2c_driver = {
 	},
 };
 
-static int __init lm3530_init(void)
-{
-	return i2c_add_driver(&lm3530_i2c_driver);
-}
-
-static void __exit lm3530_exit(void)
-{
-	i2c_del_driver(&lm3530_i2c_driver);
-}
-
-module_init(lm3530_init);
-module_exit(lm3530_exit);
+module_i2c_driver(lm3530_i2c_driver);
 
 MODULE_DESCRIPTION("Back Light driver for LM3530");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/leds/leds-lp3944.c b/drivers/leds/leds-lp3944.c
index 9010c05..b8f9f0a 100644
--- a/drivers/leds/leds-lp3944.c
+++ b/drivers/leds/leds-lp3944.c
@@ -453,18 +453,7 @@ static struct i2c_driver lp3944_driver = {
 	.id_table = lp3944_id,
 };
 
-static int __init lp3944_module_init(void)
-{
-	return i2c_add_driver(&lp3944_driver);
-}
-
-static void __exit lp3944_module_exit(void)
-{
-	i2c_del_driver(&lp3944_driver);
-}
-
-module_init(lp3944_module_init);
-module_exit(lp3944_module_exit);
+module_i2c_driver(lp3944_driver);
 
 MODULE_AUTHOR("Antonio Ospite <ospite@studenti.unina.it>");
 MODULE_DESCRIPTION("LP3944 Fun Light Chip");
diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index cb641f1..d62a798 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -797,25 +797,7 @@ static struct i2c_driver lp5521_driver = {
 	.id_table	= lp5521_id,
 };
 
-static int __init lp5521_init(void)
-{
-	int ret;
-
-	ret = i2c_add_driver(&lp5521_driver);
-
-	if (ret < 0)
-		printk(KERN_ALERT "Adding lp5521 driver failed\n");
-
-	return ret;
-}
-
-static void __exit lp5521_exit(void)
-{
-	i2c_del_driver(&lp5521_driver);
-}
-
-module_init(lp5521_init);
-module_exit(lp5521_exit);
+module_i2c_driver(lp5521_driver);
 
 MODULE_AUTHOR("Mathias Nyman, Yuri Zaporozhets, Samu Onkalo");
 MODULE_DESCRIPTION("LP5521 LED engine");
diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index 5971e309..0170760 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -1021,25 +1021,7 @@ static struct i2c_driver lp5523_driver = {
 	.id_table	= lp5523_id,
 };
 
-static int __init lp5523_init(void)
-{
-	int ret;
-
-	ret = i2c_add_driver(&lp5523_driver);
-
-	if (ret < 0)
-		printk(KERN_ALERT "Adding lp5523 driver failed\n");
-
-	return ret;
-}
-
-static void __exit lp5523_exit(void)
-{
-	i2c_del_driver(&lp5523_driver);
-}
-
-module_init(lp5523_init);
-module_exit(lp5523_exit);
+module_i2c_driver(lp5523_driver);
 
 MODULE_AUTHOR("Mathias Nyman <mathias.nyman@nokia.com>");
 MODULE_DESCRIPTION("LP5523 LED engine");
diff --git a/drivers/leds/leds-pca9532.c b/drivers/leds/leds-pca9532.c
index a2c8746..ceccab4 100644
--- a/drivers/leds/leds-pca9532.c
+++ b/drivers/leds/leds-pca9532.c
@@ -489,20 +489,8 @@ static int pca9532_remove(struct i2c_client *client)
 	return 0;
 }
 
-static int __init pca9532_init(void)
-{
-	return i2c_add_driver(&pca9532_driver);
-}
-
-static void __exit pca9532_exit(void)
-{
-	i2c_del_driver(&pca9532_driver);
-}
+module_i2c_driver(pca9532_driver);
 
 MODULE_AUTHOR("Riku Voipio");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("PCA 9532 LED dimmer");
-
-module_init(pca9532_init);
-module_exit(pca9532_exit);
-
diff --git a/drivers/leds/leds-pca955x.c b/drivers/leds/leds-pca955x.c
index 66aa3e8..dcc3bc3 100644
--- a/drivers/leds/leds-pca955x.c
+++ b/drivers/leds/leds-pca955x.c
@@ -371,18 +371,7 @@ static struct i2c_driver pca955x_driver = {
 	.id_table = pca955x_id,
 };
 
-static int __init pca955x_leds_init(void)
-{
-	return i2c_add_driver(&pca955x_driver);
-}
-
-static void __exit pca955x_leds_exit(void)
-{
-	i2c_del_driver(&pca955x_driver);
-}
-
-module_init(pca955x_leds_init);
-module_exit(pca955x_leds_exit);
+module_i2c_driver(pca955x_driver);
 
 MODULE_AUTHOR("Nate Case <ncase@xes-inc.com>");
 MODULE_DESCRIPTION("PCA955x LED driver");
-- 
1.7.5.4



