Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751012Ab1K0FEe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 00:04:34 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41694 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749Ab1K0FEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 00:04:32 -0500
Message-ID: <1322370265.2522.5.camel@phoenix>
Subject: [PATCH] sbus: convert drivers/sbus/char/* to use
 module_platform_driver()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Andrew Morton <akpm@linux-foundation.org>, sparclinux@vger.kernel.org
Date: Sun, 27 Nov 2011 13:04:25 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the drivers in drivers/sbus/char/* to use the
module_platform_driver() macro which makes the code smaller and a bit
simpler.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/sbus/char/bbc_i2c.c     |   13 +------------
 drivers/sbus/char/display7seg.c |   13 +------------
 drivers/sbus/char/envctrl.c     |   12 +-----------
 drivers/sbus/char/flash.c       |   12 +-----------
 drivers/sbus/char/uctrl.c       |   12 +-----------
 5 files changed, 5 insertions(+), 57 deletions(-)

diff --git a/drivers/sbus/char/bbc_i2c.c b/drivers/sbus/char/bbc_i2c.c
index 5f94d22..5e0341d 100644
--- a/drivers/sbus/char/bbc_i2c.c
+++ b/drivers/sbus/char/bbc_i2c.c
@@ -422,17 +422,6 @@ static struct platform_driver bbc_i2c_driver = {
 	.remove		= __devexit_p(bbc_i2c_remove),
 };
 
-static int __init bbc_i2c_init(void)
-{
-	return platform_driver_register(&bbc_i2c_driver);
-}
-
-static void __exit bbc_i2c_exit(void)
-{
-	platform_driver_unregister(&bbc_i2c_driver);
-}
-
-module_init(bbc_i2c_init);
-module_exit(bbc_i2c_exit);
+module_platform_driver(bbc_i2c_driver);
 
 MODULE_LICENSE("GPL");
diff --git a/drivers/sbus/char/display7seg.c b/drivers/sbus/char/display7seg.c
index 965a1fc..4b99397 100644
--- a/drivers/sbus/char/display7seg.c
+++ b/drivers/sbus/char/display7seg.c
@@ -275,15 +275,4 @@ static struct platform_driver d7s_driver = {
 	.remove		= __devexit_p(d7s_remove),
 };
 
-static int __init d7s_init(void)
-{
-	return platform_driver_register(&d7s_driver);
-}
-
-static void __exit d7s_exit(void)
-{
-	platform_driver_unregister(&d7s_driver);
-}
-
-module_init(d7s_init);
-module_exit(d7s_exit);
+module_platform_driver(d7s_driver);
diff --git a/drivers/sbus/char/envctrl.c b/drivers/sbus/char/envctrl.c
index be7b4e5..339fd6f 100644
--- a/drivers/sbus/char/envctrl.c
+++ b/drivers/sbus/char/envctrl.c
@@ -1138,16 +1138,6 @@ static struct platform_driver envctrl_driver = {
 	.remove		= __devexit_p(envctrl_remove),
 };
 
-static int __init envctrl_init(void)
-{
-	return platform_driver_register(&envctrl_driver);
-}
-
-static void __exit envctrl_exit(void)
-{
-	platform_driver_unregister(&envctrl_driver);
-}
+module_platform_driver(envctrl_driver);
 
-module_init(envctrl_init);
-module_exit(envctrl_exit);
 MODULE_LICENSE("GPL");
diff --git a/drivers/sbus/char/flash.c b/drivers/sbus/char/flash.c
index 73dd4e7..826157f 100644
--- a/drivers/sbus/char/flash.c
+++ b/drivers/sbus/char/flash.c
@@ -216,16 +216,6 @@ static struct platform_driver flash_driver = {
 	.remove		= __devexit_p(flash_remove),
 };
 
-static int __init flash_init(void)
-{
-	return platform_driver_register(&flash_driver);
-}
-
-static void __exit flash_cleanup(void)
-{
-	platform_driver_unregister(&flash_driver);
-}
+module_platform_driver(flash_driver);
 
-module_init(flash_init);
-module_exit(flash_cleanup);
 MODULE_LICENSE("GPL");
diff --git a/drivers/sbus/char/uctrl.c b/drivers/sbus/char/uctrl.c
index ebce963..0b31658 100644
--- a/drivers/sbus/char/uctrl.c
+++ b/drivers/sbus/char/uctrl.c
@@ -435,16 +435,6 @@ static struct platform_driver uctrl_driver = {
 };
 
 
-static int __init uctrl_init(void)
-{
-	return platform_driver_register(&uctrl_driver);
-}
-
-static void __exit uctrl_exit(void)
-{
-	platform_driver_unregister(&uctrl_driver);
-}
+module_platform_driver(uctrl_driver);
 
-module_init(uctrl_init);
-module_exit(uctrl_exit);
 MODULE_LICENSE("GPL");
-- 
1.7.5.4



