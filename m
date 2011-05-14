Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569Ab1ENK5d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 06:57:33 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:56619 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755077Ab1ENK4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 06:56:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=VTDfJMaJsjJ0kCZlaNc6fEu7DOmVtmbQYnyZUuTpSovY1Rp7+Qjp85ZsmRi2Lcc8JG
         FQstaJ/AWBdI4Tfrt2Nk0JugVcFSbKgltpoQkZywMLzJIkc4hPKBeHG6eETGJW+m1MbA
         GMqPQ2lw26Il9yw2vdsjJ7p3rWR/DjS9s2FcA=
From: matt mooney <mfmooney@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 11/14] staging: usbip: userspace: remove gcc warnings
Date: Sat, 14 May 2011 03:55:17 -0700
Message-Id: <0c194098dd7f6a7d740cc1a91b83b4f845af0ad8.1305369176.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1305369175.git.mfm@muteddisk.com>
References: <cover.1305369175.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: matt mooney <mfm@muteddisk.com>

The warnings were for unused parameters, so __attribute__((unused))
has been added until it can be determined they are truly unneeded.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 .../staging/usbip/userspace/libsrc/stub_driver.c   |    2 +-
 .../staging/usbip/userspace/src/usbip_network.c    |    3 ++-
 drivers/staging/usbip/userspace/src/usbipd.c       |    3 ++-
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/usbip/userspace/libsrc/stub_driver.c b/drivers/staging/usbip/userspace/libsrc/stub_driver.c
index a1ac067..4c76e03 100644
--- a/drivers/staging/usbip/userspace/libsrc/stub_driver.c
+++ b/drivers/staging/usbip/userspace/libsrc/stub_driver.c
@@ -181,7 +181,7 @@ static int check_new(struct dlist *dlist, struct sysfs_device *target)
 	return 1;
 }
 
-static void delete_nothing(void *dev)
+static void delete_nothing(void *dev __attribute__((unused)))
 {
 	/* do not delete anything. but, its container will be deleted. */
 }
diff --git a/drivers/staging/usbip/userspace/src/usbip_network.c b/drivers/staging/usbip/userspace/src/usbip_network.c
index 726173e..01be3c7 100644
--- a/drivers/staging/usbip/userspace/src/usbip_network.c
+++ b/drivers/staging/usbip/userspace/src/usbip_network.c
@@ -40,7 +40,8 @@ void pack_usb_device(int pack, struct usb_device *udev)
 	pack_uint16_t(pack, &udev->bcdDevice);
 }
 
-void pack_usb_interface(int pack, struct usb_interface *udev)
+void pack_usb_interface(int pack __attribute__((unused)),
+			struct usb_interface *udev __attribute__((unused)))
 {
 	/* uint8_t members need nothing */
 }
diff --git a/drivers/staging/usbip/userspace/src/usbipd.c b/drivers/staging/usbip/userspace/src/usbipd.c
index 409d064..ec9faac 100644
--- a/drivers/staging/usbip/userspace/src/usbipd.c
+++ b/drivers/staging/usbip/userspace/src/usbipd.c
@@ -388,7 +388,8 @@ static void set_signal(void)
 }
 
 
-gboolean process_comming_request(GIOChannel *gio, GIOCondition condition, gpointer data)
+gboolean process_comming_request(GIOChannel *gio, GIOCondition condition,
+				 gpointer data __attribute__((unused)))
 {
 	int ret;
 
-- 
1.7.5.1

