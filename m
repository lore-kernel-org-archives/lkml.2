Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743Ab1F2Mf3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 08:35:29 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:39322 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755373Ab1F2Mf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 08:35:26 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6391"; a="100581365"
From: Tatyana Brokhman <tlinder@codeaurora.org>
To: balbi@ti.com
Cc: greg@kroah.com, linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        ablay@codeaurora.org, Tatyana Brokhman <tlinder@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 1/2] usb: gadget: add max_speed to usb_composite_driver
Date: Wed, 29 Jun 2011 15:34:55 +0300
Message-Id: <1309350899-23868-2-git-send-email-tlinder@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1309350899-23868-1-git-send-email-tlinder@codeaurora.org>
References: <1309350899-23868-1-git-send-email-tlinder@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This field is used by the Gadget drivers to specify
the maximum speed they support, meaning: the maximum
speed they can provide descriptors for.

The driver speed will be set in consideration of this
value.

Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

---
 drivers/usb/gadget/audio.c        |    1 +
 drivers/usb/gadget/cdc2.c         |    1 +
 drivers/usb/gadget/composite.c    |    2 ++
 drivers/usb/gadget/ether.c        |    1 +
 drivers/usb/gadget/g_ffs.c        |    1 +
 drivers/usb/gadget/hid.c          |    1 +
 drivers/usb/gadget/mass_storage.c |    1 +
 drivers/usb/gadget/multi.c        |    1 +
 drivers/usb/gadget/ncm.c          |    1 +
 drivers/usb/gadget/nokia.c        |    1 +
 drivers/usb/gadget/serial.c       |    1 +
 drivers/usb/gadget/webcam.c       |    1 +
 drivers/usb/gadget/zero.c         |    1 +
 include/linux/usb/composite.h     |    2 ++
 14 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/gadget/audio.c b/drivers/usb/gadget/audio.c
index 93b999e..9d89ae47 100644
--- a/drivers/usb/gadget/audio.c
+++ b/drivers/usb/gadget/audio.c
@@ -165,6 +165,7 @@ static struct usb_composite_driver audio_driver = {
 	.name		= "g_audio",
 	.dev		= &device_desc,
 	.strings	= audio_strings,
+	.max_speed	= USB_SPEED_HIGH,
 	.unbind		= __exit_p(audio_unbind),
 };
 
diff --git a/drivers/usb/gadget/cdc2.c b/drivers/usb/gadget/cdc2.c
index 2720ab0..b1c1afb 100644
--- a/drivers/usb/gadget/cdc2.c
+++ b/drivers/usb/gadget/cdc2.c
@@ -244,6 +244,7 @@ static struct usb_composite_driver cdc_driver = {
 	.name		= "g_cdc",
 	.dev		= &device_desc,
 	.strings	= dev_strings,
+	.max_speed	= USB_SPEED_HIGH,
 	.unbind		= __exit_p(cdc_unbind),
 };
 
diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index ed8a70f..0009916 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -1386,6 +1386,8 @@ int usb_composite_probe(struct usb_composite_driver *driver,
 		driver->iProduct = driver->name;
 	composite_driver.function =  (char *) driver->name;
 	composite_driver.driver.name = driver->name;
+	composite_driver.speed = min_t(u8, composite_driver.speed,
+				       driver->max_speed);
 	composite = driver;
 	composite_gadget_bind = bind;
 
diff --git a/drivers/usb/gadget/ether.c b/drivers/usb/gadget/ether.c
index 1690c9d..ac41858 100644
--- a/drivers/usb/gadget/ether.c
+++ b/drivers/usb/gadget/ether.c
@@ -401,6 +401,7 @@ static struct usb_composite_driver eth_driver = {
 	.name		= "g_ether",
 	.dev		= &device_desc,
 	.strings	= dev_strings,
+	.max_speed	= USB_SPEED_HIGH,
 	.unbind		= __exit_p(eth_unbind),
 };
 
diff --git a/drivers/usb/gadget/g_ffs.c b/drivers/usb/gadget/g_ffs.c
index ebf6970..704c280 100644
--- a/drivers/usb/gadget/g_ffs.c
+++ b/drivers/usb/gadget/g_ffs.c
@@ -162,6 +162,7 @@ static struct usb_composite_driver gfs_driver = {
 	.name		= DRIVER_NAME,
 	.dev		= &gfs_dev_desc,
 	.strings	= gfs_dev_strings,
+	.max_speed	= USB_SPEED_HIGH,
 	.unbind		= gfs_unbind,
 	.iProduct	= DRIVER_DESC,
 };
diff --git a/drivers/usb/gadget/hid.c b/drivers/usb/gadget/hid.c
index 2523e54..9fb5750 100644
--- a/drivers/usb/gadget/hid.c
+++ b/drivers/usb/gadget/hid.c
@@ -255,6 +255,7 @@ static struct usb_composite_driver hidg_driver = {
 	.name		= "g_hid",
 	.dev		= &device_desc,
 	.strings	= dev_strings,
+	.max_speed	= USB_SPEED_HIGH,
 	.unbind		= __exit_p(hid_unbind),
 };
 
diff --git a/drivers/usb/gadget/mass_storage.c b/drivers/usb/gadget/mass_storage.c
index 0182242..d3eb274 100644
--- a/drivers/usb/gadget/mass_storage.c
+++ b/drivers/usb/gadget/mass_storage.c
@@ -169,6 +169,7 @@ static struct usb_composite_driver msg_driver = {
 	.name		= "g_mass_storage",
 	.dev		= &msg_device_desc,
 	.iProduct	= DRIVER_DESC,
+	.max_speed	= USB_SPEED_HIGH,
 	.needs_serial	= 1,
 };
 
diff --git a/drivers/usb/gadget/multi.c b/drivers/usb/gadget/multi.c
index d9feced..8c7b747 100644
--- a/drivers/usb/gadget/multi.c
+++ b/drivers/usb/gadget/multi.c
@@ -351,6 +351,7 @@ static struct usb_composite_driver multi_driver = {
 	.name		= "g_multi",
 	.dev		= &device_desc,
 	.strings	= dev_strings,
+	.max_speed	= USB_SPEED_HIGH,
 	.unbind		= __exit_p(multi_unbind),
 	.iProduct	= DRIVER_DESC,
 	.needs_serial	= 1,
diff --git a/drivers/usb/gadget/ncm.c b/drivers/usb/gadget/ncm.c
index 99c179a..62ee508 100644
--- a/drivers/usb/gadget/ncm.c
+++ b/drivers/usb/gadget/ncm.c
@@ -228,6 +228,7 @@ static struct usb_composite_driver ncm_driver = {
 	.name		= "g_ncm",
 	.dev		= &device_desc,
 	.strings	= dev_strings,
+	.max_speed	= USB_SPEED_HIGH,
 	.unbind		= __exit_p(gncm_unbind),
 };
 
diff --git a/drivers/usb/gadget/nokia.c b/drivers/usb/gadget/nokia.c
index 55ca63a..c7fb772 100644
--- a/drivers/usb/gadget/nokia.c
+++ b/drivers/usb/gadget/nokia.c
@@ -241,6 +241,7 @@ static struct usb_composite_driver nokia_driver = {
 	.name		= "g_nokia",
 	.dev		= &device_desc,
 	.strings	= dev_strings,
+	.max_speed	= USB_SPEED_HIGH,
 	.unbind		= __exit_p(nokia_unbind),
 };
 
diff --git a/drivers/usb/gadget/serial.c b/drivers/usb/gadget/serial.c
index 1ac57a9..ed1b816 100644
--- a/drivers/usb/gadget/serial.c
+++ b/drivers/usb/gadget/serial.c
@@ -242,6 +242,7 @@ static struct usb_composite_driver gserial_driver = {
 	.name		= "g_serial",
 	.dev		= &device_desc,
 	.strings	= dev_strings,
+	.max_speed	= USB_SPEED_HIGH,
 };
 
 static int __init init(void)
diff --git a/drivers/usb/gadget/webcam.c b/drivers/usb/gadget/webcam.c
index a5a0fdb..df6882d 100644
--- a/drivers/usb/gadget/webcam.c
+++ b/drivers/usb/gadget/webcam.c
@@ -373,6 +373,7 @@ static struct usb_composite_driver webcam_driver = {
 	.name		= "g_webcam",
 	.dev		= &webcam_device_descriptor,
 	.strings	= webcam_device_strings,
+	.max_speed	= USB_SPEED_HIGH,
 	.unbind		= webcam_unbind,
 };
 
diff --git a/drivers/usb/gadget/zero.c b/drivers/usb/gadget/zero.c
index 6d16db9..af7e7c3 100644
--- a/drivers/usb/gadget/zero.c
+++ b/drivers/usb/gadget/zero.c
@@ -340,6 +340,7 @@ static struct usb_composite_driver zero_driver = {
 	.name		= "zero",
 	.dev		= &device_desc,
 	.strings	= dev_strings,
+	.max_speed	= USB_SPEED_HIGH,
 	.unbind		= zero_unbind,
 	.suspend	= zero_suspend,
 	.resume		= zero_resume,
diff --git a/include/linux/usb/composite.h b/include/linux/usb/composite.h
index 99830d6..a3e72df 100644
--- a/include/linux/usb/composite.h
+++ b/include/linux/usb/composite.h
@@ -240,6 +240,7 @@ int usb_add_config(struct usb_composite_dev *,
  *	identifiers.
  * @strings: tables of strings, keyed by identifiers assigned during bind()
  *	and language IDs provided in control requests
+ * @max_speed: Highest speed the driver supports.
  * @needs_serial: set to 1 if the gadget needs userspace to provide
  * 	a serial number.  If one is not provided, warning will be printed.
  * @unbind: Reverses bind; called as a side effect of unregistering
@@ -267,6 +268,7 @@ struct usb_composite_driver {
 	const char				*iManufacturer;
 	const struct usb_device_descriptor	*dev;
 	struct usb_gadget_strings		**strings;
+	enum usb_device_speed			max_speed;
 	unsigned		needs_serial:1;
 
 	int			(*unbind)(struct usb_composite_dev *);
-- 
1.7.3.3

--
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
