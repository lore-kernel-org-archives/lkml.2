Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998Ab1GLFJu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 01:09:50 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56872 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206Ab1GLFJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 01:09:49 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH 17/17] Staging: comedi: fix line over 80 character issue in pcl818.c
Date: Tue, 12 Jul 2011 10:52:30 +0530
Message-Id: <1310448150-8697-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <[PATCH 16/16]Staging: comedi: fix line over 80 character issue in pcl818.c>
References: <[PATCH 16/16]Staging: comedi: fix line over 80 character issue in pcl818.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the pcl818.c file that fixes up a line over 80 character warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/pcl818.c |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
index 1cd4558..53700ec 100644
--- a/drivers/staging/comedi/drivers/pcl818.c
+++ b/drivers/staging/comedi/drivers/pcl818.c
@@ -1375,7 +1375,9 @@ static int ai_cmdtest(struct comedi_device *dev, struct comedi_subdevice *s,
 	if (err)
 		return 1;
 
-	/* step 2: make sure trigger sources are unique and mutually compatible */
+	/* step 2: make sure trigger sources are unique and
+	 * mutually compatible
+	 */
 
 	if (cmd->start_src != TRIG_NOW) {
 		cmd->start_src = TRIG_NOW;
@@ -1441,7 +1443,6 @@ static int ai_cmdtest(struct comedi_device *dev, struct comedi_subdevice *s,
 
 	if (err)
 		return 3;
-	
 	/* step 4: fix up any arguments */
 
 	if (cmd->convert_src == TRIG_TIMER) {
@@ -1529,7 +1530,9 @@ static int pcl818_ai_cancel(struct comedi_device *dev,
 			if (devpriv->neverending_ai ||
 			    (!devpriv->neverending_ai &&
 			     devpriv->ai_act_scan > 0)) {
-				/* wait for running dma transfer to end, do cleanup in interrupt */
+				/* wait for running dma transfer to end, do
+				 * cleanup in interrupt
+				 */
 				goto end;
 			}
 			disable_dma(devpriv->dma);
@@ -1547,7 +1550,8 @@ static int pcl818_ai_cancel(struct comedi_device *dev,
 			outb(0, dev->iobase + PCL818_AD_LO);
 			inb(dev->iobase + PCL818_AD_LO);
 			inb(dev->iobase + PCL818_AD_HI);
-			outb(0, dev->iobase + PCL818_CLRINT);	/* clear INT request */
+			/* clear INT request */
+			outb(0, dev->iobase + PCL818_CLRINT);
 			outb(0, dev->iobase + PCL818_CONTROL);	/* Stop A/D */
 			if (devpriv->usefifo) {	/*  FIFO shutdown */
 				outb(0, dev->iobase + PCL818_FI_INTCLR);
@@ -1932,7 +1936,8 @@ no_dma:
 		}
 		if (this_board->is_818) {
 			if ((it->options[4] == 1) || (it->options[4] == 10))
-				s->range_table = &range_pcl818l_h_ai;	/*  secondary range list jumper selectable */
+				/* secondary range list jumper selectable */
+				s->range_table = &range_pcl818l_h_ai;
 		} else {
 			switch (it->options[4]) {
 			case 0:
@@ -2039,7 +2044,8 @@ no_dma:
 
 	if (!this_board->is_818) {
 		if ((it->options[6] == 1) || (it->options[6] == 100))
-			devpriv->ns_min = 10000;	/* extended PCL718 to 100kHz DAC */
+			/* extended PCL718 to 100kHz DAC */
+			devpriv->ns_min = 10000;
 	}
 
 	pcl818_reset(dev);
-- 
1.6.5.2

