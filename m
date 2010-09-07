Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab0IGFeT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 01:34:19 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60892 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab0IGFeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 01:34:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=V/OQTkWC2h+FbJRVnIoM3aVIAZgE1xrXrqb5u7i1M2Qz540npCj50ugeK5OcXilWF4
         q7bg+C6PWF9r5wFhseywMKm0EeeZci6YdoIv8lT87Sn/izQXxZU/hcnphtji+hqKBC9U
         ijxSBTwNFWR7TIg62hpg6Oo9UCQXKzcALMuOA=
Subject: [PATCH 3/3] staging: xgifb: Initialize uninitialized variables
From: Javier Martinez Canillas <martinez.javier@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Bill Pemberton <wfp5p@virginia.edu>,
        Arnaud Patard <apatard@mandriva.com>,
        Randy Dunlap <randy.dunlap@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Sep 2010 01:34:05 -0400
Message-ID: <1283837645.6302.10.camel@lenovo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current patch solves compilation warnings in staging/xgifb for using possibly uninitialized variables.

Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
---
 drivers/staging/xgifb/vb_setmode.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index c4db2fc..720a592 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -376,7 +376,7 @@ void InitTo330Pointer(unsigned char ChipType, struct vb_device_info *pVBInfo)
 unsigned char XGISetModeNew(struct xgi_hw_device_info *HwDeviceExtension,
 			unsigned short ModeNo)
 {
-	unsigned short ModeIdIndex;
+	unsigned short ModeIdIndex = 0;
 	/* unsigned char *pVBInfo->FBAddr = HwDeviceExtension->pjVideoMemoryAddress; */
 	struct vb_device_info VBINF;
 	struct vb_device_info *pVBInfo = &VBINF;
@@ -3834,7 +3834,7 @@ unsigned char XGI_SetCRT2Group301(unsigned short ModeNo,
 		struct xgi_hw_device_info *HwDeviceExtension,
 		struct vb_device_info *pVBInfo)
 {
-	unsigned short tempbx, ModeIdIndex, RefreshRateTableIndex;
+	unsigned short tempbx, ModeIdIndex = 0, RefreshRateTableIndex;
 
 	tempbx = pVBInfo->VBInfo;
 	pVBInfo->SetFlag |= ProgrammingCRT2;
-- 
1.7.0.4



