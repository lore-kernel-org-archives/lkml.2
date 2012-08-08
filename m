Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932452Ab2HHIHk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 04:07:40 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1625 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932382Ab2HHIHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 04:07:23 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 08 Aug 2012 01:06:44 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>, <w.sang@pengutronix.de>, <olof@lixom.net>,
        <khali@linux-fr.org>
CC: <ben-linux@fluff.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 1/4] ARM: tegra: clock: add i2c fast clock entry in clock table
Date: Wed, 8 Aug 2012 13:21:31 +0530
Message-ID: <1344412294-2420-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1344412294-2420-1-git-send-email-ldewangan@nvidia.com>
References: <1344412294-2420-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tegra's i2c controller require two clock sources named as
div-clk and fast-clk for proper operation.
Currently, the entry of fast-clk is missing in tegra30
clock table and it is incorrectly named in the tegra20
clock table.
Adds aliases to enable lookups for "fast-clk" to succeed.
A later patch will remove the incorrectly named clock,
once the driver is modified to use the new name.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 arch/arm/mach-tegra/tegra20_clocks_data.c |    4 ++++
 arch/arm/mach-tegra/tegra30_clocks_data.c |    5 +++++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-tegra/tegra20_clocks_data.c b/arch/arm/mach-tegra/tegra20_clocks_data.c
index b5c518e..7312ecd 100644
--- a/arch/arm/mach-tegra/tegra20_clocks_data.c
+++ b/arch/arm/mach-tegra/tegra20_clocks_data.c
@@ -1028,6 +1028,10 @@ static struct clk_duplicate tegra_clk_duplicates[] = {
 	CLK_DUPLICATE("cop",	"tegra-avp",	"cop"),
 	CLK_DUPLICATE("vde",	"tegra-aes",	"vde"),
 	CLK_DUPLICATE("cclk",	NULL,		"cpu"),
+	CLK_DUPLICATE("pll_p_out3", "tegra-i2c.0", "fast-clk"),
+	CLK_DUPLICATE("pll_p_out3", "tegra-i2c.1", "fast-clk"),
+	CLK_DUPLICATE("pll_p_out3", "tegra-i2c.2", "fast-clk"),
+	CLK_DUPLICATE("pll_p_out3", "tegra-i2c.3", "fast-clk"),
 };
 
 #define CLK(dev, con, ck)	\
diff --git a/arch/arm/mach-tegra/tegra30_clocks_data.c b/arch/arm/mach-tegra/tegra30_clocks_data.c
index c924240..eae85b7 100644
--- a/arch/arm/mach-tegra/tegra30_clocks_data.c
+++ b/arch/arm/mach-tegra/tegra30_clocks_data.c
@@ -1287,6 +1287,11 @@ struct clk_duplicate tegra_clk_duplicates[] = {
 	CLK_DUPLICATE("dam1", NULL, "dam1"),
 	CLK_DUPLICATE("dam2", NULL, "dam2"),
 	CLK_DUPLICATE("spdif_in", NULL, "spdif_in"),
+	CLK_DUPLICATE("pll_p_out3", "tegra-i2c.0", "fast-clk"),
+	CLK_DUPLICATE("pll_p_out3", "tegra-i2c.1", "fast-clk"),
+	CLK_DUPLICATE("pll_p_out3", "tegra-i2c.2", "fast-clk"),
+	CLK_DUPLICATE("pll_p_out3", "tegra-i2c.3", "fast-clk"),
+	CLK_DUPLICATE("pll_p_out3", "tegra-i2c.4", "fast-clk"),
 };
 
 struct clk *tegra_ptr_clks[] = {
-- 
1.7.1.1

