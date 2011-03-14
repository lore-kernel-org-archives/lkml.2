Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab1CNUQ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 16:16:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:57887 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320Ab1CNUQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 16:16:57 -0400
Date: Mon, 14 Mar 2011 20:16:11 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, darren@dvhart.com, tglx@linutronix.de,
        walken@google.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, darren@dvhart.com, tglx@linutronix.de,
        walken@google.com
In-Reply-To: <alpine.LFD.2.00.1103141126590.2787@localhost6.localdomain6>
References: <alpine.LFD.2.00.1103141126590.2787@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/futexes] arm: Remove bogus comment in futex_atomic_cmpxchg_inatomic()
Message-ID: <tip-07d5ecae2940ddd77746e2fb597dcf57d3c2e277@git.kernel.org>
Git-Commit-ID: 07d5ecae2940ddd77746e2fb597dcf57d3c2e277
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 14 Mar 2011 20:16:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  07d5ecae2940ddd77746e2fb597dcf57d3c2e277
Gitweb:     http://git.kernel.org/tip/07d5ecae2940ddd77746e2fb597dcf57d3c2e277
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Mon, 14 Mar 2011 20:00:30 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 14 Mar 2011 21:10:26 +0100

arm: Remove bogus comment in futex_atomic_cmpxchg_inatomic()

commit 522d7dec(futex: Remove redundant pagefault_disable in
futex_atomic_cmpxchg_inatomic()) added a bogus comment.

/* Note that preemption is disabled by futex_atomic_cmpxchg_inatomic
 * call sites. */

Bogus in two aspects:

1) pagefault_disable != preempt_disable even if the mechanism we use
   is the same

2) we have a call site which deliberately does not disable pagefaults
   as it wants the possible fault to be handled - though that has been
   changed for consistency reasons now.

Sigh. I really should have seen that when committing the above. :(

Catched-by-and-rightfully-ranted-at-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <alpine.LFD.2.00.1103141126590.2787@localhost6.localdomain6>
Cc: Michel Lespinasse <walken@google.com>
Cc: Darren Hart <darren@dvhart.com>
---
 arch/arm/include/asm/futex.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/arm/include/asm/futex.h b/arch/arm/include/asm/futex.h
index 0e29d8e..199a6b6 100644
--- a/arch/arm/include/asm/futex.h
+++ b/arch/arm/include/asm/futex.h
@@ -97,9 +97,6 @@ futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
 	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
 		return -EFAULT;
 
-	/* Note that preemption is disabled by futex_atomic_cmpxchg_inatomic
-	 * call sites. */
-
 	__asm__ __volatile__("@futex_atomic_cmpxchg_inatomic\n"
 	"1:	" T(ldr) "	%1, [%4]\n"
 	"	teq	%1, %2\n"
