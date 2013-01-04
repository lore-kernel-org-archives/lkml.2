Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939Ab3ADHCG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 02:02:06 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18364 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557Ab3ADHCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 02:02:00 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 03 Jan 2013 22:59:15 -0800
From: Prashant Gaikwad <pgaikwad@nvidia.com>
To: <mturquette@linaro.org>, <swarren@nvidia.com>, <grant.likely@secretlab.ca>,
        <linus.walleij@linaro.org>, <rob.herring@calxeda.com>,
        <maxime.ripard@free-electrons.com>, <linux@prisktech.co.nz>,
        <josh.cartwright@ni.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>
Subject: [PATCH 7/7] clk: vexpress: Use common of_clk_init() function
Date: Fri, 4 Jan 2013 12:30:58 +0530
Message-ID: <1357282858-2112-7-git-send-email-pgaikwad@nvidia.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1357282858-2112-1-git-send-email-pgaikwad@nvidia.com>
References: <1357282858-2112-1-git-send-email-pgaikwad@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use common of_clk_init() function for clock initialization.

Signed-off-by: Prashant Gaikwad <pgaikwad@nvidia.com>
---
 drivers/clk/versatile/clk-vexpress-osc.c |    1 +
 drivers/clk/versatile/clk-vexpress.c     |    8 +-------
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/clk/versatile/clk-vexpress-osc.c b/drivers/clk/versatile/clk-vexpress-osc.c
index dcb6ae0..256c8be 100644
--- a/drivers/clk/versatile/clk-vexpress-osc.c
+++ b/drivers/clk/versatile/clk-vexpress-osc.c
@@ -144,3 +144,4 @@ error:
 		vexpress_config_func_put(osc->func);
 	kfree(osc);
 }
+CLK_OF_DECLARE(vexpress_soc, "arm,vexpress-osc", vexpress_osc_of_setup);
diff --git a/drivers/clk/versatile/clk-vexpress.c b/drivers/clk/versatile/clk-vexpress.c
index c742ac7..f889f2f 100644
--- a/drivers/clk/versatile/clk-vexpress.c
+++ b/drivers/clk/versatile/clk-vexpress.c
@@ -99,19 +99,13 @@ struct clk *vexpress_sp810_of_get(struct of_phandle_args *clkspec, void *data)
 	return vexpress_sp810_timerclken[clkspec->args[0]];
 }
 
-static const __initconst struct of_device_id vexpress_fixed_clk_match[] = {
-	{ .compatible = "fixed-clock", .data = of_fixed_clk_setup, },
-	{ .compatible = "arm,vexpress-osc", .data = vexpress_osc_of_setup, },
-	{}
-};
-
 void __init vexpress_clk_of_init(void)
 {
 	struct device_node *node;
 	struct clk *clk;
 	struct clk *refclk, *timclk;
 
-	of_clk_init(vexpress_fixed_clk_match);
+	of_clk_init(NULL);
 
 	node = of_find_compatible_node(NULL, NULL, "arm,sp810");
 	vexpress_sp810_init(of_iomap(node, 0));
-- 
1.7.4.1

