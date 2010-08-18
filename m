Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014Ab0HRGUc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 02:20:32 -0400
Received: from smtp.nokia.com ([192.100.122.233]:48413 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab0HRGU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 02:20:26 -0400
From: felipe.balbi@nokia.com
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Felipe Balbi <felipe.balbi@nokia.com>
Subject: [PATCH 4/4] usb: otg: twl4030-usb: switch over to defines in twl.h
Date: Wed, 18 Aug 2010 09:19:37 +0300
Message-Id: <1282112377-1335-5-git-send-email-felipe.balbi@nokia.com>
X-Mailer: git-send-email 1.7.2.1.6.g61bf12
In-Reply-To: <1282112377-1335-1-git-send-email-felipe.balbi@nokia.com>
References: <1282112377-1335-1-git-send-email-felipe.balbi@nokia.com>
X-OriginalArrivalTime: 18 Aug 2010 06:19:53.0954 (UTC) FILETIME=[5F481C20:01CB3E9D]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felipe Balbi <felipe.balbi@nokia.com>

use the new definitions on twl header for code
consistency.

Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
---
 drivers/usb/otg/twl4030-usb.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/otg/twl4030-usb.c b/drivers/usb/otg/twl4030-usb.c
index 0e88885..c9b7a87 100644
--- a/drivers/usb/otg/twl4030-usb.c
+++ b/drivers/usb/otg/twl4030-usb.c
@@ -124,7 +124,6 @@
 #define PHY_DPLL_CLK			(1 << 0)
 
 /* In module TWL4030_MODULE_PM_MASTER */
-#define PROTECT_KEY			0x0E
 #define STS_HW_CONDITIONS		0x0F
 
 /* In module TWL4030_MODULE_PM_RECEIVER */
@@ -405,8 +404,13 @@ static void twl4030_phy_resume(struct twl4030_usb *twl)
 static int twl4030_usb_ldo_init(struct twl4030_usb *twl)
 {
 	/* Enable writing to power configuration registers */
-	twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER, 0xC0, PROTECT_KEY);
-	twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER, 0x0C, PROTECT_KEY);
+	twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER,
+			TWL4030_PM_MASTER_KEY_CFG1,
+			TWL4030_PM_MASTER_PROTECT_KEY);
+
+	twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER,
+			TWL4030_PM_MASTER_KEY_CFG2,
+			TWL4030_PM_MASTER_PROTECT_KEY);
 
 	/* put VUSB3V1 LDO in active state */
 	twl_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0, VUSB_DEDICATED2);
@@ -442,7 +446,8 @@ static int twl4030_usb_ldo_init(struct twl4030_usb *twl)
 	twl_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0, VUSB1V8_TYPE);
 
 	/* disable access to power configuration registers */
-	twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER, 0, PROTECT_KEY);
+	twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER, 0,
+			TWL4030_PM_MASTER_PROTECT_KEY);
 
 	return 0;
 
-- 
1.7.2.1.6.g61bf12

