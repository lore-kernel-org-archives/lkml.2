Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab1HCJEn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 05:04:43 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53308 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753036Ab1HCJEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 05:04:39 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, stable@kernel.org
Subject: [PATCH] mfd: Fix value of WM8994_CONFIGURE_GPIO
Date: Wed,  3 Aug 2011 18:04:29 +0900
Message-Id: <1312362269-3363-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This needs to be an out of band value for the register and on this device
registers are 16 bit so we must shift left one to the 17th bit.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: stable@kernel.org
---
 include/linux/mfd/wm8994/pdata.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/mfd/wm8994/pdata.h b/include/linux/mfd/wm8994/pdata.h
index d12f8d6..97cf4f2 100644
--- a/include/linux/mfd/wm8994/pdata.h
+++ b/include/linux/mfd/wm8994/pdata.h
@@ -26,7 +26,7 @@ struct wm8994_ldo_pdata {
 	struct regulator_init_data *init_data;
 };
 
-#define WM8994_CONFIGURE_GPIO 0x8000
+#define WM8994_CONFIGURE_GPIO 0x10000
 
 #define WM8994_DRC_REGS 5
 #define WM8994_EQ_REGS  20
-- 
1.7.5.4

