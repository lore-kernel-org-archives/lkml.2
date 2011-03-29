Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254Ab1C2JR3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 05:17:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:41411 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934Ab1C2JR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 05:17:27 -0400
Date: Tue, 29 Mar 2011 09:16:43 GMT
From: tip-bot for Jean Delvare <khali@linux-fr.org>
Cc: linux-kernel@vger.kernel.org, James.Bottomley@suse.de, hpa@zytor.com,
        mingo@redhat.com, geert@linux-m68k.org, khali@linux-fr.org,
        tglx@linutronix.de, sfr@canb.auug.org.au, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, James.Bottomley@suse.de,
        linux-kernel@vger.kernel.org, geert@linux-m68k.org, khali@linux-fr.org,
        tglx@linutronix.de, sfr@canb.auug.org.au, mingo@elte.hu
In-Reply-To: <20110325152014.297890ec@endymion.delvare>
References: <20110325152014.297890ec@endymion.delvare>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Stop including <linux/delay.h> in two asm header files
Message-ID: <tip-ca444564a947034557a85357b3911d067cac4b8f@git.kernel.org>
Git-Commit-ID: ca444564a947034557a85357b3911d067cac4b8f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 29 Mar 2011 09:16:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ca444564a947034557a85357b3911d067cac4b8f
Gitweb:     http://git.kernel.org/tip/ca444564a947034557a85357b3911d067cac4b8f
Author:     Jean Delvare <khali@linux-fr.org>
AuthorDate: Fri, 25 Mar 2011 15:20:14 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 29 Mar 2011 09:37:42 +0200

x86: Stop including <linux/delay.h> in two asm header files

Stop including <linux/delay.h> in x86 header files which don't
need it. This will let the compiler complain when this header is
not included by source files when it should, so that
contributors can fix the problem before building on other
architectures starts to fail.

Credits go to Geert for the idea.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: James E.J. Bottomley <James.Bottomley@suse.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
LKML-Reference: <20110325152014.297890ec@endymion.delvare>
[ this also fixes an upstream build bug in drivers/media/rc/ite-cir.c ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
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

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index a279d98..2b7d573 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -2,7 +2,6 @@
 #define _ASM_X86_APIC_H
 
 #include <linux/cpumask.h>
-#include <linux/delay.h>
 #include <linux/pm.h>
 
 #include <asm/alternative.h>
diff --git a/arch/x86/include/asm/dma.h b/arch/x86/include/asm/dma.h
index 97b6d81..057099e 100644
--- a/arch/x86/include/asm/dma.h
+++ b/arch/x86/include/asm/dma.h
@@ -10,7 +10,6 @@
 
 #include <linux/spinlock.h>	/* And spinlocks */
 #include <asm/io.h>		/* need byte IO */
-#include <linux/delay.h>
 
 #ifdef HAVE_REALLY_SLOW_DMA_CONTROLLER
 #define dma_outb	outb_p
diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index c4e557a..5260fe9 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -16,6 +16,7 @@
 #include <linux/kprobes.h>
 #include <linux/nmi.h>
 #include <linux/module.h>
+#include <linux/delay.h>
 
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
 u64 hw_nmi_get_sample_period(void)
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 3c28928..d2cf39b 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -23,6 +23,7 @@
 #include <linux/io.h>
 #include <linux/pci.h>
 #include <linux/kdebug.h>
+#include <linux/delay.h>
 
 #include <asm/uv/uv_mmrs.h>
 #include <asm/uv/uv_hub.h>
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 948a31e..1cb0b9f 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -8,6 +8,7 @@
 #include <linux/seq_file.h>
 #include <linux/smp.h>
 #include <linux/ftrace.h>
+#include <linux/delay.h>
 
 #include <asm/apic.h>
 #include <asm/io_apic.h>
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index d3ce37e..08c44b0 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -6,6 +6,7 @@
 #include <linux/dmi.h>
 #include <linux/sched.h>
 #include <linux/tboot.h>
+#include <linux/delay.h>
 #include <acpi/reboot.h>
 #include <asm/io.h>
 #include <asm/apic.h>
diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
index a7b38d3..7cb6424 100644
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -11,6 +11,7 @@
 #include <linux/debugfs.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
+#include <linux/delay.h>
 
 #include <asm/mmu_context.h>
 #include <asm/uv/uv.h>
diff --git a/drivers/media/rc/ite-cir.c b/drivers/media/rc/ite-cir.c
index ac0e42b..accaf6c 100644
--- a/drivers/media/rc/ite-cir.c
+++ b/drivers/media/rc/ite-cir.c
@@ -41,6 +41,7 @@
 #include <linux/bitops.h>
 #include <media/rc-core.h>
 #include <linux/pci_ids.h>
+#include <linux/delay.h>
 
 #include "ite-cir.h"
 
diff --git a/drivers/scsi/ultrastor.c b/drivers/scsi/ultrastor.c
index 0571ef9..9f4b58b 100644
--- a/drivers/scsi/ultrastor.c
+++ b/drivers/scsi/ultrastor.c
@@ -138,6 +138,7 @@
 #include <linux/spinlock.h>
 #include <linux/stat.h>
 #include <linux/bitops.h>
+#include <linux/delay.h>
 
 #include <asm/io.h>
 #include <asm/system.h>
