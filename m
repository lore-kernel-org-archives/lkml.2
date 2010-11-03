Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351Ab0KCKSA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 06:18:00 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64555 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209Ab0KCKR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 06:17:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=MGMHsshJMS6MpylQfcQ0/3mwnKChaVZ/UltBd/QgEEwBoCooP0vB3JA4POcav03Y+V
         taSBegouGZk7hqC33U9Gl6zdlL4/pod4ELqy5I0NhsIQ5GDDZP2WgOmwwJZB1Jjj3/Yk
         hYPMRL2yvLmexa/7/EzyvunGQa8t2RK3WH8AE=
From: Marek Belisko <marek.belisko@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Marek Belisko <marek.belisko@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@gmail.com>
Subject: [PATCH 1/9] staging: ft1000: Get rid of PUCHAR typedef.
Date: Wed,  3 Nov 2010 11:19:47 +0100
Message-Id: <1288779595-15793-1-git-send-email-marek.belisko@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PUCHAR typedef was replaces by u8 *.

Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c   |    4 +-
 .../staging/ft1000/ft1000-usb/ft1000_download.c    |   44 ++++++++++----------
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c      |   40 +++++++++---------
 drivers/staging/ft1000/ft1000-usb/ft1000_proc.c    |    6 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h     |   11 ++---
 5 files changed, 52 insertions(+), 53 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
index 87a6487..cadfb62 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
@@ -623,10 +623,10 @@ static long ft1000_ChIoctl (struct file *File, unsigned int Command,
         memcpy(get_stat_data.eui64, info->eui64, EUISZ);
 
             if (info->ProgConStat != 0xFF) {
-                ft1000_read_dpram16(ft1000dev, FT1000_MAG_DSP_LED, (PUCHAR)&ledStat, FT1000_MAG_DSP_LED_INDX);
+                ft1000_read_dpram16(ft1000dev, FT1000_MAG_DSP_LED, (u8 *)&ledStat, FT1000_MAG_DSP_LED_INDX);
                 get_stat_data.LedStat = ntohs(ledStat);
                 DEBUG("FT1000:ft1000_ChIoctl: LedStat = 0x%x\n", get_stat_data.LedStat);
-                ft1000_read_dpram16(ft1000dev, FT1000_MAG_DSP_CON_STATE, (PUCHAR)&conStat, FT1000_MAG_DSP_CON_STATE_INDX);
+                ft1000_read_dpram16(ft1000dev, FT1000_MAG_DSP_CON_STATE, (u8 *)&conStat, FT1000_MAG_DSP_CON_STATE_INDX);
                 get_stat_data.ConStat = ntohs(conStat);
                 DEBUG("FT1000:ft1000_ChIoctl: ConStat = 0x%x\n", get_stat_data.ConStat);
             }
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
index 4dd456f..d7ca6cc 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
@@ -228,7 +228,7 @@ static USHORT get_handshake(struct ft1000_device *ft1000dev, USHORT expected_val
                    status = ft1000_write_register (ft1000dev,  FT1000_DB_DNLD_RX, FT1000_REG_DOORBELL);
                }
 
-                status = ft1000_read_dpram16 (ft1000dev, DWNLD_MAG1_HANDSHAKE_LOC, (PUCHAR)&handshake, 1);
+                status = ft1000_read_dpram16 (ft1000dev, DWNLD_MAG1_HANDSHAKE_LOC, (u8 *)&handshake, 1);
                 //DEBUG("get_handshake: handshake is %x\n", tempx);
                 handshake = ntohs(handshake);
                 //DEBUG("get_handshake: after swap, handshake is %x\n", handshake);
@@ -300,10 +300,10 @@ static USHORT get_handshake_usb(struct ft1000_device *ft1000dev, USHORT expected
    while (loopcnt < 100)
    {
        if (pft1000info->usbboot == 2) {
-           status = ft1000_read_dpram32 (ft1000dev, 0, (PUCHAR)&(pft1000info->tempbuf[0]), 64);
+           status = ft1000_read_dpram32 (ft1000dev, 0, (u8 *)&(pft1000info->tempbuf[0]), 64);
            for (temp=0; temp<16; temp++)
                DEBUG("tempbuf %d = 0x%x\n", temp, pft1000info->tempbuf[temp]);
-           status = ft1000_read_dpram16 (ft1000dev, DWNLD_MAG1_HANDSHAKE_LOC, (PUCHAR)&handshake, 1);
+           status = ft1000_read_dpram16 (ft1000dev, DWNLD_MAG1_HANDSHAKE_LOC, (u8 *)&handshake, 1);
            DEBUG("handshake from read_dpram16 = 0x%x\n", handshake);
            if (pft1000info->dspalive == pft1000info->tempbuf[6])
                handshake = 0;
@@ -313,7 +313,7 @@ static USHORT get_handshake_usb(struct ft1000_device *ft1000dev, USHORT expected
            }
        }
        else {
-           status = ft1000_read_dpram16 (ft1000dev, DWNLD_MAG1_HANDSHAKE_LOC, (PUCHAR)&handshake, 1);
+           status = ft1000_read_dpram16 (ft1000dev, DWNLD_MAG1_HANDSHAKE_LOC, (u8 *)&handshake, 1);
        }
        loopcnt++;
        msleep(10);
@@ -356,14 +356,14 @@ static USHORT get_request_type(struct ft1000_device *ft1000dev)
 
    if ( pft1000info->bootmode == 1)
    {
-       status = fix_ft1000_read_dpram32 (ft1000dev, DWNLD_MAG1_TYPE_LOC, (PUCHAR)&tempx);
+       status = fix_ft1000_read_dpram32 (ft1000dev, DWNLD_MAG1_TYPE_LOC, (u8 *)&tempx);
        tempx = ntohl(tempx);
    }
    else
    {
        tempx = 0;
 
-       status = ft1000_read_dpram16 (ft1000dev, DWNLD_MAG1_TYPE_LOC, (PUCHAR)&tempword, 1);
+       status = ft1000_read_dpram16 (ft1000dev, DWNLD_MAG1_TYPE_LOC, (u8 *)&tempword, 1);
        tempx |= (tempword << 16);
        tempx = ntohl(tempx);
    }
@@ -383,7 +383,7 @@ static USHORT get_request_type_usb(struct ft1000_device *ft1000dev)
 	struct ft1000_info *pft1000info = netdev_priv(ft1000dev->net);
    if ( pft1000info->bootmode == 1)
    {
-       status = fix_ft1000_read_dpram32 (ft1000dev, DWNLD_MAG1_TYPE_LOC, (PUCHAR)&tempx);
+       status = fix_ft1000_read_dpram32 (ft1000dev, DWNLD_MAG1_TYPE_LOC, (u8 *)&tempx);
        tempx = ntohl(tempx);
    }
    else
@@ -394,7 +394,7 @@ static USHORT get_request_type_usb(struct ft1000_device *ft1000dev)
        }
        else {
           tempx = 0;
-          status = ft1000_read_dpram16 (ft1000dev, DWNLD_MAG1_TYPE_LOC, (PUCHAR)&tempword, 1);
+          status = ft1000_read_dpram16 (ft1000dev, DWNLD_MAG1_TYPE_LOC, (u8 *)&tempword, 1);
        }
        tempx |= (tempword << 16);
        tempx = ntohl(tempx);
@@ -428,14 +428,14 @@ static long get_request_value(struct ft1000_device *ft1000dev)
 
        if ( pft1000info->bootmode == 1)
        {
-	   status = fix_ft1000_read_dpram32(ft1000dev, DWNLD_MAG1_SIZE_LOC, (PUCHAR)&value);
+	   status = fix_ft1000_read_dpram32(ft1000dev, DWNLD_MAG1_SIZE_LOC, (u8 *)&value);
 	   value = ntohl(value);
        }
        else
        {
-	   status = ft1000_read_dpram16(ft1000dev, DWNLD_MAG1_SIZE_LOC, (PUCHAR)&tempword, 0);
+	   status = ft1000_read_dpram16(ft1000dev, DWNLD_MAG1_SIZE_LOC, (u8 *)&tempword, 0);
 	   value = tempword;
-           status = ft1000_read_dpram16(ft1000dev, DWNLD_MAG1_SIZE_LOC, (PUCHAR)&tempword, 1);
+           status = ft1000_read_dpram16(ft1000dev, DWNLD_MAG1_SIZE_LOC, (u8 *)&tempword, 1);
 	   value |= (tempword << 16);
 	   value = ntohl(value);
        }
@@ -460,7 +460,7 @@ static long get_request_value_usb(struct ft1000_device *ft1000dev)
        }
        else {
           value = 0;
-          status = ft1000_read_dpram16(ft1000dev, DWNLD_MAG1_SIZE_LOC, (PUCHAR)&tempword, 1);
+          status = ft1000_read_dpram16(ft1000dev, DWNLD_MAG1_SIZE_LOC, (u8 *)&tempword, 1);
        }
 
        value |= (tempword << 16);
@@ -494,7 +494,7 @@ static void put_request_value(struct ft1000_device *ft1000dev, long lvalue)
    ULONG    status;
 
        tempx = ntohl(lvalue);
-       status = fix_ft1000_write_dpram32(ft1000dev, DWNLD_MAG1_SIZE_LOC, (PUCHAR)&tempx);
+       status = fix_ft1000_write_dpram32(ft1000dev, DWNLD_MAG1_SIZE_LOC, (u8 *)&tempx);
 
 
 
@@ -602,24 +602,24 @@ static ULONG write_blk (struct ft1000_device *ft1000dev, USHORT **pUsFile, UCHAR
 	      if (pft1000info->bootmode == 0)
 	      {
 		 if (dpram >= 0x3F4)
-                     Status = ft1000_write_dpram32 (ft1000dev, dpram, (PUCHAR)&tempbuffer[0], 8);
+                     Status = ft1000_write_dpram32 (ft1000dev, dpram, (u8 *)&tempbuffer[0], 8);
 	         else
-                    Status = ft1000_write_dpram32 (ft1000dev, dpram, (PUCHAR)&tempbuffer[0], 64);
+                    Status = ft1000_write_dpram32 (ft1000dev, dpram, (u8 *)&tempbuffer[0], 64);
 	      }
 	      else
 	      {
                  for (j=0; j<10; j++)
                  {
-                   Status = ft1000_write_dpram32 (ft1000dev, dpram, (PUCHAR)&tempbuffer[0], 64);
+                   Status = ft1000_write_dpram32 (ft1000dev, dpram, (u8 *)&tempbuffer[0], 64);
 		   if (Status == STATUS_SUCCESS)
 		   {
 		       // Work around for ASIC bit stuffing problem.
 		       if ( (tempbuffer[31] & 0xfe00) == 0xfe00)
 		       {
-      		           Status = ft1000_write_dpram32(ft1000dev, dpram+12, (PUCHAR)&tempbuffer[24], 64);
+      		           Status = ft1000_write_dpram32(ft1000dev, dpram+12, (u8 *)&tempbuffer[24], 64);
 		       }
     		       // Let's check the data written
-	    	       Status = ft1000_read_dpram32 (ft1000dev, dpram, (PUCHAR)&resultbuffer[0], 64);
+	    	       Status = ft1000_read_dpram32 (ft1000dev, dpram, (u8 *)&resultbuffer[0], 64);
 		       if ( (tempbuffer[31] & 0xfe00) == 0xfe00)
 		       {
 		           for (i=0; i<28; i++)
@@ -633,7 +633,7 @@ static ULONG write_blk (struct ft1000_device *ft1000dev, USHORT **pUsFile, UCHAR
 				   break;
 				}
 			   }
-   			   Status = ft1000_read_dpram32 (ft1000dev, dpram+12, (PUCHAR)&resultbuffer[0], 64);
+   			   Status = ft1000_read_dpram32 (ft1000dev, dpram+12, (u8 *)&resultbuffer[0], 64);
 		           for (i=0; i<16; i++)
 		           {
     			       if (resultbuffer[i] != tempbuffer[i+24])
@@ -799,7 +799,7 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, ULONG  FileLe
    ULONG                   image_chksum = 0;
 
    USHORT                  dpram = 0;
-   PUCHAR                  pbuffer;
+   u8 *pbuffer;
 	struct prov_record *pprov_record;
 	struct ft1000_info *pft1000info = netdev_priv(ft1000dev->net);
 
@@ -1066,7 +1066,7 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, ULONG  FileLe
 
                       templong = *pUsData++;
 					  templong |= (*pUsData++ << 16);
-                      Status = fix_ft1000_write_dpram32 (ft1000dev, dpram++, (PUCHAR)&templong);
+                      Status = fix_ft1000_write_dpram32 (ft1000dev, dpram++, (u8 *)&templong);
 
                }
                break;
@@ -1095,7 +1095,7 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, ULONG  FileLe
                       templong = ntohs(*pUsFile++);
 					  temp = ntohs(*pUsFile++);
 					  templong |= (temp << 16);
-                      Status = fix_ft1000_write_dpram32 (ft1000dev, dpram++, (PUCHAR)&templong);
+                      Status = fix_ft1000_write_dpram32 (ft1000dev, dpram++, (u8 *)&templong);
 
                }
                break;
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 1fa1f81..8333e66 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -196,7 +196,7 @@ u16 ft1000_write_register(struct ft1000_device *ft1000dev, USHORT value, u16 nRe
 //
 //---------------------------------------------------------------------------
 
-u16 ft1000_read_dpram32(struct ft1000_device *ft1000dev, USHORT indx, PUCHAR buffer, USHORT cnt)
+u16 ft1000_read_dpram32(struct ft1000_device *ft1000dev, USHORT indx, u8 *buffer, USHORT cnt)
 {
     u16 ret = STATUS_SUCCESS;
 
@@ -235,7 +235,7 @@ u16 ft1000_read_dpram32(struct ft1000_device *ft1000dev, USHORT indx, PUCHAR buf
 // Notes:
 //
 //---------------------------------------------------------------------------
-u16 ft1000_write_dpram32(struct ft1000_device *ft1000dev, USHORT indx, PUCHAR buffer, USHORT cnt)
+u16 ft1000_write_dpram32(struct ft1000_device *ft1000dev, USHORT indx, u8 *buffer, USHORT cnt)
 {
      u16 ret = STATUS_SUCCESS;
 
@@ -272,7 +272,7 @@ u16 ft1000_write_dpram32(struct ft1000_device *ft1000dev, USHORT indx, PUCHAR bu
 // Notes:
 //
 //---------------------------------------------------------------------------
-u16 ft1000_read_dpram16(struct ft1000_device *ft1000dev, USHORT indx, PUCHAR buffer, u8 highlow)
+u16 ft1000_read_dpram16(struct ft1000_device *ft1000dev, USHORT indx, u8 *buffer, u8 highlow)
 {
     u16 ret = STATUS_SUCCESS;
 
@@ -365,7 +365,7 @@ u16 ft1000_write_dpram16(struct ft1000_device *ft1000dev, USHORT indx, USHORT va
 // Notes:
 //
 //---------------------------------------------------------------------------
-u16 fix_ft1000_read_dpram32(struct ft1000_device *ft1000dev, USHORT indx, PUCHAR buffer)
+u16 fix_ft1000_read_dpram32(struct ft1000_device *ft1000dev, USHORT indx, u8 *buffer)
 {
     UCHAR buf[16];
     USHORT pos;
@@ -414,14 +414,14 @@ u16 fix_ft1000_read_dpram32(struct ft1000_device *ft1000dev, USHORT indx, PUCHAR
 // Notes:
 //
 //---------------------------------------------------------------------------
-u16 fix_ft1000_write_dpram32(struct ft1000_device *ft1000dev, USHORT indx, PUCHAR buffer)
+u16 fix_ft1000_write_dpram32(struct ft1000_device *ft1000dev, USHORT indx, u8 *buffer)
 {
     USHORT pos1;
     USHORT pos2;
     USHORT i;
     UCHAR buf[32];
     UCHAR resultbuffer[32];
-    PUCHAR pdata;
+    u8 *pdata;
     u16 ret  = STATUS_SUCCESS;
 
     //DEBUG("fix_ft1000_write_dpram32: Entered:\n");
@@ -445,7 +445,7 @@ u16 fix_ft1000_write_dpram32(struct ft1000_device *ft1000dev, USHORT indx, PUCHA
         return ret;
     }
 
-    ret = ft1000_read_dpram32(ft1000dev, pos1, (PUCHAR)&resultbuffer[0], 16);
+    ret = ft1000_read_dpram32(ft1000dev, pos1, (u8 *)&resultbuffer[0], 16);
     if (ret == STATUS_SUCCESS)
     {
         buffer = pdata;
@@ -460,8 +460,8 @@ u16 fix_ft1000_write_dpram32(struct ft1000_device *ft1000dev, USHORT indx, PUCHA
 
     if (ret == STATUS_FAILURE)
     {
-        ret = ft1000_write_dpram32(ft1000dev, pos1, (PUCHAR)&tempbuffer[0], 16);
-        ret = ft1000_read_dpram32(ft1000dev, pos1, (PUCHAR)&resultbuffer[0], 16);
+        ret = ft1000_write_dpram32(ft1000dev, pos1, (u8 *)&tempbuffer[0], 16);
+        ret = ft1000_read_dpram32(ft1000dev, pos1, (u8 *)&resultbuffer[0], 16);
         if (ret == STATUS_SUCCESS)
         {
             buffer = pdata;
@@ -621,7 +621,7 @@ int dsp_reload(struct ft1000_device *ft1000dev)
     status = ft1000_write_register (ft1000dev, HOST_INTF_BE, FT1000_REG_SUP_CTRL);
 
     // Let's check for FEFE
-    status = ft1000_read_dpram32 (ft1000dev, FT1000_MAG_DPRAM_FEFE_INDX, (PUCHAR)&templong, 4);
+    status = ft1000_read_dpram32 (ft1000dev, FT1000_MAG_DPRAM_FEFE_INDX, (u8 *)&templong, 4);
     DEBUG("templong (fefe) = 0x%8x\n", templong);
 
     // call codeloader
@@ -1485,7 +1485,7 @@ static BOOLEAN ft1000_receive_cmd (struct ft1000_device *dev, u16 *pbuffer, int
     int i;
     u16 tempword;
 
-    ret = ft1000_read_dpram16(dev, FT1000_MAG_PH_LEN, (PUCHAR)&size, FT1000_MAG_PH_LEN_INDX);
+    ret = ft1000_read_dpram16(dev, FT1000_MAG_PH_LEN, (u8 *)&size, FT1000_MAG_PH_LEN_INDX);
     size = ntohs(size) + PSEUDOSZ;
     if (size > maxsz) {
         DEBUG("FT1000:ft1000_receive_cmd:Invalid command length = %d\n", size);
@@ -1596,7 +1596,7 @@ static int ft1000_dsp_prov(void *arg)
             TempShortBuf[1] = htons (len);
             memcpy(&TempShortBuf[2], ppseudo_hdr, len);
 
-            status = ft1000_write_dpram32 (dev, 0, (PUCHAR)&TempShortBuf[0], (unsigned short)(len+2));
+            status = ft1000_write_dpram32 (dev, 0, (u8 *)&TempShortBuf[0], (unsigned short)(len+2));
             status = ft1000_write_register (dev, FT1000_DB_DPRAM_TX, FT1000_REG_DOORBELL);
 
             list_del(&ptr->list);
@@ -1815,7 +1815,7 @@ static int ft1000_proc_drvmsg (struct ft1000_device *dev, u16 size) {
                 }
                 info->DSPInfoBlk[10] = 0x7200;
                 info->DSPInfoBlk[11] = htons(info->DSPInfoBlklen);
-                status = ft1000_write_dpram32 (dev, 0, (PUCHAR)&info->DSPInfoBlk[0], (unsigned short)(info->DSPInfoBlklen+22));
+                status = ft1000_write_dpram32 (dev, 0, (u8 *)&info->DSPInfoBlk[0], (unsigned short)(info->DSPInfoBlklen+22));
                 status = ft1000_write_register (dev, FT1000_DB_DPRAM_TX, FT1000_REG_DOORBELL);
                 info->DrvMsgPend = 0;
 
@@ -1930,14 +1930,14 @@ int ft1000_poll(void* dev_id) {
         if (tempword & FT1000_DB_DPRAM_RX) {
             //DEBUG("ft1000_poll: FT1000_REG_DOORBELL message type:  FT1000_DB_DPRAM_RX\n");
 
-            status = ft1000_read_dpram16(dev, 0x200, (PUCHAR)&data, 0);
+            status = ft1000_read_dpram16(dev, 0x200, (u8 *)&data, 0);
             //DEBUG("ft1000_poll:FT1000_DB_DPRAM_RX:ft1000_read_dpram16:size = 0x%x\n", data);
             size = ntohs(data) + 16 + 2; //wai
             if (size % 4) {
                 modulo = 4 - (size % 4);
                 size = size + modulo;
             }
-            status = ft1000_read_dpram16(dev, 0x201, (PUCHAR)&portid, 1);
+            status = ft1000_read_dpram16(dev, 0x201, (u8 *)&portid, 1);
             portid &= 0xff;
             //DEBUG("ft1000_poll: FT1000_REG_DOORBELL message type: FT1000_DB_DPRAM_RX : portid 0x%x\n", portid);
 
@@ -2072,7 +2072,7 @@ int ft1000_poll(void* dev_id) {
             status = ft1000_write_register (dev, FT1000_ASIC_RESET_REQ, FT1000_REG_DOORBELL);
             status = ft1000_write_register (dev, HOST_INTF_BE, FT1000_REG_SUP_CTRL);
             // copy dsp session record from Adapter block
-            status = ft1000_write_dpram32 (dev, 0, (PUCHAR)&info->DSPSess.Rec[0], 1024);
+            status = ft1000_write_dpram32 (dev, 0, (u8 *)&info->DSPSess.Rec[0], 1024);
             // Program WMARK register
             status = ft1000_write_register (dev, 0x600, FT1000_REG_MAG_WATERMARK);
             // ring doorbell to tell DSP that ASIC is out of reset
@@ -2086,10 +2086,10 @@ int ft1000_poll(void* dev_id) {
             if (info->fAppMsgPend == 0) {
                // Reset ASIC and DSP
 
-                status    = ft1000_read_dpram16(dev, FT1000_MAG_DSP_TIMER0, (PUCHAR)&(info->DSP_TIME[0]), FT1000_MAG_DSP_TIMER0_INDX);
-                status    = ft1000_read_dpram16(dev, FT1000_MAG_DSP_TIMER1, (PUCHAR)&(info->DSP_TIME[1]), FT1000_MAG_DSP_TIMER1_INDX);
-                status    = ft1000_read_dpram16(dev, FT1000_MAG_DSP_TIMER2, (PUCHAR)&(info->DSP_TIME[2]), FT1000_MAG_DSP_TIMER2_INDX);
-                status    = ft1000_read_dpram16(dev, FT1000_MAG_DSP_TIMER3, (PUCHAR)&(info->DSP_TIME[3]), FT1000_MAG_DSP_TIMER3_INDX);
+                status    = ft1000_read_dpram16(dev, FT1000_MAG_DSP_TIMER0, (u8 *)&(info->DSP_TIME[0]), FT1000_MAG_DSP_TIMER0_INDX);
+                status    = ft1000_read_dpram16(dev, FT1000_MAG_DSP_TIMER1, (u8 *)&(info->DSP_TIME[1]), FT1000_MAG_DSP_TIMER1_INDX);
+                status    = ft1000_read_dpram16(dev, FT1000_MAG_DSP_TIMER2, (u8 *)&(info->DSP_TIME[2]), FT1000_MAG_DSP_TIMER2_INDX);
+                status    = ft1000_read_dpram16(dev, FT1000_MAG_DSP_TIMER3, (u8 *)&(info->DSP_TIME[3]), FT1000_MAG_DSP_TIMER3_INDX);
                 info->CardReady = 0;
                 info->DrvErrNum = DSP_CONDRESET_INFO;
                 DEBUG("ft1000_hw:DSP conditional reset requested\n");
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c b/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
index 36cdd58..dda0e33 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
@@ -39,7 +39,7 @@
 
 
 u16 ft1000_read_dpram16 (struct ft1000_device *ft1000dev, USHORT indx,
-			 PUCHAR buffer, u8 highlow);
+			 u8 *buffer, u8 highlow);
 
 
 static int
@@ -77,11 +77,11 @@ ft1000ReadProc (char *page, char **start, off_t off, int count, int *eof,
   if (info->ProgConStat != 0xFF)
     {
       ft1000_read_dpram16 (info->pFt1000Dev, FT1000_MAG_DSP_LED,
-			   (PUCHAR) & ledStat, FT1000_MAG_DSP_LED_INDX);
+			   (u8 *)&ledStat, FT1000_MAG_DSP_LED_INDX);
       info->LedStat = ntohs (ledStat);
 
       ft1000_read_dpram16 (info->pFt1000Dev, FT1000_MAG_DSP_CON_STATE,
-			   (PUCHAR) & conStat, FT1000_MAG_DSP_CON_STATE_INDX);
+			   (u8 *)&conStat, FT1000_MAG_DSP_CON_STATE_INDX);
       info->ConStat = ntohs (conStat);
       do_gettimeofday (&tv);
       delta = (tv.tv_sec - info->ConTm);
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
index 503481a..4996da9 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
@@ -104,7 +104,6 @@ struct prov_record {
 #define BOOLEAN             u8
 #define PULONG              u32 *
 #define PUSHORT             u16 *
-#define PUCHAR              u8 *
 #define PCHAR               u8 *
 #define UINT                u32
 
@@ -565,12 +564,12 @@ struct dpram_blk {
 
 u16 ft1000_read_register(struct ft1000_device *ft1000dev, u16* Data, u16 nRegIndx);
 u16 ft1000_write_register(struct ft1000_device *ft1000dev, USHORT value, u16 nRegIndx);
-u16 ft1000_read_dpram32(struct ft1000_device *ft1000dev, USHORT indx, PUCHAR buffer, USHORT cnt);
-u16 ft1000_write_dpram32(struct ft1000_device *ft1000dev, USHORT indx, PUCHAR buffer, USHORT cnt);
-u16 ft1000_read_dpram16(struct ft1000_device *ft1000dev, USHORT indx, PUCHAR buffer, u8 highlow);
+u16 ft1000_read_dpram32(struct ft1000_device *ft1000dev, USHORT indx, u8 *buffer, USHORT cnt);
+u16 ft1000_write_dpram32(struct ft1000_device *ft1000dev, USHORT indx, u8 *buffer, USHORT cnt);
+u16 ft1000_read_dpram16(struct ft1000_device *ft1000dev, USHORT indx, u8 *buffer, u8 highlow);
 u16 ft1000_write_dpram16(struct ft1000_device *ft1000dev, USHORT indx, USHORT value, u8 highlow);
-u16 fix_ft1000_read_dpram32(struct ft1000_device *ft1000dev, USHORT indx, PUCHAR buffer);
-u16 fix_ft1000_write_dpram32(struct ft1000_device *ft1000dev, USHORT indx, PUCHAR buffer);
+u16 fix_ft1000_read_dpram32(struct ft1000_device *ft1000dev, USHORT indx, u8 *buffer);
+u16 fix_ft1000_write_dpram32(struct ft1000_device *ft1000dev, USHORT indx, u8 *buffer);
 
 extern void *pFileStart;
 extern size_t FileLength;
-- 
1.7.1

