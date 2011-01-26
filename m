Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab1AZLsr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 06:48:47 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49278 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239Ab1AZLsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 06:48:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=LMiq28keH8uePwpCb2TgMoREHt5jQn1A7uFl09g3JmBSJXf8Dmqkl/rHUDlkWalgnT
         FzQ4glS78Eq1l1CNKeRMiZl9UU88DfflQddBBTxNPeUqeQ77zmDTOGYFBcVsXYC2p/Mq
         P+AuTFyvMuoSEnPhnn8hCv+ruItjDoHJitxDo=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 4/5] staging: ft1000: Fix coding style in write_blk_fifo() function.
Date: Wed, 26 Jan 2011 12:49:14 +0100
Message-Id: <1296042555-29145-4-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1296042555-29145-1-git-send-email-marek.belisko@open-nandra.com>
References: <1296042555-29145-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 .../staging/ft1000/ft1000-usb/ft1000_download.c    |   56 +++++++++----------
 1 files changed, 27 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
index 2537a11..1e12c41 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
@@ -639,44 +639,42 @@ static void usb_dnld_complete (struct urb *urb)
 // Notes:
 //
 //---------------------------------------------------------------------------
-static u32 write_blk_fifo (struct ft1000_device *ft1000dev, u16 **pUsFile, u8 **pUcFile, long word_length)
+static u32 write_blk_fifo(struct ft1000_device *ft1000dev, u16 **pUsFile,
+			  u8 **pUcFile, long word_length)
 {
-   u32 Status = STATUS_SUCCESS;
-   int byte_length;
-   long aligncnt;
-
-   byte_length = word_length * 4;
+	u32 Status = STATUS_SUCCESS;
+	int byte_length;
+	long aligncnt;
 
-   if (byte_length % 4)
-      aligncnt = 4 - (byte_length % 4);
-   else
-      aligncnt = 0;
-   byte_length += aligncnt;
+	byte_length = word_length * 4;
 
-   if (byte_length && ((byte_length % 64) == 0)) {
-      byte_length += 4;
-   }
+	if (byte_length % 4)
+		aligncnt = 4 - (byte_length % 4);
+	else
+		aligncnt = 0;
+	byte_length += aligncnt;
 
-   if (byte_length < 64)
-       byte_length = 68;
+	if (byte_length && ((byte_length % 64) == 0))
+		byte_length += 4;
 
+	if (byte_length < 64)
+		byte_length = 68;
 
-    usb_init_urb(ft1000dev->tx_urb);
-    memcpy (ft1000dev->tx_buf, *pUcFile, byte_length);
-    usb_fill_bulk_urb(ft1000dev->tx_urb,
-                      ft1000dev->dev,
-                      usb_sndbulkpipe(ft1000dev->dev, ft1000dev->bulk_out_endpointAddr),
-                      ft1000dev->tx_buf,
-                      byte_length,
-                      usb_dnld_complete,
-                      (void*)ft1000dev);
+	usb_init_urb(ft1000dev->tx_urb);
+	memcpy(ft1000dev->tx_buf, *pUcFile, byte_length);
+	usb_fill_bulk_urb(ft1000dev->tx_urb,
+			  ft1000dev->dev,
+			  usb_sndbulkpipe(ft1000dev->dev,
+					  ft1000dev->bulk_out_endpointAddr),
+			  ft1000dev->tx_buf, byte_length, usb_dnld_complete,
+			  (void *)ft1000dev);
 
-    usb_submit_urb(ft1000dev->tx_urb, GFP_ATOMIC);
+	usb_submit_urb(ft1000dev->tx_urb, GFP_ATOMIC);
 
-   *pUsFile = *pUsFile + (word_length << 1);
-   *pUcFile = *pUcFile + (word_length << 2);
+	*pUsFile = *pUsFile + (word_length << 1);
+	*pUcFile = *pUcFile + (word_length << 2);
 
-   return Status;
+	return Status;
 }
 
 //---------------------------------------------------------------------------
-- 
1.7.1

