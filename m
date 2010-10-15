Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486Ab0JPBnu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 21:43:50 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63273 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab0JPBnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 21:43:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=DwcTyY8keK1AtBmdbK4JfE/ubMok2f6cSQixTXAjOSlQT6+zrN+9weYZCs6tiEOBnp
         6k6JEmjpbjwRVpCrCzZYlE/hC44vkh5EaE4GgSDIivqd3/f5G13fMRQQeZsi4njd+yJ3
         PxIVIsXFjWCgjYRIrjX2Wz8m847WxK3jAepWU=
From: Marek Belisko <marek.belisko@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Marek Belisko <marek.belisko@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Marek Belisko <marek.belisko@gmail.com>
Subject: [PATCH 1/7] staging:ft1000: Remove MEDIAMSG typedef usage.
Date: Fri, 15 Oct 2010 14:12:58 +0200
Message-Id: <1287144784-3359-1-git-send-email-marek.belisko@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c  |    4 ++--
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h |    5 ++---
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index e98db30..f88dcf0 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -1836,7 +1836,7 @@ static int ft1000_proc_drvmsg (struct ft1000_device *dev, u16 size) {
 	FT1000_INFO *info = (FT1000_INFO *) netdev_priv (dev->net);
     u16 msgtype;
     u16 tempword;
-    PMEDIAMSG pmediamsg;
+	struct media_msg *pmediamsg;
     PDSPINITMSG pdspinitmsg;
     PDRVMSG pdrvmsg;
     u16 i;
@@ -1879,7 +1879,7 @@ static int ft1000_proc_drvmsg (struct ft1000_device *dev, u16 size) {
             case MEDIA_STATE: {
                 DEBUG("ft1000_proc_drvmsg:Command message type = MEDIA_STATE");
 
-                pmediamsg = (PMEDIAMSG)&cmdbuffer[0];
+		pmediamsg = (struct media_msg *)&cmdbuffer[0];
                 if (info->ProgConStat != 0xFF) {
                     if (pmediamsg->state) {
                         DEBUG("Media is up\n");
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
index ee54372..bfd43fd 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
@@ -51,7 +51,7 @@
 
 
 
-typedef struct _MEDIAMSG {
+struct media_msg {
 	PSEUDO_HDR pseudo;
 	u16 type;
 	u16 length;
@@ -61,7 +61,7 @@ typedef struct _MEDIAMSG {
 	u32 gateway;
 	u32 dns_1;
 	u32 dns_2;
-} __attribute__ ((packed)) MEDIAMSG, *PMEDIAMSG;
+} __attribute__ ((packed));
 
 typedef struct _DSPINITMSG {
     PSEUDO_HDR pseudo;
@@ -97,7 +97,6 @@ typedef struct _PROV_RECORD {
 } PROV_RECORD, *PPROV_RECORD;
 
 /*end of Jim*/
-
 #define DEBUG(args...) printk(KERN_INFO args)
 
 #define UCHAR               u8
-- 
1.7.1

