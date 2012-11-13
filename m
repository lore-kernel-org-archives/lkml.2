Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313Ab2KMJmc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 04:42:32 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:35704 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189Ab2KMJma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 04:42:30 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: [PATCH] power: twl4030_charger: Change TWL4030_MODULE_* ids to TWL_MODULE_*
Date: Tue, 13 Nov 2012 10:42:11 +0100
Message-ID: <1352799731-22324-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To facilitate upcoming cleanup in twl stack.
No functional changes.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/power/twl4030_charger.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/power/twl4030_charger.c b/drivers/power/twl4030_charger.c
index f9e70cf..a69d0d1 100644
--- a/drivers/power/twl4030_charger.c
+++ b/drivers/power/twl4030_charger.c
@@ -114,12 +114,12 @@ static int twl4030_clear_set(u8 mod_no, u8 clear, u8 set, u8 reg)
 
 static int twl4030_bci_read(u8 reg, u8 *val)
 {
-	return twl_i2c_read_u8(TWL4030_MODULE_MAIN_CHARGE, val, reg);
+	return twl_i2c_read_u8(TWL_MODULE_MAIN_CHARGE, val, reg);
 }
 
 static int twl4030_clear_set_boot_bci(u8 clear, u8 set)
 {
-	return twl4030_clear_set(TWL4030_MODULE_PM_MASTER, clear,
+	return twl4030_clear_set(TWL_MODULE_PM_MASTER, clear,
 			TWL4030_CONFIG_DONE | TWL4030_BCIAUTOWEN | set,
 			TWL4030_PM_MASTER_BOOT_BCI);
 }
@@ -152,7 +152,7 @@ static int twl4030_bci_have_vbus(struct twl4030_bci *bci)
 	int ret;
 	u8 hwsts;
 
-	ret = twl_i2c_read_u8(TWL4030_MODULE_PM_MASTER, &hwsts,
+	ret = twl_i2c_read_u8(TWL_MODULE_PM_MASTER, &hwsts,
 			      TWL4030_PM_MASTER_STS_HW_CONDITIONS);
 	if (ret < 0)
 		return 0;
@@ -199,7 +199,7 @@ static int twl4030_charger_enable_usb(struct twl4030_bci *bci, bool enable)
 			return ret;
 
 		/* forcing USBFASTMCHG(BCIMFSTS4[2]) to 1 */
-		ret = twl4030_clear_set(TWL4030_MODULE_MAIN_CHARGE, 0,
+		ret = twl4030_clear_set(TWL_MODULE_MAIN_CHARGE, 0,
 			TWL4030_USBFASTMCHG, TWL4030_BCIMFSTS4);
 	} else {
 		ret = twl4030_clear_set_boot_bci(TWL4030_BCIAUTOUSB, 0);
@@ -238,7 +238,7 @@ static int twl4030_charger_enable_backup(int uvolt, int uamp)
 	if (uvolt < 2500000 ||
 	    uamp < 25) {
 		/* disable charging of backup battery */
-		ret = twl4030_clear_set(TWL4030_MODULE_PM_RECEIVER,
+		ret = twl4030_clear_set(TWL_MODULE_PM_RECEIVER,
 					TWL4030_BBCHEN, 0, TWL4030_BB_CFG);
 		return ret;
 	}
@@ -262,7 +262,7 @@ static int twl4030_charger_enable_backup(int uvolt, int uamp)
 	else
 		flags |= TWL4030_BBISEL_25uA;
 
-	ret = twl4030_clear_set(TWL4030_MODULE_PM_RECEIVER,
+	ret = twl4030_clear_set(TWL_MODULE_PM_RECEIVER,
 				TWL4030_BBSEL_MASK | TWL4030_BBISEL_MASK,
 				flags,
 				TWL4030_BB_CFG);
-- 
1.8.0

