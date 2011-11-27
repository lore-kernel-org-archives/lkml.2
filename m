Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab1K0Gol (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 01:44:41 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53007 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab1K0Goh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 01:44:37 -0500
Message-ID: <1322376266.2226.3.camel@phoenix>
Subject: [PATCH] SATA/PATA: convert drivers/ata/* to use
 module_platform_driver()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Sylvain Munaut <tnt@246tNt.com>,
        Anton Vorontsov <avorontsov@ru.mvista.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Florian Fainelli <florian@openwrt.org>,
        Mark Miesfeld <mmiesfeld@amcc.com>,
        Ashish Kalra <ashish.kalra@freescale.com>,
        Paul Mundt <lethal@linux-sh.org>, Viresh Kumar <viresh.kumar@st.com>,
        Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org
Date: Sun, 27 Nov 2011 14:44:26 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the drivers in drivers/ata/* to use the
module_platform_driver() macro which makes the code smaller and a bit
simpler.

Cc: Viresh Kumar <viresh.kumar@st.com>
Cc: Jeff Garzik <jgarzik@pobox.com>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Sylvain Munaut <tnt@246tNt.com>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Marek Vasut <marek.vasut@gmail.com>
Cc: Florian Fainelli <florian@openwrt.org>
Cc: Mark Miesfeld <mmiesfeld@amcc.com>
Cc: Ashish Kalra <ashish.kalra@freescale.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/ata/pata_arasan_cf.c   |   12 +-----------
 drivers/ata/pata_at91.c        |   15 +--------------
 drivers/ata/pata_imx.c         |   12 +-----------
 drivers/ata/pata_ixp4xx_cf.c   |   13 +------------
 drivers/ata/pata_mpc52xx.c     |   21 +--------------------
 drivers/ata/pata_of_platform.c |   12 +-----------
 drivers/ata/pata_palmld.c      |   13 +------------
 drivers/ata/pata_platform.c    |   12 +-----------
 drivers/ata/pata_pxa.c         |   13 +------------
 drivers/ata/pata_rb532_cf.c    |   21 ++-------------------
 drivers/ata/sata_dwc_460ex.c   |   13 +------------
 drivers/ata/sata_fsl.c         |   14 +-------------
 12 files changed, 13 insertions(+), 158 deletions(-)

diff --git a/drivers/ata/pata_arasan_cf.c b/drivers/ata/pata_arasan_cf.c
index e8574bb..048589f 100644
--- a/drivers/ata/pata_arasan_cf.c
+++ b/drivers/ata/pata_arasan_cf.c
@@ -963,17 +963,7 @@ static struct platform_driver arasan_cf_driver = {
 	},
 };
 
-static int __init arasan_cf_init(void)
-{
-	return platform_driver_register(&arasan_cf_driver);
-}
-module_init(arasan_cf_init);
-
-static void __exit arasan_cf_exit(void)
-{
-	platform_driver_unregister(&arasan_cf_driver);
-}
-module_exit(arasan_cf_exit);
+module_platform_driver(arasan_cf_driver);
 
 MODULE_AUTHOR("Viresh Kumar <viresh.kumar@st.com>");
 MODULE_DESCRIPTION("Arasan ATA Compact Flash driver");
diff --git a/drivers/ata/pata_at91.c b/drivers/ata/pata_at91.c
index 5249e6d..a7d91a7 100644
--- a/drivers/ata/pata_at91.c
+++ b/drivers/ata/pata_at91.c
@@ -454,20 +454,7 @@ static struct platform_driver pata_at91_driver = {
 	},
 };
 
-static int __init pata_at91_init(void)
-{
-	return platform_driver_register(&pata_at91_driver);
-}
-
-static void __exit pata_at91_exit(void)
-{
-	platform_driver_unregister(&pata_at91_driver);
-}
-
-
-module_init(pata_at91_init);
-module_exit(pata_at91_exit);
-
+module_platform_driver(pata_at91_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Driver for CF in True IDE mode on AT91SAM9260 SoC");
diff --git a/drivers/ata/pata_imx.c b/drivers/ata/pata_imx.c
index ca9d9ca..c5af97f 100644
--- a/drivers/ata/pata_imx.c
+++ b/drivers/ata/pata_imx.c
@@ -235,17 +235,7 @@ static struct platform_driver pata_imx_driver = {
 	},
 };
 
-static int __init pata_imx_init(void)
-{
-	return platform_driver_register(&pata_imx_driver);
-}
-
-static void __exit pata_imx_exit(void)
-{
-	platform_driver_unregister(&pata_imx_driver);
-}
-module_init(pata_imx_init);
-module_exit(pata_imx_exit);
+module_platform_driver(pata_imx_driver);
 
 MODULE_AUTHOR("Arnaud Patard <arnaud.patard@rtp-net.org>");
 MODULE_DESCRIPTION("low-level driver for iMX PATA");
diff --git a/drivers/ata/pata_ixp4xx_cf.c b/drivers/ata/pata_ixp4xx_cf.c
index 15b6431..badb178 100644
--- a/drivers/ata/pata_ixp4xx_cf.c
+++ b/drivers/ata/pata_ixp4xx_cf.c
@@ -205,21 +205,10 @@ static struct platform_driver ixp4xx_pata_platform_driver = {
 	.remove		= __devexit_p(ixp4xx_pata_remove),
 };
 
-static int __init ixp4xx_pata_init(void)
-{
-	return platform_driver_register(&ixp4xx_pata_platform_driver);
-}
-
-static void __exit ixp4xx_pata_exit(void)
-{
-	platform_driver_unregister(&ixp4xx_pata_platform_driver);
-}
+module_platform_driver(ixp4xx_pata_platform_driver);
 
 MODULE_AUTHOR("Alessandro Zummo <a.zummo@towertech.it>");
 MODULE_DESCRIPTION("low-level driver for ixp4xx Compact Flash PATA");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
 MODULE_ALIAS("platform:" DRV_NAME);
-
-module_init(ixp4xx_pata_init);
-module_exit(ixp4xx_pata_exit);
diff --git a/drivers/ata/pata_mpc52xx.c b/drivers/ata/pata_mpc52xx.c
index 3e17463..00748ae 100644
--- a/drivers/ata/pata_mpc52xx.c
+++ b/drivers/ata/pata_mpc52xx.c
@@ -897,26 +897,7 @@ static struct platform_driver mpc52xx_ata_of_platform_driver = {
 	},
 };
 
-
-/* ======================================================================== */
-/* Module                                                                   */
-/* ======================================================================== */
-
-static int __init
-mpc52xx_ata_init(void)
-{
-	printk(KERN_INFO "ata: MPC52xx IDE/ATA libata driver\n");
-	return platform_driver_register(&mpc52xx_ata_of_platform_driver);
-}
-
-static void __exit
-mpc52xx_ata_exit(void)
-{
-	platform_driver_unregister(&mpc52xx_ata_of_platform_driver);
-}
-
-module_init(mpc52xx_ata_init);
-module_exit(mpc52xx_ata_exit);
+module_platform_driver(mpc52xx_ata_of_platform_driver);
 
 MODULE_AUTHOR("Sylvain Munaut <tnt@246tNt.com>");
 MODULE_DESCRIPTION("Freescale MPC52xx IDE/ATA libata driver");
diff --git a/drivers/ata/pata_of_platform.c b/drivers/ata/pata_of_platform.c
index 2a472c5..9f11c35 100644
--- a/drivers/ata/pata_of_platform.c
+++ b/drivers/ata/pata_of_platform.c
@@ -101,17 +101,7 @@ static struct platform_driver pata_of_platform_driver = {
 	.remove		= __devexit_p(pata_of_platform_remove),
 };
 
-static int __init pata_of_platform_init(void)
-{
-	return platform_driver_register(&pata_of_platform_driver);
-}
-module_init(pata_of_platform_init);
-
-static void __exit pata_of_platform_exit(void)
-{
-	platform_driver_unregister(&pata_of_platform_driver);
-}
-module_exit(pata_of_platform_exit);
+module_platform_driver(pata_of_platform_driver);
 
 MODULE_DESCRIPTION("OF-platform PATA driver");
 MODULE_AUTHOR("Anton Vorontsov <avorontsov@ru.mvista.com>");
diff --git a/drivers/ata/pata_palmld.c b/drivers/ata/pata_palmld.c
index b86d7e2..5ff31b6 100644
--- a/drivers/ata/pata_palmld.c
+++ b/drivers/ata/pata_palmld.c
@@ -132,20 +132,9 @@ static struct platform_driver palmld_pata_platform_driver = {
 	.remove		= __devexit_p(palmld_pata_remove),
 };
 
-static int __init palmld_pata_init(void)
-{
-	return platform_driver_register(&palmld_pata_platform_driver);
-}
-
-static void __exit palmld_pata_exit(void)
-{
-	platform_driver_unregister(&palmld_pata_platform_driver);
-}
+module_platform_driver(palmld_pata_platform_driver);
 
 MODULE_AUTHOR("Marek Vasut <marek.vasut@gmail.com>");
 MODULE_DESCRIPTION("PalmLD PATA driver");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:" DRV_NAME);
-
-module_init(palmld_pata_init);
-module_exit(palmld_pata_exit);
diff --git a/drivers/ata/pata_platform.c b/drivers/ata/pata_platform.c
index 2067308..f1848ae 100644
--- a/drivers/ata/pata_platform.c
+++ b/drivers/ata/pata_platform.c
@@ -256,17 +256,7 @@ static struct platform_driver pata_platform_driver = {
 	},
 };
 
-static int __init pata_platform_init(void)
-{
-	return platform_driver_register(&pata_platform_driver);
-}
-
-static void __exit pata_platform_exit(void)
-{
-	platform_driver_unregister(&pata_platform_driver);
-}
-module_init(pata_platform_init);
-module_exit(pata_platform_exit);
+module_platform_driver(pata_platform_driver);
 
 module_param(pio_mask, int, 0);
 
diff --git a/drivers/ata/pata_pxa.c b/drivers/ata/pata_pxa.c
index b4ede40..0bb0fb7 100644
--- a/drivers/ata/pata_pxa.c
+++ b/drivers/ata/pata_pxa.c
@@ -390,18 +390,7 @@ static struct platform_driver pxa_ata_driver = {
 	},
 };
 
-static int __init pxa_ata_init(void)
-{
-	return platform_driver_register(&pxa_ata_driver);
-}
-
-static void __exit pxa_ata_exit(void)
-{
-	platform_driver_unregister(&pxa_ata_driver);
-}
-
-module_init(pxa_ata_init);
-module_exit(pxa_ata_exit);
+module_platform_driver(pxa_ata_driver);
 
 MODULE_AUTHOR("Marek Vasut <marek.vasut@gmail.com>");
 MODULE_DESCRIPTION("DMA-capable driver for PATA on PXA CPU");
diff --git a/drivers/ata/pata_rb532_cf.c b/drivers/ata/pata_rb532_cf.c
index 1b9d10d..9417101 100644
--- a/drivers/ata/pata_rb532_cf.c
+++ b/drivers/ata/pata_rb532_cf.c
@@ -188,9 +188,6 @@ static __devexit int rb532_pata_driver_remove(struct platform_device *pdev)
 	return 0;
 }
 
-/* work with hotplug and coldplug */
-MODULE_ALIAS("platform:" DRV_NAME);
-
 static struct platform_driver rb532_pata_platform_driver = {
 	.probe		= rb532_pata_driver_probe,
 	.remove		= __devexit_p(rb532_pata_driver_remove),
@@ -200,27 +197,13 @@ static struct platform_driver rb532_pata_platform_driver = {
 	},
 };
 
-/* ------------------------------------------------------------------------ */
-
 #define DRV_INFO DRV_DESC " version " DRV_VERSION
 
-static int __init rb532_pata_module_init(void)
-{
-	printk(KERN_INFO DRV_INFO "\n");
-
-	return platform_driver_register(&rb532_pata_platform_driver);
-}
-
-static void __exit rb532_pata_module_exit(void)
-{
-	platform_driver_unregister(&rb532_pata_platform_driver);
-}
+module_platform_driver(rb532_pata_platform_driver);
 
 MODULE_AUTHOR("Gabor Juhos <juhosg at openwrt.org>");
 MODULE_AUTHOR("Florian Fainelli <florian@openwrt.org>");
 MODULE_DESCRIPTION(DRV_DESC);
 MODULE_VERSION(DRV_VERSION);
 MODULE_LICENSE("GPL");
-
-module_init(rb532_pata_module_init);
-module_exit(rb532_pata_module_exit);
+MODULE_ALIAS("platform:" DRV_NAME);
diff --git a/drivers/ata/sata_dwc_460ex.c b/drivers/ata/sata_dwc_460ex.c
index 5c42374..69f7cde 100644
--- a/drivers/ata/sata_dwc_460ex.c
+++ b/drivers/ata/sata_dwc_460ex.c
@@ -1777,18 +1777,7 @@ static struct platform_driver sata_dwc_driver = {
 	.remove = sata_dwc_remove,
 };
 
-static int __init sata_dwc_init(void)
-{
-	return platform_driver_register(&sata_dwc_driver);
-}
-
-static void __exit sata_dwc_exit(void)
-{
-	platform_driver_unregister(&sata_dwc_driver);
-}
-
-module_init(sata_dwc_init);
-module_exit(sata_dwc_exit);
+module_platform_driver(sata_dwc_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Mark Miesfeld <mmiesfeld@amcc.com>");
diff --git a/drivers/ata/sata_fsl.c b/drivers/ata/sata_fsl.c
index 78ae7b6..5a2c95b 100644
--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -1452,21 +1452,9 @@ static struct platform_driver fsl_sata_driver = {
 #endif
 };
 
-static int __init sata_fsl_init(void)
-{
-	platform_driver_register(&fsl_sata_driver);
-	return 0;
-}
-
-static void __exit sata_fsl_exit(void)
-{
-	platform_driver_unregister(&fsl_sata_driver);
-}
+module_platform_driver(fsl_sata_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Ashish Kalra, Freescale Semiconductor");
 MODULE_DESCRIPTION("Freescale 3.0Gbps SATA controller low level driver");
 MODULE_VERSION("1.10");
-
-module_init(sata_fsl_init);
-module_exit(sata_fsl_exit);
-- 
1.7.5.4



