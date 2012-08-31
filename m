Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583Ab2HaMWw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 08:22:52 -0400
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:55657 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751679Ab2HaMWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 08:22:14 -0400
From: Ulf Hansson <ulf.hansson@stericsson.com>
To: <linux-arm-kernel@lists.infradead.org>, Mike Turquette <mturquette@ti.com>,
        Mike Turquette <mturquette@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        Philippe Begnic <philippe.begnic@st.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 2/4] clk: ux500: Support for prmcu_rate clock
Date: Fri, 31 Aug 2012 14:21:29 +0200
Message-ID: <1346415691-13371-3-git-send-email-ulf.hansson@stericsson.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1346415691-13371-1-git-send-email-ulf.hansson@stericsson.com>
References: <1346415691-13371-1-git-send-email-ulf.hansson@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ulf Hansson <ulf.hansson@linaro.org>

The prmcu_rate clock is not gateable and has a rate which
only can be fetched.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/clk/ux500/clk-prcmu.c |   14 ++++++++++++++
 drivers/clk/ux500/clk.h       |    5 +++++
 2 files changed, 19 insertions(+)

diff --git a/drivers/clk/ux500/clk-prcmu.c b/drivers/clk/ux500/clk-prcmu.c
index 1d779ad..930cdfe 100644
--- a/drivers/clk/ux500/clk-prcmu.c
+++ b/drivers/clk/ux500/clk-prcmu.c
@@ -153,6 +153,11 @@ static struct clk_ops clk_prcmu_gate_ops = {
 	.recalc_rate = clk_prcmu_recalc_rate,
 };
 
+static struct clk_ops clk_prcmu_rate_ops = {
+	.is_enabled = clk_prcmu_is_enabled,
+	.recalc_rate = clk_prcmu_recalc_rate,
+};
+
 static struct clk_ops clk_prcmu_opp_gate_ops = {
 	.prepare = clk_prcmu_opp_prepare,
 	.unprepare = clk_prcmu_opp_unprepare,
@@ -228,6 +233,15 @@ struct clk *clk_reg_prcmu_gate(const char *name,
 			&clk_prcmu_gate_ops);
 }
 
+struct clk *clk_reg_prcmu_rate(const char *name,
+			       const char *parent_name,
+			       u8 cg_sel,
+			       unsigned long flags)
+{
+	return clk_reg_prcmu(name, parent_name, cg_sel, 0, flags,
+			&clk_prcmu_rate_ops);
+}
+
 struct clk *clk_reg_prcmu_opp_gate(const char *name,
 				   const char *parent_name,
 				   u8 cg_sel,
diff --git a/drivers/clk/ux500/clk.h b/drivers/clk/ux500/clk.h
index 32085aa..836d7d1 100644
--- a/drivers/clk/ux500/clk.h
+++ b/drivers/clk/ux500/clk.h
@@ -35,6 +35,11 @@ struct clk *clk_reg_prcmu_gate(const char *name,
 			       u8 cg_sel,
 			       unsigned long flags);
 
+struct clk *clk_reg_prcmu_rate(const char *name,
+			       const char *parent_name,
+			       u8 cg_sel,
+			       unsigned long flags);
+
 struct clk *clk_reg_prcmu_opp_gate(const char *name,
 				   const char *parent_name,
 				   u8 cg_sel,
-- 
1.7.10

