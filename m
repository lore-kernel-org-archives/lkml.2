Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008Ab2CUKVt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 06:21:49 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:34830 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757611Ab2CUKVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 06:21:46 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Stephan Diestelhorst <stephan.diestelhorst@amd.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Attilio Rao <attilio.rao@citrix.com>
Date: Wed, 21 Mar 2012 15:51:07 +0530
Message-Id: <20120321102107.473.89777.sendpatchset@codeblue.in.ibm.com>
In-Reply-To: <20120321102041.473.61069.sendpatchset@codeblue.in.ibm.com>
References: <20120321102041.473.61069.sendpatchset@codeblue.in.ibm.com>
Subject: [PATCH RFC V6 2/11]  x86/ticketlock: don't inline _spin_unlock when using paravirt spinlocks
x-cbid: 12032110-2000-0000-0000-000006DB985C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

The code size expands somewhat, and its probably better to just call
a function rather than inline it.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---
 arch/x86/Kconfig     |    3 +++
 kernel/Kconfig.locks |    2 +-
 2 files changed, 4 insertions(+), 1 deletions(-)
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5bed94e..10c28ec 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -623,6 +623,9 @@ config PARAVIRT_SPINLOCKS
 
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

