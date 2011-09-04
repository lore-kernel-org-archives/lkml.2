Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab1IDK2K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 06:28:10 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36791 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826Ab1IDK0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 06:26:31 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 11/12] staging: et131x: Remove ai_force_[duplex|speed] from et131x_adapter
Date: Sun,  4 Sep 2011 11:24:42 +0100
Message-Id: <1315131883-11068-12-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1315131883-11068-1-git-send-email-mark.einon@gmail.com>
References: <1315131883-11068-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ai_force settings were used to set the ethernet speed and duplex manually.
This is now being done by the phy_device, so remove.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et1310_phy.c     |    6 ++----
 drivers/staging/et131x/et131x_adapter.h |    2 --
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/et131x/et1310_phy.c b/drivers/staging/et131x/et1310_phy.c
index 3c82f44..c4bc41d 100644
--- a/drivers/staging/et131x/et1310_phy.c
+++ b/drivers/staging/et131x/et1310_phy.c
@@ -498,10 +498,8 @@ void et131x_mii_check(struct et131x_adapter *adapter,
 		}
 	}
 
-	if ((bmsr_ints & BMSR_ANEGCOMPLETE) ||
-	   (adapter->ai_force_duplex == 3 && (bmsr_ints & BMSR_LSTATUS))) {
-		if ((bmsr & BMSR_ANEGCOMPLETE) ||
-		    adapter->ai_force_duplex == 3) {
+	if (bmsr_ints & BMSR_ANEGCOMPLETE) {
+		if (bmsr & BMSR_ANEGCOMPLETE) {
 			et1310_phy_link_status(adapter,
 					     &link_status, &autoneg_status,
 					     &speed, &duplex, &mdi_mdix,
diff --git a/drivers/staging/et131x/et131x_adapter.h b/drivers/staging/et131x/et131x_adapter.h
index 292a771..78f2894 100644
--- a/drivers/staging/et131x/et131x_adapter.h
+++ b/drivers/staging/et131x/et131x_adapter.h
@@ -181,8 +181,6 @@ struct et131x_adapter {
 	u32 registry_jumbo_packet;	/* Max supported ethernet packet size */
 
 	/* Derived from the registry: */
-	u8 ai_force_duplex;	/* duplex setting */
-	u16 ai_force_speed;	/* 'Speed', user over-ride of line speed */
 	u8 flowcontrol;		/* flow control validated by the far-end */
 
 	/* Minimize init-time */
-- 
1.7.6

