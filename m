Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340Ab1KZEOq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 23:14:46 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44232 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab1KZEOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 23:14:44 -0500
Message-ID: <1322280877.6458.3.camel@phoenix>
Subject: [PATCH] platform-drivers-x86: convert drivers/platform/x86/* to use
 module_platform_driver()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Hong Liu <hong.liu@intel.com>, Durgadoss R <durgadoss.r@intel.com>,
        Daniel Drake <dsd@laptop.org>, Matthew Garrett <mjg@redhat.com>,
        platform-driver-x86@vger.kernel.org
Date: Sat, 26 Nov 2011 12:14:37 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the drivers in drivers/platform/x86/* to use the
module_platform_driver() macro which makes the code smaller and a bit
simpler.

Cc: Hong Liu <hong.liu@intel.com>
Cc: Durgadoss R <durgadoss.r@intel.com>
Cc: Daniel Drake <dsd@laptop.org>
Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/platform/x86/intel_mid_powerbtn.c |   12 +-----------
 drivers/platform/x86/intel_mid_thermal.c  |   13 +------------
 drivers/platform/x86/xo1-rfkill.c         |   13 +------------
 3 files changed, 3 insertions(+), 35 deletions(-)

diff --git a/drivers/platform/x86/intel_mid_powerbtn.c b/drivers/platform/x86/intel_mid_powerbtn.c
index f1ae507..ff3de34 100644
--- a/drivers/platform/x86/intel_mid_powerbtn.c
+++ b/drivers/platform/x86/intel_mid_powerbtn.c
@@ -118,17 +118,7 @@ static struct platform_driver mfld_pb_driver = {
 	.remove	= __devexit_p(mfld_pb_remove),
 };
 
-static int __init mfld_pb_init(void)
-{
-	return platform_driver_register(&mfld_pb_driver);
-}
-module_init(mfld_pb_init);
-
-static void __exit mfld_pb_exit(void)
-{
-	platform_driver_unregister(&mfld_pb_driver);
-}
-module_exit(mfld_pb_exit);
+module_platform_driver(mfld_pb_driver);
 
 MODULE_AUTHOR("Hong Liu <hong.liu@intel.com>");
 MODULE_DESCRIPTION("Intel Medfield Power Button Driver");
diff --git a/drivers/platform/x86/intel_mid_thermal.c b/drivers/platform/x86/intel_mid_thermal.c
index ccd7b1f..e4cc992 100644
--- a/drivers/platform/x86/intel_mid_thermal.c
+++ b/drivers/platform/x86/intel_mid_thermal.c
@@ -565,18 +565,7 @@ static struct platform_driver mid_thermal_driver = {
 	.id_table = therm_id_table,
 };
 
-static int __init mid_thermal_module_init(void)
-{
-	return platform_driver_register(&mid_thermal_driver);
-}
-
-static void __exit mid_thermal_module_exit(void)
-{
-	platform_driver_unregister(&mid_thermal_driver);
-}
-
-module_init(mid_thermal_module_init);
-module_exit(mid_thermal_module_exit);
+module_platform_driver(mid_thermal_driver);
 
 MODULE_AUTHOR("Durgadoss R <durgadoss.r@intel.com>");
 MODULE_DESCRIPTION("Intel Medfield Platform Thermal Driver");
diff --git a/drivers/platform/x86/xo1-rfkill.c b/drivers/platform/x86/xo1-rfkill.c
index e549eee..41781ed 100644
--- a/drivers/platform/x86/xo1-rfkill.c
+++ b/drivers/platform/x86/xo1-rfkill.c
@@ -67,19 +67,8 @@ static struct platform_driver xo1_rfkill_driver = {
 	.remove		= __devexit_p(xo1_rfkill_remove),
 };
 
-static int __init xo1_rfkill_init(void)
-{
-	return platform_driver_register(&xo1_rfkill_driver);
-}
-
-static void __exit xo1_rfkill_exit(void)
-{
-	platform_driver_unregister(&xo1_rfkill_driver);
-}
+module_platform_driver(xo1_rfkill_driver);
 
 MODULE_AUTHOR("Daniel Drake <dsd@laptop.org>");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:xo1-rfkill");
-
-module_init(xo1_rfkill_init);
-module_exit(xo1_rfkill_exit);
-- 
1.7.5.4



