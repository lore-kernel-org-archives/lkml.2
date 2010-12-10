Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803Ab0LJTHg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 14:07:36 -0500
Received: from mail-ey0-f171.google.com ([209.85.215.171]:32982 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756383Ab0LJTHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 14:07:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=kcjlsfQ3rMcXwAHfencv6koFmMVvJLencgUTcCE+KuQEQdUa78hqSnq4jIHcTDm+kT
         zcX/29lG41tgm2+xDWdGSgw3A5Ae9r77BslrKwpGZfw/HTdriz6pek43N8UYf1nzaTtK
         uFldpzaipqG7QvyQyg6jJRuyk2im87C1V/NQc=
From: Xenofon Foukas <foukas.xenofon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Xenofon Foukas <foukas.xenofon@gmail.com>
Subject: [PATCH] Fix coding style issues in ni_tiocmd.c
Date: Fri, 10 Dec 2010 21:07:25 +0200
Message-Id: <1292008045-6425-1-git-send-email-foukas.xenofon@gmail.com>
X-Mailer: git-send-email 1.7.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following issues in ni_tiocmd.c:

WARNING: braces {} are not necessary for any arm of this statement
WARNING: braces {} are not necessary for single statement blocks
WARNING: printk() should include KERN_ facility level
WARNING: line over 80 characters
__func__ should be used instead of gcc specific __FUNCTION__
ERROR: that open brace { should be on the previous line
WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable

Signed-off-by: Xenofon Foukas <foukas.xenofon@gmail.com>
---
 drivers/staging/comedi/drivers/ni_tiocmd.c |   71 +++++++++++++---------------
 1 files changed, 33 insertions(+), 38 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_tiocmd.c b/drivers/staging/comedi/drivers/ni_tiocmd.c
index b0d44b5..a961158 100644
--- a/drivers/staging/comedi/drivers/ni_tiocmd.c
+++ b/drivers/staging/comedi/drivers/ni_tiocmd.c
@@ -62,11 +62,10 @@ static void ni_tio_configure_dma(struct ni_gpct *counter, short enable,
 	unsigned input_select_bits = 0;
 
 	if (enable) {
-		if (read_not_write) {
+		if (read_not_write)
 			input_select_bits |= Gi_Read_Acknowledges_Irq;
-		} else {
+		else
 			input_select_bits |= Gi_Write_Acknowledges_Irq;
-		}
 	}
 	ni_tio_set_bits(counter,
 			NITIO_Gi_Input_Select_Reg(counter->counter_index),
@@ -84,9 +83,8 @@ static void ni_tio_configure_dma(struct ni_gpct *counter, short enable,
 				gi_dma_config_bits |= Gi_DMA_Enable_Bit;
 				gi_dma_config_bits |= Gi_DMA_Int_Bit;
 			}
-			if (read_not_write == 0) {
+			if (read_not_write == 0)
 				gi_dma_config_bits |= Gi_DMA_Write_Bit;
-			}
 			ni_tio_set_bits(counter,
 					NITIO_Gi_DMA_Config_Reg(counter->
 								counter_index),
@@ -174,7 +172,7 @@ static int ni_tio_input_cmd(struct ni_gpct *counter, struct comedi_async *async)
 static int ni_tio_output_cmd(struct ni_gpct *counter,
 			     struct comedi_async *async)
 {
-	printk("ni_tio: output commands not yet implemented.\n");
+	printk(KERN_ERR "ni_tio: output commands not yet implemented.\n");
 	return -ENOTSUPP;
 
 	counter->mite_chan->dir = COMEDI_OUTPUT;
@@ -198,9 +196,8 @@ static int ni_tio_cmd_setup(struct ni_gpct *counter, struct comedi_async *async)
 		set_gate_source = 1;
 		gate_source = cmd->convert_arg;
 	}
-	if (set_gate_source) {
+	if (set_gate_source)
 		retval = ni_tio_set_gate_src(counter, 0, gate_source);
-	}
 	if (cmd->flags & TRIG_WAKE_EOS) {
 		ni_tio_set_bits(counter,
 				NITIO_Gi_Interrupt_Enable_Reg(counter->
@@ -221,22 +218,21 @@ int ni_tio_cmd(struct ni_gpct *counter, struct comedi_async *async)
 
 	spin_lock_irqsave(&counter->lock, flags);
 	if (counter->mite_chan == NULL) {
-		printk
-		    ("ni_tio: commands only supported with DMA.  Interrupt-driven commands not yet implemented.\n");
+		printk(KERN_ERR "ni_tio: commands only supported with DMA.  Interrupt-driven commands not yet implemented.\n");
 		retval = -EIO;
 	} else {
 		retval = ni_tio_cmd_setup(counter, async);
 		if (retval == 0) {
-			if (cmd->flags & CMDF_WRITE) {
+			if (cmd->flags & CMDF_WRITE)
 				retval = ni_tio_output_cmd(counter, async);
-			} else {
+			else
 				retval = ni_tio_input_cmd(counter, async);
-			}
 		}
 	}
 	spin_unlock_irqrestore(&counter->lock, flags);
 	return retval;
 }
+EXPORT_SYMBOL_GPL(ni_tio_cmd);
 
 int ni_tio_cmdtest(struct ni_gpct *counter, struct comedi_cmd *cmd)
 {
@@ -342,6 +338,7 @@ int ni_tio_cmdtest(struct ni_gpct *counter, struct comedi_cmd *cmd)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(ni_tio_cmdtest);
 
 int ni_tio_cancel(struct ni_gpct *counter)
 {
@@ -349,9 +346,8 @@ int ni_tio_cancel(struct ni_gpct *counter)
 
 	ni_tio_arm(counter, 0, 0);
 	spin_lock_irqsave(&counter->lock, flags);
-	if (counter->mite_chan) {
+	if (counter->mite_chan)
 		mite_dma_disarm(counter->mite_chan);
-	}
 	spin_unlock_irqrestore(&counter->lock, flags);
 	ni_tio_configure_dma(counter, 0, 0);
 
@@ -361,10 +357,11 @@ int ni_tio_cancel(struct ni_gpct *counter)
 			0x0);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(ni_tio_cancel);
 
-	/* During buffered input counter operation for e-series, the gate interrupt is acked
-	   automatically by the dma controller, due to the Gi_Read/Write_Acknowledges_IRQ bits
-	   in the input select register.  */
+	/* During buffered input counter operation for e-series, the gate
+	   interrupt is acked automatically by the dma controller, due to the
+	   Gi_Read/Write_Acknowledges_IRQ bits in the input select register.  */
 static int should_ack_gate(struct ni_gpct *counter)
 {
 	unsigned long flags;
@@ -372,7 +369,10 @@ static int should_ack_gate(struct ni_gpct *counter)
 
 	switch (counter->counter_dev->variant) {
 	case ni_gpct_variant_m_series:
-	case ni_gpct_variant_660x:	/*  not sure if 660x really supports gate interrupts (the bits are not listed in register-level manual) */
+	/*  not sure if 660x really supports gate
+	    interrupts (the bits are not listed
+	    in register-level manual) */
+	case ni_gpct_variant_660x:
 		return 1;
 		break;
 	case ni_gpct_variant_e_series:
@@ -416,7 +416,8 @@ void ni_tio_acknowledge_and_confirm(struct ni_gpct *counter, int *gate_error,
 	if (gxx_status & Gi_Gate_Error_Bit(counter->counter_index)) {
 		ack |= Gi_Gate_Error_Confirm_Bit(counter->counter_index);
 		if (gate_error) {
-			/*660x don't support automatic acknowledgement of gate interrupt via dma read/write
+			/*660x don't support automatic acknowledgement
+			  of gate interrupt via dma read/write
 			   and report bogus gate errors */
 			if (counter->counter_dev->variant !=
 			    ni_gpct_variant_660x) {
@@ -429,9 +430,8 @@ void ni_tio_acknowledge_and_confirm(struct ni_gpct *counter, int *gate_error,
 		if (tc_error)
 			*tc_error = 1;
 	}
-	if (gi_status & Gi_TC_Bit) {
+	if (gi_status & Gi_TC_Bit)
 		ack |= Gi_TC_Interrupt_Ack_Bit;
-	}
 	if (gi_status & Gi_Gate_Interrupt_Bit) {
 		if (should_ack_gate(counter))
 			ack |= Gi_Gate_Interrupt_Ack_Bit;
@@ -452,13 +452,14 @@ void ni_tio_acknowledge_and_confirm(struct ni_gpct *counter, int *gate_error,
 				  NITIO_Gxx_Joint_Status2_Reg
 				  (counter->counter_index)) &
 		    Gi_Permanent_Stale_Bit(counter->counter_index)) {
-			printk("%s: Gi_Permanent_Stale_Data detected.\n",
-			       __FUNCTION__);
+			printk(KERN_INFO "%s: Gi_Permanent_Stale_Data detected.\n",
+			       __func__);
 			if (perm_stale_data)
 				*perm_stale_data = 1;
 		}
 	}
 }
+EXPORT_SYMBOL_GPL(ni_tio_acknowledge_and_confirm);
 
 void ni_tio_handle_interrupt(struct ni_gpct *counter,
 			     struct comedi_subdevice *s)
@@ -472,20 +473,19 @@ void ni_tio_handle_interrupt(struct ni_gpct *counter,
 	ni_tio_acknowledge_and_confirm(counter, &gate_error, &tc_error,
 				       &perm_stale_data, NULL);
 	if (gate_error) {
-		printk("%s: Gi_Gate_Error detected.\n", __FUNCTION__);
+		printk(KERN_NOTICE "%s: Gi_Gate_Error detected.\n", __func__);
 		s->async->events |= COMEDI_CB_OVERFLOW;
 	}
-	if (perm_stale_data) {
+	if (perm_stale_data)
 		s->async->events |= COMEDI_CB_ERROR;
-	}
 	switch (counter->counter_dev->variant) {
 	case ni_gpct_variant_m_series:
 	case ni_gpct_variant_660x:
 		if (read_register(counter,
-				  NITIO_Gi_DMA_Status_Reg
-				  (counter->counter_index)) & Gi_DRQ_Error_Bit)
-		{
-			printk("%s: Gi_DRQ_Error detected.\n", __FUNCTION__);
+				NITIO_Gi_DMA_Status_Reg
+				(counter->counter_index)) & Gi_DRQ_Error_Bit) {
+			printk(KERN_NOTICE "%s: Gi_DRQ_Error detected.\n",
+							__func__);
 			s->async->events |= COMEDI_CB_OVERFLOW;
 		}
 		break;
@@ -506,6 +506,7 @@ void ni_tio_handle_interrupt(struct ni_gpct *counter,
 	mite_sync_input_dma(counter->mite_chan, s->async);
 	spin_unlock_irqrestore(&counter->lock, flags);
 }
+EXPORT_SYMBOL_GPL(ni_tio_handle_interrupt);
 
 void ni_tio_set_mite_channel(struct ni_gpct *counter,
 			     struct mite_channel *mite_chan)
@@ -516,6 +517,7 @@ void ni_tio_set_mite_channel(struct ni_gpct *counter,
 	counter->mite_chan = mite_chan;
 	spin_unlock_irqrestore(&counter->lock, flags);
 }
+EXPORT_SYMBOL_GPL(ni_tio_set_mite_channel);
 
 static int __init ni_tiocmd_init_module(void)
 {
@@ -529,10 +531,3 @@ static void __exit ni_tiocmd_cleanup_module(void)
 }
 
 module_exit(ni_tiocmd_cleanup_module);
-
-EXPORT_SYMBOL_GPL(ni_tio_cmd);
-EXPORT_SYMBOL_GPL(ni_tio_cmdtest);
-EXPORT_SYMBOL_GPL(ni_tio_cancel);
-EXPORT_SYMBOL_GPL(ni_tio_handle_interrupt);
-EXPORT_SYMBOL_GPL(ni_tio_set_mite_channel);
-EXPORT_SYMBOL_GPL(ni_tio_acknowledge_and_confirm);
-- 
1.7.3.3

