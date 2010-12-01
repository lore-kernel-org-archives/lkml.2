Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab0LAPaj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 10:30:39 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:58154 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545Ab0LAPah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 10:30:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=DjqRsugRKxIe83+TQMDgAKcnceiF880VeC1qpg8pkLuiUl6+KGaJnEbJCqvwCwpDoS
         nUuT98unlgMepnzsxmxrjSawBndQlTlBCmEHUezbEGcpq5plz59eekXO1KC2sgsJtED0
         Gaiir1jvSH/Ae1PuV5U+t4OcUZo8aJQiN+ad0=
From: Hans Ulli Kroll <ulli.kroll@googlemail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>
Subject: [PATCH] Kconfig: add new symbol MIGHT_HAVE_PCI
Date: Wed,  1 Dec 2010 16:30:12 +0100
Message-Id: <1291217412-9435-1-git-send-email-ulli.kroll@googlemail.com>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today more boards with arm cpu have selectable pci bus.
This patch makes this more scalable and remove line continuations in
Kconfig

Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Hans Ulli Kroll <ulli.kroll@googlemail.com>
---
 arch/arm/Kconfig                 |    7 ++++++-
 arch/arm/mach-cns3xxx/Kconfig    |    1 +
 arch/arm/mach-integrator/Kconfig |    1 +
 arch/arm/mach-ks8695/Kconfig     |    1 +
 arch/arm/mach-pxa/Kconfig        |    1 +
 arch/arm/mach-versatile/Kconfig  |    1 +
 6 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index a19a526..614cf2f 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -34,6 +34,9 @@ config ARM
 config HAVE_PWM
 	bool
 
+config MIGHT_HAVE_PCI
+	bool
+
 config SYS_SUPPORTS_APM_EMULATION
 	bool
 
@@ -298,6 +301,7 @@ config ARCH_CNS3XXX
 	select CPU_V6
 	select GENERIC_CLOCKEVENTS
 	select ARM_GIC
+	select MIGHT_HAVE_PCI
 	select PCI_DOMAINS if PCI
 	help
 	  Support for Cavium Networks CNS3XXX platform.
@@ -433,6 +437,7 @@ config ARCH_IXP4XX
 	select CPU_XSCALE
 	select GENERIC_GPIO
 	select GENERIC_CLOCKEVENTS
+	select MIGHT_HAVE_PCI
 	select DMABOUNCE if PCI
 	help
 	  Support for Intel's IXP4XX (XScale) family of processors.
@@ -1164,7 +1169,7 @@ config ISA_DMA_API
 	bool
 
 config PCI
-	bool "PCI support" if ARCH_INTEGRATOR_AP || ARCH_VERSATILE_PB || ARCH_IXP4XX || ARCH_KS8695 || MACH_ARMCORE || ARCH_CNS3XXX
+	bool "PCI support" if MIGHT_HAVE_PCI
 	help
 	  Find out whether you have a PCI motherboard. PCI is the name of a
 	  bus system, i.e. the way the CPU talks to the other stuff inside
diff --git a/arch/arm/mach-cns3xxx/Kconfig b/arch/arm/mach-cns3xxx/Kconfig
index 9ebfcc4..29b13f2 100644
--- a/arch/arm/mach-cns3xxx/Kconfig
+++ b/arch/arm/mach-cns3xxx/Kconfig
@@ -3,6 +3,7 @@ menu "CNS3XXX platform type"
 
 config MACH_CNS3420VB
 	bool "Support for CNS3420 Validation Board"
+	select MIGHT_HAVE_PCI
 	help
 	  Include support for the Cavium Networks CNS3420 MPCore Platform
 	  Baseboard.
diff --git a/arch/arm/mach-integrator/Kconfig b/arch/arm/mach-integrator/Kconfig
index 27db275..769b0f1 100644
--- a/arch/arm/mach-integrator/Kconfig
+++ b/arch/arm/mach-integrator/Kconfig
@@ -4,6 +4,7 @@ menu "Integrator Options"
 
 config ARCH_INTEGRATOR_AP
 	bool "Support Integrator/AP and Integrator/PP2 platforms"
+	select MIGHT_HAVE_PCI
 	help
 	  Include support for the ARM(R) Integrator/AP and
 	  Integrator/PP2 platforms.
diff --git a/arch/arm/mach-ks8695/Kconfig b/arch/arm/mach-ks8695/Kconfig
index fe0c82e..f5c39a8 100644
--- a/arch/arm/mach-ks8695/Kconfig
+++ b/arch/arm/mach-ks8695/Kconfig
@@ -4,6 +4,7 @@ menu "Kendin/Micrel KS8695 Implementations"
 
 config MACH_KS8695
 	bool "KS8695 development board"
+	select MIGHT_HAVE_PCI
 	help
 	  Say 'Y' here if you want your kernel to run on the original
 	  Kendin-Micrel KS8695 development board.
diff --git a/arch/arm/mach-pxa/Kconfig b/arch/arm/mach-pxa/Kconfig
index dd235ec..716a2e1 100644
--- a/arch/arm/mach-pxa/Kconfig
+++ b/arch/arm/mach-pxa/Kconfig
@@ -94,6 +94,7 @@ config MACH_ARMCORE
 	select PXA27x
 	select IWMMXT
 	select PXA25x
+	select MIGHT_HAVE_PCI
 
 config MACH_EM_X270
 	bool "CompuLab EM-x270 platform"
diff --git a/arch/arm/mach-versatile/Kconfig b/arch/arm/mach-versatile/Kconfig
index c781f30..3f7b5e9 100644
--- a/arch/arm/mach-versatile/Kconfig
+++ b/arch/arm/mach-versatile/Kconfig
@@ -4,6 +4,7 @@ menu "Versatile platform type"
 config ARCH_VERSATILE_PB
 	bool "Support Versatile/PB platform"
 	select CPU_ARM926T
+	select MIGHT_HAVE_PCI
 	default y
 	help
 	  Include support for the ARM(R) Versatile/PB platform.
-- 
1.7.3.2

