Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976Ab2K0PXf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 10:23:35 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51831 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755875Ab2K0PXe (ORCPT
	<rfc822;linux-kernel@Vger.kernel.org>);
	Tue, 27 Nov 2012 10:23:34 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: wm8994: Make current device behaviour the default
Date: Tue, 27 Nov 2012 15:23:30 +0000
Message-Id: <1354029811-25302-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the wm8994 series of devices are now very mature make the current
behaviour of the devices the default behaviour, any future revisions are
likely to have only minor updates.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8994-core.c |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index 2f6f7db..0596d61 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -596,11 +596,10 @@ static __devinit int wm8994_device_init(struct wm8994 *wm8994, int irq)
 			break;
 		case 2:
 		case 3:
+		default:
 			regmap_patch = wm8994_revc_patch;
 			patch_regs = ARRAY_SIZE(wm8994_revc_patch);
 			break;
-		default:
-			break;
 		}
 		break;
 
@@ -619,18 +618,9 @@ static __devinit int wm8994_device_init(struct wm8994 *wm8994, int irq)
 		/* Revision C did not change the relevant layer */
 		if (wm8994->revision > 1)
 			wm8994->revision++;
-		switch (wm8994->revision) {
-		case 0:
-		case 1:
-		case 2:
-		case 3:
-		case 4:
-			regmap_patch = wm1811_reva_patch;
-			patch_regs = ARRAY_SIZE(wm1811_reva_patch);
-			break;
-		default:
-			break;
-		}
+
+		regmap_patch = wm1811_reva_patch;
+		patch_regs = ARRAY_SIZE(wm1811_reva_patch);
 		break;
 
 	default:
-- 
1.7.10.4

