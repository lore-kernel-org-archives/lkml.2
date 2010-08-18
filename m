Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942Ab0HRGUZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 02:20:25 -0400
Received: from smtp.nokia.com ([192.100.105.134]:59727 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab0HRGUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 02:20:19 -0400
From: felipe.balbi@nokia.com
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Felipe Balbi <felipe.balbi@nokia.com>
Subject: [PATCH 2/4] mfd: twl-core: switch over to defines in twl.h
Date: Wed, 18 Aug 2010 09:19:35 +0300
Message-Id: <1282112377-1335-3-git-send-email-felipe.balbi@nokia.com>
X-Mailer: git-send-email 1.7.2.1.6.g61bf12
In-Reply-To: <1282112377-1335-1-git-send-email-felipe.balbi@nokia.com>
References: <1282112377-1335-1-git-send-email-felipe.balbi@nokia.com>
X-OriginalArrivalTime: 18 Aug 2010 06:19:49.0931 (UTC) FILETIME=[5CE23FB0:01CB3E9D]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felipe Balbi <felipe.balbi@nokia.com>

use the new definitions on twl header for code
consistency.

Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
---
 drivers/mfd/twl-core.c |   21 +++++++++------------
 1 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index 720e099..9689ecf 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -202,12 +202,6 @@
 
 /* Few power values */
 #define R_CFG_BOOT			0x05
-#define R_PROTECT_KEY			0x0E
-
-/* access control values for R_PROTECT_KEY */
-#define KEY_UNLOCK1			0xce
-#define KEY_UNLOCK2			0xec
-#define KEY_LOCK			0x00
 
 /* some fields in R_CFG_BOOT */
 #define HFCLK_FREQ_19p2_MHZ		(1 << 0)
@@ -846,8 +840,8 @@ static inline int __init protect_pm_master(void)
 {
 	int e = 0;
 
-	e = twl_i2c_write_u8(TWL_MODULE_PM_MASTER, KEY_LOCK,
-			R_PROTECT_KEY);
+	e = twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER, 0,
+			TWL4030_PM_MASTER_PROTECT_KEY);
 	return e;
 }
 
@@ -855,10 +849,13 @@ static inline int __init unprotect_pm_master(void)
 {
 	int e = 0;
 
-	e |= twl_i2c_write_u8(TWL_MODULE_PM_MASTER, KEY_UNLOCK1,
-			R_PROTECT_KEY);
-	e |= twl_i2c_write_u8(TWL_MODULE_PM_MASTER, KEY_UNLOCK2,
-			R_PROTECT_KEY);
+	e |= twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER,
+			TWL4030_PM_MASTER_KEY_CFG1,
+			TWL4030_PM_MASTER_PROTECT_KEY);
+	e |= twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER,
+			TWL4030_PM_MASTER_KEY_CFG2,
+			TWL4030_PM_MASTER_PROTECT_KEY);
+
 	return e;
 }
 
-- 
1.7.2.1.6.g61bf12

