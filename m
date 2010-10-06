Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758333Ab0JFBBa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 21:01:30 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47044 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758310Ab0JFBB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 21:01:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=xANVJ/DW8G3N4KYAVhuqlBXgh7QF5PsW1apFIY/exj1GKelv1dwD4vjIS6hYhPZ/Ee
         cwdPG81huQw423lc7ed074dKKiBsuN5mBfNNjon0Fws2x2J3/UKYiGPgWVGfR0z/PWVJ
         Z8J4xqmPJcKy38+vfCtSGPMLInFIwR3u9hQ0g=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com, abbotti@mev.co.uk, fmhess@users.sourceforge.net
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 20/28] Staging: comedi: drivers: adl_pci9118.c: Edit file so that checkpatch.pl has 0 errors and warnings
Date: Tue,  5 Oct 2010 21:00:35 -0400
Message-Id: <1286326843-6170-20-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286326843-6170-1-git-send-email-tdent48227@gmail.com>
References: <1286326843-6170-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed a few lines that made checkpatch.pl complain. All warnings were
WARNING: please, no space for starting a line, ERROR: trailing whitespace,
WARNING: line over 80 characters, WARNING: unnecessary whitespace before a quoted newline,
and WARNING: please, no space before tabs.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/comedi/drivers/adl_pci9118.c |  118 +++++++++++++-------------
 1 files changed, 60 insertions(+), 58 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci9118.c b/drivers/staging/comedi/drivers/adl_pci9118.c
index b0e39cb..cdd2461 100644
--- a/drivers/staging/comedi/drivers/adl_pci9118.c
+++ b/drivers/staging/comedi/drivers/adl_pci9118.c
@@ -13,53 +13,55 @@ Driver: adl_pci9118
 Description: Adlink PCI-9118DG, PCI-9118HG, PCI-9118HR
 Author: Michal Dobes <dobes@tesnet.cz>
 Devices: [ADLink] PCI-9118DG (pci9118dg), PCI-9118HG (pci9118hg),
-  PCI-9118HR (pci9118hr)
+	PCI-9118HR (pci9118hr)
 Status: works
 
 This driver supports AI, AO, DI and DO subdevices.
 AI subdevice supports cmd and insn interface,
 other subdevices support only insn interface.
 For AI:
-- If cmd->scan_begin_src=TRIG_EXT then trigger input is TGIN (pin 46).
-- If cmd->convert_src=TRIG_EXT then trigger input is EXTTRG (pin 44).
-- If cmd->start_src/stop_src=TRIG_EXT then trigger input is TGIN (pin 46).
-- It is not neccessary to have cmd.scan_end_arg=cmd.chanlist_len but
-  cmd.scan_end_arg modulo cmd.chanlist_len must by 0.
-- If return value of cmdtest is 5 then you've bad channel list
-  (it isn't possible mixture S.E. and DIFF inputs or bipolar and unipolar
-  ranges).
+-	If cmd->scan_begin_src=TRIG_EXT then trigger input is TGIN (pin 46).
+-	If cmd->convert_src=TRIG_EXT then trigger input is EXTTRG (pin 44).
+-	If cmd->start_src/stop_src=TRIG_EXT then trigger input is TGIN (pin 46).
+-	It is not neccessary to have cmd.scan_end_arg=cmd.chanlist_len but
+	cmd.scan_end_arg modulo cmd.chanlist_len must by 0.
+-	If return value of cmdtest is 5 then you've bad channel list
+	(it isn't possible mixture S.E. and DIFF inputs or bipolar and unipolar
+	ranges).
 
 There are some hardware limitations:
-a) You cann't use mixture of unipolar/bipoar ranges or differencial/single
-   ended inputs.
-b) DMA transfers must have the length aligned to two samples (32 bit),
-   so there is some problems if cmd->chanlist_len is odd. This driver tries
-   bypass this with adding one sample to the end of the every scan and discard
-   it on output but this cann't be used if cmd->scan_begin_src=TRIG_FOLLOW
-   and is used flag TRIG_WAKE_EOS, then driver switch to interrupt driven mode
-   with interrupt after every sample.
-c) If isn't used DMA then you can use only mode where
-   cmd->scan_begin_src=TRIG_FOLLOW.
+a)	You cann't use mixture of unipolar/bipoar ranges or differencial/single
+	ended inputs.
+b	DMA transfers must have the length aligned to two samples (32 bit),
+	so there is some problems if cmd->chanlist_len is odd. This driver
+	tries bypass this with adding one sample to the end of the every
+	scan and discard it on output but this cann't be used if
+	cmd->scan_begin_src=TRIG_FOLLOW	and is used flag TRIG_WAKE_EOS, then
+	driver switch to interrupt driven mode with interrupt after every
+	sample.
+c)	If isn't used DMA then you can use only mode where
+	cmd->scan_begin_src=TRIG_FOLLOW.
 
 Configuration options:
-  [0] - PCI bus of device (optional)
-  [1] - PCI slot of device (optional)
-	If bus/slot is not specified, then first available PCI
-	card will be used.
-  [2] - 0= standard 8 DIFF/16 SE channels configuration
-	n = external multiplexer connected, 1 <= n <= 256
-  [3] - 0=autoselect DMA or EOC interrupts operation
-	1 = disable DMA mode
-	3 = disable DMA and INT, only insn interface will work
-  [4] - sample&hold signal - card can generate signal for external S&H board
-	0 = use SSHO(pin 45) signal is generated in onboard hardware S&H logic
-	0 != use ADCHN7(pin 23) signal is generated from driver, number say how
-		long delay is requested in ns and sign polarity of the hold
-		(in this case external multiplexor can serve only 128 channels)
-  [5] - 0=stop measure on all hardware errors
-	2 | = ignore ADOR - A/D Overrun status
-	8|=ignore Bover - A/D Burst Mode Overrun status
-	256|=ignore nFull - A/D FIFO Full status
+	[0] - PCI bus of device (optional)
+	[1] - PCI slot of device (optional)
+		If bus/slot is not specified, then first available PCI
+		card will be used.
+	[2] - 0= standard 8 DIFF/16 SE channels configuration
+		n = external multiplexer connected, 1 <= n <= 256
+	[3] - 0=autoselect DMA or EOC interrupts operation
+		1 = disable DMA mode
+		3 = disable DMA and INT, only insn interface will work
+	[4] - sample&hold signal - card can generate signal for external
+		S&H board 0 = use SSHO(pin 45) signal is generated in onboard
+		hardware S&H logic 0 != use ADCHN7(pin 23) signal is generated
+		from driver, number say how long delay is requested in ns and
+		sign polarity of the hold (in this case external multiplexor
+		can serve only 128 channels)
+	[5] - 0=stop measure on all hardware errors
+		2 | = ignore ADOR - A/D Overrun status
+		8|=ignore Bover - A/D Burst Mode Overrun status
+		256|=ignore nFull - A/D FIFO Full status
 
 */
 #include "../comedidev.h"
@@ -93,7 +95,7 @@ Configuration options:
 #define DPRINTK(fmt, args...)
 #endif
 
-#define IORANGE_9118 	64	/* I hope */
+#define IORANGE_9118	64	/* I hope */
 #define PCI9118_CHANLEN	255	/*
 				 * len of chanlist, some source say 256,
 				 * but reality looks like 255 :-(
@@ -1235,7 +1237,7 @@ static int Compute_and_setup_dma(struct comedi_device *dev)
 							 * align to 32bit down
 							 */
 	}
-	DPRINTK("2 dmalen0=%d dmalen1=%d \n", dmalen0, dmalen1);
+	DPRINTK("2 dmalen0=%d dmalen1=%d\n", dmalen0, dmalen1);
 
 	/* we want wake up every scan? */
 	if (devpriv->ai_flags & TRIG_WAKE_EOS) {
@@ -1295,7 +1297,7 @@ static int Compute_and_setup_dma(struct comedi_device *dev)
 		}
 	}
 
-	DPRINTK("3 dmalen0=%d dmalen1=%d \n", dmalen0, dmalen1);
+	DPRINTK("3 dmalen0=%d dmalen1=%d\n", dmalen0, dmalen1);
 	/* transfer without TRIG_WAKE_EOS */
 	if (!(devpriv->ai_flags & TRIG_WAKE_EOS)) {
 		/* if it's possible then allign DMA buffers to length of scan */
@@ -1323,13 +1325,13 @@ static int Compute_and_setup_dma(struct comedi_device *dev)
 			    ((devpriv->ai_n_realscanlen << 1) *
 			     devpriv->ai_scans)) {
 				DPRINTK
-				    ("3.0 ai_n_realscanlen=%d ai_scans=%d \n",
+				    ("3.0 ai_n_realscanlen=%d ai_scans=%d\n",
 				     devpriv->ai_n_realscanlen,
 				     devpriv->ai_scans);
 				dmalen0 =
 				    (devpriv->ai_n_realscanlen << 1) *
 				    devpriv->ai_scans;
-				DPRINTK("3.1 dmalen0=%d dmalen1=%d \n", dmalen0,
+				DPRINTK("3.1 dmalen0=%d dmalen1=%d\n", dmalen0,
 					dmalen1);
 				dmalen0 &= ~3L;
 			} else {	/*
@@ -1342,21 +1344,21 @@ static int Compute_and_setup_dma(struct comedi_device *dev)
 					dmalen1 =
 					    (devpriv->ai_n_realscanlen << 1) *
 					    devpriv->ai_scans - dmalen0;
-				DPRINTK("3.2 dmalen0=%d dmalen1=%d \n", dmalen0,
+				DPRINTK("3.2 dmalen0=%d dmalen1=%d\n", dmalen0,
 					dmalen1);
 				dmalen1 &= ~3L;
 			}
 		}
 	}
 
-	DPRINTK("4 dmalen0=%d dmalen1=%d \n", dmalen0, dmalen1);
+	DPRINTK("4 dmalen0=%d dmalen1=%d\n", dmalen0, dmalen1);
 
 	/* these DMA buffer size will be used */
 	devpriv->dma_actbuf = 0;
 	devpriv->dmabuf_use_size[0] = dmalen0;
 	devpriv->dmabuf_use_size[1] = dmalen1;
 
-	DPRINTK("5 dmalen0=%d dmalen1=%d \n", dmalen0, dmalen1);
+	DPRINTK("5 dmalen0=%d dmalen1=%d\n", dmalen0, dmalen1);
 #if 0
 	if (devpriv->ai_n_scanlen < this_board->half_fifo_size) {
 		devpriv->dmabuf_panic_size[0] =
@@ -1576,12 +1578,12 @@ static int pci9118_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	}
 
 	/* use sample&hold signal? */
-	if (cmd->convert_src == TRIG_NOW) {
+	if (cmd->convert_src == TRIG_NOW)
 		devpriv->usessh = 1;
-	} /* yes */
-	else {
+	/* yes */
+	else
 		devpriv->usessh = 0;
-	}			/*  no */
+				/*  no */
 
 	DPRINTK("1 neverending=%d scans=%u usessh=%d ai_startstop=0x%2x\n",
 		devpriv->ai_neverending, devpriv->ai_scans, devpriv->usessh,
@@ -1598,9 +1600,9 @@ static int pci9118_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		devpriv->usedma = 1;
 		if ((cmd->flags & TRIG_WAKE_EOS) &&
 		    (devpriv->ai_n_scanlen == 1)) {
-			if (cmd->convert_src == TRIG_NOW) {
+			if (cmd->convert_src == TRIG_NOW)
 				devpriv->ai_add_back = 1;
-			}
+
 			if (cmd->convert_src == TRIG_TIMER) {
 				devpriv->usedma = 0;
 					/*
@@ -1695,11 +1697,11 @@ static int pci9118_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		(cmd->scan_begin_src == TRIG_INT)) &&
 		(cmd->convert_src == TRIG_TIMER)) {
 					/* both timer is used for one time */
-		if (cmd->scan_begin_src == TRIG_EXT) {
+		if (cmd->scan_begin_src == TRIG_EXT)
 			devpriv->ai_do = 4;
-		} else {
+		else
 			devpriv->ai_do = 1;
-		}
+
 		pci9118_calc_divisors(devpriv->ai_do, dev, s,
 				      &cmd->scan_begin_arg, &cmd->convert_arg,
 				      devpriv->ai_flags,
@@ -1961,7 +1963,7 @@ static int setup_channel_list(struct comedi_device *dev,
 
 /*
 ==============================================================================
-  calculate 8254 divisors if they are used for dual timing
+	calculate 8254 divisors if they are used for dual timing
 */
 static void pci9118_calc_divisors(char mode, struct comedi_device *dev,
 				  struct comedi_subdevice *s,
@@ -2213,11 +2215,11 @@ static int pci9118_attach(struct comedi_device *dev,
 
 	opt_bus = it->options[0];
 	opt_slot = it->options[1];
-	if (it->options[3] & 1) {
+	if (it->options[3] & 1)
 		master = 0;	/* user don't want use bus master */
-	} else {
+	else
 		master = 1;
-	}
+
 
 	ret = alloc_private(dev, sizeof(struct pci9118_private));
 	if (ret < 0) {
-- 
1.7.3.1.50.g1e633

