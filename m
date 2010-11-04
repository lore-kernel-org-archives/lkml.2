Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230Ab0KDGfJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 02:35:09 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43411 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932164Ab0KDGfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 02:35:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=PL8QpxuWH/pbaa8aCrwURXZHZs6R4XZ7O91dgw1TVCUVgZOLo7wyqNbpVdf17a3zQ0
         S0ydPJiCd+X0GcnJ+L39aCKlad0BfaQ4qksCHr5vZNZ8BtzkIbOZurcJQdu5sZ44fZPD
         OyxlmBQi1FsCiVbPcRb7pttt/I2GWzAk29z6w=
From: Marek Belisko <marek.belisko@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Marek Belisko <marek.belisko@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@gmail.com>
Subject: [PATCH v2 7/9] staging: ft1000: Get rid of BOOLEAN typedef usage.
Date: Thu,  4 Nov 2010 07:37:13 +0100
Message-Id: <1288852633-11724-1-git-send-email-marek.belisko@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c   |    2 +-
 .../staging/ft1000/ft1000-usb/ft1000_download.c    |    2 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c      |    4 ++--
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.c     |    2 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h     |    7 +++----
 5 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
index f6b2e91..920ca52 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
@@ -64,7 +64,7 @@ spinlock_t free_buff_lock;
 int numofmsgbuf = 0;
 
 // Global variable to indicate that all provisioning data is sent to DSP
-//BOOLEAN fProvComplete;
+//bool fProvComplete;
 
 //
 // Table of entry-point routines for char device
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
index 0a2b833..11b7c20 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
@@ -785,7 +785,7 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, u32  FileLeng
 	struct dsp_file_hdr *pFileHdr5;
 	struct dsp_image_info *pDspImageInfoV6 = NULL;
    long                    requested_version;
-   BOOLEAN                 bGoodVersion;
+   bool                 bGoodVersion;
 	struct drv_msg *pMailBoxData;
    u16                  *pUsData = NULL;
    u16                  *pUsFile = NULL;
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index f97826d..1a517dd 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -491,7 +491,7 @@ u16 fix_ft1000_write_dpram32(struct ft1000_device *ft1000dev, u16 indx, u8 *buff
 //
 //  Returns:    None
 //-----------------------------------------------------------------------
-static void card_reset_dsp (struct ft1000_device *ft1000dev, BOOLEAN value)
+static void card_reset_dsp (struct ft1000_device *ft1000dev, bool value)
 {
     u16 status = STATUS_SUCCESS;
     u16 tempword;
@@ -1479,7 +1479,7 @@ static int ft1000_chkcard (struct ft1000_device *dev) {
 //          = 1 (successful)
 //
 //---------------------------------------------------------------------------
-static BOOLEAN ft1000_receive_cmd (struct ft1000_device *dev, u16 *pbuffer, int maxsz, u16 *pnxtph) {
+static bool ft1000_receive_cmd (struct ft1000_device *dev, u16 *pbuffer, int maxsz, u16 *pnxtph) {
     u16 size, ret;
     u16 *ppseudohdr;
     int i;
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
index 4e81bdd..41bbe99 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
@@ -36,7 +36,7 @@ static struct usb_device_id id_table[] = {
 
 MODULE_DEVICE_TABLE(usb, id_table);
 
-static BOOLEAN gPollingfailed = FALSE;
+static bool gPollingfailed = FALSE;
 int ft1000_poll_thread(void *arg)
 {
 	int ret = STATUS_SUCCESS;
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
index 64af710..cf2c42e 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
@@ -98,7 +98,6 @@ struct prov_record {
 /*end of Jim*/
 #define DEBUG(args...) printk(KERN_INFO args)
 
-#define BOOLEAN             u8
 #define PCHAR               u8 *
 #define UINT                u32
 
@@ -488,9 +487,9 @@ struct ft1000_info {
 	unsigned char usbboot;
     unsigned short dspalive;
     u16 ASIC_ID;
-    BOOLEAN fProvComplete;
-    BOOLEAN fCondResetPend;
-    BOOLEAN fAppMsgPend;
+    bool fProvComplete;
+    bool fCondResetPend;
+    bool fAppMsgPend;
     char *pfwimg;
     int fwimgsz;
     u16 DrvErrNum;
-- 
1.7.1

