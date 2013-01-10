Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab3AJMUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 07:20:55 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41523 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754273Ab3AJMS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 07:18:59 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/9] mfd: wm5102: Mark only extant DSP registers volatile
Date: Thu, 10 Jan 2013 12:18:45 +0000
Message-Id: <1357820332-14586-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357820332-14586-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130110121828.GN20956@opensource.wolfsonmicro.com>
 <1357820332-14586-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since regmap sometimes uses volatile as a proxy for readable simply
having a blanket condition can mark too many registers as readable.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm5102-tables.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/wm5102-tables.c b/drivers/mfd/wm5102-tables.c
index 4a01192..0317d11 100644
--- a/drivers/mfd/wm5102-tables.c
+++ b/drivers/mfd/wm5102-tables.c
@@ -1837,9 +1837,6 @@ static bool wm5102_readable_register(struct device *dev, unsigned int reg)
 
 static bool wm5102_volatile_register(struct device *dev, unsigned int reg)
 {
-	if (reg > 0xffff)
-		return true;
-
 	switch (reg) {
 	case ARIZONA_SOFTWARE_RESET:
 	case ARIZONA_DEVICE_REVISION:
@@ -1884,7 +1881,13 @@ static bool wm5102_volatile_register(struct device *dev, unsigned int reg)
 	case ARIZONA_MIC_DETECT_3:
 		return true;
 	default:
-		return false;
+		if ((reg >= 0x100000 && reg < 0x106000) ||
+		    (reg >= 0x180000 && reg < 0x180800) ||
+		    (reg >= 0x190000 && reg < 0x194800) ||
+		    (reg >= 0x1a8000 && reg < 0x1a9800))
+			return true;
+		else
+			return false;
 	}
 }
 
-- 
1.7.10.4

