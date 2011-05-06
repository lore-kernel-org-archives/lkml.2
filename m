Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932370Ab1EFKys (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 06:54:48 -0400
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:41436
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932280Ab1EFKyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 06:54:43 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 15/16] staging: usbip: remove section dividers
Date: Fri,  6 May 2011 03:47:55 -0700
Message-Id: <7b231e55ae3a86c60fe268077103c92fe5c7de08.1304676742.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1304676742.git.mfm@muteddisk.com>
References: <cover.1304676742.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also, removes the one-line comments that were associated with some of
the dividers because they provided no additional information.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/stub.h         |    3 ---
 drivers/staging/usbip/stub_dev.c     |   13 -------------
 drivers/staging/usbip/stub_main.c    |   10 ----------
 drivers/staging/usbip/stub_tx.c      |   11 -----------
 drivers/staging/usbip/usbip_common.c |   11 -----------
 drivers/staging/usbip/usbip_common.h |   10 ----------
 drivers/staging/usbip/vhci.h         |    3 ---
 drivers/staging/usbip/vhci_hcd.c     |   13 -------------
 drivers/staging/usbip/vhci_rx.c      |    2 --
 drivers/staging/usbip/vhci_tx.c      |    4 ----
 10 files changed, 0 insertions(+), 80 deletions(-)

diff --git a/drivers/staging/usbip/stub.h b/drivers/staging/usbip/stub.h
index 6d252b8..bfea5dc 100644
--- a/drivers/staging/usbip/stub.h
+++ b/drivers/staging/usbip/stub.h
@@ -88,9 +88,6 @@ struct bus_id_priv {
 
 extern struct kmem_cache *stub_priv_cache;
 
-/*-------------------------------------------------------------------------*/
-/* prototype declarations */
-
 /* stub_tx.c */
 void stub_complete(struct urb *);
 int stub_tx_loop(void *data);
diff --git a/drivers/staging/usbip/stub_dev.c b/drivers/staging/usbip/stub_dev.c
index 8a55068..919d558 100644
--- a/drivers/staging/usbip/stub_dev.c
+++ b/drivers/staging/usbip/stub_dev.c
@@ -61,11 +61,6 @@ struct usb_driver stub_driver = {
 	.id_table	= stub_table,
 };
 
-/*-------------------------------------------------------------------------*/
-
-/* Define sysfs entries for a usbip-bound device */
-
-
 /*
  * usbip_status shows status of usbip as long as this driver is bound to the
  * target device.
@@ -190,10 +185,6 @@ static void stub_remove_files(struct device *dev)
 	device_remove_file(dev, &dev_attr_usbip_debug);
 }
 
-/*-------------------------------------------------------------------------*/
-
-/* Event handler functions called by an event handler thread */
-
 static void stub_shutdown_connection(struct usbip_device *ud)
 {
 	struct stub_device *sdev = container_of(ud, struct stub_device, ud);
@@ -292,8 +283,6 @@ static void stub_device_unusable(struct usbip_device *ud)
 	spin_unlock(&ud->lock);
 }
 
-/*-------------------------------------------------------------------------*/
-
 /**
  * stub_device_alloc - allocate a new stub_device struct
  * @interface: usb_interface of a new device
@@ -362,8 +351,6 @@ static int stub_device_free(struct stub_device *sdev)
 	return 0;
 }
 
-/*-------------------------------------------------------------------------*/
-
 /*
  * If a usb device has multiple active interfaces, this driver is bound to all
  * the active interfaces. However, usbip exports *a* usb device (i.e., not *an*
diff --git a/drivers/staging/usbip/stub_main.c b/drivers/staging/usbip/stub_main.c
index 4ba00bb..6634e07 100644
--- a/drivers/staging/usbip/stub_main.c
+++ b/drivers/staging/usbip/stub_main.c
@@ -30,10 +30,6 @@
 /* stub_priv is allocated from stub_priv_cache */
 struct kmem_cache *stub_priv_cache;
 
-/*-------------------------------------------------------------------------*/
-
-/* Define sysfs entries for the usbip driver */
-
 /*
  * busid_tables defines matching busids that usbip can grab. A user can change
  * dynamically what device is locally used and what device is exported to a
@@ -200,10 +196,6 @@ static ssize_t store_match_busid(struct device_driver *dev, const char *buf,
 static DRIVER_ATTR(match_busid, S_IRUSR|S_IWUSR, show_match_busid,
 		   store_match_busid);
 
-/*-------------------------------------------------------------------------*/
-
-/* Cleanup functions used to free private data */
-
 static struct stub_priv *stub_priv_pop_from_listhead(struct list_head *listhead)
 {
 	struct stub_priv *priv, *tmp;
@@ -266,8 +258,6 @@ void stub_device_cleanup_urbs(struct stub_device *sdev)
 	}
 }
 
-/*-------------------------------------------------------------------------*/
-
 static int __init usb_stub_init(void)
 {
 	int ret;
diff --git a/drivers/staging/usbip/stub_tx.c b/drivers/staging/usbip/stub_tx.c
index 76d82b2..fc02261 100644
--- a/drivers/staging/usbip/stub_tx.c
+++ b/drivers/staging/usbip/stub_tx.c
@@ -109,9 +109,6 @@ void stub_complete(struct urb *urb)
 	wake_up(&sdev->tx_waitq);
 }
 
-/*-------------------------------------------------------------------------*/
-/* fill PDU */
-
 static inline void setup_base_pdu(struct usbip_header_basic *base,
 				  __u32 command, __u32 seqnum)
 {
@@ -137,9 +134,6 @@ static void setup_ret_unlink_pdu(struct usbip_header *rpdu,
 	rpdu->u.ret_unlink.status = unlink->status;
 }
 
-/*-------------------------------------------------------------------------*/
-/* send RET_SUBMIT */
-
 static struct stub_priv *dequeue_from_priv_tx(struct stub_device *sdev)
 {
 	unsigned long flags;
@@ -292,9 +286,6 @@ static int stub_send_ret_submit(struct stub_device *sdev)
 	return total_size;
 }
 
-/*-------------------------------------------------------------------------*/
-/* send RET_UNLINK */
-
 static struct stub_unlink *dequeue_from_unlink_tx(struct stub_device *sdev)
 {
 	unsigned long flags;
@@ -369,8 +360,6 @@ static int stub_send_ret_unlink(struct stub_device *sdev)
 	return total_size;
 }
 
-/*-------------------------------------------------------------------------*/
-
 int stub_tx_loop(void *data)
 {
 	struct usbip_device *ud = data;
diff --git a/drivers/staging/usbip/usbip_common.c b/drivers/staging/usbip/usbip_common.c
index a6ae67c..5d842f9 100644
--- a/drivers/staging/usbip/usbip_common.c
+++ b/drivers/staging/usbip/usbip_common.c
@@ -31,9 +31,6 @@
 	"Takahiro Hirofuchi <hirofuchi _at_ users.sourceforge.net>"
 #define DRIVER_DESC "usbip common driver"
 
-/*-------------------------------------------------------------------------*/
-/* debug routines */
-
 #ifdef CONFIG_USB_IP_DEBUG_ENABLE
 unsigned long usbip_debug_flag = 0xffffffff;
 #else
@@ -352,9 +349,6 @@ void usbip_dump_header(struct usbip_header *pdu)
 }
 EXPORT_SYMBOL_GPL(usbip_dump_header);
 
-/*-------------------------------------------------------------------------*/
-/* socket routines */
-
 /* Send/receive messages over TCP/IP. I refer drivers/block/nbd.c */
 int usbip_xmit(int send, struct socket *sock, char *buf,
 	       int size, int msg_flags)
@@ -469,9 +463,6 @@ struct socket *sockfd_to_socket(unsigned int sockfd)
 }
 EXPORT_SYMBOL_GPL(sockfd_to_socket);
 
-/*-------------------------------------------------------------------------*/
-/* pdu routines */
-
 /* there may be more cases to tweak the flags. */
 static unsigned int tweak_transfer_flags(unsigned int flags)
 {
@@ -869,8 +860,6 @@ int usbip_recv_xbuff(struct usbip_device *ud, struct urb *urb)
 }
 EXPORT_SYMBOL_GPL(usbip_recv_xbuff);
 
-/*-------------------------------------------------------------------------*/
-
 static int __init usbip_common_init(void)
 {
 	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_DESC "" DRIVER_VERSION);
diff --git a/drivers/staging/usbip/usbip_common.h b/drivers/staging/usbip/usbip_common.h
index 7acec75..0b61d71 100644
--- a/drivers/staging/usbip/usbip_common.h
+++ b/drivers/staging/usbip/usbip_common.h
@@ -26,12 +26,6 @@
 #include <asm/byteorder.h>
 #include <net/sock.h>
 
-/*-------------------------------------------------------------------------*/
-
-/*
- * define macros to print messages
- */
-
 /**
  * usbip_udbg - print debug messages if CONFIG_USB_IP_DEBUG_ENABLE is defined
  * @fmt:
@@ -137,8 +131,6 @@ extern struct device_attribute dev_attr_usbip_debug;
 		printk(KERN_INFO "usbip: " fmt , ## args);	\
 	} while (0)
 
-/*-------------------------------------------------------------------------*/
-
 /*
  * USB/IP request headers.
  * Currently, we define 4 request types:
@@ -257,8 +249,6 @@ struct usbip_header {
 	} u;
 } __packed;
 
-/*-------------------------------------------------------------------------*/
-
 int usbip_xmit(int, struct socket *, char *, int, int);
 int usbip_sendmsg(struct socket *, struct msghdr *, int);
 
diff --git a/drivers/staging/usbip/vhci.h b/drivers/staging/usbip/vhci.h
index 6e17a00..f4834df 100644
--- a/drivers/staging/usbip/vhci.h
+++ b/drivers/staging/usbip/vhci.h
@@ -101,9 +101,6 @@ struct vhci_hcd {
 extern struct vhci_hcd *the_controller;
 extern struct attribute_group dev_attr_group;
 
-/*-------------------------------------------------------------------------*/
-/* prototype declaration */
-
 /* vhci_hcd.c */
 void rh_port_connect(int rhport, enum usb_device_speed speed);
 void rh_port_disconnect(int rhport);
diff --git a/drivers/staging/usbip/vhci_hcd.c b/drivers/staging/usbip/vhci_hcd.c
index 47884d1..da5e73a 100644
--- a/drivers/staging/usbip/vhci_hcd.c
+++ b/drivers/staging/usbip/vhci_hcd.c
@@ -154,8 +154,6 @@ void rh_port_disconnect(int rhport)
 	usb_hcd_poll_rh_status(vhci_to_hcd(the_controller));
 }
 
-/*----------------------------------------------------------------------*/
-
 #define PORT_C_MASK				\
 	((USB_PORT_STAT_C_CONNECTION		\
 	  | USB_PORT_STAT_C_ENABLE		\
@@ -478,10 +476,6 @@ static int vhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 	return retval;
 }
 
-
-
-/*----------------------------------------------------------------------*/
-
 static struct vhci_device *get_vdev(struct usb_device *udev)
 {
 	int i;
@@ -950,9 +944,6 @@ static void vhci_device_init(struct vhci_device *vdev)
 	usbip_start_eh(&vdev->ud);
 }
 
-
-/*----------------------------------------------------------------------*/
-
 static int vhci_start(struct usb_hcd *hcd)
 {
 	struct vhci_hcd *vhci = hcd_to_vhci(hcd);
@@ -1007,8 +998,6 @@ static void vhci_stop(struct usb_hcd *hcd)
 	usbip_uinfo("vhci_stop done\n");
 }
 
-/*----------------------------------------------------------------------*/
-
 static int vhci_get_frame_number(struct usb_hcd *hcd)
 {
 	usbip_uerr("Not yet implemented\n");
@@ -1214,8 +1203,6 @@ static struct platform_driver vhci_driver = {
 	},
 };
 
-/*----------------------------------------------------------------------*/
-
 /*
  * The VHCI 'device' is 'virtual'; not a real plug&play hardware.
  * We need to add this virtual device as a platform device arbitrarily:
diff --git a/drivers/staging/usbip/vhci_rx.c b/drivers/staging/usbip/vhci_rx.c
index 46f2ee5..fedc442 100644
--- a/drivers/staging/usbip/vhci_rx.c
+++ b/drivers/staging/usbip/vhci_rx.c
@@ -255,8 +255,6 @@ static void vhci_rx_pdu(struct usbip_device *ud)
 	}
 }
 
-/*-------------------------------------------------------------------------*/
-
 int vhci_rx_loop(void *data)
 {
 	struct usbip_device *ud = data;
diff --git a/drivers/staging/usbip/vhci_tx.c b/drivers/staging/usbip/vhci_tx.c
index 6ececa8..62c9acb 100644
--- a/drivers/staging/usbip/vhci_tx.c
+++ b/drivers/staging/usbip/vhci_tx.c
@@ -134,8 +134,6 @@ static int vhci_send_cmd_submit(struct vhci_device *vdev)
 	return total_size;
 }
 
-/*-------------------------------------------------------------------------*/
-
 static struct vhci_unlink *dequeue_from_unlink_tx(struct vhci_device *vdev)
 {
 	unsigned long flags;
@@ -204,8 +202,6 @@ static int vhci_send_cmd_unlink(struct vhci_device *vdev)
 	return total_size;
 }
 
-/*-------------------------------------------------------------------------*/
-
 int vhci_tx_loop(void *data)
 {
 	struct usbip_device *ud = data;
-- 
1.7.5.1

