Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750774Ab0EAEWM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 00:22:12 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50463 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab0EAEWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 00:22:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=plAbZ6D6k31eocpLpjC/1ku/jWvNpGB9HVwm17CPTt0obrCa1PBrTP4f/VIn+RpbAP
         lVcQ80Cd7DQE8hTc55foCPyIq0CRln0NPlmjKk8b33ZYZCESYlDp0Hr0hJzwaSpMpv9n
         gZJcQHJH1uI1kK1K/T4s7D1fEwIFnzHoR5C68=
From: Dustin Dorroh <dustindorroh@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Dustin Dorroh <dustindorroh@gmail.com>
Subject: [PATCH] Staging: comedi: ssc_dnp: adjusted comments: coding style issue
Date: Fri, 30 Apr 2010 21:22:00 -0700
Message-Id: <1272687720-27039-1-git-send-email-dustindorroh@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a coding style issue.

Signed-off-by: Dustin Dorroh <dustindorroh@gmail.com>
---
 drivers/staging/comedi/drivers/ssv_dnp.c |   97 ++++++++++++++++--------------
 1 files changed, 51 insertions(+), 46 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ssv_dnp.c b/drivers/staging/comedi/drivers/ssv_dnp.c
index 17c92a5..f49ea03 100644
--- a/drivers/staging/comedi/drivers/ssv_dnp.c
+++ b/drivers/staging/comedi/drivers/ssv_dnp.c
@@ -41,14 +41,14 @@ Status: unknown
 /* 0..3 remain unchanged! For details about Port C Mode Register see         */
 /* the remarks in dnp_insn_config() below.                                   */
 
-#define CSCIR 0x22		/* Chip Setup and Control Index Register       */
-#define CSCDR 0x23		/* Chip Setup and Control Data Register        */
-#define PAMR  0xa5		/* Port A Mode Register                        */
-#define PADR  0xa9		/* Port A Data Register                        */
-#define PBMR  0xa4		/* Port B Mode Register                        */
-#define PBDR  0xa8		/* Port B Data Register                        */
-#define PCMR  0xa3		/* Port C Mode Register                        */
-#define PCDR  0xa7		/* Port C Data Register                        */
+#define CSCIR 0x22		/* Chip Setup and Control Index Register     */
+#define CSCDR 0x23		/* Chip Setup and Control Data Register      */
+#define PAMR  0xa5		/* Port A Mode Register                      */
+#define PADR  0xa9		/* Port A Data Register                      */
+#define PBMR  0xa4		/* Port B Mode Register                      */
+#define PBDR  0xa8		/* Port B Data Register                      */
+#define PCMR  0xa3		/* Port C Mode Register                      */
+#define PCDR  0xa7		/* Port C Data Register                      */
 
 /* This data structure holds information about the supported boards -------- */
 
@@ -59,8 +59,10 @@ struct dnp_board {
 	int have_dio;
 };
 
-static const struct dnp_board dnp_boards[] = {	/* we only support one DNP 'board'   */
-	{			/* variant at the moment             */
+static const struct dnp_board dnp_boards[] = {	
+				/* we only support one DNP 'board'   	     */
+				/* variant at the moment             	     */
+	{
 	 .name = "dnp-1486",
 	 .ai_chans = 16,
 	 .ai_bits = 12,
@@ -80,9 +82,9 @@ struct dnp_private_data {
 #define devpriv ((dnp_private *)dev->private)
 
 /* ------------------------------------------------------------------------- */
-/* The struct comedi_driver structure tells the Comedi core module which functions  */
-/* to call to configure/deconfigure (attach/detach) the board, and also      */
-/* about the kernel module that contains the device code.                    */
+/* The struct comedi_driver structure tells the Comedi core module which     */
+/* functions to call to configure/deconfigure (attach/detach) the board,     */
+/* and also about the kernel module that contains the device code.           */
 /*                                                                           */
 /* In the following section we define the API of this driver.                */
 /* ------------------------------------------------------------------------- */
@@ -97,7 +99,8 @@ static struct comedi_driver driver_dnp = {
 	.detach = dnp_detach,
 	.board_name = &dnp_boards[0].name,
 	/* only necessary for non-PnP devs   */
-	.offset = sizeof(struct dnp_board),	/* like ISA-PnP, PCI or PCMCIA.      */
+	/* like ISA-PnP, PCI or PCMCIA.      */					
+	.offset = sizeof(struct dnp_board),
 	.num_names = ARRAY_SIZE(dnp_boards),
 };
 
@@ -124,26 +127,26 @@ static int dnp_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	printk("comedi%d: dnp: ", dev->minor);
 
-	/* Autoprobing: this should find out which board we have. Currently only   */
-	/* the 1486 board is supported and autoprobing is not implemented :-)      */
-	/* dev->board_ptr = dnp_probe(dev); */
+	/* Autoprobing: this should find out which board we have.	     */
+	/* Currently only the 1486 board is supported and autoprobing is     */
+	/* not implemented :-) dev->board_ptr = dnp_probe(dev);		     */
 
-	/* Initialize the name of the board. We can use the "thisboard" macro now. */
+	/* Initialize the board name. We can use the "thisboard" macro now.  */
 	dev->board_name = thisboard->name;
 
-	/* Allocate the private structure area. alloc_private() is a convenient    */
-	/* macro defined in comedidev.h.                                           */
+	/* Allocate the private structure area. alloc_private() is a	     */
+	/* convenient macro defined in comedidev.h.			     */
 	if (alloc_private(dev, sizeof(struct dnp_private_data)) < 0)
 		return -ENOMEM;
 
-	/* Allocate the subdevice structures. alloc_subdevice() is a convenient    */
-	/* macro defined in comedidev.h.                                           */
+	/* Allocate the subdevice structures. alloc_subdevice() is a	     */
+	/* convenient macro defined in comedidev.h.			     */
 
 	if (alloc_subdevices(dev, 1) < 0)
 		return -ENOMEM;
 
 	s = dev->subdevices + 0;
-	/* digital i/o subdevice                                                   */
+	/* digital i/o subdevice */
 	s->type = COMEDI_SUBD_DIO;
 	s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
 	s->n_chan = 20;
@@ -154,11 +157,11 @@ static int dnp_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	printk("attached\n");
 
-	/* We use the I/O ports 0x22,0x23 and 0xa3-0xa9, which are always
-	 * allocated for the primary 8259, so we don't need to allocate them
-	 * ourselves. */
+	/* We use the I/O ports 0x22,0x23 and 0xa3-0xa9, which are always    */
+	/* allocated for the primary 8259, so we don't need to allocate them */
+	/* ourselves. 							     */
 
-	/* configure all ports as input (default)                                  */
+	/* configure all ports as input (default) */
 	outb(PAMR, CSCIR);
 	outb(0x00, CSCDR);
 	outb(PBMR, CSCIR);
@@ -181,7 +184,7 @@ static int dnp_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 static int dnp_detach(struct comedi_device *dev)
 {
 
-	/* configure all ports as input (default)                                  */
+	/* configure all ports as input (default) */
 	outb(PAMR, CSCIR);
 	outb(0x00, CSCDR);
 	outb(PBMR, CSCIR);
@@ -189,7 +192,7 @@ static int dnp_detach(struct comedi_device *dev)
 	outb(PCMR, CSCIR);
 	outb((inb(CSCDR) & 0xAA), CSCDR);
 
-	/* announce that we are finished                                           */
+	/* announce that we are finished */
 	printk("comedi%d: dnp: remove\n", dev->minor);
 
 	return 0;
@@ -208,15 +211,15 @@ static int dnp_dio_insn_bits(struct comedi_device *dev,
 {
 
 	if (insn->n != 2)
-		return -EINVAL;	/* insn uses data[0] and data[1]     */
+		return -EINVAL;	/* insn uses data[0] and data[1]     	     */
 
-	/* The insn data is a mask in data[0] and the new data in data[1], each    */
-	/* channel cooresponding to a bit.                                         */
-
-	/* Ports A and B are straight forward: each bit corresponds to an output   */
-	/* pin with the same order. Port C is different: bits 0...3 correspond to  */
-	/* bits 4...7 of the output register (PCDR).                               */
+	/* The insn data is a mask in data[0] and the new data in data[1],   */
+	/* each channel cooresponding to a bit. 			     */
 
+	/* Ports A and B are straight forward: each bit corresponds to an    */
+	/* output pin with the same order. Port C is different: bits 0...3   */
+	/* correspond to  bits 4...7 of the output register (PCDR).	     */
+	
 	if (data[0]) {
 
 		outb(PADR, CSCIR);
@@ -235,7 +238,7 @@ static int dnp_dio_insn_bits(struct comedi_device *dev,
 		     | (u8) ((data[1] & 0x0F0000) >> 12), CSCDR);
 	}
 
-	/* on return, data[1] contains the value of the digital input lines.       */
+	/* on return, data[1] contains the value of the digital input lines. */
 	outb(PADR, CSCIR);
 	data[0] = inb(CSCDR);
 	outb(PBDR, CSCIR);
@@ -259,8 +262,9 @@ static int dnp_dio_insn_config(struct comedi_device *dev,
 {
 
 	u8 register_buffer;
-
-	int chan = CR_CHAN(insn->chanspec);	/* reduces chanspec to lower 16 bits */
+	
+	/* reduces chanspec to lower 16 bits */
+	int chan = CR_CHAN(insn->chanspec);
 
 	switch (data[0]) {
 	case INSN_CONFIG_DIO_OUTPUT:
@@ -275,11 +279,11 @@ static int dnp_dio_insn_config(struct comedi_device *dev,
 		return -EINVAL;
 		break;
 	}
-	/* Test: which port does the channel belong to?                            */
+	/* Test: which port does the channel belong to? */
 
-	/* We have to pay attention with port C: this is the meaning of PCMR:      */
-	/* Bit in PCMR:              7 6 5 4 3 2 1 0                               */
-	/* Corresponding port C pin: d 3 d 2 d 1 d 0   d= don't touch              */
+	/* We have to pay attention with port C: this is the meaning of PCMR:*/
+	/* Bit in PCMR:              7 6 5 4 3 2 1 0			     */
+	/* Corresponding port C pin: d 3 d 2 d 1 d 0   d= don't touch	     */
 
 	if ((chan >= 0) && (chan <= 7)) {
 		/* this is port A */
@@ -289,8 +293,9 @@ static int dnp_dio_insn_config(struct comedi_device *dev,
 		chan -= 8;
 		outb(PBMR, CSCIR);
 	} else if ((chan >= 16) && (chan <= 19)) {
-		/* this is port C; multiplication with 2 brings bits into correct        */
-		/* position for PCMR!                                                    */
+		/* this is port C */
+		/* multiplication with 2 brings bits into correct position   */
+		/* for PCMR! 						     */
 		chan -= 16;
 		chan *= 2;
 		outb(PCMR, CSCIR);
@@ -298,7 +303,7 @@ static int dnp_dio_insn_config(struct comedi_device *dev,
 		return -EINVAL;
 	}
 
-	/* read 'old' direction of the port and set bits (out=1, in=0)             */
+	/* read 'old' direction of the port and set bits (out=1, in=0) 	     */
 	register_buffer = inb(CSCDR);
 	if (data[0] == COMEDI_OUTPUT)
 		register_buffer |= (1 << chan);
-- 
1.7.0.4

