Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126Ab1AYLax (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 06:30:53 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39955 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414Ab1AYLaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 06:30:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=ndh1qY47kuLLuh0ASaDAwhQSjuD+Str36Tm4ZA2+kAMHLVvcZ933ghkfrC/s3BA+0n
         0Afi1wWXbZZU3ZhtDcr4bYNjg4G9m8PFZhh1peksWIql2RE7BFfVg8IkKQ9WrlwY5T+J
         /AxVymotIm84IdlxLUKaO8hk5Y7d7oDWxQRvA=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH resend 02/12] staging: ft1000: Remove dead code.
Date: Tue, 25 Jan 2011 12:31:13 +0100
Message-Id: <1295955083-11086-2-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1295955083-11086-1-git-send-email-marek.belisko@open-nandra.com>
References: <1295955083-11086-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove code which was under #if 0.

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 .../staging/ft1000/ft1000-usb/ft1000_download.c    |   63 +-------------------
 1 files changed, 1 insertions(+), 62 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
index 696e319..edeabff 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
@@ -169,18 +169,6 @@ static u32 check_usb_db (struct ft1000_device *ft1000dev)
 	ret_val = 0;
 	break;
       }
-#if 0
-      // Check if Card is present
-      status = ft1000_read_register (ft1000dev, &temp, FT1000_REG_SUP_IMASK);
-      if (temp == 0x0000) {
-          break;
-      }
-
-      status = ft1000_read_register (ft1000dev, &temp, FT1000_REG_ASIC_ID);
-      if (temp == 0xffff) {
-         break;
-      }
-#endif
    }
 
 	return ret_val;
@@ -447,34 +435,6 @@ static long get_request_value(struct ft1000_device *ft1000dev)
 
 }
 
-#if 0
-static long get_request_value_usb(struct ft1000_device *ft1000dev)
-{
-   u32     value;
-   u16   tempword;
-   u32    status;
-   struct ft1000_info * pft1000info = netdev_priv(ft1000dev->net);
-
-       if (pft1000info->usbboot == 2) {
-          value = pft1000info->tempbuf[4];
-          tempword = pft1000info->tempbuf[5];
-       }
-       else {
-          value = 0;
-          status = ft1000_read_dpram16(ft1000dev, DWNLD_MAG1_SIZE_LOC, (u8 *)&tempword, 1);
-       }
-
-       value |= (tempword << 16);
-       value = ntohl(value);
-
-   if (pft1000info->usbboot == 1)
-       pft1000info->usbboot = 2;
-
-   //DEBUG("get_request_value_usb: value is %x\n", value);
-   return value;
-
-}
-#endif
 
 //---------------------------------------------------------------------------
 // Function:    put_request_value
@@ -724,22 +684,7 @@ static u32 write_blk_fifo (struct ft1000_device *ft1000dev, u16 **pUsFile, u8 **
    if (byte_length < 64)
        byte_length = 68;
 
-#if 0
-   pblk = kzalloc(byte_length, GFP_KERNEL);
-   memcpy (pblk, *pUcFile, byte_length);
-
-   pipe = usb_sndbulkpipe (ft1000dev->dev, ft1000dev->bulk_out_endpointAddr);
 
-   Status = usb_bulk_msg (ft1000dev->dev,
-                          pipe,
-                          pblk,
-                          byte_length,
-                          &cnt,
-                          10);
-   DEBUG("write_blk_fifo Status = 0x%8x Bytes Transfer = %d Data = 0x%x\n", Status, cnt, *pblk);
-
-   kfree(pblk);
-#else
     usb_init_urb(ft1000dev->tx_urb);
     memcpy (ft1000dev->tx_buf, *pUcFile, byte_length);
     usb_fill_bulk_urb(ft1000dev->tx_urb,
@@ -751,7 +696,6 @@ static u32 write_blk_fifo (struct ft1000_device *ft1000dev, u16 **pUsFile, u8 **
                       (void*)ft1000dev);
 
     usb_submit_urb(ft1000dev->tx_urb, GFP_ATOMIC);
-#endif
 
    *pUsFile = *pUsFile + (word_length << 1);
    *pUcFile = *pUcFile + (word_length << 2);
@@ -1001,15 +945,10 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, u32  FileLeng
                   status = STATUS_FAILURE;
                   break;
                }
-#if 0
-               word_length = get_request_value_usb(ft1000dev);
-               //DEBUG("FT1000:download:word_length = %d\n", (int)word_length);
-               if (word_length > MAX_LENGTH/2)
-#else
+
                word_length = get_request_value(ft1000dev);
                //DEBUG("FT1000:download:word_length = %d\n", (int)word_length);
                if (word_length > MAX_LENGTH)
-#endif
                {
                   DEBUG("FT1000:download:Download error: Max length exceeded\n");
                   status = STATUS_FAILURE;
-- 
1.7.1

