Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932552Ab2HHIKI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 04:10:08 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1606 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932369Ab2HHIHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 04:07:07 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 08 Aug 2012 01:06:54 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>, <w.sang@pengutronix.de>, <olof@lixom.net>,
        <khali@linux-fr.org>
CC: <ben-linux@fluff.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 4/4] ARM: tegra: clock: remove unused clock entry for i2c
Date: Wed, 8 Aug 2012 13:21:34 +0530
Message-ID: <1344412294-2420-5-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1344412294-2420-1-git-send-email-ldewangan@nvidia.com>
References: <1344412294-2420-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tegra20 clock table have the entry for clock (tegra_i2c.x, "i2c")
which is no more require as driver acquire clock with name of
"div-clk" and "fast-clk".
Remove these entries from table.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 arch/arm/mach-tegra/tegra20_clocks_data.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-tegra/tegra20_clocks_data.c b/arch/arm/mach-tegra/tegra20_clocks_data.c
index c1318c2..6516beb 100644
--- a/arch/arm/mach-tegra/tegra20_clocks_data.c
+++ b/arch/arm/mach-tegra/tegra20_clocks_data.c
@@ -893,10 +893,6 @@ PERIPH_CLK(i2c1,	"tegra-i2c.0",		"div-clk", 12,	0x124,	26000000,  mux_pllp_pllc_
 PERIPH_CLK(i2c2,	"tegra-i2c.1",		"div-clk", 54,	0x198,	26000000,  mux_pllp_pllc_pllm_clkm,	MUX | DIV_U16);
 PERIPH_CLK(i2c3,	"tegra-i2c.2",		"div-clk", 67,	0x1b8,	26000000,  mux_pllp_pllc_pllm_clkm,	MUX | DIV_U16);
 PERIPH_CLK(dvc,		"tegra-i2c.3",		"div-clk", 47,	0x128,	26000000,  mux_pllp_pllc_pllm_clkm,	MUX | DIV_U16);
-PERIPH_CLK(i2c1_i2c,	"tegra-i2c.0",		"i2c",	0,	0,	72000000,  mux_pllp_out3,			0);
-PERIPH_CLK(i2c2_i2c,	"tegra-i2c.1",		"i2c",	0,	0,	72000000,  mux_pllp_out3,			0);
-PERIPH_CLK(i2c3_i2c,	"tegra-i2c.2",		"i2c",	0,	0,	72000000,  mux_pllp_out3,			0);
-PERIPH_CLK(dvc_i2c,	"tegra-i2c.3",		"i2c",	0,	0,	72000000,  mux_pllp_out3,			0);
 PERIPH_CLK(uarta,	"tegra-uart.0",		NULL,	6,	0x178,	600000000, mux_pllp_pllc_pllm_clkm,	MUX);
 PERIPH_CLK(uartb,	"tegra-uart.1",		NULL,	7,	0x17c,	600000000, mux_pllp_pllc_pllm_clkm,	MUX);
 PERIPH_CLK(uartc,	"tegra-uart.2",		NULL,	55,	0x1a0,	600000000, mux_pllp_pllc_pllm_clkm,	MUX);
@@ -962,10 +958,6 @@ static struct clk *tegra_list_clks[] = {
 	&tegra_i2c2,
 	&tegra_i2c3,
 	&tegra_dvc,
-	&tegra_i2c1_i2c,
-	&tegra_i2c2_i2c,
-	&tegra_i2c3_i2c,
-	&tegra_dvc_i2c,
 	&tegra_uarta,
 	&tegra_uartb,
 	&tegra_uartc,
-- 
1.7.1.1

