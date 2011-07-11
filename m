Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756360Ab1GKF1e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 01:27:34 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36193 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499Ab1GKF1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 01:27:33 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH 2/2] Staging: comedi: fix brace coding style issue in pcl818.c
Date: Mon, 11 Jul 2011 11:10:09 +0530
Message-Id: <1310362809-15273-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <[PATCH 2/2]Staging: comedi: fix brace coding style issue in pcl818.c>
References: <[PATCH 2/2]Staging: comedi: fix brace coding style issue in pcl818.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the pcl818.c file that fixes up a brace warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/pcl818.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
index 6a7fa42..a42148e 100644
--- a/drivers/staging/comedi/drivers/pcl818.c
+++ b/drivers/staging/comedi/drivers/pcl818.c
@@ -463,9 +463,8 @@ static int pcl818_ao_insn_read(struct comedi_device *dev,
 	int n;
 	int chan = CR_CHAN(insn->chanspec);
 
-	for (n = 0; n < insn->n; n++) {
+	for (n = 0; n < insn->n; n++)
 		data[n] = devpriv->ao_readback[chan];
-	}
 
 	return n;
 }
@@ -824,9 +823,8 @@ static irqreturn_t interrupt_pcl818_ai_mode13_fifo(int irq, void *d)
 		comedi_buf_put(s->async, (lo >> 4) | (inb(dev->iobase + PCL818_FI_DATAHI) << 4));	/*  get one sample */
 
 		devpriv->act_chanlist_pos++;
-		if (devpriv->act_chanlist_pos >= devpriv->act_chanlist_len) {
+		if (devpriv->act_chanlist_pos >= devpriv->act_chanlist_len)
 			devpriv->act_chanlist_pos = 0;
-		}
 		s->async->cur_chan++;
 		if (s->async->cur_chan >= devpriv->ai_n_chan) {
 			s->async->cur_chan = 0;
@@ -1056,17 +1054,14 @@ static int pcl818_ai_cmd_mode(int mode, struct comedi_device *dev,
 	switch (devpriv->dma) {
 	case 1:		/*  DMA */
 	case 3:
-		if (devpriv->dma_rtc == 0) {
+		if (devpriv->dma_rtc == 0)
 			pcl818_ai_mode13dma_int(mode, dev, s);
-		}
 #ifdef unused
-		else {
+		else
 			pcl818_ai_mode13dma_rtc(mode, dev, s);
-		}
 #else
-		else {
+		else
 			return -EINVAL;
-		}
 #endif
 		break;
 	case 0:
-- 
1.6.5.2

