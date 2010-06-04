Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366Ab0FDDWq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 23:22:46 -0400
Received: from vms173007pub.verizon.net ([206.46.173.7]:64097 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167Ab0FDDWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 23:22:44 -0400
Date: Thu, 03 Jun 2010 23:22:28 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: H Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Dave Jones <davej@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Venkatesh Pallipadi <venki@google.com>
Subject: [PATCH] x86: Look for IA32_ENERGY_PERF_BIAS support - v3
In-reply-to: <20100304231547.654246000@intel.com>
Message-id: <alpine.LFD.2.00.1006032310160.6669@localhost.localdomain>
References: <20100304231454.247805000@intel.com>
 <20100304231547.654246000@intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:  Venkatesh Pallipadi <venki@google.com>

The new IA32_ENERGY_PERF_BIAS MSR allows system software to give
hardware a hint whether OS policy favors more power saving,
or more performance.  This allows the OS to have some influence
on internal hardware power/performance tradeoffs where the OS
has previously had no influence.

The support for this feature is indicated by CPUID.06H.ECX.bit3,
as documented in the Intel Architectures Software Developer's Manual.

This patch discovers support of this feature and displays it
as "epb" in /proc/cpuinfo.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
lenb: v3 refreshes venki's original patch to apply to 2.6.35-rc1

 arch/x86/include/asm/cpufeature.h          |    1 +
 arch/x86/include/asm/msr-index.h           |    2 ++
 arch/x86/kernel/cpu/addon_cpuid_features.c |    1 +
 3 files changed, 4 insertions(+), 0 deletions(-)

Index: linus/arch/x86/include/asm/cpufeature.h
===================================================================
--- linus.orig/arch/x86/include/asm/cpufeature.h
+++ linus/arch/x86/include/asm/cpufeature.h
@@ -162,6 +162,7 @@
 #define X86_FEATURE_IDA		(7*32+ 0) /* Intel Dynamic Acceleration */
 #define X86_FEATURE_ARAT	(7*32+ 1) /* Always Running APIC Timer */
 #define X86_FEATURE_CPB		(7*32+ 2) /* AMD Core Performance Boost */
+#define X86_FEATURE_EPB		(7*32+ 3) /* IA32_ENERGY_PERF_BIAS support */
 
 /* Virtualization flags: Linux defined */
 #define X86_FEATURE_TPR_SHADOW  (8*32+ 0) /* Intel TPR Shadow */
Index: linus/arch/x86/include/asm/msr-index.h
===================================================================
--- linus.orig/arch/x86/include/asm/msr-index.h
+++ linus/arch/x86/include/asm/msr-index.h
@@ -238,6 +238,8 @@
 
 #define MSR_IA32_TEMPERATURE_TARGET	0x000001a2
 
+#define MSR_IA32_ENERGY_PERF_BIAS	0x000001b0
+
 /* MISC_ENABLE bits: architectural */
 #define MSR_IA32_MISC_ENABLE_FAST_STRING	(1ULL << 0)
 #define MSR_IA32_MISC_ENABLE_TCC		(1ULL << 1)
Index: linus/arch/x86/kernel/cpu/addon_cpuid_features.c
===================================================================
--- linus.orig/arch/x86/kernel/cpu/addon_cpuid_features.c
+++ linus/arch/x86/kernel/cpu/addon_cpuid_features.c
@@ -33,6 +33,7 @@ void __cpuinit init_scattered_cpuid_feat
 		{ X86_FEATURE_IDA,   		CR_EAX, 1, 0x00000006 },
 		{ X86_FEATURE_ARAT,  		CR_EAX, 2, 0x00000006 },
 		{ X86_FEATURE_APERFMPERF,	CR_ECX, 0, 0x00000006 },
+		{ X86_FEATURE_EPB,		CR_ECX, 3, 0x00000006 },
 		{ X86_FEATURE_CPB,   		CR_EDX, 9, 0x80000007 },
 		{ X86_FEATURE_NPT,   		CR_EDX, 0, 0x8000000a },
 		{ X86_FEATURE_LBRV,  		CR_EDX, 1, 0x8000000a },

