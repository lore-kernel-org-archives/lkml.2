Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab0KCKSG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 06:18:06 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64555 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234Ab0KCKSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 06:18:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=PeIYfQaSIQgpP0FXUGTL6Obd6bVjkfeu3mB3+J1XImMmKr5Ainp4Y3X5NJM1KvEdu5
         mUoEiWpjKk/eldGhROUyR8f8mpFX4aCXHNqFkWJy3HJx7U/m2nJbcHh4yO52CSCBBFXY
         UTEWi9wGvo7C18GCYJ4MogStAYMnmCdnCZeL0=
From: Marek Belisko <marek.belisko@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Marek Belisko <marek.belisko@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@gmail.com>
Subject: [PATCH 3/9] staging: ft1000: GEt rid of PUSHORT typedef usage.
Date: Wed,  3 Nov 2010 11:19:49 +0100
Message-Id: <1288779595-15793-3-git-send-email-marek.belisko@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288779595-15793-1-git-send-email-marek.belisko@gmail.com>
References: <1288779595-15793-1-git-send-email-marek.belisko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c |    6 +++---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c    |   18 +++++++++---------
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.h    |    2 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h   |    1 -
 4 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
index cadfb62..6659bc7 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
@@ -656,7 +656,7 @@ static long ft1000_ChIoctl (struct file *File, unsigned int Command,
             USHORT qtype;
             USHORT msgsz;
 		struct pseudo_hdr *ppseudo_hdr;
-            PUSHORT pmsg;
+            u16 *pmsg;
             USHORT total_len;
             USHORT app_index;
             u16 status;
@@ -766,8 +766,8 @@ static long ft1000_ChIoctl (struct file *File, unsigned int Command,
                         // Make sure we are within the limits of the slow queue memory limitation
                         if ( (msgsz < MAX_CMD_SQSIZE) && (msgsz > PSEUDOSZ) ) {
                             // Need to put sequence number plus new checksum for message
-                            //pmsg = (PUSHORT)&dpram_command.dpram_blk.pseudohdr;
-                            pmsg = (PUSHORT)&dpram_data->pseudohdr;
+                            //pmsg = (u16 *)&dpram_command.dpram_blk.pseudohdr;
+                            pmsg = (u16 *)&dpram_data->pseudohdr;
 				ppseudo_hdr = (struct pseudo_hdr *)pmsg;
                             total_len = msgsz+2;
                             if (total_len & 0x1) {
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 2f195c8..c964bf7 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -1209,7 +1209,7 @@ static int ft1000_copy_up_pkt (struct urb *urb)
     //DEBUG("ft1000_copy_up_pkt: transfer_buffer_length=%d, actual_buffer_len=%d\n",
       //       urb->transfer_buffer_length, urb->actual_length);
 
-    chksum = (PUSHORT)ft1000dev->rx_buf;
+    chksum = (u16 *)ft1000dev->rx_buf;
 
     tempword = *chksum++;
     for (i=1; i<7; i++)
@@ -1541,7 +1541,7 @@ static int ft1000_dsp_prov(void *arg)
     u16 i=0;
 	struct prov_record *ptr;
 	struct pseudo_hdr *ppseudo_hdr;
-    PUSHORT pmsg;
+    u16 *pmsg;
     u16 status;
     USHORT TempShortBuf [256];
 
@@ -1579,7 +1579,7 @@ static int ft1000_dsp_prov(void *arg)
             len = htons(len);
             len += PSEUDOSZ;
 
-            pmsg = (PUSHORT)ptr->pprov_data;
+            pmsg = (u16 *)ptr->pprov_data;
 		ppseudo_hdr = (struct pseudo_hdr *)pmsg;
             // Insert slow queue sequence number
             ppseudo_hdr->seq_num = info->squeseqnum++;
@@ -1626,7 +1626,7 @@ static int ft1000_proc_drvmsg (struct ft1000_device *dev, u16 size) {
 	struct drv_msg *pdrvmsg;
     u16 i;
 	struct pseudo_hdr *ppseudo_hdr;
-    PUSHORT pmsg;
+    u16 *pmsg;
     u16 status;
     union {
         u8  byte[2];
@@ -1758,7 +1758,7 @@ static int ft1000_proc_drvmsg (struct ft1000_device *dev, u16 size) {
                 tempword = ntohs(pdrvmsg->length);
                 info->DSPInfoBlklen = tempword;
                 if (tempword < (MAX_DSP_SESS_REC-4) ) {
-                    pmsg = (PUSHORT)&pdrvmsg->data[0];
+                    pmsg = (u16 *)&pdrvmsg->data[0];
                     for (i=0; i<((tempword+1)/2); i++) {
                         DEBUG("FT1000:drivermsg:dsp info data = 0x%x\n", *pmsg);
                         info->DSPInfoBlk[i+10] = *pmsg++;
@@ -1790,10 +1790,10 @@ static int ft1000_proc_drvmsg (struct ft1000_device *dev, u16 size) {
 
                 // Put message into Slow Queue
                 // Form Pseudo header
-                pmsg = (PUSHORT)info->DSPInfoBlk;
+                pmsg = (u16 *)info->DSPInfoBlk;
                 *pmsg++ = 0;
                 *pmsg++ = htons(info->DSPInfoBlklen+20+info->DSPInfoBlklen);
-		ppseudo_hdr = (struct pseudo_hdr *)(PUSHORT)&info->DSPInfoBlk[2];
+		ppseudo_hdr = (struct pseudo_hdr *)(u16 *)&info->DSPInfoBlk[2];
                 ppseudo_hdr->length = htons(info->DSPInfoBlklen+4+info->DSPInfoBlklen);
                 ppseudo_hdr->source = 0x10;
                 ppseudo_hdr->destination = 0x20;
@@ -1840,7 +1840,7 @@ static int ft1000_proc_drvmsg (struct ft1000_device *dev, u16 size) {
               if ( (tempword & FT1000_DB_DPRAM_TX) == 0) {
                   // Put message into Slow Queue
                   // Form Pseudo header
-                  pmsg = (PUSHORT)&tempbuffer[0];
+                  pmsg = (u16 *)&tempbuffer[0];
 			ppseudo_hdr = (struct pseudo_hdr *)pmsg;
                   ppseudo_hdr->length = htons(0x0012);
                   ppseudo_hdr->source = 0x10;
@@ -1861,7 +1861,7 @@ static int ft1000_proc_drvmsg (struct ft1000_device *dev, u16 size) {
                   for (i=1; i<7; i++) {
                       ppseudo_hdr->checksum ^= *pmsg++;
                   }
-                  pmsg = (PUSHORT)&tempbuffer[16];
+                  pmsg = (u16 *)&tempbuffer[16];
                   *pmsg++ = htons(RSP_DRV_ERR_RPT_MSG);
                   *pmsg++ = htons(0x000e);
                   *pmsg++ = htons(info->DSP_TIME[0]);
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.h b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.h
index c580741..a2e19d2 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.h
@@ -4,7 +4,7 @@
 
 #include "ft1000_usb.h"
 
-extern u16 ft1000_read_register(struct usb_device *dev, PUSHORT Data, u8 nRegIndx);
+extern u16 ft1000_read_register(struct usb_device *dev, u16 *Data, u8 nRegIndx);
 extern u16 ft1000_write_register(struct usb_device *dev, USHORT value, u8 nRegIndx);
 
 #endif
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
index 96665a7..7ec8845 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
@@ -102,7 +102,6 @@ struct prov_record {
 #define ULONG               u32 /* WTF ??? */
 #define BOOLEAN             u8
 #define PULONG              u32 *
-#define PUSHORT             u16 *
 #define PCHAR               u8 *
 #define UINT                u32
 
-- 
1.7.1

