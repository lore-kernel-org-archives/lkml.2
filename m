Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274Ab2FMWnU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 18:43:20 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:56043 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170Ab2FMWnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 18:43:16 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-16.tower-127.messagelabs.com!1339627395!5726007!4
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 14/15] staging: comedi: 8255: add namespace to 'do_config' function
Date: Wed, 13 Jun 2012 15:43:04 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206131543.05160.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The name 'do_config' is pretty generic, and this function is the
only one in this driver without namespace. Add namespace to it
just to avoid any issues.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/8255.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/8255.c b/drivers/staging/comedi/drivers/8255.c
index abbb6d4..8c97ac1 100644
--- a/drivers/staging/comedi/drivers/8255.c
+++ b/drivers/staging/comedi/drivers/8255.c
@@ -169,7 +169,8 @@ static int subdev_8255_insn(struct comedi_device *dev,
 	return insn->n;
 }
 
-static void do_config(struct comedi_device *dev, struct comedi_subdevice *s)
+static void subdev_8255_do_config(struct comedi_device *dev,
+				  struct comedi_subdevice *s)
 {
 	struct subdev_8255_private *spriv = s->private;
 	unsigned long iobase = spriv->iobase;
@@ -221,7 +222,7 @@ static int subdev_8255_insn_config(struct comedi_device *dev,
 		return -EINVAL;
 	}
 
-	do_config(dev, s);
+	subdev_8255_do_config(dev, s);
 
 	return 1;
 }
@@ -344,7 +345,7 @@ int subdev_8255_init(struct comedi_device *dev, struct comedi_subdevice *s,
 	s->state	= 0;
 	s->io_bits	= 0;
 
-	do_config(dev, s);
+	subdev_8255_do_config(dev, s);
 
 	return 0;
 }
-- 
1.7.7

