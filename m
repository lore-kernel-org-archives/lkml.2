Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758349Ab0JFBBb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 21:01:31 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:65271 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758305Ab0JFBB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 21:01:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=DinFIuwiPUjZXhQJgXPVqDGNRl13DbkcLOlZitEPEDybn6MuvsZWEAgZQKrwZR7LyJ
         /A/OorzntE5ZtH8wKPA2Q/PnwXii4YBfqh7taH/oLx06RJ4GqSQbcvHPfEMtMVw1ZXCn
         1coLL8ZDF6AmkyTWOzzxQzkHQLIy11+ROHX/0=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com, abbotti@mev.co.uk, fmhess@users.sourceforge.net
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 19/28] Staging: comedi: drivers: adl_pci9111.c: Edit file so that checkpatch.pl has 30 warnings and 3 errors
Date: Tue,  5 Oct 2010 21:00:34 -0400
Message-Id: <1286326843-6170-19-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286326843-6170-1-git-send-email-tdent48227@gmail.com>
References: <1286326843-6170-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed a few lines that made checkpatch.pl complain. Could not get ever error but
I got the warnings down to 65 less than the orignal file, The warnings and errors that are left are
 WARNING: line over 80 characters, ERROR: Macros with multiple statements should be enclosed in a do - while loop,
 WARNING: printk() should include KERN_ facility level.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/comedi/drivers/adl_pci9111.c |  170 +++++++++++++-------------
 1 files changed, 85 insertions(+), 85 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci9111.c b/drivers/staging/comedi/drivers/adl_pci9111.c
index b2a02b0..7fb6509 100644
--- a/drivers/staging/comedi/drivers/adl_pci9111.c
+++ b/drivers/staging/comedi/drivers/adl_pci9111.c
@@ -1,26 +1,26 @@
 /*
 
-   comedi/drivers/adl_pci9111.c
+	comedi/drivers/adl_pci9111.c
 
-   Hardware driver for PCI9111 ADLink cards:
+	Hardware driver for PCI9111 ADLink cards:
 
-     PCI-9111HR
+		PCI-9111HR
 
-   Copyright (C) 2002-2005 Emmanuel Pacaud <emmanuel.pacaud@univ-poitiers.fr>
+	Copyright (C) 2002-2005 Emmanuel Pacaud <emmanuel.pacaud@univ-poitiers.fr>
 
-    This program is free software; you can redistribute it and/or modify
-    it under the terms of the GNU General Public License as published by
-    the Free Software Foundation; either version 2 of the License, or
-    (at your option) any later version.
+	This program is free software; you can redistribute it and/or modify
+	it under the terms of the GNU General Public License as published by
+	the Free Software Foundation; either version 2 of the License, or
+	(at your option) any later version.
 
-    This program is distributed in the hope that it will be useful,
-    but WITHOUT ANY WARRANTY; without even the implied warranty of
-    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-    GNU General Public License for more details.
+	This program is distributed in the hope that it will be useful,
+	but WITHOUT ANY WARRANTY; without even the implied warranty of
+	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+	GNU General Public License for more details.
 
-    You should have received a copy of the GNU General Public License
-    along with this program; if not, write to the Free Software
-    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+	You should have received a copy of the GNU General Public License
+	along with this program; if not, write to the Free Software
+	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
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
+	- start_src			TRIG_NOW
+	- scan_begin_src		TRIG_FOLLOW	TRIG_TIMER	TRIG_EXT
+	- convert_src				TRIG_TIMER	TRIG_EXT
+	- scan_end_src		TRIG_COUNT
+	- stop_src			TRIG_COUNT	TRIG_NONE
 
-    The scanned channels must be consecutive and start from 0. They must
-    all have the same range and aref.
+	The scanned channels must be consecutive and start from 0. They must
+	all have the same range and aref.
 
 Configuration options:
 
-    [0] - PCI bus number (optional)
-    [1] - PCI slot number (optional)
+	[0] - PCI bus number (optional)
+	[1] - PCI slot number (optional)
 
-    If bus/slot is not specified, the first available PCI
-    device will be used.
+	If bus/slot is not specified, the first available PCI
+	device will be used.
 
 */
 
 /*
 CHANGELOG:
 
-  2005/02/17 Extend AI streaming capabilities. Now, scan_begin_arg can be
-  a multiple of chanlist_len*convert_arg.
-  2002/02/19 Fixed the two's complement conversion in pci9111_(hr_)ai_get_data.
-  2002/02/18 Added external trigger support for analog input.
+	2005/02/17 Extend AI streaming capabilities. Now, scan_begin_arg can be
+	a multiple of chanlist_len*convert_arg.
+	2002/02/19 Fixed the two's complement conversion in pci9111_(hr_)ai_get_data.
+	2002/02/18 Added external trigger support for analog input.
 
 TODO:
 
-  - Really test implemented functionality.
-  - Add support for the PCI-9111DG with a probe routine to identify the card
-    type (perhaps with the help of the channel number readback of the A/D Data
-    register).
-  - Add external multiplexer support.
+	- Really test implemented functionality.
+	- Add support for the PCI-9111DG with a probe routine to identify the
+	  card type (perhaps with the help of the channel number readback of
+	  the A/D Data register).
+	- Add external multiplexer support.
 
 */
 
@@ -187,95 +187,95 @@ TODO:
  */
 
 #define pci9111_trigger_and_autoscan_get() \
-  (inb(PCI9111_IO_BASE+PCI9111_REGISTER_AD_MODE_INTERRUPT_READBACK)&0x0F)
+	(inb(PCI9111_IO_BASE+PCI9111_REGISTER_AD_MODE_INTERRUPT_READBACK)&0x0F)
 
 #define pci9111_trigger_and_autoscan_set(flags) \
-  outb(flags, PCI9111_IO_BASE+PCI9111_REGISTER_TRIGGER_MODE_CONTROL)
+	outb(flags, PCI9111_IO_BASE+PCI9111_REGISTER_TRIGGER_MODE_CONTROL)
 
 #define pci9111_interrupt_and_fifo_get()				   \
-  ((inb(PCI9111_IO_BASE+PCI9111_REGISTER_AD_MODE_INTERRUPT_READBACK) >> 4) \
-   &0x03)
+	((inb(PCI9111_IO_BASE+PCI9111_REGISTER_AD_MODE_INTERRUPT_READBACK) >> 4) \
+	&0x03)
 
 #define pci9111_interrupt_and_fifo_set(flags) \
-  outb(flags, PCI9111_IO_BASE+PCI9111_REGISTER_INTERRUPT_CONTROL)
+	outb(flags, PCI9111_IO_BASE+PCI9111_REGISTER_INTERRUPT_CONTROL)
 
 #define pci9111_interrupt_clear() \
-  outb(0, PCI9111_IO_BASE+PCI9111_REGISTER_INTERRUPT_CLEAR)
+	outb(0, PCI9111_IO_BASE+PCI9111_REGISTER_INTERRUPT_CLEAR)
 
 #define pci9111_software_trigger() \
-  outb(0, PCI9111_IO_BASE+PCI9111_REGISTER_SOFTWARE_TRIGGER)
+	outb(0, PCI9111_IO_BASE+PCI9111_REGISTER_SOFTWARE_TRIGGER)
 
 #define pci9111_fifo_reset() do {					\
-  outb(PCI9111_FFEN_SET_FIFO_ENABLE,					\
-       PCI9111_IO_BASE+PCI9111_REGISTER_INTERRUPT_CONTROL);		\
-  outb(PCI9111_FFEN_SET_FIFO_DISABLE,					\
-       PCI9111_IO_BASE+PCI9111_REGISTER_INTERRUPT_CONTROL);		\
-  outb(PCI9111_FFEN_SET_FIFO_ENABLE,					\
-       PCI9111_IO_BASE+PCI9111_REGISTER_INTERRUPT_CONTROL);		\
+	outb(PCI9111_FFEN_SET_FIFO_ENABLE,					\
+		PCI9111_IO_BASE+PCI9111_REGISTER_INTERRUPT_CONTROL);		\
+	outb(PCI9111_FFEN_SET_FIFO_DISABLE,					\
+		PCI9111_IO_BASE+PCI9111_REGISTER_INTERRUPT_CONTROL);		\
+	outb(PCI9111_FFEN_SET_FIFO_ENABLE,					\
+		PCI9111_IO_BASE+PCI9111_REGISTER_INTERRUPT_CONTROL);		\
   } while (0)
 
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
 
 #define pci9111_ai_channel_set(channel)					\
-  outb((channel)&PCI9111_CHANNEL_MASK,					\
-       PCI9111_IO_BASE+PCI9111_REGISTER_AD_CHANNEL_CONTROL)
+	outb((channel)&PCI9111_CHANNEL_MASK,					\
+		PCI9111_IO_BASE+PCI9111_REGISTER_AD_CHANNEL_CONTROL)
 
 #define pci9111_ai_channel_get()					\
-  (inb(PCI9111_IO_BASE+PCI9111_REGISTER_AD_CHANNEL_READBACK)		\
-   &PCI9111_CHANNEL_MASK)
+	(inb(PCI9111_IO_BASE+PCI9111_REGISTER_AD_CHANNEL_READBACK)		\
+		&PCI9111_CHANNEL_MASK)
 
 #define pci9111_ai_range_set(range)					\
-  outb((range)&PCI9111_RANGE_MASK,					\
-       PCI9111_IO_BASE+PCI9111_REGISTER_INPUT_SIGNAL_RANGE)
+	outb((range)&PCI9111_RANGE_MASK,					\
+		PCI9111_IO_BASE+PCI9111_REGISTER_INPUT_SIGNAL_RANGE)
 
 #define pci9111_ai_range_get()						\
-  (inb(PCI9111_IO_BASE+PCI9111_REGISTER_RANGE_STATUS_READBACK)		\
-   &PCI9111_RANGE_MASK)
+	(inb(PCI9111_IO_BASE+PCI9111_REGISTER_RANGE_STATUS_READBACK)		\
+	&PCI9111_RANGE_MASK)
 
 #define pci9111_ai_get_data()						\
-  (((inw(PCI9111_IO_BASE+PCI9111_REGISTER_AD_FIFO_VALUE)>>4)		\
-    &PCI9111_AI_RESOLUTION_MASK)					\
-   ^ PCI9111_AI_RESOLUTION_2_CMP_BIT)
+	(((inw(PCI9111_IO_BASE+PCI9111_REGISTER_AD_FIFO_VALUE)>>4)		\
+	&PCI9111_AI_RESOLUTION_MASK)					\
+		^ PCI9111_AI_RESOLUTION_2_CMP_BIT)
 
 #define pci9111_hr_ai_get_data()					\
-  ((inw(PCI9111_IO_BASE+PCI9111_REGISTER_AD_FIFO_VALUE)			\
-    & PCI9111_HR_AI_RESOLUTION_MASK)					\
-   ^ PCI9111_HR_AI_RESOLUTION_2_CMP_BIT)
+	((inw(PCI9111_IO_BASE+PCI9111_REGISTER_AD_FIFO_VALUE)			\
+	& PCI9111_HR_AI_RESOLUTION_MASK)					\
+	^ PCI9111_HR_AI_RESOLUTION_2_CMP_BIT)
 
 #define pci9111_ao_set_data(data)					\
-  outw(data&PCI9111_AO_RESOLUTION_MASK,					\
-       PCI9111_IO_BASE+PCI9111_REGISTER_DA_OUTPUT)
+	outw(data&PCI9111_AO_RESOLUTION_MASK,					\
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
+	outb((data >> 8) & 0xFF, PCI9111_IO_BASE+PCI9111_REGISTER_8254_COUNTER_0)
 
 #define pci9111_8254_counter_1_set(data) \
-  outb(data & 0xFF, PCI9111_IO_BASE+PCI9111_REGISTER_8254_COUNTER_1); \
-  outb((data >> 8) & 0xFF, PCI9111_IO_BASE+PCI9111_REGISTER_8254_COUNTER_1)
+	outb(data & 0xFF, PCI9111_IO_BASE+PCI9111_REGISTER_8254_COUNTER_1); \
+	outb((data >> 8) & 0xFF, PCI9111_IO_BASE+PCI9111_REGISTER_8254_COUNTER_1)
 
 #define pci9111_8254_counter_2_set(data) \
-  outb(data & 0xFF, PCI9111_IO_BASE+PCI9111_REGISTER_8254_COUNTER_2); \
-  outb((data >> 8) & 0xFF, PCI9111_IO_BASE+PCI9111_REGISTER_8254_COUNTER_2)
+	outb(data & 0xFF, PCI9111_IO_BASE+PCI9111_REGISTER_8254_COUNTER_2); \
+	outb((data >> 8) & 0xFF, PCI9111_IO_BASE+PCI9111_REGISTER_8254_COUNTER_2)
 
 /*  Function prototypes */
 
@@ -342,7 +342,7 @@ static const struct pci9111_board pci9111_boards[] = {
 };
 
 #define pci9111_board_nbr \
-  (sizeof(pci9111_boards)/sizeof(struct pci9111_board))
+	(sizeof(pci9111_boards)/sizeof(struct pci9111_board))
 
 static struct comedi_driver pci9111_driver = {
 	.driver_name = PCI9111_DRIVER_NAME,
-- 
1.7.3.1.50.g1e633

