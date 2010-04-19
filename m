Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab0DSGVV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 02:21:21 -0400
Received: from mail-yw0-f194.google.com ([209.85.211.194]:63525 "EHLO
	mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab0DSGVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 02:21:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=RnUu9ZOt6iE1v4dReDlhvtiFAUSiyrnXS95J7Hznn7NJeobbG/1EgpxYFPVpCMqTtu
         I7wrYQKoEDVvFywGheJKq/Ji9IUtW8kaL61uBM+fC18aOkUyxdIDBKIn+Av7/AidUzCU
         tq9SStbl798bTvpAPeyBr/agG2IaF3GDpxHrI=
From: Gustavo Silva <silvagustavosilva@gmail.com>
To: gregkh@suse.de
Cc: abbotti@mev.co.uk, fmhess@users.sourceforge.net,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Gustavo Silva <silvagustavo@users.sourceforge.net>
Subject: [PATCH] Staging: comedi: drivers: fix coding style issues in das08.c
Date: Mon, 19 Apr 2010 01:21:10 -0500
Message-Id: <1271658070-10511-1-git-send-email-silvagustavo@users.sourceforge.net>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the das08.c file that fixes up the following issues
found by the checkpatch.pl tool.

WARNING: line over 80 characters x 6
ERROR: code indent should use tabs where possible x 3
ERROR: spaces required around that '?' (ctx:VxV) x 4
ERROR: spaces required around that ':' (ctx:VxV) x 4
ERROR: that open brace { should be on the previous line x 1
WARNING: printk() should include KERN_ facility level x 9
WARNING: braces {} are not necessary for single statement blocks x 1
WARNING: EXPORT_SYMBOL(foo); should immediately follow its
function/variable x 2

Signed-off-by: Gustavo Silva <silvagustavo@users.sourceforge.net>
---
 drivers/staging/comedi/drivers/das08.c |  156 +++++++++++++++++---------------
 1 files changed, 82 insertions(+), 74 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das08.c b/drivers/staging/comedi/drivers/das08.c
index f425833..9cb144f 100644
--- a/drivers/staging/comedi/drivers/das08.c
+++ b/drivers/staging/comedi/drivers/das08.c
@@ -1,55 +1,55 @@
 /*
-    comedi/drivers/das08.c
-    DAS08 driver
-
-    COMEDI - Linux Control and Measurement Device Interface
-    Copyright (C) 2000 David A. Schleef <ds@schleef.org>
-    Copyright (C) 2001,2002,2003 Frank Mori Hess <fmhess@users.sourceforge.net>
-    Copyright (C) 2004 Salvador E. Tropea <set@users.sf.net> <set@ieee.org>
-
-    This program is free software; you can redistribute it and/or modify
-    it under the terms of the GNU General Public License as published by
-    the Free Software Foundation; either version 2 of the License, or
-    (at your option) any later version.
-
-    This program is distributed in the hope that it will be useful,
-    but WITHOUT ANY WARRANTY; without even the implied warranty of
-    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-    GNU General Public License for more details.
-
-    You should have received a copy of the GNU General Public License
-    along with this program; if not, write to the Free Software
-    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
-
-*****************************************************************
+ *  comedi/drivers/das08.c
+ *  DAS08 driver
+ *
+ *  COMEDI - Linux Control and Measurement Device Interface
+ *  Copyright (C) 2000 David A. Schleef <ds@schleef.org>
+ *  Copyright (C) 2001,2002,2003 Frank Mori Hess <fmhess@users.sourceforge.net>
+ *  Copyright (C) 2004 Salvador E. Tropea <set@users.sf.net> <set@ieee.org>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ *****************************************************************
+ */
 
-*/
 /*
-Driver: das08
-Description: DAS-08 compatible boards
-Author: Warren Jasper, ds, Frank Hess
-Devices: [Keithley Metrabyte] DAS08 (isa-das08), [ComputerBoards] DAS08 (isa-das08),
-  DAS08-PGM (das08-pgm),
-  DAS08-PGH (das08-pgh), DAS08-PGL (das08-pgl), DAS08-AOH (das08-aoh),
-  DAS08-AOL (das08-aol), DAS08-AOM (das08-aom), DAS08/JR-AO (das08/jr-ao),
-  DAS08/JR-16-AO (das08jr-16-ao), PCI-DAS08 (das08),
-  PC104-DAS08 (pc104-das08), DAS08/JR/16 (das08jr/16)
-Status: works
-
-This is a rewrite of the das08 and das08jr drivers.
-
-Options (for ISA cards):
-        [0] - base io address
-
-Options (for pci-das08):
-        [0] - bus  (optional)
-        [1] = slot (optional)
-
-The das08 driver doesn't support asynchronous commands, since
-the cheap das08 hardware doesn't really support them.  The
-comedi_rt_timer driver can be used to emulate commands for this
-driver.
-*/
+ * Driver: das08
+ * Description: DAS-08 compatible boards
+ * Author: Warren Jasper, ds, Frank Hess
+ * Devices: [Keithley Metrabyte] DAS08 (isa-das08),
+ * [ComputerBoards] DAS08 (isa-das08), DAS08-PGM (das08-pgm),
+ * DAS08-PGH (das08-pgh), DAS08-PGL (das08-pgl), DAS08-AOH (das08-aoh),
+ * DAS08-AOL (das08-aol), DAS08-AOM (das08-aom), DAS08/JR-AO (das08/jr-ao),
+ * DAS08/JR-16-AO (das08jr-16-ao), PCI-DAS08 (das08),
+ * PC104-DAS08 (pc104-das08), DAS08/JR/16 (das08jr/16)
+ * Status: works
+ *
+ * This is a rewrite of the das08 and das08jr drivers.
+ *
+ * Options (for ISA cards):
+ *		[0] - base io address
+ *
+ * Options (for pci-das08):
+ *		[0] - bus  (optional)
+ *		[1] = slot (optional)
+ *
+ * The das08 driver doesn't support asynchronous commands, since
+ * the cheap das08 hardware doesn't really support them.  The
+ * comedi_rt_timer driver can be used to emulate commands for this
+ * driver.
+ */
 
 #include "../comedidev.h"
 
@@ -122,8 +122,8 @@ driver.
 */
 
 #define DAS08JR_DIO		3
-#define DAS08JR_AO_LSB(x)	((x)?6:4)
-#define DAS08JR_AO_MSB(x)	((x)?7:5)
+#define DAS08JR_AO_LSB(x)	((x) ? 6 : 4)
+#define DAS08JR_AO_MSB(x)	((x) ? 7 : 5)
 
 /*
     cio-das08_aox.pdf
@@ -148,8 +148,8 @@ driver.
 #define DAS08AO_GAIN_CONTROL	3
 #define DAS08AO_GAIN_STATUS	3
 
-#define DAS08AO_AO_LSB(x)	((x)?0xa:8)
-#define DAS08AO_AO_MSB(x)	((x)?0xb:9)
+#define DAS08AO_AO_LSB(x)	((x) ? 0xa : 8)
+#define DAS08AO_AO_MSB(x)	((x) ? 0xb : 9)
 #define DAS08AO_AO_UPDATE	8
 
 /* gainlist same as _pgx_ below */
@@ -239,8 +239,9 @@ static const struct comedi_lrange *const das08_ai_lranges[] = {
 	&range_das08_pgm,
 };
 
-static const int das08_pgh_gainlist[] =
-    { 8, 0, 10, 2, 12, 4, 14, 6, 1, 3, 5, 7 };
+static const int das08_pgh_gainlist[] = {
+	8, 0, 10, 2, 12, 4, 14, 6, 1, 3, 5, 7
+};
 static const int das08_pgl_gainlist[] = { 8, 0, 2, 4, 6, 1, 3, 5, 7 };
 static const int das08_pgm_gainlist[] = { 8, 0, 10, 12, 14, 9, 11, 13, 15 };
 
@@ -535,7 +536,8 @@ static int das08_ai_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
 	inb(dev->iobase + DAS08_MSB);
 
 	/* set multiplexer */
-	spin_lock(&dev->spinlock);	/*  lock to prevent race with digital output */
+	/*  lock to prevent race with digital output */
+	spin_lock(&dev->spinlock);
 	devpriv->do_mux_bits &= ~DAS08_MUX_MASK;
 	devpriv->do_mux_bits |= DAS08_MUX(chan);
 	outb(devpriv->do_mux_bits, dev->iobase + DAS08_CONTROL);
@@ -552,7 +554,7 @@ static int das08_ai_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
 		/* clear over-range bits for 16-bit boards */
 		if (thisboard->ai_nbits == 16)
 			if (inb(dev->iobase + DAS08_MSB) & 0x80)
-				printk("das08: over-range\n");
+				printk(KERN_INFO "das08: over-range\n");
 
 		/* trigger conversion */
 		outb_p(0, dev->iobase + DAS08_TRIG_12BIT);
@@ -562,7 +564,7 @@ static int das08_ai_rinsn(struct comedi_device *dev, struct comedi_subdevice *s,
 				break;
 		}
 		if (i == TIMEOUT) {
-			printk("das08: timeout\n");
+			printk(KERN_ERR "das08: timeout\n");
 			return -ETIME;
 		}
 		msb = inb(dev->iobase + DAS08_MSB);
@@ -607,7 +609,8 @@ static int das08_do_wbits(struct comedi_device *dev, struct comedi_subdevice *s,
 	/*  set new bit values */
 	wbits |= data[0] & data[1];
 	/*  remember digital output bits */
-	spin_lock(&dev->spinlock);	/*  prevent race with setting of analog input mux */
+	/*  prevent race with setting of analog input mux */
+	spin_lock(&dev->spinlock);
 	devpriv->do_mux_bits &= ~DAS08_DO_MASK;
 	devpriv->do_mux_bits |= DAS08_OP(wbits);
 	outb(devpriv->do_mux_bits, dev->iobase + DAS08_CONTROL);
@@ -860,9 +863,9 @@ int das08_common_attach(struct comedi_device *dev, unsigned long iobase)
 
 	/*  allocate ioports for non-pcmcia, non-pci boards */
 	if ((thisboard->bustype != pcmcia) && (thisboard->bustype != pci)) {
-		printk(" iobase 0x%lx\n", iobase);
+		printk(KERN_INFO " iobase 0x%lx\n", iobase);
 		if (!request_region(iobase, thisboard->iosize, DRV_NAME)) {
-			printk(" I/O port conflict\n");
+			printk(KERN_ERR " I/O port conflict\n");
 			return -EIO;
 		}
 	}
@@ -878,8 +881,11 @@ int das08_common_attach(struct comedi_device *dev, unsigned long iobase)
 	/* ai */
 	if (thisboard->ai) {
 		s->type = COMEDI_SUBD_AI;
-		/* XXX some boards actually have differential inputs instead of single ended.
-		 *  The driver does nothing with arefs though, so it's no big deal. */
+		/* XXX some boards actually have differential
+		 * inputs instead of single ended.
+		 * The driver does nothing with arefs though,
+		 * so it's no big deal.
+		 */
 		s->subdev_flags = SDF_READABLE | SDF_GROUND;
 		s->n_chan = 8;
 		s->maxdata = (1 << thisboard->ai_nbits) - 1;
@@ -966,6 +972,7 @@ int das08_common_attach(struct comedi_device *dev, unsigned long iobase)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(das08_common_attach);
 
 static int das08_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
@@ -980,7 +987,7 @@ static int das08_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (ret < 0)
 		return ret;
 
-	printk("comedi%d: das08: ", dev->minor);
+	printk(KERN_INFO "comedi%d: das08: ", dev->minor);
 	/*  deal with a pci board */
 	if (thisboard->bustype == pci) {
 #ifdef CONFIG_COMEDI_PCI
@@ -1007,20 +1014,21 @@ static int das08_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 			}
 		}
 		if (!pdev) {
-			printk("No pci das08 cards found\n");
+			printk(KERN_ERR "No pci das08 cards found\n");
 			return -EIO;
 		}
 		devpriv->pdev = pdev;
 		/*  enable PCI device and reserve I/O spaces */
 		if (comedi_pci_enable(pdev, DRV_NAME)) {
-			printk
-			    (" Error enabling PCI device and requesting regions\n");
+			printk(KERN_ERR " Error enabling PCI device and "
+						"requesting regions\n");
 			return -EIO;
 		}
 		/*  read base addresses */
 		pci_iobase = pci_resource_start(pdev, 1);
 		iobase = pci_resource_start(pdev, 2);
-		printk("pcibase 0x%lx  iobase 0x%lx\n", pci_iobase, iobase);
+		printk(KERN_INFO "pcibase 0x%lx  iobase 0x%lx\n",
+							pci_iobase, iobase);
 		devpriv->pci_iobase = pci_iobase;
 #if 0
 /* We could enable to pci-das08's interrupt here to make it possible
@@ -1034,17 +1042,18 @@ static int das08_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 		outw(INTR1_ENABLE | PCI_INTR_ENABLE, pci_iobase + INTCSR);
 #endif
 #else /* CONFIG_COMEDI_PCI */
-		printk("this driver has not been built with PCI support.\n");
+		printk(KERN_ERR "this driver has not been built with PCI support.\n");
 		return -EINVAL;
 #endif /* CONFIG_COMEDI_PCI */
 	} else {
 		iobase = it->options[0];
 	}
-	printk("\n");
+	printk(KERN_INFO "\n");
 
 	return das08_common_attach(dev, iobase);
 }
 
+
 int das08_common_detach(struct comedi_device *dev)
 {
 	printk(KERN_INFO "comedi%d: das08: remove\n", dev->minor);
@@ -1060,9 +1069,9 @@ int das08_common_detach(struct comedi_device *dev)
 #ifdef CONFIG_COMEDI_PCI
 	if (devpriv) {
 		if (devpriv->pdev) {
-			if (devpriv->pci_iobase) {
+			if (devpriv->pci_iobase)
 				comedi_pci_disable(devpriv->pdev);
-			}
+
 			pci_dev_put(devpriv->pdev);
 		}
 	}
@@ -1070,6 +1079,7 @@ int das08_common_detach(struct comedi_device *dev)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(das08_common_detach);
 
 #ifdef CONFIG_COMEDI_PCI
 COMEDI_PCI_INITCLEANUP(driver_das08, das08_pci_table);
@@ -1077,8 +1087,6 @@ COMEDI_PCI_INITCLEANUP(driver_das08, das08_pci_table);
 COMEDI_INITCLEANUP(driver_das08);
 #endif
 
-EXPORT_SYMBOL_GPL(das08_common_attach);
-EXPORT_SYMBOL_GPL(das08_common_detach);
 #ifdef CONFIG_COMEDI_PCMCIA
 EXPORT_SYMBOL_GPL(das08_cs_boards);
 #endif
-- 
1.5.4.3

