Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab0ISSys (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 14:54:48 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49062 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643Ab0ISSyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 14:54:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=wDkz9ZBO9vIRCwMA2ZfkXvAOa2yNLF7PLZjd8hDJmu36kUl1poJ+/L4OZPfnGziGnc
         WVpPig9mfquXikgkYTGP6B53gEarn7bClpUzlOVgQSr0AolkynVaouBCxNXPLQ59cT4Y
         qKlggDVxEfJy5aEx9pxiByGFDRNviZJPJ4gwY=
From: Maurice Dawson <mauricedawson2699@gmail.com>
To: gregkh@suse.de, arun.thomas@gmail.com, stewart_r@aliencamel.com,
        u.kleine-koenig@pengutronix.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] Staging: comedi: fix EXPORT SYMBOL coding style issue in ni_labpc.c
Date: Sun, 19 Sep 2010 19:54:30 +0100
Message-Id: <1284922470-2624-1-git-send-email-mauricedawson2699@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the ni_labpc.c file that fixes up, EXPORT SYMBOL(foo) should immediately follow its function/variable
warnings, found by the checkpatch.pl tool

Signed-off-by: Maurice Dawson <mauricedawson2699@gmail.com>
---
 drivers/staging/comedi/drivers/ni_labpc.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_labpc.c b/drivers/staging/comedi/drivers/ni_labpc.c
index 8d120cd..f18a8a7 100644
--- a/drivers/staging/comedi/drivers/ni_labpc.c
+++ b/drivers/staging/comedi/drivers/ni_labpc.c
@@ -24,7 +24,7 @@ Driver: ni_labpc
 Description: National Instruments Lab-PC (& compatibles)
 Author: Frank Mori Hess <fmhess@users.sourceforge.net>
 Devices: [National Instruments] Lab-PC-1200 (labpc-1200),
-	Lab-PC-1200AI (labpc-1200ai), Lab-PC+ (lab-pc+), PCI-1200 (ni_labpc)
+	Lab-PC-1200AI(labpc-1200ai), Lab-PC + (lab-pc+), PCI-1200 (ni_labpc)
 Status: works
 
 Tested with lab-pc-1200.  For the older Lab-PC+, not all input ranges
@@ -48,12 +48,12 @@ comedilib, use the comedi_calibrate program.
 
 Configuration options - ISA boards:
 [0] - I/O port base address
-[1] - IRQ (optional, required for timed or externally triggered conversions)
-[2] - DMA channel (optional)
+[1] - IRQ(optional, required for timed or externally triggered conversions)
+[2] - DMA channel(optional)
 
 Configuration options - PCI boards:
-[0] - bus (optional)
-[1] - slot (optional)
+[0] - bus(optional)
+[1] - slot(optional)
 
 The Lab-pc+ has quirky chanlist requirements
 when scanning multiple channels.  Multiple channel scan
@@ -345,6 +345,7 @@ const int labpc_1200_is_unipolar[NUM_LABPC_1200_AI_RANGES] = {
 	1,
 	1,
 };
+EXPORT_SYMBOL_GPL(labpc_1200_is_unipolar);
 
 /* map range index to gain bits */
 const int labpc_1200_ai_gain_bits[NUM_LABPC_1200_AI_RANGES] = {
@@ -363,6 +364,7 @@ const int labpc_1200_ai_gain_bits[NUM_LABPC_1200_AI_RANGES] = {
 	0x60,
 	0x70,
 };
+EXPORT_SYMBOL_GPL(labpc_1200_ai_gain_bits);
 
 const struct comedi_lrange range_labpc_1200_ai = {
 	NUM_LABPC_1200_AI_RANGES,
@@ -383,6 +385,7 @@ const struct comedi_lrange range_labpc_1200_ai = {
 	 UNI_RANGE(0.1),
 	 }
 };
+EXPORT_SYMBOL_GPL(range_labpc_1200_ai);
 
 /* analog output ranges */
 #define AO_RANGE_IS_UNIPOLAR 0x1
@@ -701,6 +704,7 @@ int labpc_common_attach(struct comedi_device *dev, unsigned long iobase,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(labpc_common_attach);
 
 static int labpc_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
@@ -807,6 +811,7 @@ int labpc_common_detach(struct comedi_device *dev)
 
 	return 0;
 };
+EXPORT_SYMBOL_GPL(labpc_common_detach);
 
 static void labpc_clear_adc_fifo(const struct comedi_device *dev)
 {
@@ -2152,11 +2157,6 @@ module_init(driver_labpc_init_module);
 module_exit(driver_labpc_cleanup_module);
 #endif
 
-EXPORT_SYMBOL_GPL(labpc_common_attach);
-EXPORT_SYMBOL_GPL(labpc_common_detach);
-EXPORT_SYMBOL_GPL(range_labpc_1200_ai);
-EXPORT_SYMBOL_GPL(labpc_1200_ai_gain_bits);
-EXPORT_SYMBOL_GPL(labpc_1200_is_unipolar);
 
 MODULE_AUTHOR("Comedi http://www.comedi.org");
 MODULE_DESCRIPTION("Comedi low-level driver");
-- 
1.7.0.4

