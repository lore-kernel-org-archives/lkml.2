Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab1H2RpL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 13:45:11 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57860 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023Ab1H2RoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 13:44:07 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: greg@kroah.com, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 3/6] staging: et131x: Remove unused xcvr_id in struct ce_stats
Date: Mon, 29 Aug 2011 18:42:38 +0100
Message-Id: <1314639761-4947-3-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1314639761-4947-1-git-send-email-mark.einon@gmail.com>
References: <1314639761-4947-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xcvr_id holds the phy ID which is stored but never used in the driver.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et1310_phy.c     |    4 ----
 drivers/staging/et131x/et131x_adapter.h |    1 -
 2 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/et131x/et1310_phy.c b/drivers/staging/et131x/et1310_phy.c
index c845c27..21e0704 100644
--- a/drivers/staging/et131x/et1310_phy.c
+++ b/drivers/staging/et131x/et1310_phy.c
@@ -242,7 +242,6 @@ int et131x_xcvr_find(struct et131x_adapter *adapter)
 	u8 xcvr_addr;
 	u16 idr1;
 	u16 idr2;
-	u32 xcvr_id;
 
 	/* We need to get xcvr id and address we just get the first one */
 	for (xcvr_addr = 0; xcvr_addr < 32; xcvr_addr++) {
@@ -254,10 +253,7 @@ int et131x_xcvr_find(struct et131x_adapter *adapter)
 			     (u8) offsetof(struct mi_regs, idr2),
 			     &idr2);
 
-		xcvr_id = (u32) ((idr1 << 16) | idr2);
-
 		if (idr1 != 0 && idr1 != 0xffff) {
-			adapter->stats.xcvr_id = xcvr_id;
 			adapter->stats.xcvr_addr = xcvr_addr;
 			return 0;
 		}
diff --git a/drivers/staging/et131x/et131x_adapter.h b/drivers/staging/et131x/et131x_adapter.h
index 762e07c..b03460b 100644
--- a/drivers/staging/et131x/et131x_adapter.h
+++ b/drivers/staging/et131x/et131x_adapter.h
@@ -115,7 +115,6 @@ struct ce_stats {
 
 	/* Transceiver state informations. */
 	u8		xcvr_addr;
-	u32		xcvr_id;
 
 	/* Tx Statistics. */
 	u32		tx_underflows;
-- 
1.7.6

