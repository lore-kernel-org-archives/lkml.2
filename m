Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934039Ab2HWOr5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 10:47:57 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54356 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757928Ab2HWOry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 10:47:54 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: wm8994: Implement support for WM1811 devices with higher cust_ids
Date: Thu, 23 Aug 2012 15:47:52 +0100
Message-Id: <1345733272-18570-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Higher cust_ids have had the device revision field reset so need different
handling of GPIO6.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8994-regmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/wm8994-regmap.c b/drivers/mfd/wm8994-regmap.c
index 52e9e29..2fbce9c 100644
--- a/drivers/mfd/wm8994-regmap.c
+++ b/drivers/mfd/wm8994-regmap.c
@@ -1136,7 +1136,7 @@ static bool wm1811_volatile_register(struct device *dev, unsigned int reg)
 
 	switch (reg) {
 	case WM8994_GPIO_6:
-		if (wm8994->revision > 1)
+		if (wm8994->cust_id > 1 || wm8994->revision > 1)
 			return true;
 		else
 			return false;
-- 
1.7.10.4

