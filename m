Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452Ab2LQMJH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 07:09:07 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4906 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298Ab2LQMJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 07:09:04 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 17 Dec 2012 04:06:27 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 3/4] ARM: tegra: Add OF_DEV_AUXDATA for uart driver in board dt
Date: Mon, 17 Dec 2012 17:38:20 +0530
Message-ID: <1355746101-15291-4-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1355746101-15291-1-git-send-email-ldewangan@nvidia.com>
References: <1355746101-15291-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add OF_DEV_AUXDATA for high speed uart controller driver for
Tegra20/Tegra30 board dt files.
Set the parent clock of uart controller to PLLP.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 arch/arm/mach-tegra/board-dt-tegra20.c |    8 ++++++++
 arch/arm/mach-tegra/board-dt-tegra30.c |    9 +++++++++
 2 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-tegra/board-dt-tegra20.c b/arch/arm/mach-tegra/board-dt-tegra20.c
index 734d9cc..959c8b3 100644
--- a/arch/arm/mach-tegra/board-dt-tegra20.c
+++ b/arch/arm/mach-tegra/board-dt-tegra20.c
@@ -94,6 +94,11 @@ struct of_dev_auxdata tegra20_auxdata_lookup[] __initdata = {
 	OF_DEV_AUXDATA("nvidia,tegra20-slink", 0x7000D600, "spi_tegra.1", NULL),
 	OF_DEV_AUXDATA("nvidia,tegra20-slink", 0x7000D800, "spi_tegra.2", NULL),
 	OF_DEV_AUXDATA("nvidia,tegra20-slink", 0x7000DA00, "spi_tegra.3", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-hsuart", 0x70006000, "tegra-uart.0", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-hsuart", 0x70006040, "tegra-uart.1", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-hsuart", 0x70006200, "tegra-uart.2", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-hsuart", 0x70006300, "tegra-uart.3", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-hsuart", 0x70006400, "tegra-uart.4", NULL),
 	OF_DEV_AUXDATA("nvidia,tegra20-host1x", 0x50000000, "host1x", NULL),
 	OF_DEV_AUXDATA("nvidia,tegra20-dc", 0x54200000, "tegradc.0", NULL),
 	OF_DEV_AUXDATA("nvidia,tegra20-dc", 0x54240000, "tegradc.1", NULL),
@@ -106,7 +111,10 @@ struct of_dev_auxdata tegra20_auxdata_lookup[] __initdata = {
 static __initdata struct tegra_clk_init_table tegra_dt_clk_init_table[] = {
 	/* name		parent		rate		enabled */
 	{ "uarta",	"pll_p",	216000000,	true },
+	{ "uartb",	"pll_p",	216000000,	false },
+	{ "uartc",	"pll_p",	216000000,	false },
 	{ "uartd",	"pll_p",	216000000,	true },
+	{ "uarte",	"pll_p",	216000000,	false },
 	{ "usbd",	"clk_m",	12000000,	false },
 	{ "usb2",	"clk_m",	12000000,	false },
 	{ "usb3",	"clk_m",	12000000,	false },
diff --git a/arch/arm/mach-tegra/board-dt-tegra30.c b/arch/arm/mach-tegra/board-dt-tegra30.c
index 6497d12..f430351 100644
--- a/arch/arm/mach-tegra/board-dt-tegra30.c
+++ b/arch/arm/mach-tegra/board-dt-tegra30.c
@@ -57,6 +57,11 @@ struct of_dev_auxdata tegra30_auxdata_lookup[] __initdata = {
 	OF_DEV_AUXDATA("nvidia,tegra30-slink", 0x7000DA00, "spi_tegra.3", NULL),
 	OF_DEV_AUXDATA("nvidia,tegra30-slink", 0x7000DC00, "spi_tegra.4", NULL),
 	OF_DEV_AUXDATA("nvidia,tegra30-slink", 0x7000DE00, "spi_tegra.5", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra30-hsuart", 0x70006000, "tegra-uart.0", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra30-hsuart", 0x70006040, "tegra-uart.1", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra30-hsuart", 0x70006200, "tegra-uart.2", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra30-hsuart", 0x70006300, "tegra-uart.3", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra30-hsuart", 0x70006400, "tegra-uart.4", NULL),
 	OF_DEV_AUXDATA("nvidia,tegra30-host1x", 0x50000000, "host1x", NULL),
 	OF_DEV_AUXDATA("nvidia,tegra30-dc", 0x54200000, "tegradc.0", NULL),
 	OF_DEV_AUXDATA("nvidia,tegra30-dc", 0x54240000, "tegradc.1", NULL),
@@ -69,6 +74,10 @@ struct of_dev_auxdata tegra30_auxdata_lookup[] __initdata = {
 static __initdata struct tegra_clk_init_table tegra_dt_clk_init_table[] = {
 	/* name		parent		rate		enabled */
 	{ "uarta",	"pll_p",	408000000,	true },
+	{ "uartb",	"pll_p",	408000000,	false },
+	{ "uartc",	"pll_p",	408000000,	false },
+	{ "uartd",	"pll_p",	408000000,	false },
+	{ "uarte",	"pll_p",	408000000,	false },
 	{ "pll_a",	"pll_p_out1",	564480000,	true },
 	{ "pll_a_out0",	"pll_a",	11289600,	true },
 	{ "extern1",	"pll_a_out0",	0,		true },
-- 
1.7.1.1

