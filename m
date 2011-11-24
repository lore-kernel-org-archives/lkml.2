Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007Ab1KXNVk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 08:21:40 -0500
Received: from damascus.uab.es ([158.109.168.135]:23322 "EHLO damascus.uab.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753024Ab1KXNVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 08:21:39 -0500
Date: Thu, 24 Nov 2011 16:23:44 +0100
From: Davidlohr Bueso <dave@gnu.org>
Subject: [PATCH] USB: remove BKL comments
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Message-id: <1322148224.6239.2.camel@offworld>
Organization: GNU
MIME-version: 1.0
X-Mailer: Evolution 3.0.3-2
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
X-Spam-Tests: ALL_TRUSTED=-1
X-imss-version: 2.054
X-imss-result: Passed
X-imss-scanInfo: M:P L:N SM:0
X-imss-tmaseResult: TT:0 TS:0.0000 TC:00 TRN:0 TV:6.5.1024(18538.007)
X-imss-scores: Clean:62.45850 C:2 M:3 S:5 R:5
X-imss-settings: Baseline:3 C:3 M:3 S:3 R:3 (0.5000 0.5000)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <dave@gnu.org>

The BKL is a gonner.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 drivers/usb/core/hub.c          |    1 -
 drivers/usb/misc/usbtest.c      |    1 -
 drivers/usb/serial/usb-serial.c |    2 --
 3 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 7978146..29d0669 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1360,7 +1360,6 @@ descriptor_error:
 	return -ENODEV;
 }
 
-/* No BKL needed */
 static int
 hub_ioctl(struct usb_interface *intf, unsigned int code, void *user_data)
 {
diff --git a/drivers/usb/misc/usbtest.c b/drivers/usb/misc/usbtest.c
index bd6d008..959145b 100644
--- a/drivers/usb/misc/usbtest.c
+++ b/drivers/usb/misc/usbtest.c
@@ -1765,7 +1765,6 @@ static int test_unaligned_bulk(
  * off just killing the userspace task and waiting for it to exit.
  */
 
-/* No BKL needed */
 static int
 usbtest_ioctl(struct usb_interface *intf, unsigned int code, void *buf)
 {
diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index cc274fd..3ed9e16 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -1336,7 +1336,6 @@ static void fixup_generic(struct usb_serial_driver *device)
 
 int usb_serial_register(struct usb_serial_driver *driver)
 {
-	/* must be called with BKL held */
 	int retval;
 
 	if (usb_disabled())
@@ -1374,7 +1373,6 @@ EXPORT_SYMBOL_GPL(usb_serial_register);
 
 void usb_serial_deregister(struct usb_serial_driver *device)
 {
-	/* must be called with BKL held */
 	printk(KERN_INFO "USB Serial deregistering driver %s\n",
 	       device->description);
 	mutex_lock(&table_lock);
-- 
1.7.7.3



