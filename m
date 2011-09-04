Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab1IDK2R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 06:28:17 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33421 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955Ab1IDK03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 06:26:29 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 10/12] staging: et131x: Remove struct mi_regs from et1310_phy.h
Date: Sun,  4 Sep 2011 11:24:41 +0100
Message-Id: <1315131883-11068-11-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1315131883-11068-1-git-send-email-mark.einon@gmail.com>
References: <1315131883-11068-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This structure is no longer used, and references registers defined in mii.h and other parts of et1310_phy.h

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et1310_phy.h |   34 +++++-----------------------------
 1 files changed, 5 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/et131x/et1310_phy.h b/drivers/staging/et131x/et1310_phy.h
index 104008e..82037ac 100644
--- a/drivers/staging/et131x/et1310_phy.h
+++ b/drivers/staging/et131x/et1310_phy.h
@@ -61,6 +61,11 @@
 
 #include "et1310_address_map.h"
 
+/*
+ * Defines for generic MII registers 0x00 -> 0x0F can be found in
+ * include/linux/mii.h
+ */
+
 /* some defines for modem registers that seem to be 'reserved' */
 #define PHY_INDEX_REG              0x10
 #define PHY_DATA_REG               0x11
@@ -80,35 +85,6 @@
 					/* TRU_VMI_LINK_CONTROL_REG       29 */
 					/* TRU_VMI_TIMING_CONTROL_REG        */
 
-/* PHY Register Mapping(MI) Management Interface Regs */
-struct mi_regs {
-	u8 bmcr;	/* Basic mode control reg(Reg 0x00) */
-	u8 bmsr;	/* Basic mode status reg(Reg 0x01) */
-	u8 idr1;	/* Phy identifier reg 1(Reg 0x02) */
-	u8 idr2;	/* Phy identifier reg 2(Reg 0x03) */
-	u8 anar;	/* Auto-Negotiation advertisement(Reg 0x04) */
-	u8 anlpar;	/* Auto-Negotiation link Partner Ability(Reg 0x05) */
-	u8 aner;	/* Auto-Negotiation expansion reg(Reg 0x06) */
-	u8 annptr;	/* Auto-Negotiation next page transmit reg(Reg 0x07) */
-	u8 lpnpr;	/* link partner next page reg(Reg 0x08) */
-	u8 gcr;		/* Gigabit basic mode control reg(Reg 0x09) */
-	u8 gsr;		/* Gigabit basic mode status reg(Reg 0x0A) */
-	u8 mi_res1[4];	/* Future use by MI working group(Reg 0x0B - 0x0E) */
-	u8 esr;		/* Extended status reg(Reg 0x0F) */
-	u8 mi_res2[3];	/* Future use by MI working group(Reg 0x10 - 0x12) */
-	u8 loop_ctl;	/* Loopback Control Reg(Reg 0x13) */
-	u8 mi_res3;	/* Future use by MI working group(Reg 0x14) */
-	u8 mcr;		/* MI Control Reg(Reg 0x15) */
-	u8 pcr;		/* Configuration Reg(Reg 0x16) */
-	u8 phy_ctl;	/* PHY Control Reg(Reg 0x17) */
-	u8 imr;		/* Interrupt Mask Reg(Reg 0x18) */
-	u8 isr;		/* Interrupt Status Reg(Reg 0x19) */
-	u8 psr;		/* PHY Status Reg(Reg 0x1A) */
-	u8 lcr1;	/* LED Control 1 Reg(Reg 0x1B) */
-	u8 lcr2;	/* LED Control 2 Reg(Reg 0x1C) */
-	u8 mi_res4[3];	/* Future use by MI working group(Reg 0x1D - 0x1F) */
-};
-
 /* MI Register 10: Gigabit basic mode status reg(Reg 0x0A) */
 #define ET_1000BT_MSTR_SLV 0x4000
 
-- 
1.7.6

