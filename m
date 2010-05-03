Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933455Ab0ECXWK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 19:22:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:53127 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932245Ab0ECXWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 19:22:01 -0400
Date: Mon, 3 May 2010 23:21:41 GMT
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       trenn@suse.de, tglx@linutronix.de, borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, trenn@suse.de, borislav.petkov@amd.com
In-Reply-To: <1270065406-1814-4-git-send-email-bp@amd64.org>
References: <1270065406-1814-4-git-send-email-bp@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, cpu: Make APERF/MPERF a normal table-driven flag
Message-ID: <tip-097c1bd5673edaf2a162724636858b71f658fdd2@git.kernel.org>
Git-Commit-ID: 097c1bd5673edaf2a162724636858b71f658fdd2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 03 May 2010 23:21:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  097c1bd5673edaf2a162724636858b71f658fdd2
Gitweb:     http://git.kernel.org/tip/097c1bd5673edaf2a162724636858b71f658fdd2
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Mon, 3 May 2010 15:49:31 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 3 May 2010 15:49:31 -0700

x86, cpu: Make APERF/MPERF a normal table-driven flag

APERF/MPERF can be handled via the table like all the other scattered
CPU flags.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Borislav Petkov <borislav.petkov@amd.com>
LKML-Reference: <1270065406-1814-4-git-send-email-bp@amd64.org>
---
 arch/x86/kernel/cpu/addon_cpuid_features.c |   23 ++++++++---------------
 1 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/cpu/addon_cpuid_features.c b/arch/x86/kernel/cpu/addon_cpuid_features.c
index fd1fc19..10fa568 100644
--- a/arch/x86/kernel/cpu/addon_cpuid_features.c
+++ b/arch/x86/kernel/cpu/addon_cpuid_features.c
@@ -30,13 +30,14 @@ void __cpuinit init_scattered_cpuid_features(struct cpuinfo_x86 *c)
 	const struct cpuid_bit *cb;
 
 	static const struct cpuid_bit __cpuinitconst cpuid_bits[] = {
-		{ X86_FEATURE_IDA,   CR_EAX, 1, 0x00000006 },
-		{ X86_FEATURE_ARAT,  CR_EAX, 2, 0x00000006 },
-		{ X86_FEATURE_CPB,   CR_EDX, 9, 0x80000007 },
-		{ X86_FEATURE_NPT,   CR_EDX, 0, 0x8000000a },
-		{ X86_FEATURE_LBRV,  CR_EDX, 1, 0x8000000a },
-		{ X86_FEATURE_SVML,  CR_EDX, 2, 0x8000000a },
-		{ X86_FEATURE_NRIPS, CR_EDX, 3, 0x8000000a },
+		{ X86_FEATURE_IDA,   		CR_EAX, 1, 0x00000006 },
+		{ X86_FEATURE_ARAT,  		CR_EAX, 2, 0x00000006 },
+		{ X86_FEATURE_APERFMPERF,	CR_ECX, 0, 0x00000006 },
+		{ X86_FEATURE_CPB,   		CR_EDX, 9, 0x80000007 },
+		{ X86_FEATURE_NPT,   		CR_EDX, 0, 0x8000000a },
+		{ X86_FEATURE_LBRV,  		CR_EDX, 1, 0x8000000a },
+		{ X86_FEATURE_SVML,  		CR_EDX, 2, 0x8000000a },
+		{ X86_FEATURE_NRIPS, 		CR_EDX, 3, 0x8000000a },
 		{ 0, 0, 0, 0 }
 	};
 
@@ -54,14 +55,6 @@ void __cpuinit init_scattered_cpuid_features(struct cpuinfo_x86 *c)
 		if (regs[cb->reg] & (1 << cb->bit))
 			set_cpu_cap(c, cb->feature);
 	}
-
-	/*
-	 * common AMD/Intel features
-	 */
-	if (c->cpuid_level >= 6) {
-		if (cpuid_ecx(6) & 0x1)
-			set_cpu_cap(c, X86_FEATURE_APERFMPERF);
-	}
 }
 
 /* leaf 0xb SMT level */
