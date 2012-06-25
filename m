Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757996Ab2FYX6o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 19:58:44 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:28744 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757262Ab2FYX6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 19:58:41 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-209.messagelabs.com!1340668719!6916915!1
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 17/33] staging: comedi: cb_das16_cs: remove skel driver cut-and-paste comments
Date: Mon, 25 Jun 2012 16:58:34 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206251658.34368.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a number of comments in this driver that are cut-and-paste
from the skel driver. They are not needed in "real" drivers.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_das16_cs.c | 20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_das16_cs.c b/drivers/staging/comedi/drivers/cb_das16_cs.c
index e1e3ff0..36fd3e6 100644
--- a/drivers/staging/comedi/drivers/cb_das16_cs.c
+++ b/drivers/staging/comedi/drivers/cb_das16_cs.c
@@ -108,10 +108,6 @@ static irqreturn_t das16cs_interrupt(int irq, void *d)
 	return IRQ_HANDLED;
 }
 
-/*
- * "instructions" read/write data in "one-shot" or "software-triggered"
- * mode.
- */
 static int das16cs_ai_rinsn(struct comedi_device *dev,
 			    struct comedi_subdevice *s,
 			    struct comedi_insn *insn, unsigned int *data)
@@ -168,13 +164,6 @@ static int das16cs_ai_cmdtest(struct comedi_device *dev,
 	int err = 0;
 	int tmp;
 
-	/* cmdtest tests a particular command to see if it is valid.
-	 * Using the cmdtest ioctl, a user can create a valid cmd
-	 * and then have it executes by the cmd ioctl.
-	 *
-	 * cmdtest returns 1,2,3,4 or 0, depending on which tests
-	 * the command passes. */
-
 	/* step 1: make sure trigger sources are trivially valid */
 
 	tmp = cmd->start_src;
@@ -367,8 +356,6 @@ static int das16cs_ao_winsn(struct comedi_device *dev,
 	return i;
 }
 
-/* AO subdevices should have a read insn as well as a write insn.
- * Usually this means copying a value stored in devpriv. */
 static int das16cs_ao_rinsn(struct comedi_device *dev,
 			    struct comedi_subdevice *s,
 			    struct comedi_insn *insn, unsigned int *data)
@@ -383,11 +370,6 @@ static int das16cs_ao_rinsn(struct comedi_device *dev,
 	return i;
 }
 
-/* DIO devices are slightly special.  Although it is possible to
- * implement the insn_read/insn_write interface, it is much more
- * useful to applications if you implement the insn_bits interface.
- * This allows packed reading/writing of the DIO channels.  The
- * comedi core can convert between insn_bits and insn_read/write */
 static int das16cs_dio_insn_bits(struct comedi_device *dev,
 				 struct comedi_subdevice *s,
 				 struct comedi_insn *insn, unsigned int *data)
@@ -399,8 +381,6 @@ static int das16cs_dio_insn_bits(struct comedi_device *dev,
 		outw(s->state, dev->iobase + 16);
 	}
 
-	/* on return, data[1] contains the value of the digital
-	 * input and output lines. */
 	data[1] = inw(dev->iobase + 16);
 
 	return insn->n;
-- 
1.7.11

