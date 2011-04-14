Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964933Ab1DNSPb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:15:31 -0400
Received: from mail.windriver.com ([147.11.1.11]:41896 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964903Ab1DNR6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:58:12 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        Len Brown <lenb@kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 152/209] x86, mwait: Move mwait constants to a common header file
Date: Thu, 14 Apr 2011 13:55:10 -0400
Message-Id: <1302803767-9715-39-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
 <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: H. Peter Anvin <hpa@linux.intel.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit bc83cccc761953f878088cdfa682de0970b5561f upstream.

We have MWAIT constants spread across three different .c files, for no
good reason.  Move them all into a common header file.

[PG: required for cherry pick of ce5f68246b - to avoid dup. mwait
fields in smpboot.c; drop intel_idle.c chunk, as 34 doesnt have it]

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Reviewed-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Len Brown <lenb@kernel.org>
LKML-Reference: <tip-*@git.kernel.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/include/asm/mwait.h  |   15 +++++++++++++++
 arch/x86/kernel/acpi/cstate.c |   11 +----------
 drivers/acpi/acpi_pad.c       |    7 +------
 3 files changed, 17 insertions(+), 16 deletions(-)
 create mode 100644 arch/x86/include/asm/mwait.h

diff --git a/arch/x86/include/asm/mwait.h b/arch/x86/include/asm/mwait.h
new file mode 100644
index 0000000..bcdff99
--- /dev/null
+++ b/arch/x86/include/asm/mwait.h
@@ -0,0 +1,15 @@
+#ifndef _ASM_X86_MWAIT_H
+#define _ASM_X86_MWAIT_H
+
+#define MWAIT_SUBSTATE_MASK		0xf
+#define MWAIT_CSTATE_MASK		0xf
+#define MWAIT_SUBSTATE_SIZE		4
+#define MWAIT_MAX_NUM_CSTATES		8
+
+#define CPUID_MWAIT_LEAF		5
+#define CPUID5_ECX_EXTENSIONS_SUPPORTED 0x1
+#define CPUID5_ECX_INTERRUPT_BREAK	0x2
+
+#define MWAIT_ECX_INTERRUPT_BREAK	0x1
+
+#endif /* _ASM_X86_MWAIT_H */
diff --git a/arch/x86/kernel/acpi/cstate.c b/arch/x86/kernel/acpi/cstate.c
index fb7a5f0..bcc4add 100644
--- a/arch/x86/kernel/acpi/cstate.c
+++ b/arch/x86/kernel/acpi/cstate.c
@@ -13,6 +13,7 @@
 
 #include <acpi/processor.h>
 #include <asm/acpi.h>
+#include <asm/mwait.h>
 
 /*
  * Initialize bm_flags based on the CPU cache properties
@@ -65,16 +66,6 @@ static struct cstate_entry *cpu_cstate_entry;	/* per CPU ptr */
 
 static short mwait_supported[ACPI_PROCESSOR_MAX_POWER];
 
-#define MWAIT_SUBSTATE_MASK	(0xf)
-#define MWAIT_CSTATE_MASK	(0xf)
-#define MWAIT_SUBSTATE_SIZE	(4)
-
-#define CPUID_MWAIT_LEAF (5)
-#define CPUID5_ECX_EXTENSIONS_SUPPORTED (0x1)
-#define CPUID5_ECX_INTERRUPT_BREAK	(0x2)
-
-#define MWAIT_ECX_INTERRUPT_BREAK	(0x1)
-
 #define NATIVE_CSTATE_BEYOND_HALT	(2)
 
 static long acpi_processor_ffh_cstate_probe_cpu(void *_cx)
diff --git a/drivers/acpi/acpi_pad.c b/drivers/acpi/acpi_pad.c
index 6212213..6f7a7c0 100644
--- a/drivers/acpi/acpi_pad.c
+++ b/drivers/acpi/acpi_pad.c
@@ -30,18 +30,13 @@
 #include <linux/slab.h>
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
+#include <asm/mwait.h>
 
 #define ACPI_PROCESSOR_AGGREGATOR_CLASS	"acpi_pad"
 #define ACPI_PROCESSOR_AGGREGATOR_DEVICE_NAME "Processor Aggregator"
 #define ACPI_PROCESSOR_AGGREGATOR_NOTIFY 0x80
 static DEFINE_MUTEX(isolated_cpus_lock);
 
-#define MWAIT_SUBSTATE_MASK	(0xf)
-#define MWAIT_CSTATE_MASK	(0xf)
-#define MWAIT_SUBSTATE_SIZE	(4)
-#define CPUID_MWAIT_LEAF (5)
-#define CPUID5_ECX_EXTENSIONS_SUPPORTED (0x1)
-#define CPUID5_ECX_INTERRUPT_BREAK	(0x2)
 static unsigned long power_saving_mwait_eax;
 static void power_saving_mwait_init(void)
 {
-- 
1.7.4.4

