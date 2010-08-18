Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161Ab0HRGVH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 02:21:07 -0400
Received: from smtp.nokia.com ([192.100.105.134]:59793 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab0HRGUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 02:20:54 -0400
From: felipe.balbi@nokia.com
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Felipe Balbi <felipe.balbi@nokia.com>
Subject: [PATCH 3/4] mfd: twl4030-power: switch over to defines in twl.h
Date: Wed, 18 Aug 2010 09:19:36 +0300
Message-Id: <1282112377-1335-4-git-send-email-felipe.balbi@nokia.com>
X-Mailer: git-send-email 1.7.2.1.6.g61bf12
In-Reply-To: <1282112377-1335-1-git-send-email-felipe.balbi@nokia.com>
References: <1282112377-1335-1-git-send-email-felipe.balbi@nokia.com>
X-OriginalArrivalTime: 18 Aug 2010 06:19:52.0532 (UTC) FILETIME=[5E6F2140:01CB3E9D]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felipe Balbi <felipe.balbi@nokia.com>

use the new definitions on twl header for code
consistency.

Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
---
 drivers/mfd/twl4030-power.c |   30 ++++++++++++++++--------------
 1 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/mfd/twl4030-power.c b/drivers/mfd/twl4030-power.c
index 7efa878..16422de0 100644
--- a/drivers/mfd/twl4030-power.c
+++ b/drivers/mfd/twl4030-power.c
@@ -63,10 +63,6 @@ static u8 twl4030_start_script_address = 0x2b;
 #define R_MEMORY_ADDRESS	PHY_TO_OFF_PM_MASTER(0x59)
 #define R_MEMORY_DATA		PHY_TO_OFF_PM_MASTER(0x5a)
 
-#define R_PROTECT_KEY		0x0E
-#define R_KEY_1			0xC0
-#define R_KEY_2			0x0C
-
 /* resource configuration registers
    <RESOURCE>_DEV_GRP   at address 'n+0'
    <RESOURCE>_TYPE      at address 'n+1'
@@ -465,15 +461,17 @@ int twl4030_remove_script(u8 flags)
 {
 	int err = 0;
 
-	err = twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER, R_KEY_1,
-			R_PROTECT_KEY);
+	err = twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER,
+			TWL4030_PM_MASTER_KEY_CFG1,
+			TWL4030_PM_MASTER_PROTECT_KEY);
 	if (err) {
 		pr_err("twl4030: unable to unlock PROTECT_KEY\n");
 		return err;
 	}
 
-	err = twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER, R_KEY_2,
-			R_PROTECT_KEY);
+	err = twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER,
+			TWL4030_PM_MASTER_KEY_CFG2,
+			TWL4030_PM_MASTER_PROTECT_KEY);
 	if (err) {
 		pr_err("twl4030: unable to unlock PROTECT_KEY\n");
 		return err;
@@ -504,7 +502,8 @@ int twl4030_remove_script(u8 flags)
 			return err;
 	}
 
-	err = twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER, 0, R_PROTECT_KEY);
+	err = twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER, 0,
+			TWL4030_PM_MASTER_PROTECT_KEY);
 	if (err)
 		pr_err("TWL4030 Unable to relock registers\n");
 
@@ -518,13 +517,15 @@ void __init twl4030_power_init(struct twl4030_power_data *twl4030_scripts)
 	struct twl4030_resconfig *resconfig;
 	u8 address = twl4030_start_script_address;
 
-	err = twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER, R_KEY_1,
-				R_PROTECT_KEY);
+	err = twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER,
+			TWL4030_PM_MASTER_KEY_CFG1,
+			TWL4030_PM_MASTER_PROTECT_KEY);
 	if (err)
 		goto unlock;
 
-	err = twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER, R_KEY_2,
-				R_PROTECT_KEY);
+	err = twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER,
+			TWL4030_PM_MASTER_KEY_CFG2,
+			TWL4030_PM_MASTER_PROTECT_KEY);
 	if (err)
 		goto unlock;
 
@@ -546,7 +547,8 @@ void __init twl4030_power_init(struct twl4030_power_data *twl4030_scripts)
 		}
 	}
 
-	err = twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER, 0, R_PROTECT_KEY);
+	err = twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER, 0,
+			TWL4030_PM_MASTER_PROTECT_KEY);
 	if (err)
 		pr_err("TWL4030 Unable to relock registers\n");
 	return;
-- 
1.7.2.1.6.g61bf12

