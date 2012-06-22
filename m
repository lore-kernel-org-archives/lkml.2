Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762833Ab2FVXag (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 19:30:36 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:45348 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756473Ab2FVXaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 19:30:35 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-160.messagelabs.com!1340407833!6623281!1
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 20/31] staging: comedi: ni_daq_700: remove the subdev_700_init function
Date: Fri, 22 Jun 2012 16:30:13 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206221630.14354.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the contents of subdev_700_init into the attach function.
For aesthetic reasone, add some whitespace to the initialization
of the subdevice.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/ni_daq_700.c | 31 ++++++++++-------------------
 1 file changed, 10 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_daq_700.c b/drivers/staging/comedi/drivers/ni_daq_700.c
index dbc5fc6..206a0c4 100644
--- a/drivers/staging/comedi/drivers/ni_daq_700.c
+++ b/drivers/staging/comedi/drivers/ni_daq_700.c
@@ -102,26 +102,6 @@ static int subdev_700_insn_config(struct comedi_device *dev,
 	return 1;
 }
 
-static int subdev_700_init(struct comedi_device *dev,
-			   struct comedi_subdevice *s,
-			   int (*cb) (int, int, int, unsigned long),
-			   unsigned long arg)
-{
-	s->type = COMEDI_SUBD_DIO;
-	s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
-	s->n_chan = 16;
-	s->range_table = &range_digital;
-	s->maxdata = 1;
-
-	s->insn_bits = subdev_700_insn;
-	s->insn_config = subdev_700_insn_config;
-
-	s->state = 0;
-	s->io_bits = 0x00ff;
-
-	return 0;
-}
-
 static int dio700_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	const struct dio700_board *thisboard = comedi_board(dev);
@@ -171,7 +151,16 @@ static int dio700_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	/* DAQCard-700 dio */
 	s = dev->subdevices + 0;
-	subdev_700_init(dev, s, NULL, dev->iobase);
+	s->type		= COMEDI_SUBD_DIO;
+	s->subdev_flags	= SDF_READABLE | SDF_WRITABLE;
+	s->n_chan	= 16;
+	s->range_table	= &range_digital;
+	s->maxdata	= 1;
+	s->insn_bits	= subdev_700_insn;
+	s->insn_config	= subdev_700_insn_config;
+
+	s->state	= 0;
+	s->io_bits	= 0x00ff;
 
 	return 0;
 };
-- 
1.7.11

