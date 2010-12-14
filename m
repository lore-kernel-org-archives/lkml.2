Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758323Ab0LNWO4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 17:14:56 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57279 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757110Ab0LNWOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 17:14:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=u5k+vMnHHdDRfn0vLoX7YQv9UFq5hNPiHeTWz7ALYfTVVKwdtUjEuRBwEoz2dHwFlJ
         9lsLDWctSNnFbUmW2BhIEgmF3Gy11da3Sc6XWc5EM+x1v+NQlZUmkvwfNGyoVHm5J2oS
         Ehi07f4Aq66bkvVvYDXWoE/l4VUJEHPLFsch8=
From: Xenofon Foukas <foukas.xenofon@gmail.com>
To: gregkh@suse.de, arun.thomas@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Xenofon Foukas <foukas.xenofon@gmail.com>
Subject: [PATCH] Fix coding style issues in ii_pci20kc.c
Date: Wed, 15 Dec 2010 00:14:30 +0200
Message-Id: <1292364870-7075-1-git-send-email-foukas.xenofon@gmail.com>
X-Mailer: git-send-email 1.7.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following issues in file ii_pci20kc.c:

WARNING: please, no space before tabs
WARNING: unnecessary whitespace before a quoted newline
WARNING: line over 80 characters

Signed-off-by: Xenofon Foukas <foukas.xenofon@gmail.com>
---
 drivers/staging/comedi/drivers/ii_pci20kc.c |   66 +++++++++++++++++++--------
 1 files changed, 46 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ii_pci20kc.c b/drivers/staging/comedi/drivers/ii_pci20kc.c
index 39a6a85..e4711ef 100644
--- a/drivers/staging/comedi/drivers/ii_pci20kc.c
+++ b/drivers/staging/comedi/drivers/ii_pci20kc.c
@@ -19,7 +19,7 @@
  *				- 16 bit
  *
  *	only ONE PCI-20341 module possible
- * 	only ONE PCI-20006 module possible
+ *	only ONE PCI-20006 module possible
  *	no extern trigger implemented
  *
  *	NOT WORKING (but soon) only 4 on-board differential channels supported
@@ -83,11 +83,11 @@ options for PCI-20341M:
 #include "../comedidev.h"
 
 #define PCI20000_ID			0x1d
-#define PCI20341_ID    			0x77
-#define PCI20006_ID      		0xe3
+#define PCI20341_ID			0x77
+#define PCI20006_ID			0xe3
 #define PCI20xxx_EMPTY_ID		0xff
 
-#define PCI20000_OFFSET 		0x100
+#define PCI20000_OFFSET			0x100
 #define PCI20000_MODULES		3
 
 #define PCI20000_DIO_0			0x80
@@ -246,7 +246,7 @@ static int pci20xxx_attach(struct comedi_device *dev,
 			pci20006_init(dev, s, it->options[2 * i + 2],
 				      it->options[2 * i + 3]);
 			printk(KERN_INFO "comedi%d: "
-			       "ii_pci20kc PCI-20006 module in slot %d \n",
+			       "ii_pci20kc PCI-20006 module in slot %d\n",
 			       dev->minor, i + 1);
 			break;
 		case PCI20341_ID:
@@ -255,7 +255,7 @@ static int pci20xxx_attach(struct comedi_device *dev,
 			pci20341_init(dev, s, it->options[2 * i + 2],
 				      it->options[2 * i + 3]);
 			printk(KERN_INFO "comedi%d: "
-			       "ii_pci20kc PCI-20341 module in slot %d \n",
+			       "ii_pci20kc PCI-20341 module in slot %d\n",
 			       dev->minor, i + 1);
 			break;
 		default:
@@ -376,9 +376,20 @@ static int pci20341_insn_read(struct comedi_device *dev,
 static const int pci20341_timebase[] = { 0x00, 0x00, 0x00, 0x04 };
 static const int pci20341_settling_time[] = { 0x58, 0x58, 0x93, 0x99 };
 
-static const struct comedi_lrange range_bipolar0_5 = { 1, {BIP_RANGE(0.5)} };
-static const struct comedi_lrange range_bipolar0_05 = { 1, {BIP_RANGE(0.05)} };
-static const struct comedi_lrange range_bipolar0_025 = { 1, {BIP_RANGE(0.025)} };
+static const struct comedi_lrange range_bipolar0_5 = {
+	1,
+	{BIP_RANGE(0.5)}
+};
+
+static const struct comedi_lrange range_bipolar0_05 = {
+	1,
+	{BIP_RANGE(0.05)}
+};
+
+static const struct comedi_lrange range_bipolar0_025 = {
+	1,
+	{BIP_RANGE(0.025)}
+};
 
 static const struct comedi_lrange *const pci20341_ranges[] = {
 	&range_bipolar5,
@@ -408,12 +419,18 @@ static int pci20341_init(struct comedi_device *dev, struct comedi_subdevice *s,
 	s->maxdata = 0xffff;
 	s->range_table = pci20341_ranges[opt0];
 
-	option = sdp->pci20341.timebase | PCI20341_REPMODE;	/* depends on gain, trigger, repetition mode */
-
-	writeb(PCI20341_INIT, sdp->iobase + PCI20341_CONFIG_REG);	/* initialize Module */
-	writeb(PCI20341_PACER, sdp->iobase + PCI20341_MOD_STATUS);	/* set Pacer */
-	writeb(option, sdp->iobase + PCI20341_OPT_REG);	/* option register */
-	writeb(sdp->pci20341.settling_time, sdp->iobase + PCI20341_SET_TIME_REG);	/* settling time counter */
+	/* depends on gain, trigger, repetition mode */
+	option = sdp->pci20341.timebase | PCI20341_REPMODE;
+
+	/* initialize Module */
+	writeb(PCI20341_INIT, sdp->iobase + PCI20341_CONFIG_REG);
+	/* set Pacer */
+	writeb(PCI20341_PACER, sdp->iobase + PCI20341_MOD_STATUS);
+	/* option register */
+	writeb(option, sdp->iobase + PCI20341_OPT_REG);
+	/* settling time counter */
+	writeb(sdp->pci20341.settling_time,
+		sdp->iobase + PCI20341_SET_TIME_REG);
 	/* trigger not implemented */
 	return 0;
 }
@@ -429,11 +446,15 @@ static int pci20341_insn_read(struct comedi_device *dev,
 	unsigned int clb;	/* channel list byte */
 	unsigned int boarddata;
 
-	writeb(1, sdp->iobase + PCI20341_LCHAN_ADDR_REG);	/* write number of input channels */
+	/* write number of input channels */
+	writeb(1, sdp->iobase + PCI20341_LCHAN_ADDR_REG);
 	clb = PCI20341_DAISY_CHAIN | PCI20341_MUX | (sdp->pci20341.ai_gain << 3)
 	    | CR_CHAN(insn->chanspec);
 	writeb(clb, sdp->iobase + PCI20341_CHAN_LIST);
-	writeb(0x00, sdp->iobase + PCI20341_CC_RESET);	/* reset settling time counter and trigger delay counter */
+
+	/* reset settling time counter and trigger delay counter */
+	writeb(0x00, sdp->iobase + PCI20341_CC_RESET);
+
 	writeb(0x00, sdp->iobase + PCI20341_CHAN_RESET);
 
 	/* generate Pacer */
@@ -444,9 +465,12 @@ static int pci20341_insn_read(struct comedi_device *dev,
 		 * the whole interrupt stuff
 		 */
 		j = 0;
-		readb(sdp->iobase + PCI20341_SOFT_PACER);	/* generate Pacer */
+		/* generate Pacer */
+		readb(sdp->iobase + PCI20341_SOFT_PACER);
+
 		eoc = readb(sdp->iobase + PCI20341_STATUS_REG);
-		while ((eoc < 0x80) && j < 100) {	/* poll Interrupt Flag */
+		/* poll Interrupt Flag */
+		while ((eoc < 0x80) && j < 100) {
 			j++;
 			eoc = readb(sdp->iobase + PCI20341_STATUS_REG);
 		}
@@ -460,7 +484,9 @@ static int pci20341_insn_read(struct comedi_device *dev,
 		lo = readb(sdp->iobase + PCI20341_LDATA);
 		hi = readb(sdp->iobase + PCI20341_LDATA + 1);
 		boarddata = lo + 0x100 * hi;
-		data[i] = (short)((boarddata + 0x8000) & 0xffff);	/* board-data -> comedi-data */
+
+		/* board-data -> comedi-data */
+		data[i] = (short)((boarddata + 0x8000) & 0xffff);
 	}
 
 	return i;
-- 
1.7.3.3

