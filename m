Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab2KMFGn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 00:06:43 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6462 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971Ab2KMFGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 00:06:41 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 12 Nov 2012 21:06:34 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <linux@arm.linux.org.uk>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 2/3] ARM: tegra: Add OF_DEV_AUXDATA for sflash driver in board dt
Date: Tue, 13 Nov 2012 10:33:40 +0530
Message-ID: <1352783021-25393-3-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1352783021-25393-1-git-send-email-ldewangan@nvidia.com>
References: <1352783021-25393-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add OF_DEV_AUXDATA for sflash controller driver for Tegra20
board dt files.
Set the parent clock of sflash controller to PLLP and configure
clock to 20MHz.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 arch/arm/mach-tegra/board-dt-tegra20.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-tegra/board-dt-tegra20.c b/arch/arm/mach-tegra/board-dt-tegra20.c
index 22f5a9b..1198e84 100644
--- a/arch/arm/mach-tegra/board-dt-tegra20.c
+++ b/arch/arm/mach-tegra/board-dt-tegra20.c
@@ -89,6 +89,7 @@ struct of_dev_auxdata tegra20_auxdata_lookup[] __initdata = {
 		       &tegra_ehci3_pdata),
 	OF_DEV_AUXDATA("nvidia,tegra20-apbdma", TEGRA_APB_DMA_BASE, "tegra-apbdma", NULL),
 	OF_DEV_AUXDATA("nvidia,tegra20-pwm", TEGRA_PWFM_BASE, "tegra-pwm", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-sflash", 0x7000c380, "spi", NULL),
 	OF_DEV_AUXDATA("nvidia,tegra20-slink", 0x7000D400, "spi_tegra.0", NULL),
 	OF_DEV_AUXDATA("nvidia,tegra20-slink", 0x7000D600, "spi_tegra.1", NULL),
 	OF_DEV_AUXDATA("nvidia,tegra20-slink", 0x7000D800, "spi_tegra.2", NULL),
@@ -112,6 +113,7 @@ static __initdata struct tegra_clk_init_table tegra_dt_clk_init_table[] = {
 	{ "sdmmc1",	"pll_p",	48000000,	false},
 	{ "sdmmc3",	"pll_p",	48000000,	false},
 	{ "sdmmc4",	"pll_p",	48000000,	false},
+	{ "spi",	"pll_p",	20000000,	false },
 	{ "sbc1",	"pll_p",	100000000,	false },
 	{ "sbc2",	"pll_p",	100000000,	false },
 	{ "sbc3",	"pll_p",	100000000,	false },
-- 
1.7.1.1

