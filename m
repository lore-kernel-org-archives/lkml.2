Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab0KCKTZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 06:19:25 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49068 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605Ab0KCKSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 06:18:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=wPEOD/pKaeMShSbpwdb24PaW2mKl/ApqVtBa7DsVEuchK8s5OCjzJ8CEdOL7PirvDZ
         FPmsnbi+rPPKgIFJqg00dk8WZC0jYxghiRSTQoQUKzJAYtvkgQKC66vGr1J8pAPpWnsK
         gjSJP9u5R7fXPnVtuMMy1qgBnNh/4seVXdgDY=
From: Marek Belisko <marek.belisko@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Marek Belisko <marek.belisko@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@gmail.com>
Subject: [PATCH 6/9] staging: ft1000: Get rid of ULONG typedef usage.
Date: Wed,  3 Nov 2010 11:19:52 +0100
Message-Id: <1288779595-15793-6-git-send-email-marek.belisko@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288779595-15793-1-git-send-email-marek.belisko@gmail.com>
References: <1288779595-15793-1-git-send-email-marek.belisko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
---
 .../staging/ft1000/ft1000-usb/ft1000_download.c    |   52 ++++++++++----------
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c      |    2 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h     |    3 +-
 3 files changed, 28 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
index d1bc537..0a2b833 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
@@ -123,11 +123,11 @@ struct dsp_image_info {
 // Notes:
 //
 //---------------------------------------------------------------------------
-static ULONG check_usb_db (struct ft1000_device *ft1000dev)
+static u32 check_usb_db (struct ft1000_device *ft1000dev)
 {
    int               loopcnt;
    u16            temp;
-   ULONG             status;
+   u32             status;
 
    loopcnt = 0;
    while (loopcnt < 10)
@@ -204,7 +204,7 @@ static u16 get_handshake(struct ft1000_device *ft1000dev, u16 expected_value)
 {
    u16            handshake;
    int               loopcnt;
-   ULONG             status=0;
+   u32             status=0;
 	struct ft1000_info *pft1000info = netdev_priv(ft1000dev->net);
 
    loopcnt = 0;
@@ -271,13 +271,13 @@ static u16 get_handshake(struct ft1000_device *ft1000dev, u16 expected_value)
 //---------------------------------------------------------------------------
 static void put_handshake(struct ft1000_device *ft1000dev,u16 handshake_value)
 {
-    ULONG tempx;
+    u32 tempx;
     u16 tempword;
-    ULONG status;
+    u32 status;
 
 
 
-        tempx = (ULONG)handshake_value;
+        tempx = (u32)handshake_value;
         tempx = ntohl(tempx);
 
         tempword = (u16)(tempx & 0xffff);
@@ -292,7 +292,7 @@ static u16 get_handshake_usb(struct ft1000_device *ft1000dev, u16 expected_value
    u16            handshake;
    int               loopcnt;
    u16            temp;
-   ULONG             status=0;
+   u32             status=0;
 
 	struct ft1000_info *pft1000info = netdev_priv(ft1000dev->net);
    loopcnt = 0;
@@ -349,9 +349,9 @@ static void put_handshake_usb(struct ft1000_device *ft1000dev,u16 handshake_valu
 static u16 get_request_type(struct ft1000_device *ft1000dev)
 {
    u16   request_type;
-   ULONG    status;
+   u32    status;
    u16   tempword;
-   ULONG    tempx;
+   u32    tempx;
 	struct ft1000_info *pft1000info = netdev_priv(ft1000dev->net);
 
    if ( pft1000info->bootmode == 1)
@@ -377,9 +377,9 @@ static u16 get_request_type(struct ft1000_device *ft1000dev)
 static u16 get_request_type_usb(struct ft1000_device *ft1000dev)
 {
    u16   request_type;
-   ULONG    status;
+   u32    status;
    u16   tempword;
-   ULONG    tempx;
+   u32    tempx;
 	struct ft1000_info *pft1000info = netdev_priv(ft1000dev->net);
    if ( pft1000info->bootmode == 1)
    {
@@ -420,9 +420,9 @@ static u16 get_request_type_usb(struct ft1000_device *ft1000dev)
 //---------------------------------------------------------------------------
 static long get_request_value(struct ft1000_device *ft1000dev)
 {
-   ULONG     value;
+   u32     value;
    u16   tempword;
-   ULONG    status;
+   u32    status;
 	struct ft1000_info *pft1000info = netdev_priv(ft1000dev->net);
 
 
@@ -449,9 +449,9 @@ static long get_request_value(struct ft1000_device *ft1000dev)
 #if 0
 static long get_request_value_usb(struct ft1000_device *ft1000dev)
 {
-   ULONG     value;
+   u32     value;
    u16   tempword;
-   ULONG    status;
+   u32    status;
    struct ft1000_info * pft1000info = netdev_priv(ft1000dev->net);
 
        if (pft1000info->usbboot == 2) {
@@ -490,8 +490,8 @@ static long get_request_value_usb(struct ft1000_device *ft1000dev)
 //---------------------------------------------------------------------------
 static void put_request_value(struct ft1000_device *ft1000dev, long lvalue)
 {
-   ULONG    tempx;
-   ULONG    status;
+   u32    tempx;
+   u32    status;
 
        tempx = ntohl(lvalue);
        status = fix_ft1000_write_dpram32(ft1000dev, DWNLD_MAG1_SIZE_LOC, (u8 *)&tempx);
@@ -546,9 +546,9 @@ static u16 hdr_checksum(struct pseudo_hdr *pHdr)
 // Notes:
 //
 //---------------------------------------------------------------------------
-static ULONG write_blk (struct ft1000_device *ft1000dev, u16 **pUsFile, u8 **pUcFile, long word_length)
+static u32 write_blk (struct ft1000_device *ft1000dev, u16 **pUsFile, u8 **pUcFile, long word_length)
 {
-   ULONG Status = STATUS_SUCCESS;
+   u32 Status = STATUS_SUCCESS;
    u16 dpram;
    long temp_word_length;
    int loopcnt, i, j;
@@ -702,9 +702,9 @@ static void usb_dnld_complete (struct urb *urb)
 // Notes:
 //
 //---------------------------------------------------------------------------
-static ULONG write_blk_fifo (struct ft1000_device *ft1000dev, u16 **pUsFile, u8 **pUcFile, long word_length)
+static u32 write_blk_fifo (struct ft1000_device *ft1000dev, u16 **pUsFile, u8 **pUcFile, long word_length)
 {
-   ULONG Status = STATUS_SUCCESS;
+   u32 Status = STATUS_SUCCESS;
    int byte_length;
    long aligncnt;
 
@@ -770,7 +770,7 @@ static ULONG write_blk_fifo (struct ft1000_device *ft1000dev, u16 **pUsFile, u8
 //  Returns:    status                  - return code
 //---------------------------------------------------------------------------
 
-u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, ULONG  FileLength)
+u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, u32  FileLength)
 {
    u16                     Status = STATUS_SUCCESS;
    UINT                    uiState;
@@ -795,8 +795,8 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, ULONG  FileLe
    long                    loader_code_address, loader_code_size = 0;
    long                    run_address = 0, run_size = 0;
 
-   ULONG                   templong;
-   ULONG                   image_chksum = 0;
+   u32                   templong;
+   u32                   image_chksum = 0;
 
    u16                  dpram = 0;
    u8 *pbuffer;
@@ -1114,7 +1114,7 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, ULONG  FileLe
                        templong = temp;
                        temp = (u16)(pDspImageInfoV6->version >> 16);
                        templong |= (temp << 16);
-                   if (templong == (ULONG)requested_version)
+                   if (templong == (u32)requested_version)
                        {
                            bGoodVersion = TRUE;
                            DEBUG("FT1000:download: bGoodVersion is TRUE\n");
@@ -1123,7 +1123,7 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, ULONG  FileLe
                            pCodeEnd = (u8 *)(pFileStart + pDspImageInfoV6->end_offset);
                            run_address = pDspImageInfoV6->run_address;
                            run_size = pDspImageInfoV6->image_size;
-                           image_chksum = (ULONG)pDspImageInfoV6->checksum;
+                           image_chksum = (u32)pDspImageInfoV6->checksum;
                            break;
                         }
                         pDspImageInfoV6++;
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 709f8da..f97826d 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -594,7 +594,7 @@ int dsp_reload(struct ft1000_device *ft1000dev)
 {
     u16 status;
     u16 tempword;
-    ULONG templong;
+    u32 templong;
 
 	struct ft1000_info *pft1000info;
 
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
index bc00223..64af710 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
@@ -98,7 +98,6 @@ struct prov_record {
 /*end of Jim*/
 #define DEBUG(args...) printk(KERN_INFO args)
 
-#define ULONG               u32 /* WTF ??? */
 #define BOOLEAN             u8
 #define PCHAR               u8 *
 #define UINT                u32
@@ -572,7 +571,7 @@ extern size_t FileLength;
 extern int numofmsgbuf;
 
 int ft1000_close (struct net_device *dev);
-u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, ULONG  FileLength);
+u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, u32  FileLength);
 
 extern struct list_head freercvpool;
 extern spinlock_t free_buff_lock;   // lock to arbitrate free buffer list for receive command data
-- 
1.7.1

