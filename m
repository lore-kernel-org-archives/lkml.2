Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751596Ab0KCVTo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 17:19:44 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:46212 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab0KCVTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 17:19:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=SK+WFxDs5P9XCcy0RSVvdcAthhr+ivg6tMLtuzOCf2tc4ibjw58nNFohuhuzwa8j2i
         BJTFfs/DtHAmy5PdKPS1LpyRCJeyug2zL+i5jQDx+XA3xHl6328LKBo96+OqeSX0oJ1W
         nLGU3TIZ2SFohGFffQJePKmJexQ8NXcD/ICpU=
From: Damian Varayud <davarayud@gmail.com>
To: gregkh@suse.de, harmonco@engr.orst.edu, sam.j.richardson@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] Staging: comedi: fix brace coding style issue in ni_tio.c This is a patch to the ni_tio.c file that fixes up a brace, indentation and overlines warning found by the checkpatch.pl tool Signed-off-by: Varayud Damian Alfredo <davarayud@gmail.com>
Date: Wed,  3 Nov 2010 18:19:20 -0300
Message-Id: <1288819162-6330-1-git-send-email-user@netbu>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/staging/comedi/drivers/ni_tio.c |  154 ++++++++++++++++++-------------
 1 files changed, 89 insertions(+), 65 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_tio.c b/drivers/staging/comedi/drivers/ni_tio.c
index a9bb6b1..dd3db48 100644
--- a/drivers/staging/comedi/drivers/ni_tio.c
+++ b/drivers/staging/comedi/drivers/ni_tio.c
@@ -59,8 +59,8 @@ MODULE_DESCRIPTION("Comedi support for NI general-purpose counters");
 MODULE_LICENSE("GPL");
 
 static inline enum Gi_Counting_Mode_Reg_Bits Gi_Alternate_Sync_Bit(enum
-								   ni_gpct_variant
-								   variant)
+								ni_gpct_variant
+								variant)
 {
 	switch (variant) {
 	case ni_gpct_variant_e_series:
@@ -122,8 +122,8 @@ static inline enum Gi_Counting_Mode_Reg_Bits Gi_Prescale_X8_Bit(enum
 }
 
 static inline enum Gi_Counting_Mode_Reg_Bits Gi_HW_Arm_Select_Mask(enum
-								   ni_gpct_variant
-								   variant)
+								ni_gpct_variant
+								variant)
 {
 	switch (variant) {
 	case ni_gpct_variant_e_series:
@@ -166,16 +166,21 @@ static inline unsigned NI_660x_Source_Pin_Clock(unsigned n)
 	return 0x2 + n;
 }
 
-/* clock sources for ni e and m series boards, get bits with Gi_Source_Select_Bits() */
+/* clock sources for ni e and m series boards,
+	get bits with Gi_Source_Select_Bits() */
 enum ni_m_series_clock_source {
 	NI_M_Series_Timebase_1_Clock = 0x0,	/* 20MHz */
 	NI_M_Series_Timebase_2_Clock = 0x12,	/* 100KHz */
 	NI_M_Series_Next_TC_Clock = 0x13,
-	NI_M_Series_Next_Gate_Clock = 0x14,	/* when Gi_Src_SubSelect = 0 */
-	NI_M_Series_PXI_Star_Trigger_Clock = 0x14,	/* when Gi_Src_SubSelect = 1 */
+	/* when Gi_Src_SubSelect = 0 */
+	NI_M_Series_Next_Gate_Clock = 0x14,
+	/* when Gi_Src_SubSelect = 1 */
+	NI_M_Series_PXI_Star_Trigger_Clock = 0x14,
 	NI_M_Series_PXI10_Clock = 0x1d,
-	NI_M_Series_Timebase_3_Clock = 0x1e,	/* 80MHz, when Gi_Src_SubSelect = 0 */
-	NI_M_Series_Analog_Trigger_Out_Clock = 0x1e,	/* when Gi_Src_SubSelect = 1 */
+	/* 80MHz, when Gi_Src_SubSelect = 0 */
+	NI_M_Series_Timebase_3_Clock = 0x1e,
+	/* when Gi_Src_SubSelect = 1 */
+	NI_M_Series_Analog_Trigger_Out_Clock = 0x1e,
 	NI_M_Series_Logic_Low_Clock = 0x1f,
 };
 static const unsigned ni_m_series_max_pfi_channel = 15;
@@ -276,7 +281,7 @@ static inline unsigned NI_660x_RTSI_Second_Gate_Select(unsigned n)
 }
 
 static const unsigned int counter_status_mask =
-    COMEDI_COUNTER_ARMED | COMEDI_COUNTER_COUNTING;
+	COMEDI_COUNTER_ARMED | COMEDI_COUNTER_COUNTING;
 
 static int __init ni_tio_init_module(void)
 {
@@ -291,21 +296,22 @@ static void __exit ni_tio_cleanup_module(void)
 
 module_exit(ni_tio_cleanup_module);
 
-struct ni_gpct_device *ni_gpct_device_construct(struct comedi_device *dev,
-						void (*write_register) (struct
-									ni_gpct
-									*
-									counter,
-									unsigned
-									bits,
-									enum
-									ni_gpct_register
-									reg),
-						unsigned (*read_register)
-						(struct ni_gpct *counter,
-						 enum ni_gpct_register reg),
-						enum ni_gpct_variant variant,
-						unsigned num_counters)
+struct ni_gpct_device *ni_gpct_device_construct
+				(struct comedi_device *dev,
+				void (*write_register) (struct
+							ni_gpct
+							*
+							counter,
+							unsigned
+							bits,
+							enum
+							ni_gpct_register
+							reg),
+				unsigned (*read_register)
+				(struct ni_gpct *counter,
+					enum ni_gpct_register reg),
+				enum ni_gpct_variant variant,
+				unsigned num_counters)
 {
 	unsigned i;
 
@@ -320,7 +326,7 @@ struct ni_gpct_device *ni_gpct_device_construct(struct comedi_device *dev,
 	spin_lock_init(&counter_dev->regs_lock);
 	BUG_ON(num_counters == 0);
 	counter_dev->counters =
-	    kzalloc(sizeof(struct ni_gpct) * num_counters, GFP_KERNEL);
+	    kzalloc(sizeof(struct ni_gpct) *num_counters, GFP_KERNEL);
 	if (counter_dev->counters == NULL) {
 		kfree(counter_dev);
 		return NULL;
@@ -427,7 +433,7 @@ static unsigned int ni_tio_counter_status(struct ni_gpct *counter)
 	unsigned int status = 0;
 	const unsigned bits = read_register(counter,
 					    NITIO_Gxx_Status_Reg(counter->
-								 counter_index));
+							    counter_index));
 	if (bits & Gi_Armed_Bit(counter->counter_index)) {
 		status |= COMEDI_COUNTER_ARMED;
 		if (bits & Gi_Counting_Bit(counter->counter_index))
@@ -443,13 +449,14 @@ static void ni_tio_set_sync_mode(struct ni_gpct *counter, int force_alt_sync)
 	    NITIO_Gi_Counting_Mode_Reg(counter->counter_index);
 	static const uint64_t min_normal_sync_period_ps = 25000;
 	const uint64_t clock_period_ps = ni_tio_clock_period_ps(counter,
-								ni_tio_generic_clock_src_select
-								(counter));
+						ni_tio_generic_clock_src_select
+						(counter));
 
 	if (ni_tio_counting_mode_registers_present(counter_dev) == 0)
 		return;
 
-	switch (ni_tio_get_soft_copy(counter, counting_mode_reg) & Gi_Counting_Mode_Mask) {
+	switch (ni_tio_get_soft_copy(counter, counting_mode_reg)
+		& Gi_Counting_Mode_Mask) {
 	case Gi_Counting_Mode_QuadratureX1_Bits:
 	case Gi_Counting_Mode_QuadratureX2_Bits:
 	case Gi_Counting_Mode_QuadratureX4_Bits:
@@ -459,9 +466,9 @@ static void ni_tio_set_sync_mode(struct ni_gpct *counter, int force_alt_sync)
 	default:
 		break;
 	}
-	/* It's not clear what we should do if clock_period is unknown, so we are not
-	   using the alt sync bit in that case, but allow the caller to decide by using the
-	   force_alt_sync parameter. */
+	/* It's not clear what we should do if clock_period is unknown,
+	   so we are not using the alt sync bit in that case, but allow
+	   the caller to decide by using the force_alt_sync parameter. */
 	if (force_alt_sync ||
 	    (clock_period_ps && clock_period_ps < min_normal_sync_period_ps)) {
 		ni_tio_set_bits(counter, counting_mode_reg,
@@ -567,7 +574,9 @@ int ni_tio_arm(struct ni_gpct *counter, int arm, unsigned start_trigger)
 				break;
 			default:
 				if (start_trigger & NI_GPCT_ARM_UNKNOWN) {
-					/* pass-through the least significant bits so we can figure out what select later */
+					/* pass-through the least significant
+					bits so we can figure out
+					what select later */
 					unsigned hw_arm_select_bits =
 					    (start_trigger <<
 					     Gi_HW_Arm_Select_Shift) &
@@ -631,7 +640,8 @@ static unsigned ni_660x_source_select_bits(unsigned int clock_source)
 		break;
 	default:
 		for (i = 0; i <= ni_660x_max_rtsi_channel; ++i) {
-			if (clock_select_bits == NI_GPCT_RTSI_CLOCK_SRC_BITS(i)) {
+			if (clock_select_bits ==
+			    NI_GPCT_RTSI_CLOCK_SRC_BITS(i)) {
 				ni_660x_clock = NI_660x_RTSI_Clock(i);
 				break;
 			}
@@ -690,7 +700,8 @@ static unsigned ni_m_series_source_select_bits(unsigned int clock_source)
 		break;
 	default:
 		for (i = 0; i <= ni_m_series_max_rtsi_channel; ++i) {
-			if (clock_select_bits == NI_GPCT_RTSI_CLOCK_SRC_BITS(i)) {
+			if (clock_select_bits ==
+			    NI_GPCT_RTSI_CLOCK_SRC_BITS(i)) {
 				ni_m_series_clock = NI_M_Series_RTSI_Clock(i);
 				break;
 			}
@@ -698,7 +709,8 @@ static unsigned ni_m_series_source_select_bits(unsigned int clock_source)
 		if (i <= ni_m_series_max_rtsi_channel)
 			break;
 		for (i = 0; i <= ni_m_series_max_pfi_channel; ++i) {
-			if (clock_select_bits == NI_GPCT_PFI_CLOCK_SRC_BITS(i)) {
+			if (clock_select_bits ==
+			    NI_GPCT_PFI_CLOCK_SRC_BITS(i)) {
 				ni_m_series_clock = NI_M_Series_PFI_Clock(i);
 				break;
 			}
@@ -808,9 +820,9 @@ static unsigned ni_tio_clock_src_modifiers(const struct ni_gpct *counter)
 {
 	struct ni_gpct_device *counter_dev = counter->counter_dev;
 	const unsigned counting_mode_bits = ni_tio_get_soft_copy(counter,
-								 NITIO_Gi_Counting_Mode_Reg
-								 (counter->
-								  counter_index));
+						    NITIO_Gi_Counting_Mode_Reg
+						    (counter->
+						    counter_index));
 	unsigned bits = 0;
 
 	if (ni_tio_get_soft_copy(counter,
@@ -833,8 +845,8 @@ static unsigned ni_m_series_clock_src_select(const struct ni_gpct *counter)
 	unsigned clock_source = 0;
 	unsigned i;
 	const unsigned input_select = (ni_tio_get_soft_copy(counter,
-							    NITIO_Gi_Input_Select_Reg
-							    (counter->counter_index))
+						      NITIO_Gi_Input_Select_Reg
+						      (counter->counter_index))
 				       & Gi_Source_Select_Mask) >>
 	    Gi_Source_Select_Shift;
 
@@ -898,8 +910,8 @@ static unsigned ni_660x_clock_src_select(const struct ni_gpct *counter)
 	unsigned clock_source = 0;
 	unsigned i;
 	const unsigned input_select = (ni_tio_get_soft_copy(counter,
-							    NITIO_Gi_Input_Select_Reg
-							    (counter->counter_index))
+						      NITIO_Gi_Input_Select_Reg
+						      (counter->counter_index))
 				       & Gi_Source_Select_Mask) >>
 	    Gi_Source_Select_Shift;
 
@@ -986,7 +998,8 @@ static uint64_t ni_tio_clock_period_ps(const struct ni_gpct *counter,
 		clock_period_ps = 100000;
 		break;
 	default:
-		/* clock period is specified by user with prescaling already taken into account. */
+		/* clock period is specified by user
+		   with prescaling already taken into account. */
 		return counter->clock_period_ps;
 		break;
 	}
@@ -1039,7 +1052,8 @@ static int ni_660x_set_first_gate(struct ni_gpct *counter,
 				  unsigned int gate_source)
 {
 	const unsigned selected_gate = CR_CHAN(gate_source);
-	/* bits of selected_gate that may be meaningful to input select register */
+	/* bits of selected_gate that may be meaningful
+	   to input select register */
 	const unsigned selected_gate_mask = 0x1f;
 	unsigned ni_660x_gate_select;
 	unsigned i;
@@ -1087,7 +1101,8 @@ static int ni_m_series_set_first_gate(struct ni_gpct *counter,
 				      unsigned int gate_source)
 {
 	const unsigned selected_gate = CR_CHAN(gate_source);
-	/* bits of selected_gate that may be meaningful to input select register */
+	/* bits of selected_gate that may be meaningful
+	   to input select register */
 	const unsigned selected_gate_mask = 0x1f;
 	unsigned ni_m_series_gate_select;
 	unsigned i;
@@ -1159,7 +1174,8 @@ static int ni_660x_set_second_gate(struct ni_gpct *counter,
 		break;
 	default:
 		for (i = 0; i <= ni_660x_max_rtsi_channel; ++i) {
-			if (selected_second_gate == NI_GPCT_RTSI_GATE_SELECT(i)) {
+			if (selected_second_gate ==
+			    NI_GPCT_RTSI_GATE_SELECT(i)) {
 				ni_660x_second_gate_select =
 				    selected_second_gate &
 				    selected_second_gate_mask;
@@ -1202,8 +1218,8 @@ static int ni_m_series_set_second_gate(struct ni_gpct *counter,
 	static const unsigned selected_second_gate_mask = 0x1f;
 	unsigned ni_m_series_second_gate_select;
 
-	/* FIXME: We don't know what the m-series second gate codes are, so we'll just pass
-	   the bits through for now. */
+	/* FIXME: We don't know what the m-series second gate codes are,
+	   so we'll just pass the bits through for now. */
 	switch (selected_second_gate) {
 	default:
 		ni_m_series_second_gate_select =
@@ -1320,7 +1336,8 @@ static int ni_tio_set_other_src(struct ni_gpct *counter, unsigned index,
 		counter_dev->regs[abz_reg] &= ~mask;
 		counter_dev->regs[abz_reg] |= (source << shift) & mask;
 		write_register(counter, counter_dev->regs[abz_reg], abz_reg);
-/* printk("%s %x %d %d\n", __func__, counter_dev->regs[abz_reg], index, source); */
+/* printk("%s %x %d %d\n", __func__, counter_dev->regs[abz_reg],
+   index, source); */
 		return 0;
 	}
 	return -EINVAL;
@@ -1349,7 +1366,8 @@ static unsigned ni_660x_first_gate_to_generic_gate_source(unsigned
 		break;
 	default:
 		for (i = 0; i <= ni_660x_max_rtsi_channel; ++i) {
-			if (ni_660x_gate_select == NI_660x_RTSI_Gate_Select(i)) {
+			if (ni_660x_gate_select ==
+			    NI_660x_RTSI_Gate_Select(i)) {
 				return NI_GPCT_RTSI_GATE_SELECT(i);
 				break;
 			}
@@ -1372,7 +1390,7 @@ static unsigned ni_660x_first_gate_to_generic_gate_source(unsigned
 };
 
 static unsigned ni_m_series_first_gate_to_generic_gate_source(unsigned
-							      ni_m_series_gate_select)
+						       ni_m_series_gate_select)
 {
 	unsigned i;
 
@@ -1476,10 +1494,10 @@ static unsigned ni_660x_second_gate_to_generic_gate_source(unsigned
 };
 
 static unsigned ni_m_series_second_gate_to_generic_gate_source(unsigned
-							       ni_m_series_gate_select)
+						       ni_m_series_gate_select)
 {
-	/*FIXME: the second gate sources for the m series are undocumented, so we just return
-	 * the raw bits for now. */
+	/*FIXME: the second gate sources for the m series are undocumented,
+	  so we just return the raw bits for now. */
 	switch (ni_m_series_gate_select) {
 	default:
 		return ni_m_series_gate_select;
@@ -1643,11 +1661,14 @@ int ni_tio_rinsn(struct ni_gpct *counter, struct comedi_insn *insn,
 		ni_tio_set_bits(counter,
 				NITIO_Gi_Command_Reg(counter->counter_index),
 				Gi_Save_Trace_Bit, Gi_Save_Trace_Bit);
-		/* The count doesn't get latched until the next clock edge, so it is possible the count
-		   may change (once) while we are reading.  Since the read of the SW_Save_Reg isn't
-		   atomic (apparently even when it's a 32 bit register according to 660x docs),
-		   we need to read twice and make sure the reading hasn't changed.  If it has,
-		   a third read will be correct since the count value will definitely have latched by then. */
+		/* The count doesn't get latched until the next clock edge,
+		   so it is possible the count may change (once)
+		   while we are reading.  Since the read of the SW_Save_Reg
+		   isn't atomic (apparently even when it's a 32 bit register
+		   according to 660x docs), we need to read twice and make sure
+		   the reading hasn't changed.  If it has, a third read will be
+		   correct since the count value will definitely
+		   have latched by then. */
 		first_read =
 		    read_register(counter,
 				  NITIO_Gi_SW_Save_Reg(counter->counter_index));
@@ -1683,7 +1704,7 @@ static unsigned ni_tio_next_load_register(struct ni_gpct *counter)
 {
 	const unsigned bits = read_register(counter,
 					    NITIO_Gxx_Status_Reg(counter->
-								 counter_index));
+							       counter_index));
 
 	if (bits & Gi_Next_Load_Source_Bit(counter->counter_index))
 		return NITIO_Gi_LoadB_Reg(counter->counter_index);
@@ -1702,15 +1723,18 @@ int ni_tio_winsn(struct ni_gpct *counter, struct comedi_insn *insn,
 		return 0;
 	switch (channel) {
 	case 0:
-		/* Unsafe if counter is armed.  Should probably check status and return -EBUSY if armed. */
-		/* Don't disturb load source select, just use whichever load register is already selected. */
+		/* Unsafe if counter is armed.  Should probably check status
+		   and return -EBUSY if armed. */
+		/* Don't disturb load source select, just use whichever
+		   load register is already selected. */
 		load_reg = ni_tio_next_load_register(counter);
 		write_register(counter, data[0], load_reg);
 		ni_tio_set_bits_transient(counter,
 					  NITIO_Gi_Command_Reg(counter->
 							       counter_index),
 					  0, 0, Gi_Load_Bit);
-		/* restore state of load reg to whatever the user set last set it to */
+		/* restore state of load reg to whatever the user
+		set last set it to */
 		write_register(counter, counter_dev->regs[load_reg], load_reg);
 		break;
 	case 1:
-- 
1.7.0.4

