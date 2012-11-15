Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993490Ab2KOQ1w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 11:27:52 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:55886 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992633Ab2KOQ1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 11:27:50 -0500
Date: Thu, 15 Nov 2012 21:57:42 +0530
From: Arpith Easow Alexander <arpith99@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: abbotti@mev.co.uk, fmhess@users.sourceforge.net,
        hsweeten@visionengravers.com, dan.carpenter@oracle.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: comedi: drivers: replaced printk with dev_dbg
Message-ID: <20121115162740.GA10360@gmail.com>
References: <20121110070833.GA18391@gmail.com>
 <20121113195252.GA13648@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="OXfL5xGRrasGEqWY"
Content-Disposition: inline
In-Reply-To: <20121113195252.GA13648@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 13, 2012 at 11:52:52AM -0800, Greg KH wrote:
> On Sat, Nov 10, 2012 at 12:38:38PM +0530, Arpith Easow Alexander wrote:
> > This is a patch to the vmk80xx.c file that replaces the printk with dev_dbg.
> > This fixes the warnings found by the checkpatch.pl tool.
> > 
> > Signed-off-by: Arpith Easow Alexander <arpith99@gmail.com>
> > ---
> >  drivers/staging/comedi/drivers/vmk80xx.c |   30 ++++++++++++++++++------------
> >  1 file changed, 18 insertions(+), 12 deletions(-)
> > 
> > diff --git a/drivers/staging/comedi/drivers/vmk80xx.c b/drivers/staging/comedi/drivers/vmk80xx.c
> > index df277aa..6eb5361 100644
> > --- a/drivers/staging/comedi/drivers/vmk80xx.c
> > +++ b/drivers/staging/comedi/drivers/vmk80xx.c
> > @@ -131,10 +131,10 @@ static int dbgcm = 1;
> >  static int dbgcm;
> >  #endif
> >  
> > -#define dbgcm(fmt, arg...)                     \
> > +#define dbgcm(dev, fmt, arg...)                     \
> >  do {                                           \
> >  	if (dbgcm)                             \
> > -		printk(KERN_DEBUG fmt, ##arg); \
> > +		dev_dbg(dev, fmt, ##arg); \
> 
> So a macro called dbgcm tests a variable called dbgcm?  Gotta love c at
> times...
> 
> Just delete the macro, and the variable, and call dev_dbg() directly
> please.

Ok. Done. (Attached both changes).

Thanks,
Arpith

--OXfL5xGRrasGEqWY
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-Staging-comedi-drivers-replaced-printk-with-dev_dbg.patch"

>From 35a1768b938fc6ba231d1aaa2e2a74f7b5380962 Mon Sep 17 00:00:00 2001
From: Arpith Easow Alexander <arpith99@gmail.com>
Date: Sat, 10 Nov 2012 11:55:26 +0530
Subject: [PATCH 1/2] Staging: comedi: drivers: replaced printk with dev_dbg

This is a patch to the vmk80xx.c file that replaces the printk with dev_dbg.
This fixes the warnings found by the checkpatch.pl tool.

Signed-off-by: Arpith Easow Alexander <arpith99@gmail.com>
---
 drivers/staging/comedi/drivers/vmk80xx.c |   30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/comedi/drivers/vmk80xx.c b/drivers/staging/comedi/drivers/vmk80xx.c
index df277aa..6eb5361 100644
--- a/drivers/staging/comedi/drivers/vmk80xx.c
+++ b/drivers/staging/comedi/drivers/vmk80xx.c
@@ -131,10 +131,10 @@ static int dbgcm = 1;
 static int dbgcm;
 #endif
 
-#define dbgcm(fmt, arg...)                     \
+#define dbgcm(dev, fmt, arg...)                     \
 do {                                           \
 	if (dbgcm)                             \
-		printk(KERN_DEBUG fmt, ##arg); \
+		dev_dbg(dev, fmt, ##arg); \
 } while (0)
 
 enum vmk80xx_model {
@@ -213,8 +213,9 @@ static void vmk80xx_tx_callback(struct urb *urb)
 
 	if (stat && !(stat == -ENOENT
 		      || stat == -ECONNRESET || stat == -ESHUTDOWN))
-		dbgcm("comedi#: vmk80xx: %s - nonzero urb status (%d)\n",
-		      __func__, stat);
+		dbgcm(&(dev->udev->dev),
+			"comedi#: vmk80xx: %s - nonzero urb status (%d)\n",
+			__func__, stat);
 
 	if (!test_bit(TRANS_OUT_BUSY, &dev->flags))
 		return;
@@ -237,7 +238,8 @@ static void vmk80xx_rx_callback(struct urb *urb)
 	case -ESHUTDOWN:
 		break;
 	default:
-		dbgcm("comedi#: vmk80xx: %s - nonzero urb status (%d)\n",
+		dbgcm(&(dev->udev->dev),
+		      "comedi#: vmk80xx: %s - nonzero urb status (%d)\n",
 		      __func__, stat);
 		goto resubmit;
 	}
@@ -1371,14 +1373,16 @@ static int vmk80xx_usb_probe(struct usb_interface *intf,
 
 	if (dev->board.model == VMK8061_MODEL) {
 		vmk80xx_read_eeprom(dev, IC3_VERSION);
-		printk(KERN_INFO "comedi#: vmk80xx: %s\n", dev->fw.ic3_vers);
+		dev_dbg(&(dev->udev->dev),
+			"comedi#: vmk80xx: %s\n", dev->fw.ic3_vers);
 
 		if (vmk80xx_check_data_link(dev)) {
 			vmk80xx_read_eeprom(dev, IC6_VERSION);
-			printk(KERN_INFO "comedi#: vmk80xx: %s\n",
+			dev_dbg(&(dev->udev->dev), "comedi#: vmk80xx: %s\n",
 			       dev->fw.ic6_vers);
 		} else {
-			dbgcm("comedi#: vmk80xx: no conn. to CPU\n");
+			dbgcm(&(dev->udev->dev),
+				"comedi#: vmk80xx: no conn. to CPU\n");
 		}
 	}
 
@@ -1387,8 +1391,9 @@ static int vmk80xx_usb_probe(struct usb_interface *intf,
 
 	dev->probed = 1;
 
-	printk(KERN_INFO "comedi#: vmk80xx: board #%d [%s] now attached\n",
-	       dev->count, dev->board.name);
+	dev_dbg(&(dev->udev->dev),
+		"comedi#: vmk80xx: board #%d [%s] now attached\n",
+		dev->count, dev->board.name);
 
 	mutex_unlock(&glb_mutex);
 
@@ -1422,8 +1427,9 @@ static void vmk80xx_usb_disconnect(struct usb_interface *intf)
 	kfree(dev->usb_rx_buf);
 	kfree(dev->usb_tx_buf);
 
-	printk(KERN_INFO "comedi#: vmk80xx: board #%d [%s] now detached\n",
-	       dev->count, dev->board.name);
+	dev_dbg(&(dev->udev->dev),
+		"comedi#: vmk80xx: board #%d [%s] now detached\n",
+		dev->count, dev->board.name);
 
 	up(&dev->limit_sem);
 	mutex_unlock(&glb_mutex);
-- 
1.7.9.5


--OXfL5xGRrasGEqWY
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0002-Staging-comedi-drivers-Replaced-macro-dbgcm-with-dir.patch"

>From ca6624888fc6b817c353ccdd3c445cedd0c124e0 Mon Sep 17 00:00:00 2001
From: Arpith Easow Alexander <arpith99@gmail.com>
Date: Thu, 15 Nov 2012 21:18:44 +0530
Subject: [PATCH 2/2] Staging: comedi: drivers: Replaced macro dbgcm with
 direct call to dev_dbg.

Removed debug control variable and macro for printk statements.
Now using direct call to dev_dbg.

Signed-off-by: Arpith Easow Alexander <arpith99@gmail.com>
---
 drivers/staging/comedi/drivers/vmk80xx.c |   18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/comedi/drivers/vmk80xx.c b/drivers/staging/comedi/drivers/vmk80xx.c
index 6eb5361..562f217 100644
--- a/drivers/staging/comedi/drivers/vmk80xx.c
+++ b/drivers/staging/comedi/drivers/vmk80xx.c
@@ -125,18 +125,6 @@ enum {
 #define URB_RCV_FLAG            (1 << 0)
 #define URB_SND_FLAG            (1 << 1)
 
-#ifdef CONFIG_COMEDI_DEBUG
-static int dbgcm = 1;
-#else
-static int dbgcm;
-#endif
-
-#define dbgcm(dev, fmt, arg...)                     \
-do {                                           \
-	if (dbgcm)                             \
-		dev_dbg(dev, fmt, ##arg); \
-} while (0)
-
 enum vmk80xx_model {
 	VMK8055_MODEL,
 	VMK8061_MODEL
@@ -213,7 +201,7 @@ static void vmk80xx_tx_callback(struct urb *urb)
 
 	if (stat && !(stat == -ENOENT
 		      || stat == -ECONNRESET || stat == -ESHUTDOWN))
-		dbgcm(&(dev->udev->dev),
+		dev_dbg(&(dev->udev->dev),
 			"comedi#: vmk80xx: %s - nonzero urb status (%d)\n",
 			__func__, stat);
 
@@ -238,7 +226,7 @@ static void vmk80xx_rx_callback(struct urb *urb)
 	case -ESHUTDOWN:
 		break;
 	default:
-		dbgcm(&(dev->udev->dev),
+		dev_dbg(&(dev->udev->dev),
 		      "comedi#: vmk80xx: %s - nonzero urb status (%d)\n",
 		      __func__, stat);
 		goto resubmit;
@@ -1381,7 +1369,7 @@ static int vmk80xx_usb_probe(struct usb_interface *intf,
 			dev_dbg(&(dev->udev->dev), "comedi#: vmk80xx: %s\n",
 			       dev->fw.ic6_vers);
 		} else {
-			dbgcm(&(dev->udev->dev),
+			dev_dbg(&(dev->udev->dev),
 				"comedi#: vmk80xx: no conn. to CPU\n");
 		}
 	}
-- 
1.7.9.5


--OXfL5xGRrasGEqWY--
