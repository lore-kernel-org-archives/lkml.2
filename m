Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750929Ab2AVHeE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 02:34:04 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48174 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722Ab2AVHeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 02:34:03 -0500
Message-ID: <1327217629.6497.0.camel@phoenix>
Subject: [PATCH 1/3] MISC: convert drivers/misc/* to use
 module_platform_driver()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "Ira W. Snyder" <iws@ovro.caltech.edu>,
        Pratyush Anand <pratyush.anand@st.com>,
        Pavan Savoy <pavan_savoy@ti.com>, Donggeun Kim <dg77.kim@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <greg@kroah.com>
Date: Sun, 22 Jan 2012 15:33:49 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the drivers in drivers/misc/* to use the
module_platform_driver() macro which makes the code smaller and a bit
simpler.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Ira W. Snyder <iws@ovro.caltech.edu>
Cc: Pratyush Anand <pratyush.anand@st.com>
Cc: Pavan Savoy <pavan_savoy@ti.com>
Cc: Donggeun Kim <dg77.kim@samsung.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Pratyush Anand <pratyush.anand@st.com>
---
 drivers/misc/carma/carma-fpga.c      |   17 +----------------
 drivers/misc/max8997-muic.c          |   12 +-----------
 drivers/misc/spear13xx_pcie_gadget.c |   12 +-----------
 drivers/misc/ti-st/st_kim.c          |   13 +------------
 4 files changed, 4 insertions(+), 50 deletions(-)

diff --git a/drivers/misc/carma/carma-fpga.c b/drivers/misc/carma/carma-fpga.c
index 14e974b2..366bc15 100644
--- a/drivers/misc/carma/carma-fpga.c
+++ b/drivers/misc/carma/carma-fpga.c
@@ -1410,23 +1410,8 @@ static struct platform_driver data_of_driver = {
 	},
 };
 
-/*
- * Module Init / Exit
- */
-
-static int __init data_init(void)
-{
-	return platform_driver_register(&data_of_driver);
-}
-
-static void __exit data_exit(void)
-{
-	platform_driver_unregister(&data_of_driver);
-}
+module_platform_driver(data_of_driver);
 
 MODULE_AUTHOR("Ira W. Snyder <iws@ovro.caltech.edu>");
 MODULE_DESCRIPTION("CARMA DATA-FPGA Access Driver");
 MODULE_LICENSE("GPL");
-
-module_init(data_init);
-module_exit(data_exit);
diff --git a/drivers/misc/max8997-muic.c b/drivers/misc/max8997-muic.c
index d74ef41..19591ea 100644
--- a/drivers/misc/max8997-muic.c
+++ b/drivers/misc/max8997-muic.c
@@ -488,17 +488,7 @@ static struct platform_driver max8997_muic_driver = {
 	.remove		= __devexit_p(max8997_muic_remove),
 };
 
-static int __init max8997_muic_init(void)
-{
-	return platform_driver_register(&max8997_muic_driver);
-}
-module_init(max8997_muic_init);
-
-static void __exit max8997_muic_exit(void)
-{
-	platform_driver_unregister(&max8997_muic_driver);
-}
-module_exit(max8997_muic_exit);
+module_platform_driver(max8997_muic_driver);
 
 MODULE_DESCRIPTION("Maxim MAX8997 MUIC driver");
 MODULE_AUTHOR("Donggeun Kim <dg77.kim@samsung.com>");
diff --git a/drivers/misc/spear13xx_pcie_gadget.c b/drivers/misc/spear13xx_pcie_gadget.c
index 43d073b..123ed98 100644
--- a/drivers/misc/spear13xx_pcie_gadget.c
+++ b/drivers/misc/spear13xx_pcie_gadget.c
@@ -891,17 +891,7 @@ static struct platform_driver spear_pcie_gadget_driver = {
 	},
 };
 
-static int __init spear_pcie_gadget_init(void)
-{
-	return platform_driver_register(&spear_pcie_gadget_driver);
-}
-module_init(spear_pcie_gadget_init);
-
-static void __exit spear_pcie_gadget_exit(void)
-{
-	platform_driver_unregister(&spear_pcie_gadget_driver);
-}
-module_exit(spear_pcie_gadget_exit);
+module_platform_driver(spear_pcie_gadget_driver);
 
 MODULE_ALIAS("platform:pcie-gadget-spear");
 MODULE_AUTHOR("Pratyush Anand");
diff --git a/drivers/misc/ti-st/st_kim.c b/drivers/misc/ti-st/st_kim.c
index a7a861c..7c14f8f 100644
--- a/drivers/misc/ti-st/st_kim.c
+++ b/drivers/misc/ti-st/st_kim.c
@@ -837,19 +837,8 @@ static struct platform_driver kim_platform_driver = {
 	},
 };
 
-static int __init st_kim_init(void)
-{
-	return platform_driver_register(&kim_platform_driver);
-}
-
-static void __exit st_kim_deinit(void)
-{
-	platform_driver_unregister(&kim_platform_driver);
-}
-
+module_platform_driver(kim_platform_driver);
 
-module_init(st_kim_init);
-module_exit(st_kim_deinit);
 MODULE_AUTHOR("Pavan Savoy <pavan_savoy@ti.com>");
 MODULE_DESCRIPTION("Shared Transport Driver for TI BT/FM/GPS combo chips ");
 MODULE_LICENSE("GPL");
-- 
1.7.5.4



