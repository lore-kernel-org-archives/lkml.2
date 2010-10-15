Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab0JOMSL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 08:18:11 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59096 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754492Ab0JOMSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 08:18:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=nlvSzO6EllJLrCeQhP1hIPtbSDxM5pRpd17vlZsmKeO5smJ+0grCIAo71NMDxAQuBO
         8ELr8+n4BUhXBsiMMRRln98mRA16QkSdOknuIqb0i9Qh45abHihPuMosItNruEFnNCeR
         yjSKiE/+gSMg0B1JihryJL7vYxy0sRxHmglkk=
From: Marek Belisko <marek.belisko@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Marek Belisko <marek.belisko@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Marek Belisko <marek.belisko@gmail.com>
Subject: [PATCH 2/7] staging:ft1000: Remove DSPINITMSG typedef usage.
Date: Fri, 15 Oct 2010 14:12:59 +0200
Message-Id: <1287144784-3359-2-git-send-email-marek.belisko@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287144784-3359-1-git-send-email-marek.belisko@gmail.com>
References: <1287144784-3359-1-git-send-email-marek.belisko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c  |    6 +++---
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h |   24 ++++++++++++------------
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index f88dcf0..519f578 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -1837,7 +1837,7 @@ static int ft1000_proc_drvmsg (struct ft1000_device *dev, u16 size) {
     u16 msgtype;
     u16 tempword;
 	struct media_msg *pmediamsg;
-    PDSPINITMSG pdspinitmsg;
+	struct dsp_init_msg *pdspinitmsg;
     PDRVMSG pdrvmsg;
     u16 i;
     PPSEUDO_HDR ppseudo_hdr;
@@ -1924,7 +1924,7 @@ static int ft1000_proc_drvmsg (struct ft1000_device *dev, u16 size) {
             case DSP_INIT_MSG: {
                 DEBUG("ft1000_proc_drvmsg:Command message type = DSP_INIT_MSG");
 
-                pdspinitmsg = (PDSPINITMSG)&cmdbuffer[2];
+		pdspinitmsg = (struct dsp_init_msg *)&cmdbuffer[2];
                 memcpy(info->DspVer, pdspinitmsg->DspVer, DSPVERSZ);
                 DEBUG("DSPVER = 0x%2x 0x%2x 0x%2x 0x%2x\n", info->DspVer[0], info->DspVer[1], info->DspVer[2], info->DspVer[3]);
                 memcpy(info->HwSerNum, pdspinitmsg->HwSerNum, HWSERNUMSZ);
@@ -1938,7 +1938,7 @@ static int ft1000_proc_drvmsg (struct ft1000_device *dev, u16 size) {
                 dev->net->dev_addr[4] = info->eui64[6];
                 dev->net->dev_addr[5] = info->eui64[7];
 
-                if (ntohs(pdspinitmsg->length) == (sizeof(DSPINITMSG) - 20) ) {
+		if (ntohs(pdspinitmsg->length) == (sizeof(struct dsp_init_msg) - 20)) {
                     memcpy(info->ProductMode, pdspinitmsg->ProductMode, MODESZ);
                     memcpy(info->RfCalVer, pdspinitmsg->RfCalVer, CALVERSZ);
                     memcpy(info->RfCalDate, pdspinitmsg->RfCalDate, CALDATESZ);
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
index bfd43fd..200f3c0 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
@@ -63,18 +63,18 @@ struct media_msg {
 	u32 dns_2;
 } __attribute__ ((packed));
 
-typedef struct _DSPINITMSG {
-    PSEUDO_HDR pseudo;
-    u16 type;
-    u16 length;
-    u8 DspVer[DSPVERSZ];        // DSP version number
-    u8 HwSerNum[HWSERNUMSZ];    // Hardware Serial Number
-    u8 Sku[SKUSZ];              // SKU
-    u8 eui64[EUISZ];            // EUI64
-    u8 ProductMode[MODESZ];     // Product Mode (Market/Production)
-    u8 RfCalVer[CALVERSZ];      // Rf Calibration version
-    u8 RfCalDate[CALDATESZ];    // Rf Calibration date
-} __attribute__ ((packed)) DSPINITMSG, *PDSPINITMSG;
+struct dsp_init_msg {
+	PSEUDO_HDR pseudo;
+	u16 type;
+	u16 length;
+	u8 DspVer[DSPVERSZ];        // DSP version number
+	u8 HwSerNum[HWSERNUMSZ];    // Hardware Serial Number
+	u8 Sku[SKUSZ];              // SKU
+	u8 eui64[EUISZ];            // EUI64
+	u8 ProductMode[MODESZ];     // Product Mode (Market/Production)
+	u8 RfCalVer[CALVERSZ];      // Rf Calibration version
+	u8 RfCalDate[CALDATESZ];    // Rf Calibration date
+} __attribute__ ((packed));
 
 
 typedef struct _APP_INFO_BLOCK
-- 
1.7.1

