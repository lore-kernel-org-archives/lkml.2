Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762751Ab2FVXTw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 19:19:52 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:19777 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946Ab2FVXTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 19:19:51 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-127.messagelabs.com!1340407190!6580907!1
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 11/31] staging: comedi: ni_daq_700: Remove a "do nothing" function stub
Date: Fri, 22 Jun 2012 16:19:47 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206221619.47538.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function do_config() doesn't do anything. Just remove it.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/ni_daq_700.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_daq_700.c b/drivers/staging/comedi/drivers/ni_daq_700.c
index 7ad5465..99ce234d 100644
--- a/drivers/staging/comedi/drivers/ni_daq_700.c
+++ b/drivers/staging/comedi/drivers/ni_daq_700.c
@@ -107,8 +107,6 @@ struct subdev_700_struct {
 #define CALLBACK_FUNC	(((struct subdev_700_struct *)s->private)->cb_func)
 #define subdevpriv	((struct subdev_700_struct *)s->private)
 
-static void do_config(struct comedi_device *dev, struct comedi_subdevice *s);
-
 static int subdev_700_cb(int dir, int port, int data, unsigned long arg)
 {
 	/* port is always A for output and B for input (8255 emu) */
@@ -165,11 +163,6 @@ static int subdev_700_insn_config(struct comedi_device *dev,
 	return 1;
 }
 
-static void do_config(struct comedi_device *dev, struct comedi_subdevice *s)
-{				/* use powerup defaults */
-	return;
-}
-
 static int subdev_700_init(struct comedi_device *dev,
 			   struct comedi_subdevice *s,
 			   int (*cb) (int, int, int, unsigned long),
@@ -196,7 +189,6 @@ static int subdev_700_init(struct comedi_device *dev,
 
 	s->state = 0;
 	s->io_bits = 0x00ff;
-	do_config(dev, s);
 
 	return 0;
 }
-- 
1.7.11

