Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454Ab1FBSVc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 14:21:32 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36567 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754188Ab1FBSUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 14:20:04 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 9/9] mfd: Restructure wm8994-core device revision handling
Date: Thu,  2 Jun 2011 19:18:55 +0100
Message-Id: <1307038735-18788-9-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.3
In-Reply-To: <1307038735-18788-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20110602181808.GA18726@opensource.wolfsonmicro.com>
 <1307038735-18788-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch on the device type before revision since anything we do here will
be device as well as revision specific.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8994-core.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index e198d40..18f19b7 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -476,13 +476,18 @@ static int wm8994_device_init(struct wm8994 *wm8994, int irq)
 		goto err_enable;
 	}
 
-	switch (ret) {
-	case 0:
-	case 1:
-		if (wm8994->type == WM8994)
+	switch (wm8994->type) {
+	case WM8994:
+		switch (ret) {
+		case 0:
+		case 1:
 			dev_warn(wm8994->dev,
 				 "revision %c not fully supported\n",
 				 'A' + ret);
+			break;
+		default:
+			break;
+		}
 		break;
 	default:
 		break;
-- 
1.7.5.3

