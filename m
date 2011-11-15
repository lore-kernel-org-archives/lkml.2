Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710Ab2DRAVM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 20:21:12 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:56159 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366Ab2DRAVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 20:21:09 -0400
Message-Id: <8675ae$5bugrc@wolverine02.qualcomm.com>
X-IronPort-AV: E=McAfee;i="5400,1158,6684"; a="180306796"
From: Richard Kuo <rkuo@codeaurora.org>
Date: Tue, 15 Nov 2011 16:31:48 -0600
Subject: [PATCH 06/10] various Kconfig cleanup and old platform build code removal
To: linux-arch@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Kuo <rkuo@codeaurora.org>
---
 arch/hexagon/Kconfig  |   21 ++++-----------------
 arch/hexagon/Makefile |    5 -----
 2 files changed, 4 insertions(+), 22 deletions(-)

diff --git a/arch/hexagon/Kconfig b/arch/hexagon/Kconfig
index 3126fc6..e00d158 100644
--- a/arch/hexagon/Kconfig
+++ b/arch/hexagon/Kconfig
@@ -13,8 +13,8 @@ config HEXAGON
 	# select ARCH_REQUIRE_GPIOLIB
 	# select HAVE_CLK
 	# select IRQ_PER_CPU
-	select HAVE_IRQ_WORK
 	# select GENERIC_PENDING_IRQ if SMP
+	select HAVE_IRQ_WORK
 	select GENERIC_ATOMIC64
 	select HAVE_PERF_EVENTS
 	select HAVE_GENERIC_HARDIRQS
@@ -25,7 +25,7 @@ config HEXAGON
 	select HAVE_ARCH_TRACEHOOK
 	select NO_IOPORT
 	select GENERIC_IOMAP
-	# mostly generic routines, with some accelerated ones
+	select STACKTRACE_SUPPORT
 	---help---
 	  Qualcomm Hexagon is a processor architecture designed for high
 	  performance and low power across a wide variety of applications.
@@ -72,15 +72,6 @@ config GENERIC_CSUM
 config GENERIC_IRQ_PROBE
 	def_bool y
 
-#config ZONE_DMA
-#	bool
-#	default y
-
-config HAS_DMA
-	bool
-	select HAVE_DMA_ATTRS
-	default y
-
 config NEED_SG_DMA_LENGTH
 	def_bool y
 
@@ -113,14 +104,11 @@ config GENERIC_BUG
 	def_bool y
 	depends on BUG
 
-config BUG
-	def_bool y
-
 menu "Machine selection"
 
 choice
 	prompt "System type"
-	default HEXAGON_ARCH_V2
+	default HEXAGON_COMET
 
 config HEXAGON_COMET
 	bool "Comet Board"
@@ -193,8 +181,7 @@ source "kernel/Kconfig.hz"
 source "kernel/time/Kconfig"
 
 config GENERIC_GPIO
-	bool "Generic GPIO support"
-	default n
+	def_bool n
 
 endmenu
 
diff --git a/arch/hexagon/Makefile b/arch/hexagon/Makefile
index 0c4de87..7e32265 100644
--- a/arch/hexagon/Makefile
+++ b/arch/hexagon/Makefile
@@ -51,8 +51,3 @@ head-y := arch/hexagon/kernel/head.o \
 core-y += arch/hexagon/kernel/ \
 	arch/hexagon/mm/ \
 	arch/hexagon/lib/
-
-#	arch/hexagon/platform/common/
-#
-#core-$(CONFIG_HEXAGON_COMET)		+= arch/hexagon/platform/comet/
-#machine-$(CONFIG_HEXAGON_COMET)		:= comet
-- 
1.7.1


--

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
