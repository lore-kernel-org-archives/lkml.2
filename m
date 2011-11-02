Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933602Ab1KBShR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 14:37:17 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18132 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933556Ab1KBShM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 14:37:12 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6518"; a="133707013"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Matt Wagantall <mattw@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [RFC PATCH 30/34] msm: clock: Add EBI1 voter clocks for ADM on SoCs without them
Date: Wed,  2 Nov 2011 11:36:27 -0700
Message-Id: <1320258991-22325-31-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1320258991-22325-1-git-send-email-davidb@codeaurora.org>
References: <1320258991-22325-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Wagantall <mattw@codeaurora.org>

The ADM driver wishes to vote for EBI1 clock rates during ADM
transfers.  Add voter clocks for this purpose.

On msm8960, this also requires the creation of an EBI voter clock
for the msm_bus driver, since it was previously using the clock
directly.

Signed-off-by: Matt Wagantall <mattw@codeaurora.org>
Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/clock-7x30.c        |    2 ++
 arch/arm/mach-msm/clock-pcom-lookup.c |    4 ++++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-msm/clock-7x30.c b/arch/arm/mach-msm/clock-7x30.c
index d917942..019fdea 100644
--- a/arch/arm/mach-msm/clock-7x30.c
+++ b/arch/arm/mach-msm/clock-7x30.c
@@ -2373,6 +2373,7 @@ static DEFINE_CLK_VOTER(ebi_mddi_clk, &pbus_clk.c);
 static DEFINE_CLK_VOTER(ebi_tv_clk, &pbus_clk.c);
 static DEFINE_CLK_VOTER(ebi_vcd_clk, &pbus_clk.c);
 static DEFINE_CLK_VOTER(ebi_vfe_clk, &pbus_clk.c);
+static DEFINE_CLK_VOTER(ebi_adm_clk, &pbus_clk.c);
 
 /*
  * SoC-specific functions required by clock-local driver
@@ -2757,6 +2758,7 @@ static struct clk_local_ownership {
 	{ CLK_LOOKUP("ebi1_tv_clk",	ebi_tv_clk.c,	NULL) },
 	{ CLK_LOOKUP("ebi1_vcd_clk",	ebi_vcd_clk.c,	NULL) },
 	{ CLK_LOOKUP("ebi1_vfe_clk",	ebi_vfe_clk.c,	NULL) },
+	{ CLK_LOOKUP("ebi1_clk",	ebi_adm_clk.c,	"msm_dmov") },
 
 	/*
 	 * This is a many-to-one mapping because we don't know how the remote
diff --git a/arch/arm/mach-msm/clock-pcom-lookup.c b/arch/arm/mach-msm/clock-pcom-lookup.c
index 9d83cba..e74a556 100644
--- a/arch/arm/mach-msm/clock-pcom-lookup.c
+++ b/arch/arm/mach-msm/clock-pcom-lookup.c
@@ -139,6 +139,7 @@ static DEFINE_CLK_VOTER(ebi_mddi_clk,	&ebi1_clk.c);
 static DEFINE_CLK_VOTER(ebi_tv_clk,	&ebi1_clk.c);
 static DEFINE_CLK_VOTER(ebi_usb_clk,	&ebi1_clk.c);
 static DEFINE_CLK_VOTER(ebi_vfe_clk,	&ebi1_clk.c);
+static DEFINE_CLK_VOTER(ebi_adm_clk,	&ebi1_clk.c);
 
 struct clk_lookup msm_clocks_7x01a[] = {
 	CLK_LOOKUP("adm_clk",		adm_clk.c,	NULL),
@@ -236,6 +237,7 @@ struct clk_lookup msm_clocks_7x27[] = {
 	CLK_LOOKUP("ebi1_mddi_clk",	ebi_mddi_clk.c,	NULL),
 	CLK_LOOKUP("ebi1_usb_clk",	ebi_usb_clk.c,	NULL),
 	CLK_LOOKUP("ebi1_vfe_clk",	ebi_vfe_clk.c,	NULL),
+	CLK_LOOKUP("ebi1_clk",		ebi_adm_clk.c,	"msm_dmov"),
 };
 unsigned msm_num_clocks_7x27 = ARRAY_SIZE(msm_clocks_7x27);
 
@@ -307,6 +309,7 @@ struct clk_lookup msm_clocks_7x27a[] = {
 	CLK_LOOKUP("ebi1_mddi_clk",	ebi_mddi_clk.c,	NULL),
 	CLK_LOOKUP("ebi1_usb_clk",	ebi_usb_clk.c,	NULL),
 	CLK_LOOKUP("ebi1_vfe_clk",	ebi_vfe_clk.c,	NULL),
+	CLK_LOOKUP("ebi1_clk",		ebi_adm_clk.c,	"msm_dmov"),
 };
 unsigned msm_num_clocks_7x27a = ARRAY_SIZE(msm_clocks_7x27a);
 
@@ -371,6 +374,7 @@ struct clk_lookup msm_clocks_8x50[] = {
 	CLK_LOOKUP("ebi1_tv_clk",	ebi_tv_clk.c,	NULL),
 	CLK_LOOKUP("ebi1_usb_clk",	ebi_usb_clk.c,	NULL),
 	CLK_LOOKUP("ebi1_vfe_clk",	ebi_vfe_clk.c,	NULL),
+	CLK_LOOKUP("ebi1_clk",		ebi_adm_clk.c,	"msm_dmov"),
 
 	CLK_LOOKUP("grp_pclk",		grp_3d_p_clk.c,	NULL),
 	CLK_LOOKUP("grp_2d_clk",	grp_2d_clk.c,	NULL),
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

