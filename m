Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab2IFM5x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 08:57:53 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40916 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754370Ab2IFMso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 08:48:44 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: <linux-arm-kernel@lists.infradead.org>
Cc: HACHIMI Samir <shachimi@adeneo-embedded.com>, shawn.guo@linaro.org,
        thierry.reding@avionic-design.de, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Beno=C3=AEt=20Th=C3=A9baudeau?= 
	<benoit.thebaudeau@advansee.com>,
        kernel@pengutronix.de, Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 9/9] ARM i.MX: remove PWM platform support
Date: Thu,  6 Sep 2012 14:48:15 +0200
Message-Id: <1346935695-25179-10-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1346935695-25179-1-git-send-email-s.hauer@pengutronix.de>
References: <1346935695-25179-1-git-send-email-s.hauer@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the pwm driver now is devicetree only, remove the platform
support for this device.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 arch/arm/mach-imx/clk-imx21.c                   |    1 -
 arch/arm/mach-imx/clk-imx25.c                   |    8 ---
 arch/arm/mach-imx/clk-imx27.c                   |    1 -
 arch/arm/mach-imx/clk-imx51-imx53.c             |    2 -
 arch/arm/mach-imx/devices-imx25.h               |    4 --
 arch/arm/mach-imx/devices-imx51.h               |    4 --
 arch/arm/plat-mxc/devices/Kconfig               |    3 -
 arch/arm/plat-mxc/devices/Makefile              |    1 -
 arch/arm/plat-mxc/devices/platform-mxc_pwm.c    |   69 -----------------------
 arch/arm/plat-mxc/include/mach/devices-common.h |    9 ---
 10 files changed, 102 deletions(-)
 delete mode 100644 arch/arm/plat-mxc/devices/platform-mxc_pwm.c

diff --git a/arch/arm/mach-imx/clk-imx21.c b/arch/arm/mach-imx/clk-imx21.c
index ea13e61..63d5724 100644
--- a/arch/arm/mach-imx/clk-imx21.c
+++ b/arch/arm/mach-imx/clk-imx21.c
@@ -150,7 +150,6 @@ int __init mx21_clocks_init(unsigned long lref, unsigned long href)
 	clk_register_clkdev(clk[per1], "per", "imx-gpt.1");
 	clk_register_clkdev(clk[gpt3_ipg_gate], "ipg", "imx-gpt.2");
 	clk_register_clkdev(clk[per1], "per", "imx-gpt.2");
-	clk_register_clkdev(clk[pwm_ipg_gate], "pwm", "mxc_pwm.0");
 	clk_register_clkdev(clk[per2], "per", "imx21-cspi.0");
 	clk_register_clkdev(clk[cspi1_ipg_gate], "ipg", "imx21-cspi.0");
 	clk_register_clkdev(clk[per2], "per", "imx21-cspi.1");
diff --git a/arch/arm/mach-imx/clk-imx25.c b/arch/arm/mach-imx/clk-imx25.c
index fdd8cc8..1d40c6e 100644
--- a/arch/arm/mach-imx/clk-imx25.c
+++ b/arch/arm/mach-imx/clk-imx25.c
@@ -202,14 +202,6 @@ int __init mx25_clocks_init(void)
 	clk_register_clkdev(clk[cspi1_ipg], NULL, "imx35-cspi.0");
 	clk_register_clkdev(clk[cspi2_ipg], NULL, "imx35-cspi.1");
 	clk_register_clkdev(clk[cspi3_ipg], NULL, "imx35-cspi.2");
-	clk_register_clkdev(clk[pwm1_ipg], "ipg", "mxc_pwm.0");
-	clk_register_clkdev(clk[per10], "per", "mxc_pwm.0");
-	clk_register_clkdev(clk[pwm1_ipg], "ipg", "mxc_pwm.1");
-	clk_register_clkdev(clk[per10], "per", "mxc_pwm.1");
-	clk_register_clkdev(clk[pwm1_ipg], "ipg", "mxc_pwm.2");
-	clk_register_clkdev(clk[per10], "per", "mxc_pwm.2");
-	clk_register_clkdev(clk[pwm1_ipg], "ipg", "mxc_pwm.3");
-	clk_register_clkdev(clk[per10], "per", "mxc_pwm.3");
 	clk_register_clkdev(clk[kpp_ipg], NULL, "imx-keypad");
 	clk_register_clkdev(clk[tsc_ipg], NULL, "mx25-adc");
 	clk_register_clkdev(clk[i2c_ipg_per], NULL, "imx-i2c.0");
diff --git a/arch/arm/mach-imx/clk-imx27.c b/arch/arm/mach-imx/clk-imx27.c
index f69ca46..4043222 100644
--- a/arch/arm/mach-imx/clk-imx27.c
+++ b/arch/arm/mach-imx/clk-imx27.c
@@ -210,7 +210,6 @@ int __init mx27_clocks_init(unsigned long fref)
 	clk_register_clkdev(clk[per1_gate], "per", "imx-gpt.4");
 	clk_register_clkdev(clk[gpt6_ipg_gate], "ipg", "imx-gpt.5");
 	clk_register_clkdev(clk[per1_gate], "per", "imx-gpt.5");
-	clk_register_clkdev(clk[pwm_ipg_gate], NULL, "mxc_pwm.0");
 	clk_register_clkdev(clk[per2_gate], "per", "mxc-mmc.0");
 	clk_register_clkdev(clk[sdhc1_ipg_gate], "ipg", "mxc-mmc.0");
 	clk_register_clkdev(clk[per2_gate], "per", "mxc-mmc.1");
diff --git a/arch/arm/mach-imx/clk-imx51-imx53.c b/arch/arm/mach-imx/clk-imx51-imx53.c
index b522411..cafe20f 100644
--- a/arch/arm/mach-imx/clk-imx51-imx53.c
+++ b/arch/arm/mach-imx/clk-imx51-imx53.c
@@ -254,8 +254,6 @@ static void __init mx5_clocks_common_init(unsigned long rate_ckil,
 	clk_register_clkdev(clk[ecspi2_per_gate], "per", "imx51-ecspi.1");
 	clk_register_clkdev(clk[ecspi2_ipg_gate], "ipg", "imx51-ecspi.1");
 	clk_register_clkdev(clk[cspi_ipg_gate], NULL, "imx35-cspi.2");
-	clk_register_clkdev(clk[pwm1_ipg_gate], "pwm", "mxc_pwm.0");
-	clk_register_clkdev(clk[pwm2_ipg_gate], "pwm", "mxc_pwm.1");
 	clk_register_clkdev(clk[i2c1_gate], NULL, "imx-i2c.0");
 	clk_register_clkdev(clk[i2c2_gate], NULL, "imx-i2c.1");
 	clk_register_clkdev(clk[usboh3_per_gate], "per", "mxc-ehci.0");
diff --git a/arch/arm/mach-imx/devices-imx25.h b/arch/arm/mach-imx/devices-imx25.h
index f8e03dd..441c422 100644
--- a/arch/arm/mach-imx/devices-imx25.h
+++ b/arch/arm/mach-imx/devices-imx25.h
@@ -84,7 +84,3 @@ extern const struct imx_spi_imx_data imx25_cspi_data[];
 #define imx25_add_spi_imx0(pdata)	imx25_add_spi_imx(0, pdata)
 #define imx25_add_spi_imx1(pdata)	imx25_add_spi_imx(1, pdata)
 #define imx25_add_spi_imx2(pdata)	imx25_add_spi_imx(2, pdata)
-
-extern struct imx_mxc_pwm_data imx25_mxc_pwm_data[];
-#define imx25_add_mxc_pwm(id)	\
-	imx_add_mxc_pwm(&imx25_mxc_pwm_data[id])
diff --git a/arch/arm/mach-imx/devices-imx51.h b/arch/arm/mach-imx/devices-imx51.h
index 9f17187..18643f7 100644
--- a/arch/arm/mach-imx/devices-imx51.h
+++ b/arch/arm/mach-imx/devices-imx51.h
@@ -58,10 +58,6 @@ extern const struct imx_imx2_wdt_data imx51_imx2_wdt_data[];
 #define imx51_add_imx2_wdt(id)	\
 	imx_add_imx2_wdt(&imx51_imx2_wdt_data[id])
 
-extern const struct imx_mxc_pwm_data imx51_mxc_pwm_data[];
-#define imx51_add_mxc_pwm(id)	\
-	imx_add_mxc_pwm(&imx51_mxc_pwm_data[id])
-
 extern const struct imx_imx_keypad_data imx51_imx_keypad_data;
 #define imx51_add_imx_keypad(pdata)	\
 	imx_add_imx_keypad(&imx51_imx_keypad_data, pdata)
diff --git a/arch/arm/plat-mxc/devices/Kconfig b/arch/arm/plat-mxc/devices/Kconfig
index cb3e3ee..478b014 100644
--- a/arch/arm/plat-mxc/devices/Kconfig
+++ b/arch/arm/plat-mxc/devices/Kconfig
@@ -61,9 +61,6 @@ config IMX_HAVE_PLATFORM_MXC_MMC
 config IMX_HAVE_PLATFORM_MXC_NAND
 	bool
 
-config IMX_HAVE_PLATFORM_MXC_PWM
-	bool
-
 config IMX_HAVE_PLATFORM_MXC_RNGA
 	bool
 	select ARCH_HAS_RNGA
diff --git a/arch/arm/plat-mxc/devices/Makefile b/arch/arm/plat-mxc/devices/Makefile
index c11ac84..b3bddeb 100644
--- a/arch/arm/plat-mxc/devices/Makefile
+++ b/arch/arm/plat-mxc/devices/Makefile
@@ -20,7 +20,6 @@ obj-$(CONFIG_IMX_HAVE_PLATFORM_MX2_CAMERA) += platform-mx2-camera.o
 obj-$(CONFIG_IMX_HAVE_PLATFORM_MXC_EHCI) += platform-mxc-ehci.o
 obj-$(CONFIG_IMX_HAVE_PLATFORM_MXC_MMC) += platform-mxc-mmc.o
 obj-$(CONFIG_IMX_HAVE_PLATFORM_MXC_NAND) += platform-mxc_nand.o
-obj-$(CONFIG_IMX_HAVE_PLATFORM_MXC_PWM) += platform-mxc_pwm.o
 obj-$(CONFIG_IMX_HAVE_PLATFORM_MXC_RNGA) += platform-mxc_rnga.o
 obj-$(CONFIG_IMX_HAVE_PLATFORM_MXC_RTC) += platform-mxc_rtc.o
 obj-$(CONFIG_IMX_HAVE_PLATFORM_MXC_W1) += platform-mxc_w1.o
diff --git a/arch/arm/plat-mxc/devices/platform-mxc_pwm.c b/arch/arm/plat-mxc/devices/platform-mxc_pwm.c
deleted file mode 100644
index b0c4ae2..0000000
--- a/arch/arm/plat-mxc/devices/platform-mxc_pwm.c
+++ /dev/null
@@ -1,69 +0,0 @@
-/*
- * Copyright (C) 2009-2010 Pengutronix
- * Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>
- *
- * This program is free software; you can redistribute it and/or modify it under
- * the terms of the GNU General Public License version 2 as published by the
- * Free Software Foundation.
- */
-#include <mach/hardware.h>
-#include <mach/devices-common.h>
-
-#define imx_mxc_pwm_data_entry_single(soc, _id, _hwid, _size)		\
-	{								\
-		.id = _id,						\
-		.iobase = soc ## _PWM ## _hwid ## _BASE_ADDR,		\
-		.iosize = _size,					\
-		.irq = soc ## _INT_PWM ## _hwid,			\
-	}
-#define imx_mxc_pwm_data_entry(soc, _id, _hwid, _size)			\
-	[_id] = imx_mxc_pwm_data_entry_single(soc, _id, _hwid, _size)
-
-#ifdef CONFIG_SOC_IMX21
-const struct imx_mxc_pwm_data imx21_mxc_pwm_data __initconst =
-	imx_mxc_pwm_data_entry_single(MX21, 0, , SZ_4K);
-#endif /* ifdef CONFIG_SOC_IMX21 */
-
-#ifdef CONFIG_SOC_IMX25
-const struct imx_mxc_pwm_data imx25_mxc_pwm_data[] __initconst = {
-#define imx25_mxc_pwm_data_entry(_id, _hwid)				\
-	imx_mxc_pwm_data_entry(MX25, _id, _hwid, SZ_16K)
-	imx25_mxc_pwm_data_entry(0, 1),
-	imx25_mxc_pwm_data_entry(1, 2),
-	imx25_mxc_pwm_data_entry(2, 3),
-	imx25_mxc_pwm_data_entry(3, 4),
-};
-#endif /* ifdef CONFIG_SOC_IMX25 */
-
-#ifdef CONFIG_SOC_IMX27
-const struct imx_mxc_pwm_data imx27_mxc_pwm_data __initconst =
-	imx_mxc_pwm_data_entry_single(MX27, 0, , SZ_4K);
-#endif /* ifdef CONFIG_SOC_IMX27 */
-
-#ifdef CONFIG_SOC_IMX51
-const struct imx_mxc_pwm_data imx51_mxc_pwm_data[] __initconst = {
-#define imx51_mxc_pwm_data_entry(_id, _hwid)				\
-	imx_mxc_pwm_data_entry(MX51, _id, _hwid, SZ_16K)
-	imx51_mxc_pwm_data_entry(0, 1),
-	imx51_mxc_pwm_data_entry(1, 2),
-};
-#endif /* ifdef CONFIG_SOC_IMX51 */
-
-struct platform_device *__init imx_add_mxc_pwm(
-		const struct imx_mxc_pwm_data *data)
-{
-	struct resource res[] = {
-		{
-			.start = data->iobase,
-			.end = data->iobase + data->iosize - 1,
-			.flags = IORESOURCE_MEM,
-		}, {
-			.start = data->irq,
-			.end = data->irq,
-			.flags = IORESOURCE_IRQ,
-		},
-	};
-
-	return imx_add_platform_device("mxc_pwm", data->id,
-			res, ARRAY_SIZE(res), NULL, 0);
-}
diff --git a/arch/arm/plat-mxc/include/mach/devices-common.h b/arch/arm/plat-mxc/include/mach/devices-common.h
index a7f5bb1..e8c5f84 100644
--- a/arch/arm/plat-mxc/include/mach/devices-common.h
+++ b/arch/arm/plat-mxc/include/mach/devices-common.h
@@ -271,15 +271,6 @@ struct imx_pata_imx_data {
 struct platform_device *__init imx_add_pata_imx(
 		const struct imx_pata_imx_data *data);
 
-struct imx_mxc_pwm_data {
-	int id;
-	resource_size_t iobase;
-	resource_size_t iosize;
-	resource_size_t irq;
-};
-struct platform_device *__init imx_add_mxc_pwm(
-		const struct imx_mxc_pwm_data *data);
-
 /* mxc_rtc */
 struct imx_mxc_rtc_data {
 	resource_size_t iobase;
-- 
1.7.10.4

