Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966Ab2KVSyp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:54:45 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:32988 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475Ab2KVSyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:54:43 -0500
From: Fabio Estevam <festevam@gmail.com>
To: shawn.guo@linaro.org
Cc: mturquette@linaro.org, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] clk: mxs: Remove unneeded NULL pointer check
Date: Wed, 21 Nov 2012 19:33:03 -0200
Message-Id: <1353533583-13166-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

mxs platform has been converted to device tree.

There is no need to check if np is NULL after doing:

np = of_find_compatible_node(NULL, NULL, "fsl,imx[23/28]-clkctrl");

,as it will always be non-NULL.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/clk/mxs/clk-imx23.c |    8 +++-----
 drivers/clk/mxs/clk-imx28.c |    8 +++-----
 2 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/clk/mxs/clk-imx23.c b/drivers/clk/mxs/clk-imx23.c
index f00dffb..02c90d4 100644
--- a/drivers/clk/mxs/clk-imx23.c
+++ b/drivers/clk/mxs/clk-imx23.c
@@ -154,11 +154,9 @@ int __init mx23_clocks_init(void)
 		}
 
 	np = of_find_compatible_node(NULL, NULL, "fsl,imx23-clkctrl");
-	if (np) {
-		clk_data.clks = clks;
-		clk_data.clk_num = ARRAY_SIZE(clks);
-		of_clk_add_provider(np, of_clk_src_onecell_get, &clk_data);
-	}
+	clk_data.clks = clks;
+	clk_data.clk_num = ARRAY_SIZE(clks);
+	of_clk_add_provider(np, of_clk_src_onecell_get, &clk_data);
 
 	clk_register_clkdev(clks[clk32k], NULL, "timrot");
 
diff --git a/drivers/clk/mxs/clk-imx28.c b/drivers/clk/mxs/clk-imx28.c
index 42978f1b..1ba6c0f 100644
--- a/drivers/clk/mxs/clk-imx28.c
+++ b/drivers/clk/mxs/clk-imx28.c
@@ -232,11 +232,9 @@ int __init mx28_clocks_init(void)
 		}
 
 	np = of_find_compatible_node(NULL, NULL, "fsl,imx28-clkctrl");
-	if (np) {
-		clk_data.clks = clks;
-		clk_data.clk_num = ARRAY_SIZE(clks);
-		of_clk_add_provider(np, of_clk_src_onecell_get, &clk_data);
-	}
+	clk_data.clks = clks;
+	clk_data.clk_num = ARRAY_SIZE(clks);
+	of_clk_add_provider(np, of_clk_src_onecell_get, &clk_data);
 
 	clk_register_clkdev(clks[clk32k], NULL, "timrot");
 	clk_register_clkdev(clks[enet_out], NULL, "enet_out");
-- 
1.7.9.5

