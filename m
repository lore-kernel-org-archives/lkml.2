Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116Ab1GMQG7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 12:06:59 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:53508 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755972Ab1GMQG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 12:06:58 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH 1/3] Staging: comedi: fix warning: line over 80 character issue in das16m1.c
Date: Wed, 13 Jul 2011 21:49:36 +0530
Message-Id: <1310573976-5100-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <[PATCH 1/3]Staging: comedi:fix warning: line over 80 character issue in das16m1.c>
References: <[PATCH 1/3]Staging: comedi:fix warning: line over 80 character issue in das16m1.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the das16m1.c file that fixes up a  warning:line over 80 character found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/das16m1.c |   38 ++++++++++++++++++-----------
 1 files changed, 23 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das16m1.c b/drivers/staging/comedi/drivers/das16m1.c
index a5ce3b2..642f20d 100644
--- a/drivers/staging/comedi/drivers/das16m1.c
+++ b/drivers/staging/comedi/drivers/das16m1.c
@@ -52,8 +52,8 @@ list has 2 or more channels in it, then two conditions must be satisfied:
 (2) - the list must have an even number of entries.
 
 Options:
-        [0] - base io address
-        [1] - irq (optional, but you probably want it)
+	[0] - base io address
+	[1] - irq (optional, but you probably want it)
 
 irq can be omitted, although the cmd interface will not work without it.
 */
@@ -185,15 +185,18 @@ static struct comedi_driver driver_das16m1 = {
 
 struct das16m1_private_struct {
 	unsigned int control_state;
 	/* initial value in lower half of hardware conversion counter,
 	 * needed to keep track of whether new count has been loaded into
 	 * counter yet (loaded by first sample conversion) */
 	u16 initial_hw_count;
 	short ai_buffer[FIFO_SIZE];
 	unsigned int do_bits;	/*  saves status of digital output bits */
-	unsigned int divisor1;	/*  divides master clock to obtain conversion speed */
-	unsigned int divisor2;	/*  divides master clock to obtain conversion speed */
+	/* divides master clock to obtain conversion speed */
+	unsigned int divisor1;
+	/* divides master clock to obtain conversion speed */
+	unsigned int divisor2;
 };
 #define devpriv ((struct das16m1_private_struct *)(dev->private))
 #define thisboard ((const struct das16m1_board *)(dev->board_ptr))
@@ -250,7 +253,8 @@ static int das16m1_cmd_test(struct comedi_device *dev,
 	if (err)
 		return 1;
 
-	/* step 2: make sure trigger sources are unique and mutually compatible */
+	/* step 2: make sure trigger sources are unique and
+	 * mutually compatible */
 	if (cmd->stop_src != TRIG_COUNT && cmd->stop_src != TRIG_NONE)
 		err++;
 	if (cmd->start_src != TRIG_NOW && cmd->start_src != TRIG_EXT)
@@ -320,7 +324,8 @@ static int das16m1_cmd_test(struct comedi_device *dev,
 	/*  check chanlist against board's peculiarities */
 	if (cmd->chanlist && cmd->chanlist_len > 1) {
 		for (i = 0; i < cmd->chanlist_len; i++) {
-			/*  even/odd channels must go into even/odd queue addresses */
+			/* even/odd channels must go into
+			 * even/odd queue addresses */
 			if ((i % 2) != (CR_CHAN(cmd->chanlist[i]) % 2)) {
 				comedi_error(dev, "bad chanlist:\n"
 					     " even/odd channels must go have even/odd chanlist indices");
@@ -556,13 +561,15 @@ static void das16m1_handler(struct comedi_device *dev, unsigned int status)
 	if (devpriv->adc_count == 0 && hw_counter == devpriv->initial_hw_count) {
 		num_samples = 0;
 	} else {
-		/* The calculation of num_samples looks odd, but it uses the following facts.
-		 * 16 bit hardware counter is initialized with value of zero (which really
-		 * means 0x1000).  The counter decrements by one on each conversion
-		 * (when the counter decrements from zero it goes to 0xffff).  num_samples
-		 * is a 16 bit variable, so it will roll over in a similar fashion to the
-		 * hardware counter.  Work it out, and this is what you get. */
-		num_samples = -hw_counter - devpriv->adc_count;
+		/* The calculation of num_samples looks odd, but it uses the
+		 * following facts .16 bit hardware counter is initialized with
+		 * value of zero (which really means 0x1000).The counter
+		 * decrements by one on each conversion (when the counter
+		 * decrements from zero it goes to 0xffff). num_samples is a
+		 * 16 bit variable, so it will roll over in a similar fashion
+		 * to the hardware counter.Work it out, and this is what
+		 * you get.num_samples = -hw_counter - devpriv->adc_count;
+                */
 	}
 	/*  check if we only need some of the points */
 	if (cmd->stop_src == TRIG_COUNT) {
@@ -753,7 +760,8 @@ static int das16m1_attach(struct comedi_device *dev,
 	/* 8255 */
 	subdev_8255_init(dev, s, NULL, dev->iobase + DAS16M1_82C55);
 
-	/*  disable upper half of hardware conversion counter so it doesn't mess with us */
+	/* disable upper half of hardware conversion counter
+	 * so it doesn't mess with us */
 	outb(TOTAL_CLEAR, dev->iobase + DAS16M1_8254_FIRST_CNTRL);
 
 	/*  initialize digital output lines */
-- 
1.6.5.2

