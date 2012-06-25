Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757998Ab2FYX7f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 19:59:35 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:56080 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757262Ab2FYX7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 19:59:34 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-131.messagelabs.com!1340668770!24311289!1
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 18/33] staging: comedi: cb_das16_cs: remove unused timer subdevice
Date: Mon, 25 Jun 2012 16:59:26 -0700
User-Agent: KMail/1.9.9
CC: <abbotti@mev.co.uk>, <fmhess@users.sourceforge.net>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206251659.26939.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The timer subdevice is never initialized due to the 'if (0)'. The
comedi callbacks also don't do anything and just return -EINVAL.

Remove the subdevice and associated code.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_das16_cs.c | 32 +---------------------------
 1 file changed, 1 insertion(+), 31 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_das16_cs.c b/drivers/staging/comedi/drivers/cb_das16_cs.c
index 36fd3e6..b0a2223 100644
--- a/drivers/staging/comedi/drivers/cb_das16_cs.c
+++ b/drivers/staging/comedi/drivers/cb_das16_cs.c
@@ -425,21 +425,6 @@ static int das16cs_dio_insn_config(struct comedi_device *dev,
 	return insn->n;
 }
 
-static int das16cs_timer_insn_read(struct comedi_device *dev,
-				   struct comedi_subdevice *s,
-				   struct comedi_insn *insn, unsigned int *data)
-{
-	return -EINVAL;
-}
-
-static int das16cs_timer_insn_config(struct comedi_device *dev,
-				     struct comedi_subdevice *s,
-				     struct comedi_insn *insn,
-				     unsigned int *data)
-{
-	return -EINVAL;
-}
-
 static const struct das16cs_board *das16cs_probe(struct comedi_device *dev,
 						 struct pcmcia_device *link)
 {
@@ -497,7 +482,7 @@ static int das16cs_attach(struct comedi_device *dev,
 	if (alloc_private(dev, sizeof(struct das16cs_private)) < 0)
 		return -ENOMEM;
 
-	ret = comedi_alloc_subdevices(dev, 4);
+	ret = comedi_alloc_subdevices(dev, 3);
 	if (ret)
 		return ret;
 
@@ -540,21 +525,6 @@ static int das16cs_attach(struct comedi_device *dev,
 		s->type = COMEDI_SUBD_UNUSED;
 	}
 
-	s = dev->subdevices + 3;
-	/* timer subdevice */
-	if (0) {
-		s->type = COMEDI_SUBD_TIMER;
-		s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
-		s->n_chan = 1;
-		s->maxdata = 0xff;
-		s->range_table = &range_unknown;
-		s->insn_read = das16cs_timer_insn_read;
-		s->insn_config = das16cs_timer_insn_config;
-	} else {
-		s->type = COMEDI_SUBD_UNUSED;
-	}
-
-
 	return 1;
 }
 
-- 
1.7.11

