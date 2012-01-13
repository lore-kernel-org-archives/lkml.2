Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab2AMIf5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 03:35:57 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:41064 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218Ab2AMIfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 03:35:55 -0500
Message-ID: <1326443748.5482.3.camel@phoenix>
Subject: [PATCH 1/2] backlight: Convert backlight i2c drivers to
 module_i2c_driver
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Michael Hennerich <hennerich@blackfin.uclinux.org>,
        Dmitry Baryshkov <dbaryshkov@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 13 Jan 2012 16:35:48 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out some boilerplate code for i2c driver registration into
module_i2c_driver.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Michael Hennerich <hennerich@blackfin.uclinux.org>
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/video/backlight/adp8860_bl.c |   12 +-----------
 drivers/video/backlight/adp8870_bl.c |   12 +-----------
 drivers/video/backlight/tosa_bl.c    |   13 +------------
 3 files changed, 3 insertions(+), 34 deletions(-)

diff --git a/drivers/video/backlight/adp8860_bl.c b/drivers/video/backlight/adp8860_bl.c
index 378276c..550dbf0 100644
--- a/drivers/video/backlight/adp8860_bl.c
+++ b/drivers/video/backlight/adp8860_bl.c
@@ -819,17 +819,7 @@ static struct i2c_driver adp8860_driver = {
 	.id_table = adp8860_id,
 };
 
-static int __init adp8860_init(void)
-{
-	return i2c_add_driver(&adp8860_driver);
-}
-module_init(adp8860_init);
-
-static void __exit adp8860_exit(void)
-{
-	i2c_del_driver(&adp8860_driver);
-}
-module_exit(adp8860_exit);
+module_i2c_driver(adp8860_driver);
 
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
diff --git a/drivers/video/backlight/adp8870_bl.c b/drivers/video/backlight/adp8870_bl.c
index 6735059..9be58c6 100644
--- a/drivers/video/backlight/adp8870_bl.c
+++ b/drivers/video/backlight/adp8870_bl.c
@@ -991,17 +991,7 @@ static struct i2c_driver adp8870_driver = {
 	.id_table = adp8870_id,
 };
 
-static int __init adp8870_init(void)
-{
-	return i2c_add_driver(&adp8870_driver);
-}
-module_init(adp8870_init);
-
-static void __exit adp8870_exit(void)
-{
-	i2c_del_driver(&adp8870_driver);
-}
-module_exit(adp8870_exit);
+module_i2c_driver(adp8870_driver);
 
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
diff --git a/drivers/video/backlight/tosa_bl.c b/drivers/video/backlight/tosa_bl.c
index 425a736..2b241ab 100644
--- a/drivers/video/backlight/tosa_bl.c
+++ b/drivers/video/backlight/tosa_bl.c
@@ -181,18 +181,7 @@ static struct i2c_driver tosa_bl_driver = {
 	.id_table	= tosa_bl_id,
 };
 
-static int __init tosa_bl_init(void)
-{
-	return i2c_add_driver(&tosa_bl_driver);
-}
-
-static void __exit tosa_bl_exit(void)
-{
-	i2c_del_driver(&tosa_bl_driver);
-}
-
-module_init(tosa_bl_init);
-module_exit(tosa_bl_exit);
+module_i2c_driver(tosa_bl_driver);
 
 MODULE_AUTHOR("Dmitry Baryshkov");
 MODULE_LICENSE("GPL v2");
-- 
1.7.5.4



