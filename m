Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757861Ab1ANOTo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 09:19:44 -0500
Received: from qmta07.emeryville.ca.mail.comcast.net ([76.96.30.64]:50025 "EHLO
	qmta07.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757781Ab1ANOTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 09:19:25 -0500
From: matt mooney <mfm@muteddisk.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RESEND PATCH 13/27] char: change to new flag variable
Date: Fri, 14 Jan 2011 06:12:36 -0800
Message-Id: <a58843383b54133255c341e8988a09b74f8c1901.1295006565.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <cover.1295006561.git.mfm@muteddisk.com>
References: <cover.1295006561.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace EXTRA_CFLAGS with ccflags-y.

Signed-off-by: matt mooney <mfm@muteddisk.com>
Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
---
 drivers/char/mwave/Makefile |    4 ++--
 drivers/char/mwave/README   |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/char/mwave/Makefile b/drivers/char/mwave/Makefile
index 26b4fce..efa6a82 100644
--- a/drivers/char/mwave/Makefile
+++ b/drivers/char/mwave/Makefile
@@ -9,7 +9,7 @@ obj-$(CONFIG_MWAVE) += mwave.o
 mwave-y := mwavedd.o smapi.o tp3780i.o 3780i.o
 
 # To have the mwave driver disable other uarts if necessary
-# EXTRA_CFLAGS += -DMWAVE_FUTZ_WITH_OTHER_DEVICES
+# ccflags-y := -DMWAVE_FUTZ_WITH_OTHER_DEVICES
 
 # To compile in lots (~20 KiB) of run-time enablable printk()s for debugging:
-ccflags-y := -DMW_TRACE
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
1.7.3.4

