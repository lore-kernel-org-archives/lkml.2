Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932869Ab1KHLRf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 06:17:35 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:45038 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932797Ab1KHLRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 06:17:11 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 19/20] Staging: comedi: fix brace coding style issue in daqboard2000.c
Date: Tue,  8 Nov 2011 16:45:29 +0530
Message-Id: <1320750930-9764-19-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1320750930-9764-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1320750930-9764-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the daqboard2000.c file that fixes up a brace
warning found by the checkpatch.pl tool.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/daqboard2000.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/comedi/drivers/daqboard2000.c b/drivers/staging/comedi/drivers/daqboard2000.c
index 82be77d..aef336f 100644
--- a/drivers/staging/comedi/drivers/daqboard2000.c
+++ b/drivers/staging/comedi/drivers/daqboard2000.c
@@ -430,16 +430,14 @@ static int daqboard2000_ai_insn_read(struct comedi_device *dev,
 		/* Enable reading from the scanlist FIFO */
 		fpga->acqControl = DAQBOARD2000_SeqStartScanList;
 		for (timeout = 0; timeout < 20; timeout++) {
-			if (fpga->acqControl & DAQBOARD2000_AcqConfigPipeFull) {
+			if (fpga->acqControl & DAQBOARD2000_AcqConfigPipeFull)
 				break;
-			}
 			/* udelay(2); */
 		}
 		fpga->acqControl = DAQBOARD2000_AdcPacerEnable;
 		for (timeout = 0; timeout < 20; timeout++) {
-			if (fpga->acqControl & DAQBOARD2000_AcqLogicScanning) {
+			if (fpga->acqControl & DAQBOARD2000_AcqLogicScanning)
 				break;
-			}
 			/* udelay(2); */
 		}
 		for (timeout = 0; timeout < 20; timeout++) {
@@ -465,10 +463,8 @@ static int daqboard2000_ao_insn_read(struct comedi_device *dev,
 	int i;
 	int chan = CR_CHAN(insn->chanspec);
 
-	for (i = 0; i < insn->n; i++) {
+	for (i = 0; i < insn->n; i++)
 		data[i] = devpriv->ao_readback[chan];
-	}
-
 	return i;
 }
 
@@ -490,9 +486,8 @@ static int daqboard2000_ao_insn_write(struct comedi_device *dev,
 		/* fpga->dacControl = (chan + 2) * 0x0010 | 0x0001; udelay(1000); */
 		fpga->dacSetting[chan] = data[i];
 		for (timeout = 0; timeout < 20; timeout++) {
-			if ((fpga->dacControl & ((chan + 1) * 0x0010)) == 0) {
+			if ((fpga->dacControl & ((chan + 1) * 0x0010)) == 0)
 				break;
-			}
 			/* udelay(2); */
 		}
 		devpriv->ao_readback[chan] = data[i];
@@ -605,7 +600,7 @@ static int initialize_daqboard2000(struct comedi_device *dev,
 			for (; i < len; i += 2) {
 				int data =
 				    (cpld_array[i] << 8) + cpld_array[i + 1];
-				if (!daqboard2000_writeCPLD(dev, data)) {
+				if (!daqboard2000_writeCPLD(dev, data))
 					break;
 				}
 			}
-- 
1.7.0.4

