Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217Ab1LHMxD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 07:53:03 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:63777 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905Ab1LHMw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 07:52:58 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 02/30] Staging: comedi: fix brace coding style issue in daqboard2000.c
Date: Thu,  8 Dec 2011 18:21:57 +0530
Message-Id: <1323348745-31477-2-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323348745-31477-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1323348745-31477-1-git-send-email-ravishankar.km@greenturtles.in>
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
index 9958bd5..a16060e 100644
--- a/drivers/staging/comedi/drivers/daqboard2000.c
+++ b/drivers/staging/comedi/drivers/daqboard2000.c
@@ -429,16 +429,14 @@ static int daqboard2000_ai_insn_read(struct comedi_device *dev,
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
@@ -464,9 +462,8 @@ static int daqboard2000_ao_insn_read(struct comedi_device *dev,
 	int i;
 	int chan = CR_CHAN(insn->chanspec);
 
-	for (i = 0; i < insn->n; i++) {
+	for (i = 0; i < insn->n; i++)
 		data[i] = devpriv->ao_readback[chan];
-	}
 
 	return i;
 }
@@ -489,9 +486,8 @@ static int daqboard2000_ao_insn_write(struct comedi_device *dev,
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
@@ -604,9 +600,8 @@ static int initialize_daqboard2000(struct comedi_device *dev,
 			for (; i < len; i += 2) {
 				int data =
 				    (cpld_array[i] << 8) + cpld_array[i + 1];
-				if (!daqboard2000_writeCPLD(dev, data)) {
+				if (!daqboard2000_writeCPLD(dev, data))
 					break;
-				}
 			}
 			if (i >= len) {
 #ifdef DEBUG_EEPROM
-- 
1.7.0.4

