Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213Ab1FTFpf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 01:45:35 -0400
Received: from qmta05.westchester.pa.mail.comcast.net ([76.96.62.48]:38438
	"EHLO qmta05.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752018Ab1FTFpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 01:45:30 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 03/22] staging: usbip: userspace: usbip_common.h: move enums
Date: Sun, 19 Jun 2011 22:44:33 -0700
Message-Id: <6d9f92fc4b7f241d03a519c1428c1cf14d4c4901.1308547654.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <cover.1308547654.git.mfm@muteddisk.com>
References: <cover.1308547654.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Relocate enums to follow logging macros.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 .../staging/usbip/userspace/libsrc/usbip_common.h  |   50 +++++++++----------
 1 files changed, 24 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/usbip/userspace/libsrc/usbip_common.h b/drivers/staging/usbip/userspace/libsrc/usbip_common.h
index 090b7c5..7dadb21 100644
--- a/drivers/staging/usbip/userspace/libsrc/usbip_common.h
+++ b/drivers/staging/usbip/userspace/libsrc/usbip_common.h
@@ -30,30 +30,6 @@
 #define USBIP_HOST_DRV_NAME	"usbip-host"
 #define USBIP_VHCI_DRV_NAME	"vhci_hcd"
 
-enum usb_device_speed {
-	USB_SPEED_UNKNOWN = 0,                  /* enumerating */
-	USB_SPEED_LOW, USB_SPEED_FULL,          /* usb 1.1 */
-	USB_SPEED_HIGH,                         /* usb 2.0 */
-	USB_SPEED_VARIABLE                      /* wireless (usb 2.5) */
-};
-
-/* FIXME: how to sync with drivers/usbip_common.h ? */
-enum usbip_device_status{
-	/* sdev is available. */
-	SDEV_ST_AVAILABLE = 0x01,
-	/* sdev is now used. */
-	SDEV_ST_USED,
-	/* sdev is unusable because of a fatal error. */
-	SDEV_ST_ERROR,
-
-	/* vdev does not connect a remote device. */
-	VDEV_ST_NULL,
-	/* vdev is used, but the USB address is not assigned yet */
-	VDEV_ST_NOTASSIGNED,
-	VDEV_ST_USED,
-	VDEV_ST_ERROR
-};
-
 extern int usbip_use_syslog;
 extern int usbip_use_stderr;
 extern int usbip_use_debug ;
@@ -102,6 +78,30 @@ extern int usbip_use_debug ;
 		abort();				\
 	} while (0)
 
+enum usb_device_speed {
+	USB_SPEED_UNKNOWN = 0,                  /* enumerating */
+	USB_SPEED_LOW, USB_SPEED_FULL,          /* usb 1.1 */
+	USB_SPEED_HIGH,                         /* usb 2.0 */
+	USB_SPEED_VARIABLE                      /* wireless (usb 2.5) */
+};
+
+/* FIXME: how to sync with drivers/usbip_common.h ? */
+enum usbip_device_status{
+	/* sdev is available. */
+	SDEV_ST_AVAILABLE = 0x01,
+	/* sdev is now used. */
+	SDEV_ST_USED,
+	/* sdev is unusable because of a fatal error. */
+	SDEV_ST_ERROR,
+
+	/* vdev does not connect a remote device. */
+	VDEV_ST_NULL,
+	/* vdev is used, but the USB address is not assigned yet */
+	VDEV_ST_NOTASSIGNED,
+	VDEV_ST_USED,
+	VDEV_ST_ERROR
+};
+
 struct usbip_usb_interface {
 	uint8_t bInterfaceClass;
 	uint8_t bInterfaceSubClass;
@@ -109,8 +109,6 @@ struct usbip_usb_interface {
 	uint8_t padding;	/* alignment */
 } __attribute__((packed));
 
-
-
 struct usbip_usb_device {
 	char path[SYSFS_PATH_MAX];
 	char busid[SYSFS_BUS_ID_SIZE];
-- 
1.7.5.2

