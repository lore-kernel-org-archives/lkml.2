Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722Ab2GEPUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 11:20:41 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:36348 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752702Ab2GEPUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 11:20:38 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av4EAJGv9U9bdWOb/2dsb2JhbABFhV+xSIEHghkBBSMECwFGECUCJgICVwcSiA+mdZJSgSCPRYESA5U3kAOCYQ
X-IronPort-AV: E=Sophos;i="4.77,531,1336341600"; 
   d="scan'208";a="939596334"
From: =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
To: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        aaro.koskinen@iki.fi, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
Subject: [PATCH 09/19] Staging: xgifb: Remove useless always true condition.
Date: Thu,  5 Jul 2012 16:45:52 +0200
Message-Id: <9c16a6965a0622aed63ba911c5c766422839e455.1341498466.git.magomez@igalia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1341498465.git.magomez@igalia.com>
References: <cover.1341498465.git.magomez@igalia.com>
In-Reply-To: <cover.1341498465.git.magomez@igalia.com>
References: <cover.1341498465.git.magomez@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Miguel Gómez <magomez@igalia.com>
---
 drivers/staging/xgifb/vb_init.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/xgifb/vb_init.c b/drivers/staging/xgifb/vb_init.c
index 64935fa..ae10153 100644
--- a/drivers/staging/xgifb/vb_init.c
+++ b/drivers/staging/xgifb/vb_init.c
@@ -1185,13 +1185,11 @@ static void XGINew_GetXG21Sense(struct xgi_hw_device_info *HwDeviceExtension,
 {
 	unsigned char Temp;
 
-#if 1
 	if (pVBInfo->IF_DEF_LVDS) { /* For XG21 LVDS */
 		xgifb_reg_or(pVBInfo->P3d4, 0x32, LCDSense);
 		/* LVDS on chip */
 		xgifb_reg_and_or(pVBInfo->P3d4, 0x38, ~0xE0, 0xC0);
 	} else {
-#endif
 		/* Enable GPIOA/B read  */
 		xgifb_reg_and_or(pVBInfo->P3d4, 0x4A, ~0x03, 0x03);
 		Temp = xgifb_reg_get(pVBInfo->P3d4, 0x48) & 0xC0;
@@ -1214,9 +1212,7 @@ static void XGINew_GetXG21Sense(struct xgi_hw_device_info *HwDeviceExtension,
 			/* Disable read GPIOF */
 			xgifb_reg_and(pVBInfo->P3d4, 0x4A, ~0x20);
 		}
-#if 1
 	}
-#endif
 }
 
 static void XGINew_GetXG27Sense(struct xgi_hw_device_info *HwDeviceExtension,
-- 
1.7.9.5

