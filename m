Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751393Ab1GHKZV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 06:25:21 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:37877 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab1GHKZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 06:25:18 -0400
From: ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH 2/2] Staging: comedi: fix wraning:line over 80 character  issue in rtd520.c
Date: Fri,  8 Jul 2011 16:07:39 +0530
Message-Id: <1310121459-12788-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <[PATCH]Staging: comedi: fix line over 80 character warning issues in rtd520.c>
References: <[PATCH]Staging: comedi: fix line over 80 character warning issues in rtd520.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the rtd520.c file that fixes up a line over 80 charcter warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/rtd520.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 7f09ed7..44dbf43 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -1403,7 +1403,8 @@ static int ai_read_dregs(struct comedi_device *dev, struct comedi_subdevice *s)
 
 		d = d >> 3;	/* low 3 bits are marker lines */
 		if (CHAN_ARRAY_TEST(devpriv->chanBipolar, s->async->cur_chan))
-			sample = d + 2048;	/* convert to comedi unsigned data */
+			/* convert to comedi unsigned data */
+			sample = d + 2048;
 		else
 			sample = d;
 
@@ -1491,9 +1492,11 @@ static int ai_process_dma(struct comedi_device *dev, struct comedi_subdevice *s)
 		short sample;
 
 		if (CHAN_ARRAY_TEST(devpriv->chanBipolar, s->async->cur_chan)) {
-			sample = (*dp >> 3) + 2048;	/* convert to comedi unsigned data */
+			/* convert to comedi unsigned data */
+			sample = (*dp >> 3) + 2048;
 		else
-			sample = *dp >> 3;	/* low 3 bits are marker lines */
+			/* low 3 bits are marker lines */
+			sample = *dp >> 3;
 
 		*dp++ = sample;	/* put processed value back */
 
@@ -1543,7 +1546,8 @@ static irqreturn_t rtd_interrupt(int irq,	/* interrupt number (ignored) */
 	struct comedi_device *dev = d;	/* must be called "dev" for devpriv */
 	u16 status;
 	u16 fifoStatus;
-	struct comedi_subdevice *s = dev->subdevices + 0;	/* analog in subdevice */
+	/* analog in subdevice */
+	struct comedi_subdevice *s = dev->subdevices + 0;
 
 	if (!dev->attached)
 		return IRQ_NONE;
-- 
1.6.5.2

