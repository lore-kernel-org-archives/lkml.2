Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518Ab1GHK4S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 06:56:18 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64296 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620Ab1GHK4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 06:56:14 -0400
From: hankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH 3/3] Staging: comedi: fix line over 80 character  issue in rtd520.c
Date: Fri,  8 Jul 2011 16:38:31 +0530
Message-Id: <1310123311-15929-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <[PATCH]Staging: comedi: fix line over 80 character issue in rtd520.c>
References: <[PATCH]Staging: comedi: fix line over 80 character issue in rtd520.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the rtd520.c file that fixes up a  warning: line over 80 character found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/rtd520.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 44dbf43..dd00b4a 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -1026,7 +1026,8 @@ static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		}
 
 		RtdDma0Mode(dev, DMA_MODE_BITS);
-		RtdDma0Source(dev, DMAS_ADFIFO_HALF_FULL);	/* set DMA trigger source */
+		/* set DMA trigger source */
+		RtdDma0Source(dev, DMAS_ADFIFO_HALF_FULL);
 	} else {
 		printk(KERN_INFO "( no IRQ->no DMA )");
 	}
@@ -1202,11 +1203,13 @@ static unsigned short rtdConvertChanGain(struct comedi_device *dev,
 		CHAN_ARRAY_SET(devpriv->chanBipolar, chanIndex);
 	} else if (range < thisboard->rangeUniStart) {	/* second batch are +-10 */
 		r |= 0x100;	/* +-10 range */
-		r |= ((range - thisboard->range10Start) & 0x7) << 4;	/* gain */
+		/* gain */
+		r |= ((range - thisboard->range10Start) & 0x7) << 4;
 		CHAN_ARRAY_SET(devpriv->chanBipolar, chanIndex);
 	} else {		/* last batch is +10 */
 		r |= 0x200;	/* +10 range */
-		r |= ((range - thisboard->rangeUniStart) & 0x7) << 4;	/* gain */
+		/* gain */
+		r |= ((range - thisboard->rangeUniStart) & 0x7) << 4;
 		CHAN_ARRAY_CLEAR(devpriv->chanBipolar, chanIndex);
 	}
 
@@ -1336,7 +1339,8 @@ static int rtd_ai_rinsn(struct comedi_device *dev,
 		/*printk ("rtd520: Got 0x%x after %d usec\n", d, ii+1); */
 		d = d >> 3;	/* low 3 bits are marker lines */
 		if (CHAN_ARRAY_TEST(devpriv->chanBipolar, 0))
-			data[n] = d + 2048;	/* convert to comedi unsigned data */
+			/* convert to comedi unsigned data */
+			data[n] = d + 2048;
 		else
 			data[n] = d;
 	}
-- 
1.6.5.2

