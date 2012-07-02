Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933101Ab2GBV0j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 17:26:39 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:64102 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317Ab2GBV0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 17:26:37 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-127.messagelabs.com!1341264392!7502829!13
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: s626: fix the number of dio channels
Date: Mon, 2 Jul 2012 14:26:24 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207021426.25319.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first digital i/o subdevice has its n_chan set to S626_DIO_CHANNELS
which is defined as 48. This is actually the total number of channels
provided by all three digital i/o subdevices. Each subdevice only has
16 channels.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/s626.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index bef9649..f90578e 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -2636,7 +2636,7 @@ static int s626_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	/* digital I/O subdevice */
 	s->type = COMEDI_SUBD_DIO;
 	s->subdev_flags = SDF_WRITABLE | SDF_READABLE;
-	s->n_chan = S626_DIO_CHANNELS;
+	s->n_chan = 16;
 	s->maxdata = 1;
 	s->io_bits = 0xffff;
 	s->private = &dio_private_A;
-- 
1.7.11

