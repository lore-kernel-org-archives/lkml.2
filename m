Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759661Ab1FATrk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 15:47:40 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:59138 "EHLO duck.linux-mips.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759635Ab1FATrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 15:47:36 -0400
Message-Id: <20110601180610.371273795@duck.linux-mips.net>
User-Agent: quilt/0.48-1
Date: Wed, 01 Jun 2011 19:05:01 +0100
From: ralf@linux-mips.org
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [patch 05/14] i8253: Make x86 use the shared i8253_lock.
References: <20110601180456.801265664@duck.linux-mips.net>
Content-Disposition: inline; filename=i8253-move-x86-to-shared-lock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org

 arch/x86/Kconfig        |    1 +
 arch/x86/kernel/i8253.c |    3 ---
 2 files changed, 1 insertion(+), 3 deletions(-)

Index: linux-mips/arch/x86/Kconfig
===================================================================
--- linux-mips.orig/arch/x86/Kconfig
+++ linux-mips/arch/x86/Kconfig
@@ -67,6 +67,7 @@ config X86
 	select GENERIC_IRQ_PROBE
 	select GENERIC_PENDING_IRQ if SMP
 	select GENERIC_IRQ_SHOW
+	select I8253_LOCK
 	select IRQ_FORCED_THREADING
 	select USE_GENERIC_SMP_HELPERS if SMP
 	select HAVE_BPF_JIT if (X86_64 && NET)
Index: linux-mips/arch/x86/kernel/i8253.c
===================================================================
--- linux-mips.orig/arch/x86/kernel/i8253.c
+++ linux-mips/arch/x86/kernel/i8253.c
@@ -16,9 +16,6 @@
 #include <asm/hpet.h>
 #include <asm/smp.h>
 
-DEFINE_RAW_SPINLOCK(i8253_lock);
-EXPORT_SYMBOL(i8253_lock);
-
 /*
  * HPET replaces the PIT, when enabled. So we need to know, which of
  * the two timers is used


