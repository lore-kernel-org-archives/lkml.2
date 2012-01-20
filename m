Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303Ab2ATNMe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 08:12:34 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47661 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab2ATNMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 08:12:30 -0500
Message-ID: <1327065142.15205.4.camel@phoenix>
Subject: [PATCH RESEND] platform-drivers-x86: convert drivers/platform/x86/*
 to use module_platform_driver()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Hong Liu <hong.liu@intel.com>, Durgadoss R <durgadoss.r@intel.com>,
        Daniel Drake <dsd@laptop.org>, Matthew Garrett <mjg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        platform-driver-x86@vger.kernel.org
Date: Fri, 20 Jan 2012 21:12:22 +0800
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

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Hong Liu <hong.liu@intel.com>
Cc: Durgadoss R <durgadoss.r@intel.com>
Cc: Daniel Drake <dsd@laptop.org>
Cc: Matthew Garrett <mjg@redhat.com>
Acked-by: Durgadoss R <Durgadoss.r@intel.com>
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



