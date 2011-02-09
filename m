Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667Ab1BIODq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 09:03:46 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36706 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755260Ab1BIOC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 09:02:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=J+aL9Z//BmCNR+wQhmkCmaYyREiTL9C3WKE+A+srdHZdnWEO/v3TeEAvcsmFNMS79w
         VDVGfo+xbnNURWfSiQjkzUrGPG/5Tk2GaLFNQWJqFNQUatllrxmNARnH3eKWF5Kllo4L
         Yr14H5gb4VdH0blYSFgl5F2t9duPBpqu6GxCc=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 6/9] staging: ft1000: Fix coding style in ft1000_read/write_dpram16 functions.
Date: Wed,  9 Feb 2011 15:02:39 +0100
Message-Id: <1297260162-19263-6-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297260162-19263-1-git-send-email-marek.belisko@open-nandra.com>
References: <1297260162-19263-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c |   82 ++++++++++--------------
 1 files changed, 34 insertions(+), 48 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index be07b42..aa4ad7b 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -240,36 +240,28 @@ int ft1000_write_dpram32(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer,
 // Notes:
 //
 //---------------------------------------------------------------------------
-int ft1000_read_dpram16(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer, u8 highlow)
+int ft1000_read_dpram16(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer,
+			u8 highlow)
 {
-    int ret = STATUS_SUCCESS;
-
-    //DEBUG("ft1000_read_dpram16: indx: %d  hightlow: %d\n", indx, highlow);
-
-    u8 request;
-
-    if (highlow == 0 )
-        request = HARLEY_READ_DPRAM_LOW;
-    else
-        request = HARLEY_READ_DPRAM_HIGH;
-
-    ret = ft1000_control(ft1000dev,
-                         usb_rcvctrlpipe(ft1000dev->dev,0),
-                         request,                     //request --READ_DPRAM_H/L
-                         HARLEY_READ_OPERATION,       //requestType
-                         0,                           //value
-                         indx,                        //index
-                         buffer,                      //data
-                         2,                           //data size
-                         LARGE_TIMEOUT );             //timeout
-
-   //DEBUG("ft1000_read_dpram16: ret is  %d \n", ret);
-
+	int ret = STATUS_SUCCESS;
+	u8 request;
 
-   //DEBUG("ft1000_read_dpram16: data is  %x \n", *buffer);
+	if (highlow == 0)
+		request = HARLEY_READ_DPRAM_LOW;
+	else
+		request = HARLEY_READ_DPRAM_HIGH;
 
-   return ret;
+	ret = ft1000_control(ft1000dev,
+			     usb_rcvctrlpipe(ft1000dev->dev, 0),
+			     request,
+			     HARLEY_READ_OPERATION,
+			     0,
+			     indx,
+			     buffer,
+			     2,
+			     LARGE_TIMEOUT);
 
+	return ret;
 }
 
 //---------------------------------------------------------------------------
@@ -290,31 +282,25 @@ int ft1000_read_dpram16(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer, u
 //---------------------------------------------------------------------------
 int ft1000_write_dpram16(struct ft1000_device *ft1000dev, u16 indx, u16 value, u8 highlow)
 {
-     int ret = STATUS_SUCCESS;
-
-
-
-     //DEBUG("ft1000_write_dpram16: indx: %d  value: %d  highlow: %d\n", indx, value, highlow);
-
-     u8 request;
-
+	int ret = STATUS_SUCCESS;
+	u8 request;
 
-     if ( highlow == 0 )
-         request = HARLEY_WRITE_DPRAM_LOW;
-     else
-         request = HARLEY_WRITE_DPRAM_HIGH;
+	if (highlow == 0)
+		request = HARLEY_WRITE_DPRAM_LOW;
+	else
+		request = HARLEY_WRITE_DPRAM_HIGH;
 
-     ret = ft1000_control(ft1000dev,
-                           usb_sndctrlpipe(ft1000dev->dev, 0),
-                           request,                             //request -- WRITE_DPRAM_H/L
-                           HARLEY_WRITE_OPERATION,              //requestType
-                           value,                                   //value
-                           indx,                                //index
-                           NULL,                               //buffer
-                           0,                                   //buffer size
-                           LARGE_TIMEOUT );
+	ret = ft1000_control(ft1000dev,
+			     usb_sndctrlpipe(ft1000dev->dev, 0),
+			     request,
+			     HARLEY_WRITE_OPERATION,
+			     value,
+			     indx,
+			     NULL,
+			     0,
+			     LARGE_TIMEOUT);
 
-    return ret;
+	return ret;
 }
 
 //---------------------------------------------------------------------------
-- 
1.7.1

