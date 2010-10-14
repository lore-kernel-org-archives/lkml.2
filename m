Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab0JNLnL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 07:43:11 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59275 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123Ab0JNLnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 07:43:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=KvfRLCRNwslYVZqEQW46cjAh9VntRf3M8J87UNTCLwVL6uIZN53vMtIJZJMH27qUfI
         YLut6x6HYDFBD/3BOtrAtvdhjWMVQpb7Nz3y3DUQRuZqaMuGXLFTB4kfRXxvq02MkxgZ
         m602yvzMvTrNLyWTMRGn/CeBg4DZPFzswgqd4=
From: Marek Belisko <marek.belisko@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Marek Belisko <marek.belisko@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Vasiliy Kulikov <segooon@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Marek Belisko <marek.belisko@gmail.com>
Subject: [PATCH] staging:ft1000:Use specific error return value.
Date: Thu, 14 Oct 2010 13:36:11 +0200
Message-Id: <1287056171-12215-1-git-send-email-marek.belisko@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c |   30 +++---------------------
 1 files changed, 4 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index d0637c3..507a248 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -141,12 +141,12 @@ static int ft1000_control(struct ft1000_device *ft1000dev,unsigned int pipe,
     if (ft1000dev == NULL )
     {
         DEBUG("NULL ft1000dev, failure\n");
-        return STATUS_FAILURE;
+	return -ENODEV;
     }
     else if ( ft1000dev->dev == NULL )
     {
         DEBUG("NULL ft1000dev->dev, failure\n");
-        return STATUS_FAILURE;
+	return -ENODEV;
     }
 
     ret = usb_control_msg(ft1000dev->dev,
@@ -159,11 +159,8 @@ static int ft1000_control(struct ft1000_device *ft1000dev,unsigned int pipe,
                           size,
                           LARGE_TIMEOUT);
 
-    if (ret>0)
-        ret = STATUS_SUCCESS;
-    else
-        ret = STATUS_FAILURE;
-
+	if (ret > 0)
+		ret = 0;
 
     return ret;
 
@@ -204,8 +201,6 @@ u16 ft1000_read_register(struct ft1000_device *ft1000dev, u16* Data, u16 nRegInd
    //DEBUG("ft1000_read_register: ret is  %d \n", ret);
 
    //DEBUG("ft1000_read_register: data is  %x \n", *Data);
-   if ( ret != STATUS_SUCCESS )
-       return STATUS_FAILURE;
 
    return ret;
 
@@ -242,9 +237,6 @@ u16 ft1000_write_register(struct ft1000_device *ft1000dev, USHORT value, u16 nRe
                            0,
                            LARGE_TIMEOUT );
 
-   if ( ret != STATUS_SUCCESS )
-       return STATUS_FAILURE;
-
     return ret;
 }
 
@@ -283,8 +275,6 @@ u16 ft1000_read_dpram32(struct ft1000_device *ft1000dev, USHORT indx, PUCHAR buf
    //DEBUG("ft1000_read_dpram32: ret is  %d \n", ret);
 
    //DEBUG("ft1000_read_dpram32: ret=%d \n", ret);
-   if ( ret != STATUS_SUCCESS )
-       return STATUS_FAILURE;
 
    return ret;
 
@@ -324,11 +314,6 @@ u16 ft1000_write_dpram32(struct ft1000_device *ft1000dev, USHORT indx, PUCHAR bu
                            cnt,                                //buffer size
                            LARGE_TIMEOUT );
 
-
-   if ( ret != STATUS_SUCCESS )
-       return STATUS_FAILURE;
-
-
     return ret;
 }
 
@@ -375,8 +360,6 @@ u16 ft1000_read_dpram16(struct ft1000_device *ft1000dev, USHORT indx, PUCHAR buf
 
 
    //DEBUG("ft1000_read_dpram16: data is  %x \n", *buffer);
-   if ( ret != STATUS_SUCCESS )
-       return STATUS_FAILURE;
 
    return ret;
 
@@ -424,11 +407,6 @@ u16 ft1000_write_dpram16(struct ft1000_device *ft1000dev, USHORT indx, USHORT va
                            0,                                   //buffer size
                            LARGE_TIMEOUT );
 
-
-   if ( ret != STATUS_SUCCESS )
-       return STATUS_FAILURE;
-
-
     return ret;
 }
 
-- 
1.7.1

