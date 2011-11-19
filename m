Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab1KSR15 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 12:27:57 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48930 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463Ab1KSR1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 12:27:54 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH 3/3] usb: gadget: rename usb_gadget_driver::speed to max_speed
Date: Sat, 19 Nov 2011 18:27:38 +0100
Message-Id: <cc474a48df8db0ec55a1baecac9708de46b8c151.1321719300.git.mina86@mina86.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <12833fb1f3db020248c582c1f947724056a34fe2.1321719300.git.mina86@mina86.com>
References: <12833fb1f3db020248c582c1f947724056a34fe2.1321719300.git.mina86@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/usb/gadget/amd5536udc.c        |    2 +-
 drivers/usb/gadget/at91_udc.c          |    2 +-
 drivers/usb/gadget/ci13xxx_udc.c       |    2 +-
 drivers/usb/gadget/composite.c         |    8 ++++----
 drivers/usb/gadget/dbgp.c              |    2 +-
 drivers/usb/gadget/dummy_hcd.c         |   13 ++++++-------
 drivers/usb/gadget/file_storage.c      |    2 +-
 drivers/usb/gadget/fsl_qe_udc.c        |    4 ++--
 drivers/usb/gadget/fsl_udc_core.c      |    2 +-
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
 drivers/usb/gadget/s3c-hsotg.c         |    2 +-
 drivers/usb/gadget/s3c-hsudc.c         |    2 +-
 drivers/usb/gadget/s3c2410_udc.c       |    4 ++--
 drivers/usb/musb/musb_gadget.c         |    2 +-
 drivers/usb/renesas_usbhs/mod_gadget.c |    2 +-
 include/linux/usb/gadget.h             |    4 ++--
 28 files changed, 41 insertions(+), 42 deletions(-)

diff --git a/drivers/usb/gadget/amd5536udc.c b/drivers/usb/gadget/amd5536udc.c
index e69cdbc..e9a2c5c 100644
--- a/drivers/usb/gadget/amd5536udc.c
+++ b/drivers/usb/gadget/amd5536udc.c
@@ -1959,7 +1959,7 @@ static int amd5536_start(struct usb_gadget_driver *driver,
 	u32 tmp;
 
 	if (!driver || !bind || !driver->setup
-			|| driver->speed < USB_SPEED_HIGH)
+			|| driver->max_speed < USB_SPEED_HIGH)
 		return -EINVAL;
 	if (!dev)
 		return -ENODEV;
diff --git a/drivers/usb/gadget/at91_udc.c b/drivers/usb/gadget/at91_udc.c
index 8efe0fa..ac41f71 100644
--- a/drivers/usb/gadget/at91_udc.c
+++ b/drivers/usb/gadget/at91_udc.c
@@ -1633,7 +1633,7 @@ static int at91_start(struct usb_gadget_driver *driver,
 	unsigned long	flags;
 
 	if (!driver
-			|| driver->speed < USB_SPEED_FULL
+			|| driver->max_speed < USB_SPEED_FULL
 			|| !bind
 			|| !driver->setup) {
 		DBG("bad parameter.\n");
diff --git a/drivers/usb/gadget/ci13xxx_udc.c b/drivers/usb/gadget/ci13xxx_udc.c
index 4347ecc..bd96ad9 100644
--- a/drivers/usb/gadget/ci13xxx_udc.c
+++ b/drivers/usb/gadget/ci13xxx_udc.c
@@ -801,7 +801,7 @@ static ssize_t show_driver(struct device *dev, struct device_attribute *attr,
 	n += scnprintf(buf + n, PAGE_SIZE - n, "function  = %s\n",
 		       (driver->function ? driver->function : ""));
 	n += scnprintf(buf + n, PAGE_SIZE - n, "max speed = %d\n",
-		       driver->speed);
+		       driver->max_speed);
 
 	return n;
 }
diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index f71b078..a95de6a 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -1535,9 +1535,9 @@ composite_resume(struct usb_gadget *gadget)
 
 static struct usb_gadget_driver composite_driver = {
 #ifdef CONFIG_USB_GADGET_SUPERSPEED
-	.speed		= USB_SPEED_SUPER,
+	.max_speed	= USB_SPEED_SUPER,
 #else
-	.speed		= USB_SPEED_HIGH,
+	.max_speed	= USB_SPEED_HIGH,
 #endif
 
 	.unbind		= composite_unbind,
@@ -1584,8 +1584,8 @@ int usb_composite_probe(struct usb_composite_driver *driver,
 		driver->iProduct = driver->name;
 	composite_driver.function =  (char *) driver->name;
 	composite_driver.driver.name = driver->name;
-	composite_driver.speed = min((u8)composite_driver.speed,
-				     (u8)driver->max_speed);
+	composite_driver.max_speed =
+		min_t(u8, composite_driver.max_speed, driver->max_speed);
 	composite = driver;
 	composite_gadget_bind = bind;
 
diff --git a/drivers/usb/gadget/dbgp.c b/drivers/usb/gadget/dbgp.c
index 6256420..19d7bb0 100644
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
index cf235d8..db815c2 100644
--- a/drivers/usb/gadget/dummy_hcd.c
+++ b/drivers/usb/gadget/dummy_hcd.c
@@ -823,19 +823,18 @@ static int dummy_pullup (struct usb_gadget *_gadget, int value)
 
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
 
@@ -898,7 +897,7 @@ static int dummy_udc_start(struct usb_gadget *g,
 	struct dummy_hcd	*dum_hcd = gadget_to_dummy_hcd(g);
 	struct dummy		*dum = dum_hcd->dum;
 
-	if (driver->speed == USB_SPEED_UNKNOWN)
+	if (driver->max_speed == USB_SPEED_UNKNOWN)
 		return -EINVAL;
 
 	/*
diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_storage.c
index 11b5196..17a7047 100644
--- a/drivers/usb/gadget/file_storage.c
+++ b/drivers/usb/gadget/file_storage.c
@@ -3584,7 +3584,7 @@ static void fsg_resume(struct usb_gadget *gadget)
 /*-------------------------------------------------------------------------*/
 
 static struct usb_gadget_driver		fsg_driver = {
-	.speed		= USB_SPEED_SUPER,
+	.max_speed	= USB_SPEED_SUPER,
 	.function	= (char *) fsg_string_product,
 	.unbind		= fsg_unbind,
 	.disconnect	= fsg_disconnect,
diff --git a/drivers/usb/gadget/fsl_qe_udc.c b/drivers/usb/gadget/fsl_qe_udc.c
index e00cf92..b7a1efe 100644
--- a/drivers/usb/gadget/fsl_qe_udc.c
+++ b/drivers/usb/gadget/fsl_qe_udc.c
@@ -2336,7 +2336,7 @@ static int fsl_qe_start(struct usb_gadget_driver *driver,
 	if (!udc_controller)
 		return -ENODEV;
 
-	if (!driver || driver->speed < USB_SPEED_FULL
+	if (!driver || driver->max_speed < USB_SPEED_FULL
 			|| !bind || !driver->disconnect || !driver->setup)
 		return -EINVAL;
 
@@ -2350,7 +2350,7 @@ static int fsl_qe_start(struct usb_gadget_driver *driver,
 	/* hook up the driver */
 	udc_controller->driver = driver;
 	udc_controller->gadget.dev.driver = &driver->driver;
-	udc_controller->gadget.speed = (enum usb_device_speed)(driver->speed);
+	udc_controller->gadget.speed = driver->max_speed;
 	spin_unlock_irqrestore(&udc_controller->lock, flags);
 
 	retval = bind(&udc_controller->gadget);
diff --git a/drivers/usb/gadget/fsl_udc_core.c b/drivers/usb/gadget/fsl_udc_core.c
index 77d6d22..efd76ac 100644
--- a/drivers/usb/gadget/fsl_udc_core.c
+++ b/drivers/usb/gadget/fsl_udc_core.c
@@ -1938,7 +1938,7 @@ static int fsl_start(struct usb_gadget_driver *driver,
 	if (!udc_controller)
 		return -ENODEV;
 
-	if (!driver || driver->speed < USB_SPEED_FULL
+	if (!driver || driver->max_speed < USB_SPEED_FULL
 			|| !bind || !driver->disconnect || !driver->setup)
 		return -EINVAL;
 
diff --git a/drivers/usb/gadget/fusb300_udc.c b/drivers/usb/gadget/fusb300_udc.c
index 6e32a60..5831cb4 100644
--- a/drivers/usb/gadget/fusb300_udc.c
+++ b/drivers/usb/gadget/fusb300_udc.c
@@ -1317,7 +1317,7 @@ static int fusb300_udc_start(struct usb_gadget_driver *driver,
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
index 2d978c0..8d1c75a 100644
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
index 6ccae27..9361251 100644
--- a/drivers/usb/gadget/inode.c
+++ b/drivers/usb/gadget/inode.c
@@ -1766,9 +1766,9 @@ gadgetfs_suspend (struct usb_gadget *gadget)
 
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
@@ -1792,7 +1792,7 @@ static int gadgetfs_probe (struct usb_gadget *gadget)
 }
 
 static struct usb_gadget_driver probe_driver = {
-	.speed		= USB_SPEED_HIGH,
+	.max_speed	= USB_SPEED_HIGH,
 	.unbind		= gadgetfs_nop,
 	.setup		= (void *)gadgetfs_nop,
 	.disconnect	= gadgetfs_nop,
diff --git a/drivers/usb/gadget/m66592-udc.c b/drivers/usb/gadget/m66592-udc.c
index a7692c2..3608b3b 100644
--- a/drivers/usb/gadget/m66592-udc.c
+++ b/drivers/usb/gadget/m66592-udc.c
@@ -1472,7 +1472,7 @@ static int m66592_start(struct usb_gadget_driver *driver,
 	int retval;
 
 	if (!driver
-			|| driver->speed < USB_SPEED_HIGH
+			|| driver->max_speed < USB_SPEED_HIGH
 			|| !bind
 			|| !driver->setup)
 		return -EINVAL;
diff --git a/drivers/usb/gadget/net2272.c b/drivers/usb/gadget/net2272.c
index d5050f4..4c81d54 100644
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
index 9ee36fd..cf1f364 100644
--- a/drivers/usb/gadget/net2280.c
+++ b/drivers/usb/gadget/net2280.c
@@ -1881,7 +1881,7 @@ static int net2280_start(struct usb_gadget *_gadget,
 	 * (dev->usb->xcvrdiag & FORCE_FULL_SPEED_MODE)
 	 * "must not be used in normal operation"
 	 */
-	if (!driver || driver->speed < USB_SPEED_HIGH
+	if (!driver || driver->max_speed < USB_SPEED_HIGH
 			|| !driver->setup)
 		return -EINVAL;
 
diff --git a/drivers/usb/gadget/omap_udc.c b/drivers/usb/gadget/omap_udc.c
index ed01a0f..7db5bbe 100644
--- a/drivers/usb/gadget/omap_udc.c
+++ b/drivers/usb/gadget/omap_udc.c
@@ -2110,7 +2110,7 @@ static int omap_udc_start(struct usb_gadget_driver *driver,
 		return -ENODEV;
 	if (!driver
 			// FIXME if otg, check:  driver->is_otg
-			|| driver->speed < USB_SPEED_FULL
+			|| driver->max_speed < USB_SPEED_FULL
 			|| !bind || !driver->setup)
 		return -EINVAL;
 
diff --git a/drivers/usb/gadget/pch_udc.c b/drivers/usb/gadget/pch_udc.c
index 7f97b4a..dd2313c 100644
--- a/drivers/usb/gadget/pch_udc.c
+++ b/drivers/usb/gadget/pch_udc.c
@@ -2693,7 +2693,7 @@ static int pch_udc_start(struct usb_gadget_driver *driver,
 	struct pch_udc_dev	*dev = pch_udc;
 	int			retval;
 
-	if (!driver || (driver->speed == USB_SPEED_UNKNOWN) || !bind ||
+	if (!driver || (driver->max_speed == USB_SPEED_UNKNOWN) || !bind ||
 	    !driver->setup || !driver->unbind || !driver->disconnect) {
 		dev_err(&dev->pdev->dev,
 			"%s: invalid driver parameter\n", __func__);
diff --git a/drivers/usb/gadget/printer.c b/drivers/usb/gadget/printer.c
index b74f49ac..d83134b 100644
--- a/drivers/usb/gadget/printer.c
+++ b/drivers/usb/gadget/printer.c
@@ -1535,7 +1535,7 @@ fail:
 /*-------------------------------------------------------------------------*/
 
 static struct usb_gadget_driver printer_driver = {
-	.speed		= DEVSPEED,
+	.max_speed	= DEVSPEED,
 
 	.function	= (char *) driver_desc,
 	.unbind		= printer_unbind,
diff --git a/drivers/usb/gadget/pxa25x_udc.c b/drivers/usb/gadget/pxa25x_udc.c
index c090a7e..dd47063 100644
--- a/drivers/usb/gadget/pxa25x_udc.c
+++ b/drivers/usb/gadget/pxa25x_udc.c
@@ -1264,7 +1264,7 @@ static int pxa25x_start(struct usb_gadget_driver *driver,
 	int			retval;
 
 	if (!driver
-			|| driver->speed < USB_SPEED_FULL
+			|| driver->max_speed < USB_SPEED_FULL
 			|| !bind
 			|| !driver->disconnect
 			|| !driver->setup)
diff --git a/drivers/usb/gadget/pxa27x_udc.c b/drivers/usb/gadget/pxa27x_udc.c
index 18b6b09..f4c44eb 100644
--- a/drivers/usb/gadget/pxa27x_udc.c
+++ b/drivers/usb/gadget/pxa27x_udc.c
@@ -1807,7 +1807,7 @@ static int pxa27x_udc_start(struct usb_gadget_driver *driver,
 	struct pxa_udc *udc = the_controller;
 	int retval;
 
-	if (!driver || driver->speed < USB_SPEED_FULL || !bind
+	if (!driver || driver->max_speed < USB_SPEED_FULL || !bind
 			|| !driver->disconnect || !driver->setup)
 		return -EINVAL;
 	if (!udc)
diff --git a/drivers/usb/gadget/r8a66597-udc.c b/drivers/usb/gadget/r8a66597-udc.c
index 3666d7c..f5b8d21 100644
--- a/drivers/usb/gadget/r8a66597-udc.c
+++ b/drivers/usb/gadget/r8a66597-udc.c
@@ -1746,7 +1746,7 @@ static int r8a66597_start(struct usb_gadget *gadget,
 	struct r8a66597 *r8a66597 = gadget_to_r8a66597(gadget);
 
 	if (!driver
-			|| driver->speed < USB_SPEED_HIGH
+			|| driver->max_speed < USB_SPEED_HIGH
 			|| !driver->setup)
 		return -EINVAL;
 	if (!r8a66597)
diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
index 6bc7ad8..d098c36 100644
--- a/drivers/usb/gadget/s3c-hsotg.c
+++ b/drivers/usb/gadget/s3c-hsotg.c
@@ -2586,7 +2586,7 @@ static int s3c_hsotg_start(struct usb_gadget_driver *driver,
 		return -EINVAL;
 	}
 
-	if (driver->speed < USB_SPEED_FULL)
+	if (driver->max_speed < USB_SPEED_FULL)
 		dev_err(hsotg->dev, "%s: bad speed\n", __func__);
 
 	if (!bind || !driver->setup) {
diff --git a/drivers/usb/gadget/s3c-hsudc.c b/drivers/usb/gadget/s3c-hsudc.c
index 09ea965..f398b85 100644
--- a/drivers/usb/gadget/s3c-hsudc.c
+++ b/drivers/usb/gadget/s3c-hsudc.c
@@ -1142,7 +1142,7 @@ static int s3c_hsudc_start(struct usb_gadget_driver *driver,
 	int ret;
 
 	if (!driver
-		|| driver->speed < USB_SPEED_FULL
+		|| driver->max_speed < USB_SPEED_FULL
 		|| !bind
 		|| !driver->unbind || !driver->disconnect || !driver->setup)
 		return -EINVAL;
diff --git a/drivers/usb/gadget/s3c2410_udc.c b/drivers/usb/gadget/s3c2410_udc.c
index b864377..4d860e9 100644
--- a/drivers/usb/gadget/s3c2410_udc.c
+++ b/drivers/usb/gadget/s3c2410_udc.c
@@ -1683,9 +1683,9 @@ static int s3c2410_udc_start(struct usb_gadget_driver *driver,
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
index 47a3d1e..3148461 100644
--- a/drivers/usb/musb/musb_gadget.c
+++ b/drivers/usb/musb/musb_gadget.c
@@ -1903,7 +1903,7 @@ static int musb_gadget_start(struct usb_gadget *g,
 	unsigned long		flags;
 	int			retval = -EINVAL;
 
-	if (driver->speed < USB_SPEED_HIGH)
+	if (driver->max_speed < USB_SPEED_HIGH)
 		goto err0;
 
 	pm_runtime_get_sync(musb->controller);
diff --git a/drivers/usb/renesas_usbhs/mod_gadget.c b/drivers/usb/renesas_usbhs/mod_gadget.c
index 53b5e80..f48d6f6c 100644
--- a/drivers/usb/renesas_usbhs/mod_gadget.c
+++ b/drivers/usb/renesas_usbhs/mod_gadget.c
@@ -757,7 +757,7 @@ static int usbhsg_gadget_start(struct usb_gadget *gadget,
 
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

