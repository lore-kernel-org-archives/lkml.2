Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483Ab1HVXRw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 19:17:52 -0400
Received: from claw.goop.org ([74.207.240.146]:48645 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754209Ab1HVXP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 19:15:26 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 11/15] x86/cmpxchg: move 64-bit set64_bit() to match 32-bit
Date: Mon, 22 Aug 2011 16:15:07 -0700
Message-Id: <a4e57d501236503d40f90793ad71ca921810d37f.1314054734.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1314045780.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1314045780.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1314054734.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1314054734.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/cmpxchg_64.h |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/cmpxchg_64.h b/arch/x86/include/asm/cmpxchg_64.h
index 423ae58..aeaa610 100644
--- a/arch/x86/include/asm/cmpxchg_64.h
+++ b/arch/x86/include/asm/cmpxchg_64.h
@@ -3,11 +3,6 @@
 
 #include <asm/alternative.h> /* Provides LOCK_PREFIX */
 
-static inline void set_64bit(volatile u64 *ptr, u64 val)
-{
-	*ptr = val;
-}
-
 extern void __xchg_wrong_size(void);
 extern void __cmpxchg_wrong_size(void);
 
@@ -66,6 +61,11 @@ extern void __cmpxchg_wrong_size(void);
 #define xchg(ptr, v)							\
 	__xchg((v), (ptr), sizeof(*ptr))
 
+static inline void set_64bit(volatile u64 *ptr, u64 val)
+{
+	*ptr = val;
+}
+
 #define __HAVE_ARCH_CMPXCHG 1
 
 /*
-- 
1.7.6

