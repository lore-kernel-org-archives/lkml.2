Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab0FRWQO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 18:16:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:52384 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753948Ab0FRWQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 18:16:12 -0400
Date: Fri, 18 Jun 2010 22:15:44 GMT
From: tip-bot for Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       andi@firstfloor.org, stable@kernel.org, ak@linux.intel.com,
       tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, stable@kernel.org, ak@linux.intel.com,
       tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20100618210859.GA10913@basil.fritz.box>
References: <20100618210859.GA10913@basil.fritz.box>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Fix vsyscall on gcc 4.5 with -Os
Message-ID: <tip-124482935fb7fb9303c8a8ab930149c6a93d9910@git.kernel.org>
Git-Commit-ID: 124482935fb7fb9303c8a8ab930149c6a93d9910
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 18 Jun 2010 22:15:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  124482935fb7fb9303c8a8ab930149c6a93d9910
Gitweb:     http://git.kernel.org/tip/124482935fb7fb9303c8a8ab930149c6a93d9910
Author:     Andi Kleen <andi@firstfloor.org>
AuthorDate: Fri, 18 Jun 2010 23:09:00 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 18 Jun 2010 14:16:31 -0700

x86: Fix vsyscall on gcc 4.5 with -Os

This fixes the -Os breaks with gcc 4.5 bug.  rdtsc_barrier needs to be
force inlined, otherwise user space will jump into kernel space and
kill init.

This also addresses http://gcc.gnu.org/bugzilla/show_bug.cgi?id=44129
I believe.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
LKML-Reference: <20100618210859.GA10913@basil.fritz.box>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: <stable@kernel.org>
---
 arch/x86/include/asm/system.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/system.h b/arch/x86/include/asm/system.h
index b8fe48e..e7f4d33 100644
--- a/arch/x86/include/asm/system.h
+++ b/arch/x86/include/asm/system.h
@@ -451,7 +451,7 @@ void stop_this_cpu(void *dummy);
  *
  * (Could use an alternative three way for this if there was one.)
  */
-static inline void rdtsc_barrier(void)
+static __always_inline void rdtsc_barrier(void)
 {
 	alternative(ASM_NOP3, "mfence", X86_FEATURE_MFENCE_RDTSC);
 	alternative(ASM_NOP3, "lfence", X86_FEATURE_LFENCE_RDTSC);
