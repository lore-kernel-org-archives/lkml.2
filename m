Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309Ab1GVT4r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 15:56:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:38139 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755134Ab1GVT4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 15:56:46 -0400
Date: Fri, 22 Jul 2011 19:56:38 GMT
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-26056c822f9428ddc95fd7ac3008bbb0032d1086@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com,
        jeremy.fitzhardinge@citrix.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com,
        jeremy.fitzhardinge@citrix.com
In-Reply-To: <4E050704.3070409@zytor.com>
References: <4E050704.3070409@zytor.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/spinlocks] x86, ticketlock: Use asm volatile for __ticket_unlock_release()
Git-Commit-ID: 26056c822f9428ddc95fd7ac3008bbb0032d1086
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 22 Jul 2011 19:56:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  26056c822f9428ddc95fd7ac3008bbb0032d1086
Gitweb:     http://git.kernel.org/tip/26056c822f9428ddc95fd7ac3008bbb0032d1086
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Fri, 22 Jul 2011 11:15:20 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 22 Jul 2011 11:15:20 -0700

x86, ticketlock: Use asm volatile for __ticket_unlock_release()

__ticket_uplock_release() really should have barrier semantics, so use
"asm volatile" there.

Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Link: http://lkml.kernel.org/r/4E050704.3070409@zytor.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/spinlock.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 704b0c3..f8d51dc 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -36,11 +36,11 @@
 static __always_inline void __ticket_unlock_release(struct arch_spinlock *lock)
 {
 	if (sizeof(lock->tickets.head) == sizeof(u8))
-		asm (LOCK_PREFIX "incb %0"
-		     : "+m" (lock->tickets.head) : : "memory");
+		asm volatile(LOCK_PREFIX "incb %0"
+			     : "+m" (lock->tickets.head) : : "memory");
 	else
-		asm (LOCK_PREFIX "incw %0"
-		     : "+m" (lock->tickets.head) : : "memory");
+		asm volatile(LOCK_PREFIX "incw %0"
+			     : "+m" (lock->tickets.head) : : "memory");
 
 }
 #else
