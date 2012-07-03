Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933263Ab2GCBPL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 21:15:11 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:45588 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756218Ab2GCBPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 21:15:09 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-160.messagelabs.com!1341278108!8516722!1
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 8/8] staging: comedi: dmm32at: remove skel driver cut-and-paste comments
Date: Mon, 2 Jul 2012 18:15:02 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207021815.02935.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the cut-and-paste comments from the skel driver.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/dmm32at.c | 40 --------------------------------
 1 file changed, 40 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dmm32at.c b/drivers/staging/comedi/drivers/dmm32at.c
index f0221e9..7107f59 100644
--- a/drivers/staging/comedi/drivers/dmm32at.c
+++ b/drivers/staging/comedi/drivers/dmm32at.c
@@ -160,10 +160,6 @@ struct dmm32at_board {
 	const char *name;
 };
 
-/* this structure is for data unique to this hardware driver.  If
- * several hardware drivers keep similar information in this structure,
- * feel free to suggest moving the variable to the struct comedi_device struct.
- */
 struct dmm32at_private {
 
 	int data;
@@ -176,11 +172,6 @@ struct dmm32at_private {
 
 };
 
-/*
- * "instructions" read/write data in "one-shot" or "software-triggered"
- * mode.
- */
-
 static int dmm32at_ai_rinsn(struct comedi_device *dev,
 			    struct comedi_subdevice *s,
 			    struct comedi_insn *insn, unsigned int *data)
@@ -253,20 +244,9 @@ static int dmm32at_ai_rinsn(struct comedi_device *dev,
 	return n;
 }
 
-/* This function doesn't require a particular form, this is just
- * what happens to be used in some of the drivers.  It should
- * convert ns nanoseconds to a counter value suitable for programming
- * the device.  Also, it should adjust ns so that it cooresponds to
- * the actual time that the device will use. */
 static int dmm32at_ns_to_timer(unsigned int *ns, int round)
 {
 	/* trivial timer */
-	/* if your timing is done through two cascaded timers, the
-	 * i8253_cascade_ns_to_timer() function in 8253.h can be
-	 * very helpful.  There are also i8254_load() and i8254_mm_load()
-	 * which can be used to load values into the ubiquitous 8254 counters
-	 */
-
 	return *ns;
 }
 
@@ -278,15 +258,6 @@ static int dmm32at_ai_cmdtest(struct comedi_device *dev,
 	int tmp;
 	int start_chan, gain, i;
 
-	/* printk("dmmat32 in command test\n"); */
-
-	/* cmdtest tests a particular command to see if it is valid.
-	 * Using the cmdtest ioctl, a user can create a valid cmd
-	 * and then have it executes by the cmd ioctl.
-	 *
-	 * cmdtest returns 1,2,3,4 or 0, depending on which tests
-	 * the command passes. */
-
 	/* step 1: make sure trigger sources are trivially valid */
 
 	tmp = cmd->start_src;
@@ -659,8 +630,6 @@ static int dmm32at_ao_winsn(struct comedi_device *dev,
 	return i;
 }
 
-/* AO subdevices should have a read insn as well as a write insn.
- * Usually this means copying a value stored in devpriv. */
 static int dmm32at_ao_rinsn(struct comedi_device *dev,
 			    struct comedi_subdevice *s,
 			    struct comedi_insn *insn, unsigned int *data)
@@ -675,11 +644,6 @@ static int dmm32at_ao_rinsn(struct comedi_device *dev,
 	return i;
 }
 
-/* DIO devices are slightly special.  Although it is possible to
- * implement the insn_read/insn_write interface, it is much more
- * useful to applications if you implement the insn_bits interface.
- * This allows packed reading/writing of the DIO channels.  The
- * comedi core can convert between insn_bits and insn_read/write */
 static int dmm32at_dio_insn_bits(struct comedi_device *dev,
 				 struct comedi_subdevice *s,
 				 struct comedi_insn *insn, unsigned int *data)
@@ -853,10 +817,6 @@ static int dmm32at_attach(struct comedi_device *dev,
 
 	dev->board_name = board->name;
 
-/*
- * Allocate the private structure area.  alloc_private() is a
- * convenient macro defined in comedidev.h.
- */
 	if (alloc_private(dev, sizeof(*devpriv)) < 0)
 		return -ENOMEM;
 	devpriv = dev->private;
-- 
1.7.11

