Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932838Ab1JNMae (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 08:30:34 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:58622 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932784Ab1JNMac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 08:30:32 -0400
Subject: [PATCH 15/21] powerpc: drop unused Kconfig symbols
From: Paul Bolle <pebolle@tiscali.nl>
To: Josh Boyer <jwboyer@gmail.com>, Matt Porter <mporter@kernel.crashing.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Oct 2011 14:30:00 +0200
Message-ID: <1318595400.6132.73.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 arch/powerpc/Kconfig                       |   22 ----------------------
 arch/powerpc/platforms/40x/Kconfig         |    5 -----
 arch/powerpc/platforms/Kconfig.cputype     |    8 --------
 arch/powerpc/platforms/embedded6xx/Kconfig |    4 ----
 arch/powerpc/platforms/prep/Kconfig        |    9 ---------
 arch/powerpc/platforms/wsp/Kconfig         |    5 -----
 6 files changed, 0 insertions(+), 53 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 6926b61..6887d80 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -379,10 +379,6 @@ config PHYP_DUMP
 
 	  If unsure, say "N"
 
-config PPCBUG_NVRAM
-	bool "Enable reading PPCBUG NVRAM during boot" if PPLUS || LOPEC
-	default y if PPC_PREP
-
 config IRQ_ALL_CPUS
 	bool "Distribute interrupts on all CPUs by default"
 	depends on SMP && !MV64360
@@ -744,24 +740,6 @@ config 8260_PCI9
 	depends on PCI_8260 && !8272
 	default y
 
-choice
-	prompt "IDMA channel for PCI 9 workaround"
-	depends on 8260_PCI9
-
-config 8260_PCI9_IDMA1
-	bool "IDMA1"
-
-config 8260_PCI9_IDMA2
-	bool "IDMA2"
-
-config 8260_PCI9_IDMA3
-	bool "IDMA3"
-
-config 8260_PCI9_IDMA4
-	bool "IDMA4"
-
-endchoice
-
 source "drivers/pci/pcie/Kconfig"
 
 source "drivers/pci/Kconfig"
diff --git a/arch/powerpc/platforms/40x/Kconfig b/arch/powerpc/platforms/40x/Kconfig
index d733d7c..4bd3a27 100644
--- a/arch/powerpc/platforms/40x/Kconfig
+++ b/arch/powerpc/platforms/40x/Kconfig
@@ -115,11 +115,6 @@ config PPC40x_SIMPLE
 	help
 	  This option enables the simple PowerPC 40x platform support.
 
-# 40x specific CPU modules, selected based on the board above.
-config NP405H
-	bool
-	#depends on ASH
-
 # OAK doesn't exist but wanted to keep this around for any future 403GCX boards
 config 403GCX
 	bool
diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
index e06e395..f16f997 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -282,14 +282,6 @@ config PPC_MMU_NOHASH
 	def_bool y
 	depends on !PPC_STD_MMU
 
-config PPC_MMU_NOHASH_32
-	def_bool y
-	depends on PPC_MMU_NOHASH && PPC32
-
-config PPC_MMU_NOHASH_64
-	def_bool y
-	depends on PPC_MMU_NOHASH && PPC64
-
 config PPC_BOOK3E_MMU
 	def_bool y
 	depends on FSL_BOOKE || PPC_BOOK3E
diff --git a/arch/powerpc/platforms/embedded6xx/Kconfig b/arch/powerpc/platforms/embedded6xx/Kconfig
index 524d971..5a8f50a 100644
--- a/arch/powerpc/platforms/embedded6xx/Kconfig
+++ b/arch/powerpc/platforms/embedded6xx/Kconfig
@@ -87,10 +87,6 @@ config MV64X60
 config MPC10X_OPENPIC
 	bool
 
-config MPC10X_STORE_GATHERING
-	bool "Enable MPC10x store gathering"
-	depends on MPC10X_BRIDGE
-
 config GAMECUBE_COMMON
 	bool
 
diff --git a/arch/powerpc/platforms/prep/Kconfig b/arch/powerpc/platforms/prep/Kconfig
index f0536c7..1547f66 100644
--- a/arch/powerpc/platforms/prep/Kconfig
+++ b/arch/powerpc/platforms/prep/Kconfig
@@ -21,12 +21,3 @@ config PREP_RESIDUAL
 	  or pass the 'noresidual' option to the kernel.
 
 	  If you are running a PReP system, say Y here, otherwise say N.
-
-config PROC_PREPRESIDUAL
-	bool "Support for reading of PReP Residual Data in /proc"
-	depends on PREP_RESIDUAL && PROC_FS
-	help
-	  Enabling this option will create a /proc/residual file which allows
-	  you to get at the residual data on PReP systems.  You will need a tool
-	  (lsresidual) to parse it.  If you aren't on a PReP system, you don't
-	  want this.
diff --git a/arch/powerpc/platforms/wsp/Kconfig b/arch/powerpc/platforms/wsp/Kconfig
index c3c48eb..375f01e 100644
--- a/arch/powerpc/platforms/wsp/Kconfig
+++ b/arch/powerpc/platforms/wsp/Kconfig
@@ -21,8 +21,3 @@ endmenu
 config PPC_A2_DD2
 	bool "Support for DD2 based A2/WSP systems"
 	depends on PPC_A2
-
-config WORKAROUND_ERRATUM_463
-	depends on PPC_A2_DD2
-	bool "Workaround erratum 463"
-	default y
-- 
1.7.4.4




