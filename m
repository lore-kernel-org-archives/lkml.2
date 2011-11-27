Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab1K0MpR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 07:45:17 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61680 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754956Ab1K0MpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 07:45:14 -0500
Message-ID: <1322397903.2799.5.camel@phoenix>
Subject: [PATCH] mtd: convert drivers/mtd/* to use module_platform_driver()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>,
        Jiandong Zheng <jdzheng@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Wan ZongShun <mcuos.com@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Jamie Iles <jamie@jamieiles.com>, Olof Johansson <olof@lixom.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Manuel Lauss <manuel.lauss@googlemail.com>,
        Vimal Singh <vimal.newwork@gmail.com>,
        Andres Salomon <dilinger@queued.net>, Sukumar Ghorai <s-ghorai@ti.com>,
        linux-mtd@lists.infradead.org
Date: Sun, 27 Nov 2011 20:45:03 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the drivers in drivers/mtd/* to use the
module_platform_driver() macro which makes the code smaller and a bit
simpler.

Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Jiandong Zheng <jdzheng@broadcom.com>
Cc: Scott Branden <sbranden@broadcom.com>
Cc: Wan ZongShun <mcuos.com@gmail.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Jamie Iles <jamie@jamieiles.com>
Cc: Olof Johansson <olof@lixom.net>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Brian Norris <computersforpeace@gmail.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Manuel Lauss <manuel.lauss@googlemail.com>
Cc: Vimal Singh <vimal.newwork@gmail.com>
Cc: Andres Salomon <dilinger@queued.net>
Cc: Sukumar Ghorai <s-ghorai@ti.com>
Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mtd/maps/bcm963xx-flash.c   |   13 +------------
 drivers/mtd/maps/bfin-async-flash.c |   12 +-----------
 drivers/mtd/maps/gpio-addr-flash.c  |   12 +-----------
 drivers/mtd/maps/ixp2000.c          |   12 +-----------
 drivers/mtd/maps/ixp4xx.c           |   14 +-------------
 drivers/mtd/maps/latch-addr-flash.c |   12 +-----------
 drivers/mtd/maps/physmap_of.c       |   13 +------------
 drivers/mtd/maps/pxa2xx-flash.c     |   13 +------------
 drivers/mtd/maps/rbtx4939-flash.c   |   13 +------------
 drivers/mtd/maps/sa1100-flash.c     |   13 +------------
 drivers/mtd/maps/sun_uflash.c       |   13 +------------
 drivers/mtd/nand/ams-delta.c        |   12 +-----------
 drivers/mtd/nand/au1550nd.c         |   12 +-----------
 drivers/mtd/nand/bcm_umi_nand.c     |   13 +------------
 drivers/mtd/nand/fsl_elbc_nand.c    |   13 +------------
 drivers/mtd/nand/fsl_upm.c          |   12 +-----------
 drivers/mtd/nand/jz4740_nand.c      |   12 +-----------
 drivers/mtd/nand/mpc5121_nfc.c      |   14 +-------------
 drivers/mtd/nand/ndfc.c             |   13 +------------
 drivers/mtd/nand/nomadik_nand.c     |   14 +-------------
 drivers/mtd/nand/nuc900_nand.c      |   13 +------------
 drivers/mtd/nand/omap2.c            |   15 +--------------
 drivers/mtd/nand/pasemi_nand.c      |   12 +-----------
 drivers/mtd/nand/plat_nand.c        |   13 +------------
 drivers/mtd/nand/pxa3xx_nand.c      |   12 +-----------
 drivers/mtd/nand/sharpsl.c          |   12 +-----------
 drivers/mtd/nand/socrates_nand.c    |   13 +------------
 drivers/mtd/nand/tmio_nand.c        |   13 +------------
 drivers/mtd/onenand/generic.c       |   16 ++--------------
 drivers/mtd/onenand/samsung.c       |   13 +------------
 30 files changed, 31 insertions(+), 356 deletions(-)

diff --git a/drivers/mtd/maps/bcm963xx-flash.c b/drivers/mtd/maps/bcm963xx-flash.c
index 736ca10..56927f5 100644
--- a/drivers/mtd/maps/bcm963xx-flash.c
+++ b/drivers/mtd/maps/bcm963xx-flash.c
@@ -257,18 +257,7 @@ static struct platform_driver bcm63xx_mtd_dev = {
 	},
 };
 
-static int __init bcm963xx_mtd_init(void)
-{
-	return platform_driver_register(&bcm63xx_mtd_dev);
-}
-
-static void __exit bcm963xx_mtd_exit(void)
-{
-	platform_driver_unregister(&bcm63xx_mtd_dev);
-}
-
-module_init(bcm963xx_mtd_init);
-module_exit(bcm963xx_mtd_exit);
+module_platform_driver(bcm63xx_mtd_dev);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Broadcom BCM63xx MTD driver for CFE and RedBoot");
diff --git a/drivers/mtd/maps/bfin-async-flash.c b/drivers/mtd/maps/bfin-async-flash.c
index 6d6b2b5..650126c 100644
--- a/drivers/mtd/maps/bfin-async-flash.c
+++ b/drivers/mtd/maps/bfin-async-flash.c
@@ -190,17 +190,7 @@ static struct platform_driver bfin_flash_driver = {
 	},
 };
 
-static int __init bfin_flash_init(void)
-{
-	return platform_driver_register(&bfin_flash_driver);
-}
-module_init(bfin_flash_init);
-
-static void __exit bfin_flash_exit(void)
-{
-	platform_driver_unregister(&bfin_flash_driver);
-}
-module_exit(bfin_flash_exit);
+module_platform_driver(bfin_flash_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("MTD map driver for Blackfins with flash/ethernet on same async bank");
diff --git a/drivers/mtd/maps/gpio-addr-flash.c b/drivers/mtd/maps/gpio-addr-flash.c
index 1ec66f0..33cce89 100644
--- a/drivers/mtd/maps/gpio-addr-flash.c
+++ b/drivers/mtd/maps/gpio-addr-flash.c
@@ -279,17 +279,7 @@ static struct platform_driver gpio_flash_driver = {
 	},
 };
 
-static int __init gpio_flash_init(void)
-{
-	return platform_driver_register(&gpio_flash_driver);
-}
-module_init(gpio_flash_init);
-
-static void __exit gpio_flash_exit(void)
-{
-	platform_driver_unregister(&gpio_flash_driver);
-}
-module_exit(gpio_flash_exit);
+module_platform_driver(gpio_flash_driver);
 
 MODULE_AUTHOR("Mike Frysinger <vapier@gentoo.org>");
 MODULE_DESCRIPTION("MTD map driver for flashes addressed physically and with gpios");
diff --git a/drivers/mtd/maps/ixp2000.c b/drivers/mtd/maps/ixp2000.c
index 437fcd2..fc7d4d0 100644
--- a/drivers/mtd/maps/ixp2000.c
+++ b/drivers/mtd/maps/ixp2000.c
@@ -246,18 +246,8 @@ static struct platform_driver ixp2000_flash_driver = {
 	},
 };
 
-static int __init ixp2000_flash_init(void)
-{
-	return platform_driver_register(&ixp2000_flash_driver);
-}
-
-static void __exit ixp2000_flash_exit(void)
-{
-	platform_driver_unregister(&ixp2000_flash_driver);
-}
+module_platform_driver(ixp2000_flash_driver);
 
-module_init(ixp2000_flash_init);
-module_exit(ixp2000_flash_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Deepak Saxena <dsaxena@plexity.net>");
 MODULE_ALIAS("platform:IXP2000-Flash");
diff --git a/drivers/mtd/maps/ixp4xx.c b/drivers/mtd/maps/ixp4xx.c
index 3040901..8b54101 100644
--- a/drivers/mtd/maps/ixp4xx.c
+++ b/drivers/mtd/maps/ixp4xx.c
@@ -270,19 +270,7 @@ static struct platform_driver ixp4xx_flash_driver = {
 	},
 };
 
-static int __init ixp4xx_flash_init(void)
-{
-	return platform_driver_register(&ixp4xx_flash_driver);
-}
-
-static void __exit ixp4xx_flash_exit(void)
-{
-	platform_driver_unregister(&ixp4xx_flash_driver);
-}
-
-
-module_init(ixp4xx_flash_init);
-module_exit(ixp4xx_flash_exit);
+module_platform_driver(ixp4xx_flash_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("MTD map driver for Intel IXP4xx systems");
diff --git a/drivers/mtd/maps/latch-addr-flash.c b/drivers/mtd/maps/latch-addr-flash.c
index 119baa7..8fed58e 100644
--- a/drivers/mtd/maps/latch-addr-flash.c
+++ b/drivers/mtd/maps/latch-addr-flash.c
@@ -223,17 +223,7 @@ static struct platform_driver latch_addr_flash_driver = {
 	},
 };
 
-static int __init latch_addr_flash_init(void)
-{
-	return platform_driver_register(&latch_addr_flash_driver);
-}
-module_init(latch_addr_flash_init);
-
-static void __exit latch_addr_flash_exit(void)
-{
-	platform_driver_unregister(&latch_addr_flash_driver);
-}
-module_exit(latch_addr_flash_exit);
+module_platform_driver(latch_addr_flash_driver);
 
 MODULE_AUTHOR("David Griego <dgriego@mvista.com>");
 MODULE_DESCRIPTION("MTD map driver for flashes addressed physically with upper "
diff --git a/drivers/mtd/maps/physmap_of.c b/drivers/mtd/maps/physmap_of.c
index 7d65f9d..2e6fb68 100644
--- a/drivers/mtd/maps/physmap_of.c
+++ b/drivers/mtd/maps/physmap_of.c
@@ -338,18 +338,7 @@ static struct platform_driver of_flash_driver = {
 	.remove		= of_flash_remove,
 };
 
-static int __init of_flash_init(void)
-{
-	return platform_driver_register(&of_flash_driver);
-}
-
-static void __exit of_flash_exit(void)
-{
-	platform_driver_unregister(&of_flash_driver);
-}
-
-module_init(of_flash_init);
-module_exit(of_flash_exit);
+module_platform_driver(of_flash_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Vitaly Wool <vwool@ru.mvista.com>");
diff --git a/drivers/mtd/maps/pxa2xx-flash.c b/drivers/mtd/maps/pxa2xx-flash.c
index 2a25b67..274e399 100644
--- a/drivers/mtd/maps/pxa2xx-flash.c
+++ b/drivers/mtd/maps/pxa2xx-flash.c
@@ -142,18 +142,7 @@ static struct platform_driver pxa2xx_flash_driver = {
 	.shutdown	= pxa2xx_flash_shutdown,
 };
 
-static int __init init_pxa2xx_flash(void)
-{
-	return platform_driver_register(&pxa2xx_flash_driver);
-}
-
-static void __exit cleanup_pxa2xx_flash(void)
-{
-	platform_driver_unregister(&pxa2xx_flash_driver);
-}
-
-module_init(init_pxa2xx_flash);
-module_exit(cleanup_pxa2xx_flash);
+module_platform_driver(pxa2xx_flash_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Nicolas Pitre <nico@fluxnic.net>");
diff --git a/drivers/mtd/maps/rbtx4939-flash.c b/drivers/mtd/maps/rbtx4939-flash.c
index 0237f19..bb7d204 100644
--- a/drivers/mtd/maps/rbtx4939-flash.c
+++ b/drivers/mtd/maps/rbtx4939-flash.c
@@ -137,18 +137,7 @@ static struct platform_driver rbtx4939_flash_driver = {
 	},
 };
 
-static int __init rbtx4939_flash_init(void)
-{
-	return platform_driver_register(&rbtx4939_flash_driver);
-}
-
-static void __exit rbtx4939_flash_exit(void)
-{
-	platform_driver_unregister(&rbtx4939_flash_driver);
-}
-
-module_init(rbtx4939_flash_init);
-module_exit(rbtx4939_flash_exit);
+module_platform_driver(rbtx4939_flash_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("RBTX4939 MTD map driver");
diff --git a/drivers/mtd/maps/sa1100-flash.c b/drivers/mtd/maps/sa1100-flash.c
index fa9c0a9..ac3a290 100644
--- a/drivers/mtd/maps/sa1100-flash.c
+++ b/drivers/mtd/maps/sa1100-flash.c
@@ -394,18 +394,7 @@ static struct platform_driver sa1100_mtd_driver = {
 	},
 };
 
-static int __init sa1100_mtd_init(void)
-{
-	return platform_driver_register(&sa1100_mtd_driver);
-}
-
-static void __exit sa1100_mtd_exit(void)
-{
-	platform_driver_unregister(&sa1100_mtd_driver);
-}
-
-module_init(sa1100_mtd_init);
-module_exit(sa1100_mtd_exit);
+module_platform_driver(sa1100_mtd_driver);
 
 MODULE_AUTHOR("Nicolas Pitre");
 MODULE_DESCRIPTION("SA1100 CFI map driver");
diff --git a/drivers/mtd/maps/sun_uflash.c b/drivers/mtd/maps/sun_uflash.c
index 2d66234..175e537 100644
--- a/drivers/mtd/maps/sun_uflash.c
+++ b/drivers/mtd/maps/sun_uflash.c
@@ -158,15 +158,4 @@ static struct platform_driver uflash_driver = {
 	.remove		= __devexit_p(uflash_remove),
 };
 
-static int __init uflash_init(void)
-{
-	return platform_driver_register(&uflash_driver);
-}
-
-static void __exit uflash_exit(void)
-{
-	platform_driver_unregister(&uflash_driver);
-}
-
-module_init(uflash_init);
-module_exit(uflash_exit);
+module_platform_driver(uflash_driver);
diff --git a/drivers/mtd/nand/ams-delta.c b/drivers/mtd/nand/ams-delta.c
index 9e6b498..3197e97 100644
--- a/drivers/mtd/nand/ams-delta.c
+++ b/drivers/mtd/nand/ams-delta.c
@@ -280,17 +280,7 @@ static struct platform_driver ams_delta_nand_driver = {
 	},
 };
 
-static int __init ams_delta_nand_init(void)
-{
-	return platform_driver_register(&ams_delta_nand_driver);
-}
-module_init(ams_delta_nand_init);
-
-static void __exit ams_delta_nand_exit(void)
-{
-	platform_driver_unregister(&ams_delta_nand_driver);
-}
-module_exit(ams_delta_nand_exit);
+module_platform_driver(ams_delta_nand_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jonathan McDowell <noodles@earth.li>");
diff --git a/drivers/mtd/nand/au1550nd.c b/drivers/mtd/nand/au1550nd.c
index 77fb4e6..73abbc3 100644
--- a/drivers/mtd/nand/au1550nd.c
+++ b/drivers/mtd/nand/au1550nd.c
@@ -560,17 +560,7 @@ static struct platform_driver au1550nd_driver = {
 	.remove		= __devexit_p(au1550nd_remove),
 };
 
-static int __init au1550nd_load(void)
-{
-	return platform_driver_register(&au1550nd_driver);
-};
-
-static void __exit au1550nd_exit(void)
-{
-	platform_driver_unregister(&au1550nd_driver);
-};
-module_init(au1550nd_load);
-module_exit(au1550nd_exit);
+module_platform_driver(au1550nd_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Embedded Edge, LLC");
diff --git a/drivers/mtd/nand/bcm_umi_nand.c b/drivers/mtd/nand/bcm_umi_nand.c
index 46b58d6..50387fd 100644
--- a/drivers/mtd/nand/bcm_umi_nand.c
+++ b/drivers/mtd/nand/bcm_umi_nand.c
@@ -546,18 +546,7 @@ static struct platform_driver nand_driver = {
 	.resume = bcm_umi_nand_resume,
 };
 
-static int __init nand_init(void)
-{
-	return platform_driver_register(&nand_driver);
-}
-
-static void __exit nand_exit(void)
-{
-	platform_driver_unregister(&nand_driver);
-}
-
-module_init(nand_init);
-module_exit(nand_exit);
+module_platform_driver(nand_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Broadcom");
diff --git a/drivers/mtd/nand/fsl_elbc_nand.c b/drivers/mtd/nand/fsl_elbc_nand.c
index eedd8ee..f2f6e87 100644
--- a/drivers/mtd/nand/fsl_elbc_nand.c
+++ b/drivers/mtd/nand/fsl_elbc_nand.c
@@ -971,18 +971,7 @@ static struct platform_driver fsl_elbc_nand_driver = {
 	.remove = fsl_elbc_nand_remove,
 };
 
-static int __init fsl_elbc_nand_init(void)
-{
-	return platform_driver_register(&fsl_elbc_nand_driver);
-}
-
-static void __exit fsl_elbc_nand_exit(void)
-{
-	platform_driver_unregister(&fsl_elbc_nand_driver);
-}
-
-module_init(fsl_elbc_nand_init);
-module_exit(fsl_elbc_nand_exit);
+module_platform_driver(fsl_elbc_nand_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Freescale");
diff --git a/drivers/mtd/nand/fsl_upm.c b/drivers/mtd/nand/fsl_upm.c
index b4f3cc9..45df542 100644
--- a/drivers/mtd/nand/fsl_upm.c
+++ b/drivers/mtd/nand/fsl_upm.c
@@ -353,17 +353,7 @@ static struct platform_driver of_fun_driver = {
 	.remove		= __devexit_p(fun_remove),
 };
 
-static int __init fun_module_init(void)
-{
-	return platform_driver_register(&of_fun_driver);
-}
-module_init(fun_module_init);
-
-static void __exit fun_module_exit(void)
-{
-	platform_driver_unregister(&of_fun_driver);
-}
-module_exit(fun_module_exit);
+module_platform_driver(of_fun_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Anton Vorontsov <avorontsov@ru.mvista.com>");
diff --git a/drivers/mtd/nand/jz4740_nand.c b/drivers/mtd/nand/jz4740_nand.c
index e266407..ac3b9f2 100644
--- a/drivers/mtd/nand/jz4740_nand.c
+++ b/drivers/mtd/nand/jz4740_nand.c
@@ -423,17 +423,7 @@ static struct platform_driver jz_nand_driver = {
 	},
 };
 
-static int __init jz_nand_init(void)
-{
-	return platform_driver_register(&jz_nand_driver);
-}
-module_init(jz_nand_init);
-
-static void __exit jz_nand_exit(void)
-{
-	platform_driver_unregister(&jz_nand_driver);
-}
-module_exit(jz_nand_exit);
+module_platform_driver(jz_nand_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Lars-Peter Clausen <lars@metafoo.de>");
diff --git a/drivers/mtd/nand/mpc5121_nfc.c b/drivers/mtd/nand/mpc5121_nfc.c
index 5ede647..c240cf1 100644
--- a/drivers/mtd/nand/mpc5121_nfc.c
+++ b/drivers/mtd/nand/mpc5121_nfc.c
@@ -879,19 +879,7 @@ static struct platform_driver mpc5121_nfc_driver = {
 	},
 };
 
-static int __init mpc5121_nfc_init(void)
-{
-	return platform_driver_register(&mpc5121_nfc_driver);
-}
-
-module_init(mpc5121_nfc_init);
-
-static void __exit mpc5121_nfc_cleanup(void)
-{
-	platform_driver_unregister(&mpc5121_nfc_driver);
-}
-
-module_exit(mpc5121_nfc_cleanup);
+module_platform_driver(mpc5121_nfc_driver);
 
 MODULE_AUTHOR("Freescale Semiconductor, Inc.");
 MODULE_DESCRIPTION("MPC5121 NAND MTD driver");
diff --git a/drivers/mtd/nand/ndfc.c b/drivers/mtd/nand/ndfc.c
index f8aacf4..ec68854 100644
--- a/drivers/mtd/nand/ndfc.c
+++ b/drivers/mtd/nand/ndfc.c
@@ -294,18 +294,7 @@ static struct platform_driver ndfc_driver = {
 	.remove = __devexit_p(ndfc_remove),
 };
 
-static int __init ndfc_nand_init(void)
-{
-	return platform_driver_register(&ndfc_driver);
-}
-
-static void __exit ndfc_nand_exit(void)
-{
-	platform_driver_unregister(&ndfc_driver);
-}
-
-module_init(ndfc_nand_init);
-module_exit(ndfc_nand_exit);
+module_platform_driver(ndfc_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Thomas Gleixner <tglx@linutronix.de>");
diff --git a/drivers/mtd/nand/nomadik_nand.c b/drivers/mtd/nand/nomadik_nand.c
index b463ecf..673dc6c 100644
--- a/drivers/mtd/nand/nomadik_nand.c
+++ b/drivers/mtd/nand/nomadik_nand.c
@@ -228,19 +228,7 @@ static struct platform_driver nomadik_nand_driver = {
 	},
 };
 
-static int __init nand_nomadik_init(void)
-{
-	pr_info("Nomadik NAND driver\n");
-	return platform_driver_register(&nomadik_nand_driver);
-}
-
-static void __exit nand_nomadik_exit(void)
-{
-	platform_driver_unregister(&nomadik_nand_driver);
-}
-
-module_init(nand_nomadik_init);
-module_exit(nand_nomadik_exit);
+module_platform_driver(nomadik_nand_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("ST Microelectronics (sachin.verma@st.com)");
diff --git a/drivers/mtd/nand/nuc900_nand.c b/drivers/mtd/nand/nuc900_nand.c
index fa8faed..8febe46 100644
--- a/drivers/mtd/nand/nuc900_nand.c
+++ b/drivers/mtd/nand/nuc900_nand.c
@@ -364,18 +364,7 @@ static struct platform_driver nuc900_nand_driver = {
 	},
 };
 
-static int __init nuc900_nand_init(void)
-{
-	return platform_driver_register(&nuc900_nand_driver);
-}
-
-static void __exit nuc900_nand_exit(void)
-{
-	platform_driver_unregister(&nuc900_nand_driver);
-}
-
-module_init(nuc900_nand_init);
-module_exit(nuc900_nand_exit);
+module_platform_driver(nuc900_nand_driver);
 
 MODULE_AUTHOR("Wan ZongShun <mcuos.com@gmail.com>");
 MODULE_DESCRIPTION("w90p910/NUC9xx nand driver!");
diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
index f745f00..b3a883e 100644
--- a/drivers/mtd/nand/omap2.c
+++ b/drivers/mtd/nand/omap2.c
@@ -1145,20 +1145,7 @@ static struct platform_driver omap_nand_driver = {
 	},
 };
 
-static int __init omap_nand_init(void)
-{
-	pr_info("%s driver initializing\n", DRIVER_NAME);
-
-	return platform_driver_register(&omap_nand_driver);
-}
-
-static void __exit omap_nand_exit(void)
-{
-	platform_driver_unregister(&omap_nand_driver);
-}
-
-module_init(omap_nand_init);
-module_exit(omap_nand_exit);
+module_platform_driver(omap_nand_driver);
 
 MODULE_ALIAS("platform:" DRIVER_NAME);
 MODULE_LICENSE("GPL");
diff --git a/drivers/mtd/nand/pasemi_nand.c b/drivers/mtd/nand/pasemi_nand.c
index a97264e..974dbf8 100644
--- a/drivers/mtd/nand/pasemi_nand.c
+++ b/drivers/mtd/nand/pasemi_nand.c
@@ -230,17 +230,7 @@ static struct platform_driver pasemi_nand_driver =
 	.remove		= pasemi_nand_remove,
 };
 
-static int __init pasemi_nand_init(void)
-{
-	return platform_driver_register(&pasemi_nand_driver);
-}
-module_init(pasemi_nand_init);
-
-static void __exit pasemi_nand_exit(void)
-{
-	platform_driver_unregister(&pasemi_nand_driver);
-}
-module_exit(pasemi_nand_exit);
+module_platform_driver(pasemi_nand_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Egor Martovetsky <egor@pasemi.com>");
diff --git a/drivers/mtd/nand/plat_nand.c b/drivers/mtd/nand/plat_nand.c
index ea8e123..7f2da69 100644
--- a/drivers/mtd/nand/plat_nand.c
+++ b/drivers/mtd/nand/plat_nand.c
@@ -148,18 +148,7 @@ static struct platform_driver plat_nand_driver = {
 	},
 };
 
-static int __init plat_nand_init(void)
-{
-	return platform_driver_register(&plat_nand_driver);
-}
-
-static void __exit plat_nand_exit(void)
-{
-	platform_driver_unregister(&plat_nand_driver);
-}
-
-module_init(plat_nand_init);
-module_exit(plat_nand_exit);
+module_platform_driver(plat_nand_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Vitaly Wool");
diff --git a/drivers/mtd/nand/pxa3xx_nand.c b/drivers/mtd/nand/pxa3xx_nand.c
index 9eb7f87..90d6016 100644
--- a/drivers/mtd/nand/pxa3xx_nand.c
+++ b/drivers/mtd/nand/pxa3xx_nand.c
@@ -1311,17 +1311,7 @@ static struct platform_driver pxa3xx_nand_driver = {
 	.resume		= pxa3xx_nand_resume,
 };
 
-static int __init pxa3xx_nand_init(void)
-{
-	return platform_driver_register(&pxa3xx_nand_driver);
-}
-module_init(pxa3xx_nand_init);
-
-static void __exit pxa3xx_nand_exit(void)
-{
-	platform_driver_unregister(&pxa3xx_nand_driver);
-}
-module_exit(pxa3xx_nand_exit);
+module_platform_driver(pxa3xx_nand_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("PXA3xx NAND controller driver");
diff --git a/drivers/mtd/nand/sharpsl.c b/drivers/mtd/nand/sharpsl.c
index 619d2a5..b175c0f 100644
--- a/drivers/mtd/nand/sharpsl.c
+++ b/drivers/mtd/nand/sharpsl.c
@@ -230,17 +230,7 @@ static struct platform_driver sharpsl_nand_driver = {
 	.remove		= __devexit_p(sharpsl_nand_remove),
 };
 
-static int __init sharpsl_nand_init(void)
-{
-	return platform_driver_register(&sharpsl_nand_driver);
-}
-module_init(sharpsl_nand_init);
-
-static void __exit sharpsl_nand_exit(void)
-{
-	platform_driver_unregister(&sharpsl_nand_driver);
-}
-module_exit(sharpsl_nand_exit);
+module_platform_driver(sharpsl_nand_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Richard Purdie <rpurdie@rpsys.net>");
diff --git a/drivers/mtd/nand/socrates_nand.c b/drivers/mtd/nand/socrates_nand.c
index 0fb24f9..e02b08b 100644
--- a/drivers/mtd/nand/socrates_nand.c
+++ b/drivers/mtd/nand/socrates_nand.c
@@ -273,18 +273,7 @@ static struct platform_driver socrates_nand_driver = {
 	.remove		= __devexit_p(socrates_nand_remove),
 };
 
-static int __init socrates_nand_init(void)
-{
-	return platform_driver_register(&socrates_nand_driver);
-}
-
-static void __exit socrates_nand_exit(void)
-{
-	platform_driver_unregister(&socrates_nand_driver);
-}
-
-module_init(socrates_nand_init);
-module_exit(socrates_nand_exit);
+module_platform_driver(socrates_nand_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Ilya Yanok");
diff --git a/drivers/mtd/nand/tmio_nand.c b/drivers/mtd/nand/tmio_nand.c
index beebd95..6caa0cd 100644
--- a/drivers/mtd/nand/tmio_nand.c
+++ b/drivers/mtd/nand/tmio_nand.c
@@ -533,18 +533,7 @@ static struct platform_driver tmio_driver = {
 	.resume		= tmio_resume,
 };
 
-static int __init tmio_init(void)
-{
-	return platform_driver_register(&tmio_driver);
-}
-
-static void __exit tmio_exit(void)
-{
-	platform_driver_unregister(&tmio_driver);
-}
-
-module_init(tmio_init);
-module_exit(tmio_exit);
+module_platform_driver(tmio_driver);
 
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Ian Molton, Dirk Opfer, Chris Humbert, Dmitry Baryshkov");
diff --git a/drivers/mtd/onenand/generic.c b/drivers/mtd/onenand/generic.c
index 7813095..0ccd5bf 100644
--- a/drivers/mtd/onenand/generic.c
+++ b/drivers/mtd/onenand/generic.c
@@ -115,21 +115,9 @@ static struct platform_driver generic_onenand_driver = {
 	.remove		= __devexit_p(generic_onenand_remove),
 };
 
-MODULE_ALIAS("platform:" DRIVER_NAME);
-
-static int __init generic_onenand_init(void)
-{
-	return platform_driver_register(&generic_onenand_driver);
-}
-
-static void __exit generic_onenand_exit(void)
-{
-	platform_driver_unregister(&generic_onenand_driver);
-}
-
-module_init(generic_onenand_init);
-module_exit(generic_onenand_exit);
+module_platform_driver(generic_onenand_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Kyungmin Park <kyungmin.park@samsung.com>");
 MODULE_DESCRIPTION("Glue layer for OneNAND flash on generic boards");
+MODULE_ALIAS("platform:" DRIVER_NAME);
diff --git a/drivers/mtd/onenand/samsung.c b/drivers/mtd/onenand/samsung.c
index 5474547..fa1ee43 100644
--- a/drivers/mtd/onenand/samsung.c
+++ b/drivers/mtd/onenand/samsung.c
@@ -1133,18 +1133,7 @@ static struct platform_driver s3c_onenand_driver = {
 	.remove         = __devexit_p(s3c_onenand_remove),
 };
 
-static int __init s3c_onenand_init(void)
-{
-	return platform_driver_register(&s3c_onenand_driver);
-}
-
-static void __exit s3c_onenand_exit(void)
-{
-	platform_driver_unregister(&s3c_onenand_driver);
-}
-
-module_init(s3c_onenand_init);
-module_exit(s3c_onenand_exit);
+module_platform_driver(s3c_onenand_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Kyungmin Park <kyungmin.park@samsung.com>");
-- 
1.7.5.4



