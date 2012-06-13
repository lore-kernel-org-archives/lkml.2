Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab2FMWl3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 18:41:29 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:56042 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab2FMWl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 18:41:27 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-160.messagelabs.com!1339627283!7929617!4
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 01/15] staging: comedi: 8255: replace printk calls
Date: Wed, 13 Jun 2012 15:41:15 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206131541.15779.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the printk calls with dev_info, dev_warn, etc.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartmen <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/8255.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/comedi/drivers/8255.c b/drivers/staging/comedi/drivers/8255.c
index 502bde8..b608a05 100644
--- a/drivers/staging/comedi/drivers/8255.c
+++ b/drivers/staging/comedi/drivers/8255.c
@@ -383,8 +383,7 @@ static int dev_8255_attach(struct comedi_device *dev,
 			break;
 	}
 	if (i == 0) {
-		printk(KERN_WARNING
-		       "comedi%d: 8255: no devices specified\n", dev->minor);
+		dev_warn(dev->class_dev, "no devices specified\n");
 		return -EINVAL;
 	}
 
@@ -392,24 +391,21 @@ static int dev_8255_attach(struct comedi_device *dev,
 	if (ret)
 		return ret;
 
-	printk(KERN_INFO "comedi%d: 8255:", dev->minor);
-
 	for (i = 0; i < dev->n_subdevices; i++) {
 		iobase = it->options[i];
 
-		printk(" 0x%04lx", iobase);
 		if (!request_region(iobase, _8255_SIZE, "8255")) {
-			printk(" (I/O port conflict)");
+			dev_warn(dev->class_dev,
+				"0x%04lx (I/O port conflict)\n", iobase);
 
 			dev->subdevices[i].type = COMEDI_SUBD_UNUSED;
 		} else {
 			subdev_8255_init(dev, dev->subdevices + i, NULL,
 					 iobase);
+			dev_info(dev->class_dev, "0x%04lx\n", iobase);
 		}
 	}
 
-	printk("\n");
-
 	return 0;
 }
 
-- 
1.7.7

