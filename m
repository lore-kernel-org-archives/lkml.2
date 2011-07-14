Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392Ab1GNGrE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 02:47:04 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54131 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213Ab1GNGrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 02:47:02 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH 3/3] Staging: comedi: fix warning issue in daqboard2000.c
Date: Thu, 14 Jul 2011 12:29:42 +0530
Message-Id: <1310626782-21613-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <[PATCH 3/3]Staging: comedi:fix line over 80 character issue in daqboard2000.c>
References: <[PATCH 3/3]Staging: comedi:fix line over 80 character issue in daqboard2000.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the daqboard2000.c file that fixes up a  warning:line over 80 character found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/daqboard2000.c |   20 ++++++++++++--------
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/daqboard2000.c b/drivers/staging/comedi/drivers/daqboard2000.c
index 12ccdae..b007a4b 100644
--- a/drivers/staging/comedi/drivers/daqboard2000.c
+++ b/drivers/staging/comedi/drivers/daqboard2000.c
@@ -415,7 +416,8 @@ static int daqboard2000_ai_insn_read(struct comedi_device *dev,
 
 	/* If pacer clock is not set to some high value (> 10 us), we
 	   risk multiple samples to be put into the result FIFO. */
-	fpga->acqPacerClockDivLow = 1000000;	/* 1 second, should be long enough */
+	/* 1 second, should be long enough */
+	fpga->acqPacerClockDivLow = 1000000;
 	fpga->acqPacerClockDivHigh = 0;
 
 	gain = CR_RANGE(insn->chanspec);
@@ -481,10 +483,11 @@ static int daqboard2000_ao_insn_write(struct comedi_device *dev,
 
 	for (i = 0; i < insn->n; i++) {
 		/*
-		 * OK, since it works OK without enabling the DAC's, let's keep
-		 * it as simple as possible...
+		 * OK, since it works OK without enabling the DAC's, let's
+		 * keep it as simple as possible...
 		 */
-		/* fpga->dacControl = (chan + 2) * 0x0010 | 0x0001; udelay(1000); */
+		/* fpga->dacControl = (chan + 2) * 0x0010 | 0x0001;
+		 * udelay(1000); */
 		fpga->dacSetting[chan] = data[i];
 		for (timeout = 0; timeout < 20; timeout++) {
 			if ((fpga->dacControl & ((chan + 1) * 0x0010)) == 0)
@@ -700,7 +703,8 @@ static void daqboard2000_initializeDac(struct comedi_device *dev)
 /*
 The test command, REMOVE!!:
 
-rmmod daqboard2000 ; rmmod comedi; make install ; modprobe daqboard2000; /usr/sbin/comedi_config /dev/comedi0 daqboard/2000 ; tail -40 /var/log/messages
+rmmod daqboard2000 ; rmmod comedi; make install ; modprobe daqboard2000;
+/usr/sbin/comedi_config /dev/comedi0 daqboard/2000 ; tail -40 /var/log/messages
 */
 
 static int daqboard2000_8255_cb(int dir, int port, int data,
-- 
1.6.5.2

