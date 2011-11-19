Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758119Ab1KSEhn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 23:37:43 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59220 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab1KSEhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 23:37:40 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 07/25] Staging: comedi: fix brace coding style issue in das16m1.c
Date: Sat, 19 Nov 2011 10:06:39 +0530
Message-Id: <1321677417-2415-7-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1321677417-2415-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1321677417-2415-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the das16m1.c file that fixes up a brace coding
warning found by the checkpatch.pl tool.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/das16m1.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das16m1.c b/drivers/staging/comedi/drivers/das16m1.c
index a5ce3b2..b8de374 100644
--- a/drivers/staging/comedi/drivers/das16m1.c
+++ b/drivers/staging/comedi/drivers/das16m1.c
@@ -384,20 +384,20 @@ static int das16m1_cmd_exec(struct comedi_device *dev,
 	byte = 0;
 	/* if we are using external start trigger (also board dislikes having
 	 * both start and conversion triggers external simultaneously) */
-	if (cmd->start_src == TRIG_EXT && cmd->convert_src != TRIG_EXT) {
+	if (cmd->start_src == TRIG_EXT && cmd->convert_src != TRIG_EXT)
 		byte |= EXT_TRIG_BIT;
-	}
+
 	outb(byte, dev->iobase + DAS16M1_CS);
 	/* clear interrupt bit */
 	outb(0, dev->iobase + DAS16M1_CLEAR_INTR);
 
 	/* enable interrupts and internal pacer */
 	devpriv->control_state &= ~PACER_MASK;
-	if (cmd->convert_src == TRIG_TIMER) {
+	if (cmd->convert_src == TRIG_TIMER)
 		devpriv->control_state |= INT_PACER;
-	} else {
+	else
 		devpriv->control_state |= EXT_PACER;
-	}
+
 	devpriv->control_state |= INTE;
 	outb(devpriv->control_state, dev->iobase + DAS16M1_INTR_CONTROL);
 
@@ -531,9 +531,8 @@ static void munge_sample_array(short *array, unsigned int num_elements)
 {
 	unsigned int i;
 
-	for (i = 0; i < num_elements; i++) {
+	for (i = 0; i < num_elements; i++)
 		array[i] = munge_sample(array[i]);
-	}
 }
 
 static void das16m1_handler(struct comedi_device *dev, unsigned int status)
-- 
1.7.0.4

