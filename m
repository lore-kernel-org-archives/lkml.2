Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157Ab2IXOoI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 10:44:08 -0400
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:41526 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752252Ab2IXOoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 10:44:03 -0400
From: Ulf Hansson <ulf.hansson@stericsson.com>
To: <linux-arm-kernel@lists.infradead.org>, Mike Turquette <mturquette@ti.com>,
        Mike Turquette <mturquette@linaro.org>, <linux-kernel@vger.kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        Philippe Begnic <philippe.begnic@st.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 3/3] clk: ux500: Update sdmmc clock to 100MHz for u8500
Date: Mon, 24 Sep 2012 16:43:19 +0200
Message-ID: <1348497799-32143-4-git-send-email-ulf.hansson@stericsson.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1348497799-32143-1-git-send-email-ulf.hansson@stericsson.com>
References: <1348497799-32143-1-git-send-email-ulf.hansson@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ulf Hansson <ulf.hansson@linaro.org>

For u8500 and using 100MHz as the frequency also requires the ape opp 100
voltage, thus use the prcmu_opp_volt_scalable clock type.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/clk/ux500/u8500_clk.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/ux500/u8500_clk.c b/drivers/clk/ux500/u8500_clk.c
index ca4a25e..7bebf1f 100644
--- a/drivers/clk/ux500/u8500_clk.c
+++ b/drivers/clk/ux500/u8500_clk.c
@@ -170,10 +170,11 @@ void u8500_clk_init(void)
 	clk_register_clkdev(clk, NULL, "mtu0");
 	clk_register_clkdev(clk, NULL, "mtu1");
 
-	clk = clk_reg_prcmu_gate("sdmmcclk", NULL, PRCMU_SDMMCCLK, CLK_IS_ROOT);
+	clk = clk_reg_prcmu_opp_volt_scalable("sdmmcclk", NULL, PRCMU_SDMMCCLK,
+					100000000,
+					CLK_IS_ROOT|CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, NULL, "sdmmc");
 
-
 	clk = clk_reg_prcmu_scalable("dsi_pll", "hdmiclk",
 				PRCMU_PLLDSI, 0, CLK_SET_RATE_GATE);
 	clk_register_clkdev(clk, "dsihs2", "mcde");
-- 
1.7.10

