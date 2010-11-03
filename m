Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755003Ab0KCKTl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 06:19:41 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52967 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977Ab0KCKR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 06:17:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=xZCGoCLeW8v++ELOCAVhMBmVrAFx/XC+lEN6ZvacpEBWLlNtN33ThfjhzP93UT7C+G
         Z6zVSBc7v3Ve8JhdRw7Zm1mmW3ZyaN3Jvudz4DukcOAPyT30jqggqXTdGKgWiOiUiJEz
         uDszsatYZMO823yvT5iRgWHDHBZ7EAz+RQXQ8=
From: Marek Belisko <marek.belisko@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Marek Belisko <marek.belisko@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@gmail.com>
Subject: [PATCH 2/9] staging: ft1000: Get rid of UCHAR typedef.
Date: Wed,  3 Nov 2010 11:19:48 +0100
Message-Id: <1288779595-15793-2-git-send-email-marek.belisko@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288779595-15793-1-git-send-email-marek.belisko@gmail.com>
References: <1288779595-15793-1-git-send-email-marek.belisko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
---
 .../staging/ft1000/ft1000-usb/ft1000_download.c    |   26 ++++++++++----------
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c      |    6 ++--
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h     |   11 ++++----
 3 files changed, 21 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
index d7ca6cc..d7377eb 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
@@ -534,7 +534,7 @@ static USHORT hdr_checksum(struct pseudo_hdr *pHdr)
 //
 // Parameters:  struct ft1000_device  - device structure
 //              USHORT **pUsFile - DSP image file pointer in USHORT
-//              UCHAR  **pUcFile - DSP image file pointer in UCHAR
+//              u8  **pUcFile - DSP image file pointer in u8
 //              long   word_length - lenght of the buffer to be written
 //                                   to DPRAM
 //
@@ -546,7 +546,7 @@ static USHORT hdr_checksum(struct pseudo_hdr *pHdr)
 // Notes:
 //
 //---------------------------------------------------------------------------
-static ULONG write_blk (struct ft1000_device *ft1000dev, USHORT **pUsFile, UCHAR **pUcFile, long word_length)
+static ULONG write_blk (struct ft1000_device *ft1000dev, USHORT **pUsFile, u8 **pUcFile, long word_length)
 {
    ULONG Status = STATUS_SUCCESS;
    USHORT dpram;
@@ -690,7 +690,7 @@ static void usb_dnld_complete (struct urb *urb)
 //
 // Parameters:  struct ft1000_device  - device structure
 //              USHORT **pUsFile - DSP image file pointer in USHORT
-//              UCHAR  **pUcFile - DSP image file pointer in UCHAR
+//              u8  **pUcFile - DSP image file pointer in u8
 //              long   word_length - lenght of the buffer to be written
 //                                   to DPRAM
 //
@@ -702,7 +702,7 @@ static void usb_dnld_complete (struct urb *urb)
 // Notes:
 //
 //---------------------------------------------------------------------------
-static ULONG write_blk_fifo (struct ft1000_device *ft1000dev, USHORT **pUsFile, UCHAR **pUcFile, long word_length)
+static ULONG write_blk_fifo (struct ft1000_device *ft1000dev, USHORT **pUsFile, u8 **pUcFile, long word_length)
 {
    ULONG Status = STATUS_SUCCESS;
    int byte_length;
@@ -789,8 +789,8 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, ULONG  FileLe
 	struct drv_msg *pMailBoxData;
    USHORT                  *pUsData = NULL;
    USHORT                  *pUsFile = NULL;
-   UCHAR                   *pUcFile = NULL;
-   UCHAR                   *pBootEnd = NULL, *pCodeEnd= NULL;
+   u8                   *pUcFile = NULL;
+   u8                   *pBootEnd = NULL, *pCodeEnd= NULL;
    int                     imageN;
    long                    loader_code_address, loader_code_size = 0;
    long                    run_address = 0, run_size = 0;
@@ -821,9 +821,9 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, ULONG  FileLe
    ft1000_write_register (ft1000dev, 0x800, FT1000_REG_MAG_WATERMARK);
 
       pUsFile = (USHORT *)(pFileStart + pFileHdr5->loader_offset);
-      pUcFile = (UCHAR *)(pFileStart + pFileHdr5->loader_offset);
+      pUcFile = (u8 *)(pFileStart + pFileHdr5->loader_offset);
 
-      pBootEnd = (UCHAR *)(pFileStart + pFileHdr5->loader_code_end);
+      pBootEnd = (u8 *)(pFileStart + pFileHdr5->loader_code_end);
 
       loader_code_address = pFileHdr5->loader_code_address;
       loader_code_size = pFileHdr5->loader_code_size;
@@ -879,7 +879,7 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, ULONG  FileLe
                DEBUG("FT1000:REQUEST_DONE_BL\n");
                /* Reposition ptrs to beginning of code section */
                pUsFile = (USHORT *)(pBootEnd);
-               pUcFile = (UCHAR *)(pBootEnd);
+               pUcFile = (u8 *)(pBootEnd);
                //DEBUG("FT1000:download:pUsFile = 0x%8x\n", (int)pUsFile);
                //DEBUG("FT1000:download:pUcFile = 0x%8x\n", (int)pUcFile);
                uiState = STATE_CODE_DWNLD;
@@ -989,7 +989,7 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, ULONG  FileLe
                pft1000info->usbboot = 3;
                /* Reposition ptrs to beginning of provisioning section */
                   pUsFile = (USHORT *)(pFileStart + pFileHdr5->commands_offset);
-                  pUcFile = (UCHAR *)(pFileStart + pFileHdr5->commands_offset);
+                  pUcFile = (u8 *)(pFileStart + pFileHdr5->commands_offset);
                uiState = STATE_DONE_DWNLD;
                break;
             case  REQUEST_CODE_SEGMENT:
@@ -1119,8 +1119,8 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, ULONG  FileLe
                            bGoodVersion = TRUE;
                            DEBUG("FT1000:download: bGoodVersion is TRUE\n");
                            pUsFile = (USHORT *)(pFileStart + pDspImageInfoV6->begin_offset);
-                           pUcFile = (UCHAR *)(pFileStart + pDspImageInfoV6->begin_offset);
-                           pCodeEnd = (UCHAR *)(pFileStart + pDspImageInfoV6->end_offset);
+                           pUcFile = (u8 *)(pFileStart + pDspImageInfoV6->begin_offset);
+                           pCodeEnd = (u8 *)(pFileStart + pDspImageInfoV6->end_offset);
                            run_address = pDspImageInfoV6->run_address;
                            run_size = pDspImageInfoV6->image_size;
                            image_chksum = (ULONG)pDspImageInfoV6->checksum;
@@ -1188,7 +1188,7 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, ULONG  FileLe
                     pprov_record->pprov_data = pbuffer;
                     list_add_tail (&pprov_record->list, &pft1000info->prov_list);
                     // Move to next entry if available
-			pUcFile = (UCHAR *)((unsigned long)pUcFile + (UINT)((usHdrLength + 1) & 0xFFFFFFFE) + sizeof(struct pseudo_hdr));
+			pUcFile = (u8 *)((unsigned long)pUcFile + (UINT)((usHdrLength + 1) & 0xFFFFFFFE) + sizeof(struct pseudo_hdr));
                     if ( (unsigned long)(pUcFile) - (unsigned long)(pFileStart) >= (unsigned long)FileLength) {
                        uiState = STATE_DONE_FILE;
                     }
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 8333e66..2f195c8 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -367,7 +367,7 @@ u16 ft1000_write_dpram16(struct ft1000_device *ft1000dev, USHORT indx, USHORT va
 //---------------------------------------------------------------------------
 u16 fix_ft1000_read_dpram32(struct ft1000_device *ft1000dev, USHORT indx, u8 *buffer)
 {
-    UCHAR buf[16];
+    u8 buf[16];
     USHORT pos;
     u16 ret = STATUS_SUCCESS;
 
@@ -419,8 +419,8 @@ u16 fix_ft1000_write_dpram32(struct ft1000_device *ft1000dev, USHORT indx, u8 *b
     USHORT pos1;
     USHORT pos2;
     USHORT i;
-    UCHAR buf[32];
-    UCHAR resultbuffer[32];
+    u8 buf[32];
+    u8 resultbuffer[32];
     u8 *pdata;
     u16 ret  = STATUS_SUCCESS;
 
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
index 4996da9..96665a7 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
@@ -98,7 +98,6 @@ struct prov_record {
 /*end of Jim*/
 #define DEBUG(args...) printk(KERN_INFO args)
 
-#define UCHAR               u8
 #define USHORT              u16
 #define ULONG               u32 /* WTF ??? */
 #define BOOLEAN             u8
@@ -371,15 +370,15 @@ struct prov_record {
 
 
 
-#define ISR_EMPTY			(UCHAR)0x00 	 // no bits set in ISR
+#define ISR_EMPTY			(u8)0x00 	 // no bits set in ISR
 
-#define ISR_DOORBELL_ACK	(UCHAR)0x01		 //  the doorbell i sent has been recieved.
+#define ISR_DOORBELL_ACK	(u8)0x01		 //  the doorbell i sent has been recieved.
 
-#define ISR_DOORBELL_PEND	(UCHAR)0x02 	 //  doorbell for me
+#define ISR_DOORBELL_PEND	(u8)0x02 	 //  doorbell for me
 
-#define ISR_RCV				(UCHAR)0x04 	 // packet received with no errors
+#define ISR_RCV				(u8)0x04 	 // packet received with no errors
 
-#define ISR_WATERMARK		(UCHAR)0x08 	 //
+#define ISR_WATERMARK		(u8)0x08 	 //
 
 
 
-- 
1.7.1

