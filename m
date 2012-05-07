Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757758Ab2EGTOe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 15:14:34 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:13180 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757669Ab2EGTOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 15:14:32 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-209.messagelabs.com!1336418070!4573653!4
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: rename addi CamelCase function pointers
Date: Mon, 7 May 2012 12:14:22 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205071214.22755.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename the CamelCase variable names for the ADDI subdevice
functions. This makes the code a bit cleaner and easier to
follow.

This will also help with converting the struct addi_board
boardtypes array to C99 style initialization to help with
maintaining the code.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

The changes to hwdrv_apci3120.c are all in comments. I haven't looked
at if the comments can be removed yet.

 .../staging/comedi/drivers/addi-data/addi_common.c |   65 ++++-----
 .../staging/comedi/drivers/addi-data/addi_common.h |  143 +++++++-------------
 .../comedi/drivers/addi-data/hwdrv_apci3120.c      |   18 ++--
 3 files changed, 89 insertions(+), 137 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/addi_common.c b/drivers/staging/comedi/drivers/addi-data/addi_common.c
index 5b5dae4..49d11ef 100644
--- a/drivers/staging/comedi/drivers/addi-data/addi_common.c
+++ b/drivers/staging/comedi/drivers/addi-data/addi_common.c
@@ -2819,16 +2819,13 @@ static int i_ADDI_Attach(struct comedi_device *dev, struct comedi_devconfig *it)
 			/* Set the initialisation flag */
 			devpriv->b_AiInitialisation = 1;
 
-			s->insn_config =
-				this_board->i_hwdrv_InsnConfigAnalogInput;
-			s->insn_read = this_board->i_hwdrv_InsnReadAnalogInput;
-			s->insn_write =
-				this_board->i_hwdrv_InsnWriteAnalogInput;
-			s->insn_bits = this_board->i_hwdrv_InsnBitsAnalogInput;
-			s->do_cmdtest =
-				this_board->i_hwdrv_CommandTestAnalogInput;
-			s->do_cmd = this_board->i_hwdrv_CommandAnalogInput;
-			s->cancel = this_board->i_hwdrv_CancelAnalogInput;
+			s->insn_config = this_board->ai_config;
+			s->insn_read = this_board->ai_read;
+			s->insn_write = this_board->ai_write;
+			s->insn_bits = this_board->ai_bits;
+			s->do_cmdtest = this_board->ai_cmdtest;
+			s->do_cmd = this_board->ai_cmd;
+			s->cancel = this_board->ai_cancel;
 
 		} else {
 			s->type = COMEDI_SUBD_UNUSED;
@@ -2844,10 +2841,8 @@ static int i_ADDI_Attach(struct comedi_device *dev, struct comedi_devconfig *it)
 			s->len_chanlist =
 				devpriv->s_EeParameters.i_NbrAoChannel;
 			s->range_table = this_board->pr_AoRangelist;
-			s->insn_config =
-				this_board->i_hwdrv_InsnConfigAnalogOutput;
-			s->insn_write =
-				this_board->i_hwdrv_InsnWriteAnalogOutput;
+			s->insn_config = this_board->ao_config;
+			s->insn_write = this_board->ao_write;
 		} else {
 			s->type = COMEDI_SUBD_UNUSED;
 		}
@@ -2862,12 +2857,10 @@ static int i_ADDI_Attach(struct comedi_device *dev, struct comedi_devconfig *it)
 				devpriv->s_EeParameters.i_NbrDiChannel;
 			s->range_table = &range_digital;
 			s->io_bits = 0;	/* all bits input */
-			s->insn_config =
-				this_board->i_hwdrv_InsnConfigDigitalInput;
-			s->insn_read = this_board->i_hwdrv_InsnReadDigitalInput;
-			s->insn_write =
-				this_board->i_hwdrv_InsnWriteDigitalInput;
-			s->insn_bits = this_board->i_hwdrv_InsnBitsDigitalInput;
+			s->insn_config = this_board->di_config;
+			s->insn_read = this_board->di_read;
+			s->insn_write = this_board->di_write;
+			s->insn_bits = this_board->di_bits;
 		} else {
 			s->type = COMEDI_SUBD_UNUSED;
 		}
@@ -2884,13 +2877,11 @@ static int i_ADDI_Attach(struct comedi_device *dev, struct comedi_devconfig *it)
 			s->range_table = &range_digital;
 			s->io_bits = 0xf;	/* all bits output */
 
-			s->insn_config = this_board->i_hwdrv_InsnConfigDigitalOutput;	/* for digital output memory.. */
-			s->insn_write =
-				this_board->i_hwdrv_InsnWriteDigitalOutput;
-			s->insn_bits =
-				this_board->i_hwdrv_InsnBitsDigitalOutput;
-			s->insn_read =
-				this_board->i_hwdrv_InsnReadDigitalOutput;
+			/* insn_config - for digital output memory */
+			s->insn_config = this_board->do_config;
+			s->insn_write = this_board->do_write;
+			s->insn_bits = this_board->do_bits;
+			s->insn_read = this_board->do_read;
 		} else {
 			s->type = COMEDI_SUBD_UNUSED;
 		}
@@ -2905,10 +2896,10 @@ static int i_ADDI_Attach(struct comedi_device *dev, struct comedi_devconfig *it)
 			s->len_chanlist = 1;
 			s->range_table = &range_digital;
 
-			s->insn_write = this_board->i_hwdrv_InsnWriteTimer;
-			s->insn_read = this_board->i_hwdrv_InsnReadTimer;
-			s->insn_config = this_board->i_hwdrv_InsnConfigTimer;
-			s->insn_bits = this_board->i_hwdrv_InsnBitsTimer;
+			s->insn_write = this_board->timer_write;
+			s->insn_read = this_board->timer_read;
+			s->insn_config = this_board->timer_config;
+			s->insn_bits = this_board->timer_bits;
 		} else {
 			s->type = COMEDI_SUBD_UNUSED;
 		}
@@ -2924,10 +2915,10 @@ static int i_ADDI_Attach(struct comedi_device *dev, struct comedi_devconfig *it)
 			s->io_bits = 0;	/* all bits input */
 			s->len_chanlist = this_board->i_NbrTTLChannel;
 			s->range_table = &range_digital;
-			s->insn_config = this_board->i_hwdr_ConfigInitTTLIO;
-			s->insn_bits = this_board->i_hwdr_ReadTTLIOBits;
-			s->insn_read = this_board->i_hwdr_ReadTTLIOAllPortValue;
-			s->insn_write = this_board->i_hwdr_WriteTTLIOChlOnOff;
+			s->insn_config = this_board->ttl_config;
+			s->insn_bits = this_board->ttl_bits;
+			s->insn_read = this_board->ttl_read;
+			s->insn_write = this_board->ttl_write;
 		} else {
 			s->type = COMEDI_SUBD_UNUSED;
 		}
@@ -3039,7 +3030,7 @@ static int i_ADDI_Detach(struct comedi_device *dev)
 static int i_ADDI_Reset(struct comedi_device *dev)
 {
 
-	this_board->i_hwdrv_Reset(dev);
+	this_board->reset(dev);
 	return 0;
 }
 
@@ -3065,7 +3056,7 @@ static int i_ADDI_Reset(struct comedi_device *dev)
 static irqreturn_t v_ADDI_Interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
-	this_board->v_hwdrv_Interrupt(irq, d);
+	this_board->interrupt(irq, d);
 	return IRQ_RETVAL(1);
 }
 
diff --git a/drivers/staging/comedi/drivers/addi-data/addi_common.h b/drivers/staging/comedi/drivers/addi-data/addi_common.h
index c6980b7..0a153fe 100644
--- a/drivers/staging/comedi/drivers/addi-data/addi_common.h
+++ b/drivers/staging/comedi/drivers/addi-data/addi_common.h
@@ -94,111 +94,72 @@ struct addi_board {
 	unsigned int ui_MinDelaytimeNs;	/*  Minimum Delay in Nano secs */
 
 	/* interrupt and reset */
-	void (*v_hwdrv_Interrupt)(int irq, void *d);
-	int (*i_hwdrv_Reset)(struct comedi_device *dev);
+	void (*interrupt)(int irq, void *d);
+	int (*reset)(struct comedi_device *);
 
 	/* Subdevice functions */
 
 	/* ANALOG INPUT */
-	int (*i_hwdrv_InsnConfigAnalogInput)(struct comedi_device *dev,
-					     struct comedi_subdevice *s,
-					     struct comedi_insn *insn,
-					     unsigned int *data);
-	int (*i_hwdrv_InsnReadAnalogInput)(struct comedi_device *dev,
-					    struct comedi_subdevice *s,
-					    struct comedi_insn *insn,
-					    unsigned int *data);
-	int (*i_hwdrv_InsnWriteAnalogInput)(struct comedi_device *dev,
-					    struct comedi_subdevice *s,
-					    struct comedi_insn *insn,
-					    unsigned int *data);
-	int (*i_hwdrv_InsnBitsAnalogInput)(struct comedi_device *dev,
-					   struct comedi_subdevice *s,
-					   struct comedi_insn *insn,
-					   unsigned int *data);
-	int (*i_hwdrv_CommandTestAnalogInput)(struct comedi_device *dev,
-					      struct comedi_subdevice *s,
-					      struct comedi_cmd *cmd);
-	int (*i_hwdrv_CommandAnalogInput)(struct comedi_device *dev,
-					  struct comedi_subdevice *s);
-	int (*i_hwdrv_CancelAnalogInput)(struct comedi_device *dev,
-					 struct comedi_subdevice *s);
+	int (*ai_config)(struct comedi_device *, struct comedi_subdevice *,
+			 struct comedi_insn *, unsigned int *);
+	int (*ai_read)(struct comedi_device *, struct comedi_subdevice *,
+		       struct comedi_insn *, unsigned int *);
+	int (*ai_write)(struct comedi_device *, struct comedi_subdevice *,
+			struct comedi_insn *, unsigned int *);
+	int (*ai_bits)(struct comedi_device *, struct comedi_subdevice *,
+		       struct comedi_insn *, unsigned int *);
+	int (*ai_cmdtest)(struct comedi_device *, struct comedi_subdevice *,
+			  struct comedi_cmd *);
+	int (*ai_cmd)(struct comedi_device *, struct comedi_subdevice *);
+	int (*ai_cancel)(struct comedi_device *, struct comedi_subdevice *);
 
 	/* Analog Output */
-	int (*i_hwdrv_InsnConfigAnalogOutput)(struct comedi_device *dev,
-					      struct comedi_subdevice *s,
-					      struct comedi_insn *insn,
-					      unsigned int *data);
-	int (*i_hwdrv_InsnWriteAnalogOutput)(struct comedi_device *dev,
-					     struct comedi_subdevice *s,
-					     struct comedi_insn *insn,
-					     unsigned int *data);
-	int (*i_hwdrv_InsnBitsAnalogOutput)(struct comedi_device *dev,
-					    struct comedi_subdevice *s,
-					    struct comedi_insn *insn,
-					    unsigned int *data);
+	int (*ao_config)(struct comedi_device *, struct comedi_subdevice *,
+			 struct comedi_insn *, unsigned int *);
+	int (*ao_write)(struct comedi_device *, struct comedi_subdevice *,
+			struct comedi_insn *, unsigned int *);
+	int (*ao_bits)(struct comedi_device *, struct comedi_subdevice *,
+		       struct comedi_insn *, unsigned int *);
 
 	/* Digital Input */
-	int (*i_hwdrv_InsnConfigDigitalInput) (struct comedi_device *dev,
-					       struct comedi_subdevice *s,
-					       struct comedi_insn *insn,
-					       unsigned int *data);
-	int (*i_hwdrv_InsnReadDigitalInput) (struct comedi_device *dev,
-					     struct comedi_subdevice *s,
-					     struct comedi_insn *insn,
-					     unsigned int *data);
-	int (*i_hwdrv_InsnWriteDigitalInput) (struct comedi_device *dev,
-					      struct comedi_subdevice *s,
-					      struct comedi_insn *insn,
-					      unsigned int *data);
-	int (*i_hwdrv_InsnBitsDigitalInput) (struct comedi_device *dev,
-					     struct comedi_subdevice *s,
-					     struct comedi_insn *insn,
-					     unsigned int *data);
+	int (*di_config)(struct comedi_device *, struct comedi_subdevice *,
+			 struct comedi_insn *, unsigned int *);
+	int (*di_read)(struct comedi_device *, struct comedi_subdevice *,
+		       struct comedi_insn *, unsigned int *);
+	int (*di_write)(struct comedi_device *, struct comedi_subdevice *,
+			struct comedi_insn *, unsigned int *);
+	int (*di_bits)(struct comedi_device *, struct comedi_subdevice *,
+		       struct comedi_insn *, unsigned int *);
 
 	/* Digital Output */
-	int (*i_hwdrv_InsnConfigDigitalOutput)(struct comedi_device *dev,
-					       struct comedi_subdevice *s,
-					       struct comedi_insn *insn,
-					       unsigned int *data);
-	int (*i_hwdrv_InsnWriteDigitalOutput)(struct comedi_device *dev,
-					      struct comedi_subdevice *s,
-					      struct comedi_insn *insn,
-					      unsigned int *data);
-	int (*i_hwdrv_InsnBitsDigitalOutput)(struct comedi_device *dev,
-					     struct comedi_subdevice *s,
-					     struct comedi_insn *insn,
-					     unsigned int *data);
-	int (*i_hwdrv_InsnReadDigitalOutput)(struct comedi_device *dev,
-					     struct comedi_subdevice *s,
-					     struct comedi_insn *insn,
-					     unsigned int *data);
+	int (*do_config)(struct comedi_device *, struct comedi_subdevice *,
+			 struct comedi_insn *, unsigned int *);
+	int (*do_write)(struct comedi_device *, struct comedi_subdevice *,
+			struct comedi_insn *, unsigned int *);
+	int (*do_bits)(struct comedi_device *, struct comedi_subdevice *,
+		       struct comedi_insn *, unsigned int *);
+	int (*do_read)(struct comedi_device *, struct comedi_subdevice *,
+		       struct comedi_insn *, unsigned int *);
 
 	/* TIMER */
-	int (*i_hwdrv_InsnConfigTimer)(struct comedi_device *dev,
-				       struct comedi_subdevice *s,
-				       struct comedi_insn *insn, unsigned int *data);
-	int (*i_hwdrv_InsnWriteTimer)(struct comedi_device *dev,
-				      struct comedi_subdevice *s, struct comedi_insn *insn,
-				      unsigned int *data);
-	int (*i_hwdrv_InsnReadTimer)(struct comedi_device *dev, struct comedi_subdevice *s,
-				     struct comedi_insn *insn, unsigned int *data);
-	int (*i_hwdrv_InsnBitsTimer)(struct comedi_device *dev, struct comedi_subdevice *s,
-				     struct comedi_insn *insn, unsigned int *data);
+	int (*timer_config)(struct comedi_device *, struct comedi_subdevice *,
+			    struct comedi_insn *, unsigned int *);
+	int (*timer_write)(struct comedi_device *, struct comedi_subdevice *,
+			   struct comedi_insn *, unsigned int *);
+	int (*timer_read)(struct comedi_device *, struct comedi_subdevice *,
+			  struct comedi_insn *, unsigned int *);
+	int (*timer_bits)(struct comedi_device *, struct comedi_subdevice *,
+			  struct comedi_insn *, unsigned int *);
 
 	/* TTL IO */
-	int (*i_hwdr_ConfigInitTTLIO)(struct comedi_device *dev,
-				      struct comedi_subdevice *s, struct comedi_insn *insn,
-				      unsigned int *data);
-	int (*i_hwdr_ReadTTLIOBits)(struct comedi_device *dev, struct comedi_subdevice *s,
-				    struct comedi_insn *insn, unsigned int *data);
-	int (*i_hwdr_ReadTTLIOAllPortValue)(struct comedi_device *dev,
-					    struct comedi_subdevice *s,
-					    struct comedi_insn *insn,
-					    unsigned int *data);
-	int (*i_hwdr_WriteTTLIOChlOnOff)(struct comedi_device *dev,
-					 struct comedi_subdevice *s,
-					 struct comedi_insn *insn, unsigned int *data);
+	int (*ttl_config)(struct comedi_device *, struct comedi_subdevice *,
+			  struct comedi_insn *, unsigned int *);
+	int (*ttl_bits)(struct comedi_device *, struct comedi_subdevice *,
+			struct comedi_insn *, unsigned int *);
+	int (*ttl_read)(struct comedi_device *, struct comedi_subdevice *,
+			struct comedi_insn *, unsigned int *);
+	int (*ttl_write)(struct comedi_device *, struct comedi_subdevice *,
+			 struct comedi_insn *, unsigned int *);
 };
 
 /* MODULE INFO STRUCTURE */
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c
index e886ced..ffe390c 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c
@@ -156,7 +156,7 @@ int i_APCI3120_InsnReadAnalogInput(struct comedi_device *dev, struct comedi_subd
 	} else
 		us_ConvertTiming = (unsigned short) (devpriv->ui_EocEosConversionTime / 1000);	/*  nano to useconds */
 
-	/*  this_board->i_hwdrv_InsnReadAnalogInput(dev,us_ConvertTiming,insn->n,&insn->chanspec,data,insn->unused[0]); */
+	/*  this_board->ai_read(dev,us_ConvertTiming,insn->n,&insn->chanspec,data,insn->unused[0]); */
 
 	/*  Clear software registers */
 	devpriv->b_TimerSelectMode = 0;
@@ -670,7 +670,7 @@ int i_APCI3120_CommandAnalogInput(struct comedi_device *dev, struct comedi_subde
 			/*  mode 1 */
 
 			devpriv->ui_AiTimer0 = cmd->convert_arg;	/*  timer constant in nano seconds */
-			/* return this_board->i_hwdrv_CommandAnalogInput(1,dev,s); */
+			/* return this_board->ai_cmd(1,dev,s); */
 			return i_APCI3120_CyclicAnalogInput(1, dev, s);
 		}
 
@@ -680,7 +680,7 @@ int i_APCI3120_CommandAnalogInput(struct comedi_device *dev, struct comedi_subde
 		/*  mode 2 */
 		devpriv->ui_AiTimer1 = cmd->scan_begin_arg;
 		devpriv->ui_AiTimer0 = cmd->convert_arg;	/*  variable changed timer2 to timer0 */
-		/* return this_board->i_hwdrv_CommandAnalogInput(2,dev,s); */
+		/* return this_board->ai_cmd(2,dev,s); */
 		return i_APCI3120_CyclicAnalogInput(2, dev, s);
 	}
 	return -1;
@@ -1922,7 +1922,7 @@ int i_APCI3120_InsnConfigTimer(struct comedi_device *dev, struct comedi_subdevic
 
 	ui_Timervalue2 = data[1] / 1000;	/*  convert nano seconds  to u seconds */
 
-	/* this_board->i_hwdrv_InsnConfigTimer(dev, ui_Timervalue2,(unsigned char)data[0]); */
+	/* this_board->timer_config(dev, ui_Timervalue2,(unsigned char)data[0]); */
 	us_TmpValue = (unsigned short) inw(devpriv->iobase + APCI3120_RD_STATUS);
 
 /*
@@ -2092,7 +2092,7 @@ int i_APCI3120_InsnWriteTimer(struct comedi_device *dev, struct comedi_subdevice
 			ui_Timervalue2 = 0;
 	}
 
-	/* this_board->i_hwdrv_InsnWriteTimer(dev,data[0],ui_Timervalue2); */
+	/* this_board->timer_write(dev,data[0],ui_Timervalue2); */
 
 	switch (data[0]) {
 	case APCI3120_START:
@@ -2260,7 +2260,7 @@ int i_APCI3120_InsnReadTimer(struct comedi_device *dev, struct comedi_subdevice
 		comedi_error(dev, "\nread:timer2  not configured ");
 	}
 
-	/* this_board->i_hwdrv_InsnReadTimer(dev,data); */
+	/* this_board->timer_read(dev,data); */
 	if (devpriv->b_Timer2Mode == APCI3120_TIMER) {
 
 		/* Read the LOW unsigned short of Timer 2 register */
@@ -2331,7 +2331,7 @@ int i_APCI3120_InsnReadDigitalInput(struct comedi_device *dev,
 
 	ui_Chan = CR_CHAN(insn->chanspec);	/*  channel specified */
 
-	/* this_board->i_hwdrv_InsnReadDigitalInput(dev,ui_Chan,data); */
+	/* this_board->di_read(dev,ui_Chan,data); */
 	if (ui_Chan <= 3) {
 		ui_TmpValue = (unsigned int) inw(devpriv->iobase + APCI3120_RD_STATUS);
 
@@ -2379,7 +2379,7 @@ int i_APCI3120_InsnBitsDigitalInput(struct comedi_device *dev, struct comedi_sub
 	*****/
 
 	*data = (ui_TmpValue >> 8) & 0xf;
-	/* this_board->i_hwdrv_InsnBitsDigitalInput(dev,data); */
+	/* this_board->di_bits(dev,data); */
 	return insn->n;
 }
 
@@ -2595,7 +2595,7 @@ int i_APCI3120_InsnWriteAnalogOutput(struct comedi_device *dev,
 	ui_Range = CR_RANGE(insn->chanspec);
 	ui_Channel = CR_CHAN(insn->chanspec);
 
-	/* this_board->i_hwdrv_InsnWriteAnalogOutput(dev, ui_Range, ui_Channel,data[0]); */
+	/* this_board->ao_write(dev, ui_Range, ui_Channel,data[0]); */
 	if (ui_Range) {		/*  if 1 then unipolar */
 
 		if (data[0] != 0)
