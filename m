Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab2DZKDI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 06:03:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44048 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755437Ab2DZKDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 06:03:06 -0400
From: Ravishankar Karkala Mallikarjunayya <ravishankarkm32@gmail.com>
To: gregkh@linuxfoundation.org, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 4/4] Staging: comedi: fix line over 80 character issue in ni_at_a2150.c
Date: Thu, 26 Apr 2012 15:32:20 +0530
Message-Id: <1335434540-13286-5-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1335434540-13286-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1335434540-13286-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the ni_at_a2150.c file that fixes up a line
over 80 character warning found by the checkpatch.pl tool.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/ni_at_a2150.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_at_a2150.c b/drivers/staging/comedi/drivers/ni_at_a2150.c
index 32e675e..80416b6 100644
--- a/drivers/staging/comedi/drivers/ni_at_a2150.c
+++ b/drivers/staging/comedi/drivers/ni_at_a2150.c
@@ -539,7 +539,10 @@ static int a2150_ai_cmdtest(struct comedi_device *dev,
 	if (err)
 		return 1;
 
-	/* step 2: make sure trigger sources are unique and mutually compatible */
+	/*
+	 * step 2: make sure trigger sources are unique and mutually
+	 * compatible
+	 */
 
 	if (cmd->start_src != TRIG_NOW && cmd->start_src != TRIG_EXT)
 		err++;
@@ -772,7 +775,10 @@ static int a2150_ai_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
 	/*  start acquisition for soft trigger */
 	outw(0, dev->iobase + FIFO_START_REG);
 
-	/* there is a 35.6 sample delay for data to get through the antialias filter */
+	/*
+	 * there is a 35.6 sample delay for data to get through the
+	 * antialias filter
+	 */
 	for (n = 0; n < filter_delay; n++) {
 		for (i = 0; i < timeout; i++) {
 			if (inw(dev->iobase + STATUS_REG) & FNE_BIT)
@@ -813,8 +819,10 @@ static int a2150_ai_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
 	return n;
 }
 
-/* sets bits in devpriv->clock_bits to nearest approximation of requested period,
- * adjusts requested period to actual timing. */
+/*
+ * sets bits in devpriv->clock_bits to nearest approximation of requested
+ * period, adjusts requested period to actual timing.
+ */
 static int a2150_get_timing(struct comedi_device *dev, unsigned int *period,
 			    int flags)
 {
-- 
1.7.0.4

