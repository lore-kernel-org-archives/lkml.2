Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab1AYNEr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 08:04:47 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36351 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213Ab1AYNEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 08:04:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=mdMCHbg/AvqSbagCpszvmEX9zlkI9P8gWLIGRaowb8zkdN3dTbFEtSv1EMTD8A3cXs
         fi7WFvgCmh10qnLT5UocwB9E9LmGol/4+3bg5vLk5nl/1yhtskxf3MSIqlf1pVFumg/0
         bXv54HFMcFrJM5aRxB7F5GY9LAFGNgrR/RBMg=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH v2 07/11] staging: ft1000: Fix coding style in get_request_type_usb() function.
Date: Tue, 25 Jan 2011 14:05:02 +0100
Message-Id: <1295960706-15667-8-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1295960706-15667-1-git-send-email-marek.belisko@open-nandra.com>
References: <1295960706-15667-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 .../staging/ft1000/ft1000-usb/ft1000_download.c    |   48 +++++++++----------
 1 files changed, 23 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
index f87b927..3385eac 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
@@ -364,34 +364,32 @@ static u16 get_request_type(struct ft1000_device *ft1000dev)
 
 static u16 get_request_type_usb(struct ft1000_device *ft1000dev)
 {
-   u16   request_type;
-   u32    status;
-   u16   tempword;
-   u32    tempx;
+	u16 request_type;
+	u32 status;
+	u16 tempword;
+	u32 tempx;
 	struct ft1000_info *pft1000info = netdev_priv(ft1000dev->net);
-   if ( pft1000info->bootmode == 1)
-   {
-       status = fix_ft1000_read_dpram32 (ft1000dev, DWNLD_MAG1_TYPE_LOC, (u8 *)&tempx);
-       tempx = ntohl(tempx);
-   }
-   else
-   {
-       if (pft1000info->usbboot == 2) {
-          tempx = pft1000info->tempbuf[2];
-          tempword = pft1000info->tempbuf[3];
-       }
-       else {
-          tempx = 0;
-          status = ft1000_read_dpram16 (ft1000dev, DWNLD_MAG1_TYPE_LOC, (u8 *)&tempword, 1);
-       }
-       tempx |= (tempword << 16);
-       tempx = ntohl(tempx);
-   }
-   request_type = (u16)tempx;
 
-   //DEBUG("get_request_type: request_type is %x\n", request_type);
-   return request_type;
+	if (pft1000info->bootmode == 1) {
+		status = fix_ft1000_read_dpram32(ft1000dev,
+				DWNLD_MAG1_TYPE_LOC, (u8 *)&tempx);
+		tempx = ntohl(tempx);
+	} else {
+		if (pft1000info->usbboot == 2) {
+			tempx = pft1000info->tempbuf[2];
+			tempword = pft1000info->tempbuf[3];
+		} else {
+			tempx = 0;
+			status = ft1000_read_dpram16(ft1000dev,
+					DWNLD_MAG1_TYPE_LOC,
+					(u8 *)&tempword, 1);
+		}
+		tempx |= (tempword << 16);
+		tempx = ntohl(tempx);
+	}
+	request_type = (u16)tempx;
 
+	return request_type;
 }
 
 //---------------------------------------------------------------------------
-- 
1.7.1

