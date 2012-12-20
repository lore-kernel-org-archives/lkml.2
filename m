Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308Ab2LTTO1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 14:14:27 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:48823 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237Ab2LTTNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 14:13:43 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: Eilon Greenstein <eilong@broadcom.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] bnx2x: use ARRAY_SIZE where possible
Date: Thu, 20 Dec 2012 14:11:24 -0500
Message-Id: <1356030701-16284-16-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
References: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
index 09096b4..cb41f54 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
@@ -3659,7 +3659,7 @@ static void bnx2x_warpcore_enable_AN_KR2(struct bnx2x_phy *phy,
 	bnx2x_cl45_read_or_write(bp, phy, MDIO_WC_DEVAD,
 				 MDIO_WC_REG_CL49_USERB0_CTRL, (3<<6));
 
-	for (i = 0; i < sizeof(reg_set)/sizeof(struct bnx2x_reg_set); i++)
+	for (i = 0; i < ARRAY_SIZE(reg_set); i++)
 		bnx2x_cl45_write(bp, phy, reg_set[i].devad, reg_set[i].reg,
 				 reg_set[i].val);
 
@@ -3713,7 +3713,7 @@ static void bnx2x_warpcore_enable_AN_KR(struct bnx2x_phy *phy,
 	};
 	DP(NETIF_MSG_LINK, "Enable Auto Negotiation for KR\n");
 	/* Set to default registers that may be overriden by 10G force */
-	for (i = 0; i < sizeof(reg_set)/sizeof(struct bnx2x_reg_set); i++)
+	for (i = 0; i < ARRAY_SIZE(reg_set); i++)
 		bnx2x_cl45_write(bp, phy, reg_set[i].devad, reg_set[i].reg,
 				 reg_set[i].val);
 
@@ -3854,7 +3854,7 @@ static void bnx2x_warpcore_set_10G_KR(struct bnx2x_phy *phy,
 		{MDIO_PMA_DEVAD, MDIO_WC_REG_PMD_KR_CONTROL, 0x2}
 	};
 
-	for (i = 0; i < sizeof(reg_set)/sizeof(struct bnx2x_reg_set); i++)
+	for (i = 0; i < ARRAY_SIZE(reg_set); i++)
 		bnx2x_cl45_write(bp, phy, reg_set[i].devad, reg_set[i].reg,
 				 reg_set[i].val);
 
@@ -4242,7 +4242,7 @@ static void bnx2x_warpcore_clear_regs(struct bnx2x_phy *phy,
 	bnx2x_cl45_read_or_write(bp, phy, MDIO_WC_DEVAD,
 				 MDIO_WC_REG_RX66_CONTROL, (3<<13));
 
-	for (i = 0; i < sizeof(wc_regs)/sizeof(struct bnx2x_reg_set); i++)
+	for (i = 0; i < ARRAY_SIZE(wc_regs); i++)
 		bnx2x_cl45_write(bp, phy, wc_regs[i].devad, wc_regs[i].reg,
 				 wc_regs[i].val);
 
@@ -9520,7 +9520,7 @@ static void bnx2x_save_848xx_spirom_version(struct bnx2x_phy *phy,
 	} else {
 		/* For 32-bit registers in 848xx, access via MDIO2ARM i/f. */
 		/* (1) set reg 0xc200_0014(SPI_BRIDGE_CTRL_2) to 0x03000000 */
-		for (i = 0; i < sizeof(reg_set)/sizeof(struct bnx2x_reg_set);
+		for (i = 0; i < ARRAY_SIZE(reg_set);
 		      i++)
 			bnx2x_cl45_write(bp, phy, reg_set[i].devad,
 					 reg_set[i].reg, reg_set[i].val);
@@ -9592,7 +9592,7 @@ static void bnx2x_848xx_set_led(struct bnx2x *bp,
 			 MDIO_PMA_DEVAD,
 			 MDIO_PMA_REG_8481_LINK_SIGNAL, val);
 
-	for (i = 0; i < sizeof(reg_set)/sizeof(struct bnx2x_reg_set); i++)
+	for (i = 0; i < ARRAY_SIZE(reg_set); i++)
 		bnx2x_cl45_write(bp, phy, reg_set[i].devad, reg_set[i].reg,
 				 reg_set[i].val);
 
@@ -13395,7 +13395,7 @@ static void bnx2x_disable_kr2(struct link_params *params,
 	};
 	DP(NETIF_MSG_LINK, "Disabling 20G-KR2\n");
 
-	for (i = 0; i < sizeof(reg_set)/sizeof(struct bnx2x_reg_set); i++)
+	for (i = 0; i < ARRAY_SIZE(reg_set); i++)
 		bnx2x_cl45_write(bp, phy, reg_set[i].devad, reg_set[i].reg,
 				 reg_set[i].val);
 	vars->link_attr_sync &= ~LINK_ATTR_SYNC_KR2_ENABLE;
-- 
1.8.0

