Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207Ab2FMWnH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 18:43:07 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:60752 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754968Ab2FMWnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 18:43:03 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-160.messagelabs.com!1339627370!9421870!8
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 08/15] staging: comedi: 8255: remove have_irg and refactor subdev_8255_init_irq
Date: Wed, 13 Jun 2012 15:42:21 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206131542.21842.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The have_irq variable in the 8255 private data is not used by the driver,
remove it.  This removes the need to access the private data in the
subdev_8255_init_irq function.

Also, add a bit of whitespace to improve the readability.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/8255.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/comedi/drivers/8255.c b/drivers/staging/comedi/drivers/8255.c
index 52b9817..da86a04 100644
--- a/drivers/staging/comedi/drivers/8255.c
+++ b/drivers/staging/comedi/drivers/8255.c
@@ -100,7 +100,6 @@ I/O port base address can be found in the output of 'lspci -v'.
 struct subdev_8255_private {
 	unsigned long iobase;
 	int (*io) (int, int, int, unsigned long);
-	int have_irq;
 };
 
 void subdev_8255_interrupt(struct comedi_device *dev,
@@ -340,19 +339,15 @@ int subdev_8255_init_irq(struct comedi_device *dev, struct comedi_subdevice *s,
 			 int (*io) (int, int, int, unsigned long),
 			 unsigned long iobase)
 {
-	struct subdev_8255_private *spriv;
 	int ret;
 
 	ret = subdev_8255_init(dev, s, io, iobase);
 	if (ret < 0)
 		return ret;
-	spriv = s->private;
-
-	spriv->have_irq = 1;
 
-	s->do_cmdtest = subdev_8255_cmdtest;
-	s->do_cmd = subdev_8255_cmd;
-	s->cancel = subdev_8255_cancel;
+	s->do_cmdtest	= subdev_8255_cmdtest;
+	s->do_cmd	= subdev_8255_cmd;
+	s->cancel	= subdev_8255_cancel;
 
 	return 0;
 }
-- 
1.7.7

