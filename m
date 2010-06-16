Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797Ab0FPGBT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 02:01:19 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:34877 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab0FPGBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 02:01:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ZFXiBqkCdMUglyKh3A7c8lPpKkEptEiHS8GnoD7Yz0D+3hmaycQMrBvk7jkf33Hu2c
         8K6pFWu15RA4G6f6c3QGqssVsDVf2LoAjnPOdHwfB4+P69QoCfz4SNy5aaLIs32L71G/
         26XVOdW+GBv4Hh0vq4u8xvIPgWAq3BDTFLfDo=
From: Gustavo Silva <silvagustavosilva@gmail.com>
To: gregkh@suse.de, abbotti@mev.co.uk
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Gustavo Silva <silvagustavo@users.sourceforge.net>
Subject: [PATCH] Staging: comedi: drivers: fix coding style issues in quatech_daqp_cs.c
Date: Wed, 16 Jun 2010 01:01:07 -0500
Message-Id: <1276668067-12084-1-git-send-email-silvagustavo@users.sourceforge.net>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the quatech_daqp_cs.c file that fixes up the following
issues:

ERROR: code indent should use tabs where possible		   x  1
WARNING: line over 80 characters				   x  1
WARNING: braces {} are not necessary for single statement blocks   x 10
WARNING: printk() should include KERN_ facility level		   x  6

Signed-off-by: Gustavo Silva <silvagustavo@users.sourceforge.net>
---
 drivers/staging/comedi/drivers/quatech_daqp_cs.c |   53 +++++++++++-----------
 1 files changed, 26 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/comedi/drivers/quatech_daqp_cs.c b/drivers/staging/comedi/drivers/quatech_daqp_cs.c
index a91db6c..70c820a 100644
--- a/drivers/staging/comedi/drivers/quatech_daqp_cs.c
+++ b/drivers/staging/comedi/drivers/quatech_daqp_cs.c
@@ -14,7 +14,7 @@
 
     Documentation for the DAQP PCMCIA cards can be found on Quatech's site:
 
-                ftp://ftp.quatech.com/Manuals/daqp-208.pdf
+		ftp://ftp.quatech.com/Manuals/daqp-208.pdf
 
     This manual is for both the DAQP-208 and the DAQP-308.
 
@@ -195,7 +195,7 @@ static struct comedi_driver driver_daqp = {
 
 static void daqp_dump(struct comedi_device *dev)
 {
-	printk("DAQP: status %02x; aux status %02x\n",
+	printk(KERN_INFO "DAQP: status %02x; aux status %02x\n",
 	       inb(dev->iobase + DAQP_STATUS), inb(dev->iobase + DAQP_AUX));
 }
 
@@ -207,9 +207,9 @@ static void hex_dump(char *str, void *ptr, int len)
 	printk(str);
 
 	for (i = 0; i < len; i++) {
-		if (i % 16 == 0) {
+		if (i % 16 == 0)
 			printk("\n0x%08x:", (unsigned int)cptr);
-		}
+
 		printk(" %02x", *(cptr++));
 	}
 	printk("\n");
@@ -223,9 +223,9 @@ static int daqp_ai_cancel(struct comedi_device *dev, struct comedi_subdevice *s)
 {
 	struct local_info_t *local = (struct local_info_t *)s->private;
 
-	if (local->stop) {
+	if (local->stop)
 		return -EIO;
-	}
+
 
 	outb(DAQP_COMMAND_STOP, dev->iobase + DAQP_COMMAND);
 
@@ -355,9 +355,9 @@ static int daqp_ai_insn_read(struct comedi_device *dev,
 	int v;
 	int counter = 10000;
 
-	if (local->stop) {
+	if (local->stop)
 		return -EIO;
-	}
+
 
 	/* Stop any running conversion */
 	daqp_ai_cancel(dev, s);
@@ -372,9 +372,9 @@ static int daqp_ai_insn_read(struct comedi_device *dev,
 	v = DAQP_SCANLIST_CHANNEL(CR_CHAN(insn->chanspec))
 	    | DAQP_SCANLIST_GAIN(CR_RANGE(insn->chanspec));
 
-	if (CR_AREF(insn->chanspec) == AREF_DIFF) {
+	if (CR_AREF(insn->chanspec) == AREF_DIFF)
 		v |= DAQP_SCANLIST_DIFFERENTIAL;
-	}
+
 
 	v |= DAQP_SCANLIST_START;
 
@@ -488,7 +488,10 @@ static int daqp_ai_cmdtest(struct comedi_device *dev,
 	if (err)
 		return 1;
 
-	/* step 2: make sure trigger sources are unique and mutually compatible */
+	/*
+	 * step 2: make sure trigger sources
+	 * are unique and mutually compatible
+	 */
 
 	/* note that mutual compatibility is not an issue here */
 	if (cmd->scan_begin_src != TRIG_TIMER &&
@@ -588,9 +591,9 @@ static int daqp_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	int i;
 	int v;
 
-	if (local->stop) {
+	if (local->stop)
 		return -EIO;
-	}
+
 
 	/* Stop any running conversion */
 	daqp_ai_cancel(dev, s);
@@ -640,13 +643,11 @@ static int daqp_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		v = DAQP_SCANLIST_CHANNEL(CR_CHAN(chanspec))
 		    | DAQP_SCANLIST_GAIN(CR_RANGE(chanspec));
 
-		if (CR_AREF(chanspec) == AREF_DIFF) {
+		if (CR_AREF(chanspec) == AREF_DIFF)
 			v |= DAQP_SCANLIST_DIFFERENTIAL;
-		}
 
-		if (i == 0 || scanlist_start_on_every_entry) {
+		if (i == 0 || scanlist_start_on_every_entry)
 			v |= DAQP_SCANLIST_START;
-		}
 
 		outb(v & 0xff, dev->iobase + DAQP_SCANLIST);
 		outb(v >> 8, dev->iobase + DAQP_SCANLIST);
@@ -760,7 +761,8 @@ static int daqp_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	while (--counter
 	       && (inb(dev->iobase + DAQP_STATUS) & DAQP_STATUS_EVENTS)) ;
 	if (!counter) {
-		printk("daqp: couldn't clear interrupts in status register\n");
+		printk(KERN_ERR
+		       "daqp: couldn't clear interrupts in status register\n");
 		return -1;
 	}
 
@@ -785,9 +787,8 @@ static int daqp_ao_insn_write(struct comedi_device *dev,
 	int d;
 	unsigned int chan;
 
-	if (local->stop) {
+	if (local->stop)
 		return -EIO;
-	}
 
 	chan = CR_CHAN(insn->chanspec);
 	d = data[0];
@@ -811,9 +812,8 @@ static int daqp_di_insn_read(struct comedi_device *dev,
 {
 	struct local_info_t *local = (struct local_info_t *)s->private;
 
-	if (local->stop) {
+	if (local->stop)
 		return -EIO;
-	}
 
 	data[0] = inb(dev->iobase + DAQP_DIGITAL_IO);
 
@@ -828,9 +828,8 @@ static int daqp_do_insn_write(struct comedi_device *dev,
 {
 	struct local_info_t *local = (struct local_info_t *)s->private;
 
-	if (local->stop) {
+	if (local->stop)
 		return -EIO;
-	}
 
 	outw(data[0] & 0xf, dev->iobase + DAQP_DIGITAL_IO);
 
@@ -878,7 +877,7 @@ static int daqp_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (ret < 0)
 		return ret;
 
-	printk("comedi%d: attaching daqp%d (io 0x%04lx)\n",
+	printk(KERN_INFO "comedi%d: attaching daqp%d (io 0x%04lx)\n",
 	       dev->minor, it->options[0], dev->iobase);
 
 	s = dev->subdevices + 0;
@@ -931,7 +930,7 @@ static int daqp_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 static int daqp_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: detaching daqp\n", dev->minor);
+	printk(KERN_INFO "comedi%d: detaching daqp\n", dev->minor);
 
 	return 0;
 }
@@ -1153,7 +1152,7 @@ static void daqp_cs_config(struct pcmcia_device *link)
 	/* Finally, report what we've done */
 	dev_info(&link->dev, "index 0x%02x", link->conf.ConfigIndex);
 	if (link->conf.Attributes & CONF_ENABLE_IRQ)
-		printk(", irq %u", link->irq);
+		printk(KERN_INFO ", irq %u", link->irq);
 	if (link->io.NumPorts1)
 		printk(", io 0x%04x-0x%04x", link->io.BasePort1,
 		       link->io.BasePort1 + link->io.NumPorts1 - 1);
-- 
1.5.4.3

