Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab2ADMk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 07:40:29 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47296 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686Ab2ADMk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 07:40:27 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com, rmallon@gmail.com, joe@perches.com,
        valdis.kletnieks@vt.edu,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 01/11] Staging: comedi: fix line over 80 character issue in daqboard2000.c
Date: Wed,  4 Jan 2012 18:09:56 +0530
Message-Id: <1325680806-10917-1-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the daqboard2000.c file that fixes up a line over 80
character warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/daqboard2000.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/daqboard2000.c b/drivers/staging/comedi/drivers/daqboard2000.c
index e61c6a8..2bbd121 100644
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
@@ -492,8 +495,10 @@ static int daqboard2000_ao_insn_write(struct comedi_device *dev,
 		}
 		devpriv->ao_readback[chan] = data[i];
 		/*
-		 * Since we never enabled the DAC's, we don't need to disable it...
-		 * fpga->dacControl = (chan + 2) * 0x0010 | 0x0000; udelay(1000);
+		 * Since we never enabled the DAC's, we don't need to
+		 * disable it...
+		 * fpga->dacControl = (chan + 2) * 0x0010 | 0x0000;
+		 * udelay(1000);
 		 */
 	}
 
-- 
1.7.0.4

