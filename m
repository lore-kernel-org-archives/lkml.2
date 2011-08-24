Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124Ab1HXVhS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 17:37:18 -0400
Received: from claw.goop.org ([74.207.240.146]:53450 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753860Ab1HXVhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 17:37:15 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 02/12] x86/cmpxchg: move 32-bit __cmpxchg_wrong_size to match 64 bit.
Date: Wed, 24 Aug 2011 14:36:59 -0700
Message-Id: <212ffd750654adef6ad93d8cf6771345c23736fc.1314221624.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1314207974.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1314207974.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <e1c8d3bcee83cc5ad00bdf8900a99add7abb1cb9.1314221624.git.jeremy.fitzhardinge@citrix.com>
References: <e1c8d3bcee83cc5ad00bdf8900a99add7abb1cb9.1314221624.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/cmpxchg_32.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/cmpxchg_32.h b/arch/x86/include/asm/cmpxchg_32.h
index 8d53b16..0ef9b82 100644
--- a/arch/x86/include/asm/cmpxchg_32.h
+++ b/arch/x86/include/asm/cmpxchg_32.h
@@ -9,6 +9,7 @@
  */
 
 extern void __xchg_wrong_size(void);
+extern void __cmpxchg_wrong_size(void);
 
 /*
  * Note: no "lock" prefix even on SMP: xchg always implies lock anyway.
@@ -84,8 +85,6 @@ static inline void set_64bit(volatile u64 *ptr, u64 value)
 		     : "memory");
 }
 
-extern void __cmpxchg_wrong_size(void);
-
 /*
  * Atomic compare and exchange.  Compare OLD with MEM, if identical,
  * store NEW in MEM.  Return the initial value in MEM.  Success is
-- 
1.7.6

