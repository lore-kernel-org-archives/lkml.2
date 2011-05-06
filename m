Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab1EFKyT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 06:54:19 -0400
Received: from qmta15.emeryville.ca.mail.comcast.net ([76.96.27.228]:43094
	"EHLO qmta15.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754216Ab1EFKyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 06:54:18 -0400
X-Greylist: delayed 341 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 May 2011 06:54:18 EDT
From: matt mooney <mfm@muteddisk.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 01/16] staging: usbip: stub_dev.c: coding style cleanup
Date: Fri,  6 May 2011 03:47:41 -0700
Message-Id: <f8dae1ba6dc2fd17652689dc51f4210d803e51c2.1304676742.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1304676742.git.mfm@muteddisk.com>
References: <cover.1304676742.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix alignment for consistency and remove extraneous lines.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/stub_dev.c |   44 ++++++++++---------------------------
 1 files changed, 12 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/usbip/stub_dev.c b/drivers/staging/usbip/stub_dev.c
index bce7d03..8a55068 100644
--- a/drivers/staging/usbip/stub_dev.c
+++ b/drivers/staging/usbip/stub_dev.c
@@ -23,13 +23,10 @@
 #include "usbip_common.h"
 #include "stub.h"
 
-
-
 static int stub_probe(struct usb_interface *interface,
-				const struct usb_device_id *id);
+		      const struct usb_device_id *id);
 static void stub_disconnect(struct usb_interface *interface);
 
-
 /*
  * Define device IDs here if you want to explicitly limit exportable devices.
  * In the most cases, wild card matching will be ok because driver binding can
@@ -64,7 +61,6 @@ struct usb_driver stub_driver = {
 	.id_table	= stub_table,
 };
 
-
 /*-------------------------------------------------------------------------*/
 
 /* Define sysfs entries for a usbip-bound device */
@@ -128,13 +124,11 @@ static ssize_t store_sockfd(struct device *dev, struct device_attribute *attr,
 			spin_unlock(&sdev->ud.lock);
 			return -EINVAL;
 		}
-
 #if 0
 		setnodelay(socket);
 		setkeepalive(socket);
 		setreuse(socket);
 #endif
-
 		sdev->ud.tcp_socket = socket;
 
 		spin_unlock(&sdev->ud.lock);
@@ -183,10 +177,8 @@ static int stub_add_files(struct device *dev)
 
 err_debug:
 	device_remove_file(dev, &dev_attr_usbip_sockfd);
-
 err_sockfd:
 	device_remove_file(dev, &dev_attr_usbip_status);
-
 err_status:
 	return err;
 }
@@ -198,8 +190,6 @@ static void stub_remove_files(struct device *dev)
 	device_remove_file(dev, &dev_attr_usbip_debug);
 }
 
-
-
 /*-------------------------------------------------------------------------*/
 
 /* Event handler functions called by an event handler thread */
@@ -244,18 +234,15 @@ static void stub_shutdown_connection(struct usbip_device *ud)
 		struct stub_unlink *unlink, *tmp;
 
 		spin_lock_irqsave(&sdev->priv_lock, flags);
-
 		list_for_each_entry_safe(unlink, tmp, &sdev->unlink_tx, list) {
 			list_del(&unlink->list);
 			kfree(unlink);
 		}
-
 		list_for_each_entry_safe(unlink, tmp,
 						 &sdev->unlink_free, list) {
 			list_del(&unlink->list);
 			kfree(unlink);
 		}
-
 		spin_unlock_irqrestore(&sdev->priv_lock, flags);
 	}
 }
@@ -275,7 +262,6 @@ static void stub_device_reset(struct usbip_device *ud)
 		spin_lock(&ud->lock);
 		ud->status = SDEV_ST_ERROR;
 		spin_unlock(&ud->lock);
-
 		return;
 	}
 
@@ -306,7 +292,6 @@ static void stub_device_unusable(struct usbip_device *ud)
 	spin_unlock(&ud->lock);
 }
 
-
 /*-------------------------------------------------------------------------*/
 
 /**
@@ -339,13 +324,12 @@ static struct stub_device *stub_device_alloc(struct usb_device *udev,
 	 * devnum may change later if a device is reset. However, devid never
 	 * changes during a usbip connection.
 	 */
-	sdev->devid     = (busnum << 16) | devnum;
-
-	sdev->ud.side = USBIP_STUB;
-	sdev->ud.status = SDEV_ST_AVAILABLE;
+	sdev->devid		= (busnum << 16) | devnum;
+	sdev->ud.side		= USBIP_STUB;
+	sdev->ud.status		= SDEV_ST_AVAILABLE;
 	/* sdev->ud.lock = SPIN_LOCK_UNLOCKED; */
 	spin_lock_init(&sdev->ud.lock);
-	sdev->ud.tcp_socket = NULL;
+	sdev->ud.tcp_socket	= NULL;
 
 	INIT_LIST_HEAD(&sdev->priv_init);
 	INIT_LIST_HEAD(&sdev->priv_tx);
@@ -378,7 +362,6 @@ static int stub_device_free(struct stub_device *sdev)
 	return 0;
 }
 
-
 /*-------------------------------------------------------------------------*/
 
 /*
@@ -405,7 +388,7 @@ static int stub_probe(struct usb_interface *interface,
 	/* check we should claim or not by busid_table */
 	busid_priv = get_busid_priv(udev_busid);
 	if (!busid_priv  || (busid_priv->status == STUB_BUSID_REMOV) ||
-			     (busid_priv->status == STUB_BUSID_OTHER)) {
+	    (busid_priv->status == STUB_BUSID_OTHER)) {
 		dev_info(&interface->dev,
 			 "this device %s is not in match_busid table. skip!\n",
 			 udev_busid);
@@ -420,17 +403,16 @@ static int stub_probe(struct usb_interface *interface,
 
 	if (udev->descriptor.bDeviceClass ==  USB_CLASS_HUB) {
 		usbip_udbg("this device %s is a usb hub device. skip!\n",
-								udev_busid);
+			   udev_busid);
 		return -ENODEV;
 	}
 
 	if (!strcmp(udev->bus->bus_name, "vhci_hcd")) {
 		usbip_udbg("this device %s is attached on vhci_hcd. skip!\n",
-								udev_busid);
+			   udev_busid);
 		return -ENODEV;
 	}
 
-
 	if (busid_priv->status == STUB_BUSID_ALLOC) {
 		sdev = busid_priv->sdev;
 		if (!sdev)
@@ -438,9 +420,10 @@ static int stub_probe(struct usb_interface *interface,
 
 		busid_priv->interf_count++;
 		dev_info(&interface->dev,
-		 "USB/IP Stub: register a new interface "
-		 "(bus %u dev %u ifn %u)\n", udev->bus->busnum, udev->devnum,
-		 interface->cur_altsetting->desc.bInterfaceNumber);
+			 "USB/IP Stub: register a new interface "
+			 "(bus %u dev %u ifn %u)\n",
+			 udev->bus->busnum, udev->devnum,
+			 interface->cur_altsetting->desc.bInterfaceNumber);
 
 		/* set private data to usb_interface */
 		usb_set_intfdata(interface, sdev);
@@ -504,10 +487,8 @@ static void shutdown_busid(struct bus_id_priv *busid_priv)
 		/* 2. wait for the stop of the event handler */
 		usbip_stop_eh(&busid_priv->sdev->ud);
 	}
-
 }
 
-
 /*
  * called in usb_disconnect() or usb_deregister()
  * but only if actconfig(active configuration) exists
@@ -559,7 +540,6 @@ static void stub_disconnect(struct usb_interface *interface)
 
 	busid_priv->interf_count = 0;
 
-
 	/* 1. shutdown the current connection */
 	shutdown_busid(busid_priv);
 
-- 
1.7.5.1

