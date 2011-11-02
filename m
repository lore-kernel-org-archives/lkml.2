Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933804Ab1KBSn0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 14:43:26 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18109 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933192Ab1KBShB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 14:37:01 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6518"; a="133706969"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [RFC PATCH 11/34] msm: Migrate to clock rate voting
Date: Wed,  2 Nov 2011 11:36:08 -0700
Message-Id: <1320258991-22325-12-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1320258991-22325-1-git-send-email-davidb@codeaurora.org>
References: <1320258991-22325-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Boyd <sboyd@codeaurora.org>

Add the appropriate clock voters and integrate clock.c with the
voting driver so that voting works appropriately.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/devices-msm7x30.c |   19 +++++++++++++++++++
 arch/arm/mach-msm/devices-qsd8x50.c |   17 +++++++++++++++++
 2 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-msm/devices-msm7x30.c b/arch/arm/mach-msm/devices-msm7x30.c
index 7a548a2..6574b7a 100644
--- a/arch/arm/mach-msm/devices-msm7x30.c
+++ b/arch/arm/mach-msm/devices-msm7x30.c
@@ -24,6 +24,7 @@
 #include <mach/board.h>
 
 #include "devices.h"
+#include "clock-voter.h"
 #include "smd_private.h"
 
 #include <asm/mach/flash.h>
@@ -210,6 +211,15 @@ static struct pcom_clk pbus_clk = {
 	},
 };
 
+static DEFINE_CLK_VOTER(ebi1_dtv_clk,	&pbus_clk.c);
+static DEFINE_CLK_VOTER(ebi1_kgsl_clk,	&pbus_clk.c);
+static DEFINE_CLK_VOTER(ebi1_lcdc_clk,	&pbus_clk.c);
+static DEFINE_CLK_VOTER(ebi1_mddi_clk,	&pbus_clk.c);
+static DEFINE_CLK_VOTER(ebi1_tv_clk,	&pbus_clk.c);
+static DEFINE_CLK_VOTER(ebi1_usb_clk,	&pbus_clk.c);
+static DEFINE_CLK_VOTER(ebi1_vcd_clk,	&pbus_clk.c);
+static DEFINE_CLK_VOTER(ebi1_vfe_clk,	&pbus_clk.c);
+
 struct clk_lookup msm_clocks_7x30[] = {
 	CLK_LOOKUP("adm_clk",			adm_clk.c,	"msm_dmov"),
 	CLK_LOOKUP("adsp_clk",			adsp_clk.c,	NULL),
@@ -284,6 +294,15 @@ struct clk_lookup msm_clocks_7x30[] = {
 	CLK_LOOKUP("csi_clk",			csi0_clk.c,	NULL),
 	CLK_LOOKUP("csi_pclk",			csi0_p_clk.c,	NULL),
 	CLK_LOOKUP("csi_vfe_clk",		csi0_vfe_clk.c,	NULL),
+
+	CLK_LOOKUP("ebi1_clk",	ebi1_dtv_clk.c,		NULL),
+	CLK_LOOKUP("ebi1_clk",	ebi1_kgsl_clk.c,	NULL),
+	CLK_LOOKUP("ebi1_clk",	ebi1_lcdc_clk.c,	NULL),
+	CLK_LOOKUP("ebi1_clk",	ebi1_mddi_clk.c,	NULL),
+	CLK_LOOKUP("ebi1_clk",	ebi1_tv_clk.c,		NULL),
+	CLK_LOOKUP("ebi1_clk",	ebi1_usb_clk.c,		NULL),
+	CLK_LOOKUP("ebi1_clk",	ebi1_vcd_clk.c,		NULL),
+	CLK_LOOKUP("ebi1_clk",	ebi1_vfe_clk.c,		NULL),
 };
 
 unsigned msm_num_clocks_7x30 = ARRAY_SIZE(msm_clocks_7x30);
diff --git a/arch/arm/mach-msm/devices-qsd8x50.c b/arch/arm/mach-msm/devices-qsd8x50.c
index cc93ce8..21a1f3a 100644
--- a/arch/arm/mach-msm/devices-qsd8x50.c
+++ b/arch/arm/mach-msm/devices-qsd8x50.c
@@ -29,6 +29,7 @@
 
 #include <mach/mmc.h>
 #include "clock-pcom.h"
+#include "clock-voter.h"
 
 static struct resource resources_uart3[] = {
 	{
@@ -343,6 +344,14 @@ static DEFINE_CLK_PCOM(usb_hs3_clk,	USB_HS3_CLK,	OFF);
 static DEFINE_CLK_PCOM(usb_hs3_p_clk,	USB_HS3_P_CLK,	OFF);
 static DEFINE_CLK_PCOM(usb_phy_clk,	USB_PHY_CLK,	0);
 
+static DEFINE_CLK_VOTER(ebi1_acpu_clk,	&ebi1_clk.c);
+static DEFINE_CLK_VOTER(ebi1_kgsl_clk,	&ebi1_clk.c);
+static DEFINE_CLK_VOTER(ebi1_lcdc_clk,	&ebi1_clk.c);
+static DEFINE_CLK_VOTER(ebi1_mddi_clk,	&ebi1_clk.c);
+static DEFINE_CLK_VOTER(ebi1_tv_clk,	&ebi1_clk.c);
+static DEFINE_CLK_VOTER(ebi1_usb_clk,	&ebi1_clk.c);
+static DEFINE_CLK_VOTER(ebi1_vfe_clk,	&ebi1_clk.c);
+
 struct clk_lookup msm_clocks_8x50[] = {
 	CLK_LOOKUP("adm_clk",		adm_clk.c,	"msm_dmov"),
 	CLK_LOOKUP("ce_clk",		ce_clk.c,		NULL),
@@ -395,6 +404,14 @@ struct clk_lookup msm_clocks_8x50[] = {
 	CLK_LOOKUP("usb_hs3_clk",	usb_hs3_clk.c,	NULL),
 	CLK_LOOKUP("usb_hs3_pclk",	usb_hs3_p_clk.c,	NULL),
 	CLK_LOOKUP("usb_phy_clk",	usb_phy_clk.c,	NULL),
+
+	CLK_LOOKUP("ebi1_clk",		ebi1_acpu_clk.c,	NULL),
+	CLK_LOOKUP("ebi1_clk",		ebi1_kgsl_clk.c,	NULL),
+	CLK_LOOKUP("ebi1_clk",		ebi1_lcdc_clk.c,	NULL),
+	CLK_LOOKUP("ebi1_clk",		ebi1_mddi_clk.c,	NULL),
+	CLK_LOOKUP("ebi1_clk",		ebi1_tv_clk.c,		NULL),
+	CLK_LOOKUP("ebi1_clk",		ebi1_usb_clk.c,		NULL),
+	CLK_LOOKUP("ebi1_clk",		ebi1_vfe_clk.c,		NULL),
 };
 
 unsigned msm_num_clocks_8x50 = ARRAY_SIZE(msm_clocks_8x50);
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

