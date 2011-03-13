Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109Ab1CMK1G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 06:27:06 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:39909 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019Ab1CMK0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 06:26:23 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: [PATCH v2 10/24] staging: xgifb: use mdelay() for millisecond delays
Date: Sun, 13 Mar 2011 12:26:14 +0200
Message-Id: <1300011988-2109-11-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1300011988-2109-1-git-send-email-aaro.koskinen@iki.fi>
References: <1300011988-2109-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use mdelay() instead of udelay() for millisecond delays.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/vb_init.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/xgifb/vb_init.c b/drivers/staging/xgifb/vb_init.c
index 86d7333..8567696 100644
--- a/drivers/staging/xgifb/vb_init.c
+++ b/drivers/staging/xgifb/vb_init.c
@@ -105,7 +105,7 @@ static void XGINew_DDR1x_MRS_340(unsigned long P3c4, struct vb_device_info *pVBI
 	XGINew_SetReg1(P3c4, 0x16, 0x80);
 
 	if (*pVBInfo->pXGINew_DRAMTypeDefinition != 0x0C) { /* Samsung F Die */
-		DelayUS(3000); /* Delay 67 x 3 Delay15us */
+		mdelay(3);
 		XGINew_SetReg1(P3c4, 0x18, 0x00);
 		XGINew_SetReg1(P3c4, 0x19, 0x20);
 		XGINew_SetReg1(P3c4, 0x16, 0x00);
@@ -117,7 +117,7 @@ static void XGINew_DDR1x_MRS_340(unsigned long P3c4, struct vb_device_info *pVBI
 	XGINew_SetReg1(P3c4, 0x19, 0x01);
 	XGINew_SetReg1(P3c4, 0x16, pVBInfo->SR16[0]);
 	XGINew_SetReg1(P3c4, 0x16, pVBInfo->SR16[1]);
-	DelayUS(1000);
+	mdelay(1);
 	XGINew_SetReg1(P3c4, 0x1B, 0x03);
 	DelayUS(500);
 	XGINew_SetReg1(P3c4, 0x18, pVBInfo->SR15[2][XGINew_RAMType]); /* SR18 */
@@ -292,7 +292,7 @@ static void XGINew_DDR1x_MRS_XG20(unsigned long P3c4, struct vb_device_info *pVB
 	XGINew_SetReg1(P3c4, 0x19, 0x01);
 	XGINew_SetReg1(P3c4, 0x16, 0x03);
 	XGINew_SetReg1(P3c4, 0x16, 0x83);
-	DelayUS(1000);
+	mdelay(1);
 	XGINew_SetReg1(P3c4, 0x1B, 0x03);
 	DelayUS(500);
 	/* XGINew_SetReg1(P3c4, 0x18, 0x31); */
-- 
1.5.6.5

