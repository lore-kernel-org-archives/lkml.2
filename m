Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab0KCKSI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 06:18:08 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36930 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754387Ab0KCKSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 06:18:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=jEt4DCXRiSrc125gPIRPFNBsveuUlO0hFZ4tmnArTFEfPDK60ufagcAtuRxe+0IAhq
         jC4Qhv2lJ3OgzuPK0l1MOenc0NRYMY39gJadGDS+p+73axb8j3NexF40UGmF8uYuN7jD
         aFxk9j/7L07Svxj/QYanDICZG9Rl9E7cZlwt8=
From: Marek Belisko <marek.belisko@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Marek Belisko <marek.belisko@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@gmail.com>
Subject: [PATCH 4/9] staging: ft1000: Get rid of USHORT typedef usage.
Date: Wed,  3 Nov 2010 11:19:50 +0100
Message-Id: <1288779595-15793-4-git-send-email-marek.belisko@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288779595-15793-1-git-send-email-marek.belisko@gmail.com>
References: <1288779595-15793-1-git-send-email-marek.belisko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c   |    8 +-
 .../staging/ft1000/ft1000-usb/ft1000_download.c    |  114 ++++++++++----------
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c      |   36 +++---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.h      |    2 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_proc.c    |    2 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h     |   15 ++--
 6 files changed, 88 insertions(+), 89 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
index 6659bc7..f6b2e91 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
@@ -653,12 +653,12 @@ static long ft1000_ChIoctl (struct file *File, unsigned int Command,
         {
             IOCTL_DPRAM_BLK *dpram_data;
             //IOCTL_DPRAM_COMMAND dpram_command;
-            USHORT qtype;
-            USHORT msgsz;
+            u16 qtype;
+            u16 msgsz;
 		struct pseudo_hdr *ppseudo_hdr;
             u16 *pmsg;
-            USHORT total_len;
-            USHORT app_index;
+            u16 total_len;
+            u16 app_index;
             u16 status;
 
             //DEBUG("FT1000:ft1000_ChIoctl: IOCTL_FT1000_SET_DPRAM called\n");
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
index d7377eb..d1bc537 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
@@ -126,7 +126,7 @@ struct dsp_image_info {
 static ULONG check_usb_db (struct ft1000_device *ft1000dev)
 {
    int               loopcnt;
-   USHORT            temp;
+   u16            temp;
    ULONG             status;
 
    loopcnt = 0;
@@ -190,7 +190,7 @@ static ULONG check_usb_db (struct ft1000_device *ft1000dev)
 // Function:    get_handshake
 //
 // Parameters:  struct ft1000_device  - device structure
-//              USHORT expected_value - the handshake value expected
+//              u16 expected_value - the handshake value expected
 //
 // Returns:     handshakevalue - success
 //              HANDSHAKE_TIMEOUT_VALUE - failure
@@ -200,9 +200,9 @@ static ULONG check_usb_db (struct ft1000_device *ft1000dev)
 // Notes:
 //
 //---------------------------------------------------------------------------
-static USHORT get_handshake(struct ft1000_device *ft1000dev, USHORT expected_value)
+static u16 get_handshake(struct ft1000_device *ft1000dev, u16 expected_value)
 {
-   USHORT            handshake;
+   u16            handshake;
    int               loopcnt;
    ULONG             status=0;
 	struct ft1000_info *pft1000info = netdev_priv(ft1000dev->net);
@@ -259,7 +259,7 @@ static USHORT get_handshake(struct ft1000_device *ft1000dev, USHORT expected_val
 // Function:    put_handshake
 //
 // Parameters:  struct ft1000_device  - device structure
-//              USHORT handshake_value - handshake to be written
+//              u16 handshake_value - handshake to be written
 //
 // Returns:     none
 //
@@ -269,10 +269,10 @@ static USHORT get_handshake(struct ft1000_device *ft1000dev, USHORT expected_val
 // Notes:
 //
 //---------------------------------------------------------------------------
-static void put_handshake(struct ft1000_device *ft1000dev,USHORT handshake_value)
+static void put_handshake(struct ft1000_device *ft1000dev,u16 handshake_value)
 {
     ULONG tempx;
-    USHORT tempword;
+    u16 tempword;
     ULONG status;
 
 
@@ -280,18 +280,18 @@ static void put_handshake(struct ft1000_device *ft1000dev,USHORT handshake_value
         tempx = (ULONG)handshake_value;
         tempx = ntohl(tempx);
 
-        tempword = (USHORT)(tempx & 0xffff);
+        tempword = (u16)(tempx & 0xffff);
         status = ft1000_write_dpram16 (ft1000dev, DWNLD_MAG1_HANDSHAKE_LOC, tempword, 0);
-        tempword = (USHORT)(tempx >> 16);
+        tempword = (u16)(tempx >> 16);
         status = ft1000_write_dpram16 (ft1000dev, DWNLD_MAG1_HANDSHAKE_LOC, tempword, 1);
         status = ft1000_write_register(ft1000dev, FT1000_DB_DNLD_TX, FT1000_REG_DOORBELL);
 }
 
-static USHORT get_handshake_usb(struct ft1000_device *ft1000dev, USHORT expected_value)
+static u16 get_handshake_usb(struct ft1000_device *ft1000dev, u16 expected_value)
 {
-   USHORT            handshake;
+   u16            handshake;
    int               loopcnt;
-   USHORT            temp;
+   u16            temp;
    ULONG             status=0;
 
 	struct ft1000_info *pft1000info = netdev_priv(ft1000dev->net);
@@ -327,7 +327,7 @@ static USHORT get_handshake_usb(struct ft1000_device *ft1000dev, USHORT expected
    return HANDSHAKE_TIMEOUT_VALUE;
 }
 
-static void put_handshake_usb(struct ft1000_device *ft1000dev,USHORT handshake_value)
+static void put_handshake_usb(struct ft1000_device *ft1000dev,u16 handshake_value)
 {
    int i;
 
@@ -346,11 +346,11 @@ static void put_handshake_usb(struct ft1000_device *ft1000dev,USHORT handshake_v
 // Notes:
 //
 //---------------------------------------------------------------------------
-static USHORT get_request_type(struct ft1000_device *ft1000dev)
+static u16 get_request_type(struct ft1000_device *ft1000dev)
 {
-   USHORT   request_type;
+   u16   request_type;
    ULONG    status;
-   USHORT   tempword;
+   u16   tempword;
    ULONG    tempx;
 	struct ft1000_info *pft1000info = netdev_priv(ft1000dev->net);
 
@@ -367,18 +367,18 @@ static USHORT get_request_type(struct ft1000_device *ft1000dev)
        tempx |= (tempword << 16);
        tempx = ntohl(tempx);
    }
-   request_type = (USHORT)tempx;
+   request_type = (u16)tempx;
 
    //DEBUG("get_request_type: request_type is %x\n", request_type);
    return request_type;
 
 }
 
-static USHORT get_request_type_usb(struct ft1000_device *ft1000dev)
+static u16 get_request_type_usb(struct ft1000_device *ft1000dev)
 {
-   USHORT   request_type;
+   u16   request_type;
    ULONG    status;
-   USHORT   tempword;
+   u16   tempword;
    ULONG    tempx;
 	struct ft1000_info *pft1000info = netdev_priv(ft1000dev->net);
    if ( pft1000info->bootmode == 1)
@@ -399,7 +399,7 @@ static USHORT get_request_type_usb(struct ft1000_device *ft1000dev)
        tempx |= (tempword << 16);
        tempx = ntohl(tempx);
    }
-   request_type = (USHORT)tempx;
+   request_type = (u16)tempx;
 
    //DEBUG("get_request_type: request_type is %x\n", request_type);
    return request_type;
@@ -421,7 +421,7 @@ static USHORT get_request_type_usb(struct ft1000_device *ft1000dev)
 static long get_request_value(struct ft1000_device *ft1000dev)
 {
    ULONG     value;
-   USHORT   tempword;
+   u16   tempword;
    ULONG    status;
 	struct ft1000_info *pft1000info = netdev_priv(ft1000dev->net);
 
@@ -450,7 +450,7 @@ static long get_request_value(struct ft1000_device *ft1000dev)
 static long get_request_value_usb(struct ft1000_device *ft1000dev)
 {
    ULONG     value;
-   USHORT   tempword;
+   u16   tempword;
    ULONG    status;
    struct ft1000_info * pft1000info = netdev_priv(ft1000dev->net);
 
@@ -516,10 +516,10 @@ static void put_request_value(struct ft1000_device *ft1000dev, long lvalue)
 // Notes:
 //
 //---------------------------------------------------------------------------
-static USHORT hdr_checksum(struct pseudo_hdr *pHdr)
+static u16 hdr_checksum(struct pseudo_hdr *pHdr)
 {
-   USHORT   *usPtr = (USHORT *)pHdr;
-   USHORT   chksum;
+   u16   *usPtr = (u16 *)pHdr;
+   u16   chksum;
 
 
   chksum = ((((((usPtr[0] ^ usPtr[1]) ^ usPtr[2]) ^ usPtr[3]) ^
@@ -533,7 +533,7 @@ static USHORT hdr_checksum(struct pseudo_hdr *pHdr)
 // Function:    write_blk
 //
 // Parameters:  struct ft1000_device  - device structure
-//              USHORT **pUsFile - DSP image file pointer in USHORT
+//              u16 **pUsFile - DSP image file pointer in u16
 //              u8  **pUcFile - DSP image file pointer in u8
 //              long   word_length - lenght of the buffer to be written
 //                                   to DPRAM
@@ -546,20 +546,20 @@ static USHORT hdr_checksum(struct pseudo_hdr *pHdr)
 // Notes:
 //
 //---------------------------------------------------------------------------
-static ULONG write_blk (struct ft1000_device *ft1000dev, USHORT **pUsFile, u8 **pUcFile, long word_length)
+static ULONG write_blk (struct ft1000_device *ft1000dev, u16 **pUsFile, u8 **pUcFile, long word_length)
 {
    ULONG Status = STATUS_SUCCESS;
-   USHORT dpram;
+   u16 dpram;
    long temp_word_length;
    int loopcnt, i, j;
-   USHORT *pTempFile;
-   USHORT tempword;
-   USHORT tempbuffer[64];
-   USHORT resultbuffer[64];
+   u16 *pTempFile;
+   u16 tempword;
+   u16 tempbuffer[64];
+   u16 resultbuffer[64];
 	struct ft1000_info *pft1000info = netdev_priv(ft1000dev->net);
 
    //DEBUG("FT1000:download:start word_length = %d\n",(int)word_length);
-   dpram = (USHORT)DWNLD_MAG1_PS_HDR_LOC;
+   dpram = (u16)DWNLD_MAG1_PS_HDR_LOC;
    tempword = *(*pUsFile);
    (*pUsFile)++;
    Status = ft1000_write_dpram16(ft1000dev, dpram, tempword, 0);
@@ -569,7 +569,7 @@ static ULONG write_blk (struct ft1000_device *ft1000dev, USHORT **pUsFile, u8 **
 
    *pUcFile = *pUcFile + 4;
    word_length--;
-   tempword = (USHORT)word_length;
+   tempword = (u16)word_length;
    word_length = (word_length / 16) + 1;
    pTempFile = *pUsFile;
    temp_word_length = word_length;
@@ -689,7 +689,7 @@ static void usb_dnld_complete (struct urb *urb)
 // Function:    write_blk_fifo
 //
 // Parameters:  struct ft1000_device  - device structure
-//              USHORT **pUsFile - DSP image file pointer in USHORT
+//              u16 **pUsFile - DSP image file pointer in u16
 //              u8  **pUcFile - DSP image file pointer in u8
 //              long   word_length - lenght of the buffer to be written
 //                                   to DPRAM
@@ -702,7 +702,7 @@ static void usb_dnld_complete (struct urb *urb)
 // Notes:
 //
 //---------------------------------------------------------------------------
-static ULONG write_blk_fifo (struct ft1000_device *ft1000dev, USHORT **pUsFile, u8 **pUcFile, long word_length)
+static ULONG write_blk_fifo (struct ft1000_device *ft1000dev, u16 **pUsFile, u8 **pUcFile, long word_length)
 {
    ULONG Status = STATUS_SUCCESS;
    int byte_length;
@@ -774,21 +774,21 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, ULONG  FileLe
 {
    u16                     Status = STATUS_SUCCESS;
    UINT                    uiState;
-   USHORT                  handshake;
+   u16                  handshake;
 	struct pseudo_hdr *pHdr;
-   USHORT                  usHdrLength;
+   u16                  usHdrLength;
    long                    word_length;
-   USHORT                  request;
-   USHORT                  temp;
-   USHORT                  tempword;
+   u16                  request;
+   u16                  temp;
+   u16                  tempword;
 
 	struct dsp_file_hdr *pFileHdr5;
 	struct dsp_image_info *pDspImageInfoV6 = NULL;
    long                    requested_version;
    BOOLEAN                 bGoodVersion;
 	struct drv_msg *pMailBoxData;
-   USHORT                  *pUsData = NULL;
-   USHORT                  *pUsFile = NULL;
+   u16                  *pUsData = NULL;
+   u16                  *pUsFile = NULL;
    u8                   *pUcFile = NULL;
    u8                   *pBootEnd = NULL, *pCodeEnd= NULL;
    int                     imageN;
@@ -798,7 +798,7 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, ULONG  FileLe
    ULONG                   templong;
    ULONG                   image_chksum = 0;
 
-   USHORT                  dpram = 0;
+   u16                  dpram = 0;
    u8 *pbuffer;
 	struct prov_record *pprov_record;
 	struct ft1000_info *pft1000info = netdev_priv(ft1000dev->net);
@@ -820,7 +820,7 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, ULONG  FileLe
 
    ft1000_write_register (ft1000dev, 0x800, FT1000_REG_MAG_WATERMARK);
 
-      pUsFile = (USHORT *)(pFileStart + pFileHdr5->loader_offset);
+      pUsFile = (u16 *)(pFileStart + pFileHdr5->loader_offset);
       pUcFile = (u8 *)(pFileStart + pFileHdr5->loader_offset);
 
       pBootEnd = (u8 *)(pFileStart + pFileHdr5->loader_code_end);
@@ -878,7 +878,7 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, ULONG  FileLe
             case  REQUEST_DONE_BL:
                DEBUG("FT1000:REQUEST_DONE_BL\n");
                /* Reposition ptrs to beginning of code section */
-               pUsFile = (USHORT *)(pBootEnd);
+               pUsFile = (u16 *)(pBootEnd);
                pUcFile = (u8 *)(pBootEnd);
                //DEBUG("FT1000:download:pUsFile = 0x%8x\n", (int)pUsFile);
                //DEBUG("FT1000:download:pUcFile = 0x%8x\n", (int)pUcFile);
@@ -909,7 +909,7 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, ULONG  FileLe
                /*
                 * Position ASIC DPRAM auto-increment pointer.
                 */
-				    dpram = (USHORT)DWNLD_MAG1_PS_HDR_LOC;
+				    dpram = (u16)DWNLD_MAG1_PS_HDR_LOC;
 					if (word_length & 0x1)
 						word_length++;
 					word_length = word_length / 2;
@@ -988,7 +988,7 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, ULONG  FileLe
             case  REQUEST_DONE_CL:
                pft1000info->usbboot = 3;
                /* Reposition ptrs to beginning of provisioning section */
-                  pUsFile = (USHORT *)(pFileStart + pFileHdr5->commands_offset);
+                  pUsFile = (u16 *)(pFileStart + pFileHdr5->commands_offset);
                   pUcFile = (u8 *)(pFileStart + pFileHdr5->commands_offset);
                uiState = STATE_DONE_DWNLD;
                break;
@@ -1027,7 +1027,7 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, ULONG  FileLe
                /*
                 * Position ASIC DPRAM auto-increment pointer.
                 */
-		   dpram = (USHORT)DWNLD_MAG1_PS_HDR_LOC;
+		   dpram = (u16)DWNLD_MAG1_PS_HDR_LOC;
 		   if (word_length & 0x1)
 			word_length++;
 		   word_length = word_length / 2;
@@ -1053,8 +1053,8 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, ULONG  FileLe
                 */
 
 
-                   pUsData = (USHORT *)&pMailBoxData->data[0];
-                   dpram = (USHORT)DWNLD_MAG1_PS_HDR_LOC;
+                   pUsData = (u16 *)&pMailBoxData->data[0];
+                   dpram = (u16)DWNLD_MAG1_PS_HDR_LOC;
                    if (word_length & 0x1)
                        word_length++;
 
@@ -1079,10 +1079,10 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, ULONG  FileLe
                 * Position ASIC DPRAM auto-increment pointer.
                 */
 
-               pUsFile = (USHORT *)(pFileStart + pFileHdr5->version_data_offset);
+               pUsFile = (u16 *)(pFileStart + pFileHdr5->version_data_offset);
 
 
-                   dpram = (USHORT)DWNLD_MAG1_PS_HDR_LOC;
+                   dpram = (u16)DWNLD_MAG1_PS_HDR_LOC;
                    if (word_length & 0x1)
                        word_length++;
 
@@ -1110,15 +1110,15 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, ULONG  FileLe
                for (imageN = 0; imageN < pFileHdr5->nDspImages; imageN++)
                {
 
-                       temp = (USHORT)(pDspImageInfoV6->version);
+                       temp = (u16)(pDspImageInfoV6->version);
                        templong = temp;
-                       temp = (USHORT)(pDspImageInfoV6->version >> 16);
+                       temp = (u16)(pDspImageInfoV6->version >> 16);
                        templong |= (temp << 16);
                    if (templong == (ULONG)requested_version)
                        {
                            bGoodVersion = TRUE;
                            DEBUG("FT1000:download: bGoodVersion is TRUE\n");
-                           pUsFile = (USHORT *)(pFileStart + pDspImageInfoV6->begin_offset);
+                           pUsFile = (u16 *)(pFileStart + pDspImageInfoV6->begin_offset);
                            pUcFile = (u8 *)(pFileStart + pDspImageInfoV6->begin_offset);
                            pCodeEnd = (u8 *)(pFileStart + pDspImageInfoV6->end_offset);
                            run_address = pDspImageInfoV6->run_address;
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index c964bf7..709f8da 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -160,7 +160,7 @@ u16 ft1000_read_register(struct ft1000_device *ft1000dev, u16* Data, u16 nRegInd
 // Notes:
 //
 //---------------------------------------------------------------------------
-u16 ft1000_write_register(struct ft1000_device *ft1000dev, USHORT value, u16 nRegIndx)
+u16 ft1000_write_register(struct ft1000_device *ft1000dev, u16 value, u16 nRegIndx)
 {
      u16 ret = STATUS_SUCCESS;
 
@@ -196,7 +196,7 @@ u16 ft1000_write_register(struct ft1000_device *ft1000dev, USHORT value, u16 nRe
 //
 //---------------------------------------------------------------------------
 
-u16 ft1000_read_dpram32(struct ft1000_device *ft1000dev, USHORT indx, u8 *buffer, USHORT cnt)
+u16 ft1000_read_dpram32(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer, u16 cnt)
 {
     u16 ret = STATUS_SUCCESS;
 
@@ -235,7 +235,7 @@ u16 ft1000_read_dpram32(struct ft1000_device *ft1000dev, USHORT indx, u8 *buffer
 // Notes:
 //
 //---------------------------------------------------------------------------
-u16 ft1000_write_dpram32(struct ft1000_device *ft1000dev, USHORT indx, u8 *buffer, USHORT cnt)
+u16 ft1000_write_dpram32(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer, u16 cnt)
 {
      u16 ret = STATUS_SUCCESS;
 
@@ -272,7 +272,7 @@ u16 ft1000_write_dpram32(struct ft1000_device *ft1000dev, USHORT indx, u8 *buffe
 // Notes:
 //
 //---------------------------------------------------------------------------
-u16 ft1000_read_dpram16(struct ft1000_device *ft1000dev, USHORT indx, u8 *buffer, u8 highlow)
+u16 ft1000_read_dpram16(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer, u8 highlow)
 {
     u16 ret = STATUS_SUCCESS;
 
@@ -320,7 +320,7 @@ u16 ft1000_read_dpram16(struct ft1000_device *ft1000dev, USHORT indx, u8 *buffer
 // Notes:
 //
 //---------------------------------------------------------------------------
-u16 ft1000_write_dpram16(struct ft1000_device *ft1000dev, USHORT indx, USHORT value, u8 highlow)
+u16 ft1000_write_dpram16(struct ft1000_device *ft1000dev, u16 indx, u16 value, u8 highlow)
 {
      u16 ret = STATUS_SUCCESS;
 
@@ -365,10 +365,10 @@ u16 ft1000_write_dpram16(struct ft1000_device *ft1000dev, USHORT indx, USHORT va
 // Notes:
 //
 //---------------------------------------------------------------------------
-u16 fix_ft1000_read_dpram32(struct ft1000_device *ft1000dev, USHORT indx, u8 *buffer)
+u16 fix_ft1000_read_dpram32(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer)
 {
     u8 buf[16];
-    USHORT pos;
+    u16 pos;
     u16 ret = STATUS_SUCCESS;
 
     //DEBUG("fix_ft1000_read_dpram32: indx: %d  \n", indx);
@@ -414,11 +414,11 @@ u16 fix_ft1000_read_dpram32(struct ft1000_device *ft1000dev, USHORT indx, u8 *bu
 // Notes:
 //
 //---------------------------------------------------------------------------
-u16 fix_ft1000_write_dpram32(struct ft1000_device *ft1000dev, USHORT indx, u8 *buffer)
+u16 fix_ft1000_write_dpram32(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer)
 {
-    USHORT pos1;
-    USHORT pos2;
-    USHORT i;
+    u16 pos1;
+    u16 pos2;
+    u16 i;
     u8 buf[32];
     u8 resultbuffer[32];
     u8 *pdata;
@@ -494,7 +494,7 @@ u16 fix_ft1000_write_dpram32(struct ft1000_device *ft1000dev, USHORT indx, u8 *b
 static void card_reset_dsp (struct ft1000_device *ft1000dev, BOOLEAN value)
 {
     u16 status = STATUS_SUCCESS;
-    USHORT tempword;
+    u16 tempword;
 
     status = ft1000_write_register (ft1000dev, HOST_INTF_BE, FT1000_REG_SUP_CTRL);
     status = ft1000_read_register(ft1000dev, &tempword, FT1000_REG_SUP_CTRL);
@@ -593,7 +593,7 @@ void CardSendCommand(struct ft1000_device *ft1000dev, void *ptempbuffer, int siz
 int dsp_reload(struct ft1000_device *ft1000dev)
 {
     u16 status;
-    USHORT tempword;
+    u16 tempword;
     ULONG templong;
 
 	struct ft1000_info *pft1000info;
@@ -1543,7 +1543,7 @@ static int ft1000_dsp_prov(void *arg)
 	struct pseudo_hdr *ppseudo_hdr;
     u16 *pmsg;
     u16 status;
-    USHORT TempShortBuf [256];
+    u16 TempShortBuf [256];
 
     DEBUG("*** DspProv Entered\n");
 
@@ -1876,7 +1876,7 @@ static int ft1000_proc_drvmsg (struct ft1000_device *dev, u16 size) {
                   *pmsg++ = convert.wrd;
                   *pmsg++ = htons(info->DrvErrNum);
 
-                  CardSendCommand (dev, (unsigned char*)&tempbuffer[0], (USHORT)(0x0012 + PSEUDOSZ));
+                  CardSendCommand (dev, (unsigned char*)&tempbuffer[0], (u16)(0x0012 + PSEUDOSZ));
                   info->DrvErrNum = 0;
               }
               info->DrvMsgPend = 0;
@@ -1907,9 +1907,9 @@ int ft1000_poll(void* dev_id) {
     u16 status;
     u16 size;
     int i;
-    USHORT data;
-    USHORT modulo;
-    USHORT portid;
+    u16 data;
+    u16 modulo;
+    u16 portid;
     u16 nxtph;
 	struct dpram_blk *pdpram_blk;
 	struct pseudo_hdr *ppseudo_hdr;
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.h b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.h
index a2e19d2..ab9312f 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.h
@@ -5,6 +5,6 @@
 #include "ft1000_usb.h"
 
 extern u16 ft1000_read_register(struct usb_device *dev, u16 *Data, u8 nRegIndx);
-extern u16 ft1000_write_register(struct usb_device *dev, USHORT value, u8 nRegIndx);
+extern u16 ft1000_write_register(struct usb_device *dev, u16 value, u8 nRegIndx);
 
 #endif
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c b/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
index dda0e33..f665640 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
@@ -38,7 +38,7 @@
 //#endif
 
 
-u16 ft1000_read_dpram16 (struct ft1000_device *ft1000dev, USHORT indx,
+u16 ft1000_read_dpram16 (struct ft1000_device *ft1000dev, u16 indx,
 			 u8 *buffer, u8 highlow);
 
 
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
index 7ec8845..2e48686 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
@@ -98,7 +98,6 @@ struct prov_record {
 /*end of Jim*/
 #define DEBUG(args...) printk(KERN_INFO args)
 
-#define USHORT              u16
 #define ULONG               u32 /* WTF ??? */
 #define BOOLEAN             u8
 #define PULONG              u32 *
@@ -561,13 +560,13 @@ struct dpram_blk {
 } __attribute__ ((packed));
 
 u16 ft1000_read_register(struct ft1000_device *ft1000dev, u16* Data, u16 nRegIndx);
-u16 ft1000_write_register(struct ft1000_device *ft1000dev, USHORT value, u16 nRegIndx);
-u16 ft1000_read_dpram32(struct ft1000_device *ft1000dev, USHORT indx, u8 *buffer, USHORT cnt);
-u16 ft1000_write_dpram32(struct ft1000_device *ft1000dev, USHORT indx, u8 *buffer, USHORT cnt);
-u16 ft1000_read_dpram16(struct ft1000_device *ft1000dev, USHORT indx, u8 *buffer, u8 highlow);
-u16 ft1000_write_dpram16(struct ft1000_device *ft1000dev, USHORT indx, USHORT value, u8 highlow);
-u16 fix_ft1000_read_dpram32(struct ft1000_device *ft1000dev, USHORT indx, u8 *buffer);
-u16 fix_ft1000_write_dpram32(struct ft1000_device *ft1000dev, USHORT indx, u8 *buffer);
+u16 ft1000_write_register(struct ft1000_device *ft1000dev, u16 value, u16 nRegIndx);
+u16 ft1000_read_dpram32(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer, u16 cnt);
+u16 ft1000_write_dpram32(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer, u16 cnt);
+u16 ft1000_read_dpram16(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer, u8 highlow);
+u16 ft1000_write_dpram16(struct ft1000_device *ft1000dev, u16 indx, u16 value, u8 highlow);
+u16 fix_ft1000_read_dpram32(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer);
+u16 fix_ft1000_write_dpram32(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer);
 
 extern void *pFileStart;
 extern size_t FileLength;
-- 
1.7.1

