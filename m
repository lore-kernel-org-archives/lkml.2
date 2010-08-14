Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944Ab0HNAj4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 20:39:56 -0400
Received: from king.tilera.com ([72.1.168.226]:19587 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752008Ab0HNAj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 20:39:56 -0400
Message-Id: <201008140039.o7E0dqTq005996@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 13 Aug 2010 20:32:41 -0400
Subject: [PATCH] arch/tile: Rename the hweight() implementations to __arch_hweight().
To: Borislav Petkov <petkovbb@googlemail.com>,
        Mike Frysinger <vapier.adi@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <AANLkTikvJna6vnc73RVhVAJZ8mERJoFk=V6Nwq-3HHWz@mail.gmail.com>
X-OriginalArrivalTime: 14 Aug 2010 00:39:55.0208 (UTC) FILETIME=[37077C80:01CB3B49]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

See commit 1527bc8b928dd1399c3d3467dd47d9ede210978a.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---

Mike, thanks for the pointer to the hweight issue.  Since we are using
__builtin_popcount() and the compiler can do constant propagation, etc.,
with it at compile-time, this is less critical, but it seems like the
easiest way to get the definitions of the HWEIGHT macros.

 arch/tile/include/asm/bitops.h |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/tile/include/asm/bitops.h b/arch/tile/include/asm/bitops.h
index 84600f3..6832b4b 100644
--- a/arch/tile/include/asm/bitops.h
+++ b/arch/tile/include/asm/bitops.h
@@ -98,26 +98,27 @@ static inline int fls64(__u64 w)
 	return (sizeof(__u64) * 8) - __builtin_clzll(w);
 }
 
-static inline unsigned int hweight32(unsigned int w)
+static inline unsigned int __arch_hweight32(unsigned int w)
 {
 	return __builtin_popcount(w);
 }
 
-static inline unsigned int hweight16(unsigned int w)
+static inline unsigned int __arch_hweight16(unsigned int w)
 {
 	return __builtin_popcount(w & 0xffff);
 }
 
-static inline unsigned int hweight8(unsigned int w)
+static inline unsigned int __arch_hweight8(unsigned int w)
 {
 	return __builtin_popcount(w & 0xff);
 }
 
-static inline unsigned long hweight64(__u64 w)
+static inline unsigned long __arch_hweight64(__u64 w)
 {
 	return __builtin_popcountll(w);
 }
 
+#include <asm-generic/bitops/const_hweight.h>
 #include <asm-generic/bitops/lock.h>
 #include <asm-generic/bitops/sched.h>
 #include <asm-generic/bitops/ext2-non-atomic.h>
-- 
1.6.5.2

