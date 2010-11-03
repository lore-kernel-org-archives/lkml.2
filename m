Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107Ab0KCKS7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 06:18:59 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52967 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571Ab0KCKSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 06:18:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Uf0unixHIH5Kv6dvgiATySUjMQCFS0pXrpqfVkZgug8AZC2RP7cU/kEBJT/l48DKxh
         kQGKLV2SbFk+7GqwSI3FiwmXx+3nVEUb3hwqyC5OzfsxAjgieLAdsWxSwrRX7MjqCiTs
         vvP69HoHJtb3w/nUHDrmLb5KmlahQzzGMAAjg=
From: Marek Belisko <marek.belisko@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Marek Belisko <marek.belisko@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@gmail.com>
Subject: [PATCH 9/9] staging: ft1000: Get rid of UINT typedef usage.
Date: Wed,  3 Nov 2010 11:19:55 +0100
Message-Id: <1288779595-15793-9-git-send-email-marek.belisko@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288779595-15793-1-git-send-email-marek.belisko@gmail.com>
References: <1288779595-15793-1-git-send-email-marek.belisko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
---
 .../staging/ft1000/ft1000-usb/ft1000_download.c    |    6 +++---
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h     |    2 --
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
index 235eb45..e90eb63 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
@@ -773,7 +773,7 @@ static u32 write_blk_fifo (struct ft1000_device *ft1000dev, u16 **pUsFile, u8 **
 u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, u32  FileLength)
 {
    u16                     Status = STATUS_SUCCESS;
-   UINT                    uiState;
+   u32                    uiState;
    u16                  handshake;
 	struct pseudo_hdr *pHdr;
    u16                  usHdrLength;
@@ -1181,14 +1181,14 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, u32  FileLeng
             // Get buffer for provisioning data
 		pbuffer = kmalloc((usHdrLength + sizeof(struct pseudo_hdr)), GFP_ATOMIC);
             if (pbuffer) {
-		memcpy(pbuffer, (void *)pUcFile, (UINT)(usHdrLength + sizeof(struct pseudo_hdr)));
+		memcpy(pbuffer, (void *)pUcFile, (u32)(usHdrLength + sizeof(struct pseudo_hdr)));
                 // link provisioning data
 		pprov_record = kmalloc(sizeof(struct prov_record), GFP_ATOMIC);
                 if (pprov_record) {
                     pprov_record->pprov_data = pbuffer;
                     list_add_tail (&pprov_record->list, &pft1000info->prov_list);
                     // Move to next entry if available
-			pUcFile = (u8 *)((unsigned long)pUcFile + (UINT)((usHdrLength + 1) & 0xFFFFFFFE) + sizeof(struct pseudo_hdr));
+			pUcFile = (u8 *)((unsigned long)pUcFile + (u32)((usHdrLength + 1) & 0xFFFFFFFE) + sizeof(struct pseudo_hdr));
                     if ( (unsigned long)(pUcFile) - (unsigned long)(pFileStart) >= (unsigned long)FileLength) {
                        uiState = STATE_DONE_FILE;
                     }
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
index 340e845..4aa78b5 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
@@ -98,8 +98,6 @@ struct prov_record {
 /*end of Jim*/
 #define DEBUG(args...) printk(KERN_INFO args)
 
-#define UINT                u32
-
 #define FALSE           0
 #define TRUE            1
 
-- 
1.7.1

