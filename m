Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934598Ab2J3VEP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 17:04:15 -0400
Received: from smtp181.dfw.emailsrvr.com ([67.192.241.181]:50893 "EHLO
	smtp181.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934544Ab2J3VEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 17:04:11 -0400
From: Mark Langsdorf <mark.langsdorf@calxeda.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Langsdorf <mark.langsdorf@calxeda.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 2/6] clk, highbank: remove non-bypass reset mode
Date: Tue, 30 Oct 2012 16:04:12 -0500
Message-Id: <1351631056-25938-3-git-send-email-mark.langsdorf@calxeda.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com>
References: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The highbank clock will glitch if the clock rate is reset without
relocking the PLL. Remove the option to attempt reseting without
relocking.

Signed-off-by: Mark Langsdorf <mark.langsdorf@calxeda.com>
Signed-off-by: Rob Herring <rob.herring@calxeda.com>
---
 drivers/clk/clk-highbank.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/clk-highbank.c b/drivers/clk/clk-highbank.c
index 52fecad..4f50c42 100644
--- a/drivers/clk/clk-highbank.c
+++ b/drivers/clk/clk-highbank.c
@@ -171,7 +171,8 @@ static int clk_pll_set_rate(struct clk_hw *hwclk, unsigned long rate,
 
 		writel(reg | HB_PLL_RESET, hbclk->reg);
 		reg &= ~(HB_PLL_DIVF_MASK | HB_PLL_DIVQ_MASK);
-		reg |= (divf << HB_PLL_DIVF_SHIFT) | (divq << HB_PLL_DIVQ_SHIFT);
+		reg |= (divf << HB_PLL_DIVF_SHIFT) |
+			(divq << HB_PLL_DIVQ_SHIFT);
 		writel(reg | HB_PLL_RESET, hbclk->reg);
 		writel(reg, hbclk->reg);
 
@@ -182,8 +183,10 @@ static int clk_pll_set_rate(struct clk_hw *hwclk, unsigned long rate,
 		reg |= HB_PLL_EXT_ENA;
 		reg &= ~HB_PLL_EXT_BYPASS;
 	} else {
+		writel(reg | HB_PLL_EXT_BYPASS, hbclk->reg);
 		reg &= ~HB_PLL_DIVQ_MASK;
 		reg |= divq << HB_PLL_DIVQ_SHIFT;
+		writel(reg | HB_PLL_EXT_BYPASS, hbclk->reg);
 	}
 	writel(reg, hbclk->reg);
 
-- 
1.7.11.7

