Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab1BUWOW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 17:14:22 -0500
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:32925 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab1BUWOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 17:14:19 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: gregkh@suse.de, arnaud.patard@rtp-net.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] staging: xgifb: delete redundant XGIhw_ext fields
Date: Tue, 22 Feb 2011 00:14:26 +0200
Message-Id: <1298326466-22707-2-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1298326466-22707-1-git-send-email-aaro.koskinen@iki.fi>
References: <1298326466-22707-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pSR and pCR fields can be deleted with no changes in the functionality.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/XGI_main_26.c |   18 ------------------
 drivers/staging/xgifb/vgatypes.h    |   10 ----------
 2 files changed, 0 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index c6ae792..8606e32 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -3029,22 +3029,6 @@ static int __devinit xgifb_probe(struct pci_dev *pdev,
 	/* XGIhw_ext.pQueryNorthBridgeSpace = &XGIfb_query_north_bridge_space; */
 	strcpy(XGIhw_ext.szVBIOSVer, "0.84");
 
-	XGIhw_ext.pSR = vmalloc(sizeof(struct XGI_DSReg) * SR_BUFFER_SIZE);
-	if (XGIhw_ext.pSR == NULL) {
-		printk(KERN_ERR "XGIfb: Fatal error: Allocating SRReg space failed.\n");
-		ret = -ENODEV;
-		goto error;
-	}
-	XGIhw_ext.pSR[0].jIdx = XGIhw_ext.pSR[0].jVal = 0xFF;
-
-	XGIhw_ext.pCR = vmalloc(sizeof(struct XGI_DSReg) * CR_BUFFER_SIZE);
-	if (XGIhw_ext.pCR == NULL) {
-		printk(KERN_ERR "XGIfb: Fatal error: Allocating CRReg space failed.\n");
-		ret = -ENODEV;
-		goto error;
-	}
-	XGIhw_ext.pCR[0].jIdx = XGIhw_ext.pCR[0].jVal = 0xFF;
-
 	if (!XGIvga_enabled) {
 		/* Mapping Max FB Size for 315 Init */
 		XGIhw_ext.pjVideoMemoryAddress = ioremap(xgi_video_info.video_base, 0x10000000);
@@ -3419,8 +3403,6 @@ error_0:
 			   xgi_video_info.video_size);
 error:
 	vfree(XGIhw_ext.pjVirtualRomBase);
-	vfree(XGIhw_ext.pSR);
-	vfree(XGIhw_ext.pCR);
 	framebuffer_release(fb_info);
 	return ret;
 }
diff --git a/drivers/staging/xgifb/vgatypes.h b/drivers/staging/xgifb/vgatypes.h
index 92a9ee5..dacdac3 100644
--- a/drivers/staging/xgifb/vgatypes.h
+++ b/drivers/staging/xgifb/vgatypes.h
@@ -106,16 +106,6 @@ struct xgi_hw_device_info
     unsigned char bIsPowerSaving;     /* True: XGIInit() is invoked by power management,
                                    otherwise by 2nd adapter's initialzation */
 
-    struct XGI_DSReg  *pSR;             /* restore SR registers in initial function. */
-                                 /* end data :(idx, val) =  (FF, FF). */
-                                 /* Note : restore SR registers if  */
-                                 /* bSkipDramSizing = 1 */
-
-    struct XGI_DSReg  *pCR;             /* restore CR registers in initial function. */
-                                 /* end data :(idx, val) =  (FF, FF) */
-                                 /* Note : restore cR registers if  */
-                                 /* bSkipDramSizing = 1 */
-
 	unsigned char(*pQueryVGAConfigSpace)(struct xgi_hw_device_info *,
 					    unsigned long, unsigned long,
 					    unsigned long *);
-- 
1.5.6.5

