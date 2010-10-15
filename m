Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab0JOOJM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 10:09:12 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63692 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755111Ab0JOOJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 10:09:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=fWbHnyWZbaCmaJKUgYHj8n0o8qKlKaeVsdMvP3+Rfgy6sBIB8UJ7f8YEfJ0ooPrR4R
         lNouYH88GFsjU+8Wl76BfKNkR42MaDIyg6D6TvHBlYmnfVnIKESPeOkgShM3QFv/4a+T
         W++WC7NhHoFmf+DsMhFDQy6l7Hv02fFuGIx6c=
From: Marek Belisko <marek.belisko@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Marek Belisko <marek.belisko@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Marek Belisko <marek.belisko@gmail.com>
Subject: [PATCH 6/7] staging:ft1000: Remove DRVMGS typedef usage.
Date: Fri, 15 Oct 2010 14:13:03 +0200
Message-Id: <1287144784-3359-6-git-send-email-marek.belisko@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287144784-3359-1-git-send-email-marek.belisko@gmail.com>
References: <1287144784-3359-1-git-send-email-marek.belisko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
---
 .../staging/ft1000/ft1000-usb/ft1000_download.c    |    4 ++--
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c      |    4 ++--
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h     |   10 +++++-----
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
index 48eb697..ee32f40 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
@@ -786,7 +786,7 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, ULONG  FileLe
 	struct dsp_image_info *pDspImageInfoV6 = NULL;
    long                    requested_version;
    BOOLEAN                 bGoodVersion;
-   PDRVMSG                 pMailBoxData;
+	struct drv_msg *pMailBoxData;
    USHORT                  *pUsData = NULL;
    USHORT                  *pUsFile = NULL;
    UCHAR                   *pUcFile = NULL;
@@ -1047,7 +1047,7 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, ULONG  FileLe
                // Convert length from byte count to word count. Make sure we round up.
                word_length = (long)(pft1000info->DSPInfoBlklen + 1)/2;
                put_request_value(ft1000dev, word_length);
-               pMailBoxData = (PDRVMSG)&(pft1000info->DSPInfoBlk[0]);
+		pMailBoxData = (struct drv_msg *)&(pft1000info->DSPInfoBlk[0]);
                /*
                 * Position ASIC DPRAM auto-increment pointer.
                 */
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index efe47ac..f8ca086 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -1838,7 +1838,7 @@ static int ft1000_proc_drvmsg (struct ft1000_device *dev, u16 size) {
     u16 tempword;
 	struct media_msg *pmediamsg;
 	struct dsp_init_msg *pdspinitmsg;
-    PDRVMSG pdrvmsg;
+	struct drv_msg *pdrvmsg;
     u16 i;
 	struct pseudo_hdr *ppseudo_hdr;
     PUSHORT pmsg;
@@ -1872,7 +1872,7 @@ static int ft1000_proc_drvmsg (struct ft1000_device *dev, u16 size) {
             }
         }
 #endif
-        pdrvmsg = (PDRVMSG)&cmdbuffer[2];
+	pdrvmsg = (struct drv_msg *)&cmdbuffer[2];
         msgtype = ntohs(pdrvmsg->type);
         DEBUG("ft1000_proc_drvmsg:Command message type = 0x%x\n", msgtype);
         switch (msgtype) {
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
index bef9bcf..e3ecbea 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
@@ -455,12 +455,12 @@ struct prov_record {
 
 #define MAX_BUF_SIZE            4096
 
-typedef struct _DRVMSG {
+struct drv_msg {
 	struct pseudo_hdr pseudo;
-        u16 type;
-        u16 length;
-        u8  data[0];
-} __attribute__ ((packed)) DRVMSG, *PDRVMSG;
+	u16 type;
+	u16 length;
+	u8  data[0];
+} __attribute__ ((packed));
 
 struct ft1000_device
 {
-- 
1.7.1

