Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530Ab0EFKJE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 06:09:04 -0400
Received: from mail-iw0-f197.google.com ([209.85.223.197]:58052 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab0EFKJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 06:09:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=SaweZGTNl2Kd/UY+1+8i0wcjkRsi3qndvGCNK3pdMCkn3aynkK8aW6ILAdjXkxpHBZ
         ejXxb1IwCLpsCmKZFalUFN/iguSAE53aKWw7JnszO7vwcwJzj/Ily91XEFoHogZb8wou
         OvHhp+721/XwjN5Nd4Q25lo/z8UUQEGa5UZC8=
From: Mark <reodge@gmail.com>
To: gregkh@suse.de, berndporr@f2s.com, revent82@gmail.com,
       shawn.bohrer@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Mark <reodge@gmail.com>
Subject: [PATCH] Staging: comedi: Fixed long line lengths in comedi.h
Date: Thu,  6 May 2010 18:07:44 +0800
Message-Id: <1273140464-9384-1-git-send-email-reodge@gmail.com>
X-Mailer: git-send-email 1.7.0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patches fixes some of the long line lengths that checkpatch.pl was
complaining about in comedi.h

Signed-off-by: Mark Rankilor <reodge@gmail.com>
---
 drivers/staging/comedi/comedi.h |   26 +++++++++++++++++---------
 1 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/comedi/comedi.h b/drivers/staging/comedi/comedi.h
index 8e4caaa..20a6fee 100644
--- a/drivers/staging/comedi/comedi.h
+++ b/drivers/staging/comedi/comedi.h
@@ -46,8 +46,10 @@
 #define COMEDI_DEVCONF_AUX_DATA2_LENGTH		26
 #define COMEDI_DEVCONF_AUX_DATA1_LENGTH		27
 #define COMEDI_DEVCONF_AUX_DATA0_LENGTH		28
-#define COMEDI_DEVCONF_AUX_DATA_HI		29	/* most significant 32 bits of pointer address (if needed) */
-#define COMEDI_DEVCONF_AUX_DATA_LO		30	/* least significant 32 bits of pointer address */
+/* most significant 32 bits of pointer address (if needed) */
+#define COMEDI_DEVCONF_AUX_DATA_HI		29
+/* least significant 32 bits of pointer address */
+#define COMEDI_DEVCONF_AUX_DATA_LO		30
 #define COMEDI_DEVCONF_AUX_DATA_LENGTH		31	/* total data length */
 
 /* max length of device and driver names */
@@ -55,8 +57,10 @@
 
 /* packs and unpacks a channel/range number */
 
-#define CR_PACK(chan, rng, aref)		((((aref)&0x3)<<24) | (((rng)&0xff)<<16) | (chan))
-#define CR_PACK_FLAGS(chan, range, aref, flags)	(CR_PACK(chan, range, aref) | ((flags) & CR_FLAGS_MASK))
+#define CR_PACK(chan, rng, aref)					\
+	((((aref)&0x3)<<24) | (((rng)&0xff)<<16) | (chan))
+#define CR_PACK_FLAGS(chan, range, aref, flags)				\
+	(CR_PACK(chan, range, aref) | ((flags) & CR_FLAGS_MASK))
 
 #define CR_CHAN(a)	((a)&0xffff)
 #define CR_RANGE(a)	(((a)>>16)&0xff)
@@ -125,7 +129,8 @@
 /* command flags */
 /* These flags are used in comedi_cmd structures */
 
-#define CMDF_PRIORITY		0x00000008	/* try to use a real-time interrupt while performing command */
+/* try to use a real-time interrupt while performing command */
+#define CMDF_PRIORITY		0x00000008
 
 #define TRIG_RT		CMDF_PRIORITY	/* compatibility definition */
 
@@ -242,15 +247,18 @@
 		INSN_CONFIG_DISARM = 32,
 		INSN_CONFIG_GET_COUNTER_STATUS = 33,
 		INSN_CONFIG_RESET = 34,
-		INSN_CONFIG_GPCT_SINGLE_PULSE_GENERATOR = 1001,	/* Use CTR as single pulsegenerator */
-		INSN_CONFIG_GPCT_PULSE_TRAIN_GENERATOR = 1002,	/* Use CTR as pulsetraingenerator */
-		INSN_CONFIG_GPCT_QUADRATURE_ENCODER = 1003,	/* Use the counter as encoder */
+		/* Use CTR as single pulsegenerator */
+		INSN_CONFIG_GPCT_SINGLE_PULSE_GENERATOR = 1001,
+		/* Use CTR as pulsetraingenerator */
+		INSN_CONFIG_GPCT_PULSE_TRAIN_GENERATOR = 1002,
+		/* Use the counter as encoder */
+		INSN_CONFIG_GPCT_QUADRATURE_ENCODER = 1003,
 		INSN_CONFIG_SET_GATE_SRC = 2001,	/* Set gate source */
 		INSN_CONFIG_GET_GATE_SRC = 2002,	/* Get gate source */
 		INSN_CONFIG_SET_CLOCK_SRC = 2003,	/* Set master clock source */
 		INSN_CONFIG_GET_CLOCK_SRC = 2004,	/* Get master clock source */
 		INSN_CONFIG_SET_OTHER_SRC = 2005,	/* Set other source */
-		/*	INSN_CONFIG_GET_OTHER_SRC = 2006,*//* Get other source */
+		/* INSN_CONFIG_GET_OTHER_SRC = 2006,*//* Get other source */
 		INSN_CONFIG_GET_HARDWARE_BUFFER_SIZE = 2006,	/* Get size in bytes of
 								   subdevice's on-board
 								   fifos used during
-- 
1.7.0.5

