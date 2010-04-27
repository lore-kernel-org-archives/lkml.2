Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757132Ab0D0VZg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 17:25:36 -0400
Received: from mail-ew0-f220.google.com ([209.85.219.220]:54663 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757115Ab0D0VZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 17:25:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=EmeRnU2QumtDEsDuAKG4U2TzXa5upQtnHX2BdUC3Btrahri77lV0byYeqFEp+c1ZBO
         PYy+c5tzUpQlqlumd7ioehZ1xU+eREChJiUGyTkp4w15uZKjsRR639AMYR1M9xtk7iFt
         He5lt9n0gakLm4PD1Dhu+3EiyeSlcSTkZVxcs=
From: Roel Van Nyen <roel.vannyen@gmail.com>
To: gregkh@suse.de
Cc: mchehab@redhat.com, stefan.ringel@arcor.de, michel.ludwig@gmail.com,
       d.belimov@gmail.com, linux-kernel@vger.kernel.org,
       Roel Van Nyen <roel.vannyen@gmail.com>
Subject: [PATCH] Staging: tm6000: fix coding style issues of tm6000-cards.c
Date: Tue, 27 Apr 2010 23:25:15 +0200
Message-Id: <1272403516-26560-1-git-send-email-roel.vannyen@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix coding style issues

Signed-off-by: Roel Van Nyen <roel.vannyen@gmail.com>
---
 drivers/staging/tm6000/tm6000-cards.c |  131 ++++++++++++++++-----------------
 1 files changed, 63 insertions(+), 68 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index 2935533..a7e2b54 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -246,7 +246,7 @@ struct tm6000_board tm6000_boards[] = {
 };
 
 /* table of devices that work with this driver */
-struct usb_device_id tm6000_id_table [] = {
+struct usb_device_id tm6000_id_table[] = {
 	{ USB_DEVICE(0x6000, 0x0001), .driver_info = TM5600_BOARD_10MOONS_UT821 },
 	{ USB_DEVICE(0x6000, 0x0002), .driver_info = TM6010_BOARD_GENERIC },
 	{ USB_DEVICE(0x06e1, 0xf332), .driver_info = TM6000_BOARD_ADSTECH_DUAL_TV },
@@ -271,23 +271,23 @@ struct usb_device_id tm6000_id_table [] = {
 
 int tm6000_tuner_callback(void *ptr, int component, int command, int arg)
 {
-	int rc=0;
+	int rc = 0;
 	struct tm6000_core *dev = ptr;
 
-	if (dev->tuner_type!=TUNER_XC2028)
+	if (dev->tuner_type != TUNER_XC2028)
 		return 0;
 
 	switch (command) {
 	case XC2028_RESET_CLK:
-		tm6000_set_reg (dev, REQ_04_EN_DISABLE_MCU_INT,
+		tm6000_set_reg(dev, REQ_04_EN_DISABLE_MCU_INT,
 					0x02, arg);
 		msleep(10);
-		rc=tm6000_set_reg (dev, REQ_03_SET_GET_MCU_PIN,
+		rc = tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
 					TM6000_GPIO_CLK, 0);
-		if (rc<0)
+		if (rc < 0)
 			return rc;
 		msleep(10);
-		rc=tm6000_set_reg (dev, REQ_03_SET_GET_MCU_PIN,
+		rc = tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
 					TM6000_GPIO_CLK, 1);
 		break;
 	case XC2028_TUNER_RESET:
@@ -320,24 +320,24 @@ int tm6000_tuner_callback(void *ptr, int component, int command, int arg)
 			}
 			break;
 		case 1:
-			tm6000_set_reg (dev, REQ_04_EN_DISABLE_MCU_INT,
+			tm6000_set_reg(dev, REQ_04_EN_DISABLE_MCU_INT,
 						0x02, 0x01);
 			msleep(10);
 			break;
 
 		case 2:
-			rc=tm6000_set_reg (dev, REQ_03_SET_GET_MCU_PIN,
+			rc = tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
 						TM6000_GPIO_CLK, 0);
-			if (rc<0)
+			if (rc < 0)
 				return rc;
 			msleep(100);
-			rc=tm6000_set_reg (dev, REQ_03_SET_GET_MCU_PIN,
+			rc = tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
 						TM6000_GPIO_CLK, 1);
 			msleep(100);
 			break;
 		}
 	}
-	return (rc);
+	return rc;
 }
 
 int tm6000_cards_setup(struct tm6000_core *dev)
@@ -437,28 +437,28 @@ int tm6000_cards_setup(struct tm6000_core *dev)
 	return 0;
 };
 
-static void tm6000_config_tuner (struct tm6000_core *dev)
+static void tm6000_config_tuner(struct tm6000_core *dev)
 {
-	struct tuner_setup           tun_setup;
+	struct tuner_setup tun_setup;
 
 	/* Load tuner module */
 	v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap,
-		"tuner", "tuner",dev->tuner_addr, NULL);
+		"tuner", "tuner", dev->tuner_addr, NULL);
 
 	memset(&tun_setup, 0, sizeof(tun_setup));
-	tun_setup.type   = dev->tuner_type;
-	tun_setup.addr   = dev->tuner_addr;
+	tun_setup.type = dev->tuner_type;
+	tun_setup.addr = dev->tuner_addr;
 	tun_setup.mode_mask = T_ANALOG_TV | T_RADIO | T_DIGITAL_TV;
 	tun_setup.tuner_callback = tm6000_tuner_callback;
 
 	v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_type_addr, &tun_setup);
 
 	if (dev->tuner_type == TUNER_XC2028) {
-		struct v4l2_priv_tun_config  xc2028_cfg;
-		struct xc2028_ctrl           ctl;
+		struct v4l2_priv_tun_config xc2028_cfg;
+		struct xc2028_ctrl ctl;
 
 		memset(&xc2028_cfg, 0, sizeof(xc2028_cfg));
-		memset (&ctl,0,sizeof(ctl));
+		memset(&ctl, 0, sizeof(ctl));
 
 		ctl.input1 = 1;
 		ctl.read_not_reliable = 0;
@@ -469,7 +469,7 @@ static void tm6000_config_tuner (struct tm6000_core *dev)
 		xc2028_cfg.tuner = TUNER_XC2028;
 		xc2028_cfg.priv  = &ctl;
 
-		switch(dev->model) {
+		switch (dev->model) {
 		case TM6010_BOARD_HAUPPAUGE_900H:
 		case TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE:
 		case TM6010_BOARD_TWINHAN_TU501:
@@ -509,8 +509,8 @@ static int tm6000_init_dev(struct tm6000_core *dev)
 	dev->caps = tm6000_boards[dev->model].caps;
 
 	/* initialize hardware */
-	rc=tm6000_init (dev);
-	if (rc<0)
+	rc = tm6000_init(dev);
+	if (rc < 0)
 		goto err;
 
 	rc = v4l2_device_register(&dev->udev->dev, &dev->v4l2_dev);
@@ -518,8 +518,8 @@ static int tm6000_init_dev(struct tm6000_core *dev)
 		goto err;
 
 	/* register i2c bus */
-	rc=tm6000_i2c_register(dev);
-	if (rc<0)
+	rc = tm6000_i2c_register(dev);
+	if (rc < 0)
 		goto err;
 
 	/* Default values for STD and resolutions */
@@ -528,7 +528,7 @@ static int tm6000_init_dev(struct tm6000_core *dev)
 	dev->norm = V4L2_STD_PAL_M;
 
 	/* Configure tuner */
-	tm6000_config_tuner (dev);
+	tm6000_config_tuner(dev);
 
 	/* Set video standard */
 	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_std, dev->norm);
@@ -545,20 +545,20 @@ static int tm6000_init_dev(struct tm6000_core *dev)
 			"tvaudio", "tvaudio", I2C_ADDR_TDA9874, NULL);
 
 	/* register and initialize V4L2 */
-	rc=tm6000_v4l2_register(dev);
-	if (rc<0)
+	rc = tm6000_v4l2_register(dev);
+	if (rc < 0)
 		goto err;
 
-	if(dev->caps.has_dvb) {
+	if (dev->caps.has_dvb) {
 		dev->dvb = kzalloc(sizeof(*(dev->dvb)), GFP_KERNEL);
-		if(!dev->dvb) {
+		if (!dev->dvb) {
 			rc = -ENOMEM;
 			goto err2;
 		}
 
 #ifdef CONFIG_VIDEO_TM6000_DVB
 		rc = tm6000_dvb_register(dev);
-		if(rc < 0) {
+		if (rc < 0) {
 			kfree(dev->dvb);
 			dev->dvb = NULL;
 			goto err2;
@@ -579,24 +579,23 @@ err:
 /* high bandwidth multiplier, as encoded in highspeed endpoint descriptors */
 #define hb_mult(wMaxPacketSize) (1 + (((wMaxPacketSize) >> 11) & 0x03))
 
-static void get_max_endpoint (  struct usb_device *usbdev,
+static void get_max_endpoint (struct usb_device *usbdev,
 				char *msgtype,
 				struct usb_host_endpoint *curr_e,
 				unsigned int *maxsize,
-				struct usb_host_endpoint **ep  )
+				struct usb_host_endpoint **ep)
 {
 	u16 tmp = le16_to_cpu(curr_e->desc.wMaxPacketSize);
 	unsigned int size = tmp & 0x7ff;
 
 	if (usbdev->speed == USB_SPEED_HIGH)
-		size = size * hb_mult (tmp);
+		size = size * hb_mult(tmp);
 
-	if (size>*maxsize) {
+	if (size > *maxsize) {
 		*ep = curr_e;
 		*maxsize = size;
-		printk("tm6000: %s endpoint: 0x%02x (max size=%u bytes)\n",
-					msgtype, curr_e->desc.bEndpointAddress,
-					size);
+		printk(KERN_INFO "tm6000: %s endpoint: 0x%02x (max size=%u bytes)\n",
+			msgtype, curr_e->desc.bEndpointAddress, size);
 	}
 }
 
@@ -609,22 +608,21 @@ static int tm6000_usb_probe(struct usb_interface *interface,
 {
 	struct usb_device *usbdev;
 	struct tm6000_core *dev = NULL;
-	int i,rc=0;
-	int nr=0;
+	int i, rc = 0;
+	int nr = 0;
 	char *speed;
 
-
-	usbdev=usb_get_dev(interface_to_usbdev(interface));
+	usbdev = usb_get_dev(interface_to_usbdev(interface));
 
 	/* Selects the proper interface */
-	rc=usb_set_interface(usbdev,0,1);
-	if (rc<0)
+	rc = usb_set_interface(usbdev, 0, 1);
+	if (rc < 0)
 		goto err;
 
 	/* Check to see next free device and mark as used */
-	nr=find_first_zero_bit(&tm6000_devused,TM6000_MAXBOARDS);
+	nr = find_first_zero_bit(&tm6000_devused, TM6000_MAXBOARDS);
 	if (nr >= TM6000_MAXBOARDS) {
-		printk ("tm6000: Supports only %i tm60xx boards.\n",TM6000_MAXBOARDS);
+		printk(KERN_ERR "tm6000: Supports only %i tm60xx boards.\n", TM6000_MAXBOARDS);
 		usb_put_dev(usbdev);
 		return -ENOMEM;
 	}
@@ -632,23 +630,22 @@ static int tm6000_usb_probe(struct usb_interface *interface,
 	/* Create and initialize dev struct */
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 	if (dev == NULL) {
-		printk ("tm6000" ": out of memory!\n");
+		printk(KERN_ERR "tm6000" ": out of memory!\n");
 		usb_put_dev(usbdev);
 		return -ENOMEM;
 	}
 	spin_lock_init(&dev->slock);
 
 	/* Increment usage count */
-	tm6000_devused|=1<<nr;
+	tm6000_devused |= 1<<nr;
 	snprintf(dev->name, 29, "tm6000 #%d", nr);
 
-	dev->model=id->driver_info;
-	if ((card[nr]>=0) && (card[nr]<ARRAY_SIZE(tm6000_boards))) {
-		dev->model=card[nr];
-	}
+	dev->model = id->driver_info;
+	if ((card[nr] >= 0) && (card[nr] < ARRAY_SIZE(tm6000_boards)))
+		dev->model = card[nr];
 
-	dev->udev= usbdev;
-	dev->devno=nr;
+	dev->udev = usbdev;
+	dev->devno = nr;
 
 	switch (usbdev->speed) {
 	case USB_SPEED_LOW:
@@ -680,7 +677,7 @@ static int tm6000_usb_probe(struct usb_interface *interface,
 			dir_out = ((e->desc.bEndpointAddress &
 					USB_ENDPOINT_DIR_MASK) == USB_DIR_OUT);
 
-			printk("tm6000: alt %d, interface %i, class %i\n",
+			printk(KERN_INFO "tm6000: alt %d, interface %i, class %i\n",
 			       i,
 			       interface->altsetting[i].desc.bInterfaceNumber,
 			       interface->altsetting[i].desc.bInterfaceClass);
@@ -713,7 +710,7 @@ static int tm6000_usb_probe(struct usb_interface *interface,
 	}
 
 
-	printk("tm6000: New video device @ %s Mbps (%04x:%04x, ifnum %d)\n",
+	printk(KERN_INFO "tm6000: New video device @ %s Mbps (%04x:%04x, ifnum %d)\n",
 		speed,
 		le16_to_cpu(dev->udev->descriptor.idVendor),
 		le16_to_cpu(dev->udev->descriptor.idProduct),
@@ -721,8 +718,8 @@ static int tm6000_usb_probe(struct usb_interface *interface,
 
 /* check if the the device has the iso in endpoint at the correct place */
 	if (!dev->isoc_in) {
-		printk("tm6000: probing error: no IN ISOC endpoint!\n");
-		rc= -ENODEV;
+		printk(KERN_ERR"tm6000: probing error: no IN ISOC endpoint!\n");
+		rc = -ENODEV;
 
 		goto err;
 	}
@@ -730,19 +727,19 @@ static int tm6000_usb_probe(struct usb_interface *interface,
 	/* save our data pointer in this interface device */
 	usb_set_intfdata(interface, dev);
 
-	printk("tm6000: Found %s\n", tm6000_boards[dev->model].name);
+	printk(KERN_INFO "tm6000: Found %s\n", tm6000_boards[dev->model].name);
 
-	rc=tm6000_init_dev(dev);
+	rc = tm6000_init_dev(dev);
 
-	if (rc<0)
+	if (rc < 0)
 		goto err;
 
 	return 0;
 
 err:
-	printk("tm6000: Error %d while registering\n", rc);
+	printk(KERN_ERR "tm6000: Error %d while registering\n", rc);
 
-	tm6000_devused&=~(1<<nr);
+	tm6000_devused &= ~(1<<nr);
 	usb_put_dev(usbdev);
 
 	kfree(dev);
@@ -762,12 +759,12 @@ static void tm6000_usb_disconnect(struct usb_interface *interface)
 	if (!dev)
 		return;
 
-	printk("tm6000: disconnecting %s\n", dev->name);
+	printk(KERN_INFO "tm6000: disconnecting %s\n", dev->name);
 
 	mutex_lock(&dev->lock);
 
 #ifdef CONFIG_VIDEO_TM6000_DVB
-	if(dev->dvb) {
+	if (dev->dvb) {
 		tm6000_dvb_unregister(dev);
 		kfree(dev->dvb);
 	}
@@ -779,8 +776,6 @@ static void tm6000_usb_disconnect(struct usb_interface *interface)
 
 	v4l2_device_unregister(&dev->v4l2_dev);
 
-//	wake_up_interruptible_all(&dev->open);
-
 	dev->state |= DEV_DISCONNECTED;
 
 	usb_put_dev(dev->udev);
@@ -807,7 +802,7 @@ static int __init tm6000_module_init(void)
 	/* register this driver with the USB subsystem */
 	result = usb_register(&tm6000_usb_driver);
 	if (result)
-		printk("tm6000"
+		printk(KERN_ERR "tm6000"
 			   " usb_register failed. Error number %d.\n", result);
 
 	return result;
-- 
1.6.3.3

