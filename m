Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751070Ab0DYBt6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 21:49:58 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:45619 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749Ab0DYBt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 21:49:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=BZVfcgRI0xbUtI0hChc6n7Zss3DAbvkpWhJ9abqfIaPQqVtob/6JI/j2U6dMjfSv6b
         0YPnPaLfRVXqNKWo6xqkTtoEruEFDEzIZD+6kIeHTOUYnpfB6At9bcNdZWjx67d4rzsc
         /Mxay4PTl4R7A8K0G3HWXCvn0iis+mmLw1PI0=
Message-ID: <4BD39FBD.3090607@gmail.com>
Date: Sun, 25 Apr 2010 02:49:49 +0100
From: Darren Armstrong <darren.armstrong85@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: gregkh@suse.de
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging:comedi:ssc_dnp: Fixed coding style issues
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is my first open source patch, so I hope I've got all my ducks in a line :-)

Fixed coding style issues: 80-char width limit, KERN_ facility level

Signed-off-by: Darren Armstrong <darren.armstrong85@gmail.com>
---
 drivers/staging/comedi/drivers/ssv_dnp.c |   86 ++++++++++++++++--------------
 1 files changed, 45 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ssv_dnp.c b/drivers/staging/comedi/drivers/ssv_dnp.c
index 17c92a5..3bec593 100644
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
 
@@ -59,8 +59,9 @@ struct dnp_board {
 	int have_dio;
 };
 
-static const struct dnp_board dnp_boards[] = {	/* we only support one DNP 'board'   */
-	{			/* variant at the moment             */
+/* We only support one DNP 'board' variant at the moment */
+static const struct dnp_board dnp_boards[] = {
+	{
 	 .name = "dnp-1486",
 	 .ai_chans = 16,
 	 .ai_bits = 12,
@@ -80,9 +81,9 @@ struct dnp_private_data {
 #define devpriv ((dnp_private *)dev->private)
 
 /* ------------------------------------------------------------------------- */
-/* The struct comedi_driver structure tells the Comedi core module which functions  */
-/* to call to configure/deconfigure (attach/detach) the board, and also      */
-/* about the kernel module that contains the device code.                    */
+/* The struct comedi_driver structure tells the Comedi core module which     */
+/* functions to call to configure/deconfigure (attach/detach) the board, and */
+/* also about the kernel module that contains the device code.               */
 /*                                                                           */
 /* In the following section we define the API of this driver.                */
 /* ------------------------------------------------------------------------- */
@@ -97,7 +98,7 @@ static struct comedi_driver driver_dnp = {
 	.detach = dnp_detach,
 	.board_name = &dnp_boards[0].name,
 	/* only necessary for non-PnP devs   */
-	.offset = sizeof(struct dnp_board),	/* like ISA-PnP, PCI or PCMCIA.      */
+	.offset = sizeof(struct dnp_board),   /* like ISA-PnP, PCI or PCMCIA */
 	.num_names = ARRAY_SIZE(dnp_boards),
 };
 
@@ -122,28 +123,30 @@ static int dnp_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 
 	struct comedi_subdevice *s;
 
-	printk("comedi%d: dnp: ", dev->minor);
+	printk(KERN_INFO "comedi%d: dnp: ", dev->minor);
 
-	/* Autoprobing: this should find out which board we have. Currently only   */
-	/* the 1486 board is supported and autoprobing is not implemented :-)      */
+	/* Autoprobing: this should find out which board we have. Currently  */
+	/* only the 1486 board is supported and autoprobing is not           */
+	/* implemented :-)                                                   */
 	/* dev->board_ptr = dnp_probe(dev); */
 
-	/* Initialize the name of the board. We can use the "thisboard" macro now. */
+	/* Initialize the name of the board.                                 */
+	/* We can use the "thisboard" macro now.                             */
 	dev->board_name = thisboard->name;
 
-	/* Allocate the private structure area. alloc_private() is a convenient    */
-	/* macro defined in comedidev.h.                                           */
+	/* Allocate the private structure area. alloc_private() is a         */
+	/* convenient macro defined in comedidev.h.                          */
 	if (alloc_private(dev, sizeof(struct dnp_private_data)) < 0)
 		return -ENOMEM;
 
-	/* Allocate the subdevice structures. alloc_subdevice() is a convenient    */
-	/* macro defined in comedidev.h.                                           */
+	/* Allocate the subdevice structures. alloc_subdevice() is a         */
+	/* convenient macro defined in comedidev.h.                          */
 
 	if (alloc_subdevices(dev, 1) < 0)
 		return -ENOMEM;
 
 	s = dev->subdevices + 0;
-	/* digital i/o subdevice                                                   */
+	/* digital i/o subdevice                                             */
 	s->type = COMEDI_SUBD_DIO;
 	s->subdev_flags = SDF_READABLE | SDF_WRITABLE;
 	s->n_chan = 20;
@@ -158,7 +161,7 @@ static int dnp_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	 * allocated for the primary 8259, so we don't need to allocate them
 	 * ourselves. */
 
-	/* configure all ports as input (default)                                  */
+	/* configure all ports as input (default)                            */
 	outb(PAMR, CSCIR);
 	outb(0x00, CSCDR);
 	outb(PBMR, CSCIR);
@@ -181,7 +184,7 @@ static int dnp_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 static int dnp_detach(struct comedi_device *dev)
 {
 
-	/* configure all ports as input (default)                                  */
+	/* configure all ports as input (default)                            */
 	outb(PAMR, CSCIR);
 	outb(0x00, CSCDR);
 	outb(PBMR, CSCIR);
@@ -189,8 +192,8 @@ static int dnp_detach(struct comedi_device *dev)
 	outb(PCMR, CSCIR);
 	outb((inb(CSCDR) & 0xAA), CSCDR);
 
-	/* announce that we are finished                                           */
-	printk("comedi%d: dnp: remove\n", dev->minor);
+	/* announce that we are finished                                     */
+	printk(KERN_INFO "comedi%d: dnp: remove\n", dev->minor);
 
 	return 0;
 
@@ -210,12 +213,12 @@ static int dnp_dio_insn_bits(struct comedi_device *dev,
 	if (insn->n != 2)
 		return -EINVAL;	/* insn uses data[0] and data[1]     */
 
-	/* The insn data is a mask in data[0] and the new data in data[1], each    */
-	/* channel cooresponding to a bit.                                         */
+	/* The insn data is a mask in data[0] and the new data in data[1],   */
+	/* each channel cooresponding to a bit.                              */
 
-	/* Ports A and B are straight forward: each bit corresponds to an output   */
-	/* pin with the same order. Port C is different: bits 0...3 correspond to  */
-	/* bits 4...7 of the output register (PCDR).                               */
+	/* Ports A and B are straight forward: each bit corresponds to an    */
+	/* output pin with the same order. Port C is different: bits 0...3   */
+	/* correspond to bits 4...7 of the output register (PCDR).           */
 
 	if (data[0]) {
 
@@ -235,7 +238,7 @@ static int dnp_dio_insn_bits(struct comedi_device *dev,
 		     | (u8) ((data[1] & 0x0F0000) >> 12), CSCDR);
 	}
 
-	/* on return, data[1] contains the value of the digital input lines.       */
+	/* on return, data[1] contains the value of the digital input lines. */
 	outb(PADR, CSCIR);
 	data[0] = inb(CSCDR);
 	outb(PBDR, CSCIR);
@@ -260,7 +263,8 @@ static int dnp_dio_insn_config(struct comedi_device *dev,
 
 	u8 register_buffer;
 
-	int chan = CR_CHAN(insn->chanspec);	/* reduces chanspec to lower 16 bits */
+	/* reduces chanspec to lower 16 bits */
+	int chan = CR_CHAN(insn->chanspec);
 
 	switch (data[0]) {
 	case INSN_CONFIG_DIO_OUTPUT:
@@ -275,11 +279,11 @@ static int dnp_dio_insn_config(struct comedi_device *dev,
 		return -EINVAL;
 		break;
 	}
-	/* Test: which port does the channel belong to?                            */
+	/* Test: which port does the channel belong to?                       */
 
-	/* We have to pay attention with port C: this is the meaning of PCMR:      */
-	/* Bit in PCMR:              7 6 5 4 3 2 1 0                               */
-	/* Corresponding port C pin: d 3 d 2 d 1 d 0   d= don't touch              */
+	/* We have to pay attention with port C: this is the meaning of PCMR: */
+	/* Bit in PCMR:              7 6 5 4 3 2 1 0                          */
+	/* Corresponding port C pin: d 3 d 2 d 1 d 0   d= don't touch         */
 
 	if ((chan >= 0) && (chan <= 7)) {
 		/* this is port A */
@@ -289,8 +293,8 @@ static int dnp_dio_insn_config(struct comedi_device *dev,
 		chan -= 8;
 		outb(PBMR, CSCIR);
 	} else if ((chan >= 16) && (chan <= 19)) {
-		/* this is port C; multiplication with 2 brings bits into correct        */
-		/* position for PCMR!                                                    */
+		/* this is port C; multiplication with 2 brings bits into     */
+		/* correct position for PCMR!                                 */
 		chan -= 16;
 		chan *= 2;
 		outb(PCMR, CSCIR);
@@ -298,7 +302,7 @@ static int dnp_dio_insn_config(struct comedi_device *dev,
 		return -EINVAL;
 	}
 
-	/* read 'old' direction of the port and set bits (out=1, in=0)             */
+	/* read 'old' direction of the port and set bits (out=1, in=0)        */
 	register_buffer = inb(CSCDR);
 	if (data[0] == COMEDI_OUTPUT)
 		register_buffer |= (1 << chan);
-- 
1.6.3.3


