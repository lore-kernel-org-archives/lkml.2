Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab2LARPC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 12:15:02 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46645 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752624Ab2LARPA (ORCPT
	<rfc822;linux-kernel@Vger.kernel.org>);
	Sat, 1 Dec 2012 12:15:00 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: wm5102: Add readback of DSP status 3 register
Date: Sun,  2 Dec 2012 02:14:56 +0900
Message-Id: <1354382096-26277-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm5102-tables.c           |    2 ++
 include/linux/mfd/arizona/registers.h |    1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/mfd/wm5102-tables.c b/drivers/mfd/wm5102-tables.c
index e9063ab..b82a003 100644
--- a/drivers/mfd/wm5102-tables.c
+++ b/drivers/mfd/wm5102-tables.c
@@ -1822,6 +1822,7 @@ static bool wm5102_readable_register(struct device *dev, unsigned int reg)
 	case ARIZONA_DSP1_CLOCKING_1:
 	case ARIZONA_DSP1_STATUS_1:
 	case ARIZONA_DSP1_STATUS_2:
+	case ARIZONA_DSP1_STATUS_3:
 		return true;
 	default:
 		if ((reg >= 0x100000 && reg < 0x106000) ||
@@ -1878,6 +1879,7 @@ static bool wm5102_volatile_register(struct device *dev, unsigned int reg)
 	case ARIZONA_AOD_IRQ_RAW_STATUS:
 	case ARIZONA_DSP1_STATUS_1:
 	case ARIZONA_DSP1_STATUS_2:
+	case ARIZONA_DSP1_STATUS_3:
 	case ARIZONA_HEADPHONE_DETECT_2:
 	case ARIZONA_MIC_DETECT_3:
 		return true;
diff --git a/include/linux/mfd/arizona/registers.h b/include/linux/mfd/arizona/registers.h
index ba26e99..1f6fe31 100644
--- a/include/linux/mfd/arizona/registers.h
+++ b/include/linux/mfd/arizona/registers.h
@@ -981,6 +981,7 @@
 #define ARIZONA_DSP1_CLOCKING_1                  0x1101
 #define ARIZONA_DSP1_STATUS_1                    0x1104
 #define ARIZONA_DSP1_STATUS_2                    0x1105
+#define ARIZONA_DSP1_STATUS_3                    0x1106
 #define ARIZONA_DSP2_CONTROL_1                   0x1200
 #define ARIZONA_DSP2_CLOCKING_1                  0x1201
 #define ARIZONA_DSP2_STATUS_1                    0x1204
-- 
1.7.10.4

