Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab0IHSQG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 14:16:06 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:32815 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab0IHSQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 14:16:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=uDMOW1GQDet+LPGbWlG7Z+Gk7xnUahY2c5NLGkZnzSZ2/2swkyoM0DqbDYKH8NfCgY
         VssHDJx6gNpolVMkvTeajJfrheqtQHtADFJDCzLwEV5gMBaE1nsZE3Vhy4ZALs7OKpeE
         ctwvTxVMrA2KtIuqeP346QsiwB3HMiTwwdQqg=
From: Maurice Dawson <mauricedawson2699@gmail.com>
To: gregkh@suse.de, arun.thomas@gmail.com, reodge@gmail.com,
        mithlesh@linsyssoft.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: comedi: fix space coding style issue in adl_pci9111.c
Date: Wed,  8 Sep 2010 19:15:46 +0100
Message-Id: <1283969746-4183-1-git-send-email-mauricedawson2699@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the adl_pci9111.c file that fixes up multiple please, no space for starting a line warnings, found by the checkpatch.pl tool

Signed-off-by: Maurice Dawson <mauricedawson2699@gmail.com>
---
 drivers/staging/comedi/drivers/adl_pci9111.c |  193 +++++++++++++-------------
 1 files changed, 98 insertions(+), 95 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci9111.c b/drivers/staging/comedi/drivers/adl_pci9111.c
index b2a02b0..96c4f30 100644
--- a/drivers/staging/comedi/drivers/adl_pci9111.c
+++ b/drivers/staging/comedi/drivers/adl_pci9111.c
@@ -1,26 +1,26 @@
 /*
 
-   comedi/drivers/adl_pci9111.c
+comedi/drivers/adl_pci9111.c
 
-   Hardware driver for PCI9111 ADLink cards:
+Hardware driver for PCI9111 ADLink cards:
 
-     PCI-9111HR
+PCI-9111HR
 
-   Copyright (C) 2002-2005 Emmanuel Pacaud <emmanuel.pacaud@univ-poitiers.fr>
+Copyright (C) 2002-2005 Emmanuel Pacaud <emmanuel.pacaud@univ-poitiers.fr>
 
-    This program is free software; you can redistribute it and/or modify
-    it under the terms of the GNU General Public License as published by
-    the Free Software Foundation; either version 2 of the License, or
-    (at your option) any later version.
+This program is free software; you can redistribute it and/or modify
+it under the terms of the GNU General Public License as published by
+the Free Software Foundation; either version 2 of the License, or
+(at your option) any later version.
 
-    This program is distributed in the hope that it will be useful,
-    but WITHOUT ANY WARRANTY; without even the implied warranty of
-    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-    GNU General Public License for more details.
+This program is distributed in the hope that it will be useful,
+but WITHOUT ANY WARRANTY; without even the implied warranty of
+MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+GNU General Public License for more details.
 
-    You should have received a copy of the GNU General Public License
-    along with this program; if not, write to the Free Software
-    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+You should have received a copy of the GNU General Public License
+along with this program; if not, write to the Free Software
+Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
 
 /*
@@ -32,46 +32,46 @@ Status: experimental
 
 Supports:
 
-  - ai_insn read
-  - ao_insn read/write
-  - di_insn read
-  - do_insn read/write
-  - ai_do_cmd mode with the following sources:
+	- ai_insn read
+	- ao_insn read/write
+	- di_insn read
+	- do_insn read/write
+	- ai_do_cmd mode with the following sources:
 
-    - start_src			TRIG_NOW
-    - scan_begin_src		TRIG_FOLLOW	TRIG_TIMER	TRIG_EXT
-    - convert_src				TRIG_TIMER	TRIG_EXT
-    - scan_end_src		TRIG_COUNT
-    - stop_src			TRIG_COUNT	TRIG_NONE
+	- start_src		TRIG_NOW
+	- scan_begin_src	TRIG_FOLLOW	TRIG_TIMER	TRIG_EXT
+	- convert_src				TRIG_TIMER	TRIG_EXT
+	- scan_end_src		TRIG_COUNT
+	- stop_src		TRIG_COUNT	TRIG_NONE
 
-    The scanned channels must be consecutive and start from 0. They must
-    all have the same range and aref.
+The scanned channels must be consecutive and start from 0. They must
+all have the same range and aref.
 
 Configuration options:
 
-    [0] - PCI bus number (optional)
-    [1] - PCI slot number (optional)
+	[0] - PCI bus number (optional)
+	[1] - PCI slot number (optional)
 
-    If bus/slot is not specified, the first available PCI
-    device will be used.
+If bus/slot is not specified, the first available PCI
+device will be used.
 
 */
 
 /*
 CHANGELOG:
 
-  2005/02/17 Extend AI streaming capabilities. Now, scan_begin_arg can be
-  a multiple of chanlist_len*convert_arg.
-  2002/02/19 Fixed the two's complement conversion in pci9111_(hr_)ai_get_data.
-  2002/02/18 Added external trigger support for analog input.
+2005/02/17 Extend AI streaming capabilities. Now, scan_begin_arg can be
+a multiple of chanlist_len*convert_arg.
+2002/02/19 Fixed the two's complement conversion in pci9111_(hr_)ai_get_data.
+2002/02/18 Added external trigger support for analog input.
 
 TODO:
 
-  - Really test implemented functionality.
-  - Add support for the PCI-9111DG with a probe routine to identify the card
-    type (perhaps with the help of the channel number readback of the A/D Data
-    register).
-  - Add external multiplexer support.
+	- Really test implemented functionality.
+	- Add support for the PCI-9111DG with a probe routine to identify
+	  the card type (perhaps with the help of the channel number readback
+	  of the A/D Data register).
+	- Add external multiplexer support.
 
 */
 
@@ -187,95 +187,98 @@ TODO:
  */
 
 #define pci9111_trigger_and_autoscan_get() \
-  (inb(PCI9111_IO_BASE+PCI9111_REGISTER_AD_MODE_INTERRUPT_READBACK)&0x0F)
+	(inb(PCI9111_IO_BASE+PCI9111_REGISTER_AD_MODE_INTERRUPT_READBACK)&0x0F)
 
 #define pci9111_trigger_and_autoscan_set(flags) \
-  outb(flags, PCI9111_IO_BASE+PCI9111_REGISTER_TRIGGER_MODE_CONTROL)
+	outb(flags, PCI9111_IO_BASE+PCI9111_REGISTER_TRIGGER_MODE_CONTROL)
 
-#define pci9111_interrupt_and_fifo_get()				   \
-  ((inb(PCI9111_IO_BASE+PCI9111_REGISTER_AD_MODE_INTERRUPT_READBACK) >> 4) \
-   &0x03)
+#define pci9111_interrupt_and_fifo_get() \
+	((inb(PCI9111_IO_BASE+PCI9111_REGISTER_AD_MODE_INTERRUPT_READBACK) \
+		>> 4) & 0x03)
 
 #define pci9111_interrupt_and_fifo_set(flags) \
-  outb(flags, PCI9111_IO_BASE+PCI9111_REGISTER_INTERRUPT_CONTROL)
+	outb(flags, PCI9111_IO_BASE+PCI9111_REGISTER_INTERRUPT_CONTROL)
 
 #define pci9111_interrupt_clear() \
-  outb(0, PCI9111_IO_BASE+PCI9111_REGISTER_INTERRUPT_CLEAR)
+	outb(0, PCI9111_IO_BASE+PCI9111_REGISTER_INTERRUPT_CLEAR)
 
 #define pci9111_software_trigger() \
-  outb(0, PCI9111_IO_BASE+PCI9111_REGISTER_SOFTWARE_TRIGGER)
+	outb(0, PCI9111_IO_BASE+PCI9111_REGISTER_SOFTWARE_TRIGGER)
 
-#define pci9111_fifo_reset() do {					\
-  outb(PCI9111_FFEN_SET_FIFO_ENABLE,					\
-       PCI9111_IO_BASE+PCI9111_REGISTER_INTERRUPT_CONTROL);		\
-  outb(PCI9111_FFEN_SET_FIFO_DISABLE,					\
-       PCI9111_IO_BASE+PCI9111_REGISTER_INTERRUPT_CONTROL);		\
-  outb(PCI9111_FFEN_SET_FIFO_ENABLE,					\
-       PCI9111_IO_BASE+PCI9111_REGISTER_INTERRUPT_CONTROL);		\
-  } while (0)
+#define pci9111_fifo_reset() do { \
+	outb(PCI9111_FFEN_SET_FIFO_ENABLE, \
+		PCI9111_IO_BASE+PCI9111_REGISTER_INTERRUPT_CONTROL); \
+	outb(PCI9111_FFEN_SET_FIFO_DISABLE, \
+		PCI9111_IO_BASE+PCI9111_REGISTER_INTERRUPT_CONTROL); \
+	outb(PCI9111_FFEN_SET_FIFO_ENABLE, \
+		PCI9111_IO_BASE+PCI9111_REGISTER_INTERRUPT_CONTROL); \
+	} while (0)
 
 #define pci9111_is_fifo_full() \
-  ((inb(PCI9111_IO_BASE+PCI9111_REGISTER_RANGE_STATUS_READBACK)& \
-    PCI9111_FIFO_FULL_MASK) == 0)
+	((inb(PCI9111_IO_BASE+PCI9111_REGISTER_RANGE_STATUS_READBACK)& \
+		PCI9111_FIFO_FULL_MASK) == 0)
 
 #define pci9111_is_fifo_half_full() \
-  ((inb(PCI9111_IO_BASE+PCI9111_REGISTER_RANGE_STATUS_READBACK)& \
-    PCI9111_FIFO_HALF_FULL_MASK) == 0)
+	((inb(PCI9111_IO_BASE+PCI9111_REGISTER_RANGE_STATUS_READBACK)& \
+		PCI9111_FIFO_HALF_FULL_MASK) == 0)
 
 #define pci9111_is_fifo_empty() \
-  ((inb(PCI9111_IO_BASE+PCI9111_REGISTER_RANGE_STATUS_READBACK)& \
-    PCI9111_FIFO_EMPTY_MASK) == 0)
+	((inb(PCI9111_IO_BASE+PCI9111_REGISTER_RANGE_STATUS_READBACK)& \
+		PCI9111_FIFO_EMPTY_MASK) == 0)
 
-#define pci9111_ai_channel_set(channel)					\
-  outb((channel)&PCI9111_CHANNEL_MASK,					\
-       PCI9111_IO_BASE+PCI9111_REGISTER_AD_CHANNEL_CONTROL)
+#define pci9111_ai_channel_set(channel) \
+	outb((channel)&PCI9111_CHANNEL_MASK, \
+		PCI9111_IO_BASE+PCI9111_REGISTER_AD_CHANNEL_CONTROL)
 
-#define pci9111_ai_channel_get()					\
-  (inb(PCI9111_IO_BASE+PCI9111_REGISTER_AD_CHANNEL_READBACK)		\
-   &PCI9111_CHANNEL_MASK)
+#define pci9111_ai_channel_get() \
+	(inb(PCI9111_IO_BASE+PCI9111_REGISTER_AD_CHANNEL_READBACK) \
+		&PCI9111_CHANNEL_MASK)
 
-#define pci9111_ai_range_set(range)					\
-  outb((range)&PCI9111_RANGE_MASK,					\
-       PCI9111_IO_BASE+PCI9111_REGISTER_INPUT_SIGNAL_RANGE)
+#define pci9111_ai_range_set(range) \
+	outb((range)&PCI9111_RANGE_MASK, \
+		PCI9111_IO_BASE+PCI9111_REGISTER_INPUT_SIGNAL_RANGE)
 
-#define pci9111_ai_range_get()						\
-  (inb(PCI9111_IO_BASE+PCI9111_REGISTER_RANGE_STATUS_READBACK)		\
-   &PCI9111_RANGE_MASK)
+#define pci9111_ai_range_get() \
+	(inb(PCI9111_IO_BASE+PCI9111_REGISTER_RANGE_STATUS_READBACK) \
+		&PCI9111_RANGE_MASK)
 
-#define pci9111_ai_get_data()						\
-  (((inw(PCI9111_IO_BASE+PCI9111_REGISTER_AD_FIFO_VALUE)>>4)		\
-    &PCI9111_AI_RESOLUTION_MASK)					\
-   ^ PCI9111_AI_RESOLUTION_2_CMP_BIT)
+#define pci9111_ai_get_data() \
+	(((inw(PCI9111_IO_BASE+PCI9111_REGISTER_AD_FIFO_VALUE)>>4) \
+		&PCI9111_AI_RESOLUTION_MASK) \
+			^ PCI9111_AI_RESOLUTION_2_CMP_BIT)
 
-#define pci9111_hr_ai_get_data()					\
-  ((inw(PCI9111_IO_BASE+PCI9111_REGISTER_AD_FIFO_VALUE)			\
-    & PCI9111_HR_AI_RESOLUTION_MASK)					\
-   ^ PCI9111_HR_AI_RESOLUTION_2_CMP_BIT)
+#define pci9111_hr_ai_get_data() \
+	((inw(PCI9111_IO_BASE+PCI9111_REGISTER_AD_FIFO_VALUE) \
+		&PCI9111_HR_AI_RESOLUTION_MASK) \
+			^ PCI9111_HR_AI_RESOLUTION_2_CMP_BIT)
 
-#define pci9111_ao_set_data(data)					\
-  outw(data&PCI9111_AO_RESOLUTION_MASK,					\
-       PCI9111_IO_BASE+PCI9111_REGISTER_DA_OUTPUT)
+#define pci9111_ao_set_data(data) \
+	outw(data&PCI9111_AO_RESOLUTION_MASK, \
+		PCI9111_IO_BASE+PCI9111_REGISTER_DA_OUTPUT)
 
 #define pci9111_di_get_bits() \
-  inw(PCI9111_IO_BASE+PCI9111_REGISTER_DIGITAL_IO)
+	inw(PCI9111_IO_BASE+PCI9111_REGISTER_DIGITAL_IO)
 
 #define pci9111_do_set_bits(bits) \
-  outw(bits, PCI9111_IO_BASE+PCI9111_REGISTER_DIGITAL_IO)
+	outw(bits, PCI9111_IO_BASE+PCI9111_REGISTER_DIGITAL_IO)
 
 #define pci9111_8254_control_set(flags) \
-  outb(flags, PCI9111_IO_BASE+PCI9111_REGISTER_8254_CONTROL)
+	outb(flags, PCI9111_IO_BASE+PCI9111_REGISTER_8254_CONTROL)
 
 #define pci9111_8254_counter_0_set(data) \
-  outb(data & 0xFF, PCI9111_IO_BASE+PCI9111_REGISTER_8254_COUNTER_0); \
-  outb((data >> 8) & 0xFF, PCI9111_IO_BASE+PCI9111_REGISTER_8254_COUNTER_0)
+	outb(data & 0xFF, PCI9111_IO_BASE+PCI9111_REGISTER_8254_COUNTER_0); \
+		outb((data >> 8) & 0xFF, \
+			PCI9111_IO_BASE+PCI9111_REGISTER_8254_COUNTER_0)
 
 #define pci9111_8254_counter_1_set(data) \
-  outb(data & 0xFF, PCI9111_IO_BASE+PCI9111_REGISTER_8254_COUNTER_1); \
-  outb((data >> 8) & 0xFF, PCI9111_IO_BASE+PCI9111_REGISTER_8254_COUNTER_1)
+	outb(data & 0xFF, PCI9111_IO_BASE+PCI9111_REGISTER_8254_COUNTER_1); \
+		outb((data >> 8) & 0xFF, \
+			PCI9111_IO_BASE+PCI9111_REGISTER_8254_COUNTER_1)
 
 #define pci9111_8254_counter_2_set(data) \
-  outb(data & 0xFF, PCI9111_IO_BASE+PCI9111_REGISTER_8254_COUNTER_2); \
-  outb((data >> 8) & 0xFF, PCI9111_IO_BASE+PCI9111_REGISTER_8254_COUNTER_2)
+	outb(data & 0xFF, PCI9111_IO_BASE+PCI9111_REGISTER_8254_COUNTER_2); \
+		outb((data >> 8) & 0xFF, \
+			PCI9111_IO_BASE+PCI9111_REGISTER_8254_COUNTER_2)
 
 /*  Function prototypes */
 
@@ -342,7 +345,7 @@ static const struct pci9111_board pci9111_boards[] = {
 };
 
 #define pci9111_board_nbr \
-  (sizeof(pci9111_boards)/sizeof(struct pci9111_board))
+	(sizeof(pci9111_boards)/sizeof(struct pci9111_board))
 
 static struct comedi_driver pci9111_driver = {
 	.driver_name = PCI9111_DRIVER_NAME,
-- 
1.7.0.4

