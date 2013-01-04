Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207Ab3ADQgE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 11:36:04 -0500
Received: from smtp131.dfw.emailsrvr.com ([67.192.241.131]:41768 "EHLO
	smtp131.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754861Ab3ADQfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 11:35:25 -0500
From: Mark Langsdorf <mark.langsdorf@calxeda.com>
To: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Mark Langsdorf <mark.langsdorf@calxeda.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 2/4 v10] clk, highbank: Prevent glitches in non-bypass reset mode
Date: Fri,  4 Jan 2013 10:35:44 -0600
Message-Id: <1357317346-1120-3-git-send-email-mark.langsdorf@calxeda.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357317346-1120-1-git-send-email-mark.langsdorf@calxeda.com>
References: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com>
 <1357317346-1120-1-git-send-email-mark.langsdorf@calxeda.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The highbank clock will glitch with the current code if the
clock rate is reset without relocking the PLL. Program the PLL
correctly to prevent glitches.

Signed-off-by: Mark Langsdorf <mark.langsdorf@calxeda.com>
Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Acked-by: Mike Turquette <mturquette@linaro.org>
---
Changes from v6, v7, v8, v9
        None.
Changes from v5
        Added Mike Turquette's ack.
Changes from v4
        None.
Changes from v3
        Changelog text and patch name now correspond to the actual patch.
        was clk, highbank: remove non-bypass reset mode.
Changes from v2
        None.
Changes from v1
        Removed erroneous reformating.

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
1.8.0.2

