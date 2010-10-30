Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab0J3VQy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 17:16:54 -0400
Received: from mail.perches.com ([173.55.12.10]:3713 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820Ab0J3VJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 17:09:26 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Muli Ben-Yehuda <muli@il.ibm.com>, "Jon D. Mason" <jdmason@kudzu.us>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        discuss@x86-64.org
Subject: [PATCH 05/39] arch/x86: Update WARN uses
Date: Sat, 30 Oct 2010 14:08:22 -0700
Message-Id: <9c86643277c2e832de6d97fb79be5e30b5fe2e48.1288471898.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1288471897.git.joe@perches.com>
References: <cover.1288471897.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Coalesce long formats.
Align arguments.
Add missing newlines.
Remove KERN_<level>.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/x86/kernel/acpi/boot.c      |    2 +-
 arch/x86/kernel/apic/apic.c      |    2 +-
 arch/x86/kernel/apic/es7000_32.c |    2 +-
 arch/x86/kernel/cpu/perf_event.c |    4 ++--
 arch/x86/kernel/pci-calgary_64.c |    4 ++--
 arch/x86/kernel/tsc_sync.c       |    4 ++--
 arch/x86/kernel/xsave.c          |    2 +-
 arch/x86/mm/ioremap.c            |    5 ++---
 arch/x86/mm/pageattr-test.c      |    2 +-
 arch/x86/mm/pageattr.c           |    5 ++---
 arch/x86/platform/sfi/sfi.c      |    4 ++--
 11 files changed, 17 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 71232b9..e005970 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -1368,7 +1368,7 @@ static int __init dmi_ignore_irq0_timer_override(const struct dmi_system_id *d)
 	 * the acpi_skip_timer_override flag already:
 	 */
 	if (!acpi_skip_timer_override) {
-		WARN(1, KERN_ERR "ati_ixp4x0 quirk not complete.\n");
+		WARN(1, "ati_ixp4x0 quirk not complete\n");
 		pr_notice("%s detected: Ignoring BIOS IRQ0 pin2 override\n",
 			d->ident);
 		acpi_skip_timer_override = 1;
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 850657d..86d8a50 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -2079,7 +2079,7 @@ static int lapic_resume(struct sys_device *dev)
 	if (intr_remapping_enabled) {
 		ioapic_entries = alloc_ioapic_entries();
 		if (!ioapic_entries) {
-			WARN(1, "Alloc ioapic_entries in lapic resume failed.");
+			WARN(1, "Alloc ioapic_entries in lapic resume failed\n");
 			ret = -ENOMEM;
 			goto restore;
 		}
diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index 8593582..a30bc9b 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -564,7 +564,7 @@ static unsigned int es7000_cpu_mask_to_apicid(const struct cpumask *cpumask)
 		int new_apicid = es7000_cpu_to_logical_apicid(cpu);
 
 		if (round && APIC_CLUSTER(apicid) != APIC_CLUSTER(new_apicid)) {
-			WARN(1, "Not a valid mask!");
+			WARN(1, "Not a valid mask!\n");
 
 			return BAD_APICID;
 		}
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index ed63101..564444d 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1378,14 +1378,14 @@ void __init init_hw_perf_events(void)
 		x86_pmu.quirks();
 
 	if (x86_pmu.num_counters > X86_PMC_MAX_GENERIC) {
-		WARN(1, KERN_ERR "hw perf events %d > max(%d), clipping!",
+		WARN(1, "hw perf events %d > max(%d), clipping!\n",
 		     x86_pmu.num_counters, X86_PMC_MAX_GENERIC);
 		x86_pmu.num_counters = X86_PMC_MAX_GENERIC;
 	}
 	x86_pmu.intel_ctrl = (1 << x86_pmu.num_counters) - 1;
 
 	if (x86_pmu.num_counters_fixed > X86_PMC_MAX_FIXED) {
-		WARN(1, KERN_ERR "hw perf events fixed %d > max(%d), clipping!",
+		WARN(1, "hw perf events fixed %d > max(%d), clipping!\n",
 		     x86_pmu.num_counters_fixed, X86_PMC_MAX_FIXED);
 		x86_pmu.num_counters_fixed = X86_PMC_MAX_FIXED;
 	}
diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index f56a117..f179747 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -296,8 +296,8 @@ static void iommu_free(struct iommu_table *tbl, dma_addr_t dma_addr,
 	/* were we called with bad_dma_address? */
 	badend = DMA_ERROR_CODE + (EMERGENCY_PAGES * PAGE_SIZE);
 	if (unlikely((dma_addr >= DMA_ERROR_CODE) && (dma_addr < badend))) {
-		WARN(1, KERN_ERR "Calgary: driver tried unmapping bad DMA "
-		       "address 0x%Lx\n", dma_addr);
+		WARN(1, "Calgary: driver tried unmapping bad DMA address 0x%llx\n",
+		     dma_addr);
 		return;
 	}
 
diff --git a/arch/x86/kernel/tsc_sync.c b/arch/x86/kernel/tsc_sync.c
index 0aa5fed8..cf11d51 100644
--- a/arch/x86/kernel/tsc_sync.c
+++ b/arch/x86/kernel/tsc_sync.c
@@ -94,8 +94,8 @@ static __cpuinit void check_tsc_warp(void)
 		}
 	}
 	WARN(!(now-start),
-		"Warning: zero tsc calibration delta: %Ld [max: %Ld]\n",
-			now-start, end-start);
+	     "Warning: zero tsc calibration delta: %lld [max: %lld]\n",
+	     now-start, end-start);
 }
 
 /*
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 9c253bd..b499aa8 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -418,7 +418,7 @@ static void __init xstate_enable_boot_cpu(void)
 	unsigned int eax, ebx, ecx, edx;
 
 	if (boot_cpu_data.cpuid_level < XSTATE_CPUID) {
-		WARN(1, KERN_ERR "XSTATE_CPUID missing\n");
+		WARN(1, "XSTATE_CPUID missing\n");
 		return;
 	}
 
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 0369843..841ae72 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -476,9 +476,8 @@ static int __init check_early_ioremap_leak(void)
 
 	if (!count)
 		return 0;
-	WARN(1, KERN_WARNING
-	       "Debug warning: early ioremap leak of %d areas detected.\n",
-		count);
+	WARN(1, "Debug warning: early ioremap leak of %d areas detected\n",
+	     count);
 	printk(KERN_WARNING
 		"please boot with early_ioremap_debug and report the dmesg.\n");
 
diff --git a/arch/x86/mm/pageattr-test.c b/arch/x86/mm/pageattr-test.c
index e1d1069..15d3536 100644
--- a/arch/x86/mm/pageattr-test.c
+++ b/arch/x86/mm/pageattr-test.c
@@ -224,7 +224,7 @@ static int pageattr_test(void)
 	failed += print_split(&sc);
 
 	if (failed) {
-		WARN(1, KERN_ERR "NOT PASSED. Please report.\n");
+		WARN(1, "NOT PASSED. Please report.\n");
 		return -EINVAL;
 	} else {
 		if (print)
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 532e793..0c97354 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -615,9 +615,8 @@ static int __cpa_process_fault(struct cpa_data *cpa, unsigned long vaddr,
 		cpa->pfn = __pa(vaddr) >> PAGE_SHIFT;
 		return 0;
 	} else {
-		WARN(1, KERN_WARNING "CPA: called for zero pte. "
-			"vaddr = %lx cpa->vaddr = %lx\n", vaddr,
-			*cpa->vaddr);
+		WARN(1, "CPA: called for zero pte. vaddr = %lx cpa->vaddr = %lx\n",
+		     vaddr, *cpa->vaddr);
 
 		return -EFAULT;
 	}
diff --git a/arch/x86/platform/sfi/sfi.c b/arch/x86/platform/sfi/sfi.c
index dd4c281..f66fabc 100644
--- a/arch/x86/platform/sfi/sfi.c
+++ b/arch/x86/platform/sfi/sfi.c
@@ -97,8 +97,8 @@ static int __init sfi_parse_ioapic(struct sfi_table_header *table)
 		pentry++;
 	}
 
-	WARN(pic_mode, KERN_WARNING
-		"SFI: pic_mod shouldn't be 1 when IOAPIC table is present\n");
+	WARN(pic_mode,
+	     "SFI: pic_mod shouldn't be 1 when IOAPIC table is present\n");
 	pic_mode = 0;
 	return 0;
 }
-- 
1.7.3.1.g432b3.dirty

