Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab2KSP2a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 10:28:30 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62304 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119Ab2KSP23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 10:28:29 -0500
Date: Mon, 19 Nov 2012 20:58:21 +0530
From: Arpith Easow Alexander <arpith99@gmail.com>
To: abbotti@mev.co.uk, fmhess@users.sourceforge.net,
        gregkh@linuxfoundation.org, hsweeten@visionengravers.com,
        dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] Staging: comedi: drivers: Replaced macro dbgcm with
 direct call to dev_dbg.
Message-ID: <20121119152816.GA6031@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

