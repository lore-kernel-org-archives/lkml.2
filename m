Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179Ab0CaT4I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 15:56:08 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:41151 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756203Ab0CaT4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 15:56:05 -0400
From: Borislav Petkov <bp@amd64.org>
To: <hpa@zytor.com>, <mingo@elte.hu>, <tglx@linutronix.de>,
       <akpm@linux-foundation.org>
Cc: davej@redhat.com, trenn@suse.de, linux@dominikbrodowski.net,
       cpufreq@vger.kernel.org, <linux-kernel@vger.kernel.org>,
       <x86@kernel.org>
Subject: [PATCH 1/6] x86, cpu: Add AMD core boosting feature flag to /proc/cpuinfo
Date: Wed, 31 Mar 2010 21:56:41 +0200
Message-Id: <1270065406-1814-2-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1270065406-1814-1-git-send-email-bp@amd64.org>
References: <1270065406-1814-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

By semi-popular demand, this adds the Core Performance Boost feature
flag to /proc/cpuinfo. Possible use case for this is userspace tools
like cpufreq-aperf, for example, so that they don't have to jump through
hoops of accessing "/dev/cpu/%d/cpuid" in order to check for CPB hw
support, or call cpuid from userspace.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Reviewed-by: Thomas Renninger <trenn@suse.de>
---
 arch/x86/include/asm/cpufeature.h          |    1 +
 arch/x86/kernel/cpu/addon_cpuid_features.c |    5 +++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 0cd82d0..630e623 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -161,6 +161,7 @@
  */
 #define X86_FEATURE_IDA		(7*32+ 0) /* Intel Dynamic Acceleration */
 #define X86_FEATURE_ARAT	(7*32+ 1) /* Always Running APIC Timer */
+#define X86_FEATURE_CPB		(7*32+ 2) /* AMD Core Performance Boost */
 
 /* Virtualization flags: Linux defined */
 #define X86_FEATURE_TPR_SHADOW  (8*32+ 0) /* Intel TPR Shadow */
diff --git a/arch/x86/kernel/cpu/addon_cpuid_features.c b/arch/x86/kernel/cpu/addon_cpuid_features.c
index 97ad79c..ead2a1c 100644
--- a/arch/x86/kernel/cpu/addon_cpuid_features.c
+++ b/arch/x86/kernel/cpu/addon_cpuid_features.c
@@ -30,8 +30,9 @@ void __cpuinit init_scattered_cpuid_features(struct cpuinfo_x86 *c)
 	const struct cpuid_bit *cb;
 
 	static const struct cpuid_bit __cpuinitconst cpuid_bits[] = {
-		{ X86_FEATURE_IDA, CR_EAX, 1, 0x00000006 },
-		{ X86_FEATURE_ARAT, CR_EAX, 2, 0x00000006 },
+		{ X86_FEATURE_IDA,   CR_EAX, 1, 0x00000006 },
+		{ X86_FEATURE_ARAT,  CR_EAX, 2, 0x00000006 },
+		{ X86_FEATURE_CPB,   CR_EDX, 9, 0x80000007 },
 		{ X86_FEATURE_NPT,   CR_EDX, 0, 0x8000000a },
 		{ X86_FEATURE_LBRV,  CR_EDX, 1, 0x8000000a },
 		{ X86_FEATURE_SVML,  CR_EDX, 2, 0x8000000a },
-- 
1.7.0

