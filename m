Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524Ab0GFCSy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 22:18:54 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59830 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457Ab0GFCSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 22:18:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=vZOMoXifq7atmwrtfLAgUlCSIJe6C5dX8zoDZ9PMn9e6m/ZGWZhDM06wy1yeOrCvDh
         nJIptEkAQdv4QMAD49sJOLiN//SKvGQYGf9H9bi8G+X7YgLagDMNR3mf9JbDGJ1Wz8pO
         bXiiJTFuJmW0lHHL7d6d00vNjMA6G1412Y5e8=
From: Mark <reodge@gmail.com>
To: gregkh@suse.de
Cc: Mark <reodge@gmail.com>, Ian Abbott <abbotti@mev.co.uk>,
       Arun Thomas <arun.thomas@gmail.com>, Jason Wong <tsanghan@gmail.com>,
       =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: comedi: Cleanup adv_pci1710.c from checkpatch.pl
Date: Tue,  6 Jul 2010 03:18:19 +0100
Message-Id: <1278382699-23769-1-git-send-email-reodge@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleans up some issues discovered by checkpatch.pl

Signed-off-by: Mark Rankilor <reodge@gmail.com>
---
 drivers/staging/comedi/drivers/adv_pci1710.c |   47 +++++++++++++++----------
 1 files changed, 28 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci1710.c b/drivers/staging/comedi/drivers/adv_pci1710.c
index 2791f90..bdd6954 100644
--- a/drivers/staging/comedi/drivers/adv_pci1710.c
+++ b/drivers/staging/comedi/drivers/adv_pci1710.c
@@ -19,7 +19,7 @@
 /*
 Driver: adv_pci1710
 Description: Advantech PCI-1710, PCI-1710HG, PCI-1711, PCI-1713,
-             Advantech PCI-1720, PCI-1731
+	     Advantech PCI-1720, PCI-1731
 Author: Michal Dobes <dobes@tesnet.cz>
 Devices: [Advantech] PCI-1710 (adv_pci1710), PCI-1710HG (pci1710hg),
   PCI-1711 (adv_pci1710), PCI-1713, PCI-1720,
@@ -37,8 +37,8 @@ PCI driver.
 Configuration options:
   [0] - PCI bus of device (optional)
   [1] - PCI slot of device (optional)
-          If bus/slot is not specified, the first available PCI
-          device will be used.
+	If bus/slot is not specified, the first available PCI
+	device will be used.
 */
 
 #include <linux/interrupt.h>
@@ -50,7 +50,9 @@ Configuration options:
 #include "8253.h"
 #include "amcc_s5933.h"
 
-#define PCI171x_PARANOIDCHECK	/* if defined, then is used code which control correct channel number on every 12 bit sample */
+#define PCI171x_PARANOIDCHECK	/* if defined, then is used code which control
+				 * correct channel number on every 12 bit
+				 * sample */
 
 #undef PCI171X_EXTDEBUG
 
@@ -70,8 +72,8 @@ Configuration options:
 #define TYPE_PCI1713	2
 #define TYPE_PCI1720	3
 
-#define IORANGE_171x 	32
-#define IORANGE_1720 	16
+#define IORANGE_171x	32
+#define IORANGE_1720	16
 
 #define PCI171x_AD_DATA	 0	/* R:   A/D data */
 #define PCI171x_SOFTTRG	 0	/* W:   soft trigger for A/D */
@@ -91,13 +93,15 @@ Configuration options:
 #define PCI171x_CNT2	28	/* R/W: 8254 counter 2 */
 #define PCI171x_CNTCTRL	30	/* W:   8254 counter control */
 
-/* upper bits from status register (PCI171x_STATUS) (lower is same woth control reg) */
+/* upper bits from status register (PCI171x_STATUS) (lower is same with control
+ * reg) */
 #define	Status_FE	0x0100	/* 1=FIFO is empty */
 #define Status_FH	0x0200	/* 1=FIFO is half full */
 #define Status_FF	0x0400	/* 1=FIFO is full, fatal error */
 #define Status_IRQ	0x0800	/* 1=IRQ occured */
 /* bits from control register (PCI171x_CONTROL) */
-#define Control_CNT0	0x0040	/* 1=CNT0 have external source, 0=have internal 100kHz source */
+#define Control_CNT0	0x0040	/* 1=CNT0 have external source,
+				 * 0=have internal 100kHz source */
 #define Control_ONEFH	0x0020	/* 1=IRQ on FIFO is half full, 0=every sample */
 #define Control_IRQEN	0x0010	/* 1=enable IRQ */
 #define Control_GATE	0x0008	/* 1=enable external trigger GATE (8254?) */
@@ -112,7 +116,8 @@ Configuration options:
 #define Counter_RW0     0x0010	/* RW0/RW1 select read/write mode */
 #define Counter_RW1     0x0020
 #define Counter_SC0     0x0040	/* Select Counter. Only 00 or 11 may */
-#define Counter_SC1     0x0080	/* be used, 00 for CNT0, 11 for read-back command */
+#define Counter_SC1     0x0080	/* be used, 00 for CNT0,
+				 * 11 for read-back command */
 
 #define PCI1720_DA0	 0	/* W:   D/A register 0 */
 #define PCI1720_DA1	 2	/* W:   D/A register 1 */
@@ -138,8 +143,8 @@ static const struct comedi_lrange range_pci1710_3 = { 9, {
 							  }
 };
 
-static const char range_codes_pci1710_3[] =
-    { 0x00, 0x01, 0x02, 0x03, 0x04, 0x10, 0x11, 0x12, 0x13 };
+static const char range_codes_pci1710_3[] = { 0x00, 0x01, 0x02, 0x03, 0x04,
+					      0x10, 0x11, 0x12, 0x13 };
 
 static const struct comedi_lrange range_pci1710hg = { 12, {
 							   BIP_RANGE(5),
@@ -157,10 +162,9 @@ static const struct comedi_lrange range_pci1710hg = { 12, {
 							   }
 };
 
-static const char range_codes_pci1710hg[] =
-    { 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x10, 0x11, 0x12,
-	0x13
-};
+static const char range_codes_pci1710hg[] = { 0x00, 0x01, 0x02, 0x03, 0x04,
+					      0x05, 0x06, 0x07, 0x10, 0x11,
+					      0x12, 0x13 };
 
 static const struct comedi_lrange range_pci17x1 = { 5, {
 							BIP_RANGE(10),
@@ -301,7 +305,8 @@ struct pci1710_private {
 	unsigned int ai_timer1;	/*  timers */
 	unsigned int ai_timer2;
 	short ao_data[4];	/*  data output buffer */
-	unsigned int cnt0_write_wait;	/*  after a write, wait for update of the internal state */
+	unsigned int cnt0_write_wait;	/* after a write, wait for update of the
+					 * internal state */
 };
 
 #define devpriv ((struct pci1710_private *)dev->private)
@@ -324,7 +329,9 @@ static int pci1710_reset(struct comedi_device *dev);
 static int pci171x_ai_cancel(struct comedi_device *dev,
 			     struct comedi_subdevice *s);
 
-static const unsigned int muxonechan[] = { 0x0000, 0x0101, 0x0202, 0x0303, 0x0404, 0x0505, 0x0606, 0x0707,	/*  used for gain list programming */
+/*  used for gain list programming */
+static const unsigned int muxonechan[] = {
+	0x0000, 0x0101, 0x0202, 0x0303, 0x0404, 0x0505, 0x0606, 0x0707,
 	0x0808, 0x0909, 0x0a0a, 0x0b0b, 0x0c0c, 0x0d0d, 0x0e0e, 0x0f0f,
 	0x1010, 0x1111, 0x1212, 0x1313, 0x1414, 0x1515, 0x1616, 0x1717,
 	0x1818, 0x1919, 0x1a1a, 0x1b1b, 0x1c1c, 0x1d1d, 0x1e1e, 0x1f1f
@@ -774,7 +781,8 @@ static void interrupt_pci1710_half_fifo(void *d)
 	}
 
 	if (!devpriv->neverending_ai)
-		if (devpriv->ai_act_scan >= devpriv->ai_scans) {	/* all data sampled */
+		if (devpriv->ai_act_scan >= devpriv->ai_scans) { /* all data
+								    sampled */
 			pci171x_ai_cancel(dev, s);
 			s->async->events |= COMEDI_CB_EOA;
 			comedi_event(dev, s);
@@ -1559,7 +1567,8 @@ static int pci1710_attach(struct comedi_device *dev,
 		s->maxdata = 1;
 		s->len_chanlist = this_board->n_dochan;
 		s->range_table = &range_digital;
-		s->io_bits = (1 << this_board->n_dochan) - 1;	/* all bits output */
+		/* all bits output */
+		s->io_bits = (1 << this_board->n_dochan) - 1;
 		s->state = 0;
 		s->insn_bits = pci171x_insn_bits_do;
 		subdev++;
-- 
1.7.1

