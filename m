Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab0JOMSH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 08:18:07 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51339 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292Ab0JOMSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 08:18:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=vaRCb9FCOnaO9IdiAxkBVhkviY5mDzJypufD+n8LG45gIYHith+fHa1mTykJihcVWL
         guhyHzmg6UphQi0MgfKDob0lVgmu94T/KHlKaVdPsnuboxQjy9u++eGgIqT9cBsgtmkR
         XYoId26fksmbfvBEIZGLGK/50TRwBOIRbK7vU=
From: Marek Belisko <marek.belisko@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Marek Belisko <marek.belisko@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Marek Belisko <marek.belisko@gmail.com>
Subject: [PATCH 4/7] staging:ft1000: Remove PROV_RECORD typedef usage.
Date: Fri, 15 Oct 2010 14:13:01 +0200
Message-Id: <1287144784-3359-4-git-send-email-marek.belisko@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287144784-3359-1-git-send-email-marek.belisko@gmail.com>
References: <1287144784-3359-1-git-send-email-marek.belisko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
---
 .../staging/ft1000/ft1000-usb/ft1000_download.c    |    5 ++---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c      |    8 ++++----
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h     |    8 ++++----
 3 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
index 4e506aa..b950634 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
@@ -777,7 +777,6 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, ULONG  FileLe
    USHORT                  handshake;
    PPSEUDO_HDR             pHdr;
    USHORT                  usHdrLength;
-   //PPROV_RECORD            pProvRecord;
    long                    word_length;
    USHORT                  request;
    USHORT                  temp;
@@ -801,7 +800,7 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, ULONG  FileLe
 
    USHORT                  dpram = 0;
    PUCHAR                  pbuffer;
-   PPROV_RECORD            pprov_record;
+	struct prov_record *pprov_record;
    FT1000_INFO *pft1000info = netdev_priv(ft1000dev->net);
 
    DEBUG("Entered   scram_dnldr...\n");
@@ -1184,7 +1183,7 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, ULONG  FileLe
             if (pbuffer) {
                 memcpy(pbuffer, (void *)pUcFile, (UINT)(usHdrLength + sizeof(PSEUDO_HDR)));
                 // link provisioning data
-                pprov_record = kmalloc( sizeof(PROV_RECORD), GFP_ATOMIC );
+		pprov_record = kmalloc(sizeof(struct prov_record), GFP_ATOMIC);
                 if (pprov_record) {
                     pprov_record->pprov_data = pbuffer;
                     list_add_tail (&pprov_record->list, &pft1000info->prov_list);
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 519f578..4a7e007 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -722,7 +722,7 @@ static int ft1000_reset_card (struct net_device *dev)
     FT1000_INFO *info = netdev_priv(dev);
     struct ft1000_device *ft1000dev = info->pFt1000Dev;
     u16 tempword;
-    PPROV_RECORD ptr;
+	struct prov_record *ptr;
 
     DEBUG("ft1000_hw:ft1000_reset_card called.....\n");
 
@@ -733,7 +733,7 @@ static int ft1000_reset_card (struct net_device *dev)
     // Make sure we free any memory reserve for provisioning
     while (list_empty(&info->prov_list) == 0) {
         DEBUG("ft1000_hw:ft1000_reset_card:deleting provisioning record\n");
-        ptr = list_entry(info->prov_list.next, PROV_RECORD, list);
+	ptr = list_entry(info->prov_list.next, struct prov_record, list);
         list_del(&ptr->list);
         kfree(ptr->pprov_data);
         kfree(ptr);
@@ -1754,7 +1754,7 @@ static int ft1000_dsp_prov(void *arg)
     u16 tempword;
     u16 len;
     u16 i=0;
-    PPROV_RECORD ptr;
+	struct prov_record *ptr;
     PPSEUDO_HDR ppseudo_hdr;
     PUSHORT pmsg;
     u16 status;
@@ -1789,7 +1789,7 @@ static int ft1000_dsp_prov(void *arg)
             DEBUG("*** Provision Data Sent to DSP\n");
 
             // Send provisioning data
-            ptr = list_entry(info->prov_list.next, PROV_RECORD, list);
+		ptr = list_entry(info->prov_list.next, struct prov_record, list);
             len = *(u16 *)ptr->pprov_data;
             len = htons(len);
             len += PSEUDOSZ;
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
index 3fce7f6..673a245 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
@@ -90,10 +90,10 @@ struct app_info_block {
 	struct list_head app_sqlist;   // link list of msgs for applicaton on slow queue
 } __attribute__((packed));
 
-typedef struct _PROV_RECORD {
-    struct list_head list;
-    u8 *pprov_data;
-} PROV_RECORD, *PPROV_RECORD;
+struct prov_record {
+	struct list_head list;
+	u8 *pprov_data;
+};
 
 /*end of Jim*/
 #define DEBUG(args...) printk(KERN_INFO args)
-- 
1.7.1

