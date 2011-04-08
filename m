Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936Ab1DHUhw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 16:37:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:57093 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757920Ab1DHUhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 16:37:48 -0400
Date: Fri, 8 Apr 2011 20:37:03 GMT
From: tip-bot for Ian Campbell <ijc@hellion.org.uk>
Message-ID: <tip-ce9c99af8d4b3b0b9463654fd252d8640d804dc3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        ian.campbell@citrix.com, ijc@hellion.org.uk, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ijc@hellion.org.uk, ian.campbell@citrix.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1302245177.31620.47.camel@localhost.localdomain>
References: <1302245177.31620.47.camel@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, cpu: Move AMD Elan Kconfig under "Processor family"
Git-Commit-ID: ce9c99af8d4b3b0b9463654fd252d8640d804dc3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 08 Apr 2011 20:37:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ce9c99af8d4b3b0b9463654fd252d8640d804dc3
Gitweb:     http://git.kernel.org/tip/ce9c99af8d4b3b0b9463654fd252d8640d804dc3
Author:     Ian Campbell <ijc@hellion.org.uk>
AuthorDate: Fri, 8 Apr 2011 07:42:29 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 8 Apr 2011 13:01:25 -0700

x86, cpu: Move AMD Elan Kconfig under "Processor family"

Currently the option resides under X86_EXTENDED_PLATFORM due to historical
nonstandard A20M# handling. However that is no longer the case and so Elan can
be treated as part of the standard processor choice Kconfig option.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Link: http://lkml.kernel.org/r/1302245177.31620.47.camel@localhost.localdomain
Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/Kconfig                    |   11 -----------
 arch/x86/Kconfig.cpu                |   16 ++++++++++------
 arch/x86/Makefile_32.cpu            |    2 +-
 arch/x86/include/asm/module.h       |    2 +-
 arch/x86/kernel/cpu/cpufreq/Kconfig |    4 ++--
 5 files changed, 14 insertions(+), 21 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cc6c53a..f00a3f3 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -365,17 +365,6 @@ config X86_UV
 # Following is an alphabetically sorted list of 32 bit extended platforms
 # Please maintain the alphabetic order if and when there are additions
 
-config X86_ELAN
-	bool "AMD Elan"
-	depends on X86_32
-	depends on X86_EXTENDED_PLATFORM
-	---help---
-	  Select this for an AMD Elan processor.
-
-	  Do not use this option for K6/Athlon/Opteron processors!
-
-	  If unsure, choose "PC-compatible" instead.
-
 config X86_INTEL_CE
 	bool "CE4100 TV platform"
 	depends on PCI
diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index d161e93..6a7cfdf 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -1,6 +1,4 @@
 # Put here option for CPU selection and depending optimization
-if !X86_ELAN
-
 choice
 	prompt "Processor family"
 	default M686 if X86_32
@@ -203,6 +201,14 @@ config MWINCHIP3D
 	  stores for this CPU, which can increase performance of some
 	  operations.
 
+config MELAN
+	bool "AMD Elan"
+	depends on X86_32
+	---help---
+	  Select this for an AMD Elan processor.
+
+	  Do not use this option for K6/Athlon/Opteron processors!
+
 config MGEODEGX1
 	bool "GeodeGX1"
 	depends on X86_32
@@ -292,8 +298,6 @@ config X86_GENERIC
 	  This is really intended for distributors who need more
 	  generic optimizations.
 
-endif
-
 #
 # Define implied options from the CPU selection here
 config X86_INTERNODE_CACHE_SHIFT
@@ -312,7 +316,7 @@ config X86_L1_CACHE_SHIFT
 	int
 	default "7" if MPENTIUM4 || MPSC
 	default "6" if MK7 || MK8 || MPENTIUMM || MCORE2 || MATOM || MVIAC7 || X86_GENERIC || GENERIC_CPU
-	default "4" if X86_ELAN || M486 || M386 || MGEODEGX1
+	default "4" if MELAN || M486 || M386 || MGEODEGX1
 	default "5" if MWINCHIP3D || MWINCHIPC6 || MCRUSOE || MEFFICEON || MCYRIXIII || MK6 || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || M586 || MVIAC3_2 || MGEODE_LX
 
 config X86_XADD
@@ -358,7 +362,7 @@ config X86_POPAD_OK
 
 config X86_ALIGNMENT_16
 	def_bool y
-	depends on MWINCHIP3D || MWINCHIPC6 || MCYRIXIII || X86_ELAN || MK6 || M586MMX || M586TSC || M586 || M486 || MVIAC3_2 || MGEODEGX1
+	depends on MWINCHIP3D || MWINCHIPC6 || MCYRIXIII || MELAN || MK6 || M586MMX || M586TSC || M586 || M486 || MVIAC3_2 || MGEODEGX1
 
 config X86_INTEL_USERCOPY
 	def_bool y
diff --git a/arch/x86/Makefile_32.cpu b/arch/x86/Makefile_32.cpu
index f2ee1ab..86cee7b 100644
--- a/arch/x86/Makefile_32.cpu
+++ b/arch/x86/Makefile_32.cpu
@@ -37,7 +37,7 @@ cflags-$(CONFIG_MATOM)		+= $(call cc-option,-march=atom,$(call cc-option,-march=
 	$(call cc-option,-mtune=atom,$(call cc-option,-mtune=generic))
 
 # AMD Elan support
-cflags-$(CONFIG_X86_ELAN)	+= -march=i486
+cflags-$(CONFIG_MELAN)		+= -march=i486
 
 # Geode GX1 support
 cflags-$(CONFIG_MGEODEGX1)	+= -march=pentium-mmx
diff --git a/arch/x86/include/asm/module.h b/arch/x86/include/asm/module.h
index 67763c5..9eae775 100644
--- a/arch/x86/include/asm/module.h
+++ b/arch/x86/include/asm/module.h
@@ -35,7 +35,7 @@
 #define MODULE_PROC_FAMILY "K7 "
 #elif defined CONFIG_MK8
 #define MODULE_PROC_FAMILY "K8 "
-#elif defined CONFIG_X86_ELAN
+#elif defined CONFIG_MELAN
 #define MODULE_PROC_FAMILY "ELAN "
 #elif defined CONFIG_MCRUSOE
 #define MODULE_PROC_FAMILY "CRUSOE "
diff --git a/arch/x86/kernel/cpu/cpufreq/Kconfig b/arch/x86/kernel/cpu/cpufreq/Kconfig
index 870e6cc..0ab9b22 100644
--- a/arch/x86/kernel/cpu/cpufreq/Kconfig
+++ b/arch/x86/kernel/cpu/cpufreq/Kconfig
@@ -43,7 +43,7 @@ config X86_ACPI_CPUFREQ
 config ELAN_CPUFREQ
 	tristate "AMD Elan SC400 and SC410"
 	select CPU_FREQ_TABLE
-	depends on X86_ELAN
+	depends on MELAN
 	---help---
 	  This adds the CPUFreq driver for AMD Elan SC400 and SC410
 	  processors.
@@ -59,7 +59,7 @@ config ELAN_CPUFREQ
 config SC520_CPUFREQ
 	tristate "AMD Elan SC520"
 	select CPU_FREQ_TABLE
-	depends on X86_ELAN
+	depends on MELAN
 	---help---
 	  This adds the CPUFreq driver for AMD Elan SC520 processor.
 
