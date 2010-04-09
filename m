Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708Ab0DIWTU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 18:19:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:32904 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223Ab0DIWTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 18:19:16 -0400
Date: Fri, 9 Apr 2010 22:18:50 GMT
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       trenn@suse.de, tglx@linutronix.de, borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, trenn@suse.de, borislav.petkov@amd.com
In-Reply-To: <1270065406-1814-2-git-send-email-bp@amd64.org>
References: <1270065406-1814-2-git-send-email-bp@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, cpu: Add AMD core boosting feature flag to /proc/cpuinfo
Message-ID: <tip-5958f1d5d722df7a9e5d129676614a8e5219bacd@git.kernel.org>
Git-Commit-ID: 5958f1d5d722df7a9e5d129676614a8e5219bacd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 09 Apr 2010 22:18:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5958f1d5d722df7a9e5d129676614a8e5219bacd
Gitweb:     http://git.kernel.org/tip/5958f1d5d722df7a9e5d129676614a8e5219bacd
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Wed, 31 Mar 2010 21:56:41 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 9 Apr 2010 14:05:23 -0700

x86, cpu: Add AMD core boosting feature flag to /proc/cpuinfo

By semi-popular demand, this adds the Core Performance Boost feature
flag to /proc/cpuinfo. Possible use case for this is userspace tools
like cpufreq-aperf, for example, so that they don't have to jump through
hoops of accessing "/dev/cpu/%d/cpuid" in order to check for CPB hw
support, or call cpuid from userspace.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
LKML-Reference: <1270065406-1814-2-git-send-email-bp@amd64.org>
Reviewed-by: Thomas Renninger <trenn@suse.de>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
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
