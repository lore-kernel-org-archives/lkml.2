Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932573Ab2JRK6Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 06:58:24 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19623 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932358Ab2JRK5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 06:57:44 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 18 Oct 2012 03:46:00 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>, <linux@arm.linux.org.uk>
CC: <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 3/5] ARM: tegra: fix clock entry of slink controller
Date: Thu, 18 Oct 2012 16:26:33 +0530
Message-ID: <1350557795-31487-4-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1350557795-31487-1-git-send-email-ldewangan@nvidia.com>
References: <1350557795-31487-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the driver name, connection name and clock name
for slink controller clocks in clock table of
Tegra20 and Tegra30.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 arch/arm/mach-tegra/board-dt-tegra20.c    |    8 ++++++
 arch/arm/mach-tegra/board-dt-tegra30.c    |   12 +++++++++
 arch/arm/mach-tegra/tegra20_clocks_data.c |   16 ++++++------
 arch/arm/mach-tegra/tegra30_clocks_data.c |   36 ++++++++++++++--------------
 4 files changed, 46 insertions(+), 26 deletions(-)

diff --git a/arch/arm/mach-tegra/board-dt-tegra20.c b/arch/arm/mach-tegra/board-dt-tegra20.c
index 2053f74..2d6915e 100644
--- a/arch/arm/mach-tegra/board-dt-tegra20.c
+++ b/arch/arm/mach-tegra/board-dt-tegra20.c
@@ -90,6 +90,10 @@ struct of_dev_auxdata tegra20_auxdata_lookup[] __initdata = {
 		       &tegra_ehci3_pdata),
 	OF_DEV_AUXDATA("nvidia,tegra20-apbdma", TEGRA_APB_DMA_BASE, "tegra-apbdma", NULL),
 	OF_DEV_AUXDATA("nvidia,tegra20-pwm", TEGRA_PWFM_BASE, "tegra-pwm", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-slink", TEGRA_SLINK1_BASE, "spi-tegra-slink.0", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-slink", TEGRA_SLINK2_BASE, "spi-tegra-slink.1", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-slink", TEGRA_SLINK3_BASE, "spi-tegra-slink.2", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-slink", TEGRA_SLINK4_BASE, "spi-tegra-slink.3", NULL),
 	{}
 };
 
@@ -109,6 +113,10 @@ static __initdata struct tegra_clk_init_table tegra_dt_clk_init_table[] = {
 	{ "sdmmc1",	"pll_p",	48000000,	false},
 	{ "sdmmc3",	"pll_p",	48000000,	false},
 	{ "sdmmc4",	"pll_p",	48000000,	false},
+	{ "slink1",	"pll_p",	100000000,	false },
+	{ "slink2",	"pll_p",	100000000,	false },
+	{ "slink3",	"pll_p",	100000000,	false },
+	{ "slink4",	"pll_p",	100000000,	false },
 	{ NULL,		NULL,		0,		0},
 };
 
diff --git a/arch/arm/mach-tegra/board-dt-tegra30.c b/arch/arm/mach-tegra/board-dt-tegra30.c
index 9e6f79a..cf2defd 100644
--- a/arch/arm/mach-tegra/board-dt-tegra30.c
+++ b/arch/arm/mach-tegra/board-dt-tegra30.c
@@ -52,6 +52,12 @@ struct of_dev_auxdata tegra30_auxdata_lookup[] __initdata = {
 	OF_DEV_AUXDATA("nvidia,tegra30-ahub", 0x70080000, "tegra30-ahub", NULL),
 	OF_DEV_AUXDATA("nvidia,tegra30-apbdma", 0x6000a000, "tegra-apbdma", NULL),
 	OF_DEV_AUXDATA("nvidia,tegra30-pwm", TEGRA_PWFM_BASE, "tegra-pwm", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra30-slink", TEGRA_SLINK1_BASE, "spi-tegra-slink.0", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra30-slink", TEGRA_SLINK2_BASE, "spi-tegra-slink.1", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra30-slink", TEGRA_SLINK3_BASE, "spi-tegra-slink.2", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra30-slink", TEGRA_SLINK4_BASE, "spi-tegra-slink.3", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra30-slink", TEGRA_SLINK5_BASE, "spi-tegra-slink.4", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra30-slink", TEGRA_SLINK6_BASE, "spi-tegra-slink.5", NULL),
 	{}
 };
 
@@ -71,6 +77,12 @@ static __initdata struct tegra_clk_init_table tegra_dt_clk_init_table[] = {
 	{ "sdmmc1",	"pll_p",	48000000,	false},
 	{ "sdmmc3",	"pll_p",	48000000,	false},
 	{ "sdmmc4",	"pll_p",	48000000,	false},
+	{ "slink1",	"pll_p",	100000000,	false},
+	{ "slink2",	"pll_p",	100000000,	false},
+	{ "slink3",	"pll_p",	100000000,	false},
+	{ "slink4",	"pll_p",	100000000,	false},
+	{ "slink5",	"pll_p",	100000000,	false},
+	{ "slink6",	"pll_p",	100000000,	false},
 	{ NULL,		NULL,		0,		0},
 };
 
diff --git a/arch/arm/mach-tegra/tegra20_clocks_data.c b/arch/arm/mach-tegra/tegra20_clocks_data.c
index 9615ee3..b23c99f 100644
--- a/arch/arm/mach-tegra/tegra20_clocks_data.c
+++ b/arch/arm/mach-tegra/tegra20_clocks_data.c
@@ -894,10 +894,10 @@ PERIPH_CLK(pwm,		"tegra-pwm",		NULL,	17,	0x110,	432000000, mux_pllp_pllc_audio_c
 PERIPH_CLK(spi,		"spi",			NULL,	43,	0x114,	40000000,  mux_pllp_pllc_pllm_clkm,	MUX | DIV_U71);
 PERIPH_CLK(xio,		"xio",			NULL,	45,	0x120,	150000000, mux_pllp_pllc_pllm_clkm,	MUX | DIV_U71);
 PERIPH_CLK(twc,		"twc",			NULL,	16,	0x12c,	150000000, mux_pllp_pllc_pllm_clkm,	MUX | DIV_U71);
-PERIPH_CLK(sbc1,	"spi_tegra.0",		NULL,	41,	0x134,	160000000, mux_pllp_pllc_pllm_clkm,	MUX | DIV_U71);
-PERIPH_CLK(sbc2,	"spi_tegra.1",		NULL,	44,	0x118,	160000000, mux_pllp_pllc_pllm_clkm,	MUX | DIV_U71);
-PERIPH_CLK(sbc3,	"spi_tegra.2",		NULL,	46,	0x11c,	160000000, mux_pllp_pllc_pllm_clkm,	MUX | DIV_U71);
-PERIPH_CLK(sbc4,	"spi_tegra.3",		NULL,	68,	0x1b4,	160000000, mux_pllp_pllc_pllm_clkm,	MUX | DIV_U71);
+PERIPH_CLK(slink1,	"spi-tegra-slink.0",	"slink",	41,	0x134,	160000000, mux_pllp_pllc_pllm_clkm,	MUX | DIV_U71);
+PERIPH_CLK(slink2,	"spi-tegra-slink.1",	"slink",	44,	0x118,	160000000, mux_pllp_pllc_pllm_clkm,	MUX | DIV_U71);
+PERIPH_CLK(slink3,	"spi-tegra-slink.2",	"slink",	46,	0x11c,	160000000, mux_pllp_pllc_pllm_clkm,	MUX | DIV_U71);
+PERIPH_CLK(slink4,	"spi-tegra-slink.3",	"slink",	68,	0x1b4,	160000000, mux_pllp_pllc_pllm_clkm,	MUX | DIV_U71);
 PERIPH_CLK(ide,		"ide",			NULL,	25,	0x144,	100000000, mux_pllp_pllc_pllm_clkm,	MUX | DIV_U71); /* requires min voltage */
 PERIPH_CLK(ndflash,	"tegra_nand",		NULL,	13,	0x160,	164000000, mux_pllp_pllc_pllm_clkm,	MUX | DIV_U71); /* scales with voltage */
 PERIPH_CLK(vfir,	"vfir",			NULL,	7,	0x168,	72000000,  mux_pllp_pllc_pllm_clkm,	MUX | DIV_U71);
@@ -960,10 +960,10 @@ static struct clk *tegra_list_clks[] = {
 	&tegra_spi,
 	&tegra_xio,
 	&tegra_twc,
-	&tegra_sbc1,
-	&tegra_sbc2,
-	&tegra_sbc3,
-	&tegra_sbc4,
+	&tegra_slink1,
+	&tegra_slink2,
+	&tegra_slink3,
+	&tegra_slink4,
 	&tegra_ide,
 	&tegra_ndflash,
 	&tegra_vfir,
diff --git a/arch/arm/mach-tegra/tegra30_clocks_data.c b/arch/arm/mach-tegra/tegra30_clocks_data.c
index 3d2e553..8fe2da8 100644
--- a/arch/arm/mach-tegra/tegra30_clocks_data.c
+++ b/arch/arm/mach-tegra/tegra30_clocks_data.c
@@ -1046,12 +1046,12 @@ PERIPH_CLK(dam2,	"tegra30-dam.2",	NULL,	110,	0x3e0,	48000000,  mux_plla_pllc_pll
 PERIPH_CLK(hda,		"tegra30-hda",		"hda",	125,	0x428,	108000000, mux_pllp_pllc_pllm_clkm,	MUX | DIV_U71);
 PERIPH_CLK(hda2codec_2x,	"tegra30-hda",	"hda2codec",	111,	0x3e4,	48000000,  mux_pllp_pllc_pllm_clkm,	MUX | DIV_U71);
 PERIPH_CLK(hda2hdmi,	"tegra30-hda",		"hda2hdmi",	128,	0,	48000000,  mux_clk_m,			0);
-PERIPH_CLK(sbc1,	"spi_tegra.0",		NULL,	41,	0x134,	160000000, mux_pllp_pllc_pllm_clkm,	MUX | DIV_U71 | PERIPH_ON_APB);
-PERIPH_CLK(sbc2,	"spi_tegra.1",		NULL,	44,	0x118,	160000000, mux_pllp_pllc_pllm_clkm,	MUX | DIV_U71 | PERIPH_ON_APB);
-PERIPH_CLK(sbc3,	"spi_tegra.2",		NULL,	46,	0x11c,	160000000, mux_pllp_pllc_pllm_clkm,	MUX | DIV_U71 | PERIPH_ON_APB);
-PERIPH_CLK(sbc4,	"spi_tegra.3",		NULL,	68,	0x1b4,	160000000, mux_pllp_pllc_pllm_clkm,	MUX | DIV_U71 | PERIPH_ON_APB);
-PERIPH_CLK(sbc5,	"spi_tegra.4",		NULL,	104,	0x3c8,	160000000, mux_pllp_pllc_pllm_clkm,	MUX | DIV_U71 | PERIPH_ON_APB);
-PERIPH_CLK(sbc6,	"spi_tegra.5",		NULL,	105,	0x3cc,	160000000, mux_pllp_pllc_pllm_clkm,	MUX | DIV_U71 | PERIPH_ON_APB);
+PERIPH_CLK(slink1,	"spi-tegra-slink.0",	"slink",	41,	0x134,	160000000, mux_pllp_pllc_pllm_clkm,	MUX | DIV_U71 | PERIPH_ON_APB);
+PERIPH_CLK(slink2,	"spi-tegra-slink.1",	"slink",	44,	0x118,	160000000, mux_pllp_pllc_pllm_clkm,	MUX | DIV_U71 | PERIPH_ON_APB);
+PERIPH_CLK(slink3,	"spi-tegra-slink.2",	"slink",	46,	0x11c,	160000000, mux_pllp_pllc_pllm_clkm,	MUX | DIV_U71 | PERIPH_ON_APB);
+PERIPH_CLK(slink4,	"spi-tegra-slink.3",	"slink",	68,	0x1b4,	160000000, mux_pllp_pllc_pllm_clkm,	MUX | DIV_U71 | PERIPH_ON_APB);
+PERIPH_CLK(slink5,	"spi-tegra-slink.4",	"slink",	104,	0x3c8,	160000000, mux_pllp_pllc_pllm_clkm,	MUX | DIV_U71 | PERIPH_ON_APB);
+PERIPH_CLK(slink6,	"spi-tegra-slink.5",	"slink",	105,	0x3cc,	160000000, mux_pllp_pllc_pllm_clkm,	MUX | DIV_U71 | PERIPH_ON_APB);
 PERIPH_CLK(sata_oob,	"tegra_sata_oob",	NULL,	123,	0x420,	216000000, mux_pllp_pllc_pllm_clkm,	MUX | DIV_U71);
 PERIPH_CLK(sata,	"tegra_sata",		NULL,	124,	0x424,	216000000, mux_pllp_pllc_pllm_clkm,	MUX | DIV_U71);
 PERIPH_CLK(sata_cold,	"tegra_sata_cold",	NULL,	129,	0,	48000000,  mux_clk_m,			0);
@@ -1163,12 +1163,12 @@ struct clk *tegra_list_clks[] = {
 	&tegra_hda,
 	&tegra_hda2codec_2x,
 	&tegra_hda2hdmi,
-	&tegra_sbc1,
-	&tegra_sbc2,
-	&tegra_sbc3,
-	&tegra_sbc4,
-	&tegra_sbc5,
-	&tegra_sbc6,
+	&tegra_slink1,
+	&tegra_slink2,
+	&tegra_slink3,
+	&tegra_slink4,
+	&tegra_slink5,
+	&tegra_slink6,
 	&tegra_sata_oob,
 	&tegra_sata,
 	&tegra_sata_cold,
@@ -1271,12 +1271,12 @@ struct clk_duplicate tegra_clk_duplicates[] = {
 	CLK_DUPLICATE("i2c3", "tegra-i2c-slave.2", NULL),
 	CLK_DUPLICATE("i2c4", "tegra-i2c-slave.3", NULL),
 	CLK_DUPLICATE("i2c5", "tegra-i2c-slave.4", NULL),
-	CLK_DUPLICATE("sbc1", "spi_slave_tegra.0", NULL),
-	CLK_DUPLICATE("sbc2", "spi_slave_tegra.1", NULL),
-	CLK_DUPLICATE("sbc3", "spi_slave_tegra.2", NULL),
-	CLK_DUPLICATE("sbc4", "spi_slave_tegra.3", NULL),
-	CLK_DUPLICATE("sbc5", "spi_slave_tegra.4", NULL),
-	CLK_DUPLICATE("sbc6", "spi_slave_tegra.5", NULL),
+	CLK_DUPLICATE("slink1", "spi_slave_tegra.0", NULL),
+	CLK_DUPLICATE("slink2", "spi_slave_tegra.1", NULL),
+	CLK_DUPLICATE("slink3", "spi_slave_tegra.2", NULL),
+	CLK_DUPLICATE("slink4", "spi_slave_tegra.3", NULL),
+	CLK_DUPLICATE("slink5", "spi_slave_tegra.4", NULL),
+	CLK_DUPLICATE("slink6", "spi_slave_tegra.5", NULL),
 	CLK_DUPLICATE("twd", "smp_twd", NULL),
 	CLK_DUPLICATE("vcp", "nvavp", "vcp"),
 	CLK_DUPLICATE("i2s0", NULL, "i2s0"),
-- 
1.7.1.1

