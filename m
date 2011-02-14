Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab1BNSJD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 13:09:03 -0500
Received: from hera.kernel.org ([140.211.167.34]:45613 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752521Ab1BNSHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 13:07:23 -0500
Date: Mon, 14 Feb 2011 13:51:55 GMT
From: tip-bot for Borislav Petkov <bp@amd64.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, bp@amd64.org, mingo@elte.hu,
        borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bp@amd64.org, borislav.petkov@amd.com,
        mingo@elte.hu
In-Reply-To: <20110211171754.GA21047@aftab>
References: <20110211171754.GA21047@aftab>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Fix mwait_usable section mismatch
Message-ID: <tip-1c9d16e35911090dee3f9313e6af13af623d66ee@git.kernel.org>
Git-Commit-ID: 1c9d16e35911090dee3f9313e6af13af623d66ee
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 14 Feb 2011 18:06:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1c9d16e35911090dee3f9313e6af13af623d66ee
Gitweb:     http://git.kernel.org/tip/1c9d16e35911090dee3f9313e6af13af623d66ee
Author:     Borislav Petkov <bp@amd64.org>
AuthorDate: Fri, 11 Feb 2011 18:17:54 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 14 Feb 2011 12:08:28 +0100

x86: Fix mwait_usable section mismatch

We use it in non __cpuinit code now too so drop marker.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
LKML-Reference: <20110211171754.GA21047@aftab>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/cpu.h |    2 +-
 arch/x86/kernel/process.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index 6e6e755..4564c8e 100644
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -32,6 +32,6 @@ extern void arch_unregister_cpu(int);
 
 DECLARE_PER_CPU(int, cpu_state);
 
-int __cpuinit mwait_usable(const struct cpuinfo_x86 *);
+int mwait_usable(const struct cpuinfo_x86 *);
 
 #endif /* _ASM_X86_CPU_H */
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index e764fc0..3c189e9 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -506,7 +506,7 @@ static void poll_idle(void)
 #define MWAIT_ECX_EXTENDED_INFO		0x01
 #define MWAIT_EDX_C1			0xf0
 
-int __cpuinit mwait_usable(const struct cpuinfo_x86 *c)
+int mwait_usable(const struct cpuinfo_x86 *c)
 {
 	u32 eax, ebx, ecx, edx;
 
