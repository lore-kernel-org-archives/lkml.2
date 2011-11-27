Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab1K0GwD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 01:52:03 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36645 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab1K0Gv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 01:51:58 -0500
Message-ID: <1322376711.2226.5.camel@phoenix>
Subject: [PATCH] ide: convert drivers/ide/* to use module_platform_driver()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ralf Baechle <ralf@linux-mips.org>, Kumar Gala <galak@kernel.crashing.org>,
        "David S. Miller" <davem@davemloft.net>, linux-ide@vger.kernel.org
Date: Sun, 27 Nov 2011 14:51:51 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the drivers in drivers/ide/* to use the
module_platform_driver() macro which makes the code smaller and a bit
simpler.

Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Kumar Gala <galak@kernel.crashing.org>
Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/ide/au1xxx-ide.c   |   13 +------------
 drivers/ide/ide_platform.c |   13 +------------
 2 files changed, 2 insertions(+), 24 deletions(-)

diff --git a/drivers/ide/au1xxx-ide.c b/drivers/ide/au1xxx-ide.c
index 259786c..07ea580 100644
--- a/drivers/ide/au1xxx-ide.c
+++ b/drivers/ide/au1xxx-ide.c
@@ -592,18 +592,7 @@ static struct platform_driver au1200_ide_driver = {
 	.remove		= au_ide_remove,
 };
 
-static int __init au_ide_init(void)
-{
-	return platform_driver_register(&au1200_ide_driver);
-}
-
-static void __exit au_ide_exit(void)
-{
-	platform_driver_unregister(&au1200_ide_driver);
-}
+module_platform_driver(au1200_ide_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("AU1200 IDE driver");
-
-module_init(au_ide_init);
-module_exit(au_ide_exit);
diff --git a/drivers/ide/ide_platform.c b/drivers/ide/ide_platform.c
index 962693b..3357e2d 100644
--- a/drivers/ide/ide_platform.c
+++ b/drivers/ide/ide_platform.c
@@ -133,19 +133,8 @@ static struct platform_driver platform_ide_driver = {
 	.remove = __devexit_p(plat_ide_remove),
 };
 
-static int __init platform_ide_init(void)
-{
-	return platform_driver_register(&platform_ide_driver);
-}
-
-static void __exit platform_ide_exit(void)
-{
-	platform_driver_unregister(&platform_ide_driver);
-}
+module_platform_driver(platform_ide_driver);
 
 MODULE_DESCRIPTION("Platform IDE driver");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:pata_platform");
-
-module_init(platform_ide_init);
-module_exit(platform_ide_exit);
-- 
1.7.5.4



