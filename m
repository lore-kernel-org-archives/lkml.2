Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353Ab2KTHaE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 02:30:04 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7715 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab2KTHaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 02:30:00 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 19 Nov 2012 23:29:49 -0800
From: Sivaram Nair <sivaramn@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Sivaram Nair <sivaramn@nvidia.com>
Subject: [PATCH 1/1] arm: tegra: select correct parent clk for pll_p
Date: Tue, 20 Nov 2012 09:29:16 +0200
Message-ID: <1353396556-7738-1-git-send-email-sivaramn@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For Tegra30, pll_p clk's parent is wrongly specified as clk_m instead of
pll_ref in the tegra30_clk_init_table and this is resulting in a
boot-time warning. This patch fixes this by correcting the clk init
table.

Signed-off-by: Sivaram Nair <sivaramn@nvidia.com>
---
 arch/arm/mach-tegra/common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-tegra/common.c b/arch/arm/mach-tegra/common.c
index 0816562..d54cfc5 100644
--- a/arch/arm/mach-tegra/common.c
+++ b/arch/arm/mach-tegra/common.c
@@ -104,7 +104,7 @@ static __initdata struct tegra_clk_init_table tegra20_clk_init_table[] = {
 static __initdata struct tegra_clk_init_table tegra30_clk_init_table[] = {
 	/* name		parent		rate		enabled */
 	{ "clk_m",	NULL,		0,		true },
-	{ "pll_p",	"clk_m",	408000000,	true },
+	{ "pll_p",	"pll_ref",	408000000,	true },
 	{ "pll_p_out1",	"pll_p",	9600000,	true },
 	{ "pll_p_out4",	"pll_p",	102000000,	true },
 	{ "sclk",	"pll_p_out4",	102000000,	true },
-- 
1.7.9.5

