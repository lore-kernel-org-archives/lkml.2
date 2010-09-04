Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365Ab0IDXJb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 19:09:31 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60212 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267Ab0IDXJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 19:09:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=arv+bbNxTVG8z9F673exNIlVOWY6Z8qTAv14K8VmqwAeg589jCgaaDVSXAH9T/4/ct
         Xc08DnMK2Sz1KeQrHKkJNDnATe8YRAsap6jQOtgqxA94ofifrsjeQGPhfskTc+IaSrnG
         dvlDTrDhKjV0275vTA/et/RWSWd1w4DcRl+DM=
Subject: [PATCH 4/4] staging: xgifb: Init uninitialized variables and fix
 some style issues
From: Javier Martinez Canillas <martinez.javier@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Bill Pemberton <wfp5p@virginia.edu>,
        Arnaud Patard <apatard@mandriva.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Huang Weiyi <weiyi.huang@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 04 Sep 2010 19:09:25 -0400
Message-ID: <1283641765.9641.7.camel@lenovo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
---
 drivers/staging/xgifb/vb_setmode.c |   35 +++++++++++++++++------------------
 1 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index cf6874b..bcd3083 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -399,21 +399,20 @@ void InitTo330Pointer(unsigned char ChipType, struct vb_device_info *pVBInfo)
 unsigned char XGISetModeNew(struct xgi_hw_device_info *HwDeviceExtension,
 			    unsigned short ModeNo)
 {
-    unsigned short ModeIdIndex ;
-        /* unsigned char *pVBInfo->FBAddr = HwDeviceExtension->pjVideoMemoryAddress ; */
-    struct vb_device_info VBINF;
-    struct vb_device_info *pVBInfo = &VBINF;
-    pVBInfo->ROMAddr = HwDeviceExtension->pjVirtualRomBase ;
-    pVBInfo->BaseAddr = (unsigned long)HwDeviceExtension->pjIOAddress ;
-    pVBInfo->IF_DEF_LVDS = 0 ;
-    pVBInfo->IF_DEF_CH7005 = 0 ;
-    pVBInfo->IF_DEF_LCDA = 1 ;
-    pVBInfo->IF_DEF_CH7017 = 0 ;
-    pVBInfo->IF_DEF_CH7007 = 0 ;                                /* [Billy] 2007/05/14 */
-    pVBInfo->IF_DEF_VideoCapture = 0 ;
-    pVBInfo->IF_DEF_ScaleLCD = 0 ;
-    pVBInfo->IF_DEF_OEMUtil = 0 ;
-    pVBInfo->IF_DEF_PWD = 0 ;
+	unsigned short ModeIdIndex = 0;
+	struct vb_device_info VBINF;
+	struct vb_device_info *pVBInfo = &VBINF;
+	pVBInfo->ROMAddr = HwDeviceExtension->pjVirtualRomBase;
+	pVBInfo->BaseAddr = (unsigned long)HwDeviceExtension->pjIOAddress;
+	pVBInfo->IF_DEF_LVDS = 0;
+	pVBInfo->IF_DEF_CH7005 = 0;
+	pVBInfo->IF_DEF_LCDA = 1;
+	pVBInfo->IF_DEF_CH7017 = 0;
+	pVBInfo->IF_DEF_CH7007 = 0;		/* [Billy] 2007/05/14 */
+	pVBInfo->IF_DEF_VideoCapture = 0;
+	pVBInfo->IF_DEF_ScaleLCD = 0;
+	pVBInfo->IF_DEF_OEMUtil = 0;
+	pVBInfo->IF_DEF_PWD = 0;
 
 
     if ( HwDeviceExtension->jChipType >= XG20 )			/* kuku 2004/06/25 */
@@ -4444,9 +4443,9 @@ unsigned char XGI_SetCRT2Group301(unsigned short ModeNo,
 				  struct xgi_hw_device_info *HwDeviceExtension,
 				  struct vb_device_info *pVBInfo)
 {
-    unsigned short tempbx ,
-           ModeIdIndex ,
-           RefreshRateTableIndex ;
+	unsigned short tempbx,
+	ModeIdIndex = 0,
+	RefreshRateTableIndex;
 
     tempbx=pVBInfo->VBInfo ;
     pVBInfo->SetFlag |= ProgrammingCRT2 ;
-- 
1.7.0.4



