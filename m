Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117Ab2FMWmf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 18:42:35 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:3861 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754995Ab2FMWmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 18:42:33 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-209.messagelabs.com!1339627224!8449939!50
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 07/15] staging: comedi: 8255: refactor subdev_8255_init
Date: Wed, 13 Jun 2012 15:42:12 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206131542.12977.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refactor the initialization of the 8255 so that the private data
allocation is done before the subdevice is setup. This makes sure
that the setup is complete.

Also, add a bit of whitespace to improve the readability.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/8255.c |   31 +++++++++++++++----------------
 1 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/comedi/drivers/8255.c b/drivers/staging/comedi/drivers/8255.c
index 80ef031..52b9817 100644
--- a/drivers/staging/comedi/drivers/8255.c
+++ b/drivers/staging/comedi/drivers/8255.c
@@ -310,27 +310,26 @@ int subdev_8255_init(struct comedi_device *dev, struct comedi_subdevice *s,
 {
 	struct subdev_8255_private *spriv;
 
-	s->type = COMEDI_SUBD_DIO;
-	s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
-	s->n_chan = 24;
-	s->range_table = &range_digital;
-	s->maxdata = 1;
-
 	spriv = kmalloc(sizeof(*spriv), GFP_KERNEL);
 	if (!spriv)
 		return -ENOMEM;
-	s->private = spriv;
 
-	spriv->iobase = iobase;
-	if (io == NULL)
-		spriv->io = subdev_8255_io;
-	else
-		spriv->io = io;
-	s->insn_bits = subdev_8255_insn;
-	s->insn_config = subdev_8255_insn_config;
+	spriv->iobase	= iobase;
+	spriv->io	= io ? io : subdev_8255_io;
+
+	s->private	= spriv;
+
+	s->type		= COMEDI_SUBD_DIO;
+	s->subdev_flags	= SDF_READABLE | SDF_WRITABLE;
+	s->n_chan	= 24;
+	s->range_table	= &range_digital;
+	s->maxdata	= 1;
+	s->insn_bits	= subdev_8255_insn;
+	s->insn_config	= subdev_8255_insn_config;
+
+	s->state	= 0;
+	s->io_bits	= 0;
 
-	s->state = 0;
-	s->io_bits = 0;
 	do_config(dev, s);
 
 	return 0;
-- 
1.7.7

