Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759737Ab1LOXZd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 18:25:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43783 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891Ab1LOXZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 18:25:32 -0500
Date: Thu, 15 Dec 2011 15:25:21 -0800
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-83d99df7c4bf37176d8c7b199e3b129a51fa04c8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        shemminger@vyatta.com, dhowells@redhat.com, heukelum@mailshack.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dhowells@redhat.com, heukelum@mailshack.com, shemminger@vyatta.com,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <4EEA77E1.6050009@zytor.com>
References: <4EEA77E1.6050009@zytor.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86, bitops: Move fls64.h inside __KERNEL__
Git-Commit-ID: 83d99df7c4bf37176d8c7b199e3b129a51fa04c8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 15 Dec 2011 15:25:27 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  83d99df7c4bf37176d8c7b199e3b129a51fa04c8
Gitweb:     http://git.kernel.org/tip/83d99df7c4bf37176d8c7b199e3b129a51fa04c8
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Thu, 15 Dec 2011 14:55:53 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 15 Dec 2011 15:04:07 -0800

x86, bitops: Move fls64.h inside __KERNEL__

We would include <asm-generic/bitops/fls64.h> even without __KERNEL__,
but that doesn't make sense, as:

1. That file provides fls64(), but the corresponding function fls() is
   not exported to user space.
2. The implementation of fls64.h uses kernel-only symbols.
3. fls64.h is not exported to user space.

This appears to have been a bug introduced in checkin:

d57594c203b1 bitops: use __fls for fls64 on 64-bit archs

Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Alexander van Heukelum <heukelum@mailshack.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Link: http://lkml.kernel.org/r/4EEA77E1.6050009@zytor.com
---
 arch/x86/include/asm/bitops.h |   11 ++---------
 1 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
index 1775d6e..4a6235b 100644
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -380,6 +380,8 @@ static inline unsigned long __fls(unsigned long word)
 	return word;
 }
 
+#undef ADDR
+
 #ifdef __KERNEL__
 /**
  * ffs - find first set bit in word
@@ -434,11 +436,6 @@ static inline int fls(int x)
 #endif
 	return r + 1;
 }
-#endif /* __KERNEL__ */
-
-#undef ADDR
-
-#ifdef __KERNEL__
 
 #include <asm-generic/bitops/find.h>
 
@@ -450,12 +447,8 @@ static inline int fls(int x)
 
 #include <asm-generic/bitops/const_hweight.h>
 
-#endif /* __KERNEL__ */
-
 #include <asm-generic/bitops/fls64.h>
 
-#ifdef __KERNEL__
-
 #include <asm-generic/bitops/le.h>
 
 #include <asm-generic/bitops/ext2-atomic-setbit.h>
