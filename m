Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab1CYOUi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 10:20:38 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:49022 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab1CYOUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 10:20:36 -0400
Date: Fri, 25 Mar 2011 15:20:14 +0100
From: Jean Delvare <khali@linux-fr.org>
To: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] x86: Stop including <linux/delay.h> in two asm header files
Message-ID: <20110325152014.297890ec@endymion.delvare>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stop including <linux/delay.h> in x86 header files which don't need
it. This will let the compiler complain when this header is not
included by source files when it should, so that contributors can fix
the problem before building on other architectures starts to fail.

Credits go to Geert for the idea.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
---
As discussed on linux-next.

 arch/x86/include/asm/apic.h        |    1 -
 arch/x86/include/asm/dma.h         |    1 -
 arch/x86/kernel/apic/hw_nmi.c      |    1 +
 arch/x86/kernel/apic/x2apic_uv_x.c |    1 +
 arch/x86/kernel/irq.c              |    1 +
 arch/x86/kernel/reboot.c           |    1 +
 arch/x86/platform/uv/tlb_uv.c      |    1 +
 drivers/media/rc/ite-cir.c         |    1 +
 drivers/scsi/ultrastor.c           |    1 +
 9 files changed, 7 insertions(+), 2 deletions(-)

--- linux-2.6.39-rc0.orig/arch/x86/include/asm/apic.h	2011-03-25 14:15:01.000000000 +0100
+++ linux-2.6.39-rc0/arch/x86/include/asm/apic.h	2011-03-25 14:37:06.000000000 +0100
@@ -2,7 +2,6 @@
 #define _ASM_X86_APIC_H
 
 #include <linux/cpumask.h>
-#include <linux/delay.h>
 #include <linux/pm.h>
 
 #include <asm/alternative.h>
--- linux-2.6.39-rc0.orig/arch/x86/include/asm/dma.h	2011-03-25 14:15:01.000000000 +0100
+++ linux-2.6.39-rc0/arch/x86/include/asm/dma.h	2011-03-25 14:37:06.000000000 +0100
@@ -10,7 +10,6 @@
 
 #include <linux/spinlock.h>	/* And spinlocks */
 #include <asm/io.h>		/* need byte IO */
-#include <linux/delay.h>
 
 #ifdef HAVE_REALLY_SLOW_DMA_CONTROLLER
 #define dma_outb	outb_p
--- linux-2.6.39-rc0.orig/arch/x86/kernel/apic/hw_nmi.c	2011-03-25 14:15:01.000000000 +0100
+++ linux-2.6.39-rc0/arch/x86/kernel/apic/hw_nmi.c	2011-03-25 14:37:07.000000000 +0100
@@ -16,6 +16,7 @@
 #include <linux/kprobes.h>
 #include <linux/nmi.h>
 #include <linux/module.h>
+#include <linux/delay.h>
 
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
 u64 hw_nmi_get_sample_period(void)
--- linux-2.6.39-rc0.orig/arch/x86/kernel/apic/x2apic_uv_x.c	2011-03-25 14:15:01.000000000 +0100
+++ linux-2.6.39-rc0/arch/x86/kernel/apic/x2apic_uv_x.c	2011-03-25 14:37:07.000000000 +0100
@@ -23,6 +23,7 @@
 #include <linux/io.h>
 #include <linux/pci.h>
 #include <linux/kdebug.h>
+#include <linux/delay.h>
 
 #include <asm/uv/uv_mmrs.h>
 #include <asm/uv/uv_hub.h>
--- linux-2.6.39-rc0.orig/arch/x86/kernel/irq.c	2011-03-25 14:15:01.000000000 +0100
+++ linux-2.6.39-rc0/arch/x86/kernel/irq.c	2011-03-25 14:37:07.000000000 +0100
@@ -8,6 +8,7 @@
 #include <linux/seq_file.h>
 #include <linux/smp.h>
 #include <linux/ftrace.h>
+#include <linux/delay.h>
 
 #include <asm/apic.h>
 #include <asm/io_apic.h>
--- linux-2.6.39-rc0.orig/arch/x86/kernel/reboot.c	2011-03-25 14:15:01.000000000 +0100
+++ linux-2.6.39-rc0/arch/x86/kernel/reboot.c	2011-03-25 14:37:07.000000000 +0100
@@ -6,6 +6,7 @@
 #include <linux/dmi.h>
 #include <linux/sched.h>
 #include <linux/tboot.h>
+#include <linux/delay.h>
 #include <acpi/reboot.h>
 #include <asm/io.h>
 #include <asm/apic.h>
--- linux-2.6.39-rc0.orig/arch/x86/platform/uv/tlb_uv.c	2011-03-25 14:15:01.000000000 +0100
+++ linux-2.6.39-rc0/arch/x86/platform/uv/tlb_uv.c	2011-03-25 14:37:07.000000000 +0100
@@ -11,6 +11,7 @@
 #include <linux/debugfs.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
+#include <linux/delay.h>
 
 #include <asm/mmu_context.h>
 #include <asm/uv/uv.h>
--- linux-2.6.39-rc0.orig/drivers/scsi/ultrastor.c	2011-03-25 14:15:01.000000000 +0100
+++ linux-2.6.39-rc0/drivers/scsi/ultrastor.c	2011-03-25 14:37:07.000000000 +0100
@@ -138,6 +138,7 @@
 #include <linux/spinlock.h>
 #include <linux/stat.h>
 #include <linux/bitops.h>
+#include <linux/delay.h>
 
 #include <asm/io.h>
 #include <asm/system.h>
--- linux-2.6.39-rc0.orig/drivers/media/rc/ite-cir.c	2011-03-25 13:54:59.000000000 +0100
+++ linux-2.6.39-rc0/drivers/media/rc/ite-cir.c	2011-03-25 14:56:15.000000000 +0100
@@ -41,6 +41,7 @@
 #include <linux/bitops.h>
 #include <media/rc-core.h>
 #include <linux/pci_ids.h>
+#include <linux/delay.h>
 
 #include "ite-cir.h"
 

-- 
Jean Delvare
