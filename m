Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964834Ab2GFKlf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 06:41:35 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:29884 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964787Ab2GFKl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 06:41:27 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av4EAHC/9k9bdWOb/2dsb2JhbABFhWSxVIEHghkBBSMECwFGECUCJgICVwcSiA+nOZMDgSCPLYESA5U3kAOCYQ
X-IronPort-AV: E=Sophos;i="4.77,537,1336341600"; 
   d="scan'208";a="940130689"
From: =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
To: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        aaro.koskinen@iki.fi, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>
Subject: [PATCH 09/19 v2] Staging: xgifb: Remove useless always true condition.
Date: Fri,  6 Jul 2012 12:40:44 +0200
Message-Id: <a48369327a9409f8e17fe5b9cef66b13d61f75a8.1341569486.git.magomez@igalia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1341569486.git.magomez@igalia.com>
References: <cover.1341498465.git.magomez@igalia.com>
 <cover.1341569486.git.magomez@igalia.com>
In-Reply-To: <cover.1341569486.git.magomez@igalia.com>
References: <cover.1341569486.git.magomez@igalia.com>
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

