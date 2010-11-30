Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976Ab0K3VmL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 16:42:11 -0500
Received: from mail.perches.com ([173.55.12.10]:2033 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222Ab0K3VmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 16:42:10 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org
Subject: [PATCH 1/2] media: Remove unnecessary casts of usb_get_intfdata
Date: Tue, 30 Nov 2010 13:42:07 -0800
Message-Id: <ce546290dcd54062fa8cda575ab3d6e7d806c52f.1291153099.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.2.245.g03276.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/dvb/siano/smsusb.c |    9 +++------
 drivers/media/rc/imon.c          |    2 +-
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/media/dvb/siano/smsusb.c b/drivers/media/dvb/siano/smsusb.c
index 50d4338..0b8da57 100644
--- a/drivers/media/dvb/siano/smsusb.c
+++ b/drivers/media/dvb/siano/smsusb.c
@@ -288,8 +288,7 @@ static int smsusb1_setmode(void *context, int mode)
 
 static void smsusb_term_device(struct usb_interface *intf)
 {
-	struct smsusb_device_t *dev =
-		(struct smsusb_device_t *) usb_get_intfdata(intf);
+	struct smsusb_device_t *dev = usb_get_intfdata(intf);
 
 	if (dev) {
 		smsusb_stop_streaming(dev);
@@ -445,8 +444,7 @@ static void smsusb_disconnect(struct usb_interface *intf)
 
 static int smsusb_suspend(struct usb_interface *intf, pm_message_t msg)
 {
-	struct smsusb_device_t *dev =
-		(struct smsusb_device_t *)usb_get_intfdata(intf);
+	struct smsusb_device_t *dev = usb_get_intfdata(intf);
 	printk(KERN_INFO "%s: Entering status %d.\n", __func__, msg.event);
 	smsusb_stop_streaming(dev);
 	return 0;
@@ -455,8 +453,7 @@ static int smsusb_suspend(struct usb_interface *intf, pm_message_t msg)
 static int smsusb_resume(struct usb_interface *intf)
 {
 	int rc, i;
-	struct smsusb_device_t *dev =
-		(struct smsusb_device_t *)usb_get_intfdata(intf);
+	struct smsusb_device_t *dev = usb_get_intfdata(intf);
 	struct usb_device *udev = interface_to_usbdev(intf);
 
 	printk(KERN_INFO "%s: Entering.\n", __func__);
diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index de9dc0e..6811512 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -2274,7 +2274,7 @@ static int __devinit imon_probe(struct usb_interface *interface,
 	mutex_lock(&driver_lock);
 
 	first_if = usb_ifnum_to_if(usbdev, 0);
-	first_if_ctx = (struct imon_context *)usb_get_intfdata(first_if);
+	first_if_ctx = usb_get_intfdata(first_if);
 
 	if (ifnum == 0) {
 		ictx = imon_init_intf0(interface);
-- 
1.7.3.2.245.g03276.dirty

