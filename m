Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659Ab2DEORA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 10:17:00 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34656 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751421Ab2DEOQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 10:16:59 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: wm8994: Cache chip revision
Date: Thu,  5 Apr 2012 15:16:56 +0100
Message-Id: <1333635416-3905-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need to mark the chip revision registers as volatile, it won't
change at runtime so we can cache it from the device at startup.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8994-regmap.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/wm8994-regmap.c b/drivers/mfd/wm8994-regmap.c
index bfd25af..52e9e29 100644
--- a/drivers/mfd/wm8994-regmap.c
+++ b/drivers/mfd/wm8994-regmap.c
@@ -1122,7 +1122,6 @@ static bool wm8994_volatile_register(struct device *dev, unsigned int reg)
 	case WM8994_RATE_STATUS:
 	case WM8958_MIC_DETECT_3:
 	case WM8994_DC_SERVO_4E:
-	case WM8994_CHIP_REVISION:
 	case WM8994_INTERRUPT_STATUS_1:
 	case WM8994_INTERRUPT_STATUS_2:
 		return true;
-- 
1.7.9.1

