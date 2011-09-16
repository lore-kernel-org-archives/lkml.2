Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab1IPWbd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 18:31:33 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:58393 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485Ab1IPWbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 18:31:31 -0400
From: Ramesh Raj <ramesh.v.raj@gmail.com>
To: gregkh@suse.de
Cc: abbotti@mev.co.uk, fmhess@users.sourceforge.net,
        fthain@telegraphics.com.au, hjk@linutronix.de, jkosina@suse.cz,
        blp@cs.stanford.edu, justinmattock@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ramesh Raj <ramesh.v.raj@gmail.com>
Subject: [PATCH] staging: comedi: fixed checkpatch errors and curly brace issues
Date: Fri, 16 Sep 2011 18:31:13 -0400
Message-Id: <1316212273-14940-1-git-send-email-ramesh.v.raj@gmail.com>
X-Mailer: git-send-email 1.7.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

daqboard2000.c: fixed checkpatch errors and curly brace issues.

Signed-off-by: Ramesh Raj <ramesh.v.raj@gmail.com>
---
 drivers/staging/comedi/drivers/daqboard2000.c |  144 +++++++++++++------------
 1 files changed, 74 insertions(+), 70 deletions(-)

diff --git a/drivers/staging/comedi/drivers/daqboard2000.c b/drivers/staging/comedi/drivers/daqboard2000.c
index 82be77d..4311b83 100644
--- a/drivers/staging/comedi/drivers/daqboard2000.c
+++ b/drivers/staging/comedi/drivers/daqboard2000.c
@@ -51,11 +51,10 @@ Configuration options:
    for the card, and here are the findings so far.
 
    1. A good document that describes the PCI interface chip is 9080db-106.pdf
-      available from http://www.plxtech.com/products/io/pci9080 
+	available from http://www.plxtech.com/products/io/pci9080
 
    2. The initialization done so far is:
-        a. program the FPGA (windows code sans a lot of error messages)
-	b.
+	a. program the FPGA (windows code sans a lot of error messages)
 
    3. Analog out seems to work OK with DAC's disabled, if DAC's are enabled,
       you have to output values to all enabled DAC's until result appears, I
@@ -63,52 +62,52 @@ Configuration options:
       gives me no clues. I'll keep it simple so far.
 
    4. Analog in.
-        Each channel in the scanlist seems to be controlled by four
+	Each channel in the scanlist seems to be controlled by four
 	control words:
 
-        Word0:
-          +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
-          ! | | | ! | | | ! | | | ! | | | !
-          +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+	Word0:
+	  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+	  ! | | | ! | | | ! | | | ! | | | !
+	  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 
-        Word1:
-          +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
-          ! | | | ! | | | ! | | | ! | | | !
-          +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+	Word1:
+	  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+	  ! | | | ! | | | ! | | | ! | | | !
+	  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 	   |             |       | | | | |
-           +------+------+       | | | | +-- Digital input (??)
+	   +------+------+       | | | | +-- Digital input (??)
 		  |		 | | | +---- 10 us settling time
 		  |		 | | +------ Suspend acquisition (last to scan)
 		  |		 | +-------- Simultaneous sample and hold
 		  |		 +---------- Signed data format
 		  +------------------------- Correction offset low
 
-        Word2:
-          +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
-          ! | | | ! | | | ! | | | ! | | | !
-          +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
-           |     | |     | | | | | |     |
-           +-----+ +--+--+ +++ +++ +--+--+
-              |       |     |   |     +----- Expansion channel
+	Word2:
+	  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+	  ! | | | ! | | | ! | | | ! | | | !
+	  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+	   |     | |     | | | | | |     |
+	   +-----+ +--+--+ +++ +++ +--+--+
+	      |       |     |   |     +----- Expansion channel
 	      |       |     |   +----------- Expansion gain
-              |       |     +--------------- Channel (low)
+	      |       |     +--------------- Channel (low)
 	      |       +--------------------- Correction offset high
 	      +----------------------------- Correction gain low
-        Word3:
-          +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
-          ! | | | ! | | | ! | | | ! | | | !
-          +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
-           |             | | | |   | | | |
-           +------+------+ | | +-+-+ | | +-- Low bank enable
-                  |        | |   |   | +---- High bank enable
-                  |        | |   |   +------ Hi/low select
-		  |    	   | |   +---------- Gain (1,?,2,4,8,16,32,64)
-		  |    	   | +-------------- differential/single ended
-		  |    	   +---------------- Unipolar
+	Word3:
+	  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+	  ! | | | ! | | | ! | | | ! | | | !
+	  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+	   |             | | | |   | | | |
+	   +------+------+ | | +-+-+ | | +-- Low bank enable
+		  |        | |   |   | +---- High bank enable
+		  |        | |   |   +------ Hi/low select
+		  |        | |   +---------- Gain (1,?,2,4,8,16,32,64)
+		  |        | +-------------- differential/single ended
+		  |        +---------------- Unipolar
 		  +------------------------- Correction gain high
 
    999. The card seems to have an incredible amount of capabilities, but
-        trying to reverse engineer them from the Windows source is beyond my
+	trying to reverse engineer them from the Windows source is beyond my
 	patience.
 
  */
@@ -121,11 +120,11 @@ Configuration options:
 #include "comedi_pci.h"
 #include "8255.h"
 
-#define DAQBOARD2000_SUBSYSTEM_IDS2 	0x00021616	/* Daqboard/2000 - 2 Dacs */
-#define DAQBOARD2000_SUBSYSTEM_IDS4 	0x00041616	/* Daqboard/2000 - 4 Dacs */
+#define DAQBOARD2000_SUBSYSTEM_IDS2     0x00021616 /* Daqboard/2000 - 2 Dacs */
+#define DAQBOARD2000_SUBSYSTEM_IDS4     0x00041616 /* Daqboard/2000 - 4 Dacs */
 
-#define DAQBOARD2000_DAQ_SIZE 		0x1002
-#define DAQBOARD2000_PLX_SIZE 		0x100
+#define DAQBOARD2000_DAQ_SIZE           0x1002
+#define DAQBOARD2000_PLX_SIZE           0x100
 
 /* Initialization bits for the Serial EEPROM Control Register */
 #define DAQBOARD2000_SECRProgPinHi      0x8001767e
@@ -136,11 +135,11 @@ Configuration options:
 #define DAQBOARD2000_SECRReloadLo       0x8000767e
 
 /* SECR status bits */
-#define DAQBOARD2000_EEPROM_PRESENT     0x10000000
+#define DAQBOARD2000_EEPROM_PRESENT	0x10000000
 
 /* CPLD status bits */
-#define DAQBOARD2000_CPLD_INIT 		0x0002
-#define DAQBOARD2000_CPLD_DONE 		0x0004
+#define DAQBOARD2000_CPLD_INIT          0x0002
+#define DAQBOARD2000_CPLD_DONE          0x0004
 
 /* Available ranges */
 static const struct comedi_lrange range_daqboard2000_ai = { 13, {
@@ -415,7 +414,7 @@ static int daqboard2000_ai_insn_read(struct comedi_device *dev,
 
 	/* If pacer clock is not set to some high value (> 10 us), we
 	   risk multiple samples to be put into the result FIFO. */
-	fpga->acqPacerClockDivLow = 1000000;	/* 1 second, should be long enough */
+	fpga->acqPacerClockDivLow = 1000000;/* 1 second, should be long enough*/
 	fpga->acqPacerClockDivHigh = 0;
 
 	gain = CR_RANGE(insn->chanspec);
@@ -430,16 +429,16 @@ static int daqboard2000_ai_insn_read(struct comedi_device *dev,
 		/* Enable reading from the scanlist FIFO */
 		fpga->acqControl = DAQBOARD2000_SeqStartScanList;
 		for (timeout = 0; timeout < 20; timeout++) {
-			if (fpga->acqControl & DAQBOARD2000_AcqConfigPipeFull) {
+			if (fpga->acqControl & DAQBOARD2000_AcqConfigPipeFull)
 				break;
-			}
+
 			/* udelay(2); */
 		}
 		fpga->acqControl = DAQBOARD2000_AdcPacerEnable;
 		for (timeout = 0; timeout < 20; timeout++) {
-			if (fpga->acqControl & DAQBOARD2000_AcqLogicScanning) {
+			if (fpga->acqControl & DAQBOARD2000_AcqLogicScanning)
 				break;
-			}
+
 			/* udelay(2); */
 		}
 		for (timeout = 0; timeout < 20; timeout++) {
@@ -465,9 +464,8 @@ static int daqboard2000_ao_insn_read(struct comedi_device *dev,
 	int i;
 	int chan = CR_CHAN(insn->chanspec);
 
-	for (i = 0; i < insn->n; i++) {
+	for (i = 0; i < insn->n; i++)
 		data[i] = devpriv->ao_readback[chan];
-	}
 
 	return i;
 }
@@ -487,18 +485,22 @@ static int daqboard2000_ao_insn_write(struct comedi_device *dev,
 		 * OK, since it works OK without enabling the DAC's, let's keep
 		 * it as simple as possible...
 		 */
-		/* fpga->dacControl = (chan + 2) * 0x0010 | 0x0001; udelay(1000); */
+
+		/* fpga->dacControl = (chan + 2) * 0x0010 | 0x0001;
+		 * udelay(1000);
+		 */
 		fpga->dacSetting[chan] = data[i];
 		for (timeout = 0; timeout < 20; timeout++) {
-			if ((fpga->dacControl & ((chan + 1) * 0x0010)) == 0) {
+			if ((fpga->dacControl & ((chan + 1) * 0x0010)) == 0)
 				break;
-			}
+
 			/* udelay(2); */
 		}
 		devpriv->ao_readback[chan] = data[i];
 		/*
-		 * Since we never enabled the DAC's, we don't need to disable it...
-		 * fpga->dacControl = (chan + 2) * 0x0010 | 0x0000; udelay(1000);
+		 * Since we never enabled the DAC's, we don't need to disable it
+		 * fpga->dacControl = (chan + 2) * 0x0010 | 0x0000;
+		 * udelay(1000);
 		 */
 	}
 
@@ -531,7 +533,7 @@ static void daqboard2000_pulseProgPin(struct comedi_device *dev)
 	writel(DAQBOARD2000_SECRProgPinHi, devpriv->plx + 0x6c);
 	udelay(10000);
 	writel(DAQBOARD2000_SECRProgPinLo, devpriv->plx + 0x6c);
-	udelay(10000);		/* Not in the original code, but I like symmetry... */
+	udelay(10000);	/* Not in the original code, but I like symmetry... */
 }
 
 static int daqboard2000_pollCPLD(struct comedi_device *dev, int mask)
@@ -605,9 +607,8 @@ static int initialize_daqboard2000(struct comedi_device *dev,
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
@@ -658,9 +659,9 @@ static void daqboard2000_activateReferenceDacs(struct comedi_device *dev)
 	/*  Set the + reference dac value in the FPGA */
 	fpga->refDacs = 0x80 | DAQBOARD2000_PosRefDacSelect;
 	for (timeout = 0; timeout < 20; timeout++) {
-		if ((fpga->dacControl & DAQBOARD2000_RefBusy) == 0) {
+		if ((fpga->dacControl & DAQBOARD2000_RefBusy) == 0)
 			break;
-		}
+
 		udelay(2);
 	}
 /*  printk("DAQBOARD2000_PosRefDacSelect %d\n", timeout);*/
@@ -668,9 +669,9 @@ static void daqboard2000_activateReferenceDacs(struct comedi_device *dev)
 	/*  Set the - reference dac value in the FPGA */
 	fpga->refDacs = 0x80 | DAQBOARD2000_NegRefDacSelect;
 	for (timeout = 0; timeout < 20; timeout++) {
-		if ((fpga->dacControl & DAQBOARD2000_RefBusy) == 0) {
+		if ((fpga->dacControl & DAQBOARD2000_RefBusy) == 0)
 			break;
-		}
+
 		udelay(2);
 	}
 /*  printk("DAQBOARD2000_NegRefDacSelect %d\n", timeout);*/
@@ -707,7 +708,11 @@ static void daqboard2000_initializeDac(struct comedi_device *dev)
 /*
 The test command, REMOVE!!:
 
-rmmod daqboard2000 ; rmmod comedi; make install ; modprobe daqboard2000; /usr/sbin/comedi_config /dev/comedi0 daqboard/2000 ; tail -40 /var/log/messages
+rmmod daqboard2000;
+* rmmod comedi; make install ;
+* modprobe daqboard2000;
+* /usr/sbin/comedi_config /dev/comedi0 daqboard/2000 ;
+* tail -40 /var/log/messages
 */
 
 static int daqboard2000_8255_cb(int dir, int port, int data,
@@ -722,7 +727,7 @@ static int daqboard2000_8255_cb(int dir, int port, int data,
 	}
 /*
   printk("daqboard2000_8255_cb %x %d %d %2.2x -> %2.2x\n",
-        arg, dir, port, data, result);
+	arg, dir, port, data, result);
 */
 	return result;
 }
@@ -743,9 +748,9 @@ static int daqboard2000_attach(struct comedi_device *dev,
 	slot = it->options[1];
 
 	result = alloc_private(dev, sizeof(struct daqboard2000_private));
-	if (result < 0) {
+	if (result < 0)
 		return -ENOMEM;
-	}
+
 	for (card = pci_get_device(0x1616, 0x0409, NULL);
 	     card != NULL; card = pci_get_device(0x1616, 0x0409, card)) {
 		if (bus || slot) {
@@ -778,7 +783,7 @@ static int daqboard2000_attach(struct comedi_device *dev,
 		}
 		if (!dev->board_ptr) {
 			printk
-			    (" unknown subsystem id %08x (pretend it is an ids2)",
+			   ("unknown subsystem id %08x (pretend it is an ids2)",
 			     id);
 			dev->board_ptr = boardtypes;
 		}
@@ -794,9 +799,8 @@ static int daqboard2000_attach(struct comedi_device *dev,
 	    ioremap(pci_resource_start(card, 0), DAQBOARD2000_PLX_SIZE);
 	devpriv->daq =
 	    ioremap(pci_resource_start(card, 2), DAQBOARD2000_DAQ_SIZE);
-	if (!devpriv->plx || !devpriv->daq) {
+	if (!devpriv->plx || !devpriv->daq)
 		return -ENOMEM;
-	}
 
 	result = alloc_subdevices(dev, 3);
 	if (result < 0)
@@ -869,18 +873,18 @@ static int daqboard2000_detach(struct comedi_device *dev)
 	if (dev->subdevices)
 		subdev_8255_cleanup(dev, dev->subdevices + 2);
 
-	if (dev->irq) {
+	if (dev->irq)
 		free_irq(dev->irq, dev);
-	}
+
 	if (devpriv) {
 		if (devpriv->daq)
 			iounmap(devpriv->daq);
 		if (devpriv->plx)
 			iounmap(devpriv->plx);
 		if (devpriv->pci_dev) {
-			if (devpriv->got_regions) {
+			if (devpriv->got_regions)
 				comedi_pci_disable(devpriv->pci_dev);
-			}
+
 			pci_dev_put(devpriv->pci_dev);
 		}
 	}
-- 
1.7.6.1

