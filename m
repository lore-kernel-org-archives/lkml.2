Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933387Ab2EWAnO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 20:43:14 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:40138 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235Ab2EWAnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 20:43:10 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-132.messagelabs.com!1337733788!12411570!2
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: remove thisboard macro in the pcmda12 driver
Date: Tue, 22 May 2012 17:42:55 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205221742.55668.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'thisboard' macro depends on having a local variable with
a magic name. The CodingStyle document suggests not doing this
to avoid confusion. Remove the macro and use the comedi_board()
inline helper to get the dev->board_ptr information.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

diff --git a/drivers/staging/comedi/drivers/pcmda12.c b/drivers/staging/comedi/drivers/pcmda12.c
index 4786148..f49c66a 100644
--- a/drivers/staging/comedi/drivers/pcmda12.c
+++ b/drivers/staging/comedi/drivers/pcmda12.c
@@ -80,11 +80,6 @@ static const struct comedi_lrange pcmda12_ranges = {
 	 }
 };
 
-/*
- * Useful for shorthand access to the particular board structure
- */
-#define thisboard ((const struct pcmda12_board *)dev->board_ptr)
-
 struct pcmda12_private {
 
 	unsigned int ao_readback[CHANS];
@@ -167,6 +162,7 @@ static int ao_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
 static int pcmda12_attach(struct comedi_device *dev,
 			  struct comedi_devconfig *it)
 {
+	const struct pcmda12_board *board = comedi_board(dev);
 	struct comedi_subdevice *s;
 	unsigned long iobase;
 
@@ -181,11 +177,7 @@ static int pcmda12_attach(struct comedi_device *dev,
 	}
 	dev->iobase = iobase;
 
-/*
- * Initialize dev->board_name.  Note that we can use the "thisboard"
- * macro now, since we just initialized it in the last line.
- */
-	dev->board_name = thisboard->name;
+	dev->board_name = board->name;
 
 /*
  * Allocate the private structure area.  alloc_private() is a
