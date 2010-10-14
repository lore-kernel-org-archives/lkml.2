Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab0JNJjb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 05:39:31 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64563 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755465Ab0JNJjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 05:39:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=hGw1IPErkJVkYKwaHobNjazKNxKu8IdWP7pSC50kG3U349car3OE/Xq0dhDM2LyomN
         4OAJVTBMf6gNYvl4XkRqu2TbcqmVLZGZqYfYi7Oy7R4IFFQuOyek70/WpeHNPPON4vsO
         Sc0LW77z3nJ0QG3rYyMFRwRHi7u9I6/z4N+SY=
From: Marek Belisko <marek.belisko@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Marek Belisko <marek.belisko@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Marek Belisko <marek.belisko@gmail.com>
Subject: [PATCH 5/5] staging:ft1000: remove dead code.
Date: Thu, 14 Oct 2010 11:41:00 +0200
Message-Id: <1287049260-11988-6-git-send-email-marek.belisko@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287049260-11988-1-git-send-email-marek.belisko@gmail.com>
References: <1287049260-11988-1-git-send-email-marek.belisko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

was #ifdef so remove code which was under #else to make
code more readable.

Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
---
 .../staging/ft1000/ft1000-usb/ft1000_download.c    |   79 +-------------------
 1 files changed, 2 insertions(+), 77 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
index bbb2430..4e506aa 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
@@ -17,7 +17,6 @@
 #include <linux/vmalloc.h>
 #include "ft1000_usb.h"
 
-#define  FIFO_DNLD               1
 
 #define  DWNLD_HANDSHAKE_LOC     0x02
 #define  DWNLD_TYPE_LOC          0x04
@@ -140,9 +139,7 @@ static ULONG check_usb_db (struct ft1000_device *ft1000dev)
       {
            DEBUG("FT1000:Got checkusb doorbell\n");
            status = ft1000_write_register (ft1000dev, 0x0080, FT1000_REG_DOORBELL);
-#if FIFO_DNLD
            status = ft1000_write_register (ft1000dev, 0x0100, FT1000_REG_DOORBELL);
-#endif
            status = ft1000_write_register (ft1000dev,  0x8000, FT1000_REG_DOORBELL);
            break;
       }
@@ -214,7 +211,6 @@ static USHORT get_handshake(struct ft1000_device *ft1000dev, USHORT expected_val
    while (loopcnt < 100)
    {
 
-#if FIFO_DNLD
            // Need to clear downloader doorbell if Hartley ASIC
            status = ft1000_write_register (ft1000dev,  FT1000_DB_DNLD_RX, FT1000_REG_DOORBELL);
            //DEBUG("FT1000:get_handshake:doorbell = 0x%x\n", temp);
@@ -236,47 +232,6 @@ static USHORT get_handshake(struct ft1000_device *ft1000dev, USHORT expected_val
                 //DEBUG("get_handshake: handshake is %x\n", tempx);
                 handshake = ntohs(handshake);
                 //DEBUG("get_handshake: after swap, handshake is %x\n", handshake);
-#else
-           // Need to clear downloader doorbell if Hartley ASIC
-           status = ft1000_read_register (ft1000dev, &temp, FT1000_REG_DOORBELL);
-           //DEBUG("FT1000:get_handshake:doorbell = 0x%x\n", temp);
-           if (temp)
-           {
-               if (temp & FT1000_DB_DNLD_RX)
-               {
-                   //DEBUG("get_handshake: write FT1000_DB_DNLD_RX to doorbell register\n");
-                   status = ft1000_write_register(ft1000dev, FT1000_DB_DNLD_RX, FT1000_REG_DOORBELL);
-               }
-
-               if (pft1000info->fcodeldr)
-               {
-                   DEBUG(" get_handshake: fcodeldr is %d\n", pft1000info->fcodeldr);
-                   pft1000info->fcodeldr = 0;
-                   status = check_usb_db(ft1000dev);
-                   if (status != STATUS_SUCCESS)
-                   {
-                       DEBUG("get_handshake: check_usb_db failed\n");
-                       status = STATUS_FAILURE;
-                       break;
-                   }
-
-                   status = ft1000_read_register (ft1000dev, &temp, FT1000_REG_DOORBELL);
-                   //DEBUG("FT1000:get_handshake:doorbell = 0x%x\n", temp);
-                   if (temp)
-                   {
-                       if (temp & FT1000_DB_DNLD_RX)
-                           status = ft1000_write_register(ft1000dev,FT1000_DB_DNLD_RX, FT1000_REG_DOORBELL);
-                   }
-                }
-
-                status = ft1000_read_dpram16 (ft1000dev, DWNLD_MAG1_HANDSHAKE_LOC, (PUCHAR)&handshake, 1);
-                //DEBUG("get_handshake: handshake is %x\n", tempx);
-                handshake = ntohs(handshake);
-                //DEBUG("get_handshake: after swap, handshake is %x\n", handshake);
-
-           } //end of if temp
-#endif
-
 
         if (status)
            return HANDSHAKE_TIMEOUT_VALUE;
@@ -318,7 +273,6 @@ static void put_handshake(struct ft1000_device *ft1000dev,USHORT handshake_value
 {
     ULONG tempx;
     USHORT tempword;
-    int i;
     ULONG status;
 
 
@@ -331,23 +285,6 @@ static void put_handshake(struct ft1000_device *ft1000dev,USHORT handshake_value
         tempword = (USHORT)(tempx >> 16);
         status = ft1000_write_dpram16 (ft1000dev, DWNLD_MAG1_HANDSHAKE_LOC, tempword, 1);
         status = ft1000_write_register(ft1000dev, FT1000_DB_DNLD_TX, FT1000_REG_DOORBELL);
-#if FIFO_DNLD
-        for (i=0; i<1000; i++);
-#else
-        for (i=0; i<10; i++)
-        {
-            status = ft1000_read_register (ft1000dev, &tempword, FT1000_REG_DOORBELL);
-            if ((tempword & FT1000_DB_DNLD_TX) == 0)
-                break;
-        }
-        if (i==10)
-        {
-            DEBUG("FT1000:put_handshake could not clear Tx doorbell\n");
-            status = ft1000_read_register (ft1000dev, &tempword, FT1000_REG_DOORBELL);
-            DEBUG("FT1000:put_handshake:doorbell = 0x%x\n",tempword);
-        }
-#endif
-
 }
 
 static USHORT get_handshake_usb(struct ft1000_device *ft1000dev, USHORT expected_value)
@@ -424,12 +361,8 @@ static USHORT get_request_type(struct ft1000_device *ft1000dev)
    }
    else
    {
-#if FIFO_DNLD
        tempx = 0;
-#else
-       status = ft1000_read_dpram16 (ft1000dev, DWNLD_MAG1_TYPE_LOC, (PUCHAR)&tempword, 0);
-       tempx = tempword;
-#endif
+
        status = ft1000_read_dpram16 (ft1000dev, DWNLD_MAG1_TYPE_LOC, (PUCHAR)&tempword, 1);
        tempx |= (tempword << 16);
        tempx = ntohl(tempx);
@@ -533,10 +466,8 @@ static long get_request_value_usb(struct ft1000_device *ft1000dev)
        value |= (tempword << 16);
        value = ntohl(value);
 
-#if FIFO_DNLD
    if (pft1000info->usbboot == 1)
        pft1000info->usbboot = 2;
-#endif
 
    //DEBUG("get_request_value_usb: value is %x\n", value);
    return value;
@@ -1056,9 +987,7 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, ULONG  FileLe
                }
                break;
             case  REQUEST_DONE_CL:
-#if FIFO_DNLD
                pft1000info->usbboot = 3;
-#endif
                /* Reposition ptrs to beginning of provisioning section */
                   pUsFile = (USHORT *)(pFileStart + pFileHdr5->commands_offset);
                   pUcFile = (UCHAR *)(pFileStart + pFileHdr5->commands_offset);
@@ -1104,7 +1033,6 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, ULONG  FileLe
 			word_length++;
 		   word_length = word_length / 2;
 
-#if FIFO_DNLD
    	       write_blk_fifo (ft1000dev, &pUsFile, &pUcFile, word_length);
                if (pft1000info->usbboot == 0)
                    pft1000info->usbboot++;
@@ -1112,10 +1040,7 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, ULONG  FileLe
                    tempword = 0;
                    ft1000_write_dpram16 (ft1000dev, DWNLD_MAG1_PS_HDR_LOC, tempword, 0);
                }
-#else
-   	       write_blk (ft1000dev, &pUsFile, &pUcFile, word_length);
-   	       //ft1000_write_dpram32 (ft1000dev, dpram, (PUCHAR)pUcFile, word_length);
-#endif
+
                break;
 
             case  REQUEST_MAILBOX_DATA:
-- 
1.7.1

