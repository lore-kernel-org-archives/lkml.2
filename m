Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933840Ab1JDX1C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 19:27:02 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54554 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933678Ab1JDX1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 19:27:00 -0400
Subject: [RFC] drivercore: Add helper macro for platform_driver boilerplate
To: greg@kroah.com, Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 04 Oct 2011 17:26:55 -0600
Message-ID: <20111004232403.10364.22050.stgit@ponder>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For simple modules that contain a single platform_driver without any
additional setup code then ends up being a block of duplicated
boilerplate.  This patch adds a new macro, module_platform_driver(),
which replaces the module_init()/module_exit() registrations with
template functions.

This patch also converts all the relevant spi drivers to use the new
macro.  There are a lot of drivers in the tree that are using this
pattern and could be converted.

It also fixes up some incorrect section annotations where I found
them.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

I think this is useful, and I like the diffstat that it produces.
What does everyone else think of this approach?  I can do versions for
i2c_drivers and spi_drivers too.

This is *not* tested very much.  I'm circulating mostly for review for
now.

 drivers/spi/spi-altera.c        |   13 +------------
 drivers/spi/spi-ath79.c         |   13 +------------
 drivers/spi/spi-atmel.c         |   13 +------------
 drivers/spi/spi-bfin-sport.c    |   13 +------------
 drivers/spi/spi-coldfire-qspi.c |   14 ++------------
 drivers/spi/spi-davinci.c       |   18 ++++--------------
 drivers/spi/spi-dw-mmio.c       |   14 ++------------
 drivers/spi/spi-ep93xx.c        |   20 +++++---------------
 drivers/spi/spi-fsl-espi.c      |   13 +------------
 drivers/spi/spi-gpio.c          |   21 +++++----------------
 drivers/spi/spi-imx.c           |   14 +-------------
 drivers/spi/spi-mpc512x-psc.c   |   13 +------------
 drivers/spi/spi-mpc52xx-psc.c   |   13 +------------
 drivers/spi/spi-mpc52xx.c       |   14 +-------------
 drivers/spi/spi-nuc900.c        |   14 +-------------
 drivers/spi/spi-oc-tiny.c       |   13 +------------
 drivers/spi/spi-ppc4xx.c        |   13 +------------
 drivers/spi/spi-s3c24xx.c       |   21 +++++----------------
 drivers/spi/spi-sh-msiof.c      |   13 +------------
 drivers/spi/spi-sh-sci.c        |   13 +------------
 drivers/spi/spi-sh.c            |   13 +------------
 drivers/spi/spi-stmp.c          |   13 +------------
 drivers/spi/spi-tegra.c         |   16 +++-------------
 drivers/spi/spi-ti-ssp.c        |   13 +------------
 drivers/spi/spi-xilinx.c        |   13 +------------
 drivers/tty/serial/of_serial.c  |   12 +-----------
 include/linux/platform_device.h |   15 +++++++++++++++
 27 files changed, 60 insertions(+), 328 deletions(-)

diff --git a/drivers/spi/spi-altera.c b/drivers/spi/spi-altera.c
index 4813a63..881c196 100644
--- a/drivers/spi/spi-altera.c
+++ b/drivers/spi/spi-altera.c
@@ -320,18 +320,7 @@ static struct platform_driver altera_spi_driver = {
 		.of_match_table = altera_spi_match,
 	},
 };
-
-static int __init altera_spi_init(void)
-{
-	return platform_driver_register(&altera_spi_driver);
-}
-module_init(altera_spi_init);
-
-static void __exit altera_spi_exit(void)
-{
-	platform_driver_unregister(&altera_spi_driver);
-}
-module_exit(altera_spi_exit);
+module_platform_driver(altera_spi_driver);
 
 MODULE_DESCRIPTION("Altera SPI driver");
 MODULE_AUTHOR("Thomas Chou <thomas@wytron.com.tw>");
diff --git a/drivers/spi/spi-ath79.c b/drivers/spi/spi-ath79.c
index 03019bf..024b48a 100644
--- a/drivers/spi/spi-ath79.c
+++ b/drivers/spi/spi-ath79.c
@@ -273,18 +273,7 @@ static struct platform_driver ath79_spi_driver = {
 		.owner	= THIS_MODULE,
 	},
 };
-
-static __init int ath79_spi_init(void)
-{
-	return platform_driver_register(&ath79_spi_driver);
-}
-module_init(ath79_spi_init);
-
-static __exit void ath79_spi_exit(void)
-{
-	platform_driver_unregister(&ath79_spi_driver);
-}
-module_exit(ath79_spi_exit);
+module_platform_driver(ath79_spi_driver);
 
 MODULE_DESCRIPTION("SPI controller driver for Atheros AR71XX/AR724X/AR913X");
 MODULE_AUTHOR("Gabor Juhos <juhosg@openwrt.org>");
diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
index 82dee9a..a356392 100644
--- a/drivers/spi/spi-atmel.c
+++ b/drivers/spi/spi-atmel.c
@@ -1074,18 +1074,7 @@ static struct platform_driver atmel_spi_driver = {
 	.resume		= atmel_spi_resume,
 	.remove		= __exit_p(atmel_spi_remove),
 };
-
-static int __init atmel_spi_init(void)
-{
-	return platform_driver_probe(&atmel_spi_driver, atmel_spi_probe);
-}
-module_init(atmel_spi_init);
-
-static void __exit atmel_spi_exit(void)
-{
-	platform_driver_unregister(&atmel_spi_driver);
-}
-module_exit(atmel_spi_exit);
+module_platform_driver(atmel_spi_driver);
 
 MODULE_DESCRIPTION("Atmel AT32/AT91 SPI Controller driver");
 MODULE_AUTHOR("Haavard Skinnemoen (Atmel)");
diff --git a/drivers/spi/spi-bfin-sport.c b/drivers/spi/spi-bfin-sport.c
index e557ff6..248a2cc 100644
--- a/drivers/spi/spi-bfin-sport.c
+++ b/drivers/spi/spi-bfin-sport.c
@@ -938,15 +938,4 @@ static struct platform_driver bfin_sport_spi_driver = {
 	.suspend = bfin_sport_spi_suspend,
 	.resume  = bfin_sport_spi_resume,
 };
-
-static int __init bfin_sport_spi_init(void)
-{
-	return platform_driver_register(&bfin_sport_spi_driver);
-}
-module_init(bfin_sport_spi_init);
-
-static void __exit bfin_sport_spi_exit(void)
-{
-	platform_driver_unregister(&bfin_sport_spi_driver);
-}
-module_exit(bfin_sport_spi_exit);
+module_platform_driver(bfin_sport_spi_driver);
diff --git a/drivers/spi/spi-coldfire-qspi.c b/drivers/spi/spi-coldfire-qspi.c
index ae2cd1c..7795d4d 100644
--- a/drivers/spi/spi-coldfire-qspi.c
+++ b/drivers/spi/spi-coldfire-qspi.c
@@ -621,20 +621,10 @@ static struct platform_driver mcfqspi_driver = {
 	.driver.name	= DRIVER_NAME,
 	.driver.owner	= THIS_MODULE,
 	.driver.pm	= MCFQSPI_DEV_PM_OPS,
+	.probe		= mcfqspi_probe,
 	.remove		= __devexit_p(mcfqspi_remove),
 };
-
-static int __init mcfqspi_init(void)
-{
-	return platform_driver_probe(&mcfqspi_driver, mcfqspi_probe);
-}
-module_init(mcfqspi_init);
-
-static void __exit mcfqspi_exit(void)
-{
-	platform_driver_unregister(&mcfqspi_driver);
-}
-module_exit(mcfqspi_exit);
+module_platform_driver(mcfqspi_driver);
 
 MODULE_AUTHOR("Steven King <sfking@fdwdc.com>");
 MODULE_DESCRIPTION("Coldfire QSPI Controller Driver");
diff --git a/drivers/spi/spi-davinci.c b/drivers/spi/spi-davinci.c
index 1f0ed80..05d5132 100644
--- a/drivers/spi/spi-davinci.c
+++ b/drivers/spi/spi-davinci.c
@@ -799,7 +799,7 @@ rx_dma_failed:
  * It will invoke spi_bitbang_start to create work queue so that client driver
  * can register transfer method to work queue.
  */
-static int davinci_spi_probe(struct platform_device *pdev)
+static int __devinit davinci_spi_probe(struct platform_device *pdev)
 {
 	struct spi_master *master;
 	struct davinci_spi *dspi;
@@ -984,7 +984,7 @@ err:
  * It will also call spi_bitbang_stop to destroy the work queue which was
  * created by spi_bitbang_start.
  */
-static int __exit davinci_spi_remove(struct platform_device *pdev)
+static int __devexit davinci_spi_remove(struct platform_device *pdev)
 {
 	struct davinci_spi *dspi;
 	struct spi_master *master;
@@ -1011,20 +1011,10 @@ static struct platform_driver davinci_spi_driver = {
 		.name = "spi_davinci",
 		.owner = THIS_MODULE,
 	},
+	.probe = davinci_spi_probe,
 	.remove = __exit_p(davinci_spi_remove),
 };
-
-static int __init davinci_spi_init(void)
-{
-	return platform_driver_probe(&davinci_spi_driver, davinci_spi_probe);
-}
-module_init(davinci_spi_init);
-
-static void __exit davinci_spi_exit(void)
-{
-	platform_driver_unregister(&davinci_spi_driver);
-}
-module_exit(davinci_spi_exit);
+module_platform_driver(davinci_spi_driver);
 
 MODULE_DESCRIPTION("TI DaVinci SPI Master Controller Driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/spi/spi-dw-mmio.c b/drivers/spi/spi-dw-mmio.c
index 34eb665..fac399c 100644
--- a/drivers/spi/spi-dw-mmio.c
+++ b/drivers/spi/spi-dw-mmio.c
@@ -127,24 +127,14 @@ static int __devexit dw_spi_mmio_remove(struct platform_device *pdev)
 }
 
 static struct platform_driver dw_spi_mmio_driver = {
+	.probe		= dw_spi_mmio_probe,
 	.remove		= __devexit_p(dw_spi_mmio_remove),
 	.driver		= {
 		.name	= DRIVER_NAME,
 		.owner	= THIS_MODULE,
 	},
 };
-
-static int __init dw_spi_mmio_init(void)
-{
-	return platform_driver_probe(&dw_spi_mmio_driver, dw_spi_mmio_probe);
-}
-module_init(dw_spi_mmio_init);
-
-static void __exit dw_spi_mmio_exit(void)
-{
-	platform_driver_unregister(&dw_spi_mmio_driver);
-}
-module_exit(dw_spi_mmio_exit);
+module_platform_driver(dw_spi_mmio_driver);
 
 MODULE_AUTHOR("Jean-Hugues Deschenes <jean-hugues.deschenes@octasic.com>");
 MODULE_DESCRIPTION("Memory-mapped I/O interface driver for DW SPI Core");
diff --git a/drivers/spi/spi-ep93xx.c b/drivers/spi/spi-ep93xx.c
index 1cf6454..77e204c 100644
--- a/drivers/spi/spi-ep93xx.c
+++ b/drivers/spi/spi-ep93xx.c
@@ -1025,7 +1025,7 @@ static void ep93xx_spi_release_dma(struct ep93xx_spi *espi)
 		free_page((unsigned long)espi->zeropage);
 }
 
-static int __init ep93xx_spi_probe(struct platform_device *pdev)
+static int __devinit ep93xx_spi_probe(struct platform_device *pdev)
 {
 	struct spi_master *master;
 	struct ep93xx_spi_info *info;
@@ -1150,7 +1150,7 @@ fail_release_master:
 	return error;
 }
 
-static int __exit ep93xx_spi_remove(struct platform_device *pdev)
+static int __devexit ep93xx_spi_remove(struct platform_device *pdev)
 {
 	struct spi_master *master = platform_get_drvdata(pdev);
 	struct ep93xx_spi *espi = spi_master_get_devdata(master);
@@ -1196,20 +1196,10 @@ static struct platform_driver ep93xx_spi_driver = {
 		.name	= "ep93xx-spi",
 		.owner	= THIS_MODULE,
 	},
-	.remove		= __exit_p(ep93xx_spi_remove),
+	.probe		= ep93xx_spi_probe,
+	.remove		= __devexit_p(ep93xx_spi_remove),
 };
-
-static int __init ep93xx_spi_init(void)
-{
-	return platform_driver_probe(&ep93xx_spi_driver, ep93xx_spi_probe);
-}
-module_init(ep93xx_spi_init);
-
-static void __exit ep93xx_spi_exit(void)
-{
-	platform_driver_unregister(&ep93xx_spi_driver);
-}
-module_exit(ep93xx_spi_exit);
+module_platform_driver(ep93xx_spi_driver);
 
 MODULE_DESCRIPTION("EP93xx SPI Controller driver");
 MODULE_AUTHOR("Mika Westerberg <mika.westerberg@iki.fi>");
diff --git a/drivers/spi/spi-fsl-espi.c b/drivers/spi/spi-fsl-espi.c
index 54e499d..d770f03 100644
--- a/drivers/spi/spi-fsl-espi.c
+++ b/drivers/spi/spi-fsl-espi.c
@@ -744,18 +744,7 @@ static struct platform_driver fsl_espi_driver = {
 	.probe		= of_fsl_espi_probe,
 	.remove		= __devexit_p(of_fsl_espi_remove),
 };
-
-static int __init fsl_espi_init(void)
-{
-	return platform_driver_register(&fsl_espi_driver);
-}
-module_init(fsl_espi_init);
-
-static void __exit fsl_espi_exit(void)
-{
-	platform_driver_unregister(&fsl_espi_driver);
-}
-module_exit(fsl_espi_exit);
+module_platform_driver(fsl_espi_driver);
 
 MODULE_AUTHOR("Mingkai Hu");
 MODULE_DESCRIPTION("Enhanced Freescale SPI Driver");
diff --git a/drivers/spi/spi-gpio.c b/drivers/spi/spi-gpio.c
index 0e88ab7..635ff08 100644
--- a/drivers/spi/spi-gpio.c
+++ b/drivers/spi/spi-gpio.c
@@ -311,7 +311,7 @@ done:
 	return value;
 }
 
-static int __init spi_gpio_probe(struct platform_device *pdev)
+static int __devinit spi_gpio_probe(struct platform_device *pdev)
 {
 	int				status;
 	struct spi_master		*master;
@@ -379,7 +379,7 @@ gpio_free:
 	return status;
 }
 
-static int __exit spi_gpio_remove(struct platform_device *pdev)
+static int __devexit spi_gpio_remove(struct platform_device *pdev)
 {
 	struct spi_gpio			*spi_gpio;
 	struct spi_gpio_platform_data	*pdata;
@@ -408,21 +408,10 @@ MODULE_ALIAS("platform:" DRIVER_NAME);
 static struct platform_driver spi_gpio_driver = {
 	.driver.name	= DRIVER_NAME,
 	.driver.owner	= THIS_MODULE,
-	.remove		= __exit_p(spi_gpio_remove),
+	.probe		= spi_gpio_probe,
+	.remove		= __devexit_p(spi_gpio_remove),
 };
-
-static int __init spi_gpio_init(void)
-{
-	return platform_driver_probe(&spi_gpio_driver, spi_gpio_probe);
-}
-module_init(spi_gpio_init);
-
-static void __exit spi_gpio_exit(void)
-{
-	platform_driver_unregister(&spi_gpio_driver);
-}
-module_exit(spi_gpio_exit);
-
+module_platform_driver(spi_gpio_driver);
 
 MODULE_DESCRIPTION("SPI master driver using generic bitbanged GPIO ");
 MODULE_AUTHOR("David Brownell");
diff --git a/drivers/spi/spi-imx.c b/drivers/spi/spi-imx.c
index 8ac6542..227dd1d 100644
--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -927,19 +927,7 @@ static struct platform_driver spi_imx_driver = {
 	.probe = spi_imx_probe,
 	.remove = __devexit_p(spi_imx_remove),
 };
-
-static int __init spi_imx_init(void)
-{
-	return platform_driver_register(&spi_imx_driver);
-}
-
-static void __exit spi_imx_exit(void)
-{
-	platform_driver_unregister(&spi_imx_driver);
-}
-
-module_init(spi_imx_init);
-module_exit(spi_imx_exit);
+module_platform_driver(spi_imx_driver);
 
 MODULE_DESCRIPTION("SPI Master Controller driver");
 MODULE_AUTHOR("Sascha Hauer, Pengutronix");
diff --git a/drivers/spi/spi-mpc512x-psc.c b/drivers/spi/spi-mpc512x-psc.c
index 6a5b423..4c63f77 100644
--- a/drivers/spi/spi-mpc512x-psc.c
+++ b/drivers/spi/spi-mpc512x-psc.c
@@ -559,18 +559,7 @@ static struct platform_driver mpc512x_psc_spi_of_driver = {
 		.of_match_table = mpc512x_psc_spi_of_match,
 	},
 };
-
-static int __init mpc512x_psc_spi_init(void)
-{
-	return platform_driver_register(&mpc512x_psc_spi_of_driver);
-}
-module_init(mpc512x_psc_spi_init);
-
-static void __exit mpc512x_psc_spi_exit(void)
-{
-	platform_driver_unregister(&mpc512x_psc_spi_of_driver);
-}
-module_exit(mpc512x_psc_spi_exit);
+module_platform_driver(mpc512x_psc_spi_of_driver);
 
 MODULE_AUTHOR("John Rigby");
 MODULE_DESCRIPTION("MPC512x PSC SPI Driver");
diff --git a/drivers/spi/spi-mpc52xx-psc.c b/drivers/spi/spi-mpc52xx-psc.c
index e30baf0..6604715 100644
--- a/drivers/spi/spi-mpc52xx-psc.c
+++ b/drivers/spi/spi-mpc52xx-psc.c
@@ -511,18 +511,7 @@ static struct platform_driver mpc52xx_psc_spi_of_driver = {
 		.of_match_table = mpc52xx_psc_spi_of_match,
 	},
 };
-
-static int __init mpc52xx_psc_spi_init(void)
-{
-	return platform_driver_register(&mpc52xx_psc_spi_of_driver);
-}
-module_init(mpc52xx_psc_spi_init);
-
-static void __exit mpc52xx_psc_spi_exit(void)
-{
-	platform_driver_unregister(&mpc52xx_psc_spi_of_driver);
-}
-module_exit(mpc52xx_psc_spi_exit);
+module_platform_driver(mpc52xx_psc_spi_of_driver);
 
 MODULE_AUTHOR("Dragos Carp");
 MODULE_DESCRIPTION("MPC52xx PSC SPI Driver");
diff --git a/drivers/spi/spi-mpc52xx.c b/drivers/spi/spi-mpc52xx.c
index 015a974..57633d9 100644
--- a/drivers/spi/spi-mpc52xx.c
+++ b/drivers/spi/spi-mpc52xx.c
@@ -564,16 +564,4 @@ static struct platform_driver mpc52xx_spi_of_driver = {
 	.probe = mpc52xx_spi_probe,
 	.remove = __devexit_p(mpc52xx_spi_remove),
 };
-
-static int __init mpc52xx_spi_init(void)
-{
-	return platform_driver_register(&mpc52xx_spi_of_driver);
-}
-module_init(mpc52xx_spi_init);
-
-static void __exit mpc52xx_spi_exit(void)
-{
-	platform_driver_unregister(&mpc52xx_spi_of_driver);
-}
-module_exit(mpc52xx_spi_exit);
-
+module_platform_driver(mpc52xx_spi_of_driver);
diff --git a/drivers/spi/spi-nuc900.c b/drivers/spi/spi-nuc900.c
index c0a6ce8..e763254 100644
--- a/drivers/spi/spi-nuc900.c
+++ b/drivers/spi/spi-nuc900.c
@@ -484,19 +484,7 @@ static struct platform_driver nuc900_spi_driver = {
 		.owner	= THIS_MODULE,
 	},
 };
-
-static int __init nuc900_spi_init(void)
-{
-	return platform_driver_register(&nuc900_spi_driver);
-}
-
-static void __exit nuc900_spi_exit(void)
-{
-	platform_driver_unregister(&nuc900_spi_driver);
-}
-
-module_init(nuc900_spi_init);
-module_exit(nuc900_spi_exit);
+module_platform_driver(nuc900_spi_driver);
 
 MODULE_AUTHOR("Wan ZongShun <mcuos.com@gmail.com>");
 MODULE_DESCRIPTION("nuc900 spi driver!");
diff --git a/drivers/spi/spi-oc-tiny.c b/drivers/spi/spi-oc-tiny.c
index f1bde66..897274e 100644
--- a/drivers/spi/spi-oc-tiny.c
+++ b/drivers/spi/spi-oc-tiny.c
@@ -406,18 +406,7 @@ static struct platform_driver tiny_spi_driver = {
 		.of_match_table = tiny_spi_match,
 	},
 };
-
-static int __init tiny_spi_init(void)
-{
-	return platform_driver_register(&tiny_spi_driver);
-}
-module_init(tiny_spi_init);
-
-static void __exit tiny_spi_exit(void)
-{
-	platform_driver_unregister(&tiny_spi_driver);
-}
-module_exit(tiny_spi_exit);
+module_platform_driver(tiny_spi_driver);
 
 MODULE_DESCRIPTION("OpenCores tiny SPI driver");
 MODULE_AUTHOR("Thomas Chou <thomas@wytron.com.tw>");
diff --git a/drivers/spi/spi-ppc4xx.c b/drivers/spi/spi-ppc4xx.c
index b267fd9..20bb73f 100644
--- a/drivers/spi/spi-ppc4xx.c
+++ b/drivers/spi/spi-ppc4xx.c
@@ -594,18 +594,7 @@ static struct platform_driver spi_ppc4xx_of_driver = {
 		.of_match_table = spi_ppc4xx_of_match,
 	},
 };
-
-static int __init spi_ppc4xx_init(void)
-{
-	return platform_driver_register(&spi_ppc4xx_of_driver);
-}
-module_init(spi_ppc4xx_init);
-
-static void __exit spi_ppc4xx_exit(void)
-{
-	platform_driver_unregister(&spi_ppc4xx_of_driver);
-}
-module_exit(spi_ppc4xx_exit);
+module_platform_driver(spi_ppc4xx_of_driver);
 
 MODULE_AUTHOR("Gary Jennejohn & Stefan Roese");
 MODULE_DESCRIPTION("Simple PPC4xx SPI Driver");
diff --git a/drivers/spi/spi-s3c24xx.c b/drivers/spi/spi-s3c24xx.c
index 1996ac5..b857a3e 100644
--- a/drivers/spi/spi-s3c24xx.c
+++ b/drivers/spi/spi-s3c24xx.c
@@ -505,7 +505,7 @@ static void s3c24xx_spi_initialsetup(struct s3c24xx_spi *hw)
 	}
 }
 
-static int __init s3c24xx_spi_probe(struct platform_device *pdev)
+static int __devinit s3c24xx_spi_probe(struct platform_device *pdev)
 {
 	struct s3c2410_spi_info *pdata;
 	struct s3c24xx_spi *hw;
@@ -661,7 +661,7 @@ static int __init s3c24xx_spi_probe(struct platform_device *pdev)
 	return err;
 }
 
-static int __exit s3c24xx_spi_remove(struct platform_device *dev)
+static int __devexit s3c24xx_spi_remove(struct platform_device *dev)
 {
 	struct s3c24xx_spi *hw = platform_get_drvdata(dev);
 
@@ -719,26 +719,15 @@ static const struct dev_pm_ops s3c24xx_spi_pmops = {
 
 MODULE_ALIAS("platform:s3c2410-spi");
 static struct platform_driver s3c24xx_spi_driver = {
-	.remove		= __exit_p(s3c24xx_spi_remove),
+	.probe		= s3c24xx_spi_probe,
+	.remove		= __devexit_p(s3c24xx_spi_remove),
 	.driver		= {
 		.name	= "s3c2410-spi",
 		.owner	= THIS_MODULE,
 		.pm	= S3C24XX_SPI_PMOPS,
 	},
 };
-
-static int __init s3c24xx_spi_init(void)
-{
-        return platform_driver_probe(&s3c24xx_spi_driver, s3c24xx_spi_probe);
-}
-
-static void __exit s3c24xx_spi_exit(void)
-{
-        platform_driver_unregister(&s3c24xx_spi_driver);
-}
-
-module_init(s3c24xx_spi_init);
-module_exit(s3c24xx_spi_exit);
+module_platform_driver(s3c24xx_spi_driver);
 
 MODULE_DESCRIPTION("S3C24XX SPI Driver");
 MODULE_AUTHOR("Ben Dooks, <ben@simtec.co.uk>");
diff --git a/drivers/spi/spi-sh-msiof.c b/drivers/spi/spi-sh-msiof.c
index e00d94b..fa7bf2b 100644
--- a/drivers/spi/spi-sh-msiof.c
+++ b/drivers/spi/spi-sh-msiof.c
@@ -730,18 +730,7 @@ static struct platform_driver sh_msiof_spi_drv = {
 		.pm		= &sh_msiof_spi_dev_pm_ops,
 	},
 };
-
-static int __init sh_msiof_spi_init(void)
-{
-	return platform_driver_register(&sh_msiof_spi_drv);
-}
-module_init(sh_msiof_spi_init);
-
-static void __exit sh_msiof_spi_exit(void)
-{
-	platform_driver_unregister(&sh_msiof_spi_drv);
-}
-module_exit(sh_msiof_spi_exit);
+module_platform_driver(sh_msiof_spi_drv);
 
 MODULE_DESCRIPTION("SuperH MSIOF SPI Master Interface Driver");
 MODULE_AUTHOR("Magnus Damm");
diff --git a/drivers/spi/spi-sh-sci.c b/drivers/spi/spi-sh-sci.c
index e7779c0..8844bc34 100644
--- a/drivers/spi/spi-sh-sci.c
+++ b/drivers/spi/spi-sh-sci.c
@@ -186,18 +186,7 @@ static struct platform_driver sh_sci_spi_drv = {
 		.owner	= THIS_MODULE,
 	},
 };
-
-static int __init sh_sci_spi_init(void)
-{
-	return platform_driver_register(&sh_sci_spi_drv);
-}
-module_init(sh_sci_spi_init);
-
-static void __exit sh_sci_spi_exit(void)
-{
-	platform_driver_unregister(&sh_sci_spi_drv);
-}
-module_exit(sh_sci_spi_exit);
+module_platform_driver(sh_sci_spi_drv);
 
 MODULE_DESCRIPTION("SH SCI SPI Driver");
 MODULE_AUTHOR("Magnus Damm <damm@opensource.se>");
diff --git a/drivers/spi/spi-sh.c b/drivers/spi/spi-sh.c
index 9eedd71..4082a45 100644
--- a/drivers/spi/spi-sh.c
+++ b/drivers/spi/spi-sh.c
@@ -524,18 +524,7 @@ static struct platform_driver spi_sh_driver = {
 		.owner = THIS_MODULE,
 	},
 };
-
-static int __init spi_sh_init(void)
-{
-	return platform_driver_register(&spi_sh_driver);
-}
-module_init(spi_sh_init);
-
-static void __exit spi_sh_exit(void)
-{
-	platform_driver_unregister(&spi_sh_driver);
-}
-module_exit(spi_sh_exit);
+module_platform_driver(spi_sh_driver);
 
 MODULE_DESCRIPTION("SH SPI bus driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/spi/spi-stmp.c b/drivers/spi/spi-stmp.c
index fadff76..58e3852 100644
--- a/drivers/spi/spi-stmp.c
+++ b/drivers/spi/spi-stmp.c
@@ -659,19 +659,8 @@ static struct platform_driver stmp_spi_driver = {
 	.suspend = stmp_spi_suspend,
 	.resume  = stmp_spi_resume,
 };
+module_platform_driver(stmp_spi_driver);
 
-static int __init stmp_spi_init(void)
-{
-	return platform_driver_register(&stmp_spi_driver);
-}
-
-static void __exit stmp_spi_exit(void)
-{
-	platform_driver_unregister(&stmp_spi_driver);
-}
-
-module_init(stmp_spi_init);
-module_exit(stmp_spi_exit);
 module_param(pio, int, S_IRUGO);
 module_param(clock, int, S_IRUGO);
 MODULE_AUTHOR("dmitry pervushin <dpervushin@embeddedalley.com>");
diff --git a/drivers/spi/spi-tegra.c b/drivers/spi/spi-tegra.c
index a5a6302..963729e 100644
--- a/drivers/spi/spi-tegra.c
+++ b/drivers/spi/spi-tegra.c
@@ -464,7 +464,7 @@ static int spi_tegra_transfer(struct spi_device *spi, struct spi_message *m)
 	return 0;
 }
 
-static int __init spi_tegra_probe(struct platform_device *pdev)
+static int __devinit spi_tegra_probe(struct platform_device *pdev)
 {
 	struct spi_master	*master;
 	struct spi_tegra_data	*tspi;
@@ -612,19 +612,9 @@ static struct platform_driver spi_tegra_driver = {
 		.owner =	THIS_MODULE,
 		.of_match_table = spi_tegra_of_match_table,
 	},
+	.probe =	spi_tegra_probe,
 	.remove =	__devexit_p(spi_tegra_remove),
 };
-
-static int __init spi_tegra_init(void)
-{
-	return platform_driver_probe(&spi_tegra_driver, spi_tegra_probe);
-}
-module_init(spi_tegra_init);
-
-static void __exit spi_tegra_exit(void)
-{
-	platform_driver_unregister(&spi_tegra_driver);
-}
-module_exit(spi_tegra_exit);
+module_platform_driver(spi_tegra_driver);
 
 MODULE_LICENSE("GPL");
diff --git a/drivers/spi/spi-ti-ssp.c b/drivers/spi/spi-ti-ssp.c
index ee22795..7963c60 100644
--- a/drivers/spi/spi-ti-ssp.c
+++ b/drivers/spi/spi-ti-ssp.c
@@ -383,18 +383,7 @@ static struct platform_driver ti_ssp_spi_driver = {
 		.owner	= THIS_MODULE,
 	},
 };
-
-static int __init ti_ssp_spi_init(void)
-{
-	return platform_driver_register(&ti_ssp_spi_driver);
-}
-module_init(ti_ssp_spi_init);
-
-static void __exit ti_ssp_spi_exit(void)
-{
-	platform_driver_unregister(&ti_ssp_spi_driver);
-}
-module_exit(ti_ssp_spi_exit);
+module_platform_driver(ti_ssp_spi_driver);
 
 MODULE_DESCRIPTION("SSP SPI Master");
 MODULE_AUTHOR("Cyril Chemparathy");
diff --git a/drivers/spi/spi-xilinx.c b/drivers/spi/spi-xilinx.c
index 4d2c75d..4c5a663 100644
--- a/drivers/spi/spi-xilinx.c
+++ b/drivers/spi/spi-xilinx.c
@@ -538,18 +538,7 @@ static struct platform_driver xilinx_spi_driver = {
 		.of_match_table = xilinx_spi_of_match,
 	},
 };
-
-static int __init xilinx_spi_pltfm_init(void)
-{
-	return platform_driver_register(&xilinx_spi_driver);
-}
-module_init(xilinx_spi_pltfm_init);
-
-static void __exit xilinx_spi_pltfm_exit(void)
-{
-	platform_driver_unregister(&xilinx_spi_driver);
-}
-module_exit(xilinx_spi_pltfm_exit);
+module_platform_driver(xilinx_spi_driver);
 
 MODULE_AUTHOR("MontaVista Software, Inc. <source@mvista.com>");
 MODULE_DESCRIPTION("Xilinx SPI driver");
diff --git a/drivers/tty/serial/of_serial.c b/drivers/tty/serial/of_serial.c
index e58cece..e8c9cee 100644
--- a/drivers/tty/serial/of_serial.c
+++ b/drivers/tty/serial/of_serial.c
@@ -200,17 +200,7 @@ static struct platform_driver of_platform_serial_driver = {
 	.remove = of_platform_serial_remove,
 };
 
-static int __init of_platform_serial_init(void)
-{
-	return platform_driver_register(&of_platform_serial_driver);
-}
-module_init(of_platform_serial_init);
-
-static void __exit of_platform_serial_exit(void)
-{
-	return platform_driver_unregister(&of_platform_serial_driver);
-};
-module_exit(of_platform_serial_exit);
+module_platform_driver(of_platform_serial_driver);
 
 MODULE_AUTHOR("Arnd Bergmann <arnd@arndb.de>");
 MODULE_LICENSE("GPL");
diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index 27bb05a..991a678 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -146,6 +146,21 @@ static inline void platform_set_drvdata(struct platform_device *pdev, void *data
 	dev_set_drvdata(&pdev->dev, data);
 }
 
+/* Helper macro for drivers that don't do anything special in module
+ * init/exit.  This eliminates a lot of boilerplate */
+#define module_platform_driver(__platform_driver) \
+int __platform_driver##_init(void) \
+{ \
+	return platform_driver_register(&(__platform_driver)); \
+} \
+module_init(__platform_driver##_init); \
+void __platform_driver##_exit(void) \
+{ \
+	platform_driver_unregister(&(__platform_driver)); \
+} \
+module_exit(__platform_driver##_exit);
+
+
 extern struct platform_device *platform_create_bundle(struct platform_driver *driver,
 					int (*probe)(struct platform_device *),
 					struct resource *res, unsigned int n_res,

