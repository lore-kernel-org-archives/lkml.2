Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998Ab2LEWPd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 17:15:33 -0500
Received: from nm40-vm4.bullet.mail.bf1.yahoo.com ([72.30.239.212]:48235 "EHLO
	nm40-vm4.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753468Ab2LEWPc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 17:15:32 -0500
X-Greylist: delayed 375 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Dec 2012 17:15:31 EST
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 436833.89470.bm@omp1060.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=LdEBVtGSO8TdUCfhmXJ24Np31+ETK+Ixovwl7GNxG031l4+6cZk2ZYrfKwkEqI1vkRdjU2fvL35IrdG6lDqUYgaFDt1n26FnTA3Ve58906Oh+LXWt71rAgXX7VV4ZYXhwAEo8m84hfTY2JX4nhgtGD8dRUcGYrdG265750sz7x8=;
X-YMail-OSG: dU2wBw4VM1lIp6MUINzDkHAVkdkYgTysGdjKhGY6DrPsmUF
 OpDInwB3gJoozMTExIQQb5xZAFwVuMBsdotbCzN0hl1QPcCyHZyxDhRF.9bB
 MqxKNCt44y3PVDeYMGjUnxUkNQP3qlfzM0kYLmZsHtpxp1MNjlYwFXlc1_is
 ULU9lnY6dFAIwcmubaiw5NYMMWWKyXIDCQdyY_QiIXKcDGpUg4_ZGXh0Ghxg
 h_umef2gFqfbesVe8qLHxzFNMKpoaf_4rmtNBKScfERu4wLSdybbznKQP8ey
 4XTvFzrnvLxUvuTMut8zgFRMbodyj12amJXtiUVgBypa8LNi46ebBQHstuK2
 UE5IlvNbpFuK64vt5WTF.49Nk8VVWK4qY909kvmv02twGd0jbifHakqJtGcY
 lOfvNuNnB0WPIyCU.u_d2R.O3YdANUwo5i4U.gYN_.XSCxJBIkd6NDqaujDX
 9TS51LeQRXQmSKzmPv8rvaL3IK1LpcejcYh9q0EBR5i1XgrJwcD6K1YaiJ8J
 BDz.ZuigIf565Sg5LvMUVVycmGi_sJObYhvPQHI.1Qz5L5OUFT8LspXZ6lhn
 52EZCbr3an5xeRJNPdIYBkjA.iFO6Ti5LKQ--
X-Rocket-MIMEInfo: 001.001,Q2FtZSBhY3Jvc3MgdGhpcyBhbmQgd2FudGVkIHRvIHNob3cgaXQgdG8gb3RoZXJzIG1vcmXCoGtub3dsZWRnZWFibGXCoGZvciBmZWVkYmFjay4gwqBJcyB0aGlzIHZhbHVlLWFkZGVkIG9yIG5vdD8gwqBVcHN0cmVhbSBVUkwgaXM6wqBodHRwczovL2dpdG9yaW91cy5vcmcvcnVtbWFnZS9yYW5kb21fcGF0Y2hlcwoKUGxlYXNlIGNjIG1lIG9uIHJlcGxpZXMgYXMgSSBhbSBub3QgYSByZWd1bGFyIHN1YnNjcmliZXIgdG8gbGttbC4gwqBUaGFuayB5b3UuCgotLS0gbGludXgtMy42L2FyY2gveDg2L2luY2x1ZGUBMAEBAQE-
X-Mailer: YahooMailWebService/0.8.128.478
Message-ID: <1354745355.79857.YahooMailNeo@web140001.mail.bf1.yahoo.com>
Date: Wed, 5 Dec 2012 14:09:15 -0800 (PST)
From: John <da_audiophile@yahoo.com>
Reply-To: John <da_audiophile@yahoo.com>
Subject: [PATCH] Additional compiler optimization options
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "da_audiophile@yahoo.com" <da_audiophile@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Came across this and wanted to show it to others more knowledgeable for feedback.  Is this value-added or not?  Upstream URL is: https://gitorious.org/rummage/random_patches

Please cc me on replies as I am not a regular subscriber to lkml.  Thank you.

--- linux-3.6/arch/x86/include/asm/module.h2012-04-29 18:43:58.239336240 -0700
+++ linux-3.6.mod/arch/x86/include/asm/module.h2012-04-29 18:43:41.609545221 -0700
@@ -17,6 +17,14 @@
 #define MODULE_PROC_FAMILY "586MMX "
 #elif defined CONFIG_MCORE2
 #define MODULE_PROC_FAMILY "CORE2 "
+#elif defined CONFIG_MCOREI7
+#define MODULE_PROC_FAMILY "COREI7 "
+#elif defined CONFIG_MCOREI7AVX
+#define MODULE_PROC_FAMILY "COREI7AVX "
+#elif defined CONFIG_MCOREAVXI
+#define MODULE_PROC_FAMILY "COREAVXI "
+#elif defined CONFIG_MCOREAVX2
+#define MODULE_PROC_FAMILY "COREAVX2 "
 #elif defined CONFIG_MATOM
 #define MODULE_PROC_FAMILY "ATOM "
 #elif defined CONFIG_M686
@@ -35,6 +43,14 @@
 #define MODULE_PROC_FAMILY "K7 "
 #elif defined CONFIG_MK8
 #define MODULE_PROC_FAMILY "K8 "
+#elif defined CONFIG_MBARCELONA
+#define MODULE_PROC_FAMILY "BARCELONA "
+#elif defined CONFIG_MBOBCAT
+#define MODULE_PROC_FAMILY "BOBCAT "
+#elif defined CONFIG_MBULLDOZER
+#define MODULE_PROC_FAMILY "BULLDOZER "
+#elif defined CONFIG_MPILEDRIVER
+#define MODULE_PROC_FAMILY "PILEDRIVER "
 #elif defined CONFIG_MELAN
 #define MODULE_PROC_FAMILY "ELAN "
 #elif defined CONFIG_MCRUSOE
--- linux-3.6/arch/x86/Kconfig.cpu2012-04-29 18:43:58.249336198 -0700
+++ linux-3.6.mod/arch/x86/Kconfig.cpu2012-04-29 18:40:46.091751798 -0700
@@ -147,7 +147,7 @@
 
 
 config MK6
-bool "K6/K6-II/K6-III"
+bool "AMD K6/K6-II/K6-III"
 depends on X86_32
 ---help---
   Select this for an AMD K6-family processor.  Enables use of
@@ -155,7 +155,7 @@
   flags to GCC.
 
 config MK7
-bool "Athlon/Duron/K7"
+bool "AMD Athlon/Duron/K7"
 depends on X86_32
 ---help---
   Select this for an AMD Athlon K7-family processor.  Enables use of
@@ -163,12 +163,40 @@
   flags to GCC.
 
 config MK8
-bool "Opteron/Athlon64/Hammer/K8"
+bool "AMD Opteron/Athlon64/Hammer/K8"
 ---help---
   Select this for an AMD Opteron or Athlon64 Hammer-family processor.
   Enables use of some extended instructions, and passes appropriate
   optimization flags to GCC.
 
+config MBARCELONA
+bool "AMD Barcelona"
+---help---
+  Select this for AMD Barcelona and newer processors.
+
+  Enables -march=barcelona
+
+config MBOBCAT
+bool "AMD Bobcat"
+---help---
+  Select this for AMD Bobcat processors.
+
+  Enables -march=btver1
+
+config MBULLDOZER
+bool "AMD Bulldozer"
+---help---
+  Select this for AMD Bulldozer processors.
+
+  Enables -march=bdver1
+
+config MPILEDRIVER
+bool "AMD Piledriver"
+---help---
+  Select this for AMD Piledriver processors.
+
+  Enables -march=bdver2
+
 config MCRUSOE
 bool "Crusoe"
 depends on X86_32
@@ -260,7 +288,7 @@
   in /proc/cpuinfo. Family 15 is an older Xeon, Family 6 a newer one.
 
 config MCORE2
-bool "Core 2/newer Xeon"
+bool "Intel Core 2"
 ---help---
 
   Select this for Intel Core 2 and newer Core 2 Xeons (Xeon 51xx and
@@ -268,6 +296,41 @@
   family in /proc/cpuinfo. Newer ones have 6 and older ones 15
   (not a typo)
 
+  Enables -march=core2
+
+config MCOREI7
+bool "Intel Core i7"
+---help---
+
+  Select this for the Intel Nehalem platform. Intel Nehalem proecessors
+  include Core i3, i5, i7, Xeon: 34xx, 35xx, 55xx, 56xx, 75xx processors.
+
+  Enables -march=corei7
+
+config MCOREI7AVX
+bool "Intel Core 2nd Gen AVX"
+---help---
+
+  Select this for 2nd Gen Core processors including Sandy Bridge.
+
+  Enables -march=corei7-avx
+
+config MCOREAVXI
+bool "Intel Core 3rd Gen AVX"
+---help---
+
+  Select this for 3rd Gen Core processors including Ivy Bridge.
+
+  Enables -march=corei7-avx
+
+config MCOREAVX2
+bool "Intel Core AVX-2"
+---help---
+
+  Select this for AVX-2 enabled processors including Haswell.
+
+  Enables -march=corei7-avx-2
+
 config MATOM
 bool "Intel Atom"
 ---help---
@@ -312,7 +375,7 @@
 config X86_L1_CACHE_SHIFT
 int
 default "7" if MPENTIUM4 || MPSC
-default "6" if MK7 || MK8 || MPENTIUMM || MCORE2 || MATOM || MVIAC7 || X86_GENERIC || GENERIC_CPU
+default "6" if MK7 || MK8 || MBARCELONA || MBOBCAT || MBULLDOZER || MPILEDRIVER || MPENTIUMM || MCORE2 || MCOREI7 || MCOREI7AVX || MCOREAVXI || MCOREAVX2 || MATOM || MVIAC7 || X86_GENERIC || GENERIC_CPU
 default "4" if MELAN || M486 || M386 || MGEODEGX1
 default "5" if MWINCHIP3D || MWINCHIPC6 || MCRUSOE || MEFFICEON || MCYRIXIII || MK6 || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || M586 || MVIAC3_2 || MGEODE_LX
 
@@ -363,11 +426,11 @@
 
 config X86_INTEL_USERCOPY
 def_bool y
-depends on MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M586MMX || X86_GENERIC || MK8 || MK7 || MEFFICEON || MCORE2
+depends on MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M586MMX || X86_GENERIC || MK8 || MK7 || MBARCELONA || MEFFICEON || MCORE2 || MCOREI7 || MCOREI7AVX || MCOREAVXI || MCOREAVX2
 
 config X86_USE_PPRO_CHECKSUM
 def_bool y
-depends on MWINCHIP3D || MWINCHIPC6 || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MK8 || MVIAC3_2 || MVIAC7 || MEFFICEON || MGEODE_LX || MCORE2 || MATOM
+depends on MWINCHIP3D || MWINCHIPC6 || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MK8 || MVIAC3_2 || MVIAC7 || MEFFICEON || MGEODE_LX || MCORE2 || MCOREI7 || MCOREI7AVX || MCOREAVXI || MCOREAVX2 || MATOM
 
 config X86_USE_3DNOW
 def_bool y
@@ -395,17 +458,17 @@
 
 config X86_TSC
 def_bool y
-depends on ((MWINCHIP3D || MCRUSOE || MEFFICEON || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || MK8 || MVIAC3_2 || MVIAC7 || MGEODEGX1 || MGEODE_LX || MCORE2 || MATOM) && !X86_NUMAQ) || X86_64
+depends on ((MWINCHIP3D || MCRUSOE || MEFFICEON || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || MK8 || MBARCELONA || MBOBCAT || MBULLDOZER || MPILEDRIVER || MVIAC3_2 || MVIAC7 || MGEODEGX1 || MGEODE_LX || MCORE2 || MCOREI7 || MCOREI7-AVX || MATOM) && !X86_NUMAQ) || X86_64
 
 config X86_CMPXCHG64
 def_bool y
-depends on X86_PAE || X86_64 || MCORE2 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MATOM
+depends on X86_PAE || X86_64 || MCORE2 || MCOREI7 || MCOREI7AVX || MCOREAVXI || MCOREAVX2 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MATOM
 
 # this should be set for all -march=.. options where the compiler
 # generates cmov.
 config X86_CMOV
 def_bool y
-depends on (MK8 || MK7 || MCORE2 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MVIAC3_2 || MVIAC7 || MCRUSOE || MEFFICEON || X86_64 || MATOM || MGEODE_LX)
+depends on (MK8 || MBARCELONA || MBOBCAT || MBULLDOZER || MPILEDRIVER || MK7 || MCORE2 || MCOREI7 || MCOREI7AVX || MCOREAVXI || MCOREAVX2 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MVIAC3_2 || MVIAC7 || MCRUSOE || MEFFICEON || X86_64 || MATOM || MGEODE_LX)
 
 config X86_MINIMUM_CPU_FAMILY
 int
--- linux-3.6/arch/x86/Makefile2012-04-29 18:43:58.249336198 -0700
+++ linux-3.6.mod/arch/x86/Makefile2012-04-29 18:41:51.260932642 -0700
@@ -51,10 +51,22 @@
 
         # FIXME - should be integrated in Makefile.cpu (Makefile_32.cpu)
         cflags-$(CONFIG_MK8) += $(call cc-option,-march=k8)
+        cflags-$(CONFIG_MBARCELONA) += $(call cc-option,-march=barcelona)
+        cflags-$(CONFIG_MBOBCAT) += $(call cc-option,-march=btver1)
+        cflags-$(CONFIG_MBULLDOZER) += $(call cc-option,-march=bdver1)
+        cflags-$(CONFIG_MPILEDRIVER) += $(call cc-option,-march=bdver2)
         cflags-$(CONFIG_MPSC) += $(call cc-option,-march=nocona)
 
         cflags-$(CONFIG_MCORE2) += \
-                $(call cc-option,-march=core2,$(call cc-option,-mtune=generic))
+                $(call cc-option,-march=core2,$(call cc-option,-mtune=core2))
+        cflags-$(CONFIG_MCOREI7) += \
+                $(call cc-option,-march=corei7,$(call cc-option,-mtune=corei7))
+        cflags-$(CONFIG_MCOREI7AVX) += \
+                $(call cc-option,-march=corei7-avx,$(call cc-option,-mtune=corei7-avx))
+        cflags-$(CONFIG_MCOREAVXI) += \
+                $(call cc-option,-march=core-avx-i,$(call cc-option,-mtune=core-avx-i))
+        cflags-$(CONFIG_MCOREAVX2) += \
+                $(call cc-option,-march=core-avx2,$(call cc-option,-mtune=core-avx2))
 cflags-$(CONFIG_MATOM) += $(call cc-option,-march=atom) \
 $(call cc-option,-mtune=atom,$(call cc-option,-mtune=generic))
         cflags-$(CONFIG_GENERIC_CPU) += $(call cc-option,-mtune=generic)
--- linux-3.6/arch/x86/Makefile_32.cpu2012-04-29 18:43:58.269335977 -0700
+++ linux-3.6.mod/arch/x86/Makefile_32.cpu2012-04-29 18:42:39.120330975 -0700
@@ -25,6 +25,10 @@
 # They make zero difference whatsosever to performance at this time.
 cflags-$(CONFIG_MK7)+= -march=athlon
 cflags-$(CONFIG_MK8)+= $(call cc-option,-march=k8,-march=athlon)
+cflags-$(CONFIG_MBARCELONA)+= $(call cc-option,-march=barcelona,-march=athlon)
+cflags-$(CONFIG_MBOBCAT)+= $(call cc-option,-march=btver1,-march=athlon)
+cflags-$(CONFIG_MBULLDOZER)+= $(call cc-option,-march=bdver1,-march=athlon)
+cflags-$(CONFIG_MPILEDRIVER)+= $(call cc-option,-march=bdver2,-march=athlon)
 cflags-$(CONFIG_MCRUSOE)+= -march=i686 $(align)-functions=0 $(align)-jumps=0 $(align)-loops=0
 cflags-$(CONFIG_MEFFICEON)+= -march=i686 $(call tune,pentium3) $(align)-functions=0 $(align)-jumps=0 $(align)-loops=0
 cflags-$(CONFIG_MWINCHIPC6)+= $(call cc-option,-march=winchip-c6,-march=i586)
@@ -33,6 +37,10 @@
 cflags-$(CONFIG_MVIAC3_2)+= $(call cc-option,-march=c3-2,-march=i686)
 cflags-$(CONFIG_MVIAC7)+= -march=i686
 cflags-$(CONFIG_MCORE2)+= -march=i686 $(call tune,core2)
+cflags-$(CONFIG_MCOREI7)+= -march=i686 $(call tune,corei7)
+cflags-$(CONFIG_MCOREI7AVX)+= -march=i686 $(call tune,corei7-avx)
+cflags-$(CONFIG_MCOREAVXI)+= -march=i686 $(call tune,core-avx-i)
+cflags-$(CONFIG_MCOREAVX2)+= -march=i686 $(call tune,core-avx-2)
 cflags-$(CONFIG_MATOM)+= $(call cc-option,-march=atom,$(call cc-option,-march=core2,-march=i686)) \
 $(call cc-option,-mtune=atom,$(call cc-option,-mtune=generic))
