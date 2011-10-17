Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741Ab1JQSbc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 14:31:32 -0400
Received: from smtp-out.google.com ([74.125.121.67]:34257 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176Ab1JQSay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 14:30:54 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:from:to:cc:subject:date:message-id:x-mailer:
	in-reply-to:references:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=bhk8UYQ4BlveWWuwrqcNx2A1A5cU9vI94wuvCKwsvjleE16oTtqsUa9AjQH40/2Ef
	pdMfF2AfXD0QQH1yGK+jw==
From: Michal Nazarewicz <mpn@google.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dave Young <hidave.darkstar@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCHv6 2/3] usb: gadget: rename usb_gadget_driver::speed to max_speed
Date: Mon, 17 Oct 2011 11:30:39 -0700
Message-Id: <40703198a0e750b4044d6c34bcc4974f05308b45.1318875728.git.mina86@mina86.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <cover.1318875728.git.mina86@mina86.com>
References: <cover.1318875728.git.mina86@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

This commit renames the “speed” field of the usb_gadget_driver
structure to “max_speed”.  This is so that to make it more
apparent that the field represents the maximum speed gadget
driver can support.

This also make the field look more like fields with the same
name in usb_gadget and usb_composite_driver structures.  All
of those represent the *maximal* speed given entity supports.

After this commit, there are the following fields in various
structures:
* usb_gadget::speed - the current connection speed,
* usb_gadget::max_speed - maximal speed UDC supports,
* usb_gadget_driver::max_speed - maximal speed gadget driver
  supports, and
* usb_composite_driver::max_speed - maximal speed composite
  gadget supports.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/usb/gadget/amd5536udc.c        |    2 +-
 drivers/usb/gadget/at91_udc.c          |    2 +-
 drivers/usb/gadget/ci13xxx_udc.c       |    2 +-
 drivers/usb/gadget/composite.c         |    8 ++++----
 drivers/usb/gadget/dbgp.c              |    2 +-
 drivers/usb/gadget/dummy_hcd.c         |   13 ++++++-------
 drivers/usb/gadget/fsl_qe_udc.c        |    6 +++---
 drivers/usb/gadget/fsl_udc_core.c      |    4 ++--
 drivers/usb/gadget/fusb300_udc.c       |    2 +-
 drivers/usb/gadget/goku_udc.c          |    2 +-
 drivers/usb/gadget/imx_udc.c           |    2 +-
 drivers/usb/gadget/inode.c             |    6 +++---
 drivers/usb/gadget/m66592-udc.c        |    2 +-
 drivers/usb/gadget/net2272.c           |    2 +-
 drivers/usb/gadget/net2280.c           |    2 +-
 drivers/usb/gadget/omap_udc.c          |    2 +-
 drivers/usb/gadget/pch_udc.c           |    2 +-
 drivers/usb/gadget/printer.c           |    2 +-
 drivers/usb/gadget/pxa25x_udc.c        |    2 +-
 drivers/usb/gadget/pxa27x_udc.c        |    2 +-
 drivers/usb/gadget/r8a66597-udc.c      |    2 +-
 drivers/usb/gadget/s3c-hsotg.c         |    4 ++--
 drivers/usb/gadget/s3c-hsudc.c         |    4 ++--
 drivers/usb/gadget/s3c2410_udc.c       |    4 ++--
 drivers/usb/musb/musb_gadget.c         |    2 +-
 drivers/usb/renesas_usbhs/mod_gadget.c |    2 +-
 include/linux/usb/gadget.h             |    4 ++--
 27 files changed, 44 insertions(+), 45 deletions(-)

diff --git a/drivers/usb/gadget/amd5536udc.c b/drivers/usb/gadget/amd5536udc.c
index 8b684b0..cd520f9 100644
--- a/drivers/usb/gadget/amd5536udc.c
+++ b/drivers/usb/gadget/amd5536udc.c
@@ -1968,7 +1968,7 @@ static int amd5536_start(struct usb_gadget_driver *driver,
 	u32 tmp;
 
 	if (!driver || !bind || !driver->setup
-			|| driver->speed != USB_SPEED_HIGH)
+			|| driver->max_speed != USB_SPEED_HIGH)
 		return -EINVAL;
 	if (!dev)
 		return -ENODEV;
diff --git a/drivers/usb/gadget/at91_udc.c b/drivers/usb/gadget/at91_udc.c
index 0059216..c87cb06 100644
--- a/drivers/usb/gadget/at91_udc.c
+++ b/drivers/usb/gadget/at91_udc.c
@@ -1643,7 +1643,7 @@ static int at91_start(struct usb_gadget_driver *driver,
 	unsigned long	flags;
 
 	if (!driver
-			|| driver->speed < USB_SPEED_FULL
+			|| driver->max_speed < USB_SPEED_FULL
 			|| !bind
 			|| !driver->setup) {
 		DBG("bad parameter.\n");
diff --git a/drivers/usb/gadget/ci13xxx_udc.c b/drivers/usb/gadget/ci13xxx_udc.c
index 36cfcc4..ce206aa 100644
--- a/drivers/usb/gadget/ci13xxx_udc.c
+++ b/drivers/usb/gadget/ci13xxx_udc.c
@@ -798,7 +798,7 @@ static ssize_t show_driver(struct device *dev, struct device_attribute *attr,
 	n += scnprintf(buf + n, PAGE_SIZE - n, "function  = %s\n",
 		       (driver->function ? driver->function : ""));
 	n += scnprintf(buf + n, PAGE_SIZE - n, "max speed = %d\n",
-		       driver->speed);
+		       driver->max_speed);
 
 	return n;
 }
diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index 805d68f..ebd3857 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -1543,9 +1543,9 @@ composite_resume(struct usb_gadget *gadget)
 
 static struct usb_gadget_driver composite_driver = {
 #ifdef CONFIG_USB_GADGET_SUPERSPEED
-	.speed		= USB_SPEED_SUPER,
+	.max_speed	= USB_SPEED_SUPER,
 #else
-	.speed		= USB_SPEED_HIGH,
+	.max_speed	= USB_SPEED_HIGH,
 #endif
 
 	.unbind		= composite_unbind,
@@ -1592,8 +1592,8 @@ int usb_composite_probe(struct usb_composite_driver *driver,
 		driver->iProduct = driver->name;
 	composite_driver.function =  (char *) driver->name;
 	composite_driver.driver.name = driver->name;
-	composite_driver.speed = min((u8)composite_driver.speed,
-				     (u8)driver->max_speed);
+	composite_driver.max_speed = min((u8)composite_driver.max_speed,
+					 (u8)driver->max_speed);
 	composite = driver;
 	composite_gadget_bind = bind;
 
diff --git a/drivers/usb/gadget/dbgp.c b/drivers/usb/gadget/dbgp.c
index 8beefdd..548f307 100644
--- a/drivers/usb/gadget/dbgp.c
+++ b/drivers/usb/gadget/dbgp.c
@@ -404,7 +404,7 @@ fail:
 
 static struct usb_gadget_driver dbgp_driver = {
 	.function = "dbgp",
-	.speed = USB_SPEED_HIGH,
+	.max_speed = USB_SPEED_HIGH,
 	.unbind = dbgp_unbind,
 	.setup = dbgp_setup,
 	.disconnect = dbgp_disconnect,
diff --git a/drivers/usb/gadget/dummy_hcd.c b/drivers/usb/gadget/dummy_hcd.c
index 03f074f..c0fefc5 100644
--- a/drivers/usb/gadget/dummy_hcd.c
+++ b/drivers/usb/gadget/dummy_hcd.c
@@ -832,19 +832,18 @@ static int dummy_pullup (struct usb_gadget *_gadget, int value)
 
 	if (value && dum->driver) {
 		if (mod_data.is_super_speed)
-			dum->gadget.speed = dum->driver->speed;
+			dum->gadget.speed = dum->driver->max_speed;
 		else if (mod_data.is_high_speed)
 			dum->gadget.speed = min_t(u8, USB_SPEED_HIGH,
-					dum->driver->speed);
+					dum->driver->max_speed);
 		else
 			dum->gadget.speed = USB_SPEED_FULL;
 		dummy_udc_udpate_ep0(dum);
 
-		if (dum->gadget.speed < dum->driver->speed)
+		if (dum->gadget.speed < dum->driver->max_speed)
 			dev_dbg(udc_dev(dum), "This device can perform faster"
-					" if you connect it to a %s port...\n",
-					(dum->driver->speed == USB_SPEED_SUPER ?
-					 "SuperSpeed" : "HighSpeed"));
+				" if you connect it to a %s port...\n",
+				usb_speed_string(dum->driver->max_speed));
 	}
 	dum_hcd = gadget_to_dummy_hcd(_gadget);
 
@@ -907,7 +906,7 @@ static int dummy_udc_start(struct usb_gadget *g,
 	struct dummy_hcd	*dum_hcd = gadget_to_dummy_hcd(g);
 	struct dummy		*dum = dum_hcd->dum;
 
-	if (driver->speed == USB_SPEED_UNKNOWN)
+	if (driver->max_speed == USB_SPEED_UNKNOWN)
 		return -EINVAL;
 
 	/*
diff --git a/drivers/usb/gadget/fsl_qe_udc.c b/drivers/usb/gadget/fsl_qe_udc.c
index 3bf872e..0487738 100644
--- a/drivers/usb/gadget/fsl_qe_udc.c
+++ b/drivers/usb/gadget/fsl_qe_udc.c
@@ -2336,8 +2336,8 @@ static int fsl_qe_start(struct usb_gadget_driver *driver,
 	if (!udc_controller)
 		return -ENODEV;
 
-	if (!driver || (driver->speed != USB_SPEED_FULL
-			&& driver->speed != USB_SPEED_HIGH)
+	if (!driver || (driver->max_speed != USB_SPEED_FULL
+			&& driver->max_speed != USB_SPEED_HIGH)
 			|| !bind || !driver->disconnect || !driver->setup)
 		return -EINVAL;
 
@@ -2351,7 +2351,7 @@ static int fsl_qe_start(struct usb_gadget_driver *driver,
 	/* hook up the driver */
 	udc_controller->driver = driver;
 	udc_controller->gadget.dev.driver = &driver->driver;
-	udc_controller->gadget.speed = (enum usb_device_speed)(driver->speed);
+	udc_controller->gadget.speed = driver->max_speed;
 	spin_unlock_irqrestore(&udc_controller->lock, flags);
 
 	retval = bind(&udc_controller->gadget);
diff --git a/drivers/usb/gadget/fsl_udc_core.c b/drivers/usb/gadget/fsl_udc_core.c
index f1fac0d..292dca0 100644
--- a/drivers/usb/gadget/fsl_udc_core.c
+++ b/drivers/usb/gadget/fsl_udc_core.c
@@ -1938,8 +1938,8 @@ static int fsl_start(struct usb_gadget_driver *driver,
 	if (!udc_controller)
 		return -ENODEV;
 
-	if (!driver || (driver->speed != USB_SPEED_FULL
-				&& driver->speed != USB_SPEED_HIGH)
+	if (!driver || (driver->max_speed != USB_SPEED_FULL
+				&& driver->max_speed != USB_SPEED_HIGH)
 			|| !bind || !driver->disconnect || !driver->setup)
 		return -EINVAL;
 
diff --git a/drivers/usb/gadget/fusb300_udc.c b/drivers/usb/gadget/fusb300_udc.c
index 235471e..dfa0800 100644
--- a/drivers/usb/gadget/fusb300_udc.c
+++ b/drivers/usb/gadget/fusb300_udc.c
@@ -1326,7 +1326,7 @@ static int fusb300_udc_start(struct usb_gadget_driver *driver,
 	int retval;
 
 	if (!driver
-			|| driver->speed < USB_SPEED_FULL
+			|| driver->max_speed < USB_SPEED_FULL
 			|| !bind
 			|| !driver->setup)
 		return -EINVAL;
diff --git a/drivers/usb/gadget/goku_udc.c b/drivers/usb/gadget/goku_udc.c
index ab9c924..5af70fcc 100644
--- a/drivers/usb/gadget/goku_udc.c
+++ b/drivers/usb/gadget/goku_udc.c
@@ -1357,7 +1357,7 @@ static int goku_start(struct usb_gadget_driver *driver,
 	int			retval;
 
 	if (!driver
-			|| driver->speed < USB_SPEED_FULL
+			|| driver->max_speed < USB_SPEED_FULL
 			|| !bind
 			|| !driver->disconnect
 			|| !driver->setup)
diff --git a/drivers/usb/gadget/imx_udc.c b/drivers/usb/gadget/imx_udc.c
index 692fd9b..27bd8dc 100644
--- a/drivers/usb/gadget/imx_udc.c
+++ b/drivers/usb/gadget/imx_udc.c
@@ -1336,7 +1336,7 @@ static int imx_udc_start(struct usb_gadget_driver *driver,
 	int retval;
 
 	if (!driver
-		|| driver->speed < USB_SPEED_FULL
+		|| driver->max_speed < USB_SPEED_FULL
 		|| !bind
 		|| !driver->disconnect
 		|| !driver->setup)
diff --git a/drivers/usb/gadget/inode.c b/drivers/usb/gadget/inode.c
index 1b24099..4bd48ea 100644
--- a/drivers/usb/gadget/inode.c
+++ b/drivers/usb/gadget/inode.c
@@ -1774,9 +1774,9 @@ gadgetfs_suspend (struct usb_gadget *gadget)
 
 static struct usb_gadget_driver gadgetfs_driver = {
 #ifdef	CONFIG_USB_GADGET_DUALSPEED
-	.speed		= USB_SPEED_HIGH,
+	.max_speed	= USB_SPEED_HIGH,
 #else
-	.speed		= USB_SPEED_FULL,
+	.max_speed	= USB_SPEED_FULL,
 #endif
 	.function	= (char *) driver_desc,
 	.unbind		= gadgetfs_unbind,
@@ -1800,7 +1800,7 @@ static int gadgetfs_probe (struct usb_gadget *gadget)
 }
 
 static struct usb_gadget_driver probe_driver = {
-	.speed		= USB_SPEED_HIGH,
+	.max_speed	= USB_SPEED_HIGH,
 	.unbind		= gadgetfs_nop,
 	.setup		= (void *)gadgetfs_nop,
 	.disconnect	= gadgetfs_nop,
diff --git a/drivers/usb/gadget/m66592-udc.c b/drivers/usb/gadget/m66592-udc.c
index fbdfca8..72dc3f1 100644
--- a/drivers/usb/gadget/m66592-udc.c
+++ b/drivers/usb/gadget/m66592-udc.c
@@ -1482,7 +1482,7 @@ static int m66592_start(struct usb_gadget_driver *driver,
 	int retval;
 
 	if (!driver
-			|| driver->speed != USB_SPEED_HIGH
+			|| driver->max_speed != USB_SPEED_HIGH
 			|| !bind
 			|| !driver->setup)
 		return -EINVAL;
diff --git a/drivers/usb/gadget/net2272.c b/drivers/usb/gadget/net2272.c
index 4dc4df6..1b19dd0 100644
--- a/drivers/usb/gadget/net2272.c
+++ b/drivers/usb/gadget/net2272.c
@@ -1459,7 +1459,7 @@ static int net2272_start(struct usb_gadget *_gadget,
 	unsigned i;
 
 	if (!driver || !driver->unbind || !driver->setup ||
-	    driver->speed != USB_SPEED_HIGH)
+	    driver->max_speed != USB_SPEED_HIGH)
 		return -EINVAL;
 
 	dev = container_of(_gadget, struct net2272, gadget);
diff --git a/drivers/usb/gadget/net2280.c b/drivers/usb/gadget/net2280.c
index a1c61e7..cc94c1e 100644
--- a/drivers/usb/gadget/net2280.c
+++ b/drivers/usb/gadget/net2280.c
@@ -1890,7 +1890,7 @@ static int net2280_start(struct usb_gadget *_gadget,
 	 * (dev->usb->xcvrdiag & FORCE_FULL_SPEED_MODE)
 	 * "must not be used in normal operation"
 	 */
-	if (!driver || driver->speed != USB_SPEED_HIGH
+	if (!driver || driver->max_speed != USB_SPEED_HIGH
 			|| !driver->setup)
 		return -EINVAL;
 
diff --git a/drivers/usb/gadget/omap_udc.c b/drivers/usb/gadget/omap_udc.c
index fff7e1c..848d737 100644
--- a/drivers/usb/gadget/omap_udc.c
+++ b/drivers/usb/gadget/omap_udc.c
@@ -2120,7 +2120,7 @@ static int omap_udc_start(struct usb_gadget_driver *driver,
 		return -ENODEV;
 	if (!driver
 			// FIXME if otg, check:  driver->is_otg
-			|| driver->speed < USB_SPEED_FULL
+			|| driver->max_speed < USB_SPEED_FULL
 			|| !bind || !driver->setup)
 		return -EINVAL;
 
diff --git a/drivers/usb/gadget/pch_udc.c b/drivers/usb/gadget/pch_udc.c
index d781540..1db6d0e 100644
--- a/drivers/usb/gadget/pch_udc.c
+++ b/drivers/usb/gadget/pch_udc.c
@@ -2701,7 +2701,7 @@ static int pch_udc_start(struct usb_gadget_driver *driver,
 	struct pch_udc_dev	*dev = pch_udc;
 	int			retval;
 
-	if (!driver || (driver->speed == USB_SPEED_UNKNOWN) || !bind ||
+	if (!driver || (driver->max_speed == USB_SPEED_UNKNOWN) || !bind ||
 	    !driver->setup || !driver->unbind || !driver->disconnect) {
 		dev_err(&dev->pdev->dev,
 			"%s: invalid driver parameter\n", __func__);
diff --git a/drivers/usb/gadget/printer.c b/drivers/usb/gadget/printer.c
index c39dd8c..2b9965b 100644
--- a/drivers/usb/gadget/printer.c
+++ b/drivers/usb/gadget/printer.c
@@ -1544,7 +1544,7 @@ fail:
 /*-------------------------------------------------------------------------*/
 
 static struct usb_gadget_driver printer_driver = {
-	.speed		= DEVSPEED,
+	.max_speed	= DEVSPEED,
 
 	.function	= (char *) driver_desc,
 	.unbind		= printer_unbind,
diff --git a/drivers/usb/gadget/pxa25x_udc.c b/drivers/usb/gadget/pxa25x_udc.c
index e4e59b4..dd3c3ae 100644
--- a/drivers/usb/gadget/pxa25x_udc.c
+++ b/drivers/usb/gadget/pxa25x_udc.c
@@ -1276,7 +1276,7 @@ static int pxa25x_start(struct usb_gadget_driver *driver,
 	int			retval;
 
 	if (!driver
-			|| driver->speed < USB_SPEED_FULL
+			|| driver->max_speed < USB_SPEED_FULL
 			|| !bind
 			|| !driver->disconnect
 			|| !driver->setup)
diff --git a/drivers/usb/gadget/pxa27x_udc.c b/drivers/usb/gadget/pxa27x_udc.c
index 85b68c7..e914d75 100644
--- a/drivers/usb/gadget/pxa27x_udc.c
+++ b/drivers/usb/gadget/pxa27x_udc.c
@@ -1817,7 +1817,7 @@ static int pxa27x_udc_start(struct usb_gadget_driver *driver,
 	struct pxa_udc *udc = the_controller;
 	int retval;
 
-	if (!driver || driver->speed < USB_SPEED_FULL || !bind
+	if (!driver || driver->max_speed < USB_SPEED_FULL || !bind
 			|| !driver->disconnect || !driver->setup)
 		return -EINVAL;
 	if (!udc)
diff --git a/drivers/usb/gadget/r8a66597-udc.c b/drivers/usb/gadget/r8a66597-udc.c
index 4227cda..6279d0d 100644
--- a/drivers/usb/gadget/r8a66597-udc.c
+++ b/drivers/usb/gadget/r8a66597-udc.c
@@ -1755,7 +1755,7 @@ static int r8a66597_start(struct usb_gadget *gadget,
 	int retval;
 
 	if (!driver
-			|| driver->speed != USB_SPEED_HIGH
+			|| driver->max_speed != USB_SPEED_HIGH
 			|| !driver->setup)
 		return -EINVAL;
 	if (!r8a66597)
diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
index 9311a20..da26309 100644
--- a/drivers/usb/gadget/s3c-hsotg.c
+++ b/drivers/usb/gadget/s3c-hsotg.c
@@ -2586,8 +2586,8 @@ static int s3c_hsotg_start(struct usb_gadget_driver *driver,
 		return -EINVAL;
 	}
 
-	if (driver->speed != USB_SPEED_HIGH &&
-	    driver->speed != USB_SPEED_FULL) {
+	if (driver->max_speed != USB_SPEED_HIGH &&
+	    driver->max_speed != USB_SPEED_FULL) {
 		dev_err(hsotg->dev, "%s: bad speed\n", __func__);
 	}
 
diff --git a/drivers/usb/gadget/s3c-hsudc.c b/drivers/usb/gadget/s3c-hsudc.c
index 3ac4241..6f1069c 100644
--- a/drivers/usb/gadget/s3c-hsudc.c
+++ b/drivers/usb/gadget/s3c-hsudc.c
@@ -1140,8 +1140,8 @@ static int s3c_hsudc_start(struct usb_gadget_driver *driver,
 	int ret;
 
 	if (!driver
-		|| (driver->speed != USB_SPEED_FULL &&
-			driver->speed != USB_SPEED_HIGH)
+		|| (driver->max_speed != USB_SPEED_FULL &&
+			driver->max_speed != USB_SPEED_HIGH)
 		|| !bind
 		|| !driver->unbind || !driver->disconnect || !driver->setup)
 		return -EINVAL;
diff --git a/drivers/usb/gadget/s3c2410_udc.c b/drivers/usb/gadget/s3c2410_udc.c
index 8d31848..5609a57 100644
--- a/drivers/usb/gadget/s3c2410_udc.c
+++ b/drivers/usb/gadget/s3c2410_udc.c
@@ -1693,9 +1693,9 @@ static int s3c2410_udc_start(struct usb_gadget_driver *driver,
 	if (udc->driver)
 		return -EBUSY;
 
-	if (!bind || !driver->setup || driver->speed < USB_SPEED_FULL) {
+	if (!bind || !driver->setup || driver->max_speed < USB_SPEED_FULL) {
 		printk(KERN_ERR "Invalid driver: bind %p setup %p speed %d\n",
-			bind, driver->setup, driver->speed);
+			bind, driver->setup, driver->max_speed);
 		return -EINVAL;
 	}
 #if defined(MODULE)
diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.c
index f174cf0..0244cd0 100644
--- a/drivers/usb/musb/musb_gadget.c
+++ b/drivers/usb/musb/musb_gadget.c
@@ -1886,7 +1886,7 @@ static int musb_gadget_start(struct usb_gadget *g,
 	unsigned long		flags;
 	int			retval = -EINVAL;
 
-	if (driver->speed != USB_SPEED_HIGH)
+	if (driver->max_speed != USB_SPEED_HIGH)
 		goto err0;
 
 	pm_runtime_get_sync(musb->controller);
diff --git a/drivers/usb/renesas_usbhs/mod_gadget.c b/drivers/usb/renesas_usbhs/mod_gadget.c
index cad38b1..400b744 100644
--- a/drivers/usb/renesas_usbhs/mod_gadget.c
+++ b/drivers/usb/renesas_usbhs/mod_gadget.c
@@ -750,7 +750,7 @@ static int usbhsg_gadget_start(struct usb_gadget *gadget,
 
 	if (!driver		||
 	    !driver->setup	||
-	    driver->speed != USB_SPEED_HIGH)
+	    driver->max_speed != USB_SPEED_HIGH)
 		return -EINVAL;
 
 	dev  = usbhsg_gpriv_to_dev(gpriv);
diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
index 98dc306..317d892 100644
--- a/include/linux/usb/gadget.h
+++ b/include/linux/usb/gadget.h
@@ -760,7 +760,7 @@ static inline int usb_gadget_disconnect(struct usb_gadget *gadget)
 /**
  * struct usb_gadget_driver - driver for usb 'slave' devices
  * @function: String describing the gadget's function
- * @speed: Highest speed the driver handles.
+ * @max_speed: Highest speed the driver handles.
  * @setup: Invoked for ep0 control requests that aren't handled by
  *	the hardware level driver. Most calls must be handled by
  *	the gadget driver, including descriptor and configuration
@@ -824,7 +824,7 @@ static inline int usb_gadget_disconnect(struct usb_gadget *gadget)
  */
 struct usb_gadget_driver {
 	char			*function;
-	enum usb_device_speed	speed;
+	enum usb_device_speed	max_speed;
 	void			(*unbind)(struct usb_gadget *);
 	int			(*setup)(struct usb_gadget *,
 					const struct usb_ctrlrequest *);
-- 
1.7.3.1

