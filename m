Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab1DSBBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 21:01:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:55119 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752884Ab1DSBBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 21:01:14 -0400
Date: Tue, 19 Apr 2011 01:01:03 GMT
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-b1e7734f024c9ce4393016a97c8d821e1f18d9b4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tj@kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
        cl@linux-foundation.org
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tj@kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
        cl@linux-foundation.org
In-Reply-To: <1303166160-10315-2-git-send-email-hpa@linux.intel.com>
References: <1303166160-10315-2-git-send-email-hpa@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, percpu: Use ASM_NOP4 instead of hardcoding P6_NOP4
Git-Commit-ID: b1e7734f024c9ce4393016a97c8d821e1f18d9b4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 19 Apr 2011 01:01:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b1e7734f024c9ce4393016a97c8d821e1f18d9b4
Gitweb:     http://git.kernel.org/tip/b1e7734f024c9ce4393016a97c8d821e1f18d9b4
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Mon, 18 Apr 2011 15:18:02 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 18 Apr 2011 16:40:06 -0700

x86, percpu: Use ASM_NOP4 instead of hardcoding P6_NOP4

For use in assembly constants, use the ASM_NOP* defines.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>
Link: http://lkml.kernel.org/r/1303166160-10315-2-git-send-email-hpa@linux.intel.com
---
 arch/x86/include/asm/percpu.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index d475b43..751e7f3 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -517,7 +517,7 @@ do {									\
 	typeof(o2) __o2 = o2;						\
 	typeof(o2) __n2 = n2;						\
 	typeof(o2) __dummy;						\
-	alternative_io("call this_cpu_cmpxchg16b_emu\n\t" P6_NOP4,	\
+	alternative_io("call this_cpu_cmpxchg16b_emu\n\t" ASM_NOP4,	\
 		       "cmpxchg16b " __percpu_prefix "(%%rsi)\n\tsetz %0\n\t",	\
 		       X86_FEATURE_CX16,				\
 		       ASM_OUTPUT2("=a"(__ret), "=d"(__dummy)),		\
