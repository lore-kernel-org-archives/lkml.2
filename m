Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867Ab1GGIYx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 04:24:53 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44365 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384Ab1GGIYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 04:24:50 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH 6/6] Staging: comedi: fix warning issue in unioxx5.c
Date: Thu,  7 Jul 2011 14:06:57 +0530
Message-Id: <1310027817-2438-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <[PATCH 2/2]Staging: comedi:fix warning issues in unioxx5.c>
References: <[PATCH 2/2]Staging: comedi:fix warning issues in unioxx5.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the unioxx5.c file that fixes up a  warning: line over 80 character by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/unioxx5.c |   30 +++++++++++++++++++++---------
 1 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/comedi/drivers/unioxx5.c b/drivers/staging/comedi/drivers/unioxx5.c
index 9b311c7..88dafb7 100644
--- a/drivers/staging/comedi/drivers/unioxx5.c
+++ b/drivers/staging/comedi/drivers/unioxx5.c
@@ -207,7 +207,9 @@ static int unioxx5_subdev_write(struct comedi_device *dev,
 	int channel, type;
 
 	channel = CR_CHAN(insn->chanspec);
-	type = usp->usp_module_type[channel / 2];	/* defining module type(analog or digital) */
+	type = usp->usp_module_type[channel / 2];	/* defining module type
+							 * (analog or digital)
+							*/
 
 	if (type == MODULE_DIGITAL) {
 		if (!__unioxx5_digital_write(usp, data, channel, dev->minor))
@@ -266,9 +268,13 @@ static int unioxx5_insn_config(struct comedi_device *dev,
 	 * change channel type on input or output)                *
 	 \*                                                        */
 	outb(1, usp->usp_iobase + 0);
-	outb(flags, usp->usp_iobase + channel_offset);	/* changes type of _one_ channel */
+	outb(flags, usp->usp_iobase + channel_offset);	/* changes type of
+							 * _one_ channel
+							*/
@@ -316,7 +322,9 @@ static int __unioxx5_subdev_init(struct comedi_subdevice *subdev,
 		to = 10000;
 
 		__unioxx5_analog_config(usp, i * 2);
-		outb(i + 1, subdev_iobase + 5);	/* sends channel number to card */
+		outb(i + 1, subdev_iobase + 5);	/* sends channel number
+						 * to card
+						*/
 		outb('H', subdev_iobase + 6);	/* requests EEPROM world */
 		while (!(inb(subdev_iobase + 0) & TxBE))
 			;	/* waits while writting will be allowed */
@@ -372,15 +381,18 @@ static int __unioxx5_digital_write(struct unioxx5_subd_priv *usp,
 		return 0;
 	}
 
-	val = usp->usp_prev_wr_val[channel_offset - 1];	/* getting previous written value */
-
+	val = usp->usp_prev_wr_val[channel_offset - 1];	/* getting previous
+							 * written value
+							*/
 	if (*data)
 		val |= mask;
 	else
 		val &= ~mask;
 
 	outb(val, usp->usp_iobase + channel_offset);
-	usp->usp_prev_wr_val[channel_offset - 1] = val;	/* saving new written value */
+	usp->usp_prev_wr_val[channel_offset - 1] = val;	/* saving new written
+							 * value
+							*/
 	return 1;
 }
 
-- 
1.6.5.2

