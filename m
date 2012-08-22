Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933387Ab2HVW4F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 18:56:05 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:53556 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757216Ab2HVWzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 18:55:48 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6812"; a="226084946"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/3] ARM: MSM: clock-pcom: Mark functions static
Date: Wed, 22 Aug 2012 15:55:44 -0700
Message-Id: <1345676145-12321-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1345676145-12321-1-git-send-email-sboyd@codeaurora.org>
References: <1345676145-12321-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These functions are only used within clock-pcom.c, therefore mark
them as static.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/clock-pcom.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-msm/clock-pcom.c b/arch/arm/mach-msm/clock-pcom.c
index 63b7113..a52c970 100644
--- a/arch/arm/mach-msm/clock-pcom.c
+++ b/arch/arm/mach-msm/clock-pcom.c
@@ -25,7 +25,7 @@
 /*
  * glue for the proc_comm interface
  */
-int pc_clk_enable(unsigned id)
+static int pc_clk_enable(unsigned id)
 {
 	int rc = msm_proc_comm(PCOM_CLKCTL_RPC_ENABLE, &id, NULL);
 	if (rc < 0)
@@ -34,7 +34,7 @@ int pc_clk_enable(unsigned id)
 		return (int)id < 0 ? -EINVAL : 0;
 }
 
-void pc_clk_disable(unsigned id)
+static void pc_clk_disable(unsigned id)
 {
 	msm_proc_comm(PCOM_CLKCTL_RPC_DISABLE, &id, NULL);
 }
@@ -54,7 +54,7 @@ int pc_clk_reset(unsigned id, enum clk_reset_action action)
 		return (int)id < 0 ? -EINVAL : 0;
 }
 
-int pc_clk_set_rate(unsigned id, unsigned rate)
+static int pc_clk_set_rate(unsigned id, unsigned rate)
 {
 	/* The rate _might_ be rounded off to the nearest KHz value by the
 	 * remote function. So a return value of 0 doesn't necessarily mean
@@ -67,7 +67,7 @@ int pc_clk_set_rate(unsigned id, unsigned rate)
 		return (int)id < 0 ? -EINVAL : 0;
 }
 
-int pc_clk_set_min_rate(unsigned id, unsigned rate)
+static int pc_clk_set_min_rate(unsigned id, unsigned rate)
 {
 	int rc = msm_proc_comm(PCOM_CLKCTL_RPC_MIN_RATE, &id, &rate);
 	if (rc < 0)
@@ -76,7 +76,7 @@ int pc_clk_set_min_rate(unsigned id, unsigned rate)
 		return (int)id < 0 ? -EINVAL : 0;
 }
 
-int pc_clk_set_max_rate(unsigned id, unsigned rate)
+static int pc_clk_set_max_rate(unsigned id, unsigned rate)
 {
 	int rc = msm_proc_comm(PCOM_CLKCTL_RPC_MAX_RATE, &id, &rate);
 	if (rc < 0)
@@ -85,7 +85,7 @@ int pc_clk_set_max_rate(unsigned id, unsigned rate)
 		return (int)id < 0 ? -EINVAL : 0;
 }
 
-int pc_clk_set_flags(unsigned id, unsigned flags)
+static int pc_clk_set_flags(unsigned id, unsigned flags)
 {
 	int rc = msm_proc_comm(PCOM_CLKCTL_RPC_SET_FLAGS, &id, &flags);
 	if (rc < 0)
@@ -94,7 +94,7 @@ int pc_clk_set_flags(unsigned id, unsigned flags)
 		return (int)id < 0 ? -EINVAL : 0;
 }
 
-unsigned pc_clk_get_rate(unsigned id)
+static unsigned pc_clk_get_rate(unsigned id)
 {
 	if (msm_proc_comm(PCOM_CLKCTL_RPC_RATE, &id, NULL))
 		return 0;
@@ -102,7 +102,7 @@ unsigned pc_clk_get_rate(unsigned id)
 		return id;
 }
 
-unsigned pc_clk_is_enabled(unsigned id)
+static unsigned pc_clk_is_enabled(unsigned id)
 {
 	if (msm_proc_comm(PCOM_CLKCTL_RPC_ENABLED, &id, NULL))
 		return 0;
@@ -110,7 +110,7 @@ unsigned pc_clk_is_enabled(unsigned id)
 		return id;
 }
 
-long pc_clk_round_rate(unsigned id, unsigned rate)
+static long pc_clk_round_rate(unsigned id, unsigned rate)
 {
 
 	/* Not really supported; pc_clk_set_rate() does rounding on it's own. */
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

