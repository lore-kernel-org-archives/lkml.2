Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757815Ab0KSWAN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:00:13 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:13487 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757673Ab0KSV7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:59:09 -0500
From: David Daney <ddaney@caviumnetworks.com>
To: devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: David Daney <ddaney@caviumnetworks.com>, Cyril Chemparathy <cyril@ti.com>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 1/2] phylib: Use common page register definition for Marvell PHYs.
Date: Fri, 19 Nov 2010 13:58:52 -0800
Message-Id: <1290203933-28251-2-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1290203933-28251-1-git-send-email-ddaney@caviumnetworks.com>
References: <1290203933-28251-1-git-send-email-ddaney@caviumnetworks.com>
X-OriginalArrivalTime: 19 Nov 2010 21:59:59.0627 (UTC) FILETIME=[1C1985B0:01CB8835]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The definition of the Marvell PHY page register is not specific to
88E1121, so rename the macro to MII_MARVELL_PHY_PAGE, and use it
throughout.

Suggested-by: Cyril Chemparathy <cyril@ti.com>
Signed-off-by: David Daney <ddaney@caviumnetworks.com>
Cc: Cyril Chemparathy <cyril@ti.com>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 drivers/net/phy/marvell.c |   27 ++++++++++++++-------------
 1 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index f0bd1a1..3600b8b 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -35,6 +35,8 @@
 #include <asm/irq.h>
 #include <asm/uaccess.h>
 
+#define MII_MARVELL_PHY_PAGE		22
+
 #define MII_M1011_IEVENT		0x13
 #define MII_M1011_IEVENT_CLEAR		0x0000
 
@@ -80,7 +82,6 @@
 #define MII_88E1121_PHY_LED_CTRL	16
 #define MII_88E1121_PHY_LED_PAGE	3
 #define MII_88E1121_PHY_LED_DEF		0x0030
-#define MII_88E1121_PHY_PAGE		22
 
 #define MII_M1011_PHY_STATUS		0x11
 #define MII_M1011_PHY_STATUS_1000	0x8000
@@ -190,9 +191,9 @@ static int m88e1121_config_aneg(struct phy_device *phydev)
 {
 	int err, oldpage, mscr;
 
-	oldpage = phy_read(phydev, MII_88E1121_PHY_PAGE);
+	oldpage = phy_read(phydev, MII_MARVELL_PHY_PAGE);
 
-	err = phy_write(phydev, MII_88E1121_PHY_PAGE,
+	err = phy_write(phydev, MII_MARVELL_PHY_PAGE,
 			MII_88E1121_PHY_MSCR_PAGE);
 	if (err < 0)
 		return err;
@@ -218,7 +219,7 @@ static int m88e1121_config_aneg(struct phy_device *phydev)
 			return err;
 	}
 
-	phy_write(phydev, MII_88E1121_PHY_PAGE, oldpage);
+	phy_write(phydev, MII_MARVELL_PHY_PAGE, oldpage);
 
 	err = phy_write(phydev, MII_BMCR, BMCR_RESET);
 	if (err < 0)
@@ -229,11 +230,11 @@ static int m88e1121_config_aneg(struct phy_device *phydev)
 	if (err < 0)
 		return err;
 
-	oldpage = phy_read(phydev, MII_88E1121_PHY_PAGE);
+	oldpage = phy_read(phydev, MII_MARVELL_PHY_PAGE);
 
-	phy_write(phydev, MII_88E1121_PHY_PAGE, MII_88E1121_PHY_LED_PAGE);
+	phy_write(phydev, MII_MARVELL_PHY_PAGE, MII_88E1121_PHY_LED_PAGE);
 	phy_write(phydev, MII_88E1121_PHY_LED_CTRL, MII_88E1121_PHY_LED_DEF);
-	phy_write(phydev, MII_88E1121_PHY_PAGE, oldpage);
+	phy_write(phydev, MII_MARVELL_PHY_PAGE, oldpage);
 
 	err = genphy_config_aneg(phydev);
 
@@ -244,9 +245,9 @@ static int m88e1318_config_aneg(struct phy_device *phydev)
 {
 	int err, oldpage, mscr;
 
-	oldpage = phy_read(phydev, MII_88E1121_PHY_PAGE);
+	oldpage = phy_read(phydev, MII_MARVELL_PHY_PAGE);
 
-	err = phy_write(phydev, MII_88E1121_PHY_PAGE,
+	err = phy_write(phydev, MII_MARVELL_PHY_PAGE,
 			MII_88E1121_PHY_MSCR_PAGE);
 	if (err < 0)
 		return err;
@@ -258,7 +259,7 @@ static int m88e1318_config_aneg(struct phy_device *phydev)
 	if (err < 0)
 		return err;
 
-	err = phy_write(phydev, MII_88E1121_PHY_PAGE, oldpage);
+	err = phy_write(phydev, MII_MARVELL_PHY_PAGE, oldpage);
 	if (err < 0)
 		return err;
 
@@ -398,7 +399,7 @@ static int m88e1118_config_init(struct phy_device *phydev)
 	int err;
 
 	/* Change address */
-	err = phy_write(phydev, 0x16, 0x0002);
+	err = phy_write(phydev, MII_MARVELL_PHY_PAGE, 0x0002);
 	if (err < 0)
 		return err;
 
@@ -408,7 +409,7 @@ static int m88e1118_config_init(struct phy_device *phydev)
 		return err;
 
 	/* Change address */
-	err = phy_write(phydev, 0x16, 0x0003);
+	err = phy_write(phydev, MII_MARVELL_PHY_PAGE, 0x0003);
 	if (err < 0)
 		return err;
 
@@ -421,7 +422,7 @@ static int m88e1118_config_init(struct phy_device *phydev)
 		return err;
 
 	/* Reset address */
-	err = phy_write(phydev, 0x16, 0x0);
+	err = phy_write(phydev, MII_MARVELL_PHY_PAGE, 0x0);
 	if (err < 0)
 		return err;
 
-- 
1.7.2.3

