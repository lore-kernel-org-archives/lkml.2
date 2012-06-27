Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341Ab2F0WDq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 18:03:46 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:31536 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932249Ab2F0WDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 18:03:44 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-132.messagelabs.com!1340834621!12710498!4
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 13/19] staging: comedi: adl_pci6208: remove some useless comments
Date: Wed, 27 Jun 2012 15:03:31 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206271503.31601.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove a number of useless comments that are cut-and-paste from
the skel driver.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adl_pci6208.c | 25 +++++--------------------
 1 file changed, 5 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci6208.c b/drivers/staging/comedi/drivers/adl_pci6208.c
index fe97db2..18ca400 100644
--- a/drivers/staging/comedi/drivers/adl_pci6208.c
+++ b/drivers/staging/comedi/drivers/adl_pci6208.c
@@ -41,16 +41,7 @@ References:
 	- adl_pci9111.c		copied the entire pci setup section
 	- adl_pci9118.c
 */
-/*
- * These headers should be followed by a blank line, and any comments
- * you wish to say about the driver.  The comment area is the place
- * to put any known bugs, limitations, unsupported features, supported
- * command triggers, whether or not commands are supported on particular
- * subdevices, etc.
- *
- * Somewhere in the comment should be information about configuration
- * options that are used with comedi_config.
- */
+
 #include "../comedidev.h"
 
 /*
@@ -65,10 +56,9 @@ References:
 #define PCI6208_DIO_DI_MASK		(0xf0)
 #define PCI6208_DIO_DI_SHIFT		(4)
 
-/* Board descriptions */
 struct pci6208_board {
 	const char *name;
-	unsigned short dev_id;	/* `lspci` will show you this */
+	unsigned short dev_id;
 	int ao_chans;
 };
 
@@ -82,8 +72,8 @@ static const struct pci6208_board pci6208_boards[] = {
 
 struct pci6208_private {
 	int data;
-	struct pci_dev *pci_dev;	/* for a PCI device */
-	unsigned int ao_readback[2];	/* Used for AO readback */
+	struct pci_dev *pci_dev;
+	unsigned int ao_readback[2];
 };
 
 static int pci6208_ao_winsn(struct comedi_device *dev,
@@ -95,11 +85,9 @@ static int pci6208_ao_winsn(struct comedi_device *dev,
 	unsigned short chan = CR_CHAN(insn->chanspec);
 	unsigned long invert = 1 << (16 - 1);
 	unsigned long out_value;
-	/* Writing a list of values to an AO channel is probably not
-	 * very useful, but that's how the interface is defined. */
+
 	for (i = 0; i < insn->n; i++) {
 		out_value = data[i] ^ invert;
-		/* a typical programming sequence */
 		do {
 			Data_Read = (inw(dev->iobase) & 1);
 		} while (Data_Read);
@@ -107,12 +95,9 @@ static int pci6208_ao_winsn(struct comedi_device *dev,
 		devpriv->ao_readback[chan] = out_value;
 	}
 
-	/* return the number of samples read/written */
 	return i;
 }
 
-/* AO subdevices should have a read insn as well as a write insn.
- * Usually this means copying a value stored in devpriv. */
 static int pci6208_ao_rinsn(struct comedi_device *dev,
 			    struct comedi_subdevice *s,
 			    struct comedi_insn *insn, unsigned int *data)
-- 
1.7.11

