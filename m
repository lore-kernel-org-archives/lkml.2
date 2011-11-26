Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405Ab1KZEz5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 23:55:57 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:57110 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab1KZEzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 23:55:55 -0500
Message-ID: <1322283343.14278.2.camel@phoenix>
Subject: [PATCH] mmc: convert drivers/mmc/host/* to use
 module_platform_driver()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Micha <mirq-linux@rere.qmqm.pl>, David Brown <davidb@codeaurora.org>,
        Ben Dooks <ben-linux@fluff.org>, Viresh Kumar <viresh.kumar@st.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Ian Molton <ian@mnementh.co.uk>, Sascha Hauer <s.hauer@pengutronix.de>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>, Chris Ball <cjb@laptop.org>,
        linux-mmc@vger.kernel.org
Date: Sat, 26 Nov 2011 12:55:43 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the drivers in drivers/mmc/host/* to use the
module_platform_driver() macro which makes the code smaller and a bit
simpler.

Cc: "Michał Mirosław" <mirq-linux@rere.qmqm.pl>
Cc: David Brown <davidb@codeaurora.org>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Viresh Kumar <viresh.kumar@st.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Ian Molton <ian@mnementh.co.uk>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mmc/host/bfin_sdh.c        |   12 +-----------
 drivers/mmc/host/cb710-mmc.c       |   13 +------------
 drivers/mmc/host/jz4740_mmc.c      |   12 +-----------
 drivers/mmc/host/msm_sdcc.c        |   13 +------------
 drivers/mmc/host/mxcmmc.c          |   13 +------------
 drivers/mmc/host/mxs-mmc.c         |   13 +------------
 drivers/mmc/host/pxamci.c          |   13 +------------
 drivers/mmc/host/s3cmci.c          |   13 +------------
 drivers/mmc/host/sdhci-cns3xxx.c   |   12 +-----------
 drivers/mmc/host/sdhci-dove.c      |   12 +-----------
 drivers/mmc/host/sdhci-esdhc-imx.c |   12 +-----------
 drivers/mmc/host/sdhci-of-esdhc.c  |   12 +-----------
 drivers/mmc/host/sdhci-of-hlwd.c   |   12 +-----------
 drivers/mmc/host/sdhci-pxav2.c     |   12 +-----------
 drivers/mmc/host/sdhci-pxav3.c     |   12 +-----------
 drivers/mmc/host/sdhci-s3c.c       |   13 +------------
 drivers/mmc/host/sdhci-spear.c     |   12 +-----------
 drivers/mmc/host/sdhci-tegra.c     |   12 +-----------
 drivers/mmc/host/sh_mmcif.c        |   14 +-------------
 drivers/mmc/host/sh_mobile_sdhi.c  |   13 +------------
 drivers/mmc/host/tmio_mmc.c        |   14 +-------------
 21 files changed, 21 insertions(+), 243 deletions(-)

diff --git a/drivers/mmc/host/bfin_sdh.c b/drivers/mmc/host/bfin_sdh.c
index 0371bf5..0366617 100644
--- a/drivers/mmc/host/bfin_sdh.c
+++ b/drivers/mmc/host/bfin_sdh.c
@@ -627,17 +627,7 @@ static struct platform_driver sdh_driver = {
 	},
 };
 
-static int __init sdh_init(void)
-{
-	return platform_driver_register(&sdh_driver);
-}
-module_init(sdh_init);
-
-static void __exit sdh_exit(void)
-{
-	platform_driver_unregister(&sdh_driver);
-}
-module_exit(sdh_exit);
+module_platform_driver(sdh_driver);
 
 MODULE_DESCRIPTION("Blackfin Secure Digital Host Driver");
 MODULE_AUTHOR("Cliff Cai, Roy Huang");
diff --git a/drivers/mmc/host/cb710-mmc.c b/drivers/mmc/host/cb710-mmc.c
index ce2a47b..83693fd 100644
--- a/drivers/mmc/host/cb710-mmc.c
+++ b/drivers/mmc/host/cb710-mmc.c
@@ -780,18 +780,7 @@ static struct platform_driver cb710_mmc_driver = {
 #endif
 };
 
-static int __init cb710_mmc_init_module(void)
-{
-	return platform_driver_register(&cb710_mmc_driver);
-}
-
-static void __exit cb710_mmc_cleanup_module(void)
-{
-	platform_driver_unregister(&cb710_mmc_driver);
-}
-
-module_init(cb710_mmc_init_module);
-module_exit(cb710_mmc_cleanup_module);
+module_platform_driver(cb710_mmc_driver);
 
 MODULE_AUTHOR("Michał Mirosław <mirq-linux@rere.qmqm.pl>");
 MODULE_DESCRIPTION("ENE CB710 memory card reader driver - MMC/SD part");
diff --git a/drivers/mmc/host/jz4740_mmc.c b/drivers/mmc/host/jz4740_mmc.c
index 74218ad..c8852a8 100644
--- a/drivers/mmc/host/jz4740_mmc.c
+++ b/drivers/mmc/host/jz4740_mmc.c
@@ -1012,17 +1012,7 @@ static struct platform_driver jz4740_mmc_driver = {
 	},
 };
 
-static int __init jz4740_mmc_init(void)
-{
-	return platform_driver_register(&jz4740_mmc_driver);
-}
-module_init(jz4740_mmc_init);
-
-static void __exit jz4740_mmc_exit(void)
-{
-	platform_driver_unregister(&jz4740_mmc_driver);
-}
-module_exit(jz4740_mmc_exit);
+module_platform_driver(jz4740_mmc_driver);
 
 MODULE_DESCRIPTION("JZ4740 SD/MMC controller driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/mmc/host/msm_sdcc.c b/drivers/mmc/host/msm_sdcc.c
index 80d8eb1..4755966 100644
--- a/drivers/mmc/host/msm_sdcc.c
+++ b/drivers/mmc/host/msm_sdcc.c
@@ -1480,18 +1480,7 @@ static struct platform_driver msmsdcc_driver = {
 	},
 };
 
-static int __init msmsdcc_init(void)
-{
-	return platform_driver_register(&msmsdcc_driver);
-}
-
-static void __exit msmsdcc_exit(void)
-{
-	platform_driver_unregister(&msmsdcc_driver);
-}
-
-module_init(msmsdcc_init);
-module_exit(msmsdcc_exit);
+module_platform_driver(msmsdcc_driver);
 
 MODULE_DESCRIPTION("Qualcomm MSM 7X00A Multimedia Card Interface driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/mmc/host/mxcmmc.c b/drivers/mmc/host/mxcmmc.c
index f07bd87..4184b79 100644
--- a/drivers/mmc/host/mxcmmc.c
+++ b/drivers/mmc/host/mxcmmc.c
@@ -1051,18 +1051,7 @@ static struct platform_driver mxcmci_driver = {
 	}
 };
 
-static int __init mxcmci_init(void)
-{
-	return platform_driver_register(&mxcmci_driver);
-}
-
-static void __exit mxcmci_exit(void)
-{
-	platform_driver_unregister(&mxcmci_driver);
-}
-
-module_init(mxcmci_init);
-module_exit(mxcmci_exit);
+module_platform_driver(mxcmci_driver);
 
 MODULE_DESCRIPTION("i.MX Multimedia Card Interface Driver");
 MODULE_AUTHOR("Sascha Hauer, Pengutronix");
diff --git a/drivers/mmc/host/mxs-mmc.c b/drivers/mmc/host/mxs-mmc.c
index 0a878b1..571c9ff 100644
--- a/drivers/mmc/host/mxs-mmc.c
+++ b/drivers/mmc/host/mxs-mmc.c
@@ -860,18 +860,7 @@ static struct platform_driver mxs_mmc_driver = {
 	},
 };
 
-static int __init mxs_mmc_init(void)
-{
-	return platform_driver_register(&mxs_mmc_driver);
-}
-
-static void __exit mxs_mmc_exit(void)
-{
-	platform_driver_unregister(&mxs_mmc_driver);
-}
-
-module_init(mxs_mmc_init);
-module_exit(mxs_mmc_exit);
+module_platform_driver(mxs_mmc_driver);
 
 MODULE_DESCRIPTION("FREESCALE MXS MMC peripheral");
 MODULE_AUTHOR("Freescale Semiconductor");
diff --git a/drivers/mmc/host/pxamci.c b/drivers/mmc/host/pxamci.c
index fc4356e..cb2dc0e 100644
--- a/drivers/mmc/host/pxamci.c
+++ b/drivers/mmc/host/pxamci.c
@@ -872,18 +872,7 @@ static struct platform_driver pxamci_driver = {
 	},
 };
 
-static int __init pxamci_init(void)
-{
-	return platform_driver_register(&pxamci_driver);
-}
-
-static void __exit pxamci_exit(void)
-{
-	platform_driver_unregister(&pxamci_driver);
-}
-
-module_init(pxamci_init);
-module_exit(pxamci_exit);
+module_platform_driver(pxamci_driver);
 
 MODULE_DESCRIPTION("PXA Multimedia Card Interface Driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/mmc/host/s3cmci.c b/drivers/mmc/host/s3cmci.c
index 720f993..1bcfd6d 100644
--- a/drivers/mmc/host/s3cmci.c
+++ b/drivers/mmc/host/s3cmci.c
@@ -1914,18 +1914,7 @@ static struct platform_driver s3cmci_driver = {
 	.shutdown	= s3cmci_shutdown,
 };
 
-static int __init s3cmci_init(void)
-{
-	return platform_driver_register(&s3cmci_driver);
-}
-
-static void __exit s3cmci_exit(void)
-{
-	platform_driver_unregister(&s3cmci_driver);
-}
-
-module_init(s3cmci_init);
-module_exit(s3cmci_exit);
+module_platform_driver(s3cmci_driver);
 
 MODULE_DESCRIPTION("Samsung S3C MMC/SD Card Interface driver");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/mmc/host/sdhci-cns3xxx.c b/drivers/mmc/host/sdhci-cns3xxx.c
index b4257e7..28a8708 100644
--- a/drivers/mmc/host/sdhci-cns3xxx.c
+++ b/drivers/mmc/host/sdhci-cns3xxx.c
@@ -115,17 +115,7 @@ static struct platform_driver sdhci_cns3xxx_driver = {
 	.remove		= __devexit_p(sdhci_cns3xxx_remove),
 };
 
-static int __init sdhci_cns3xxx_init(void)
-{
-	return platform_driver_register(&sdhci_cns3xxx_driver);
-}
-module_init(sdhci_cns3xxx_init);
-
-static void __exit sdhci_cns3xxx_exit(void)
-{
-	platform_driver_unregister(&sdhci_cns3xxx_driver);
-}
-module_exit(sdhci_cns3xxx_exit);
+module_platform_driver(sdhci_cns3xxx_driver);
 
 MODULE_DESCRIPTION("SDHCI driver for CNS3xxx");
 MODULE_AUTHOR("Scott Shu, "
diff --git a/drivers/mmc/host/sdhci-dove.c b/drivers/mmc/host/sdhci-dove.c
index a81312c..46fd1fd 100644
--- a/drivers/mmc/host/sdhci-dove.c
+++ b/drivers/mmc/host/sdhci-dove.c
@@ -88,17 +88,7 @@ static struct platform_driver sdhci_dove_driver = {
 	.remove		= __devexit_p(sdhci_dove_remove),
 };
 
-static int __init sdhci_dove_init(void)
-{
-	return platform_driver_register(&sdhci_dove_driver);
-}
-module_init(sdhci_dove_init);
-
-static void __exit sdhci_dove_exit(void)
-{
-	platform_driver_unregister(&sdhci_dove_driver);
-}
-module_exit(sdhci_dove_exit);
+module_platform_driver(sdhci_dove_driver);
 
 MODULE_DESCRIPTION("SDHCI driver for Dove");
 MODULE_AUTHOR("Saeed Bishara <saeed@marvell.com>, "
diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
index 38ebc4e..d601e41 100644
--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -606,17 +606,7 @@ static struct platform_driver sdhci_esdhc_imx_driver = {
 	.remove		= __devexit_p(sdhci_esdhc_imx_remove),
 };
 
-static int __init sdhci_esdhc_imx_init(void)
-{
-	return platform_driver_register(&sdhci_esdhc_imx_driver);
-}
-module_init(sdhci_esdhc_imx_init);
-
-static void __exit sdhci_esdhc_imx_exit(void)
-{
-	platform_driver_unregister(&sdhci_esdhc_imx_driver);
-}
-module_exit(sdhci_esdhc_imx_exit);
+module_platform_driver(sdhci_esdhc_imx_driver);
 
 MODULE_DESCRIPTION("SDHCI driver for Freescale i.MX eSDHC");
 MODULE_AUTHOR("Wolfram Sang <w.sang@pengutronix.de>");
diff --git a/drivers/mmc/host/sdhci-of-esdhc.c b/drivers/mmc/host/sdhci-of-esdhc.c
index 01e5f62..ff4adc0 100644
--- a/drivers/mmc/host/sdhci-of-esdhc.c
+++ b/drivers/mmc/host/sdhci-of-esdhc.c
@@ -131,17 +131,7 @@ static struct platform_driver sdhci_esdhc_driver = {
 	.remove = __devexit_p(sdhci_esdhc_remove),
 };
 
-static int __init sdhci_esdhc_init(void)
-{
-	return platform_driver_register(&sdhci_esdhc_driver);
-}
-module_init(sdhci_esdhc_init);
-
-static void __exit sdhci_esdhc_exit(void)
-{
-	platform_driver_unregister(&sdhci_esdhc_driver);
-}
-module_exit(sdhci_esdhc_exit);
+module_platform_driver(sdhci_esdhc_driver);
 
 MODULE_DESCRIPTION("SDHCI OF driver for Freescale MPC eSDHC");
 MODULE_AUTHOR("Xiaobo Xie <X.Xie@freescale.com>, "
diff --git a/drivers/mmc/host/sdhci-of-hlwd.c b/drivers/mmc/host/sdhci-of-hlwd.c
index 3619adc..0ce088ae 100644
--- a/drivers/mmc/host/sdhci-of-hlwd.c
+++ b/drivers/mmc/host/sdhci-of-hlwd.c
@@ -93,17 +93,7 @@ static struct platform_driver sdhci_hlwd_driver = {
 	.remove = __devexit_p(sdhci_hlwd_remove),
 };
 
-static int __init sdhci_hlwd_init(void)
-{
-	return platform_driver_register(&sdhci_hlwd_driver);
-}
-module_init(sdhci_hlwd_init);
-
-static void __exit sdhci_hlwd_exit(void)
-{
-	platform_driver_unregister(&sdhci_hlwd_driver);
-}
-module_exit(sdhci_hlwd_exit);
+module_platform_driver(sdhci_hlwd_driver);
 
 MODULE_DESCRIPTION("Nintendo Wii SDHCI OF driver");
 MODULE_AUTHOR("The GameCube Linux Team, Albert Herranz");
diff --git a/drivers/mmc/host/sdhci-pxav2.c b/drivers/mmc/host/sdhci-pxav2.c
index 7a039c3..dbb75bf 100644
--- a/drivers/mmc/host/sdhci-pxav2.c
+++ b/drivers/mmc/host/sdhci-pxav2.c
@@ -223,18 +223,8 @@ static struct platform_driver sdhci_pxav2_driver = {
 	.probe		= sdhci_pxav2_probe,
 	.remove		= __devexit_p(sdhci_pxav2_remove),
 };
-static int __init sdhci_pxav2_init(void)
-{
-	return platform_driver_register(&sdhci_pxav2_driver);
-}
-
-static void __exit sdhci_pxav2_exit(void)
-{
-	platform_driver_unregister(&sdhci_pxav2_driver);
-}
 
-module_init(sdhci_pxav2_init);
-module_exit(sdhci_pxav2_exit);
+module_platform_driver(sdhci_pxav2_driver);
 
 MODULE_DESCRIPTION("SDHCI driver for pxav2");
 MODULE_AUTHOR("Marvell International Ltd.");
diff --git a/drivers/mmc/host/sdhci-pxav3.c b/drivers/mmc/host/sdhci-pxav3.c
index 15673a7..f296956 100644
--- a/drivers/mmc/host/sdhci-pxav3.c
+++ b/drivers/mmc/host/sdhci-pxav3.c
@@ -269,18 +269,8 @@ static struct platform_driver sdhci_pxav3_driver = {
 	.probe		= sdhci_pxav3_probe,
 	.remove		= __devexit_p(sdhci_pxav3_remove),
 };
-static int __init sdhci_pxav3_init(void)
-{
-	return platform_driver_register(&sdhci_pxav3_driver);
-}
-
-static void __exit sdhci_pxav3_exit(void)
-{
-	platform_driver_unregister(&sdhci_pxav3_driver);
-}
 
-module_init(sdhci_pxav3_init);
-module_exit(sdhci_pxav3_exit);
+module_platform_driver(sdhci_pxav3_driver);
 
 MODULE_DESCRIPTION("SDHCI driver for pxav3");
 MODULE_AUTHOR("Marvell International Ltd.");
diff --git a/drivers/mmc/host/sdhci-s3c.c b/drivers/mmc/host/sdhci-s3c.c
index 4cb272c..c28ab53 100644
--- a/drivers/mmc/host/sdhci-s3c.c
+++ b/drivers/mmc/host/sdhci-s3c.c
@@ -656,18 +656,7 @@ static struct platform_driver sdhci_s3c_driver = {
 	},
 };
 
-static int __init sdhci_s3c_init(void)
-{
-	return platform_driver_register(&sdhci_s3c_driver);
-}
-
-static void __exit sdhci_s3c_exit(void)
-{
-	platform_driver_unregister(&sdhci_s3c_driver);
-}
-
-module_init(sdhci_s3c_init);
-module_exit(sdhci_s3c_exit);
+module_platform_driver(sdhci_s3c_driver);
 
 MODULE_DESCRIPTION("Samsung SDHCI (HSMMC) glue");
 MODULE_AUTHOR("Ben Dooks, <ben@simtec.co.uk>");
diff --git a/drivers/mmc/host/sdhci-spear.c b/drivers/mmc/host/sdhci-spear.c
index dee70b6..883548e 100644
--- a/drivers/mmc/host/sdhci-spear.c
+++ b/drivers/mmc/host/sdhci-spear.c
@@ -320,17 +320,7 @@ static struct platform_driver sdhci_driver = {
 	.remove		= __devexit_p(sdhci_remove),
 };
 
-static int __init sdhci_init(void)
-{
-	return platform_driver_register(&sdhci_driver);
-}
-module_init(sdhci_init);
-
-static void __exit sdhci_exit(void)
-{
-	platform_driver_unregister(&sdhci_driver);
-}
-module_exit(sdhci_exit);
+module_platform_driver(sdhci_driver);
 
 MODULE_DESCRIPTION("SPEAr Secure Digital Host Controller Interface driver");
 MODULE_AUTHOR("Viresh Kumar <viresh.kumar@st.com>");
diff --git a/drivers/mmc/host/sdhci-tegra.c b/drivers/mmc/host/sdhci-tegra.c
index e2e18d3..78a36eb 100644
--- a/drivers/mmc/host/sdhci-tegra.c
+++ b/drivers/mmc/host/sdhci-tegra.c
@@ -324,17 +324,7 @@ static struct platform_driver sdhci_tegra_driver = {
 	.remove		= __devexit_p(sdhci_tegra_remove),
 };
 
-static int __init sdhci_tegra_init(void)
-{
-	return platform_driver_register(&sdhci_tegra_driver);
-}
-module_init(sdhci_tegra_init);
-
-static void __exit sdhci_tegra_exit(void)
-{
-	platform_driver_unregister(&sdhci_tegra_driver);
-}
-module_exit(sdhci_tegra_exit);
+module_platform_driver(sdhci_tegra_driver);
 
 MODULE_DESCRIPTION("SDHCI driver for Tegra");
 MODULE_AUTHOR(" Google, Inc.");
diff --git a/drivers/mmc/host/sh_mmcif.c b/drivers/mmc/host/sh_mmcif.c
index 1c0c10b..591345d3 100644
--- a/drivers/mmc/host/sh_mmcif.c
+++ b/drivers/mmc/host/sh_mmcif.c
@@ -1206,19 +1206,7 @@ static struct platform_driver sh_mmcif_driver = {
 	},
 };
 
-static int __init sh_mmcif_init(void)
-{
-	return platform_driver_register(&sh_mmcif_driver);
-}
-
-static void __exit sh_mmcif_exit(void)
-{
-	platform_driver_unregister(&sh_mmcif_driver);
-}
-
-module_init(sh_mmcif_init);
-module_exit(sh_mmcif_exit);
-
+module_platform_driver(sh_mmcif_driver);
 
 MODULE_DESCRIPTION("SuperH on-chip MMC/eMMC interface driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/mmc/host/sh_mobile_sdhi.c b/drivers/mmc/host/sh_mobile_sdhi.c
index 41ae646..58da3c4 100644
--- a/drivers/mmc/host/sh_mobile_sdhi.c
+++ b/drivers/mmc/host/sh_mobile_sdhi.c
@@ -282,18 +282,7 @@ static struct platform_driver sh_mobile_sdhi_driver = {
 	.remove		= __devexit_p(sh_mobile_sdhi_remove),
 };
 
-static int __init sh_mobile_sdhi_init(void)
-{
-	return platform_driver_register(&sh_mobile_sdhi_driver);
-}
-
-static void __exit sh_mobile_sdhi_exit(void)
-{
-	platform_driver_unregister(&sh_mobile_sdhi_driver);
-}
-
-module_init(sh_mobile_sdhi_init);
-module_exit(sh_mobile_sdhi_exit);
+module_platform_driver(sh_mobile_sdhi_driver);
 
 MODULE_DESCRIPTION("SuperH Mobile SDHI driver");
 MODULE_AUTHOR("Magnus Damm");
diff --git a/drivers/mmc/host/tmio_mmc.c b/drivers/mmc/host/tmio_mmc.c
index a4ea102..113ce6c 100644
--- a/drivers/mmc/host/tmio_mmc.c
+++ b/drivers/mmc/host/tmio_mmc.c
@@ -138,19 +138,7 @@ static struct platform_driver tmio_mmc_driver = {
 	.resume = tmio_mmc_resume,
 };
 
-
-static int __init tmio_mmc_init(void)
-{
-	return platform_driver_register(&tmio_mmc_driver);
-}
-
-static void __exit tmio_mmc_exit(void)
-{
-	platform_driver_unregister(&tmio_mmc_driver);
-}
-
-module_init(tmio_mmc_init);
-module_exit(tmio_mmc_exit);
+module_platform_driver(tmio_mmc_driver);
 
 MODULE_DESCRIPTION("Toshiba TMIO SD/MMC driver");
 MODULE_AUTHOR("Ian Molton <spyro@f2s.com>");
-- 
1.7.5.4



