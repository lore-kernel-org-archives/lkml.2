Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933Ab2FMWlp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 18:41:45 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:52024 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719Ab2FMWln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 18:41:43 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-160.messagelabs.com!1339627291!9413118!10
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 02/15] staging: comedi: 8255: use pointer to dev->subdevices
Date: Wed, 13 Jun 2012 15:41:27 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206131541.28151.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of accessing the dev->subdevices directly as an array,
use a pointer. This method is more common in the comedi subsystem.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/8255.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/8255.c b/drivers/staging/comedi/drivers/8255.c
index b608a05..23b9acc 100644
--- a/drivers/staging/comedi/drivers/8255.c
+++ b/drivers/staging/comedi/drivers/8255.c
@@ -371,6 +371,7 @@ EXPORT_SYMBOL(subdev_8255_cleanup);
 static int dev_8255_attach(struct comedi_device *dev,
 			   struct comedi_devconfig *it)
 {
+	struct comedi_subdevice *s;
 	int ret;
 	unsigned long iobase;
 	int i;
@@ -392,16 +393,16 @@ static int dev_8255_attach(struct comedi_device *dev,
 		return ret;
 
 	for (i = 0; i < dev->n_subdevices; i++) {
+		s = dev->subdevices + i;
 		iobase = it->options[i];
 
 		if (!request_region(iobase, _8255_SIZE, "8255")) {
 			dev_warn(dev->class_dev,
 				"0x%04lx (I/O port conflict)\n", iobase);
 
-			dev->subdevices[i].type = COMEDI_SUBD_UNUSED;
+			s->type = COMEDI_SUBD_UNUSED;
 		} else {
-			subdev_8255_init(dev, dev->subdevices + i, NULL,
-					 iobase);
+			subdev_8255_init(dev, s, NULL, iobase);
 			dev_info(dev->class_dev, "0x%04lx\n", iobase);
 		}
 	}
-- 
1.7.7

