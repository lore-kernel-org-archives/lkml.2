Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196Ab2IXUiK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 16:38:10 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5959 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757874Ab2IXUiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 16:38:09 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6845"; a="238278922"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCHv2 1/3] clk: wm831x: Fix clk_register() error code checking
Date: Mon, 24 Sep 2012 13:38:03 -0700
Message-Id: <1348519085-5888-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.12.1.382.gb0576a6
In-Reply-To: <1348034730-16473-1-git-send-email-sboyd@codeaurora.org>
References: <1348034730-16473-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clk_register() returns an ERR_PTR upon failure, not NULL. Fix
these error paths.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

v2: No changes

 drivers/clk/clk-wm831x.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/clk/clk-wm831x.c b/drivers/clk/clk-wm831x.c
index e7b7765..eb1afaf 100644
--- a/drivers/clk/clk-wm831x.c
+++ b/drivers/clk/clk-wm831x.c
@@ -371,20 +371,20 @@ static __devinit int wm831x_clk_probe(struct platform_device *pdev)
 
 	clkdata->xtal_hw.init = &wm831x_xtal_init;
 	clkdata->xtal = clk_register(&pdev->dev, &clkdata->xtal_hw);
-	if (!clkdata->xtal)
-		return -EINVAL;
+	if (IS_ERR(clkdata->xtal))
+		return PTR_ERR(clkdata->xtal);
 
 	clkdata->fll_hw.init = &wm831x_fll_init;
 	clkdata->fll = clk_register(&pdev->dev, &clkdata->fll_hw);
-	if (!clkdata->fll) {
-		ret = -EINVAL;
+	if (IS_ERR(clkdata->fll)) {
+		ret = PTR_ERR(clkdata->fll);
 		goto err_xtal;
 	}
 
 	clkdata->clkout_hw.init = &wm831x_clkout_init;
 	clkdata->clkout = clk_register(&pdev->dev, &clkdata->clkout_hw);
-	if (!clkdata->clkout) {
-		ret = -EINVAL;
+	if (IS_ERR(clkdata->clkout)) {
+		ret = PTR_ERR(clkdata->clkout);
 		goto err_fll;
 	}
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

