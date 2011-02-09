Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab1BIOC7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 09:02:59 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44431 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755355Ab1BIOCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 09:02:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=U31t3YPfhAzX8F9xfTB9pvVkXLdJsmIdfzDeE+M4vRLdVfW6RBcg/stAsSj7J2KgM1
         q2CQkry3EBbM0SCeCK58RtpLPi0BK45QaGbvuzaxVQev4/Uf6m8G9OERHjJ2oq3oe+FM
         BSOp+e6/YSXvYXz9Qd4VtAEDj1uodIVWt9oAU=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 3/9] staging: ft1000: Fix return values type.
Date: Wed,  9 Feb 2011 15:02:36 +0100
Message-Id: <1297260162-19263-3-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297260162-19263-1-git-send-email-marek.belisko@open-nandra.com>
References: <1297260162-19263-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change return values type from u16 to int because all functions
use ft1000_control function which return int.

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c   |   32 +++++++++++-----------
 drivers/staging/ft1000/ft1000-usb/ft1000_proc.c |    2 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h  |   16 +++++-----
 3 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index bb28a2b..e9d79e8 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -101,9 +101,9 @@ static int ft1000_control(struct ft1000_device *ft1000dev, unsigned int pipe,
 //
 //---------------------------------------------------------------------------
 
-u16 ft1000_read_register(struct ft1000_device *ft1000dev, u16* Data, u16 nRegIndx)
+int ft1000_read_register(struct ft1000_device *ft1000dev, u16* Data, u16 nRegIndx)
 {
-    u16 ret = STATUS_SUCCESS;
+    int ret = STATUS_SUCCESS;
 
     //DEBUG("ft1000_read_register: reg index is %d\n", nRegIndx);
     //DEBUG("ft1000_read_register: spin_lock locked\n");
@@ -140,9 +140,9 @@ u16 ft1000_read_register(struct ft1000_device *ft1000dev, u16* Data, u16 nRegInd
 // Notes:
 //
 //---------------------------------------------------------------------------
-u16 ft1000_write_register(struct ft1000_device *ft1000dev, u16 value, u16 nRegIndx)
+int ft1000_write_register(struct ft1000_device *ft1000dev, u16 value, u16 nRegIndx)
 {
-     u16 ret = STATUS_SUCCESS;
+     int ret = STATUS_SUCCESS;
 
      //DEBUG("ft1000_write_register: value is: %d, reg index is: %d\n", value, nRegIndx);
 
@@ -176,9 +176,9 @@ u16 ft1000_write_register(struct ft1000_device *ft1000dev, u16 value, u16 nRegIn
 //
 //---------------------------------------------------------------------------
 
-u16 ft1000_read_dpram32(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer, u16 cnt)
+int ft1000_read_dpram32(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer, u16 cnt)
 {
-    u16 ret = STATUS_SUCCESS;
+    int ret = STATUS_SUCCESS;
 
     //DEBUG("ft1000_read_dpram32: indx: %d  cnt: %d\n", indx, cnt);
     ret =ft1000_control(ft1000dev,
@@ -215,9 +215,9 @@ u16 ft1000_read_dpram32(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer, u
 // Notes:
 //
 //---------------------------------------------------------------------------
-u16 ft1000_write_dpram32(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer, u16 cnt)
+int ft1000_write_dpram32(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer, u16 cnt)
 {
-     u16 ret = STATUS_SUCCESS;
+     int ret = STATUS_SUCCESS;
 
      //DEBUG("ft1000_write_dpram32: indx: %d   buffer: %x cnt: %d\n", indx, buffer, cnt);
      if ( cnt % 4)
@@ -252,9 +252,9 @@ u16 ft1000_write_dpram32(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer,
 // Notes:
 //
 //---------------------------------------------------------------------------
-u16 ft1000_read_dpram16(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer, u8 highlow)
+int ft1000_read_dpram16(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer, u8 highlow)
 {
-    u16 ret = STATUS_SUCCESS;
+    int ret = STATUS_SUCCESS;
 
     //DEBUG("ft1000_read_dpram16: indx: %d  hightlow: %d\n", indx, highlow);
 
@@ -300,9 +300,9 @@ u16 ft1000_read_dpram16(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer, u
 // Notes:
 //
 //---------------------------------------------------------------------------
-u16 ft1000_write_dpram16(struct ft1000_device *ft1000dev, u16 indx, u16 value, u8 highlow)
+int ft1000_write_dpram16(struct ft1000_device *ft1000dev, u16 indx, u16 value, u8 highlow)
 {
-     u16 ret = STATUS_SUCCESS;
+     int ret = STATUS_SUCCESS;
 
 
 
@@ -345,11 +345,11 @@ u16 ft1000_write_dpram16(struct ft1000_device *ft1000dev, u16 indx, u16 value, u
 // Notes:
 //
 //---------------------------------------------------------------------------
-u16 fix_ft1000_read_dpram32(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer)
+int fix_ft1000_read_dpram32(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer)
 {
     u8 buf[16];
     u16 pos;
-    u16 ret = STATUS_SUCCESS;
+    int ret = STATUS_SUCCESS;
 
     //DEBUG("fix_ft1000_read_dpram32: indx: %d  \n", indx);
     pos = (indx / 4)*4;
@@ -394,7 +394,7 @@ u16 fix_ft1000_read_dpram32(struct ft1000_device *ft1000dev, u16 indx, u8 *buffe
 // Notes:
 //
 //---------------------------------------------------------------------------
-u16 fix_ft1000_write_dpram32(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer)
+int fix_ft1000_write_dpram32(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer)
 {
     u16 pos1;
     u16 pos2;
@@ -402,7 +402,7 @@ u16 fix_ft1000_write_dpram32(struct ft1000_device *ft1000dev, u16 indx, u8 *buff
     u8 buf[32];
     u8 resultbuffer[32];
     u8 *pdata;
-    u16 ret  = STATUS_SUCCESS;
+    int ret  = STATUS_SUCCESS;
 
     //DEBUG("fix_ft1000_write_dpram32: Entered:\n");
 
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c b/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
index b87542a..5ae3967 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
@@ -51,7 +51,7 @@
 #define FTNET_PROC init_net.proc_net
 
 
-u16 ft1000_read_dpram16 (struct ft1000_device *ft1000dev, u16 indx,
+int ft1000_read_dpram16 (struct ft1000_device *ft1000dev, u16 indx,
 			 u8 *buffer, u8 highlow);
 
 
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
index a143e9c..88183fe 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
@@ -560,14 +560,14 @@ struct dpram_blk {
     u16 *pbuffer;
 } __attribute__ ((packed));
 
-u16 ft1000_read_register(struct ft1000_device *ft1000dev, u16* Data, u16 nRegIndx);
-u16 ft1000_write_register(struct ft1000_device *ft1000dev, u16 value, u16 nRegIndx);
-u16 ft1000_read_dpram32(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer, u16 cnt);
-u16 ft1000_write_dpram32(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer, u16 cnt);
-u16 ft1000_read_dpram16(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer, u8 highlow);
-u16 ft1000_write_dpram16(struct ft1000_device *ft1000dev, u16 indx, u16 value, u8 highlow);
-u16 fix_ft1000_read_dpram32(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer);
-u16 fix_ft1000_write_dpram32(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer);
+int ft1000_read_register(struct ft1000_device *ft1000dev, u16* Data, u16 nRegIndx);
+int ft1000_write_register(struct ft1000_device *ft1000dev, u16 value, u16 nRegIndx);
+int ft1000_read_dpram32(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer, u16 cnt);
+int ft1000_write_dpram32(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer, u16 cnt);
+int ft1000_read_dpram16(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer, u8 highlow);
+int ft1000_write_dpram16(struct ft1000_device *ft1000dev, u16 indx, u16 value, u8 highlow);
+int fix_ft1000_read_dpram32(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer);
+int fix_ft1000_write_dpram32(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer);
 
 extern void *pFileStart;
 extern size_t FileLength;
-- 
1.7.1

