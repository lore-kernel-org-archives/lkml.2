Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073Ab0IHV3Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 17:29:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:54377 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755995Ab0IHV3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 17:29:07 -0400
Date: Wed, 8 Sep 2010 21:28:49 GMT
From: tip-bot for Andre Przywara <andre.przywara@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        andre.przywara@amd.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andre.przywara@amd.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1283778860-26843-5-git-send-email-andre.przywara@amd.com>
References: <1283778860-26843-5-git-send-email-andre.przywara@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, kvm: add new AMD SVM feature bits
Message-ID: <tip-aeb9c7d618264dcf6eea39142fefee096c3b09e2@git.kernel.org>
Git-Commit-ID: aeb9c7d618264dcf6eea39142fefee096c3b09e2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 08 Sep 2010 21:28:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  aeb9c7d618264dcf6eea39142fefee096c3b09e2
Gitweb:     http://git.kernel.org/tip/aeb9c7d618264dcf6eea39142fefee096c3b09e2
Author:     Andre Przywara <andre.przywara@amd.com>
AuthorDate: Mon, 6 Sep 2010 15:14:20 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 8 Sep 2010 13:34:15 -0700

x86, kvm: add new AMD SVM feature bits

The recently updated CPUID specification names new SVM feature bits.
Add them to the list of reported features.

Signed-off-by: Andre Przywara <andre.przywara@amd,com>
LKML-Reference: <1283778860-26843-5-git-send-email-andre.przywara@amd.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/cpufeature.h |    7 +++++++
 arch/x86/kernel/cpu/scattered.c   |    6 ++++++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 341835df..bffeab7 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -183,6 +183,13 @@
 #define X86_FEATURE_LBRV	(8*32+ 6) /* AMD LBR Virtualization support */
 #define X86_FEATURE_SVML	(8*32+ 7) /* "svm_lock" AMD SVM locking MSR */
 #define X86_FEATURE_NRIPS	(8*32+ 8) /* "nrip_save" AMD SVM next_rip save */
+#define X86_FEATURE_TSCRATEMSR  (8*32+ 9) /* "tsc_scale" AMD TSC scaling support */
+#define X86_FEATURE_VMCBCLEAN   (8*32+10) /* "vmcb_clean" AMD VMCB clean bits support */
+#define X86_FEATURE_FLUSHBYASID (8*32+11) /* AMD flush-by-ASID support */
+#define X86_FEATURE_DECODEASSISTS (8*32+12) /* AMD Decode Assists support */
+#define X86_FEATURE_PAUSEFILTER (8*32+13) /* AMD filtered pause intercept */
+#define X86_FEATURE_PFTHRESHOLD (8*32+14) /* AMD pause filter threshold */
+
 
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (ebx), word 9 */
 #define X86_FEATURE_FSGSBASE	(9*32+ 0) /* {RD/WR}{FS/GS}BASE instructions*/
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index 34b4dad..2c77931 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -43,6 +43,12 @@ void __cpuinit init_scattered_cpuid_features(struct cpuinfo_x86 *c)
 		{ X86_FEATURE_LBRV,		CR_EDX, 1, 0x8000000a, 0 },
 		{ X86_FEATURE_SVML,		CR_EDX, 2, 0x8000000a, 0 },
 		{ X86_FEATURE_NRIPS,		CR_EDX, 3, 0x8000000a, 0 },
+		{ X86_FEATURE_TSCRATEMSR,	CR_EDX, 4, 0x8000000a, 0 },
+		{ X86_FEATURE_VMCBCLEAN,	CR_EDX, 5, 0x8000000a, 0 },
+		{ X86_FEATURE_FLUSHBYASID,	CR_EDX, 6, 0x8000000a, 0 },
+		{ X86_FEATURE_DECODEASSISTS,	CR_EDX, 7, 0x8000000a, 0 },
+		{ X86_FEATURE_PAUSEFILTER,	CR_EDX,10, 0x8000000a, 0 },
+		{ X86_FEATURE_PFTHRESHOLD,	CR_EDX,12, 0x8000000a, 0 },
 		{ 0, 0, 0, 0, 0 }
 	};
 
