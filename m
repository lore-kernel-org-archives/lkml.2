Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab0G1O3b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 10:29:31 -0400
Received: from vms173009pub.verizon.net ([206.46.173.9]:56264 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754479Ab0G1O31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 10:29:27 -0400
Date: Wed, 28 Jul 2010 00:35:32 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: x86@kernel.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org, venki@google.com
Subject: [PATCH 1/2] [PATCH] x86: Look for TSC Deadline Timer
Message-id: <alpine.LFD.2.00.1007280033370.28038@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

The new TSC Deadline Timer offers system software a low overhead
per-logical-thread deadline timer in TSC units.

The timer is implemented via a new architectural 64-bit register,
IA32_TSC_DEADLINE_MSR. Reads and writes of this MSR occur in program
order, but are non-serializing.

The support for this feature is indicated by CPUID.01H:ECX.TSC_Deadline[bit 24] = 1
as documented in the Intel Architectures Software Developer's Manual.

This patch discovers support of this feature and displays it
as "tdt" in /proc/cpuinfo, and enumeratese the new
IA32_TSC_DEADLINE_MSR in kernel headers.

Signed-off-by: Len Brown <len.brown@intel.com>
---
 arch/x86/include/asm/cpufeature.h |    1 +
 arch/x86/include/asm/msr-index.h  |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 4681459..b2a47e6 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -120,6 +120,7 @@
 #define X86_FEATURE_X2APIC	(4*32+21) /* x2APIC */
 #define X86_FEATURE_MOVBE	(4*32+22) /* MOVBE instruction */
 #define X86_FEATURE_POPCNT      (4*32+23) /* POPCNT instruction */
+#define X86_FEATURE_TSC_DEADLINE      (4*32+24) /* "tdt" TSC Deadline Timer */
 #define X86_FEATURE_AES		(4*32+25) /* AES instructions */
 #define X86_FEATURE_XSAVE	(4*32+26) /* XSAVE/XRSTOR/XSETBV/XGETBV */
 #define X86_FEATURE_OSXSAVE	(4*32+27) /* "" XSAVE enabled in the OS */
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 8c7ae43..78d0d5b 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -268,6 +268,8 @@
 #define MSR_IA32_MISC_ENABLE_TURBO_DISABLE	(1ULL << 38)
 #define MSR_IA32_MISC_ENABLE_IP_PREF_DISABLE	(1ULL << 39)
 
+#define MSR_IA32_TSC_DEADLINE		0x000006E0
+
 /* P4/Xeon+ specific */
 #define MSR_IA32_MCG_EAX		0x00000180
 #define MSR_IA32_MCG_EBX		0x00000181
-- 
1.7.2

