Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935520Ab2KBSwj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 14:52:39 -0400
Received: from smtp145.dfw.emailsrvr.com ([67.192.241.145]:43005 "EHLO
	smtp145.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935261Ab2KBSvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 14:51:44 -0400
From: Mark Langsdorf <mark.langsdorf@calxeda.com>
To: linux-kernel@vger.kernel.org
Cc: cpufreq@vger.kernel.org, Mark Langsdorf <mark.langsdorf@calxeda.com>,
        Rob Herring <rob.herring@calxeda.com>, mturquette@linaro.org
Subject: [PATCH 2/6 v2] clk, highbank: remove non-bypass reset mode
Date: Fri,  2 Nov 2012 13:51:45 -0500
Message-Id: <1351882309-733-3-git-send-email-mark.langsdorf@calxeda.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351882309-733-1-git-send-email-mark.langsdorf@calxeda.com>
References: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com>
 <1351882309-733-1-git-send-email-mark.langsdorf@calxeda.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The highbank clock will glitch if the clock rate is reset without
relocking the PLL. Remove the option to attempt reseting without
relocking.

Signed-off-by: Mark Langsdorf <mark.langsdorf@calxeda.com>
Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: mturquette@linaro.org

Changes from v2:
	Removed erroneous reformating.

---
 drivers/clk/clk-highbank.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/clk-highbank.c b/drivers/clk/clk-highbank.c
index 52fecad..3a0b723 100644
--- a/drivers/clk/clk-highbank.c
+++ b/drivers/clk/clk-highbank.c
@@ -182,8 +182,10 @@ static int clk_pll_set_rate(struct clk_hw *hwclk, unsigned long rate,
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

