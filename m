Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab1AYLb6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 06:31:58 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39955 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241Ab1AYLbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 06:31:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=ni+IHIvy4HXL/lcYD3IINY5ebK5rk6Cqa5wTJIfcqyJVxJYbwuzI5+lOmL3dRbwK4A
         v3f13dGZt/+yJKLBBhQqAe24bXSe+H5iHUHokZjD1CzX5l3LEMxWAogpkFJegLngTiQa
         NvZv5HtuN7ZW3QQZkDx/t9bCsoEF1kFyjQzuM=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH resend 08/12] staging: ft1000: Fix coding style in get_request_type_usb() function.
Date: Tue, 25 Jan 2011 12:31:19 +0100
Message-Id: <1295955083-11086-8-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1295955083-11086-1-git-send-email-marek.belisko@open-nandra.com>
References: <1295955083-11086-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 .../staging/ft1000/ft1000-usb/ft1000_download.c    |   48 +++++++++----------
 1 files changed, 23 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
index bf20e64..3b56661 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
@@ -364,34 +364,32 @@ static u16 get_request_type(struct ft1000_device *ft1000dev)
 
 static u16 get_request_type_usb(struct ft1000_device *ft1000dev)
 {
-   u16   request_type;
-   u32    status;
-   u16   tempword;
-   u32    tempx;
+	u16   request_type;
+	u32    status;
+	u16   tempword;
+	u32    tempx;
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

