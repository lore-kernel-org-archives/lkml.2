Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762836Ab2FVXck (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 19:32:40 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:47115 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756459Ab2FVXcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 19:32:39 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-160.messagelabs.com!1340407958!7534579!1
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 22/31] staging: comedi: ni_daq_700: change the 'attach' printk's to dev_printk's
Date: Fri, 22 Jun 2012 16:32:19 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206221632.20292.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the dev_printk() routines to output the kernel messages in the
attach routine.

The main 'attach' message had a level of KERN_ERR, I believe it should
have been KERN_INFO. Also, move that message to the end of the attach
so it only gets displayed if the attach is successful.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/ni_daq_700.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_daq_700.c b/drivers/staging/comedi/drivers/ni_daq_700.c
index 94cb346..50fad12 100644
--- a/drivers/staging/comedi/drivers/ni_daq_700.c
+++ b/drivers/staging/comedi/drivers/ni_daq_700.c
@@ -113,11 +113,8 @@ static int dio700_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		return -EIO;
 	iobase = link->resource[0]->start;
 
-	printk(KERN_ERR "comedi%d: ni_daq_700: %s, io 0x%lx\n", dev->minor,
-	       thisboard->name, iobase);
-
 	if (iobase == 0) {
-		printk(KERN_ERR "io base address is zero!\n");
+		dev_err(dev->class_dev, "io base address is zero!\n");
 		return -EINVAL;
 	}
 
@@ -142,6 +139,11 @@ static int dio700_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	s->state	= 0;
 	s->io_bits	= 0x00ff;
 
+	dev_info(dev->class_dev, "%s: %s, io 0x%lx\n",
+		dev->driver->driver_name,
+		dev->board_name,
+		dev->iobase);
+
 	return 0;
 };
 
-- 
1.7.11

