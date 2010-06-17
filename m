Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252Ab0FQKJU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 06:09:20 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:50786 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756448Ab0FQKJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 06:09:16 -0400
Date: Thu, 17 Jun 2010 11:55:49 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] usb: atm: fixed spacing and indentation coding style issues
Message-ID: <20100617115549.4515e982@absol.kitzblitz>
Organization: -
X-Face: "fF&[w2"Nws:JNH4'g|:gVhgGKLhj|X}}&w&V?]0=,7n`jy8D6e[Jh=7+ca|4~t5e[ItpL5
 N'y~Mvi-vJm`"1T5fi1^b!&EG]6nW~C!FN},=$G?^U2t~n[3;u\"5-|~H{-5]IQ2
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed spacing and indentation coding style issues.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 drivers/usb/atm/usbatm.h  |   22 +++++++++++-----------
 drivers/usb/atm/xusbatm.c |   10 +++++-----
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/usb/atm/usbatm.h b/drivers/usb/atm/usbatm.h
index 0863f85..5fc4894 100644
--- a/drivers/usb/atm/usbatm.h
+++ b/drivers/usb/atm/usbatm.h
@@ -48,7 +48,7 @@
 			dev_warn(&(instance)->usb_intf->dev,		\
 				 "failed assertion '%s' at line %d",	\
 				 __stringify(x), __LINE__);		\
-	} while(0)
+	} while (0)
 #endif
 
 #define usb_err(instance, format, arg...)	\
@@ -59,7 +59,7 @@
 	dev_warn(&(instance)->usb_intf->dev , format , ## arg)
 #ifdef DEBUG
 #define usb_dbg(instance, format, arg...)	\
-        dev_printk(KERN_DEBUG , &(instance)->usb_intf->dev , format , ## arg)
+	dev_printk(KERN_DEBUG , &(instance)->usb_intf->dev , format , ## arg)
 #else
 #define usb_dbg(instance, format, arg...)	\
 	do {} while (0)
@@ -104,21 +104,21 @@ struct usbatm_data;
 /*
 *  Assuming all methods exist and succeed, they are called in this order:
 *
-*  	bind, heavy_init, atm_start, ..., atm_stop, unbind
+*	bind, heavy_init, atm_start, ..., atm_stop, unbind
 */
 
 struct usbatm_driver {
 	const char *driver_name;
 
 	/* init device ... can sleep, or cause probe() failure */
-        int (*bind) (struct usbatm_data *, struct usb_interface *,
+	int (*bind) (struct usbatm_data *, struct usb_interface *,
 		     const struct usb_device_id *id);
 
 	/* additional device initialization that is too slow to be done in probe() */
-        int (*heavy_init) (struct usbatm_data *, struct usb_interface *);
+	int (*heavy_init) (struct usbatm_data *, struct usb_interface *);
 
 	/* cleanup device ... can sleep, but can't fail */
-        void (*unbind) (struct usbatm_data *, struct usb_interface *);
+	void (*unbind) (struct usbatm_data *, struct usb_interface *);
 
 	/* init ATM device ... can sleep, or cause ATM initialization failure */
 	int (*atm_start) (struct usbatm_data *, struct atm_dev *);
@@ -126,9 +126,9 @@ struct usbatm_driver {
 	/* cleanup ATM device ... can sleep, but can't fail */
 	void (*atm_stop) (struct usbatm_data *, struct atm_dev *);
 
-        int bulk_in;	/* bulk rx endpoint */
-        int isoc_in;	/* isochronous rx endpoint */
-        int bulk_out;	/* bulk tx endpoint */
+	int bulk_in;	/* bulk rx endpoint */
+	int isoc_in;	/* isochronous rx endpoint */
+	int bulk_out;	/* bulk tx endpoint */
 
 	unsigned rx_padding;
 	unsigned tx_padding;
@@ -156,7 +156,7 @@ struct usbatm_channel {
 struct usbatm_data {
 	/******************
 	*  public fields  *
-        ******************/
+	******************/
 
 	/* mini driver */
 	struct usbatm_driver *driver;
@@ -174,7 +174,7 @@ struct usbatm_data {
 
 	/********************************
 	*  private fields - do not use  *
-        ********************************/
+	********************************/
 
 	struct kref refcount;
 	struct mutex serialize;
diff --git a/drivers/usb/atm/xusbatm.c b/drivers/usb/atm/xusbatm.c
index 17d167b..48ee0c5 100644
--- a/drivers/usb/atm/xusbatm.c
+++ b/drivers/usb/atm/xusbatm.c
@@ -49,13 +49,13 @@ static struct usbatm_driver xusbatm_drivers[XUSBATM_DRIVERS_MAX];
 static struct usb_device_id xusbatm_usb_ids[XUSBATM_DRIVERS_MAX + 1];
 static struct usb_driver xusbatm_usb_driver;
 
-static struct usb_interface *xusbatm_find_intf (struct usb_device *usb_dev, int altsetting, u8 ep)
+static struct usb_interface *xusbatm_find_intf(struct usb_device *usb_dev, int altsetting, u8 ep)
 {
 	struct usb_host_interface *alt;
 	struct usb_interface *intf;
 	int i, j;
 
-	for(i = 0; i < usb_dev->actconfig->desc.bNumInterfaces; i++)
+	for (i = 0; i < usb_dev->actconfig->desc.bNumInterfaces; i++)
 		if ((intf = usb_dev->actconfig->interface[i]) && (alt = usb_altnum_to_altsetting(intf, altsetting)))
 			for (j = 0; j < alt->desc.bNumEndpoints; j++)
 				if (alt->endpoint[j].desc.bEndpointAddress == ep)
@@ -63,7 +63,7 @@ static struct usb_interface *xusbatm_find_intf (struct usb_device *usb_dev, int
 	return NULL;
 }
 
-static int xusbatm_capture_intf (struct usbatm_data *usbatm, struct usb_device *usb_dev,
+static int xusbatm_capture_intf(struct usbatm_data *usbatm, struct usb_device *usb_dev,
 		struct usb_interface *intf, int altsetting, int claim)
 {
 	int ifnum = intf->altsetting->desc.bInterfaceNumber;
@@ -80,7 +80,7 @@ static int xusbatm_capture_intf (struct usbatm_data *usbatm, struct usb_device *
 	return 0;
 }
 
-static void xusbatm_release_intf (struct usb_device *usb_dev, struct usb_interface *intf, int claimed)
+static void xusbatm_release_intf(struct usb_device *usb_dev, struct usb_interface *intf, int claimed)
 {
 	if (claimed) {
 		usb_set_intfdata(intf, NULL);
@@ -147,7 +147,7 @@ static void xusbatm_unbind(struct usbatm_data *usbatm,
 
 	usb_dbg(usbatm, "%s entered\n", __func__);
 
-	for(i = 0; i < usb_dev->actconfig->desc.bNumInterfaces; i++) {
+	for (i = 0; i < usb_dev->actconfig->desc.bNumInterfaces; i++) {
 		struct usb_interface *cur_intf = usb_dev->actconfig->interface[i];
 
 		if (cur_intf && (usb_get_intfdata(cur_intf) == usbatm)) {
-- 
1.6.4.4
