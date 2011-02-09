Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699Ab1BIODr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 09:03:47 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44431 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428Ab1BIOC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 09:02:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=PrM33gGU8qxBOlnbDeyhnOdoQVOB68afG1i+gxQDPpLLI1yK75wmtn58x8ZAVsOfZU
         awadM3sthixuljH6ETrNtJa8ObQMZWNLow2pW5O1OH2IZ16tmcXf+wws41T4AYgMk9Jh
         LqIiUXvXh4SPhJnhe+HaXJshNPG2RNEFSKzNA=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 5/9] staging: ft1000: Fix coding style in ft1000_read/write_dpram32 functions.
Date: Wed,  9 Feb 2011 15:02:38 +0100
Message-Id: <1297260162-19263-5-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297260162-19263-1-git-send-email-marek.belisko@open-nandra.com>
References: <1297260162-19263-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c |   67 +++++++++++-------------
 1 files changed, 31 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 9b98265..be07b42 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -169,27 +169,22 @@ int ft1000_write_register(struct ft1000_device *ft1000dev, u16 value,
 //
 //---------------------------------------------------------------------------
 
-int ft1000_read_dpram32(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer, u16 cnt)
+int ft1000_read_dpram32(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer,
+			u16 cnt)
 {
-    int ret = STATUS_SUCCESS;
-
-    //DEBUG("ft1000_read_dpram32: indx: %d  cnt: %d\n", indx, cnt);
-    ret =ft1000_control(ft1000dev,
-                         usb_rcvctrlpipe(ft1000dev->dev,0),
-                         HARLEY_READ_DPRAM_32,                //request --READ_DPRAM_32
-                         HARLEY_READ_OPERATION,               //requestType
-                         0,                                   //value
-                         indx,                                //index
-                         buffer,                              //data
-                         cnt,                                 //data size
-                         LARGE_TIMEOUT );                     //timeout
-
-   //DEBUG("ft1000_read_dpram32: ret is  %d \n", ret);
-
-   //DEBUG("ft1000_read_dpram32: ret=%d \n", ret);
+	int ret = STATUS_SUCCESS;
 
-   return ret;
+	ret = ft1000_control(ft1000dev,
+			     usb_rcvctrlpipe(ft1000dev->dev, 0),
+			     HARLEY_READ_DPRAM_32,
+			     HARLEY_READ_OPERATION,
+			     0,
+			     indx,
+			     buffer,
+			     cnt,
+			     LARGE_TIMEOUT);
 
+	return ret;
 }
 
 //---------------------------------------------------------------------------
@@ -208,25 +203,25 @@ int ft1000_read_dpram32(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer, u
 // Notes:
 //
 //---------------------------------------------------------------------------
-int ft1000_write_dpram32(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer, u16 cnt)
+int ft1000_write_dpram32(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer,
+			 u16 cnt)
 {
-     int ret = STATUS_SUCCESS;
+	int ret = STATUS_SUCCESS;
 
-     //DEBUG("ft1000_write_dpram32: indx: %d   buffer: %x cnt: %d\n", indx, buffer, cnt);
-     if ( cnt % 4)
-         cnt += cnt - (cnt % 4);
+	if (cnt % 4)
+		cnt += cnt - (cnt % 4);
 
-     ret = ft1000_control(ft1000dev,
-                           usb_sndctrlpipe(ft1000dev->dev, 0),
-                           HARLEY_WRITE_DPRAM_32,              //request -- WRITE_DPRAM_32
-                           HARLEY_WRITE_OPERATION,             //requestType
-                           0,                                  //value
-                           indx,                               //index
-                           buffer,                             //buffer
-                           cnt,                                //buffer size
-                           LARGE_TIMEOUT );
+	ret = ft1000_control(ft1000dev,
+			     usb_sndctrlpipe(ft1000dev->dev, 0),
+			     HARLEY_WRITE_DPRAM_32,
+			     HARLEY_WRITE_OPERATION,
+			     0,
+			     indx,
+			     buffer,
+			     cnt,
+			     LARGE_TIMEOUT);
 
-    return ret;
+	return ret;
 }
 
 //---------------------------------------------------------------------------
-- 
1.7.1

