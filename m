Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650Ab0KCPB3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 11:01:29 -0400
Received: from claw.goop.org ([74.207.240.146]:42002 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755581Ab0KCPBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 11:01:23 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@suse.de>, Jan Beulich <JBeulich@novell.com>,
        Avi Kivity <avi@redhat.com>, Xen-devel <xen-devel@lists.xensource.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 20/20] x86/ticketlock: rename ticketpair to head_tail
Date: Wed,  3 Nov 2010 11:00:01 -0400
Message-Id: <4c3a64ecac8b57d715238bb1ae55c0079879430d.1288794124.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <cover.1288794124.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1288794124.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1288794124.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1288794124.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Make it clearer what fields head_tail is actually overlapping with.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/spinlock.h       |    2 +-
 arch/x86/include/asm/spinlock_types.h |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index a16b6e4..6850884 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -174,7 +174,7 @@ static __always_inline int arch_spin_trylock(arch_spinlock_t *lock)
 
 	new.slock = tmp.slock + (1 << TICKET_SHIFT);
 
-	ret = cmpxchg(&lock->ticketpair, tmp.slock, new.slock) == tmp.slock;
+	ret = cmpxchg(&lock->head_tail, tmp.slock, new.slock) == tmp.slock;
 	barrier();		/* just make nothing creeps before lock is claimed */
 
 	return ret;
diff --git a/arch/x86/include/asm/spinlock_types.h b/arch/x86/include/asm/spinlock_types.h
index 307ef0b..df031ec 100644
--- a/arch/x86/include/asm/spinlock_types.h
+++ b/arch/x86/include/asm/spinlock_types.h
@@ -24,7 +24,7 @@ typedef struct arch_spinlock {
 		struct {
 			__ticket_t waiting;
 			union {
-				__ticketpair_t ticketpair;
+				__ticketpair_t head_tail;
 				struct __raw_tickets {
 					__ticket_t head, tail;
 				} tickets;
@@ -38,7 +38,7 @@ typedef struct arch_spinlock {
 #else
 typedef struct arch_spinlock {
 	union {
-		__ticketpair_t ticketpair;
+		__ticketpair_t head_tail;
 		struct __raw_tickets {
 			__ticket_t head, tail;
 		} tickets;
-- 
1.7.2.3

