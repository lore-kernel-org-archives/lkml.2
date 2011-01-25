Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab1AYWSA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 17:18:00 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:60745 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab1AYWR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 17:17:56 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@suse.de>,
        Ross Cohen <rcohen@snurgle.org>
Subject: [PATCH 05/20] staging/go7007: remove the BKL
Date: Tue, 25 Jan 2011 23:17:19 +0100
Message-Id: <1295993854-4971-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1295993854-4971-1-git-send-email-arnd@arndb.de>
References: <1295993854-4971-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:3F21DqUoFviXhOEYDPMPyG5+2y+Yk6x+1A9GT5zbwJ3
 Cjna/9tbdpSoh6ayL3rTESl+zrLkH2F+Lddrm2ULVTTwKEfwET
 ZDayvQEfip/dIkBsXMYuBQMDZx39Ioivjd6vk6q5W3tO87ni5S
 JIWxnriI5O0pg01K6K+o3UkksvX8DVPXDuX/0y+u8X7+sYSwxE
 sefXVG/MZ+wJbj/e/hj/g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is nothing that the BKL can possibly
protect here, so just remove it.

Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Ross Cohen <rcohen@snurgle.org>
---
 drivers/staging/go7007/Kconfig        |    1 -
 drivers/staging/go7007/s2250-loader.c |    3 ---
 2 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/go7007/Kconfig b/drivers/staging/go7007/Kconfig
index 1da57df..7dfb281 100644
--- a/drivers/staging/go7007/Kconfig
+++ b/drivers/staging/go7007/Kconfig
@@ -1,7 +1,6 @@
 config VIDEO_GO7007
 	tristate "WIS GO7007 MPEG encoder support"
 	depends on VIDEO_DEV && PCI && I2C
-	depends on BKL # please fix
 	depends on SND
 	select VIDEOBUF_DMA_SG
 	depends on RC_CORE
diff --git a/drivers/staging/go7007/s2250-loader.c b/drivers/staging/go7007/s2250-loader.c
index 7547a8f..4e13251 100644
--- a/drivers/staging/go7007/s2250-loader.c
+++ b/drivers/staging/go7007/s2250-loader.c
@@ -18,7 +18,6 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/usb.h>
 #include <dvb-usb.h>
 
@@ -142,11 +141,9 @@ static void s2250loader_disconnect(struct usb_interface *interface)
 {
 	pdevice_extension_t s;
 	printk(KERN_INFO "s2250: disconnect\n");
-	lock_kernel();
 	s = usb_get_intfdata(interface);
 	usb_set_intfdata(interface, NULL);
 	kref_put(&(s->kref), s2250loader_delete);
-	unlock_kernel();
 }
 
 static const struct usb_device_id s2250loader_ids[] = {
-- 
1.7.1

