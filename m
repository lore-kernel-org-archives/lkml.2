Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576Ab0JNJjI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 05:39:08 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36395 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755454Ab0JNJjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 05:39:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=A5D00nkLFz3lV99RFebOJWQOSzmqfv6EfZpuBKVjUgc9Me/AHSKzKEcKVJRdeFSN8s
         KFKRx8KPSw53ukSe6IsIeCBl6sWqoUJ+/DfasvJw5XM8LNOJ2c95UIxaDbvC5WoNaNjB
         ZvccF0CUArr+e0MQp7wcL7ev4OTEnXfdPi+iA=
From: Marek Belisko <marek.belisko@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Marek Belisko <marek.belisko@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Marek Belisko <marek.belisko@gmail.com>
Subject: [PATCH 4/5] staging:ft1000: correct indentations for ft1000_usb.c file.
Date: Thu, 14 Oct 2010 11:40:59 +0200
Message-Id: <1287049260-11988-5-git-send-email-marek.belisko@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287049260-11988-1-git-send-email-marek.belisko@gmail.com>
References: <1287049260-11988-1-git-send-email-marek.belisko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.c |  165 +++++++++++------------
 1 files changed, 79 insertions(+), 86 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
index c6aec27..44c475b 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
@@ -22,17 +22,16 @@ MODULE_DESCRIPTION("FT1000 EXPRESS CARD DRIVER");
 MODULE_LICENSE("Dual MPL/GPL");
 MODULE_SUPPORTED_DEVICE("QFT FT1000 Express Cards");
 
-
 void *pFileStart;
 size_t FileLength;
 
-#define VENDOR_ID 0x1291   /* Qualcomm vendor id */
-#define PRODUCT_ID 0x11    /* fake product id */
+#define VENDOR_ID 0x1291	/* Qualcomm vendor id */
+#define PRODUCT_ID 0x11		/* fake product id */
 
 /* table of devices that work with this driver */
 static struct usb_device_id id_table[] = {
-    {USB_DEVICE(VENDOR_ID, PRODUCT_ID)},
-    { },
+	{USB_DEVICE(VENDOR_ID, PRODUCT_ID)},
+	{},
 };
 
 MODULE_DEVICE_TABLE(usb, id_table);
@@ -40,35 +39,34 @@ MODULE_DEVICE_TABLE(usb, id_table);
 static BOOLEAN gPollingfailed = FALSE;
 int ft1000_poll_thread(void *arg)
 {
-    int ret = STATUS_SUCCESS;
-
-    while (!kthread_should_stop()) {
-        msleep(10);
-        if (!gPollingfailed) {
-            ret = ft1000_poll(arg);
-            if (ret != STATUS_SUCCESS) {
-                DEBUG("ft1000_poll_thread: polling failed\n");
-                gPollingfailed = TRUE;
-            }
-        }
-    }
+	int ret = STATUS_SUCCESS;
+
+	while (!kthread_should_stop()) {
+		msleep(10);
+		if (!gPollingfailed) {
+			ret = ft1000_poll(arg);
+			if (ret != STATUS_SUCCESS) {
+				DEBUG("ft1000_poll_thread: polling failed\n");
+				gPollingfailed = TRUE;
+			}
+		}
+	}
 	return STATUS_SUCCESS;
 }
 
 static int ft1000_probe(struct usb_interface *interface,
 			const struct usb_device_id *id)
 {
-    struct usb_host_interface *iface_desc;
-    struct usb_endpoint_descriptor *endpoint;
-    struct usb_device *dev;
-    unsigned numaltsetting;
+	struct usb_host_interface *iface_desc;
+	struct usb_endpoint_descriptor *endpoint;
+	struct usb_device *dev;
+	unsigned numaltsetting;
 	int i, ret = 0, size;
 
-    struct ft1000_device *ft1000dev;
-    FT1000_INFO *pft1000info;
+	struct ft1000_device *ft1000dev;
+	FT1000_INFO *pft1000info;
 	const struct firmware *dsp_fw;
 
-
 	ft1000dev = kmalloc(sizeof(struct ft1000_device), GFP_KERNEL);
 
 	if (!ft1000dev) {
@@ -76,10 +74,10 @@ static int ft1000_probe(struct usb_interface *interface,
 		return 0;
 	}
 
-    memset(ft1000dev, 0, sizeof(*ft1000dev));
+	memset(ft1000dev, 0, sizeof(*ft1000dev));
 
-    dev = interface_to_usbdev(interface);
-    DEBUG("ft1000_probe: usb device descriptor info:\n");
+	dev = interface_to_usbdev(interface);
+	DEBUG("ft1000_probe: usb device descriptor info:\n");
 	DEBUG("ft1000_probe: number of configuration is %d\n",
 	      dev->descriptor.bNumConfigurations);
 
@@ -90,11 +88,10 @@ static int ft1000_probe(struct usb_interface *interface,
 	ft1000dev->tx_urb = usb_alloc_urb(0, GFP_ATOMIC);
 	ft1000dev->rx_urb = usb_alloc_urb(0, GFP_ATOMIC);
 
-
-    DEBUG("ft1000_probe is called\n");
-    numaltsetting = interface->num_altsetting;
-    DEBUG("ft1000_probe: number of alt settings is :%d\n", numaltsetting);
-    iface_desc = interface->cur_altsetting;
+	DEBUG("ft1000_probe is called\n");
+	numaltsetting = interface->num_altsetting;
+	DEBUG("ft1000_probe: number of alt settings is :%d\n", numaltsetting);
+	iface_desc = interface->cur_altsetting;
 	DEBUG("ft1000_probe: number of endpoints is %d\n",
 	      iface_desc->desc.bNumEndpoints);
 	DEBUG("ft1000_probe: descriptor type is %d\n",
@@ -105,7 +102,7 @@ static int ft1000_probe(struct usb_interface *interface,
 	      iface_desc->desc.bAlternateSetting);
 	DEBUG("ft1000_probe: interface class is %d\n",
 	      iface_desc->desc.bInterfaceClass);
-    DEBUG("ft1000_probe: control endpoint info:\n");
+	DEBUG("ft1000_probe: control endpoint info:\n");
 	DEBUG("ft1000_probe: descriptor0 type -- %d\n",
 	      iface_desc->endpoint[0].desc.bmAttributes);
 	DEBUG("ft1000_probe: descriptor1 type -- %d\n",
@@ -113,18 +110,18 @@ static int ft1000_probe(struct usb_interface *interface,
 	DEBUG("ft1000_probe: descriptor2 type -- %d\n",
 	      iface_desc->endpoint[2].desc.bmAttributes);
 
-    for (i = 0; i < iface_desc->desc.bNumEndpoints; i++) {
+	for (i = 0; i < iface_desc->desc.bNumEndpoints; i++) {
 		endpoint =
-		    (struct usb_endpoint_descriptor *)&iface_desc->endpoint[i].
-		    desc;
-                DEBUG("endpoint %d\n", i);
+		    (struct usb_endpoint_descriptor *)&iface_desc->
+		    endpoint[i].desc;
+		DEBUG("endpoint %d\n", i);
 		DEBUG("bEndpointAddress=%x, bmAttributes=%x\n",
 		      endpoint->bEndpointAddress, endpoint->bmAttributes);
 		if ((endpoint->bEndpointAddress & USB_DIR_IN)
 		    && ((endpoint->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) ==
 			USB_ENDPOINT_XFER_BULK)) {
 			ft1000dev->bulk_in_endpointAddr =
-				endpoint->bEndpointAddress;
+			    endpoint->bEndpointAddress;
 			DEBUG("ft1000_probe: in: %d\n",
 			      endpoint->bEndpointAddress);
 		}
@@ -133,11 +130,11 @@ static int ft1000_probe(struct usb_interface *interface,
 		    && ((endpoint->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) ==
 			USB_ENDPOINT_XFER_BULK)) {
 			ft1000dev->bulk_out_endpointAddr =
-				endpoint->bEndpointAddress;
+			    endpoint->bEndpointAddress;
 			DEBUG("ft1000_probe: out: %d\n",
 			      endpoint->bEndpointAddress);
 		}
-    }
+	}
 
 	DEBUG("bulk_in=%d, bulk_out=%d\n", ft1000dev->bulk_in_endpointAddr,
 	      ft1000dev->bulk_out_endpointAddr);
@@ -161,9 +158,9 @@ static int ft1000_probe(struct usb_interface *interface,
 	FileLength = dsp_fw->size;
 	release_firmware(dsp_fw);
 
-    DEBUG("ft1000_probe: start downloading dsp image...\n");
-    init_ft1000_netdev(ft1000dev);
-    pft1000info = (FT1000_INFO *) netdev_priv(ft1000dev->net);
+	DEBUG("ft1000_probe: start downloading dsp image...\n");
+	init_ft1000_netdev(ft1000dev);
+	pft1000info = (FT1000_INFO *) netdev_priv(ft1000dev->net);
 
 	DEBUG("In probe: pft1000info=%p\n", pft1000info);
 	ret = dsp_reload(ft1000dev);
@@ -188,16 +185,15 @@ static int ft1000_probe(struct usb_interface *interface,
 		DEBUG("ft1000_probe::Waiting for Card Ready\n");
 	}
 
+	DEBUG("ft1000_probe::Card Ready!!!! Registering network device\n");
 
-    DEBUG("ft1000_probe::Card Ready!!!! Registering network device\n");
-
-    reg_ft1000_netdev(ft1000dev, interface);
+	reg_ft1000_netdev(ft1000dev, interface);
 
-    pft1000info->NetDevRegDone = 1;
+	pft1000info->NetDevRegDone = 1;
 
-		ft1000InitProc(ft1000dev->net);
+	ft1000InitProc(ft1000dev->net);
 
-       return 0;
+	return 0;
 
 err_load:
 	kfree(pFileStart);
@@ -208,70 +204,67 @@ err_fw:
 
 static void ft1000_disconnect(struct usb_interface *interface)
 {
-    FT1000_INFO *pft1000info;
+	FT1000_INFO *pft1000info;
 
-    DEBUG("ft1000_disconnect is called\n");
+	DEBUG("ft1000_disconnect is called\n");
 
-    pft1000info = (PFT1000_INFO)usb_get_intfdata(interface);
+	pft1000info = (PFT1000_INFO) usb_get_intfdata(interface);
 	DEBUG("In disconnect pft1000info=%p\n", pft1000info);
 
-
-
-    if (pft1000info) {
+	if (pft1000info) {
 		ft1000CleanupProc(pft1000info);
-        if (pft1000info->pPollThread)
-            kthread_stop(pft1000info->pPollThread );
+		if (pft1000info->pPollThread)
+			kthread_stop(pft1000info->pPollThread);
 
-        DEBUG("ft1000_disconnect: threads are terminated\n");
+		DEBUG("ft1000_disconnect: threads are terminated\n");
 
-        if (pft1000info->pFt1000Dev->net) {
-            DEBUG("ft1000_disconnect: destroy char driver\n");
-            ft1000_DestroyDevice(pft1000info->pFt1000Dev->net);
-            unregister_netdev(pft1000info->pFt1000Dev->net);
-            DEBUG("ft1000_disconnect: network device unregisterd\n");
-            free_netdev(pft1000info->pFt1000Dev->net);
+		if (pft1000info->pFt1000Dev->net) {
+			DEBUG("ft1000_disconnect: destroy char driver\n");
+			ft1000_DestroyDevice(pft1000info->pFt1000Dev->net);
+			unregister_netdev(pft1000info->pFt1000Dev->net);
+			DEBUG
+			    ("ft1000_disconnect: network device unregisterd\n");
+			free_netdev(pft1000info->pFt1000Dev->net);
 
-        }
+		}
 
-        usb_free_urb(pft1000info->pFt1000Dev->rx_urb);
-        usb_free_urb(pft1000info->pFt1000Dev->tx_urb);
+		usb_free_urb(pft1000info->pFt1000Dev->rx_urb);
+		usb_free_urb(pft1000info->pFt1000Dev->tx_urb);
 
-        DEBUG("ft1000_disconnect: urb freed\n");
+		DEBUG("ft1000_disconnect: urb freed\n");
 
 		kfree(pft1000info->pFt1000Dev);
-    }
+	}
 	kfree(pFileStart);
 
-    return;
+	return;
 }
 
 static struct usb_driver ft1000_usb_driver = {
-    .name  =    "ft1000usb",
-    .probe =    ft1000_probe,
-    .disconnect = ft1000_disconnect,
-    .id_table = id_table,
+	.name = "ft1000usb",
+	.probe = ft1000_probe,
+	.disconnect = ft1000_disconnect,
+	.id_table = id_table,
 };
 
 static int __init usb_ft1000_init(void)
 {
-    int ret = 0;
+	int ret = 0;
 
-    DEBUG("Initialize and register the driver\n");
+	DEBUG("Initialize and register the driver\n");
 
-    ret = usb_register(&ft1000_usb_driver);
-    if (ret)
-        err("usb_register failed. Error number %d", ret);
+	ret = usb_register(&ft1000_usb_driver);
+	if (ret)
+		err("usb_register failed. Error number %d", ret);
 
-    return ret;
+	return ret;
 }
 
 static void __exit usb_ft1000_exit(void)
 {
-    DEBUG("Deregister the driver\n");
-    usb_deregister(&ft1000_usb_driver);
+	DEBUG("Deregister the driver\n");
+	usb_deregister(&ft1000_usb_driver);
 }
 
-module_init (usb_ft1000_init);
-module_exit (usb_ft1000_exit);
-
-
+module_init(usb_ft1000_init);
+module_exit(usb_ft1000_exit);
-- 
1.7.1

