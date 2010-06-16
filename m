Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759394Ab0FPSab (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 14:30:31 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46623 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759383Ab0FPSa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 14:30:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=QU5B02H4aDWNiyVYDQhHeGjBDLnt3MdsZod/6YtC3tP9lIAaG0LR/MiPycmnsragte
         YehpSOOPG7Bkj+S1TWB9AFlvF+NWkwXRMqJRhEsIoUB+HUHqA7xMdW2/6Q4yGZXQtRo9
         0yDcfgSy+tFCN9+l35gLdNxeDbxXd/DbYw5+g=
From: John Sheehan <john.d.sheehan@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu, rich.folsom@gmail.com,
       mithlesh@linsyssoft.com, jirislaby@gmail.com, john.d.sheehan@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Staging: comedi: fix style errors in adl_pci9111.c
Date: Wed, 16 Jun 2010 19:30:09 +0100
Message-Id: <1276713009-8499-1-git-send-email-john.d.sheehan@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Sheehan <john.d.sheehan@gmail.com>

a patch for adl_pci9111.c, to fix the following
errors reported by the checkpatch.pl tool,

-Macros with complex values should be enclosed in parenthesis
-need consistent spacing around '&' (ctx:WxV)
-spaces required around that '==' (ctx:VxV)
-Macros with complex values should be enclosed in parenthesis
-trailing statements should be on next line

Signed-off-by: John Sheehan <john.d.sheehan@gmail.com>
---
 drivers/staging/comedi/drivers/adl_pci9111.c |   25 +++++++++++++------------
 1 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci9111.c b/drivers/staging/comedi/drivers/adl_pci9111.c
index 36a254c..b9501ce 100644
--- a/drivers/staging/comedi/drivers/adl_pci9111.c
+++ b/drivers/staging/comedi/drivers/adl_pci9111.c
@@ -177,7 +177,7 @@ TODO:
 #define PCI9111_FIFO_FULL_MASK				0x40
 #define PCI9111_AD_BUSY_MASK				0x80
 
-#define PCI9111_IO_BASE dev->iobase
+#define PCI9111_IO_BASE (dev->iobase)
 
 /*
  * Define inlined function
@@ -190,7 +190,7 @@ TODO:
   outb(flags, PCI9111_IO_BASE+PCI9111_REGISTER_TRIGGER_MODE_CONTROL)
 
 #define pci9111_interrupt_and_fifo_get() \
-  ((inb(PCI9111_IO_BASE+PCI9111_REGISTER_AD_MODE_INTERRUPT_READBACK) >> 4) &0x03)
+  ((inb(PCI9111_IO_BASE+PCI9111_REGISTER_AD_MODE_INTERRUPT_READBACK) >> 4)&0x03)
 
 #define pci9111_interrupt_and_fifo_set(flags) \
   outb(flags, PCI9111_IO_BASE+PCI9111_REGISTER_INTERRUPT_CONTROL)
@@ -208,35 +208,35 @@ TODO:
 
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
 
 #define pci9111_ai_channel_set(channel) \
   outb((channel)&PCI9111_CHANNEL_MASK, PCI9111_IO_BASE+PCI9111_REGISTER_AD_CHANNEL_CONTROL)
 
 #define pci9111_ai_channel_get() \
-  inb(PCI9111_IO_BASE+PCI9111_REGISTER_AD_CHANNEL_READBACK)&PCI9111_CHANNEL_MASK
+  (inb(PCI9111_IO_BASE+PCI9111_REGISTER_AD_CHANNEL_READBACK)&(PCI9111_CHANNEL_MASK))
 
 #define pci9111_ai_range_set(range) \
   outb((range)&PCI9111_RANGE_MASK, PCI9111_IO_BASE+PCI9111_REGISTER_INPUT_SIGNAL_RANGE)
 
 #define pci9111_ai_range_get() \
-  inb(PCI9111_IO_BASE+PCI9111_REGISTER_RANGE_STATUS_READBACK)&PCI9111_RANGE_MASK
+  (inb(PCI9111_IO_BASE+PCI9111_REGISTER_RANGE_STATUS_READBACK)&(PCI9111_RANGE_MASK))
 
 #define pci9111_ai_get_data() \
-  ((inw(PCI9111_IO_BASE+PCI9111_REGISTER_AD_FIFO_VALUE)>>4)&PCI9111_AI_RESOLUTION_MASK) \
-  ^ PCI9111_AI_RESOLUTION_2_CMP_BIT
+  (((inw(PCI9111_IO_BASE+PCI9111_REGISTER_AD_FIFO_VALUE)>>4)&PCI9111_AI_RESOLUTION_MASK) \
+  ^ (PCI9111_AI_RESOLUTION_2_CMP_BIT))
 
 #define pci9111_hr_ai_get_data() \
-  (inw(PCI9111_IO_BASE+PCI9111_REGISTER_AD_FIFO_VALUE) & PCI9111_HR_AI_RESOLUTION_MASK) \
-  ^ PCI9111_HR_AI_RESOLUTION_2_CMP_BIT
+  ((inw(PCI9111_IO_BASE+PCI9111_REGISTER_AD_FIFO_VALUE) & PCI9111_HR_AI_RESOLUTION_MASK) \
+  ^ (PCI9111_HR_AI_RESOLUTION_2_CMP_BIT))
 
 #define pci9111_ao_set_data(data) \
   outw(data&PCI9111_AO_RESOLUTION_MASK, PCI9111_IO_BASE+PCI9111_REGISTER_DA_OUTPUT)
@@ -551,7 +551,8 @@ static int pci9111_ai_cancel(struct comedi_device *dev,
 #define pci9111_check_trigger_src(src, flags) \
   tmp = src; \
   src &= flags; \
-  if (!src || tmp != src) error++
+  if (!src || tmp != src) \
+	error++
 
 static int
 pci9111_ai_do_cmd_test(struct comedi_device *dev,
-- 
1.7.0.4

