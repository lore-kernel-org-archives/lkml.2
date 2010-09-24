Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566Ab0IXTTD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 15:19:03 -0400
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:50018 "EHLO
	qmta03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757522Ab0IXTTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 15:19:01 -0400
From: matt mooney <mfm@muteddisk.com>
To: kernel-janitors@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 02/24] char: change to new flag variable
Date: Fri, 24 Sep 2010 12:17:12 -0700
Message-Id: <9968d4260be8850200cc9c7dfe08addf611468b4.1285355033.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <e0bdab5d2e8c52041c003de68ba774c3e706716c.1285355033.git.mfm@muteddisk.com>
References: <e0bdab5d2e8c52041c003de68ba774c3e706716c.1285355033.git.mfm@muteddisk.com>
In-Reply-To: <e0bdab5d2e8c52041c003de68ba774c3e706716c.1285355033.git.mfm@muteddisk.com>
References: <e0bdab5d2e8c52041c003de68ba774c3e706716c.1285355033.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace EXTRA_CFLAGS with ccflags-y.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/char/mwave/Makefile |    4 ++--
 drivers/char/mwave/README   |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/char/mwave/Makefile b/drivers/char/mwave/Makefile
index 754c9e2..c0cf57e 100644
--- a/drivers/char/mwave/Makefile
+++ b/drivers/char/mwave/Makefile
@@ -9,7 +9,7 @@ obj-$(CONFIG_MWAVE) += mwave.o
 mwave-objs := mwavedd.o smapi.o tp3780i.o 3780i.o
 
 # To have the mwave driver disable other uarts if necessary
-# EXTRA_CFLAGS += -DMWAVE_FUTZ_WITH_OTHER_DEVICES
+# ccflags-y := -DMWAVE_FUTZ_WITH_OTHER_DEVICES
 
 # To compile in lots (~20 KiB) of run-time enablable printk()s for debugging:
-EXTRA_CFLAGS += -DMW_TRACE
+ccflags-y += -DMW_TRACE
diff --git a/drivers/char/mwave/README b/drivers/char/mwave/README
index 480251f..c2a58f4 100644
--- a/drivers/char/mwave/README
+++ b/drivers/char/mwave/README
@@ -11,7 +11,7 @@ are not saved by the BIOS and so do not persist after unload and reload.
 	0x0008 tp3780i tracing
 
         Tracing only occurs if the driver has been compiled with the
-        MW_TRACE macro #defined  (i.e. let EXTRA_CFLAGS += -DMW_TRACE
+        MW_TRACE macro #defined  (i.e. let ccflags-y := -DMW_TRACE
         in the Makefile).
 
   mwave_3780i_irq=5/7/10/11/15
-- 
1.7.2.1

