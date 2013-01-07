Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab3AGB5H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 20:57:07 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:39162 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302Ab3AGB5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 20:57:01 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, nicolas.ferre@atmel.com,
        plagnioj@jcrosoft.com, richard.genoud@gmail.com, JM.Lin@atmel.com,
        wenyou.yang@atmel.com, linux@arm.linux.org.uk, linux@maxim.org.za
Subject: [v3 PATCH 10/12] ARM: at91: add clocks for spi dt entries
Date: Mon,  7 Jan 2013 09:50:11 +0800
Message-Id: <1357523413-27209-11-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357523413-27209-1-git-send-email-wenyou.yang@atmel.com>
References: <1357523413-27209-1-git-send-email-wenyou.yang@atmel.com>
X-OriginalArrivalTime: 07 Jan 2013 01:56:43.0959 (UTC) FILETIME=[3E55D470:01CDEC7A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Genoud <richard.genoud@gmail.com>

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
[<wenyou.yang@atmel.com: declare the spi clocks for sam9260, at91sam9g45, and at91sam9n12]
Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
Cc: linux@arm.linux.org.uk
Cc: plagnioj@jcrosoft.com
Cc: linux@maxim.org.za
---
 arch/arm/mach-at91/at91sam9260.c |    2 ++
 arch/arm/mach-at91/at91sam9g45.c |    2 ++
 arch/arm/mach-at91/at91sam9n12.c |    2 ++
 arch/arm/mach-at91/at91sam9x5.c  |    2 ++
 4 files changed, 8 insertions(+)

diff --git a/arch/arm/mach-at91/at91sam9260.c b/arch/arm/mach-at91/at91sam9260.c
index b67cd53..44199bc 100644
--- a/arch/arm/mach-at91/at91sam9260.c
+++ b/arch/arm/mach-at91/at91sam9260.c
@@ -232,6 +232,8 @@ static struct clk_lookup periph_clocks_lookups[] = {
 	CLKDEV_CON_DEV_ID("t2_clk", "fffdc000.timer", &tc5_clk),
 	CLKDEV_CON_DEV_ID("hclk", "500000.ohci", &ohci_clk),
 	CLKDEV_CON_DEV_ID("mci_clk", "fffa8000.mmc", &mmc_clk),
+	CLKDEV_CON_DEV_ID("spi_clk", "fffc8000.spi", &spi0_clk),
+	CLKDEV_CON_DEV_ID("spi_clk", "fffcc000.spi", &spi1_clk),
 	/* fake hclk clock */
 	CLKDEV_CON_DEV_ID("hclk", "at91_ohci", &ohci_clk),
 	CLKDEV_CON_ID("pioA", &pioA_clk),
diff --git a/arch/arm/mach-at91/at91sam9g45.c b/arch/arm/mach-at91/at91sam9g45.c
index d3addee..2ec5efe 100644
--- a/arch/arm/mach-at91/at91sam9g45.c
+++ b/arch/arm/mach-at91/at91sam9g45.c
@@ -262,6 +262,8 @@ static struct clk_lookup periph_clocks_lookups[] = {
 	CLKDEV_CON_DEV_ID("mci_clk", "fffd0000.mmc", &mmc1_clk),
 	CLKDEV_CON_DEV_ID(NULL, "fff84000.i2c", &twi0_clk),
 	CLKDEV_CON_DEV_ID(NULL, "fff88000.i2c", &twi1_clk),
+	CLKDEV_CON_DEV_ID("spi_clk", "fffa4000.spi", &spi0_clk),
+	CLKDEV_CON_DEV_ID("spi_clk", "fffa8000.spi", &spi1_clk),
 	/* fake hclk clock */
 	CLKDEV_CON_DEV_ID("hclk", "at91_ohci", &uhphs_clk),
 	CLKDEV_CON_DEV_ID(NULL, "fffff200.gpio", &pioA_clk),
diff --git a/arch/arm/mach-at91/at91sam9n12.c b/arch/arm/mach-at91/at91sam9n12.c
index 5dfc8fd..ccd0783 100644
--- a/arch/arm/mach-at91/at91sam9n12.c
+++ b/arch/arm/mach-at91/at91sam9n12.c
@@ -172,6 +172,8 @@ static struct clk_lookup periph_clocks_lookups[] = {
 	CLKDEV_CON_DEV_ID("dma_clk", "ffffec00.dma-controller", &dma_clk),
 	CLKDEV_CON_DEV_ID(NULL, "f8010000.i2c", &twi0_clk),
 	CLKDEV_CON_DEV_ID(NULL, "f8014000.i2c", &twi1_clk),
+	CLKDEV_CON_DEV_ID("spi_clk", "f0000000.spi", &spi0_clk),
+	CLKDEV_CON_DEV_ID("spi_clk", "f0004000.spi", &spi1_clk),
 	CLKDEV_CON_DEV_ID(NULL, "fffff400.gpio", &pioAB_clk),
 	CLKDEV_CON_DEV_ID(NULL, "fffff600.gpio", &pioAB_clk),
 	CLKDEV_CON_DEV_ID(NULL, "fffff800.gpio", &pioCD_clk),
diff --git a/arch/arm/mach-at91/at91sam9x5.c b/arch/arm/mach-at91/at91sam9x5.c
index 44a9a62..a200d8a 100644
--- a/arch/arm/mach-at91/at91sam9x5.c
+++ b/arch/arm/mach-at91/at91sam9x5.c
@@ -237,6 +237,8 @@ static struct clk_lookup periph_clocks_lookups[] = {
 	CLKDEV_CON_DEV_ID(NULL, "f8010000.i2c", &twi0_clk),
 	CLKDEV_CON_DEV_ID(NULL, "f8014000.i2c", &twi1_clk),
 	CLKDEV_CON_DEV_ID(NULL, "f8018000.i2c", &twi2_clk),
+	CLKDEV_CON_DEV_ID("spi_clk", "f0000000.spi", &spi0_clk),
+	CLKDEV_CON_DEV_ID("spi_clk", "f0004000.spi", &spi1_clk),
 	CLKDEV_CON_DEV_ID(NULL, "fffff400.gpio", &pioAB_clk),
 	CLKDEV_CON_DEV_ID(NULL, "fffff600.gpio", &pioAB_clk),
 	CLKDEV_CON_DEV_ID(NULL, "fffff800.gpio", &pioCD_clk),
-- 
1.7.9.5

