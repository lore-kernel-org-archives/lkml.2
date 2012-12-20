Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280Ab2LTJrn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 04:47:43 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17741 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062Ab2LTJrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 04:47:01 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 20 Dec 2012 01:42:51 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: <linux-tegra@vger.kernel.org>
CC: Hiroshi Doyu <hdoyu@nvidia.com>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Olof Johansson <olof@lixom.net>,
        Jason Cooper <jason@lakedaemon.net>, Shawn Guo <shawn.guo@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 2/9] HACK: ARM: tegra: Use CLK_IGNORE_UNUSED for Tegra 114 SoC
Date: Thu, 20 Dec 2012 11:44:00 +0200
Message-ID: <1355996654-6579-3-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355996654-6579-1-git-send-email-hdoyu@nvidia.com>
References: <1355996654-6579-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use CLK_IGNORE_UNUSED for the Tegra 114 SoC to ensure
clk_disable_unused() is not called. Otherwise the system will die,
because the usecount of the clocks is incorrect. This patch will be
reverted once the Tegra 114 clocks are implemented.

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
 arch/arm/mach-tegra/tegra30_clocks_data.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mach-tegra/tegra30_clocks_data.c b/arch/arm/mach-tegra/tegra30_clocks_data.c
index 6942c7a..4865ba5 100644
--- a/arch/arm/mach-tegra/tegra30_clocks_data.c
+++ b/arch/arm/mach-tegra/tegra30_clocks_data.c
@@ -1384,6 +1384,8 @@ static void tegra30_init_one_clock(struct clk *c)
 	if (!clk->lookup.dev_id && !clk->lookup.con_id)
 		clk->lookup.con_id = c->name;
 	clk->lookup.clk = c;
+	if (tegra_chip_id == TEGRA114) /* FIXME: Implement T114 clocks */
+		c->flags |= CLK_IGNORE_UNUSED;
 	clkdev_add(&clk->lookup);
 	tegra_clk_add(c);
 }
-- 
1.7.9.5

