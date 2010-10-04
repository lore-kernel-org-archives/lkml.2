Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180Ab0JDU3V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 16:29:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:53155 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757155Ab0JDU3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 16:29:20 -0400
Date: Mon, 4 Oct 2010 20:28:51 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100927121843.314600915@linutronix.de>
References: <20100927121843.314600915@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] x86: Use genirq Kconfig
Message-ID: <tip-3bb9808e99bcc36eecb8e082bf70efb2a0bcdcb7@git.kernel.org>
Git-Commit-ID: 3bb9808e99bcc36eecb8e082bf70efb2a0bcdcb7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 04 Oct 2010 20:28:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3bb9808e99bcc36eecb8e082bf70efb2a0bcdcb7
Gitweb:     http://git.kernel.org/tip/3bb9808e99bcc36eecb8e082bf70efb2a0bcdcb7
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Mon, 27 Sep 2010 12:46:02 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 4 Oct 2010 11:01:15 +0200

x86: Use genirq Kconfig

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20100927121843.314600915@linutronix.de>
Reviewed-by: H. Peter Anvin <hpa@zytor.com>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig |   36 +++++-------------------------------
 1 files changed, 5 insertions(+), 31 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cea0cd9..3ec657f 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -59,6 +59,11 @@ config X86
 	select ANON_INODES
 	select HAVE_ARCH_KMEMCHECK
 	select HAVE_USER_RETURN_NOTIFIER
+	select HAVE_GENERIC_HARDIRQS
+	select HAVE_SPARSE_IRQ
+	select NUMA_IRQ_DESC if (SPARSE_IRQ && NUMA)
+	select GENERIC_IRQ_PROBE
+	select GENERIC_PENDING_IRQ if SMP
 
 config INSTRUCTION_DECODER
 	def_bool (KPROBES || PERF_EVENTS)
@@ -200,20 +205,6 @@ config HAVE_INTEL_TXT
 	def_bool y
 	depends on EXPERIMENTAL && DMAR && ACPI
 
-# Use the generic interrupt handling code in kernel/irq/:
-config GENERIC_HARDIRQS
-	def_bool y
-
-config GENERIC_HARDIRQS_NO__DO_IRQ
-       def_bool y
-
-config GENERIC_IRQ_PROBE
-	def_bool y
-
-config GENERIC_PENDING_IRQ
-	def_bool y
-	depends on GENERIC_HARDIRQS && SMP
-
 config USE_GENERIC_SMP_HELPERS
 	def_bool y
 	depends on SMP
@@ -296,23 +287,6 @@ config X86_X2APIC
 
 	  If you don't know what to do here, say N.
 
-config SPARSE_IRQ
-	bool "Support sparse irq numbering"
-	depends on PCI_MSI || HT_IRQ
-	---help---
-	  This enables support for sparse irqs. This is useful for distro
-	  kernels that want to define a high CONFIG_NR_CPUS value but still
-	  want to have low kernel memory footprint on smaller machines.
-
-	  ( Sparse IRQs can also be beneficial on NUMA boxes, as they spread
-	    out the irq_desc[] array in a more NUMA-friendly way. )
-
-	  If you don't know what to do here, say N.
-
-config NUMA_IRQ_DESC
-	def_bool y
-	depends on SPARSE_IRQ && NUMA
-
 config X86_MPPARSE
 	bool "Enable MPS table" if ACPI
 	default y
