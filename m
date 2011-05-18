Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751019Ab1EREB0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 00:01:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:51736 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721Ab1EREBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 00:01:25 -0400
Date: Wed, 18 May 2011 04:01:18 GMT
From: tip-bot for Fenghua Yu <fenghua.yu@intel.com>
Message-ID: <tip-d0281a257f370b09c410e466571858b4e12869c9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1305683069-25394-2-git-send-email-fenghua.yu@intel.com>
References: <1305683069-25394-2-git-send-email-fenghua.yu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpufeature] x86, cpufeature: Add cpufeature flag for SMEP
Git-Commit-ID: d0281a257f370b09c410e466571858b4e12869c9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 18 May 2011 04:01:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d0281a257f370b09c410e466571858b4e12869c9
Gitweb:     http://git.kernel.org/tip/d0281a257f370b09c410e466571858b4e12869c9
Author:     Fenghua Yu <fenghua.yu@intel.com>
AuthorDate: Tue, 17 May 2011 18:44:26 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 17 May 2011 20:56:59 -0700

x86, cpufeature: Add cpufeature flag for SMEP

Add support for newly documented SMEP (Supervisor Mode Execution Protection) CPU
feature flag.

SMEP prevents the CPU in kernel-mode to jump to an executable page
that has the user flag set in the PTE.  This prevents the kernel from
executing user-space code accidentally or maliciously, so it for
example prevents kernel exploits from jumping to specially prepared
user-mode shell code.

[ hpa: added better description by Ingo Molnar ]

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
LKML-Reference: <1305683069-25394-2-git-send-email-fenghua.yu@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/cpufeature.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 7f2f7b1..8808cdb 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -195,6 +195,7 @@
 
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (ebx), word 9 */
 #define X86_FEATURE_FSGSBASE	(9*32+ 0) /* {RD/WR}{FS/GS}BASE instructions*/
+#define X86_FEATURE_SMEP	(9*32+ 7) /* Supervisor Mode Execution Protection */
 #define X86_FEATURE_ERMS	(9*32+ 9) /* Enhanced REP MOVSB/STOSB */
 
 #if defined(__KERNEL__) && !defined(__ASSEMBLY__)
