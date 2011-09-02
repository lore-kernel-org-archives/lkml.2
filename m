Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233Ab1IBXyW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 19:54:22 -0400
Received: from claw.goop.org ([74.207.240.146]:45527 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755Ab1IBXyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 19:54:21 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 2/8] x86/ticketlock: don't inline _spin_unlock when using paravirt spinlocks
Date: Fri,  2 Sep 2011 16:54:09 -0700
Message-Id: <bca3a7e52a8da2d4ecf0e36c80f05fd7824d767c.1315007226.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1315007226.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1315007226.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1315007226.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1315007226.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

The code size expands somewhat, and its probably better to just call
a function rather than inline it.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/Kconfig     |    3 +++
 kernel/Kconfig.locks |    2 +-
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 6a47bb2..1f03f82 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -585,6 +585,9 @@ config PARAVIRT_SPINLOCKS
 
 	  If you are unsure how to answer this question, answer N.
 
+config ARCH_NOINLINE_SPIN_UNLOCK
+       def_bool PARAVIRT_SPINLOCKS
+
 config PARAVIRT_CLOCK
 	bool
 
diff --git a/kernel/Kconfig.locks b/kernel/Kconfig.locks
index 5068e2a..584637b 100644
--- a/kernel/Kconfig.locks
+++ b/kernel/Kconfig.locks
@@ -125,7 +125,7 @@ config INLINE_SPIN_LOCK_IRQSAVE
 		 ARCH_INLINE_SPIN_LOCK_IRQSAVE
 
 config INLINE_SPIN_UNLOCK
-	def_bool !DEBUG_SPINLOCK && (!PREEMPT || ARCH_INLINE_SPIN_UNLOCK)
+	def_bool !DEBUG_SPINLOCK && (!PREEMPT || ARCH_INLINE_SPIN_UNLOCK) && !ARCH_NOINLINE_SPIN_UNLOCK
 
 config INLINE_SPIN_UNLOCK_BH
 	def_bool !DEBUG_SPINLOCK && ARCH_INLINE_SPIN_UNLOCK_BH
-- 
1.7.6

