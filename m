Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158Ab1EFKye (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 06:54:34 -0400
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:45007
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755254Ab1EFKyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 06:54:32 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 09/16] staging: usbip: vhci.h: coding style cleanup
Date: Fri,  6 May 2011 03:47:49 -0700
Message-Id: <08a41b8854887b0467c9509d61beb64e615bec3e.1304676742.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1304676742.git.mfm@muteddisk.com>
References: <cover.1304676742.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a few alignment issues and remove extraneous lines.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/vhci.h |   21 +++++++--------------
 1 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/usbip/vhci.h b/drivers/staging/usbip/vhci.h
index d3f1e5f..6e17a00 100644
--- a/drivers/staging/usbip/vhci.h
+++ b/drivers/staging/usbip/vhci.h
@@ -20,7 +20,6 @@
 #include <linux/platform_device.h>
 #include <linux/usb/hcd.h>
 
-
 struct vhci_device {
 	struct usb_device *udev;
 
@@ -33,12 +32,11 @@ struct vhci_device {
 	/* speed of a remote device */
 	enum usb_device_speed speed;
 
-	/*  vhci root-hub port to which this device is attached  */
+	/* vhci root-hub port to which this device is attached */
 	__u32 rhport;
 
 	struct usbip_device ud;
 
-
 	/* lock for the below link lists */
 	spinlock_t priv_lock;
 
@@ -54,7 +52,6 @@ struct vhci_device {
 	wait_queue_head_t waitq_tx;
 };
 
-
 /* urb->hcpriv, use container_of() */
 struct vhci_priv {
 	unsigned long seqnum;
@@ -64,7 +61,6 @@ struct vhci_priv {
 	struct urb *urb;
 };
 
-
 struct vhci_unlink {
 	/* seqnum of this request */
 	unsigned long seqnum;
@@ -85,12 +81,12 @@ struct vhci_unlink {
 
 /* for usb_bus.hcpriv */
 struct vhci_hcd {
-	spinlock_t	lock;
+	spinlock_t lock;
 
-	u32	port_status[VHCI_NPORTS];
+	u32 port_status[VHCI_NPORTS];
 
-	unsigned	resuming:1;
-	unsigned long	re_timeout;
+	unsigned resuming:1;
+	unsigned long re_timeout;
 
 	atomic_t seqnum;
 
@@ -102,11 +98,9 @@ struct vhci_hcd {
 	struct vhci_device vdev[VHCI_NPORTS];
 };
 
-
 extern struct vhci_hcd *the_controller;
 extern struct attribute_group dev_attr_group;
 
-
 /*-------------------------------------------------------------------------*/
 /* prototype declaration */
 
@@ -116,10 +110,9 @@ void rh_port_disconnect(int rhport);
 int vhci_rx_loop(void *data);
 int vhci_tx_loop(void *data);
 
-struct urb *pickup_urb_and_free_priv(struct vhci_device *vdev,
-					    __u32 seqnum);
+struct urb *pickup_urb_and_free_priv(struct vhci_device *vdev, __u32 seqnum);
 
-#define hardware		(&the_controller->pdev.dev)
+#define hardware (&the_controller->pdev.dev)
 
 static inline struct vhci_device *port_to_vdev(__u32 port)
 {
-- 
1.7.5.1

