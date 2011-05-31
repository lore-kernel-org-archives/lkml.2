Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228Ab1EaNUz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 09:20:55 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:5483 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755644Ab1EaNTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 09:19:19 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6362"; a="94584371"
From: Tatyana Brokhman <tlinder@codeaurora.org>
To: greg@kroah.com
Cc: linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org, balbi@ti.com,
        ablay@codeaurora.org, Tatyana Brokhman <tlinder@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v14 4/9] usb: Add max_speed to usb_composite_driver structure
Date: Tue, 31 May 2011 16:18:24 +0300
Message-Id: <1306847914-19876-5-git-send-email-tlinder@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1306847914-19876-1-git-send-email-tlinder@codeaurora.org>
References: <1306847914-19876-1-git-send-email-tlinder@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This field is used by the Gadget drivers to specify the maximum speed
they support, meaning: the maximum speed they can provide descriptors for.

The driver speed will be set in consideration of this value.

Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

---
 drivers/usb/gadget/audio.c        |    5 +++++
 drivers/usb/gadget/cdc2.c         |    5 +++++
 drivers/usb/gadget/composite.c    |    2 ++
 drivers/usb/gadget/ether.c        |    5 +++++
 drivers/usb/gadget/g_ffs.c        |    5 +++++
 drivers/usb/gadget/hid.c          |    5 +++++
 drivers/usb/gadget/mass_storage.c |    5 +++++
 drivers/usb/gadget/multi.c        |    5 +++++
 drivers/usb/gadget/ncm.c          |    5 +++++
 drivers/usb/gadget/nokia.c        |    5 +++++
 drivers/usb/gadget/serial.c       |    5 +++++
 drivers/usb/gadget/webcam.c       |    5 +++++
 drivers/usb/gadget/zero.c         |    5 +++++
 include/linux/usb/composite.h     |    2 ++
 14 files changed, 64 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/gadget/audio.c b/drivers/usb/gadget/audio.c
index 93b999e..0d7f0ae 100644
--- a/drivers/usb/gadget/audio.c
+++ b/drivers/usb/gadget/audio.c
@@ -165,6 +165,11 @@ static struct usb_composite_driver audio_driver = {
 	.name		= "g_audio",
 	.dev		= &device_desc,
 	.strings	= audio_strings,
+#ifdef CONFIG_USB_GADGET_DUALSPEED
+	.max_speed		= USB_SPEED_HIGH,
+#else
+	.max_speed		= USB_SPEED_FULL,
+#endif /* CONFIG_USB_GADGET_DUALSPEED */
 	.unbind		= __exit_p(audio_unbind),
 };
 
diff --git a/drivers/usb/gadget/cdc2.c b/drivers/usb/gadget/cdc2.c
index 2720ab0..6dda4ee 100644
--- a/drivers/usb/gadget/cdc2.c
+++ b/drivers/usb/gadget/cdc2.c
@@ -244,6 +244,11 @@ static struct usb_composite_driver cdc_driver = {
 	.name		= "g_cdc",
 	.dev		= &device_desc,
 	.strings	= dev_strings,
+#ifdef CONFIG_USB_GADGET_DUALSPEED
+	.max_speed	= USB_SPEED_HIGH,
+#else
+	.max_speed	= USB_SPEED_FULL,
+#endif /* CONFIG_USB_GADGET_DUALSPEED */
 	.unbind		= __exit_p(cdc_unbind),
 };
 
diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index 1c6bd66..15e9bc9 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -1378,6 +1378,8 @@ int usb_composite_probe(struct usb_composite_driver *driver,
 		driver->iProduct = driver->name;
 	composite_driver.function =  (char *) driver->name;
 	composite_driver.driver.name = driver->name;
+	composite_driver.speed = min((u8)composite_driver.speed,
+				     (u8)driver->max_speed);
 	composite = driver;
 	composite_gadget_bind = bind;
 
diff --git a/drivers/usb/gadget/ether.c b/drivers/usb/gadget/ether.c
index 1690c9d..fa7c5ab 100644
--- a/drivers/usb/gadget/ether.c
+++ b/drivers/usb/gadget/ether.c
@@ -401,6 +401,11 @@ static struct usb_composite_driver eth_driver = {
 	.name		= "g_ether",
 	.dev		= &device_desc,
 	.strings	= dev_strings,
+#ifdef CONFIG_USB_GADGET_DUALSPEED
+	.max_speed	= USB_SPEED_HIGH,
+#else
+	.max_speed	= USB_SPEED_FULL,
+#endif /* CONFIG_USB_GADGET_DUALSPEED */
 	.unbind		= __exit_p(eth_unbind),
 };
 
diff --git a/drivers/usb/gadget/g_ffs.c b/drivers/usb/gadget/g_ffs.c
index ebf6970..7b272c6 100644
--- a/drivers/usb/gadget/g_ffs.c
+++ b/drivers/usb/gadget/g_ffs.c
@@ -162,6 +162,11 @@ static struct usb_composite_driver gfs_driver = {
 	.name		= DRIVER_NAME,
 	.dev		= &gfs_dev_desc,
 	.strings	= gfs_dev_strings,
+#ifdef CONFIG_USB_GADGET_DUALSPEED
+	.max_speed	= USB_SPEED_HIGH,
+#else
+	.max_speed	= USB_SPEED_FULL,
+#endif /* CONFIG_USB_GADGET_DUALSPEED */
 	.unbind		= gfs_unbind,
 	.iProduct	= DRIVER_DESC,
 };
diff --git a/drivers/usb/gadget/hid.c b/drivers/usb/gadget/hid.c
index 2523e54..c6e133f 100644
--- a/drivers/usb/gadget/hid.c
+++ b/drivers/usb/gadget/hid.c
@@ -255,6 +255,11 @@ static struct usb_composite_driver hidg_driver = {
 	.name		= "g_hid",
 	.dev		= &device_desc,
 	.strings	= dev_strings,
+#ifdef CONFIG_USB_GADGET_DUALSPEED
+	.max_speed	= USB_SPEED_HIGH,
+#else
+	.max_speed	= USB_SPEED_FULL,
+#endif /* CONFIG_USB_GADGET_DUALSPEED */
 	.unbind		= __exit_p(hid_unbind),
 };
 
diff --git a/drivers/usb/gadget/mass_storage.c b/drivers/usb/gadget/mass_storage.c
index 0182242..b399195 100644
--- a/drivers/usb/gadget/mass_storage.c
+++ b/drivers/usb/gadget/mass_storage.c
@@ -169,6 +169,11 @@ static struct usb_composite_driver msg_driver = {
 	.name		= "g_mass_storage",
 	.dev		= &msg_device_desc,
 	.iProduct	= DRIVER_DESC,
+#ifdef CONFIG_USB_GADGET_DUALSPEED
+	.max_speed	= USB_SPEED_HIGH,
+#else
+	.max_speed	= USB_SPEED_FULL,
+#endif /* CONFIG_USB_GADGET_DUALSPEED */
 	.needs_serial	= 1,
 };
 
diff --git a/drivers/usb/gadget/multi.c b/drivers/usb/gadget/multi.c
index d9feced..b4a000e 100644
--- a/drivers/usb/gadget/multi.c
+++ b/drivers/usb/gadget/multi.c
@@ -351,6 +351,11 @@ static struct usb_composite_driver multi_driver = {
 	.name		= "g_multi",
 	.dev		= &device_desc,
 	.strings	= dev_strings,
+#ifdef CONFIG_USB_GADGET_DUALSPEED
+	.max_speed	= USB_SPEED_HIGH,
+#else
+	.max_speed	= USB_SPEED_FULL,
+#endif /* CONFIG_USB_GADGET_DUALSPEED */
 	.unbind		= __exit_p(multi_unbind),
 	.iProduct	= DRIVER_DESC,
 	.needs_serial	= 1,
diff --git a/drivers/usb/gadget/ncm.c b/drivers/usb/gadget/ncm.c
index 99c179a..8665a0e 100644
--- a/drivers/usb/gadget/ncm.c
+++ b/drivers/usb/gadget/ncm.c
@@ -228,6 +228,11 @@ static struct usb_composite_driver ncm_driver = {
 	.name		= "g_ncm",
 	.dev		= &device_desc,
 	.strings	= dev_strings,
+#ifdef CONFIG_USB_GADGET_DUALSPEED
+	.max_speed	= USB_SPEED_HIGH,
+#else
+	.max_speed	= USB_SPEED_FULL,
+#endif /* CONFIG_USB_GADGET_DUALSPEED */
 	.unbind		= __exit_p(gncm_unbind),
 };
 
diff --git a/drivers/usb/gadget/nokia.c b/drivers/usb/gadget/nokia.c
index 55ca63a..192d6dd 100644
--- a/drivers/usb/gadget/nokia.c
+++ b/drivers/usb/gadget/nokia.c
@@ -241,6 +241,11 @@ static struct usb_composite_driver nokia_driver = {
 	.name		= "g_nokia",
 	.dev		= &device_desc,
 	.strings	= dev_strings,
+#ifdef CONFIG_USB_GADGET_DUALSPEED
+	.max_speed	= USB_SPEED_HIGH,
+#else
+	.max_speed	= USB_SPEED_FULL,
+#endif /* CONFIG_USB_GADGET_DUALSPEED */
 	.unbind		= __exit_p(nokia_unbind),
 };
 
diff --git a/drivers/usb/gadget/serial.c b/drivers/usb/gadget/serial.c
index 1ac57a9..645b4f5 100644
--- a/drivers/usb/gadget/serial.c
+++ b/drivers/usb/gadget/serial.c
@@ -242,6 +242,11 @@ static struct usb_composite_driver gserial_driver = {
 	.name		= "g_serial",
 	.dev		= &device_desc,
 	.strings	= dev_strings,
+#ifdef CONFIG_USB_GADGET_DUALSPEED
+	.max_speed	= USB_SPEED_HIGH,
+#else
+	.max_speed	= USB_SPEED_FULL,
+#endif /* CONFIG_USB_GADGET_DUALSPEED */
 };
 
 static int __init init(void)
diff --git a/drivers/usb/gadget/webcam.c b/drivers/usb/gadget/webcam.c
index a5a0fdb..4533704 100644
--- a/drivers/usb/gadget/webcam.c
+++ b/drivers/usb/gadget/webcam.c
@@ -373,6 +373,11 @@ static struct usb_composite_driver webcam_driver = {
 	.name		= "g_webcam",
 	.dev		= &webcam_device_descriptor,
 	.strings	= webcam_device_strings,
+#ifdef CONFIG_USB_GADGET_DUALSPEED
+	.max_speed	= USB_SPEED_HIGH,
+#else
+	.max_speed	= USB_SPEED_FULL,
+#endif /* CONFIG_USB_GADGET_DUALSPEED */
 	.unbind		= webcam_unbind,
 };
 
diff --git a/drivers/usb/gadget/zero.c b/drivers/usb/gadget/zero.c
index 6d16db9..30abd95 100644
--- a/drivers/usb/gadget/zero.c
+++ b/drivers/usb/gadget/zero.c
@@ -340,6 +340,11 @@ static struct usb_composite_driver zero_driver = {
 	.name		= "zero",
 	.dev		= &device_desc,
 	.strings	= dev_strings,
+#ifdef CONFIG_USB_GADGET_DUALSPEED
+	.max_speed	= USB_SPEED_HIGH,
+#else
+	.max_speed	= USB_SPEED_FULL,
+#endif /* CONFIG_USB_GADGET_DUALSPEED */
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
