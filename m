Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631Ab0KCPY6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 11:24:58 -0400
Received: from claw.goop.org ([74.207.240.146]:52455 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755523Ab0KCPYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 11:24:55 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@suse.de>, Jan Beulich <JBeulich@novell.com>,
        Avi Kivity <avi@redhat.com>, Xen-devel <xen-devel@lists.xensource.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 18/20] x86/ticketlock: remove .slock
Date: Wed,  3 Nov 2010 10:59:59 -0400
Message-Id: <ccf130fbd386ce6c7cbd2c5c0704d7ff2e67a716.1288794124.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <cover.1288794124.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1288794124.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1288794124.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1288794124.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/spinlock_types.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/spinlock_types.h b/arch/x86/include/asm/spinlock_types.h
index b396ed5..def8010 100644
--- a/arch/x86/include/asm/spinlock_types.h
+++ b/arch/x86/include/asm/spinlock_types.h
@@ -20,7 +20,6 @@ typedef u32 __ticketpair_t;
 
 typedef struct arch_spinlock {
 	union {
-		unsigned int slock;
 		__ticketpair_t ticketpair;
 		struct __raw_tickets {
 			__ticket_t head, tail;
@@ -31,7 +30,7 @@ typedef struct arch_spinlock {
 #endif
 } arch_spinlock_t;
 
-#define __ARCH_SPIN_LOCK_UNLOCKED	{ { .slock = 0 } }
+#define __ARCH_SPIN_LOCK_UNLOCKED	{ { .tickets = {0, 0} } }
 
 typedef struct {
 	unsigned int lock;
-- 
1.7.2.3

