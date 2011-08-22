Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492Ab1HVXQv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 19:16:51 -0400
Received: from claw.goop.org ([74.207.240.146]:48645 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754247Ab1HVXP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 19:15:27 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 14/15] x86/ticketlocks: use cmpxchg_flag for trylock
Date: Mon, 22 Aug 2011 16:15:10 -0700
Message-Id: <7c78985287f9006156f394bfce69437023773461.1314054734.git.jeremy.fitzhardinge@citrix.com>
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
 arch/x86/include/asm/spinlock.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 05fd59e..e208c8f 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -102,7 +102,7 @@ static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
 	new.head_tail = old.head_tail + (1 << TICKET_SHIFT);
 
 	/* cmpxchg is a full barrier, so nothing can move before it */
-	return cmpxchg(&lock->head_tail, old.head_tail, new.head_tail) == old.head_tail;
+	return cmpxchg_flag(&lock->head_tail, old.head_tail, new.head_tail);
 }
 
 static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
-- 
1.7.6

