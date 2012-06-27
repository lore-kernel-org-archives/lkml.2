Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab2F0BF0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 21:05:26 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:13272 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755796Ab2F0BFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 21:05:24 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-132.messagelabs.com!1340759123!12623245!1
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 26/36] staging: comedi: cb_pcidas: fix some > 80 char lines
Date: Tue, 26 Jun 2012 18:05:12 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206261805.12950.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix some of the comments that cause checkpatch.pl to complain
about WARNING: line over 80 characters.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcidas.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas.c b/drivers/staging/comedi/drivers/cb_pcidas.c
index ff08f9e..12fb087 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas.c
@@ -1043,12 +1043,16 @@ static int cb_pcidas_ai_cmd(struct comedi_device *dev,
 	devpriv->adc_fifo_bits |= INTE;
 	devpriv->adc_fifo_bits &= ~INT_MASK;
 	if (cmd->flags & TRIG_WAKE_EOS) {
-		if (cmd->convert_src == TRIG_NOW && cmd->chanlist_len > 1)
-			devpriv->adc_fifo_bits |= INT_EOS;	/*  interrupt end of burst */
-		else
-			devpriv->adc_fifo_bits |= INT_FNE;	/*  interrupt fifo not empty */
+		if (cmd->convert_src == TRIG_NOW && cmd->chanlist_len > 1) {
+			/* interrupt end of burst */
+			devpriv->adc_fifo_bits |= INT_EOS;
+		} else {
+			/* interrupt fifo not empty */
+			devpriv->adc_fifo_bits |= INT_FNE;
+		}
 	} else {
-		devpriv->adc_fifo_bits |= INT_FHF;	/* interrupt fifo half full */
+		/* interrupt fifo half full */
+		devpriv->adc_fifo_bits |= INT_FHF;
 	}
 
 	/*  enable (and clear) interrupts */
@@ -1474,7 +1478,9 @@ static irqreturn_t cb_pcidas_interrupt(int irq, void *d)
 					INT_ADCFIFO)) == 0)
 				break;
 			cfc_write_to_buffer(s, inw(devpriv->adc_fifo));
-			if (async->cmd.stop_src == TRIG_COUNT && --devpriv->count == 0) {	/* end of acquisition */
+			if (async->cmd.stop_src == TRIG_COUNT &&
+			    --devpriv->count == 0) {
+				/* end of acquisition */
 				cb_pcidas_cancel(dev, s);
 				async->events |= COMEDI_CB_EOA;
 				break;
@@ -1620,7 +1626,10 @@ static int cb_pcidas_attach(struct comedi_device *dev,
 		s->type = COMEDI_SUBD_AO;
 		s->subdev_flags = SDF_READABLE | SDF_WRITABLE | SDF_GROUND;
 		s->n_chan = thisboard->ao_nchan;
-		/*  analog out resolution is the same as analog input resolution, so use ai_bits */
+		/*
+		 * analog out resolution is the same as
+		 * analog input resolution, so use ai_bits
+		 */
 		s->maxdata = (1 << thisboard->ai_bits) - 1;
 		s->range_table = &cb_pcidas_ao_ranges;
 		s->insn_read = cb_pcidas_ao_readback_insn;
-- 
1.7.11

