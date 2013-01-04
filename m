Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144Ab3ADHB7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 02:01:59 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10707 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557Ab3ADHBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 02:01:55 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 03 Jan 2013 22:57:42 -0800
From: Prashant Gaikwad <pgaikwad@nvidia.com>
To: <mturquette@linaro.org>, <swarren@nvidia.com>, <grant.likely@secretlab.ca>,
        <linus.walleij@linaro.org>, <rob.herring@calxeda.com>,
        <maxime.ripard@free-electrons.com>, <linux@prisktech.co.nz>,
        <josh.cartwright@ni.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>
Subject: [PATCH 6/7] clk: zynq: Use common of_clk_init() function
Date: Fri, 4 Jan 2013 12:30:57 +0530
Message-ID: <1357282858-2112-6-git-send-email-pgaikwad@nvidia.com>
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
 drivers/clk/clk-zynq.c |   14 ++++----------
 1 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/clk/clk-zynq.c b/drivers/clk/clk-zynq.c
index 37a3051..b14a25f 100644
--- a/drivers/clk/clk-zynq.c
+++ b/drivers/clk/clk-zynq.c
@@ -81,6 +81,7 @@ static void __init zynq_pll_clk_setup(struct device_node *np)
 	if (WARN_ON(ret))
 		return;
 }
+CLK_OF_DECLARE(zynq_pll, "xlnx,zynq-pll", zynq_pll_clk_setup);
 
 struct zynq_periph_clk {
 	struct clk_hw		hw;
@@ -187,6 +188,7 @@ static void __init zynq_periph_clk_setup(struct device_node *np)
 	if (WARN_ON(err))
 		return;
 }
+CLK_OF_DECLARE(zynq_periph, "xlnx,zynq-periph-clock", zynq_periph_clk_setup);
 
 /* CPU Clock domain is modelled as a mux with 4 children subclks, whose
  * derivative rates depend on CLK_621_TRUE
@@ -366,18 +368,10 @@ static void __init zynq_cpu_clk_setup(struct device_node *np)
 	if (WARN_ON(err))
 		return;
 }
-
-static const __initconst struct of_device_id zynq_clk_match[] = {
-	{ .compatible = "fixed-clock", .data = of_fixed_clk_setup, },
-	{ .compatible = "xlnx,zynq-pll", .data = zynq_pll_clk_setup, },
-	{ .compatible = "xlnx,zynq-periph-clock",
-		.data = zynq_periph_clk_setup, },
-	{ .compatible = "xlnx,zynq-cpu-clock", .data = zynq_cpu_clk_setup, },
-	{}
-};
+CLK_OF_DECLARE(zynq_cpu, "xlnx,zynq-cpu-clock", zynq_cpu_clk_setup);
 
 void __init xilinx_zynq_clocks_init(void __iomem *slcr)
 {
 	slcr_base = slcr;
-	of_clk_init(zynq_clk_match);
+	of_clk_init(NULL);
 }
-- 
1.7.4.1

