Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181Ab1HZNTw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 09:19:52 -0400
Received: from smtp-out.google.com ([74.125.121.67]:32765 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754979Ab1HZNSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 09:18:54 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:from:to:cc:subject:date:message-id:x-mailer:
	in-reply-to:references:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=VT6j/qBvqAAePmey3mstRGjlRx+D8dPZFQ9hg01pVOUd7w7jePoVkexwuXqlgiDME
	/TqHZMwvPHohiwigux4iw==
From: Michal Nazarewicz <mnazarewicz@google.com>
To: Alan Stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>
Cc: "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
        "Yang Rui Rui" <ruirui.r.yang@tieto.com>,
        "Dave Young" <hidave.darkstar@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCHv5 3/4] usb: gadget: rename usb_gadget_driver::speed to max_speed
Date: Fri, 26 Aug 2011 15:18:36 +0200
Message-Id: <00303915f94de28b1aa2cc711cb46aa503e07bff.1314364323.git.mina86@mina86.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <cover.1314364322.git.mina86@mina86.com>
References: <cover.1314364322.git.mina86@mina86.com>
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
---
 drivers/usb/gadget/amd5536udc.c        |    2 +-
 drivers/usb/gadget/at91_udc.c          |    2 +-
 drivers/usb/gadget/ci13xxx_udc.c       |    2 +-
 drivers/usb/gadget/composite.c         |    8 ++++----
 drivers/usb/gadget/dbgp.c              |    2 +-
 drivers/usb/gadget/dummy_hcd.c         |   13 ++++++-------
 drivers/usb/gadget/file_storage.c      |    4 ++--
 drivers/usb/gadget/fsl_qe_udc.c        |    6 +++---
 drivers/usb/gadget/fsl_udc_core.c      |    4 ++--
 drivers/usb/gadget/fusb300_udc.c       |    2 +-
 drivers/usb/gadget/gmidi.c             |    2 +-
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
 29 files changed, 47 insertions(+), 48 deletions(-)

diff --git a/drivers/usb/gadget/amd5536udc.c b/drivers/usb/gadget/amd5536udc.c
index 5a6a8a2..b028666 100644
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
index d01fa5b..cf7afee 100644
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
index 72e51ce..2b2ca39 100644
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
index b539d8f..13c5689 100644
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
index a1e3bba..eee9008 100644
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
diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_storage.c
index 4ac8084..3a50196 100644
--- a/drivers/usb/gadget/file_storage.c
+++ b/drivers/usb/gadget/file_storage.c
@@ -3555,9 +3555,9 @@ static void fsg_resume(struct usb_gadget *gadget)
 
 static struct usb_gadget_driver		fsg_driver = {
 #ifdef CONFIG_USB_GADGET_DUALSPEED
-	.speed		= USB_SPEED_HIGH,
+	.max_speed	= USB_SPEED_HIGH,
 #else
-	.speed		= USB_SPEED_FULL,
+	.max_speed	= USB_SPEED_FULL,
 #endif
 	.function	= (char *) fsg_string_product,
 	.unbind		= fsg_unbind,
diff --git a/drivers/usb/gadget/fsl_qe_udc.c b/drivers/usb/gadget/fsl_qe_udc.c
index 2a03e4d..98cd5df 100644
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
index c629e16..03ace77 100644
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
index 02abddb..ed05e0e 100644
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
diff --git a/drivers/usb/gadget/gmidi.c b/drivers/usb/gadget/gmidi.c
index 893b967..f1fe2bf 100644
--- a/drivers/usb/gadget/gmidi.c
+++ b/drivers/usb/gadget/gmidi.c
@@ -1282,7 +1282,7 @@ static void gmidi_resume(struct usb_gadget *gadget)
 
 
 static struct usb_gadget_driver gmidi_driver = {
-	.speed		= USB_SPEED_FULL,
+	.max_speed	= USB_SPEED_FULL,
 	.function	= (char *)longname,
 	.unbind		= gmidi_unbind,
 
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
index bf08bfc..30c761c 100644
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
index 0ed1023..8011993 100644
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
index 005165a..b9ffd5d 100644
--- a/drivers/usb/gadget/net2272.c
+++ b/drivers/usb/gadget/net2272.c
@@ -1461,7 +1461,7 @@ static int net2272_start(struct usb_gadget_driver *driver,
 	unsigned i;
 
 	if (!driver || !bind || !driver->unbind || !driver->setup ||
-	    driver->speed != USB_SPEED_HIGH)
+	    driver->max_speed != USB_SPEED_HIGH)
 		return -EINVAL;
 	if (!dev)
 		return -ENODEV;
diff --git a/drivers/usb/gadget/net2280.c b/drivers/usb/gadget/net2280.c
index f114375..53bcd4c 100644
--- a/drivers/usb/gadget/net2280.c
+++ b/drivers/usb/gadget/net2280.c
@@ -1892,7 +1892,7 @@ static int net2280_start(struct usb_gadget_driver *driver,
 	 * "must not be used in normal operation"
 	 */
 	if (!driver
-			|| driver->speed != USB_SPEED_HIGH
+			|| driver->max_speed != USB_SPEED_HIGH
 			|| !bind || !driver->setup)
 		return -EINVAL;
 	if (!dev)
diff --git a/drivers/usb/gadget/omap_udc.c b/drivers/usb/gadget/omap_udc.c
index 9bcc3d7..ac0aa49 100644
--- a/drivers/usb/gadget/omap_udc.c
+++ b/drivers/usb/gadget/omap_udc.c
@@ -2119,7 +2119,7 @@ static int omap_udc_start(struct usb_gadget_driver *driver,
 		return -ENODEV;
 	if (!driver
 			// FIXME if otg, check:  driver->is_otg
-			|| driver->speed < USB_SPEED_FULL
+			|| driver->max_speed < USB_SPEED_FULL
 			|| !bind || !driver->setup)
 		return -EINVAL;
 
diff --git a/drivers/usb/gadget/pch_udc.c b/drivers/usb/gadget/pch_udc.c
index d35ed3a..73817b4 100644
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
index 7862465..c841248 100644
--- a/drivers/usb/gadget/pxa25x_udc.c
+++ b/drivers/usb/gadget/pxa25x_udc.c
@@ -1274,7 +1274,7 @@ static int pxa25x_start(struct usb_gadget_driver *driver,
 	int			retval;
 
 	if (!driver
-			|| driver->speed < USB_SPEED_FULL
+			|| driver->max_speed < USB_SPEED_FULL
 			|| !bind
 			|| !driver->disconnect
 			|| !driver->setup)
diff --git a/drivers/usb/gadget/pxa27x_udc.c b/drivers/usb/gadget/pxa27x_udc.c
index d21455f..c1f4676 100644
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
index 8b1ad2a..f5417c9 100644
--- a/drivers/usb/gadget/r8a66597-udc.c
+++ b/drivers/usb/gadget/r8a66597-udc.c
@@ -1442,7 +1442,7 @@ static int r8a66597_start(struct usb_gadget_driver *driver,
 	int retval;
 
 	if (!driver
-			|| driver->speed != USB_SPEED_HIGH
+			|| driver->max_speed != USB_SPEED_HIGH
 			|| !bind
 			|| !driver->setup)
 		return -EINVAL;
diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
index bc41457..9fbe9da 100644
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
index d11ebc2..3ccb98b 100644
--- a/drivers/usb/gadget/s3c-hsudc.c
+++ b/drivers/usb/gadget/s3c-hsudc.c
@@ -1142,8 +1142,8 @@ static int s3c_hsudc_start(struct usb_gadget_driver *driver,
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
index 2572854..ad8ae8a 100644
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
index 4bd2bdd..9fe73d2 100644
--- a/drivers/usb/musb/musb_gadget.c
+++ b/drivers/usb/musb/musb_gadget.c
@@ -1884,7 +1884,7 @@ static int musb_gadget_start(struct usb_gadget *g,
 	unsigned long		flags;
 	int			retval = -EINVAL;
 
-	if (driver->speed != USB_SPEED_HIGH)
+	if (driver->max_speed != USB_SPEED_HIGH)
 		goto err0;
 
 	pm_runtime_get_sync(musb->controller);
diff --git a/drivers/usb/renesas_usbhs/mod_gadget.c b/drivers/usb/renesas_usbhs/mod_gadget.c
index a8ae54f..9c339a0 100644
--- a/drivers/usb/renesas_usbhs/mod_gadget.c
+++ b/drivers/usb/renesas_usbhs/mod_gadget.c
@@ -755,7 +755,7 @@ static int usbhsg_gadget_start(struct usb_gadget_driver *driver,
 	if (!bind		||
 	    !driver		||
 	    !driver->setup	||
-	    driver->speed != USB_SPEED_HIGH)
+	    driver->max_speed != USB_SPEED_HIGH)
 		return -EINVAL;
 
 	/*
diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
index 7eb2ec3..c8ea048 100644
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

