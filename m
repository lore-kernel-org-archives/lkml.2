Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab0ELAjN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 20:39:13 -0400
Received: from mail.perches.com ([173.55.12.10]:2158 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752362Ab0ELAjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 20:39:10 -0400
Subject: [trivial PATCH] arch/x86: Remove unnecessary returns from void
 function()'s
From: Joe Perches <joe@perches.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, x86@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Jiri Kosina <trivial@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 May 2010 17:39:07 -0700
Message-ID: <1273624747.20514.316.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes from arch/x86/ all the unnecessary
return; statements that precede the last closing brace of
void functions.

It does not remove returns that are immediately
preceded by a label as gcc doesn't like that.

Done via:
$ grep -rPl --include=*.[ch] "return;\n}" arch/x86/ | \
  xargs perl -i -e 'local $/ ; while (<>) { s/\n[ \t\n]+return;\n}/\n}/g; print; }'

Compile tested x86 allmodconfig only.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/x86/boot/compressed/misc.c               |    1 -
 arch/x86/include/asm/apic.h                   |    2 --
 arch/x86/kernel/acpi/boot.c                   |    2 --
 arch/x86/kernel/amd_iommu.c                   |    2 --
 arch/x86/kernel/apb_timer.c                   |    2 --
 arch/x86/kernel/apic/io_apic.c                |    2 --
 arch/x86/kernel/cpu/cpufreq/cpufreq-nforce2.c |    2 --
 arch/x86/kernel/cpu/cpufreq/powernow-k6.c     |    2 --
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c     |    2 --
 arch/x86/kernel/cpu/cpufreq/speedstep-ich.c   |    2 --
 arch/x86/kernel/cpu/cpufreq/speedstep-smi.c   |    2 --
 arch/x86/kernel/cpu/cyrix.c                   |    1 -
 arch/x86/kernel/hpet.c                        |    2 --
 arch/x86/kernel/pci-calgary_64.c              |    1 -
 arch/x86/kernel/quirks.c                      |    3 ---
 arch/x86/kernel/reboot_fixups_32.c            |    1 -
 arch/x86/kernel/traps.c                       |    2 --
 arch/x86/kernel/vsmp_64.c                     |    1 -
 arch/x86/kvm/mmu.c                            |    2 --
 arch/x86/kvm/x86.c                            |    1 -
 arch/x86/lguest/boot.c                        |    1 -
 arch/x86/lib/insn.c                           |    1 -
 arch/x86/math-emu/fpu_trig.c                  |    1 -
 arch/x86/mm/ioremap.c                         |    1 -
 arch/x86/xen/enlighten.c                      |    1 -
 25 files changed, 0 insertions(+), 40 deletions(-)

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 51e2407..4a02858 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -342,5 +342,4 @@ asmlinkage void decompress_kernel(void *rmode, memptr heap,
 	parse_elf(output);
 	if (!quiet)
 		putstr("done.\nBooting the kernel.\n");
-	return;
 }
diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index b4ac2cd..a872622 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -153,7 +153,6 @@ static inline u32 native_apic_msr_read(u32 reg)
 static inline void native_x2apic_wait_icr_idle(void)
 {
 	/* no need to wait for icr idle in x2apic */
-	return;
 }
 
 static inline u32 native_safe_x2apic_wait_icr_idle(void)
@@ -453,7 +452,6 @@ static inline void default_wait_for_init_deassert(atomic_t *deassert)
 {
 	while (!atomic_read(deassert))
 		cpu_relax();
-	return;
 }
 
 extern void generic_bigsmp_probe(void);
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index cd40aba..c187c6e 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -340,7 +340,6 @@ static void __init acpi_sci_ioapic_setup(u32 gsi, u16 polarity, u16 trigger)
 	 * and for later update of acpi_gbl_FADT
 	 */
 	acpi_sci_override_gsi = gsi;
-	return;
 }
 
 static int __init
@@ -1261,7 +1260,6 @@ static void __init acpi_process_madt(void)
 		printk(KERN_INFO "Using ACPI for processor (LAPIC) "
 		       "configuration information\n");
 #endif
-	return;
 }
 
 static int __init disable_acpi_irq(const struct dmi_system_id *d)
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index f854d89..9eb1864 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -601,8 +601,6 @@ static void __iommu_flush_pages(struct protection_domain *domain,
 		iommu_queue_inv_iommu_pages(amd_iommus[i], address,
 					    domain->id, pde, s);
 	}
-
-	return;
 }
 
 static void iommu_flush_pages(struct protection_domain *domain,
diff --git a/arch/x86/kernel/apb_timer.c b/arch/x86/kernel/apb_timer.c
index a353475..c757c36 100644
--- a/arch/x86/kernel/apb_timer.c
+++ b/arch/x86/kernel/apb_timer.c
@@ -391,8 +391,6 @@ void apbt_setup_secondary_clock(void)
 	clockevents_register_device(aevt);
 
 	apbt_enable_int(cpu);
-
-	return;
 }
 
 /*
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index eb2789c..e46da65 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1742,8 +1742,6 @@ __apicdebuginit(void) print_IO_APIC(void)
 	}
 
 	printk(KERN_INFO ".................................... done.\n");
-
-	return;
 }
 
 __apicdebuginit(void) print_APIC_field(int base)
diff --git a/arch/x86/kernel/cpu/cpufreq/cpufreq-nforce2.c b/arch/x86/kernel/cpu/cpufreq/cpufreq-nforce2.c
index 733093d..32ca812 100644
--- a/arch/x86/kernel/cpu/cpufreq/cpufreq-nforce2.c
+++ b/arch/x86/kernel/cpu/cpufreq/cpufreq-nforce2.c
@@ -125,8 +125,6 @@ static void nforce2_write_pll(int pll)
 	/* Now write the value in all 64 registers */
 	for (temp = 0; temp <= 0x3f; temp++)
 		pci_write_config_dword(nforce2_dev, NFORCE2_PLLREG, pll);
-
-	return;
 }
 
 /**
diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k6.c b/arch/x86/kernel/cpu/cpufreq/powernow-k6.c
index b3379d6..8b4fa54 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k6.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k6.c
@@ -98,8 +98,6 @@ static void powernow_k6_set_state(unsigned int best_i)
 	wrmsr(MSR_K6_EPMR, msrval, 0); /* disable it again */
 
 	cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
-
-	return;
 }
 
 
diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index b6215b9..52afb5e 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -149,14 +149,12 @@ static int query_current_values_with_pending_wait(struct powernow_k8_data *data)
 static void count_off_irt(struct powernow_k8_data *data)
 {
 	udelay((1 << data->irt) * 10);
-	return;
 }
 
 /* the voltage stabilization time */
 static void count_off_vst(struct powernow_k8_data *data)
 {
 	udelay(data->vstable * VST_UNITS_20US);
-	return;
 }
 
 /* need to init the control msr to a safe value (for each cpu) */
diff --git a/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c b/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
index 561758e..ac85c8b 100644
--- a/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
+++ b/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
@@ -139,8 +139,6 @@ static void speedstep_set_state(unsigned int state)
 			speedstep_get_frequency(speedstep_processor) / 1000);
 	else
 		printk(KERN_ERR "cpufreq: change failed - I/O error\n");
-
-	return;
 }
 
 /* Wrapper for smp_call_function_single. */
diff --git a/arch/x86/kernel/cpu/cpufreq/speedstep-smi.c b/arch/x86/kernel/cpu/cpufreq/speedstep-smi.c
index 8abd869..3fd82bf 100644
--- a/arch/x86/kernel/cpu/cpufreq/speedstep-smi.c
+++ b/arch/x86/kernel/cpu/cpufreq/speedstep-smi.c
@@ -229,8 +229,6 @@ static void speedstep_set_state(unsigned int state)
 		printk(KERN_ERR "cpufreq: change to state %u "
 			"failed with new_state %u and result %u\n",
 			state, new_state, result);
-
-	return;
 }
 
 
diff --git a/arch/x86/kernel/cpu/cyrix.c b/arch/x86/kernel/cpu/cyrix.c
index 4fbd384..13ff0c7 100644
--- a/arch/x86/kernel/cpu/cyrix.c
+++ b/arch/x86/kernel/cpu/cyrix.c
@@ -349,7 +349,6 @@ static void __cpuinit init_cyrix(struct cpuinfo_x86 *c)
 	strcpy(buf, Cx86_model[dir0_msn & 7]);
 	if (p)
 		strcat(buf, p);
-	return;
 }
 
 /*
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 23b4ecd..2916ddf 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -744,13 +744,11 @@ static int hpet_setup_msi_irq(unsigned int irq)
 }
 static void hpet_msi_capability_lookup(unsigned int start_timer)
 {
-	return;
 }
 
 #ifdef CONFIG_HPET
 static void hpet_reserve_msi_timers(struct hpet_data *hd)
 {
-	return;
 }
 #endif
 
diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index fb99f7e..aaad25e 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -1341,7 +1341,6 @@ static void __init get_tce_space_from_tar(void)
 			info->tce_space = (u64 *)__va(tce_space);
 		}
 	}
-	return;
 }
 
 static int __init calgary_iommu_init(void)
diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index 12e9fea..436c357 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -88,8 +88,6 @@ static void ich_force_hpet_resume(void)
 		BUG();
 	else
 		printk(KERN_DEBUG "Force enabled HPET at resume\n");
-
-	return;
 }
 
 static void ich_force_enable_hpet(struct pci_dev *dev)
@@ -440,7 +438,6 @@ static void nvidia_force_enable_hpet(struct pci_dev *dev)
 	dev_printk(KERN_DEBUG, &dev->dev, "Force enabled HPET at 0x%lx\n",
 		force_hpet_address);
 	cached_dev = dev;
-	return;
 }
 
 /* ISA Bridges */
diff --git a/arch/x86/kernel/reboot_fixups_32.c b/arch/x86/kernel/reboot_fixups_32.c
index fda313e..34336ff 100644
--- a/arch/x86/kernel/reboot_fixups_32.c
+++ b/arch/x86/kernel/reboot_fixups_32.c
@@ -20,7 +20,6 @@ static void cs5530a_warm_reset(struct pci_dev *dev)
 	cs5530a to perform a system warm reset */
 	pci_write_config_byte(dev, 0x44, 0x1);
 	udelay(50); /* shouldn't get here but be safe and spin-a-while */
-	return;
 }
 
 static void cs5536_warm_reset(struct pci_dev *dev)
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 1168e44..537a7d3 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -581,8 +581,6 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 	if (tsk->thread.debugreg6 & (DR_STEP | DR_TRAP_BITS))
 		send_sigtrap(tsk, regs, error_code, si_code);
 	preempt_conditional_cli(regs);
-
-	return;
 }
 
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/kernel/vsmp_64.c b/arch/x86/kernel/vsmp_64.c
index a1d804b..85fdd33 100644
--- a/arch/x86/kernel/vsmp_64.c
+++ b/arch/x86/kernel/vsmp_64.c
@@ -156,5 +156,4 @@ void __init vsmp_init(void)
 		return;
 
 	set_vsmp_pv_ops();
-	return;
 }
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 19a8906..dc189b1 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3218,7 +3218,6 @@ static void mmu_spte_walk(struct kvm_vcpu *vcpu, inspect_spte_fn fn)
 			__mmu_spte_walk(vcpu->kvm, sp, fn);
 		}
 	}
-	return;
 }
 
 static void audit_mappings_page(struct kvm_vcpu *vcpu, u64 page_pte,
@@ -3376,7 +3375,6 @@ static void check_writable_mappings_rmap(struct kvm_vcpu *vcpu)
 			inspect_spte_has_rmap(vcpu->kvm, sp, &pt[i]);
 		}
 	}
-	return;
 }
 
 static void audit_rmap(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3c4ca98..cf7835c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -478,7 +478,6 @@ void kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	vcpu->arch.cr0 = cr0;
 
 	kvm_mmu_reset_context(vcpu);
-	return;
 }
 EXPORT_SYMBOL_GPL(kvm_set_cr0);
 
diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index 2bdf628..aed5780 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -1077,7 +1077,6 @@ static void lguest_apic_icr_write(u32 low, u32 id)
 
 static void lguest_apic_wait_icr_idle(void)
 {
-	return;
 }
 
 static u32 lguest_apic_safe_wait_icr_idle(void)
diff --git a/arch/x86/lib/insn.c b/arch/x86/lib/insn.c
index 9f33b98..9068594 100644
--- a/arch/x86/lib/insn.c
+++ b/arch/x86/lib/insn.c
@@ -158,7 +158,6 @@ vex_end:
 	insn->vex_prefix.got = 1;
 
 	prefixes->got = 1;
-	return;
 }
 
 /**
diff --git a/arch/x86/math-emu/fpu_trig.c b/arch/x86/math-emu/fpu_trig.c
index ecd0668..ec312c3 100644
--- a/arch/x86/math-emu/fpu_trig.c
+++ b/arch/x86/math-emu/fpu_trig.c
@@ -173,7 +173,6 @@ static void convert_l2reg(long const *arg, int deststnr)
 	tag = FPU_normalize(dest);
 	FPU_settagi(deststnr, tag);
 	setsign(dest, sign);
-	return;
 }
 
 static void single_arg_error(FPU_REG *st0_ptr, u_char st0_tag)
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 12e4d2d..1141627 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -332,7 +332,6 @@ void unxlate_dev_mem_ptr(unsigned long phys, void *addr)
 		return;
 
 	iounmap((void __iomem *)((unsigned long)addr & PAGE_MASK));
-	return;
 }
 
 static int __initdata early_ioremap_debug;
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 65d8d79..6c12c3d 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -711,7 +711,6 @@ static void xen_apic_icr_write(u32 low, u32 id)
 
 static void xen_apic_wait_icr_idle(void)
 {
-        return;
 }
 
 static u32 xen_safe_apic_wait_icr_idle(void)


