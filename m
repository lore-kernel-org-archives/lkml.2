Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab1BIOC6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 09:02:58 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36706 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755260Ab1BIOC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 09:02:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=essnIPfvAIzA/HadRImdtMVd0ziBfRfE8fo+mSat5BfFejsx9qDh6d+mK14z/s/Qqr
         9E6hpalMX5zNFQzmFQFKawquIRf6MP5bNoa/O2jRluTN+P70eHk7j2z/lGroRivbyMKj
         duYQwgnuwdS12NTLDoOy5Ac3Ui0gJUIGVATUA=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 4/9] staging: ft1000: Fix coding style in ft1000_write/read_register functions.
Date: Wed,  9 Feb 2011 15:02:37 +0100
Message-Id: <1297260162-19263-4-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297260162-19263-1-git-send-email-marek.belisko@open-nandra.com>
References: <1297260162-19263-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c |   63 +++++++++++--------------
 1 files changed, 28 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index e9d79e8..9b98265 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -101,28 +101,22 @@ static int ft1000_control(struct ft1000_device *ft1000dev, unsigned int pipe,
 //
 //---------------------------------------------------------------------------
 
-int ft1000_read_register(struct ft1000_device *ft1000dev, u16* Data, u16 nRegIndx)
+int ft1000_read_register(struct ft1000_device *ft1000dev, u16* Data,
+			 u16 nRegIndx)
 {
-    int ret = STATUS_SUCCESS;
-
-    //DEBUG("ft1000_read_register: reg index is %d\n", nRegIndx);
-    //DEBUG("ft1000_read_register: spin_lock locked\n");
-    ret = ft1000_control(ft1000dev,
-                         usb_rcvctrlpipe(ft1000dev->dev,0),
-                         HARLEY_READ_REGISTER,   //request --READ_REGISTER
-                         HARLEY_READ_OPERATION,  //requestType
-                         0,                      //value
-                         nRegIndx,               //index
-                         Data,                   //data
-                         2,                      //data size
-                         LARGE_TIMEOUT );        //timeout
-
-   //DEBUG("ft1000_read_register: ret is  %d \n", ret);
-
-   //DEBUG("ft1000_read_register: data is  %x \n", *Data);
-
-   return ret;
+	int ret = STATUS_SUCCESS;
+
+	ret = ft1000_control(ft1000dev,
+			     usb_rcvctrlpipe(ft1000dev->dev, 0),
+			     HARLEY_READ_REGISTER,
+			     HARLEY_READ_OPERATION,
+			     0,
+			     nRegIndx,
+			     Data,
+			     2,
+			     LARGE_TIMEOUT);
 
+	return ret;
 }
 
 //---------------------------------------------------------------------------
@@ -140,23 +134,22 @@ int ft1000_read_register(struct ft1000_device *ft1000dev, u16* Data, u16 nRegInd
 // Notes:
 //
 //---------------------------------------------------------------------------
-int ft1000_write_register(struct ft1000_device *ft1000dev, u16 value, u16 nRegIndx)
+int ft1000_write_register(struct ft1000_device *ft1000dev, u16 value,
+			  u16 nRegIndx)
 {
-     int ret = STATUS_SUCCESS;
-
-     //DEBUG("ft1000_write_register: value is: %d, reg index is: %d\n", value, nRegIndx);
-
-     ret = ft1000_control(ft1000dev,
-                           usb_sndctrlpipe(ft1000dev->dev, 0),
-                           HARLEY_WRITE_REGISTER,       //request -- WRITE_REGISTER
-                           HARLEY_WRITE_OPERATION,      //requestType
-                           value,
-                           nRegIndx,
-                           NULL,
-                           0,
-                           LARGE_TIMEOUT );
+	int ret = STATUS_SUCCESS;
+
+	ret = ft1000_control(ft1000dev,
+			     usb_sndctrlpipe(ft1000dev->dev, 0),
+			     HARLEY_WRITE_REGISTER,
+			     HARLEY_WRITE_OPERATION,
+			     value,
+			     nRegIndx,
+			     NULL,
+			     0,
+			     LARGE_TIMEOUT);
 
-    return ret;
+	return ret;
 }
 
 //---------------------------------------------------------------------------
-- 
1.7.1

