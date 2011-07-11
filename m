Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894Ab1GKPDj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 11:03:39 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:52785 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757830Ab1GKPD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 11:03:29 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org,
        thierry.nolf.barco@gmail.com, Huang Shijie <b32955@freescale.com>,
        linux-mtd@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org,
        =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@karo-electronics.de>
Subject: [PATCH] ARM: mxc: use new helpers to define common struct resource entries
Date: Mon, 11 Jul 2011 17:03:15 +0200
Message-Id: <1310396595-18070-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <E1QgHeh-0004k8-2m@octopus.hi.pengutronix.de>
References: <E1QgHeh-0004k8-2m@octopus.hi.pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 arch/arm/plat-mxc/devices/platform-fec.c           |   11 +----
 arch/arm/plat-mxc/devices/platform-flexcan.c       |   11 +----
 arch/arm/plat-mxc/devices/platform-fsl-usb2-udc.c  |   11 +----
 arch/arm/plat-mxc/devices/platform-gpio-mxc.c      |   16 +------
 arch/arm/plat-mxc/devices/platform-imx-dma.c       |   11 +----
 arch/arm/plat-mxc/devices/platform-imx-fb.c        |   11 +----
 arch/arm/plat-mxc/devices/platform-imx-i2c.c       |   11 +----
 arch/arm/plat-mxc/devices/platform-imx-keypad.c    |   11 +----
 arch/arm/plat-mxc/devices/platform-imx-ssi.c       |   19 ++-------
 arch/arm/plat-mxc/devices/platform-imx-uart.c      |   35 ++++-------------
 arch/arm/plat-mxc/devices/platform-imx2-wdt.c      |    6 +--
 arch/arm/plat-mxc/devices/platform-imx21-hcd.c     |   11 +----
 arch/arm/plat-mxc/devices/platform-imx_udc.c       |   41 ++++----------------
 arch/arm/plat-mxc/devices/platform-imxdi_rtc.c     |   11 +----
 arch/arm/plat-mxc/devices/platform-ipu-core.c      |   33 +++-------------
 arch/arm/plat-mxc/devices/platform-mx1-camera.c    |   11 +----
 arch/arm/plat-mxc/devices/platform-mx2-camera.c    |   21 ++--------
 arch/arm/plat-mxc/devices/platform-mxc-ehci.c      |   11 +----
 arch/arm/plat-mxc/devices/platform-mxc-mmc.c       |   16 +------
 arch/arm/plat-mxc/devices/platform-mxc_nand.c      |   16 +------
 arch/arm/plat-mxc/devices/platform-mxc_pwm.c       |   11 +----
 arch/arm/plat-mxc/devices/platform-mxc_rnga.c      |    6 +--
 arch/arm/plat-mxc/devices/platform-mxc_rtc.c       |   11 +----
 arch/arm/plat-mxc/devices/platform-mxc_w1.c        |    6 +--
 .../plat-mxc/devices/platform-sdhci-esdhc-imx.c    |   11 +----
 arch/arm/plat-mxc/devices/platform-spi_imx.c       |   11 +----
 26 files changed, 72 insertions(+), 308 deletions(-)

diff --git a/arch/arm/plat-mxc/devices/platform-fec.c b/arch/arm/plat-mxc/devices/platform-fec.c
index 4fc6ffc..b64f309 100644
--- a/arch/arm/plat-mxc/devices/platform-fec.c
+++ b/arch/arm/plat-mxc/devices/platform-fec.c
@@ -52,15 +52,8 @@ struct platform_device *__init imx_add_fec(
 		const struct fec_platform_data *pdata)
 {
 	struct resource res[] = {
-		{
-			.start = data->iobase,
-			.end = data->iobase + SZ_4K - 1,
-			.flags = IORESOURCE_MEM,
-		}, {
-			.start = data->irq,
-			.end = data->irq,
-			.flags = IORESOURCE_IRQ,
-		},
+		DEFINE_RES_MEM(data->iobase, SZ_4K),
+		DEFINE_RES_IRQ(data->irq),
 	};
 
 	return imx_add_platform_device_dmamask("fec", 0,
diff --git a/arch/arm/plat-mxc/devices/platform-flexcan.c b/arch/arm/plat-mxc/devices/platform-flexcan.c
index 4e8497a..fcb5873 100644
--- a/arch/arm/plat-mxc/devices/platform-flexcan.c
+++ b/arch/arm/plat-mxc/devices/platform-flexcan.c
@@ -42,15 +42,8 @@ struct platform_device *__init imx_add_flexcan(
 		const struct flexcan_platform_data *pdata)
 {
 	struct resource res[] = {
-		{
-			.start = data->iobase,
-			.end = data->iobase + data->iosize - 1,
-			.flags = IORESOURCE_MEM,
-		}, {
-			.start = data->irq,
-			.end = data->irq,
-			.flags = IORESOURCE_IRQ,
-		},
+		DEFINE_RES_MEM(data->iobase, data->iosize),
+		DEFINE_RES_IRQ(data->irq),
 	};
 
 	return imx_add_platform_device("flexcan", data->id,
diff --git a/arch/arm/plat-mxc/devices/platform-fsl-usb2-udc.c b/arch/arm/plat-mxc/devices/platform-fsl-usb2-udc.c
index 23ce08e..749c28c 100644
--- a/arch/arm/plat-mxc/devices/platform-fsl-usb2-udc.c
+++ b/arch/arm/plat-mxc/devices/platform-fsl-usb2-udc.c
@@ -41,15 +41,8 @@ struct platform_device *__init imx_add_fsl_usb2_udc(
 		const struct fsl_usb2_platform_data *pdata)
 {
 	struct resource res[] = {
-		{
-			.start = data->iobase,
-			.end = data->iobase + SZ_512 - 1,
-			.flags = IORESOURCE_MEM,
-		}, {
-			.start = data->irq,
-			.end = data->irq,
-			.flags = IORESOURCE_IRQ,
-		},
+		DEFINE_RES_MEM(data->iobase, SZ_512),
+		DEFINE_RES_IRQ(data->irq),
 	};
 	return imx_add_platform_device_dmamask("fsl-usb2-udc", -1,
 			res, ARRAY_SIZE(res),
diff --git a/arch/arm/plat-mxc/devices/platform-gpio-mxc.c b/arch/arm/plat-mxc/devices/platform-gpio-mxc.c
index cf1b7fd..3314557 100644
--- a/arch/arm/plat-mxc/devices/platform-gpio-mxc.c
+++ b/arch/arm/plat-mxc/devices/platform-gpio-mxc.c
@@ -12,19 +12,9 @@ struct platform_device *__init mxc_register_gpio(int id,
 	resource_size_t iobase, resource_size_t iosize, int irq, int irq_high)
 {
 	struct resource res[] = {
-		{
-			.start = iobase,
-			.end = iobase + iosize - 1,
-			.flags = IORESOURCE_MEM,
-		}, {
-			.start = irq,
-			.end = irq,
-			.flags = IORESOURCE_IRQ,
-		}, {
-			.start = irq_high,
-			.end = irq_high,
-			.flags = IORESOURCE_IRQ,
-		},
+		DEFINE_RES_MEM(iobase, iosize),
+		DEFINE_RES_IRQ(irq),
+		DEFINE_RES_IRQ(irq_high),
 	};
 
 	return platform_device_register_resndata(&mxc_aips_bus,
diff --git a/arch/arm/plat-mxc/devices/platform-imx-dma.c b/arch/arm/plat-mxc/devices/platform-imx-dma.c
index 2b0fdb2..90280f0 100644
--- a/arch/arm/plat-mxc/devices/platform-imx-dma.c
+++ b/arch/arm/plat-mxc/devices/platform-imx-dma.c
@@ -18,15 +18,8 @@ struct platform_device __init __maybe_unused *imx_add_imx_sdma(
 	resource_size_t iobase, int irq, struct sdma_platform_data *pdata)
 {
 	struct resource res[] = {
-		{
-			.start = iobase,
-			.end = iobase + SZ_16K - 1,
-			.flags = IORESOURCE_MEM,
-		}, {
-			.start = irq,
-			.end = irq,
-			.flags = IORESOURCE_IRQ,
-		},
+		DEFINE_RES_MEM(iobase, SZ_16K),
+		DEFINE_RES_IRQ(irq),
 	};
 
 	return platform_device_register_resndata(&mxc_ahb_bus, "imx-sdma",
diff --git a/arch/arm/plat-mxc/devices/platform-imx-fb.c b/arch/arm/plat-mxc/devices/platform-imx-fb.c
index 2b0b5e0..fe76319 100644
--- a/arch/arm/plat-mxc/devices/platform-imx-fb.c
+++ b/arch/arm/plat-mxc/devices/platform-imx-fb.c
@@ -42,15 +42,8 @@ struct platform_device *__init imx_add_imx_fb(
 		const struct imx_fb_platform_data *pdata)
 {
 	struct resource res[] = {
-		{
-			.start = data->iobase,
-			.end = data->iobase + data->iosize - 1,
-			.flags = IORESOURCE_MEM,
-		}, {
-			.start = data->irq,
-			.end = data->irq,
-			.flags = IORESOURCE_IRQ,
-		},
+		DEFINE_RES_MEM(data->iobase, data->iosize),
+		DEFINE_RES_IRQ(data->irq),
 	};
 	return imx_add_platform_device_dmamask("imx-fb", 0,
 			res, ARRAY_SIZE(res),
diff --git a/arch/arm/plat-mxc/devices/platform-imx-i2c.c b/arch/arm/plat-mxc/devices/platform-imx-i2c.c
index afe60f7..d624f73 100644
--- a/arch/arm/plat-mxc/devices/platform-imx-i2c.c
+++ b/arch/arm/plat-mxc/devices/platform-imx-i2c.c
@@ -103,15 +103,8 @@ struct platform_device *__init imx_add_imx_i2c(
 		const struct imxi2c_platform_data *pdata)
 {
 	struct resource res[] = {
-		{
-			.start = data->iobase,
-			.end = data->iobase + data->iosize - 1,
-			.flags = IORESOURCE_MEM,
-		}, {
-			.start = data->irq,
-			.end = data->irq,
-			.flags = IORESOURCE_IRQ,
-		},
+		DEFINE_RES_MEM(data->iobase, data->iosize),
+		DEFINE_RES_IRQ(data->irq),
 	};
 
 	return imx_add_platform_device("imx-i2c", data->id,
diff --git a/arch/arm/plat-mxc/devices/platform-imx-keypad.c b/arch/arm/plat-mxc/devices/platform-imx-keypad.c
index 479c3e9..573a3a0 100644
--- a/arch/arm/plat-mxc/devices/platform-imx-keypad.c
+++ b/arch/arm/plat-mxc/devices/platform-imx-keypad.c
@@ -56,15 +56,8 @@ struct platform_device *__init imx_add_imx_keypad(
 		const struct matrix_keymap_data *pdata)
 {
 	struct resource res[] = {
-		{
-			.start = data->iobase,
-			.end = data->iobase + data->iosize - 1,
-			.flags = IORESOURCE_MEM,
-		}, {
-			.start = data->irq,
-			.end = data->irq,
-			.flags = IORESOURCE_IRQ,
-		},
+		DEFINE_RES_MEM(data->iobase, data->iosize),
+		DEFINE_RES_IRQ(data->irq),
 	};
 
 	return imx_add_platform_device("imx-keypad", -1,
diff --git a/arch/arm/plat-mxc/devices/platform-imx-ssi.c b/arch/arm/plat-mxc/devices/platform-imx-ssi.c
index 21c6f30..a8e6c2f 100644
--- a/arch/arm/plat-mxc/devices/platform-imx-ssi.c
+++ b/arch/arm/plat-mxc/devices/platform-imx-ssi.c
@@ -91,21 +91,10 @@ struct platform_device *__init imx_add_imx_ssi(
 		const struct imx_ssi_platform_data *pdata)
 {
 	struct resource res[] = {
-		{
-			.start = data->iobase,
-			.end = data->iobase + data->iosize - 1,
-			.flags = IORESOURCE_MEM,
-		}, {
-			.start = data->irq,
-			.end = data->irq,
-			.flags = IORESOURCE_IRQ,
-		},
-#define DMARES(_name) {							\
-	.name = #_name,							\
-	.start = data->dma ## _name,					\
-	.end = data->dma ## _name,					\
-	.flags = IORESOURCE_DMA,					\
-}
+		DEFINE_RES_MEM(data->iobase, data->iosize),
+		DEFINE_RES_IRQ(data->irq),
+#define DMARES(_name)	\
+	DEFINE_RES_NAMED(data->dma ## _name, 1, #_name, IORESOURCE_DMA)
 		DMARES(tx0),
 		DMARES(rx0),
 		DMARES(tx1),
diff --git a/arch/arm/plat-mxc/devices/platform-imx-uart.c b/arch/arm/plat-mxc/devices/platform-imx-uart.c
index cfce8c9..d3659ad 100644
--- a/arch/arm/plat-mxc/devices/platform-imx-uart.c
+++ b/arch/arm/plat-mxc/devices/platform-imx-uart.c
@@ -133,23 +133,10 @@ struct platform_device *__init imx_add_imx_uart_3irq(
 		const struct imxuart_platform_data *pdata)
 {
 	struct resource res[] = {
-		{
-			.start = data->iobase,
-			.end = data->iobase + data->iosize - 1,
-			.flags = IORESOURCE_MEM,
-		}, {
-			.start = data->irqrx,
-			.end = data->irqrx,
-			.flags = IORESOURCE_IRQ,
-		}, {
-			.start = data->irqtx,
-			.end = data->irqtx,
-			.flags = IORESOURCE_IRQ,
-		}, {
-			.start = data->irqrts,
-			.end = data->irqrx,
-			.flags = IORESOURCE_IRQ,
-		},
+		DEFINE_RES_MEM(data->iobase, data->iosize),
+		DEFINE_RES_IRQ(data->irqrx),
+		DEFINE_RES_IRQ(data->irqtx),
+		DEFINE_RES_IRQ(data->irqrts),
 	};
 
 	return imx_add_platform_device("imx-uart", data->id, res,
@@ -161,17 +148,11 @@ struct platform_device *__init imx_add_imx_uart_1irq(
 		const struct imxuart_platform_data *pdata)
 {
 	struct resource res[] = {
-		{
-			.start = data->iobase,
-			.end = data->iobase + data->iosize - 1,
-			.flags = IORESOURCE_MEM,
-		}, {
-			.start = data->irq,
-			.end = data->irq,
-			.flags = IORESOURCE_IRQ,
-		},
+		DEFINE_RES_MEM(data->iobase, data->iosize),
+		DEFINE_RES_IRQ(data->irq),
 	};
 
-	return imx_add_platform_device("imx-uart", data->id, res, ARRAY_SIZE(res),
+	return imx_add_platform_device("imx-uart", data->id,
+			res, ARRAY_SIZE(res),
 			pdata, sizeof(*pdata));
 }
diff --git a/arch/arm/plat-mxc/devices/platform-imx2-wdt.c b/arch/arm/plat-mxc/devices/platform-imx2-wdt.c
index 5e07ef2..03e81a5 100644
--- a/arch/arm/plat-mxc/devices/platform-imx2-wdt.c
+++ b/arch/arm/plat-mxc/devices/platform-imx2-wdt.c
@@ -66,11 +66,7 @@ struct platform_device *__init imx_add_imx2_wdt(
 		const struct imx_imx2_wdt_data *data)
 {
 	struct resource res[] = {
-		{
-			.start = data->iobase,
-			.end = data->iobase + data->iosize - 1,
-			.flags = IORESOURCE_MEM,
-		},
+		DEFINE_RES_MEM(data->iobase, data->iosize),
 	};
 	return imx_add_platform_device("imx2-wdt", data->id,
 			res, ARRAY_SIZE(res), NULL, 0);
diff --git a/arch/arm/plat-mxc/devices/platform-imx21-hcd.c b/arch/arm/plat-mxc/devices/platform-imx21-hcd.c
index 5770a42..77931cc 100644
--- a/arch/arm/plat-mxc/devices/platform-imx21-hcd.c
+++ b/arch/arm/plat-mxc/devices/platform-imx21-hcd.c
@@ -25,15 +25,8 @@ struct platform_device *__init imx_add_imx21_hcd(
 		const struct mx21_usbh_platform_data *pdata)
 {
 	struct resource res[] = {
-		{
-			.start = data->iobase,
-			.end = data->iobase + SZ_8K - 1,
-			.flags = IORESOURCE_MEM,
-		}, {
-			.start = data->irq,
-			.end = data->irq,
-			.flags = IORESOURCE_IRQ,
-		},
+		DEFINE_RES_MEM(data->iobase, SZ_8K),
+		DEFINE_RES_IRQ(data->irq),
 	};
 	return imx_add_platform_device_dmamask("imx21-hcd", 0,
 			res, ARRAY_SIZE(res),
diff --git a/arch/arm/plat-mxc/devices/platform-imx_udc.c b/arch/arm/plat-mxc/devices/platform-imx_udc.c
index 6fd675d..ad754c7 100644
--- a/arch/arm/plat-mxc/devices/platform-imx_udc.c
+++ b/arch/arm/plat-mxc/devices/platform-imx_udc.c
@@ -35,39 +35,14 @@ struct platform_device *__init imx_add_imx_udc(
 		const struct imxusb_platform_data *pdata)
 {
 	struct resource res[] = {
-		{
-			.start = data->iobase,
-			.end = data->iobase + data->iosize - 1,
-			.flags = IORESOURCE_MEM,
-		}, {
-			.start = data->irq0,
-			.end = data->irq0,
-			.flags = IORESOURCE_IRQ,
-		}, {
-			.start = data->irq1,
-			.end = data->irq1,
-			.flags = IORESOURCE_IRQ,
-		}, {
-			.start = data->irq2,
-			.end = data->irq2,
-			.flags = IORESOURCE_IRQ,
-		}, {
-			.start = data->irq3,
-			.end = data->irq3,
-			.flags = IORESOURCE_IRQ,
-		}, {
-			.start = data->irq4,
-			.end = data->irq4,
-			.flags = IORESOURCE_IRQ,
-		}, {
-			.start = data->irq5,
-			.end = data->irq5,
-			.flags = IORESOURCE_IRQ,
-		}, {
-			.start = data->irq6,
-			.end = data->irq6,
-			.flags = IORESOURCE_IRQ,
-		},
+		DEFINE_RES_MEM(data->iobase, data->iosize),
+		DEFINE_RES_IRQ(data->irq0),
+		DEFINE_RES_IRQ(data->irq1),
+		DEFINE_RES_IRQ(data->irq2),
+		DEFINE_RES_IRQ(data->irq3),
+		DEFINE_RES_IRQ(data->irq4),
+		DEFINE_RES_IRQ(data->irq5),
+		DEFINE_RES_IRQ(data->irq6),
 	};
 
 	return imx_add_platform_device("imx_udc", 0,
diff --git a/arch/arm/plat-mxc/devices/platform-imxdi_rtc.c b/arch/arm/plat-mxc/devices/platform-imxdi_rtc.c
index 805336f..1929153 100644
--- a/arch/arm/plat-mxc/devices/platform-imxdi_rtc.c
+++ b/arch/arm/plat-mxc/devices/platform-imxdi_rtc.c
@@ -25,15 +25,8 @@ struct platform_device *__init imx_add_imxdi_rtc(
 		const struct imx_imxdi_rtc_data *data)
 {
 	struct resource res[] = {
-		{
-			.start = data->iobase,
-			.end = data->iobase + SZ_16K - 1,
-			.flags = IORESOURCE_MEM,
-		}, {
-			.start = data->irq,
-			.end = data->irq,
-			.flags = IORESOURCE_IRQ,
-		},
+		DEFINE_RES_MEM(data->iobase, SZ_16K),
+		DEFINE_RES_IRQ(data->irq),
 	};
 
 	return imx_add_platform_device("imxdi_rtc", 0,
diff --git a/arch/arm/plat-mxc/devices/platform-ipu-core.c b/arch/arm/plat-mxc/devices/platform-ipu-core.c
index 79d340a..0a30c30 100644
--- a/arch/arm/plat-mxc/devices/platform-ipu-core.c
+++ b/arch/arm/plat-mxc/devices/platform-ipu-core.c
@@ -35,23 +35,10 @@ struct platform_device *__init imx_add_ipu_core(
 {
 	/* The resource order is important! */
 	struct resource res[] = {
-		{
-			.start = data->iobase,
-			.end = data->iobase + 0x5f,
-			.flags = IORESOURCE_MEM,
-		}, {
-			.start = data->iobase + 0x88,
-			.end = data->iobase + 0xb3,
-			.flags = IORESOURCE_MEM,
-		}, {
-			.start = data->synirq,
-			.end = data->synirq,
-			.flags = IORESOURCE_IRQ,
-		}, {
-			.start = data->errirq,
-			.end = data->errirq,
-			.flags = IORESOURCE_IRQ,
-		},
+		DEFINE_RES_MEM(data->iobase, 0x60),
+		DEFINE_RES_MEM(data->iobase + 0x88, 0x2c),
+		DEFINE_RES_IRQ(data->synirq),
+		DEFINE_RES_IRQ(data->errirq),
 	};
 
 	return imx_ipu_coredev = imx_add_platform_device("ipu-core", -1,
@@ -63,11 +50,7 @@ struct platform_device *__init imx_alloc_mx3_camera(
 		const struct mx3_camera_pdata *pdata)
 {
 	struct resource res[] = {
-		{
-			.start = data->iobase + 0x60,
-			.end = data->iobase + 0x87,
-			.flags = IORESOURCE_MEM,
-		},
+		DEFINE_RES_MEM(data->iobase + 0x60, 0x28);
 	};
 	int ret = -ENOMEM;
 	struct platform_device *pdev;
@@ -112,11 +95,7 @@ struct platform_device *__init imx_add_mx3_sdc_fb(
 		struct mx3fb_platform_data *pdata)
 {
 	struct resource res[] = {
-		{
-			.start = data->iobase + 0xb4,
-			.end = data->iobase + 0x1bf,
-			.flags = IORESOURCE_MEM,
-		},
+		DEFINE_RES_MEM(data->iobase + 0xb4, 0x10c),
 	};
 
 	if (IS_ERR_OR_NULL(imx_ipu_coredev))
diff --git a/arch/arm/plat-mxc/devices/platform-mx1-camera.c b/arch/arm/plat-mxc/devices/platform-mx1-camera.c
index edcc581..61dac5e 100644
--- a/arch/arm/plat-mxc/devices/platform-mx1-camera.c
+++ b/arch/arm/plat-mxc/devices/platform-mx1-camera.c
@@ -26,15 +26,8 @@ struct platform_device *__init imx_add_mx1_camera(
 		const struct mx1_camera_pdata *pdata)
 {
 	struct resource res[] = {
-		{
-			.start = data->iobase,
-			.end = data->iobase + data->iosize - 1,
-			.flags = IORESOURCE_MEM,
-		}, {
-			.start = data->irq,
-			.end = data->irq,
-			.flags = IORESOURCE_IRQ,
-		},
+		DEFINE_RES_MEM(data->iobase, data->iosize),
+		DEFINE_RES_IRQ(data->irq),
 	};
 	return imx_add_platform_device_dmamask("mx1-camera", 0,
 			res, ARRAY_SIZE(res),
diff --git a/arch/arm/plat-mxc/devices/platform-mx2-camera.c b/arch/arm/plat-mxc/devices/platform-mx2-camera.c
index b3f4828..c167f30 100644
--- a/arch/arm/plat-mxc/devices/platform-mx2-camera.c
+++ b/arch/arm/plat-mxc/devices/platform-mx2-camera.c
@@ -40,23 +40,10 @@ struct platform_device *__init imx_add_mx2_camera(
 		const struct mx2_camera_platform_data *pdata)
 {
 	struct resource res[] = {
-		{
-			.start = data->iobasecsi,
-			.end = data->iobasecsi + data->iosizecsi - 1,
-			.flags = IORESOURCE_MEM,
-		}, {
-			.start = data->irqcsi,
-			.end = data->irqcsi,
-			.flags = IORESOURCE_IRQ,
-		}, {
-			.start = data->iobaseemmaprp,
-			.end = data->iobaseemmaprp + data->iosizeemmaprp - 1,
-			.flags = IORESOURCE_MEM,
-		}, {
-			.start = data->irqemmaprp,
-			.end = data->irqemmaprp,
-			.flags = IORESOURCE_IRQ,
-		},
+		DEFINE_RES_MEM(data->iobasecsi, data->iosizecsi),
+		DEFINE_RES_IRQ(data->irqcsi),
+		DEFINE_RES_MEM(data->iobaseemmaprp, data->iosizeemmaprp),
+		DEFINE_RES_IRQ(data->irqemmaprp),
 	};
 	return imx_add_platform_device_dmamask("mx2-camera", 0,
 			res, data->iobaseemmaprp ? 4 : 2,
diff --git a/arch/arm/plat-mxc/devices/platform-mxc-ehci.c b/arch/arm/plat-mxc/devices/platform-mxc-ehci.c
index e1763e0..9eb7b62 100644
--- a/arch/arm/plat-mxc/devices/platform-mxc-ehci.c
+++ b/arch/arm/plat-mxc/devices/platform-mxc-ehci.c
@@ -54,15 +54,8 @@ struct platform_device *__init imx_add_mxc_ehci(
 		const struct mxc_usbh_platform_data *pdata)
 {
 	struct resource res[] = {
-		{
-			.start = data->iobase,
-			.end = data->iobase + SZ_512 - 1,
-			.flags = IORESOURCE_MEM,
-		}, {
-			.start = data->irq,
-			.end = data->irq,
-			.flags = IORESOURCE_IRQ,
-		},
+		DEFINE_RES_MEM(data->iobase, SZ_512),
+		DEFINE_RES_IRQ(data->irq),
 	};
 	return imx_add_platform_device_dmamask("mxc-ehci", data->id,
 			res, ARRAY_SIZE(res),
diff --git a/arch/arm/plat-mxc/devices/platform-mxc-mmc.c b/arch/arm/plat-mxc/devices/platform-mxc-mmc.c
index 540d3a7..b105933 100644
--- a/arch/arm/plat-mxc/devices/platform-mxc-mmc.c
+++ b/arch/arm/plat-mxc/devices/platform-mxc-mmc.c
@@ -53,19 +53,9 @@ struct platform_device *__init imx_add_mxc_mmc(
 		const struct imxmmc_platform_data *pdata)
 {
 	struct resource res[] = {
-		{
-			.start = data->iobase,
-			.end = data->iobase + SZ_4K - 1,
-			.flags = IORESOURCE_MEM,
-		}, {
-			.start = data->irq,
-			.end = data->irq,
-			.flags = IORESOURCE_IRQ,
-		}, {
-			.start = data->dmareq,
-			.end = data->dmareq,
-			.flags = IORESOURCE_DMA,
-		},
+		DEFINE_RES_MEM(data->iobase, SZ_4K),
+		DEFINE_RES_IRQ(data->irq),
+		DEFINE_RES_NAMED(data->dmareq, 1, NULL, IORESOURCE_DMA),
 	};
 	return imx_add_platform_device_dmamask("mxc-mmc", data->id,
 			res, ARRAY_SIZE(res),
diff --git a/arch/arm/plat-mxc/devices/platform-mxc_nand.c b/arch/arm/plat-mxc/devices/platform-mxc_nand.c
index 1568f39..3664533 100644
--- a/arch/arm/plat-mxc/devices/platform-mxc_nand.c
+++ b/arch/arm/plat-mxc/devices/platform-mxc_nand.c
@@ -62,19 +62,9 @@ struct platform_device *__init imx_add_mxc_nand(
 {
 	/* AXI has to come first, that's how the mxc_nand driver expect it */
 	struct resource res[] = {
-		{
-			.start = data->axibase,
-			.end = data->axibase + SZ_16K - 1,
-			.flags = IORESOURCE_MEM,
-		}, {
-			.start = data->iobase,
-			.end = data->iobase + data->iosize - 1,
-			.flags = IORESOURCE_MEM,
-		}, {
-			.start = data->irq,
-			.end = data->irq,
-			.flags = IORESOURCE_IRQ,
-		},
+		DEFINE_RES_MEM(data->axibase, SZ_16K),
+		DEFINE_RES_MEM(data->iobase, data->iosize),
+		DEFINE_RES_IRQ(data->irq),
 	};
 	return imx_add_platform_device("mxc_nand", data->id,
 			res + !data->axibase,
diff --git a/arch/arm/plat-mxc/devices/platform-mxc_pwm.c b/arch/arm/plat-mxc/devices/platform-mxc_pwm.c
index b0c4ae2..bcc95ec 100644
--- a/arch/arm/plat-mxc/devices/platform-mxc_pwm.c
+++ b/arch/arm/plat-mxc/devices/platform-mxc_pwm.c
@@ -53,15 +53,8 @@ struct platform_device *__init imx_add_mxc_pwm(
 		const struct imx_mxc_pwm_data *data)
 {
 	struct resource res[] = {
-		{
-			.start = data->iobase,
-			.end = data->iobase + data->iosize - 1,
-			.flags = IORESOURCE_MEM,
-		}, {
-			.start = data->irq,
-			.end = data->irq,
-			.flags = IORESOURCE_IRQ,
-		},
+		DEFINE_RES_MEM(data->iobase, data->iosize),
+		DEFINE_RES_IRQ(data->irq),
 	};
 
 	return imx_add_platform_device("mxc_pwm", data->id,
diff --git a/arch/arm/plat-mxc/devices/platform-mxc_rnga.c b/arch/arm/plat-mxc/devices/platform-mxc_rnga.c
index b4b7612..a4fb661 100644
--- a/arch/arm/plat-mxc/devices/platform-mxc_rnga.c
+++ b/arch/arm/plat-mxc/devices/platform-mxc_rnga.c
@@ -27,11 +27,7 @@ static struct platform_device *__init imx_add_mxc_rnga(
 		const struct imx_mxc_rnga_data *data)
 {
 	struct resource res[] = {
-		{
-			.start = data->iobase,
-			.end = data->iobase + SZ_16K - 1,
-			.flags = IORESOURCE_MEM,
-		},
+		DEFINE_RES_MEM(data->iobase, SZ_16K),
 	};
 	return imx_add_platform_device("mxc_rnga", -1,
 			res, ARRAY_SIZE(res), NULL, 0);
diff --git a/arch/arm/plat-mxc/devices/platform-mxc_rtc.c b/arch/arm/plat-mxc/devices/platform-mxc_rtc.c
index 16d0ec4..2dd42dc 100644
--- a/arch/arm/plat-mxc/devices/platform-mxc_rtc.c
+++ b/arch/arm/plat-mxc/devices/platform-mxc_rtc.c
@@ -24,15 +24,8 @@ struct platform_device *__init imx_add_mxc_rtc(
 		const struct imx_mxc_rtc_data *data)
 {
 	struct resource res[] = {
-		{
-			.start = data->iobase,
-			.end = data->iobase + SZ_16K - 1,
-			.flags = IORESOURCE_MEM,
-		}, {
-			.start = data->irq,
-			.end = data->irq,
-			.flags = IORESOURCE_IRQ,
-		},
+		DEFINE_RES_MEM(data->iobase, SZ_16K),
+		DEFINE_RES_IRQ(data->irq),
 	};
 
 	return imx_add_platform_device("mxc_rtc", -1,
diff --git a/arch/arm/plat-mxc/devices/platform-mxc_w1.c b/arch/arm/plat-mxc/devices/platform-mxc_w1.c
index 96fa5ea..72b97ea 100644
--- a/arch/arm/plat-mxc/devices/platform-mxc_w1.c
+++ b/arch/arm/plat-mxc/devices/platform-mxc_w1.c
@@ -38,11 +38,7 @@ struct platform_device *__init imx_add_mxc_w1(
 		const struct imx_mxc_w1_data *data)
 {
 	struct resource res[] = {
-		{
-			.start = data->iobase,
-			.end = data->iobase + SZ_4K - 1,
-			.flags = IORESOURCE_MEM,
-		},
+		DEFINE_RES_MEM(data->iobase, SZ_4K),
 	};
 
 	return imx_add_platform_device("mxc_w1", 0,
diff --git a/arch/arm/plat-mxc/devices/platform-sdhci-esdhc-imx.c b/arch/arm/plat-mxc/devices/platform-sdhci-esdhc-imx.c
index 6b2940b..325c2a1 100644
--- a/arch/arm/plat-mxc/devices/platform-sdhci-esdhc-imx.c
+++ b/arch/arm/plat-mxc/devices/platform-sdhci-esdhc-imx.c
@@ -70,15 +70,8 @@ struct platform_device *__init imx_add_sdhci_esdhc_imx(
 		const struct esdhc_platform_data *pdata)
 {
 	struct resource res[] = {
-		{
-			.start = data->iobase,
-			.end = data->iobase + SZ_16K - 1,
-			.flags = IORESOURCE_MEM,
-		}, {
-			.start = data->irq,
-			.end = data->irq,
-			.flags = IORESOURCE_IRQ,
-		},
+		DEFINE_RES_MEM(data->iobase, SZ_16K),
+		DEFINE_RES_IRQ(data->irq),
 	};
 
 	return imx_add_platform_device("sdhci-esdhc-imx", data->id, res,
diff --git a/arch/arm/plat-mxc/devices/platform-spi_imx.c b/arch/arm/plat-mxc/devices/platform-spi_imx.c
index f97eb36..1b680b4 100644
--- a/arch/arm/plat-mxc/devices/platform-spi_imx.c
+++ b/arch/arm/plat-mxc/devices/platform-spi_imx.c
@@ -107,15 +107,8 @@ struct platform_device *__init imx_add_spi_imx(
 		const struct spi_imx_master *pdata)
 {
 	struct resource res[] = {
-		{
-			.start = data->iobase,
-			.end = data->iobase + data->iosize - 1,
-			.flags = IORESOURCE_MEM,
-		}, {
-			.start = data->irq,
-			.end = data->irq,
-			.flags = IORESOURCE_IRQ,
-		},
+		DEFINE_RES_MEM(data->iobase, data->iosize),
+		DEFINE_RES_IRQ(data->irq),
 	};
 
 	return imx_add_platform_device(data->devid, data->id,
-- 
1.7.5.4

