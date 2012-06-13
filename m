Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234Ab2FMWnJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 18:43:09 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:60764 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755006Ab2FMWnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 18:43:05 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-160.messagelabs.com!1339627370!9421870!9
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 09/15] staging: comedi: 8255: check for failure of subdev_8255_init
Date: Wed, 13 Jun 2012 15:42:28 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206131542.28503.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The initialization of the 8255 subdevice can fail. Make sure to
check for it.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/8255.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/8255.c b/drivers/staging/comedi/drivers/8255.c
index da86a04..4cdd007 100644
--- a/drivers/staging/comedi/drivers/8255.c
+++ b/drivers/staging/comedi/drivers/8255.c
@@ -342,7 +342,7 @@ int subdev_8255_init_irq(struct comedi_device *dev, struct comedi_subdevice *s,
 	int ret;
 
 	ret = subdev_8255_init(dev, s, io, iobase);
-	if (ret < 0)
+	if (ret)
 		return ret;
 
 	s->do_cmdtest	= subdev_8255_cmdtest;
@@ -399,7 +399,9 @@ static int dev_8255_attach(struct comedi_device *dev,
 
 			s->type = COMEDI_SUBD_UNUSED;
 		} else {
-			subdev_8255_init(dev, s, NULL, iobase);
+			ret = subdev_8255_init(dev, s, NULL, iobase);
+			if (ret)
+				return ret;
 			dev_info(dev->class_dev, "0x%04lx\n", iobase);
 		}
 	}
-- 
1.7.7

