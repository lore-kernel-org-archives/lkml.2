Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299Ab0LSVoS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 16:44:18 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:64785 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295Ab0LSVoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 16:44:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=tmQJVR1bICdr/2Mjn0iy1WVQrReEC0nw0QEzE6UNB6kUZJlQhgXrYZNCooRtD4pz//
         4InzYN7HdKEqiYS6FtYC/gr8GIfmVAWDIgU2Zr4FgaLvPH1k1wS3BVPr5jz/d0XlpKXW
         0GC4fyUhd6jdl6CIg1fHe5OPPUL5y+0b2Orbc=
Subject: [PATCH] x86: add optimisation option for k10 processors
From: Benjamin <masterme120@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 19 Dec 2010 16:45:32 -0500
Message-ID: <1292795132.14811.10.camel@benjamin-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Fair <masterme120@gmail.com>

This adds a config option to optimise for AMD family-k10 processors.

Signed-off-by: Benjamin Fair <masterme120@gmail.com>

diff -uNr linux-2.6.37-rc6.vanilla/arch/x86/Kconfig.cpu
linux-2.6.37-rc6/arch/x86/Kconfig.cpu
--- linux-2.6.37-rc6.vanilla/arch/x86/Kconfig.cpu	2010-12-15
20:24:48.000000000 -0500
+++ linux-2.6.37-rc6/arch/x86/Kconfig.cpu	2010-12-19 14:31:59.034429012
-0500
@@ -171,6 +171,13 @@
 	  Enables use of some extended instructions, and passes appropriate
 	  optimization flags to GCC.
 
+config MK10
+	bool "Phenom/Phenom-II/Athlon-II/K10/10h"
+	---help---
+	  Select this for an AMD K10-family processor.  Also known as Family
+	  10h.  Enables use of some extended instructions, and passes
+	  appropriate  optimization flags to GCC.
+
 config MCRUSOE
 	bool "Crusoe"
 	depends on X86_32
@@ -313,7 +320,7 @@
 config X86_L1_CACHE_SHIFT
 	int
 	default "7" if MPENTIUM4 || MPSC
-	default "6" if MK7 || MK8 || MPENTIUMM || MCORE2 || MATOM || MVIAC7 ||
X86_GENERIC || GENERIC_CPU
+	default "6" if MK7 || MK8 || MK10 || MPENTIUMM || MCORE2 || MATOM ||
MVIAC7 || X86_GENERIC || GENERIC_CPU
 	default "4" if X86_ELAN || M486 || M386 || MGEODEGX1
 	default "5" if MWINCHIP3D || MWINCHIPC6 || MCRUSOE || MEFFICEON ||
MCYRIXIII || MK6 || MPENTIUMIII || MPENTIUMII || M686 || M586MMX ||
M586TSC || M586 || MVIAC3_2 || MGEODE_LX
 
@@ -364,11 +371,11 @@
 
 config X86_INTEL_USERCOPY
 	def_bool y
-	depends on MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII ||
M586MMX || X86_GENERIC || MK8 || MK7 || MEFFICEON || MCORE2
+	depends on MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII ||
M586MMX || X86_GENERIC || MK10 || MK8 || MK7 || MEFFICEON || MCORE2
 
 config X86_USE_PPRO_CHECKSUM
 	def_bool y
-	depends on MWINCHIP3D || MWINCHIPC6 || MCYRIXIII || MK7 || MK6 ||
MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MK8 ||
MVIAC3_2 || MEFFICEON || MGEODE_LX || MCORE2 || MATOM
+	depends on MWINCHIP3D || MWINCHIPC6 || MCYRIXIII || MK7 || MK6 ||
MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MK8 ||
MK10 || MVIAC3_2 || MEFFICEON || MGEODE_LX || MCORE2 || MATOM
 
 config X86_USE_3DNOW
 	def_bool y
@@ -396,7 +403,7 @@
 
 config X86_TSC
 	def_bool y
-	depends on ((MWINCHIP3D || MCRUSOE || MEFFICEON || MCYRIXIII || MK7 ||
MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 ||
M586MMX || M586TSC || MK8 || MVIAC3_2 || MVIAC7 || MGEODEGX1 ||
MGEODE_LX || MCORE2 || MATOM) && !X86_NUMAQ) || X86_64
+	depends on ((MWINCHIP3D || MCRUSOE || MEFFICEON || MCYRIXIII || MK7 ||
MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 ||
M586MMX || M586TSC || MK10 || MK8 || MVIAC3_2 || MVIAC7 || MGEODEGX1 ||
MGEODE_LX || MCORE2 || MATOM) && !X86_NUMAQ) || X86_64
 
 config X86_CMPXCHG64
 	def_bool y
@@ -406,7 +413,7 @@
 # generates cmov.
 config X86_CMOV
 	def_bool y
-	depends on (MK8 || MK7 || MCORE2 || MPENTIUM4 || MPENTIUMM ||
MPENTIUMIII || MPENTIUMII || M686 || MVIAC3_2 || MVIAC7 || MCRUSOE ||
MEFFICEON || X86_64 || MATOM || MGEODE_LX)
+	depends on (MK10 || MK8 || MK7 || MCORE2 || MPENTIUM4 || MPENTIUMM ||
MPENTIUMIII || MPENTIUMII || M686 || MVIAC3_2 || MVIAC7 || MCRUSOE ||
MEFFICEON || X86_64 || MATOM || MGEODE_LX)
 
 config X86_MINIMUM_CPU_FAMILY
 	int
diff -uNr linux-2.6.37-rc6.vanilla/arch/x86/Makefile
linux-2.6.37-rc6/arch/x86/Makefile
--- linux-2.6.37-rc6.vanilla/arch/x86/Makefile	2010-12-15
20:24:48.000000000 -0500
+++ linux-2.6.37-rc6/arch/x86/Makefile	2010-12-19 15:42:01.041429011
-0500
@@ -51,6 +51,7 @@
 
         # FIXME - should be integrated in Makefile.cpu
(Makefile_32.cpu)
         cflags-$(CONFIG_MK8) += $(call cc-option,-march=k8)
+        cflags-$(CONFIG_MK10) += $(call cc-option,-march=amdfam10)
         cflags-$(CONFIG_MPSC) += $(call cc-option,-march=nocona)
 
         cflags-$(CONFIG_MCORE2) += \
diff -uNr linux-2.6.37-rc6.vanilla/arch/x86/Makefile_32.cpu
linux-2.6.37-rc6/arch/x86/Makefile_32.cpu
--- linux-2.6.37-rc6.vanilla/arch/x86/Makefile_32.cpu	2010-12-15
20:24:48.000000000 -0500
+++ linux-2.6.37-rc6/arch/x86/Makefile_32.cpu	2010-12-19
14:30:29.196429012 -0500
@@ -25,6 +25,7 @@
 # They make zero difference whatsosever to performance at this time.
 cflags-$(CONFIG_MK7)		+= -march=athlon
 cflags-$(CONFIG_MK8)		+= $(call cc-option,-march=k8,-march=athlon)
+clfags-$(CONFIG_MK10)		+= $(call cc-option,-march=amdfam10)
 cflags-$(CONFIG_MCRUSOE)	+= -march=i686 $(align)-functions=0
$(align)-jumps=0 $(align)-loops=0
 cflags-$(CONFIG_MEFFICEON)	+= -march=i686 $(call tune,pentium3)
$(align)-functions=0 $(align)-jumps=0 $(align)-loops=0
 cflags-$(CONFIG_MWINCHIPC6)	+= $(call
cc-option,-march=winchip-c6,-march=i586)

