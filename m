Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab0E0CX5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 22:23:57 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:62920 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727Ab0E0CXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 22:23:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=rnuAhLQjXwz84Wi6T28krvgw2XH8XDsu0eMFfCDMF+lCUQvGAlxXpHFdMquTazKIu4
         5R6pmal4FIFcnhNR8FYmvaIM4m9Qj12HzTOqt/lVbpCsGLBO7oW8FirXWMEhj0I876Wg
         uV2SB9DL+W2OoVqwFrvvG5gXPWKpFh+Lcv9mE=
From: Scott Kidder <scott.kidder11@gmail.com>
To: gregkh@suse.de, julia@diku.dk, tj@kernel.org, joe@perches.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Scott Kidder <scott.kidder11@gmail.com>
Subject: [PATCH] Staging: otus: fix style issues in zdusb.c
Date: Wed, 26 May 2010 22:36:15 -0500
Message-Id: <1274931375-32581-1-git-send-email-scott.kidder11@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to zdusb.c that fixes whitespace,
C99 comment, and other style issues found by the
checkpatch.pl tool

Signed-off-by: Scott Kidder <scott.kidder11@gmail.com>
---
 drivers/staging/otus/zdusb.c |  251 ++++++++++++++++++++----------------------
 1 files changed, 119 insertions(+), 132 deletions(-)

diff --git a/drivers/staging/otus/zdusb.c b/drivers/staging/otus/zdusb.c
index 2c799a2..4014b74 100644
--- a/drivers/staging/otus/zdusb.c
+++ b/drivers/staging/otus/zdusb.c
@@ -48,7 +48,7 @@ static const char driver_name[] = "Otus";
 /* table of devices that work with this driver */
 static const struct usb_device_id zd1221_ids[] = {
 	{ USB_DEVICE(VENDOR_ATHR, PRODUCT_AR9170) },
-        { USB_DEVICE(VENDOR_DLINK, PRODUCT_DWA160A) },
+	{ USB_DEVICE(VENDOR_DLINK, PRODUCT_DWA160A) },
 	{ USB_DEVICE(VENDOR_NETGEAR, PRODUCT_WNDA3100) },
 	{ USB_DEVICE(VENDOR_NETGEAR, PRODUCT_WN111v2) },
 	{ }					/* Terminating entry */
@@ -60,9 +60,9 @@ extern u8_t zfLnxInitSetup(struct net_device *dev, struct usbdrv_private *macp);
 extern int usbdrv_close(struct net_device *dev);
 extern u8_t zfLnxClearStructs(struct net_device *dev);
 extern int zfWdsClose(struct net_device *dev);
-extern int zfUnregisterWdsDev(struct net_device* parentDev, u16_t wdsId);
+extern int zfUnregisterWdsDev(struct net_device *parentDev, u16_t wdsId);
 extern int zfLnxVapClose(struct net_device *dev);
-extern int zfLnxUnregisterVapDev(struct net_device* parentDev, u16_t vapId);
+extern int zfLnxUnregisterVapDev(struct net_device *parentDev, u16_t vapId);
 
 /* WDS */
 extern struct zsWdsStruct wds[ZM_WDS_PORT_NUMBER];
@@ -73,148 +73,135 @@ extern struct zsVapStruct vap[ZM_VAP_PORT_NUMBER];
 static int zfLnxProbe(struct usb_interface *interface,
 	const struct usb_device_id *id)
 {
-    struct usb_device *dev = interface_to_usbdev(interface);
-
-    struct net_device *net = NULL;
-    struct usbdrv_private *macp = NULL;
-    int vendor_id, product_id;
-    int result = 0;
-
-    usb_get_dev(dev);
-
-    vendor_id = dev->descriptor.idVendor;
-    product_id = dev->descriptor.idProduct;
-
-#ifdef HMAC_DEBUG
-    printk(KERN_NOTICE "vendor_id = %04x\n", vendor_id);
-    printk(KERN_NOTICE "product_id = %04x\n", product_id);
-
-    if (dev->speed == USB_SPEED_HIGH)
-        printk(KERN_NOTICE "USB 2.0 Host\n");
-    else
-        printk(KERN_NOTICE "USB 1.1 Host\n");
-#endif
-
-    macp = kzalloc(sizeof(struct usbdrv_private), GFP_KERNEL);
-    if (!macp)
-    {
-        printk(KERN_ERR "out of memory allocating device structure\n");
-        result = -ENOMEM;
-        goto fail;
-    }
-
-    net = alloc_etherdev(0);
-
-    if (net == NULL)
-    {
-        printk(KERN_ERR "zfLnxProbe: Not able to alloc etherdev struct\n");
-        result = -ENOMEM;
-        goto fail1;
-    }
-
-    strcpy(net->name, "ath%d");
-
-    net->ml_priv = macp;   //kernel 2.6
-    macp->udev = dev;
-    macp->device = net;
-
-    /* set up the endpoint information */
-    /* check out the endpoints */
-    macp->interface = interface;
-
-    //init_waitqueue_head(&macp->regSet_wait);
-    //init_waitqueue_head(&macp->iorwRsp_wait);
-    //init_waitqueue_head(&macp->term_wait);
-
-    if (!zfLnxAllocAllUrbs(macp))
-    {
-        result = -ENOMEM;
-        goto fail2;
-    }
-
-    if (!zfLnxInitSetup(net, macp))
-    {
-        result = -EIO;
-        goto fail3;
-    }
-    else
-    {
-        usb_set_intfdata(interface, macp);
-        SET_NETDEV_DEV(net, &interface->dev);
-
-        if (register_netdev(net) != 0)
-        {
-            usb_set_intfdata(interface, NULL);
-            goto fail3;
-        }
-    }
-
-    netif_carrier_off(net);
-    goto done;
-
+	struct usb_device *dev = interface_to_usbdev(interface);
+
+	struct net_device *net = NULL;
+	struct usbdrv_private *macp = NULL;
+	int vendor_id, product_id;
+	int result = 0;
+
+	usb_get_dev(dev);
+
+	vendor_id = dev->descriptor.idVendor;
+	product_id = dev->descriptor.idProduct;
+
+	#ifdef HMAC_DEBUG
+		printk(KERN_NOTICE "vendor_id = %04x\n", vendor_id);
+		printk(KERN_NOTICE "product_id = %04x\n", product_id);
+
+	if (dev->speed == USB_SPEED_HIGH)
+		printk(KERN_NOTICE "USB 2.0 Host\n");
+	else
+		printk(KERN_NOTICE "USB 1.1 Host\n");
+	#endif
+
+	macp = kzalloc(sizeof(struct usbdrv_private), GFP_KERNEL);
+	if (!macp) {
+		printk(KERN_ERR "out of memory allocating device structure\n");
+		result = -ENOMEM;
+		goto fail;
+	}
+
+	net = alloc_etherdev(0);
+
+	if (net == NULL) {
+		printk(KERN_ERR "zfLnxProbe: Not able to alloc etherdev struct\n");
+		result = -ENOMEM;
+		goto fail1;
+	}
+
+	strcpy(net->name, "ath%d");
+
+	net->ml_priv = macp;   /* kernel 2.6 */
+	macp->udev = dev;
+	macp->device = net;
+
+	/* set up the endpoint information */
+	/* check out the endpoints */
+	macp->interface = interface;
+
+	/* init_waitqueue_head(&macp->regSet_wait); */
+	/* init_waitqueue_head(&macp->iorwRsp_wait); */
+	/* init_waitqueue_head(&macp->term_wait); */
+
+	if (!zfLnxAllocAllUrbs(macp)) {
+		result = -ENOMEM;
+		goto fail2;
+	}
+
+	if (!zfLnxInitSetup(net, macp)) {
+		result = -EIO;
+		goto fail3;
+	} else {
+		usb_set_intfdata(interface, macp);
+		SET_NETDEV_DEV(net, &interface->dev);
+
+		if (register_netdev(net) != 0) {
+			usb_set_intfdata(interface, NULL);
+			goto fail3;
+		}
+	}
+
+	netif_carrier_off(net);
+	    goto done;
 fail3:
-    zfLnxFreeAllUrbs(macp);
+	zfLnxFreeAllUrbs(macp);
 fail2:
-    free_netdev(net);  //kernel 2.6
+	free_netdev(net);  /* kernel 2.6 */
 fail1:
-    kfree(macp);
-
+	kfree(macp);
 fail:
-    usb_put_dev(dev);
-    macp = NULL;
-
+	usb_put_dev(dev);
+	macp = NULL;
 done:
-    return result;
+	return result;
 }
 
 static void zfLnxDisconnect(struct usb_interface *interface)
 {
-    struct usbdrv_private *macp = (struct usbdrv_private *) usb_get_intfdata(interface);
-
-    printk(KERN_DEBUG "zfLnxDisconnect\n");
-
-    if (!macp)
-    {
-        printk(KERN_ERR "unregistering non-existant device\n");
-        return;
-    }
-
-    if (macp->driver_isolated)
-    {
-        if (macp->device->flags & IFF_UP)
-            usbdrv_close(macp->device);
-    }
-
-#if 0
-    /* Close WDS */
-    //zfWdsClose(wds[0].dev);
-    /* Unregister WDS */
-    //zfUnregisterWdsDev(macp->device, 0);
-
-    /* Close VAP */
-    zfLnxVapClose(vap[0].dev);
-    /* Unregister VAP */
-    zfLnxUnregisterVapDev(macp->device, 0);
-#endif
+	struct usbdrv_private *macp = (struct usbdrv_private *) usb_get_intfdata(interface);
+
+	printk(KERN_DEBUG "zfLnxDisconnect\n");
+
+	if (!macp) {
+		printk(KERN_ERR "unregistering non-existant device\n");
+		return;
+	}
+
+	if (macp->driver_isolated)
+		if (macp->device->flags & IFF_UP)
+			usbdrv_close(macp->device);
+
+	#if 0
+		/* Close WDS */
+		/* zfWdsClose(wds[0].dev); */
+		/* Unregister WDS */
+		/* zfUnregisterWdsDev(macp->device, 0); */
+
+		/* Close VAP */
+		zfLnxVapClose(vap[0].dev);
+		/* Unregister VAP */
+		zfLnxUnregisterVapDev(macp->device, 0);
+	#endif
 
-    zfLnxClearStructs(macp->device);
+	zfLnxClearStructs(macp->device);
 
-    unregister_netdev(macp->device);
+	unregister_netdev(macp->device);
 
-    usb_put_dev(interface_to_usbdev(interface));
+	usb_put_dev(interface_to_usbdev(interface));
 
-    //printk(KERN_ERR "3. zfLnxUnlinkAllUrbs\n");
-    //zfLnxUnlinkAllUrbs(macp);
+	/* printk(KERN_ERR "3. zfLnxUnlinkAllUrbs\n"); */
+	/* zfLnxUnlinkAllUrbs(macp); */
 
-    /* Free network interface */
-    free_netdev(macp->device);
+	/* Free network interface */
+	free_netdev(macp->device);
 
-    zfLnxFreeAllUrbs(macp);
-    //zfLnxClearStructs(macp->device);
-    kfree(macp);
-    macp = NULL;
+	zfLnxFreeAllUrbs(macp);
+	/* zfLnxClearStructs(macp->device); */
+	kfree(macp);
+	macp = NULL;
 
-    usb_set_intfdata(interface, NULL);
+	usb_set_intfdata(interface, NULL);
 }
 
 static struct usb_driver zd1221_driver = {
@@ -226,13 +213,13 @@ static struct usb_driver zd1221_driver = {
 
 int __init zfLnxIinit(void)
 {
-    printk(KERN_NOTICE "%s - version %s\n",  DRIVER_NAME, VERSIONID);
-    return usb_register(&zd1221_driver);
+	printk(KERN_NOTICE "%s - version %s\n",  DRIVER_NAME, VERSIONID);
+	return usb_register(&zd1221_driver);
 }
 
 void __exit zfLnxExit(void)
 {
-    usb_deregister(&zd1221_driver);
+	usb_deregister(&zd1221_driver);
 }
 
 module_init(zfLnxIinit);
-- 
1.7.1

