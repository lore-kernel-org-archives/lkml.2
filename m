Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168Ab0LNNAh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 08:00:37 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:56726 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759241Ab0LNNAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 08:00:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=sduRV/DQstcEaHVa/UjEQKRDtuGOmEyAqCusHc6acyA1ZJU8VllEHhOnb8RHI4VA/6
         Qz5wYPYh5ipxw5Aj0wwVb5JnZ6B+iaePJFKcQ7AjztVsSacdS5oAo5+H+r7v8VF4BEzL
         fE7qEI2xzDj2mKltZtgaqepcGSc+jeGLfYSnI=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 1/2] staging: ft1000: Fix camelcase variable names.
Date: Tue, 14 Dec 2010 14:02:54 +0100
Message-Id: <1292331775-3124-1-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 .../staging/ft1000/ft1000-usb/ft1000_download.c    |  204 ++++++++++----------
 1 files changed, 102 insertions(+), 102 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
index e4905ad..17546d8 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
@@ -772,26 +772,26 @@ static u32 write_blk_fifo (struct ft1000_device *ft1000dev, u16 **pUsFile, u8 **
 
 u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, u32  FileLength)
 {
-   u16                     Status = STATUS_SUCCESS;
-   u32                    uiState;
+   u16                     status = STATUS_SUCCESS;
+   u32                    state;
    u16                  handshake;
-	struct pseudo_hdr *pHdr;
-   u16                  usHdrLength;
+	struct pseudo_hdr *pseudo_header;
+   u16                  pseudo_header_len;
    long                    word_length;
    u16                  request;
    u16                  temp;
    u16                  tempword;
 
-	struct dsp_file_hdr *pFileHdr5;
-	struct dsp_image_info *pDspImageInfoV6 = NULL;
+	struct dsp_file_hdr *file_hdr;
+	struct dsp_image_info *dsp_img_info = NULL;
    long                    requested_version;
-   bool                 bGoodVersion;
-	struct drv_msg *pMailBoxData;
-   u16                  *pUsData = NULL;
-   u16                  *pUsFile = NULL;
-   u8                   *pUcFile = NULL;
-   u8                   *pBootEnd = NULL, *pCodeEnd= NULL;
-   int                     imageN;
+   bool                 correct_version;
+	struct drv_msg *mailbox_data;
+   u16                  *data = NULL;
+   u16                  *s_file = NULL;
+   u8                   *c_file = NULL;
+   u8                   *boot_end = NULL, *code_end= NULL;
+   int                     image;
    long                    loader_code_address, loader_code_size = 0;
    long                    run_address = 0, run_size = 0;
 
@@ -814,24 +814,24 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, u32  FileLeng
    // Get version id of file, at first 4 bytes of file, for newer files.
    //
 
-   uiState = STATE_START_DWNLD;
+   state = STATE_START_DWNLD;
 
-   pFileHdr5 = (struct dsp_file_hdr *)pFileStart;
+   file_hdr = (struct dsp_file_hdr *)pFileStart;
 
    ft1000_write_register (ft1000dev, 0x800, FT1000_REG_MAG_WATERMARK);
 
-      pUsFile = (u16 *)(pFileStart + pFileHdr5->loader_offset);
-      pUcFile = (u8 *)(pFileStart + pFileHdr5->loader_offset);
+      s_file = (u16 *)(pFileStart + file_hdr->loader_offset);
+      c_file = (u8 *)(pFileStart + file_hdr->loader_offset);
 
-      pBootEnd = (u8 *)(pFileStart + pFileHdr5->loader_code_end);
+      boot_end = (u8 *)(pFileStart + file_hdr->loader_code_end);
 
-      loader_code_address = pFileHdr5->loader_code_address;
-      loader_code_size = pFileHdr5->loader_code_size;
-      bGoodVersion = FALSE;
+      loader_code_address = file_hdr->loader_code_address;
+      loader_code_size = file_hdr->loader_code_size;
+      correct_version = FALSE;
 
-   while ((Status == STATUS_SUCCESS) && (uiState != STATE_DONE_FILE))
+   while ((status == STATUS_SUCCESS) && (state != STATE_DONE_FILE))
    {
-      switch (uiState)
+      switch (state)
       {
       case  STATE_START_DWNLD:
          DEBUG("FT1000:STATE_START_DWNLD\n");
@@ -848,10 +848,10 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, u32  FileLeng
          else
          {
             DEBUG("FT1000:download:Download error: Handshake failed\n");
-            Status = STATUS_FAILURE;
+            status = STATUS_FAILURE;
          }
 
-         uiState = STATE_BOOT_DWNLD;
+         state = STATE_BOOT_DWNLD;
 
          break;
 
@@ -878,11 +878,11 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, u32  FileLeng
             case  REQUEST_DONE_BL:
                DEBUG("FT1000:REQUEST_DONE_BL\n");
                /* Reposition ptrs to beginning of code section */
-               pUsFile = (u16 *)(pBootEnd);
-               pUcFile = (u8 *)(pBootEnd);
-               //DEBUG("FT1000:download:pUsFile = 0x%8x\n", (int)pUsFile);
-               //DEBUG("FT1000:download:pUcFile = 0x%8x\n", (int)pUcFile);
-               uiState = STATE_CODE_DWNLD;
+               s_file = (u16 *)(boot_end);
+               c_file = (u8 *)(boot_end);
+               //DEBUG("FT1000:download:s_file = 0x%8x\n", (int)s_file);
+               //DEBUG("FT1000:download:c_file = 0x%8x\n", (int)c_file);
+               state = STATE_CODE_DWNLD;
                pft1000info->fcodeldr = 1;
                break;
             case  REQUEST_CODE_SEGMENT:
@@ -893,17 +893,17 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, u32  FileLeng
                if (word_length > MAX_LENGTH)
                {
                   DEBUG("FT1000:download:Download error: Max length exceeded\n");
-                  Status = STATUS_FAILURE;
+                  status = STATUS_FAILURE;
                   break;
                }
-               if ( (word_length*2 + pUcFile) > pBootEnd)
+               if ( (word_length*2 + c_file) > boot_end)
                {
                   /*
                    * Error, beyond boot code range.
                    */
                   DEBUG("FT1000:download:Download error: Requested len=%d exceeds BOOT code boundry.\n",
                                                             (int)word_length);
-                  Status = STATUS_FAILURE;
+                  status = STATUS_FAILURE;
                   break;
                }
                /*
@@ -914,12 +914,12 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, u32  FileLeng
 						word_length++;
 					word_length = word_length / 2;
 
-			Status =   write_blk(ft1000dev, &pUsFile, &pUcFile, word_length);
-			//DEBUG("write_blk returned %d\n", Status);
+			status =   write_blk(ft1000dev, &s_file, &c_file, word_length);
+			//DEBUG("write_blk returned %d\n", status);
                break;
             default:
                DEBUG("FT1000:download:Download error: Bad request type=%d in BOOT download state.\n",request);
-               Status = STATUS_FAILURE;
+               status = STATUS_FAILURE;
                break;
             }
             if (pft1000info->usbboot)
@@ -930,7 +930,7 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, u32  FileLeng
          else
          {
             DEBUG("FT1000:download:Download error: Handshake failed\n");
-            Status = STATUS_FAILURE;
+            status = STATUS_FAILURE;
          }
 
          break;
@@ -959,7 +959,7 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, u32  FileLeng
                 break;
             case  REQUEST_RUN_ADDRESS:
                DEBUG("FT1000:download:  REQUEST_RUN_ADDRESS\n");
-               if (bGoodVersion)
+               if (correct_version)
                {
                   DEBUG("FT1000:download:run_address = 0x%8x\n", (int)run_address);
                   put_request_value(ft1000dev, run_address);
@@ -967,13 +967,13 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, u32  FileLeng
                else
                {
                   DEBUG("FT1000:download:Download error: Got Run address request before image offset request.\n");
-                  Status = STATUS_FAILURE;
+                  status = STATUS_FAILURE;
                   break;
                }
                break;
             case  REQUEST_CODE_LENGTH:
                DEBUG("FT1000:download:REQUEST_CODE_LENGTH\n");
-               if (bGoodVersion)
+               if (correct_version)
                {
                   DEBUG("FT1000:download:run_size = 0x%8x\n", (int)run_size);
                   put_request_value(ft1000dev, run_size);
@@ -981,23 +981,23 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, u32  FileLeng
                else
                {
                   DEBUG("FT1000:download:Download error: Got Size request before image offset request.\n");
-                  Status = STATUS_FAILURE;
+                  status = STATUS_FAILURE;
                   break;
                }
                break;
             case  REQUEST_DONE_CL:
                pft1000info->usbboot = 3;
                /* Reposition ptrs to beginning of provisioning section */
-                  pUsFile = (u16 *)(pFileStart + pFileHdr5->commands_offset);
-                  pUcFile = (u8 *)(pFileStart + pFileHdr5->commands_offset);
-               uiState = STATE_DONE_DWNLD;
+                  s_file = (u16 *)(pFileStart + file_hdr->commands_offset);
+                  c_file = (u8 *)(pFileStart + file_hdr->commands_offset);
+               state = STATE_DONE_DWNLD;
                break;
             case  REQUEST_CODE_SEGMENT:
                //DEBUG("FT1000:download: REQUEST_CODE_SEGMENT - CODELOADER\n");
-               if (!bGoodVersion)
+               if (!correct_version)
                {
                   DEBUG("FT1000:download:Download error: Got Code Segment request before image offset request.\n");
-                  Status = STATUS_FAILURE;
+                  status = STATUS_FAILURE;
                   break;
                }
 #if 0
@@ -1011,17 +1011,17 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, u32  FileLeng
 #endif
                {
                   DEBUG("FT1000:download:Download error: Max length exceeded\n");
-                  Status = STATUS_FAILURE;
+                  status = STATUS_FAILURE;
                   break;
                }
-               if ( (word_length*2 + pUcFile) > pCodeEnd)
+               if ( (word_length*2 + c_file) > code_end)
                {
                   /*
                    * Error, beyond boot code range.
                    */
                   DEBUG("FT1000:download:Download error: Requested len=%d exceeds DSP code boundry.\n",
                                (int)word_length);
-                  Status = STATUS_FAILURE;
+                  status = STATUS_FAILURE;
                   break;
                }
                /*
@@ -1032,7 +1032,7 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, u32  FileLeng
 			word_length++;
 		   word_length = word_length / 2;
 
-   	       write_blk_fifo (ft1000dev, &pUsFile, &pUcFile, word_length);
+   	       write_blk_fifo (ft1000dev, &s_file, &c_file, word_length);
                if (pft1000info->usbboot == 0)
                    pft1000info->usbboot++;
                if (pft1000info->usbboot == 1) {
@@ -1047,13 +1047,13 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, u32  FileLeng
                // Convert length from byte count to word count. Make sure we round up.
                word_length = (long)(pft1000info->DSPInfoBlklen + 1)/2;
                put_request_value(ft1000dev, word_length);
-		pMailBoxData = (struct drv_msg *)&(pft1000info->DSPInfoBlk[0]);
+		mailbox_data = (struct drv_msg *)&(pft1000info->DSPInfoBlk[0]);
                /*
                 * Position ASIC DPRAM auto-increment pointer.
                 */
 
 
-                   pUsData = (u16 *)&pMailBoxData->data[0];
+                   data = (u16 *)&mailbox_data->data[0];
                    dpram = (u16)DWNLD_MAG1_PS_HDR_LOC;
                    if (word_length & 0x1)
                        word_length++;
@@ -1064,22 +1064,22 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, u32  FileLeng
                for (; word_length > 0; word_length--) /* In words */
                {
 
-                      templong = *pUsData++;
-					  templong |= (*pUsData++ << 16);
-                      Status = fix_ft1000_write_dpram32 (ft1000dev, dpram++, (u8 *)&templong);
+                      templong = *data++;
+					  templong |= (*data++ << 16);
+                      status = fix_ft1000_write_dpram32 (ft1000dev, dpram++, (u8 *)&templong);
 
                }
                break;
 
             case  REQUEST_VERSION_INFO:
                DEBUG("FT1000:download:REQUEST_VERSION_INFO\n");
-               word_length = pFileHdr5->version_data_size;
+               word_length = file_hdr->version_data_size;
                put_request_value(ft1000dev, word_length);
                /*
                 * Position ASIC DPRAM auto-increment pointer.
                 */
 
-               pUsFile = (u16 *)(pFileStart + pFileHdr5->version_data_offset);
+               s_file = (u16 *)(pFileStart + file_hdr->version_data_offset);
 
 
                    dpram = (u16)DWNLD_MAG1_PS_HDR_LOC;
@@ -1092,59 +1092,59 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, u32  FileLeng
                for (; word_length > 0; word_length--) /* In words */
                {
 
-                      templong = ntohs(*pUsFile++);
-					  temp = ntohs(*pUsFile++);
+                      templong = ntohs(*s_file++);
+					  temp = ntohs(*s_file++);
 					  templong |= (temp << 16);
-                      Status = fix_ft1000_write_dpram32 (ft1000dev, dpram++, (u8 *)&templong);
+                      status = fix_ft1000_write_dpram32 (ft1000dev, dpram++, (u8 *)&templong);
 
                }
                break;
 
             case  REQUEST_CODE_BY_VERSION:
                DEBUG("FT1000:download:REQUEST_CODE_BY_VERSION\n");
-               bGoodVersion = FALSE;
+               correct_version = FALSE;
                requested_version = get_request_value(ft1000dev);
 
-                   pDspImageInfoV6 = (struct dsp_image_info *)(pFileStart + sizeof(struct dsp_file_hdr ));
+                   dsp_img_info = (struct dsp_image_info *)(pFileStart + sizeof(struct dsp_file_hdr ));
 
-               for (imageN = 0; imageN < pFileHdr5->nDspImages; imageN++)
+               for (image = 0; image < file_hdr->nDspImages; image++)
                {
 
-                       temp = (u16)(pDspImageInfoV6->version);
+                       temp = (u16)(dsp_img_info->version);
                        templong = temp;
-                       temp = (u16)(pDspImageInfoV6->version >> 16);
+                       temp = (u16)(dsp_img_info->version >> 16);
                        templong |= (temp << 16);
                    if (templong == (u32)requested_version)
                        {
-                           bGoodVersion = TRUE;
-                           DEBUG("FT1000:download: bGoodVersion is TRUE\n");
-                           pUsFile = (u16 *)(pFileStart + pDspImageInfoV6->begin_offset);
-                           pUcFile = (u8 *)(pFileStart + pDspImageInfoV6->begin_offset);
-                           pCodeEnd = (u8 *)(pFileStart + pDspImageInfoV6->end_offset);
-                           run_address = pDspImageInfoV6->run_address;
-                           run_size = pDspImageInfoV6->image_size;
-                           image_chksum = (u32)pDspImageInfoV6->checksum;
+                           correct_version = TRUE;
+                           DEBUG("FT1000:download: correct_version is TRUE\n");
+                           s_file = (u16 *)(pFileStart + dsp_img_info->begin_offset);
+                           c_file = (u8 *)(pFileStart + dsp_img_info->begin_offset);
+                           code_end = (u8 *)(pFileStart + dsp_img_info->end_offset);
+                           run_address = dsp_img_info->run_address;
+                           run_size = dsp_img_info->image_size;
+                           image_chksum = (u32)dsp_img_info->checksum;
                            break;
                         }
-                        pDspImageInfoV6++;
+                        dsp_img_info++;
 
 
                } //end of for
 
-               if (!bGoodVersion)
+               if (!correct_version)
                {
                   /*
                    * Error, beyond boot code range.
                    */
                   DEBUG("FT1000:download:Download error: Bad Version Request = 0x%x.\n",(int)requested_version);
-                  Status = STATUS_FAILURE;
+                  status = STATUS_FAILURE;
                   break;
                }
                break;
 
             default:
                DEBUG("FT1000:download:Download error: Bad request type=%d in CODE download state.\n",request);
-               Status = STATUS_FAILURE;
+               status = STATUS_FAILURE;
                break;
             }
             if (pft1000info->usbboot)
@@ -1155,94 +1155,94 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, u32  FileLeng
          else
          {
             DEBUG("FT1000:download:Download error: Handshake failed\n");
-            Status = STATUS_FAILURE;
+            status = STATUS_FAILURE;
          }
 
          break;
 
       case STATE_DONE_DWNLD:
          DEBUG("FT1000:download:Code loader is done...\n");
-         uiState = STATE_SECTION_PROV;
+         state = STATE_SECTION_PROV;
          break;
 
       case  STATE_SECTION_PROV:
          DEBUG("FT1000:download:STATE_SECTION_PROV\n");
-		pHdr = (struct pseudo_hdr *)pUcFile;
+		pseudo_header = (struct pseudo_hdr *)c_file;
 
-         if (pHdr->checksum == hdr_checksum(pHdr))
+         if (pseudo_header->checksum == hdr_checksum(pseudo_header))
          {
-            if (pHdr->portdest != 0x80 /* Dsp OAM */)
+            if (pseudo_header->portdest != 0x80 /* Dsp OAM */)
             {
-               uiState = STATE_DONE_PROV;
+               state = STATE_DONE_PROV;
                break;
             }
-            usHdrLength = ntohs(pHdr->length);    /* Byte length for PROV records */
+            pseudo_header_len = ntohs(pseudo_header->length);    /* Byte length for PROV records */
 
             // Get buffer for provisioning data
-		pbuffer = kmalloc((usHdrLength + sizeof(struct pseudo_hdr)), GFP_ATOMIC);
+		pbuffer = kmalloc((pseudo_header_len + sizeof(struct pseudo_hdr)), GFP_ATOMIC);
             if (pbuffer) {
-		memcpy(pbuffer, (void *)pUcFile, (u32)(usHdrLength + sizeof(struct pseudo_hdr)));
+		memcpy(pbuffer, (void *)c_file, (u32)(pseudo_header_len + sizeof(struct pseudo_hdr)));
                 // link provisioning data
 		pprov_record = kmalloc(sizeof(struct prov_record), GFP_ATOMIC);
                 if (pprov_record) {
                     pprov_record->pprov_data = pbuffer;
                     list_add_tail (&pprov_record->list, &pft1000info->prov_list);
                     // Move to next entry if available
-			pUcFile = (u8 *)((unsigned long)pUcFile + (u32)((usHdrLength + 1) & 0xFFFFFFFE) + sizeof(struct pseudo_hdr));
-                    if ( (unsigned long)(pUcFile) - (unsigned long)(pFileStart) >= (unsigned long)FileLength) {
-                       uiState = STATE_DONE_FILE;
+			c_file = (u8 *)((unsigned long)c_file + (u32)((pseudo_header_len + 1) & 0xFFFFFFFE) + sizeof(struct pseudo_hdr));
+                    if ( (unsigned long)(c_file) - (unsigned long)(pFileStart) >= (unsigned long)FileLength) {
+                       state = STATE_DONE_FILE;
                     }
                 }
                 else {
                     kfree(pbuffer);
-                    Status = STATUS_FAILURE;
+                    status = STATUS_FAILURE;
                 }
             }
             else {
-                Status = STATUS_FAILURE;
+                status = STATUS_FAILURE;
             }
          }
          else
          {
             /* Checksum did not compute */
-            Status = STATUS_FAILURE;
+            status = STATUS_FAILURE;
          }
-         DEBUG("ft1000:download: after STATE_SECTION_PROV, uiState = %d, Status= %d\n", uiState, Status);
+         DEBUG("ft1000:download: after STATE_SECTION_PROV, state = %d, status= %d\n", state, status);
          break;
 
       case  STATE_DONE_PROV:
          DEBUG("FT1000:download:STATE_DONE_PROV\n");
-         uiState = STATE_DONE_FILE;
+         state = STATE_DONE_FILE;
          break;
 
 
       default:
-         Status = STATUS_FAILURE;
+         status = STATUS_FAILURE;
          break;
       } /* End Switch */
 
-      if (Status != STATUS_SUCCESS) {
+      if (status != STATUS_SUCCESS) {
           break;
       }
 
 /****
       // Check if Card is present
-      Status = Harley_Read_Register(&temp, FT1000_REG_SUP_IMASK);
-      if ( (Status != NDIS_STATUS_SUCCESS) || (temp == 0x0000) ) {
+      status = Harley_Read_Register(&temp, FT1000_REG_SUP_IMASK);
+      if ( (status != NDIS_STATUS_SUCCESS) || (temp == 0x0000) ) {
           break;
       }
 
-      Status = Harley_Read_Register(&temp, FT1000_REG_ASIC_ID);
-      if ( (Status != NDIS_STATUS_SUCCESS) || (temp == 0xffff) ) {
+      status = Harley_Read_Register(&temp, FT1000_REG_ASIC_ID);
+      if ( (status != NDIS_STATUS_SUCCESS) || (temp == 0xffff) ) {
           break;
       }
 ****/
 
    } /* End while */
 
-   DEBUG("Download exiting with status = 0x%8x\n", Status);
+   DEBUG("Download exiting with status = 0x%8x\n", status);
    ft1000_write_register(ft1000dev, FT1000_DB_DNLD_TX, FT1000_REG_DOORBELL);
 
-   return Status;
+   return status;
 }
 
-- 
1.7.1

