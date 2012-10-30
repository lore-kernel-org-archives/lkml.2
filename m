Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360Ab2J3HHO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 03:07:14 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6493 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754532Ab2J3HHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 03:07:12 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 30 Oct 2012 00:07:09 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>, <linux@arm.linux.org.uk>
CC: <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V3 2/4] ARM: tegra: Add OF_DEV_AUXDATA for SLINK driver in board dt
Date: Tue, 30 Oct 2012 12:35:24 +0530
Message-ID: <1351580726-17350-3-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1351580726-17350-1-git-send-email-ldewangan@nvidia.com>
References: <1351580726-17350-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add OF_DEV_AUXDATA for slink driver for Tegra20 and Tegra30
board dt files.
Set the parent clock of slink controller to PLLP and configure
clock to 100MHz.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes from V1:
- Revert the changes in clock table to get the driver name.

Changes from V2:
- Get rid of the iomap.h

 arch/arm/mach-tegra/board-dt-tegra20.c |    8 ++++++++
 arch/arm/mach-tegra/board-dt-tegra30.c |   12 ++++++++++++
 2 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-tegra/board-dt-tegra20.c b/arch/arm/mach-tegra/board-dt-tegra20.c
index 2053f74..5a19589 100644
--- a/arch/arm/mach-tegra/board-dt-tegra20.c
+++ b/arch/arm/mach-tegra/board-dt-tegra20.c
@@ -90,6 +90,10 @@ struct of_dev_auxdata tegra20_auxdata_lookup[] __initdata = {
 		       &tegra_ehci3_pdata),
 	OF_DEV_AUXDATA("nvidia,tegra20-apbdma", TEGRA_APB_DMA_BASE, "tegra-apbdma", NULL),
 	OF_DEV_AUXDATA("nvidia,tegra20-pwm", TEGRA_PWFM_BASE, "tegra-pwm", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-slink", 0x7000D400, "spi_tegra.0", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-slink", 0x7000D600, "spi_tegra.1", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-slink", 0x7000D800, "spi_tegra.2", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-slink", 0x7000DA00, "spi_tegra.3", NULL),
 	{}
 };
 
@@ -109,6 +113,10 @@ static __initdata struct tegra_clk_init_table tegra_dt_clk_init_table[] = {
 	{ "sdmmc1",	"pll_p",	48000000,	false},
 	{ "sdmmc3",	"pll_p",	48000000,	false},
 	{ "sdmmc4",	"pll_p",	48000000,	false},
+	{ "sbc1",	"pll_p",	100000000,	false },
+	{ "sbc2",	"pll_p",	100000000,	false },
+	{ "sbc3",	"pll_p",	100000000,	false },
+	{ "sbc4",	"pll_p",	100000000,	false },
 	{ NULL,		NULL,		0,		0},
 };
 
diff --git a/arch/arm/mach-tegra/board-dt-tegra30.c b/arch/arm/mach-tegra/board-dt-tegra30.c
index 9e6f79a..b26cfef 100644
--- a/arch/arm/mach-tegra/board-dt-tegra30.c
+++ b/arch/arm/mach-tegra/board-dt-tegra30.c
@@ -52,6 +52,12 @@ struct of_dev_auxdata tegra30_auxdata_lookup[] __initdata = {
 	OF_DEV_AUXDATA("nvidia,tegra30-ahub", 0x70080000, "tegra30-ahub", NULL),
 	OF_DEV_AUXDATA("nvidia,tegra30-apbdma", 0x6000a000, "tegra-apbdma", NULL),
 	OF_DEV_AUXDATA("nvidia,tegra30-pwm", TEGRA_PWFM_BASE, "tegra-pwm", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra30-slink", 0x7000D400, "spi_tegra.0", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra30-slink", 0x7000D600, "spi_tegra.1", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra30-slink", 0x7000D800, "spi_tegra.2", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra30-slink", 0x7000DA00, "spi_tegra.3", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra30-slink", 0x7000DC00, "spi_tegra.4", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra30-slink", 0x7000DE00, "spi_tegra.5", NULL),
 	{}
 };
 
@@ -71,6 +77,12 @@ static __initdata struct tegra_clk_init_table tegra_dt_clk_init_table[] = {
 	{ "sdmmc1",	"pll_p",	48000000,	false},
 	{ "sdmmc3",	"pll_p",	48000000,	false},
 	{ "sdmmc4",	"pll_p",	48000000,	false},
+	{ "sbc1",	"pll_p",	100000000,	false},
+	{ "sbc2",	"pll_p",	100000000,	false},
+	{ "sbc3",	"pll_p",	100000000,	false},
+	{ "sbc4",	"pll_p",	100000000,	false},
+	{ "sbc5",	"pll_p",	100000000,	false},
+	{ "sbc6",	"pll_p",	100000000,	false},
 	{ NULL,		NULL,		0,		0},
 };
 
-- 
1.7.1.1

