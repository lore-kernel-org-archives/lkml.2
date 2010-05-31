Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507Ab0EaJUF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 05:20:05 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:43573 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756184Ab0EaJUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 05:20:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=p3WU68E6JacluVC3kau7PiHgKU1G36EMsvyAnA8yl4B0dIfFzSv4cdAiI+VwXCp9lm
         6YgtpH1qOWGQc+BgWz0DQxqqodkJ9i/6oqZITmaTtwkzQgw2fULJgBT7+GZdic+KjPZu
         LB0dJqHVJh9uwxY0tHQOhR1EWp3Zt8DZJjSIk=
From: Mark <reodge@gmail.com>
To: gregkh@suse.de
Cc: Mark <reodge@gmail.com>, Bill Pemberton <wfp5p@virginia.edu>,
       Rich Folsom <rich.folsom@gmail.com>,
       Mithlesh Thukral <mithlesh@linsyssoft.com>,
       Jiri Slaby <jirislaby@gmail.com>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: comedi: Checkpatch cleanups in adl_pci9111.c
Date: Mon, 31 May 2010 17:19:25 +0800
Message-Id: <1275297567-11584-1-git-send-email-reodge@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleans up some various warnings generated from checkpatch.pl

Signed-off-by: Mark Rankilor <reodge@gmail.com>
---
 drivers/staging/comedi/drivers/adl_pci9111.c |  105 ++++++++++++++-----------
 1 files changed, 59 insertions(+), 46 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci9111.c b/drivers/staging/comedi/drivers/adl_pci9111.c
index 36a254c..595689d 100644
--- a/drivers/staging/comedi/drivers/adl_pci9111.c
+++ b/drivers/staging/comedi/drivers/adl_pci9111.c
@@ -68,8 +68,9 @@ CHANGELOG:
 TODO:
 
   - Really test implemented functionality.
-  - Add support for the PCI-9111DG with a probe routine to identify the card type
-    (perhaps with the help of the channel number readback of the A/D Data register).
+  - Add support for the PCI-9111DG with a probe routine to identify the card
+    type (perhaps with the help of the channel number readback of the A/D Data
+    register).
   - Add external multiplexer support.
 
 */
@@ -83,12 +84,12 @@ TODO:
 #include "comedi_pci.h"
 #include "comedi_fc.h"
 
-#define PCI9111_DRIVER_NAME 	"adl_pci9111"
-#define PCI9111_HR_DEVICE_ID 	0x9111
+#define PCI9111_DRIVER_NAME	"adl_pci9111"
+#define PCI9111_HR_DEVICE_ID	0x9111
 
 /*  TODO: Add other pci9111 board id */
 
-#define PCI9111_IO_RANGE 	0x0100
+#define PCI9111_IO_RANGE	0x0100
 
 #define PCI9111_FIFO_HALF_SIZE	512
 
@@ -134,27 +135,29 @@ TODO:
 
 /* IO address map */
 
-#define PCI9111_REGISTER_AD_FIFO_VALUE 			0x00	/*  AD Data stored in FIFO */
-#define PCI9111_REGISTER_DA_OUTPUT 			0x00
-#define PCI9111_REGISTER_DIGITAL_IO 			0x02
-#define PCI9111_REGISTER_EXTENDED_IO_PORTS 		0x04
-#define PCI9111_REGISTER_AD_CHANNEL_CONTROL 		0x06	/*  Channel selection */
-#define PCI9111_REGISTER_AD_CHANNEL_READBACK 		0x06
-#define PCI9111_REGISTER_INPUT_SIGNAL_RANGE 		0x08
-#define PCI9111_REGISTER_RANGE_STATUS_READBACK 		0x08
-#define PCI9111_REGISTER_TRIGGER_MODE_CONTROL 		0x0A
-#define PCI9111_REGISTER_AD_MODE_INTERRUPT_READBACK 	0x0A
-#define PCI9111_REGISTER_SOFTWARE_TRIGGER 		0x0E
-#define PCI9111_REGISTER_INTERRUPT_CONTROL 		0x0C
+#define PCI9111_REGISTER_AD_FIFO_VALUE			0x00 /* AD Data stored
+								in FIFO */
+#define PCI9111_REGISTER_DA_OUTPUT			0x00
+#define PCI9111_REGISTER_DIGITAL_IO			0x02
+#define PCI9111_REGISTER_EXTENDED_IO_PORTS		0x04
+#define PCI9111_REGISTER_AD_CHANNEL_CONTROL		0x06 /* Channel
+								selection */
+#define PCI9111_REGISTER_AD_CHANNEL_READBACK		0x06
+#define PCI9111_REGISTER_INPUT_SIGNAL_RANGE		0x08
+#define PCI9111_REGISTER_RANGE_STATUS_READBACK		0x08
+#define PCI9111_REGISTER_TRIGGER_MODE_CONTROL		0x0A
+#define PCI9111_REGISTER_AD_MODE_INTERRUPT_READBACK	0x0A
+#define PCI9111_REGISTER_SOFTWARE_TRIGGER		0x0E
+#define PCI9111_REGISTER_INTERRUPT_CONTROL		0x0C
 #define PCI9111_REGISTER_8254_COUNTER_0			0x40
 #define PCI9111_REGISTER_8254_COUNTER_1			0x42
-#define PCI9111_REGISTER_8254_COUNTER_2 		0X44
+#define PCI9111_REGISTER_8254_COUNTER_2			0X44
 #define PCI9111_REGISTER_8254_CONTROL			0x46
-#define PCI9111_REGISTER_INTERRUPT_CLEAR 		0x48
+#define PCI9111_REGISTER_INTERRUPT_CLEAR		0x48
 
-#define PCI9111_TRIGGER_MASK 				0x0F
-#define PCI9111_PTRG_OFF 				(0 << 3)
-#define PCI9111_PTRG_ON 				(1 << 3)
+#define PCI9111_TRIGGER_MASK				0x0F
+#define PCI9111_PTRG_OFF				(0 << 3)
+#define PCI9111_PTRG_ON					(1 << 3)
 #define PCI9111_EITS_EXTERNAL				(1 << 2)
 #define PCI9111_EITS_INTERNAL				(0 << 2)
 #define PCI9111_TPST_SOFTWARE_TRIGGER			(0 << 1)
@@ -164,9 +167,9 @@ TODO:
 
 #define PCI9111_ISC0_SET_IRQ_ON_ENDING_OF_AD_CONVERSION (0 << 0)
 #define PCI9111_ISC0_SET_IRQ_ON_FIFO_HALF_FULL		(1 << 0)
-#define PCI9111_ISC1_SET_IRQ_ON_TIMER_TICK  		(0 << 1)
-#define PCI9111_ISC1_SET_IRQ_ON_EXT_TRG 		(1 << 1)
-#define PCI9111_FFEN_SET_FIFO_ENABLE 			(0 << 2)
+#define PCI9111_ISC1_SET_IRQ_ON_TIMER_TICK		(0 << 1)
+#define PCI9111_ISC1_SET_IRQ_ON_EXT_TRG			(1 << 1)
+#define PCI9111_FFEN_SET_FIFO_ENABLE			(0 << 2)
 #define PCI9111_FFEN_SET_FIFO_DISABLE			(1 << 2)
 
 #define PCI9111_CHANNEL_MASK				0x0F
@@ -177,7 +180,7 @@ TODO:
 #define PCI9111_FIFO_FULL_MASK				0x40
 #define PCI9111_AD_BUSY_MASK				0x80
 
-#define PCI9111_IO_BASE dev->iobase
+#define PCI9111_IO_BASE (dev->iobase)
 
 /*
  * Define inlined function
@@ -189,8 +192,9 @@ TODO:
 #define pci9111_trigger_and_autoscan_set(flags) \
   outb(flags, PCI9111_IO_BASE+PCI9111_REGISTER_TRIGGER_MODE_CONTROL)
 
-#define pci9111_interrupt_and_fifo_get() \
-  ((inb(PCI9111_IO_BASE+PCI9111_REGISTER_AD_MODE_INTERRUPT_READBACK) >> 4) &0x03)
+#define pci9111_interrupt_and_fifo_get()				   \
+  ((inb(PCI9111_IO_BASE+PCI9111_REGISTER_AD_MODE_INTERRUPT_READBACK) >> 4) \
+   &0x03)
 
 #define pci9111_interrupt_and_fifo_set(flags) \
   outb(flags, PCI9111_IO_BASE+PCI9111_REGISTER_INTERRUPT_CONTROL)
@@ -201,38 +205,47 @@ TODO:
 #define pci9111_software_trigger() \
   outb(0, PCI9111_IO_BASE+PCI9111_REGISTER_SOFTWARE_TRIGGER)
 
-#define pci9111_fifo_reset() \
-  outb(PCI9111_FFEN_SET_FIFO_ENABLE, PCI9111_IO_BASE+PCI9111_REGISTER_INTERRUPT_CONTROL); \
-  outb(PCI9111_FFEN_SET_FIFO_DISABLE, PCI9111_IO_BASE+PCI9111_REGISTER_INTERRUPT_CONTROL); \
-  outb(PCI9111_FFEN_SET_FIFO_ENABLE, PCI9111_IO_BASE+PCI9111_REGISTER_INTERRUPT_CONTROL)
+#define pci9111_fifo_reset() do {					\
+  outb(PCI9111_FFEN_SET_FIFO_ENABLE,					\
+       PCI9111_IO_BASE+PCI9111_REGISTER_INTERRUPT_CONTROL);		\
+  outb(PCI9111_FFEN_SET_FIFO_DISABLE,					\
+       PCI9111_IO_BASE+PCI9111_REGISTER_INTERRUPT_CONTROL);		\
+  outb(PCI9111_FFEN_SET_FIFO_ENABLE,					\
+       PCI9111_IO_BASE+PCI9111_REGISTER_INTERRUPT_CONTROL);		\
+  } while (0)
 
 #define pci9111_is_fifo_full() \
   ((inb(PCI9111_IO_BASE+PCI9111_REGISTER_RANGE_STATUS_READBACK)& \
-    PCI9111_FIFO_FULL_MASK)==0)
+    PCI9111_FIFO_FULL_MASK) == 0)
 
 #define pci9111_is_fifo_half_full() \
   ((inb(PCI9111_IO_BASE+PCI9111_REGISTER_RANGE_STATUS_READBACK)& \
-    PCI9111_FIFO_HALF_FULL_MASK)==0)
+    PCI9111_FIFO_HALF_FULL_MASK) == 0)
 
 #define pci9111_is_fifo_empty() \
   ((inb(PCI9111_IO_BASE+PCI9111_REGISTER_RANGE_STATUS_READBACK)& \
-    PCI9111_FIFO_EMPTY_MASK)==0)
+    PCI9111_FIFO_EMPTY_MASK) == 0)
 
-#define pci9111_ai_channel_set(channel) \
-  outb((channel)&PCI9111_CHANNEL_MASK, PCI9111_IO_BASE+PCI9111_REGISTER_AD_CHANNEL_CONTROL)
+#define pci9111_ai_channel_set(channel)					\
+  outb((channel)&PCI9111_CHANNEL_MASK,					\
+       PCI9111_IO_BASE+PCI9111_REGISTER_AD_CHANNEL_CONTROL)
 
-#define pci9111_ai_channel_get() \
-  inb(PCI9111_IO_BASE+PCI9111_REGISTER_AD_CHANNEL_READBACK)&PCI9111_CHANNEL_MASK
+#define pci9111_ai_channel_get()					\
+  (inb(PCI9111_IO_BASE+PCI9111_REGISTER_AD_CHANNEL_READBACK)		\
+   &PCI9111_CHANNEL_MASK)
 
-#define pci9111_ai_range_set(range) \
-  outb((range)&PCI9111_RANGE_MASK, PCI9111_IO_BASE+PCI9111_REGISTER_INPUT_SIGNAL_RANGE)
+#define pci9111_ai_range_set(range)					\
+  outb((range)&PCI9111_RANGE_MASK,					\
+       PCI9111_IO_BASE+PCI9111_REGISTER_INPUT_SIGNAL_RANGE)
 
-#define pci9111_ai_range_get() \
-  inb(PCI9111_IO_BASE+PCI9111_REGISTER_RANGE_STATUS_READBACK)&PCI9111_RANGE_MASK
+#define pci9111_ai_range_get()						\
+  (inb(PCI9111_IO_BASE+PCI9111_REGISTER_RANGE_STATUS_READBACK)		\
+   &PCI9111_RANGE_MASK)
 
-#define pci9111_ai_get_data() \
-  ((inw(PCI9111_IO_BASE+PCI9111_REGISTER_AD_FIFO_VALUE)>>4)&PCI9111_AI_RESOLUTION_MASK) \
-  ^ PCI9111_AI_RESOLUTION_2_CMP_BIT
+#define pci9111_ai_get_data()						\
+  (((inw(PCI9111_IO_BASE+PCI9111_REGISTER_AD_FIFO_VALUE)>>4)		\
+    &PCI9111_AI_RESOLUTION_MASK)					\
+   ^ PCI9111_AI_RESOLUTION_2_CMP_BIT)
 
 #define pci9111_hr_ai_get_data() \
   (inw(PCI9111_IO_BASE+PCI9111_REGISTER_AD_FIFO_VALUE) & PCI9111_HR_AI_RESOLUTION_MASK) \
-- 
1.7.1

