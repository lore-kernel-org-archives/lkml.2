Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577Ab0KCPBW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 11:01:22 -0400
Received: from claw.goop.org ([74.207.240.146]:35241 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755554Ab0KCPBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 11:01:19 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@suse.de>, Jan Beulich <JBeulich@novell.com>,
        Avi Kivity <avi@redhat.com>, Xen-devel <xen-devel@lists.xensource.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 16/20] x86/ticketlock: don't inline _spin_unlock when using paravirt spinlocks
Date: Wed,  3 Nov 2010 10:59:57 -0400
Message-Id: <c64c8997be40816f3215227ccbd2111399411285.1288794124.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <cover.1288794124.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1288794124.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1288794124.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1288794124.git.jeremy.fitzhardinge@citrix.com>
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
index cea0cd9..e67bf49 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -577,6 +577,9 @@ config PARAVIRT_SPINLOCKS
 
 	  If you are unsure how to answer this question, answer N.
 
+config ARCH_NOINLINE_SPIN_UNLOCK
+       def_bool PARAVIRT_SPINLOCKS
+
 config PARAVIRT_CLOCK
 	bool
 
diff --git a/kernel/Kconfig.locks b/kernel/Kconfig.locks
index 88c92fb..3216c22 100644
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
1.7.2.3

