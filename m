Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750960Ab2KOVUs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 16:20:48 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:53328 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab2KOVUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 16:20:46 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/6] ARM: tegra: Add AUXDATA for Tegra20 host1x
Date: Thu, 15 Nov 2012 22:07:55 +0100
Message-Id: <1353013679-16773-3-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353013679-16773-1-git-send-email-thierry.reding@avionic-design.de>
References: <1353013679-16773-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:SOBthoPhRqlqvv0NRpgpag9vm3ASss8deIW1a4R/8C9
 qT/qJ+bYQVvfb9XU/rtFd87irgm3/uGvYtAiUn/pKGNKatHxx1
 aGLbbUu3JCal2hd0Sh3XoQhImwZY0Desu6w4ZPFN08+5CieLuw
 9BvHUf7TwJhMBrKbweW4tSM4bSkih5ACdbUCUT4RxIwTvmVTgL
 DctFm9rJ8GExJMrb798sZiKI8o6K+jdy0em7V0ZyS3zlXVul2f
 ynXV0WHgvMiEMlrx1dsuhDq3RKx3mtVrtIbTRP6l1qbK4XO0Kg
 IBxygFpA3Cf0qUDgO5UeCM/oZIuvU2yVvrvVvL3L7vhfOyu2Vn
 iUGE9wy9mgGYOCfZC+bUx6EuET0jqfgli0aEFKPLJSiyDI7ky3
 eE4+Sd5hOP1RE90HNULAUiZRSLMuPk2VenXROHT+ttaYFX5VyU
 9TswJ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the OF_DEV_AUXDATA table entries required to associate the proper
names with host1x and its children. In turn, this allows the devices to
find the required clocks.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 arch/arm/mach-tegra/board-dt-tegra20.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/mach-tegra/board-dt-tegra20.c b/arch/arm/mach-tegra/board-dt-tegra20.c
index 1198e84..734d9cc 100644
--- a/arch/arm/mach-tegra/board-dt-tegra20.c
+++ b/arch/arm/mach-tegra/board-dt-tegra20.c
@@ -94,6 +94,12 @@ struct of_dev_auxdata tegra20_auxdata_lookup[] __initdata = {
 	OF_DEV_AUXDATA("nvidia,tegra20-slink", 0x7000D600, "spi_tegra.1", NULL),
 	OF_DEV_AUXDATA("nvidia,tegra20-slink", 0x7000D800, "spi_tegra.2", NULL),
 	OF_DEV_AUXDATA("nvidia,tegra20-slink", 0x7000DA00, "spi_tegra.3", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-host1x", 0x50000000, "host1x", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-dc", 0x54200000, "tegradc.0", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-dc", 0x54240000, "tegradc.1", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-hdmi", 0x54280000, "hdmi", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-dsi", 0x54300000, "dsi", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-tvo", 0x542c0000, "tvo", NULL),
 	{}
 };
 
@@ -118,6 +124,9 @@ static __initdata struct tegra_clk_init_table tegra_dt_clk_init_table[] = {
 	{ "sbc2",	"pll_p",	100000000,	false },
 	{ "sbc3",	"pll_p",	100000000,	false },
 	{ "sbc4",	"pll_p",	100000000,	false },
+	{ "host1x",	"pll_c",	150000000,	false },
+	{ "disp1",	"pll_p",	600000000,	false },
+	{ "disp2",	"pll_p",	600000000,	false },
 	{ NULL,		NULL,		0,		0},
 };
 
-- 
1.8.0

