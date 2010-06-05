Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933813Ab0FEXd2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 19:33:28 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:58348 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933798Ab0FEXdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 19:33:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=jaH15UZ47WDPXp92Abp8C2uIJ1nRWz+DbFV/qvu+eEG9wLcxt58Pb8xz6px+ro/qKn
         M079fe/W43O0M+m2mg65uGJc+1pttV6xZhRB5aIdtPp3CmRZVwdTfCJgQmY2OOsjGqSg
         W2QxkyGoLOru+m2AX8AyoBLkvQ5yKcGUk2W0Q=
From: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
To: Arnaud Patard <apatard@mandriva.com>
Cc: linux-kernel@vger.kernel.org,
       Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
Subject: [PATCH 1/6] More ifdefery cleanup.
Date: Sun,  6 Jun 2010 01:33:11 +0200
Message-Id: <1275780796-17751-2-git-send-email-riccardo.magliocchetti@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1275780796-17751-1-git-send-email-riccardo.magliocchetti@gmail.com>
References: <1275780796-17751-1-git-send-email-riccardo.magliocchetti@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
---
 drivers/staging/xgifb/vb_struct.h |    9 ---------
 drivers/staging/xgifb/vgatypes.h  |   12 ------------
 2 files changed, 0 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/xgifb/vb_struct.h b/drivers/staging/xgifb/vb_struct.h
index bb25c0e..1302d8f 100644
--- a/drivers/staging/xgifb/vb_struct.h
+++ b/drivers/staging/xgifb/vb_struct.h
@@ -1,15 +1,6 @@
 #ifndef _VB_STRUCT_
 #define _VB_STRUCT_
 
-#ifdef _INITNEW_
-#define EXTERN
-#else
-#define EXTERN extern
-#endif
-
-
-
-
 typedef struct _XGI_PanelDelayTblStruct
 {
  UCHAR timer[2];
diff --git a/drivers/staging/xgifb/vgatypes.h b/drivers/staging/xgifb/vgatypes.h
index 7ca84fe..3df7a39 100644
--- a/drivers/staging/xgifb/vgatypes.h
+++ b/drivers/staging/xgifb/vgatypes.h
@@ -74,7 +74,6 @@ typedef unsigned long XGIIOADDRESS;
 #define VBIOS_VER_MAX_LENGTH    4
 #endif
 
-#ifndef XGI_VB_CHIP_TYPE
 typedef enum _XGI_VB_CHIP_TYPE {
     VB_CHIP_Legacy = 0,
     VB_CHIP_301,
@@ -88,9 +87,7 @@ typedef enum _XGI_VB_CHIP_TYPE {
     VB_CHIP_UNKNOWN, /* other video bridge or no video bridge */
     MAX_VB_CHIP
 } XGI_VB_CHIP_TYPE;
-#endif
 
-#ifndef XGI_LCD_TYPE
 typedef enum _XGI_LCD_TYPE {
     LCD_INVALID = 0,
     LCD_320x480,       /* FSTN, DSTN */
@@ -116,17 +113,12 @@ typedef enum _XGI_LCD_TYPE {
     LCD_CUSTOM,
     LCD_UNKNOWN
 } XGI_LCD_TYPE;
-#endif
 
-#ifndef PXGI_DSReg
 typedef struct _XGI_DSReg
 {
   UCHAR  jIdx;
   UCHAR  jVal;
 } XGI_DSReg, *PXGI_DSReg;
-#endif
-
-#ifndef XGI_HW_DEVICE_INFO
 
 typedef struct _XGI_HW_DEVICE_INFO  XGI_HW_DEVICE_INFO, *PXGI_HW_DEVICE_INFO;
 
@@ -194,9 +186,6 @@ struct _XGI_HW_DEVICE_INFO
                                  /* end data :(idx, val) =  (FF, FF) */
                                  /* Note : restore cR registers if  */
                                  /* bSkipDramSizing = TRUE */
-/*
-#endif
-*/
 
     PXGI_QUERYSPACE  pQueryVGAConfigSpace;
 
@@ -205,7 +194,6 @@ struct _XGI_HW_DEVICE_INFO
     UCHAR  szVBIOSVer[VBIOS_VER_MAX_LENGTH];
 
 };
-#endif
 
 #endif
 
-- 
1.7.1

