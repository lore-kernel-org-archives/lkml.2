Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923Ab1K1Div (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 22:38:51 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54807 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab1K1Diu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 22:38:50 -0500
Message-ID: <1322451519.24694.1.camel@phoenix>
Subject: [PATCH] regulator: Convert virtual and userspace regulator consumer
 drivers to use module_platform_driver()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Mon, 28 Nov 2011 11:38:39 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts virtual and userspace regulator consumer drivers to use the
module_platform_driver() macro which makes the code smaller and a bit simpler.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/userspace-consumer.c |   13 +------------
 drivers/regulator/virtual.c            |   12 +-----------
 2 files changed, 2 insertions(+), 23 deletions(-)

diff --git a/drivers/regulator/userspace-consumer.c b/drivers/regulator/userspace-consumer.c
index fc66551..518667e 100644
--- a/drivers/regulator/userspace-consumer.c
+++ b/drivers/regulator/userspace-consumer.c
@@ -185,18 +185,7 @@ static struct platform_driver regulator_userspace_consumer_driver = {
 	},
 };
 
-
-static int __init regulator_userspace_consumer_init(void)
-{
-	return platform_driver_register(&regulator_userspace_consumer_driver);
-}
-module_init(regulator_userspace_consumer_init);
-
-static void __exit regulator_userspace_consumer_exit(void)
-{
-	platform_driver_unregister(&regulator_userspace_consumer_driver);
-}
-module_exit(regulator_userspace_consumer_exit);
+module_platform_driver(regulator_userspace_consumer_driver);
 
 MODULE_AUTHOR("Mike Rapoport <mike@compulab.co.il>");
 MODULE_DESCRIPTION("Userspace consumer for voltage and current regulators");
diff --git a/drivers/regulator/virtual.c b/drivers/regulator/virtual.c
index 858c1f86..ee0b161 100644
--- a/drivers/regulator/virtual.c
+++ b/drivers/regulator/virtual.c
@@ -352,17 +352,7 @@ static struct platform_driver regulator_virtual_consumer_driver = {
 	},
 };
 
-static int __init regulator_virtual_consumer_init(void)
-{
-	return platform_driver_register(&regulator_virtual_consumer_driver);
-}
-module_init(regulator_virtual_consumer_init);
-
-static void __exit regulator_virtual_consumer_exit(void)
-{
-	platform_driver_unregister(&regulator_virtual_consumer_driver);
-}
-module_exit(regulator_virtual_consumer_exit);
+module_platform_driver(regulator_virtual_consumer_driver);
 
 MODULE_AUTHOR("Mark Brown <broonie@opensource.wolfsonmicro.com>");
 MODULE_DESCRIPTION("Virtual regulator consumer");
-- 
1.7.5.4



