Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087Ab1E1R6H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 13:58:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52258 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754103Ab1E1R6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 13:58:05 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Restructure wm8994-core device revision handling
Date: Sun, 29 May 2011 01:48:07 +0800
Message-Id: <1306604887-31167-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.1
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
index 877590b..9497c57 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -482,13 +482,18 @@ static int wm8994_device_init(struct wm8994 *wm8994, int irq)
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
1.7.5.1

