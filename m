Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223Ab1LHMxW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 07:53:22 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36787 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864Ab1LHMxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 07:53:19 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 06/30] Staging: comedi: fix printk line over 80 character issue in daqboard2000.c
Date: Thu,  8 Dec 2011 18:22:01 +0530
Message-Id: <1323348745-31477-6-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323348745-31477-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1323348745-31477-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the daqboard2000.c file that fixes up a
line over 80 character warning found by the checkpatch.pl tool.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/daqboard2000.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/daqboard2000.c b/drivers/staging/comedi/drivers/daqboard2000.c
index fed8a3a..fb5ace8 100644
--- a/drivers/staging/comedi/drivers/daqboard2000.c
+++ b/drivers/staging/comedi/drivers/daqboard2000.c
@@ -414,7 +414,8 @@ static int daqboard2000_ai_insn_read(struct comedi_device *dev,
 
 	/* If pacer clock is not set to some high value (> 10 us), we
 	   risk multiple samples to be put into the result FIFO. */
-	fpga->acqPacerClockDivLow = 1000000;	/* 1 second, should be long enough */
+	/* 1 second, should be long enough */
+	fpga->acqPacerClockDivLow = 1000000;
 	fpga->acqPacerClockDivHigh = 0;
 
 	gain = CR_RANGE(insn->chanspec);
@@ -483,7 +484,9 @@ static int daqboard2000_ao_insn_write(struct comedi_device *dev,
 		 * OK, since it works OK without enabling the DAC's, let's keep
 		 * it as simple as possible...
 		 */
-		/* fpga->dacControl = (chan + 2) * 0x0010 | 0x0001; udelay(1000); */
+		/* fpga->dacControl = (chan + 2) * 0x0010 | 0x0001;
+		 * udelay(1000);
+		 */
 		fpga->dacSetting[chan] = data[i];
 		for (timeout = 0; timeout < 20; timeout++) {
 			if ((fpga->dacControl & ((chan + 1) * 0x0010)) == 0)
@@ -526,7 +529,8 @@ static void daqboard2000_pulseProgPin(struct comedi_device *dev)
 	writel(DAQBOARD2000_SECRProgPinHi, devpriv->plx + 0x6c);
 	udelay(10000);
 	writel(DAQBOARD2000_SECRProgPinLo, devpriv->plx + 0x6c);
-	udelay(10000);		/* Not in the original code, but I like symmetry... */
+	/* Not in the original code, but I like symmetry... */
+	udelay(10000);
 }
 
 static int daqboard2000_pollCPLD(struct comedi_device *dev, int mask)
-- 
1.7.0.4

