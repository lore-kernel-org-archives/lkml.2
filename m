Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab1AIWHy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 17:07:54 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:41163 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753092Ab1AIWFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 17:05:44 -0500
Message-Id: <20110109220509.588717286@efficios.com>
User-Agent: quilt/0.48-1
Date: Sun, 09 Jan 2011 16:59:36 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Gleb Natapov <gleb@redhat.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Alexander Graf <agraf@suse.de>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Vadim Rozenfeld <vrozenfe@redhat.com>
Subject: [RFC patch 09/28] trace event kvm remove semicolons
References: <20110109215927.633266833@efficios.com>
Content-Disposition: inline; filename=trace-event-kvm-remove-semicolons.patch
X-Poly-FromMTA: (test.dorsal.polymtl.ca [132.207.72.60]) at Sun,  9 Jan 2011 22:05:09 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Part of the gradual TRACE_EVENT() semicolon removal. Enables creation of array
of events, thus saving space for trace event probes.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Gleb Natapov <gleb@redhat.com>
CC: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>
CC: Joerg Roedel <joerg.roedel@amd.com>
CC: Vadim Rozenfeld <vrozenfe@redhat.com>
---
 arch/powerpc/kvm/trace.h   |   28 ++++++++++++++--------------
 arch/x86/kvm/mmutrace.h    |   24 ++++++++++++------------
 arch/x86/kvm/trace.h       |   44 ++++++++++++++++++++++----------------------
 include/trace/events/kvm.h |   14 +++++++-------
 4 files changed, 55 insertions(+), 55 deletions(-)

Index: linux-2.6-lttng/include/trace/events/kvm.h
===================================================================
--- linux-2.6-lttng.orig/include/trace/events/kvm.h
+++ linux-2.6-lttng/include/trace/events/kvm.h
@@ -25,7 +25,7 @@ TRACE_EVENT(kvm_set_irq,
 
 	TP_printk("gsi %u level %d source %d",
 		  __entry->gsi, __entry->level, __entry->irq_source_id)
-);
+)
 
 #define kvm_deliver_mode		\
 	{0x0, "Fixed"},			\
@@ -60,7 +60,7 @@ TRACE_EVENT(kvm_ioapic_set_irq,
 		  (__entry->e & (1<<15)) ? "level" : "edge",
 		  (__entry->e & (1<<16)) ? "|masked" : "",
 		  __entry->coalesced ? " (coalesced)" : "")
-);
+)
 
 TRACE_EVENT(kvm_msi_set_irq,
 	    TP_PROTO(__u64 address, __u64 data),
@@ -82,7 +82,7 @@ TRACE_EVENT(kvm_msi_set_irq,
 		  (__entry->address & (1<<2)) ? "logical" : "physical",
 		  (__entry->data & (1<<15)) ? "level" : "edge",
 		  (__entry->address & (1<<3)) ? "|rh" : "")
-);
+)
 
 #define kvm_irqchips						\
 	{KVM_IRQCHIP_PIC_MASTER,	"PIC master"},		\
@@ -106,7 +106,7 @@ TRACE_EVENT(kvm_ack_irq,
 	TP_printk("irqchip %s pin %u",
 		  __print_symbolic(__entry->irqchip, kvm_irqchips),
 		 __entry->pin)
-);
+)
 
 
 
@@ -142,7 +142,7 @@ TRACE_EVENT(kvm_mmio,
 	TP_printk("mmio %s len %u gpa 0x%llx val 0x%llx",
 		  __print_symbolic(__entry->type, kvm_trace_symbol_mmio),
 		  __entry->len, __entry->gpa, __entry->val)
-);
+)
 
 #define kvm_fpu_load_symbol	\
 	{0, "unload"},		\
@@ -161,7 +161,7 @@ TRACE_EVENT(kvm_fpu,
 	),
 
 	TP_printk("%s", __print_symbolic(__entry->load, kvm_fpu_load_symbol))
-);
+)
 
 TRACE_EVENT(kvm_age_page,
 	TP_PROTO(ulong hva, struct kvm_memory_slot *slot, int ref),
@@ -183,7 +183,7 @@ TRACE_EVENT(kvm_age_page,
 	TP_printk("hva %llx gfn %llx %s",
 		  __entry->hva, __entry->gfn,
 		  __entry->referenced ? "YOUNG" : "OLD")
-);
+)
 
 #endif /* _TRACE_KVM_MAIN_H */
 
Index: linux-2.6-lttng/arch/powerpc/kvm/trace.h
===================================================================
--- linux-2.6-lttng.orig/arch/powerpc/kvm/trace.h
+++ linux-2.6-lttng/arch/powerpc/kvm/trace.h
@@ -29,7 +29,7 @@ TRACE_EVENT(kvm_ppc_instr,
 
 	TP_printk("inst %u pc 0x%lx emulate %u\n",
 		  __entry->inst, __entry->pc, __entry->emulate)
-);
+)
 
 TRACE_EVENT(kvm_stlb_inval,
 	TP_PROTO(unsigned int stlb_index),
@@ -44,7 +44,7 @@ TRACE_EVENT(kvm_stlb_inval,
 	),
 
 	TP_printk("stlb_index %u", __entry->stlb_index)
-);
+)
 
 TRACE_EVENT(kvm_stlb_write,
 	TP_PROTO(unsigned int victim, unsigned int tid, unsigned int word0,
@@ -70,7 +70,7 @@ TRACE_EVENT(kvm_stlb_write,
 	TP_printk("victim %u tid %u w0 %u w1 %u w2 %u",
 		__entry->victim, __entry->tid, __entry->word0,
 		__entry->word1, __entry->word2)
-);
+)
 
 TRACE_EVENT(kvm_gtlb_write,
 	TP_PROTO(unsigned int gtlb_index, unsigned int tid, unsigned int word0,
@@ -96,7 +96,7 @@ TRACE_EVENT(kvm_gtlb_write,
 	TP_printk("gtlb_index %u tid %u w0 %u w1 %u w2 %u",
 		__entry->gtlb_index, __entry->tid, __entry->word0,
 		__entry->word1, __entry->word2)
-);
+)
 
 
 /*************************************************************************
@@ -128,7 +128,7 @@ TRACE_EVENT(kvm_book3s_exit,
 	TP_printk("exit=0x%x | pc=0x%lx | msr=0x%lx | dar=0x%lx | srr1=0x%lx",
 		  __entry->exit_nr, __entry->pc, __entry->msr, __entry->dar,
 		  __entry->srr1)
-);
+)
 
 TRACE_EVENT(kvm_book3s_reenter,
 	TP_PROTO(int r, struct kvm_vcpu *vcpu),
@@ -145,7 +145,7 @@ TRACE_EVENT(kvm_book3s_reenter,
 	),
 
 	TP_printk("reentry r=%d | pc=0x%lx", __entry->r, __entry->pc)
-);
+)
 
 #ifdef CONFIG_PPC_BOOK3S_64
 
@@ -177,7 +177,7 @@ TRACE_EVENT(kvm_book3s_64_mmu_map,
 	TP_printk("KVM: %c%c Map 0x%lx: [%lx] 0x%lx (0x%llx) -> %lx",
 		  __entry->flag_w, __entry->flag_x, __entry->eaddr,
 		  __entry->hpteg, __entry->va, __entry->vpage, __entry->hpaddr)
-);
+)
 
 #endif /* CONFIG_PPC_BOOK3S_64 */
 
@@ -208,7 +208,7 @@ TRACE_EVENT(kvm_book3s_mmu_map,
 	TP_printk("Map: hva=%llx pfn=%llx ea=%lx vp=%llx ra=%lx [%x]",
 		  __entry->host_va, __entry->pfn, __entry->eaddr,
 		  __entry->vpage, __entry->raddr, __entry->flags)
-);
+)
 
 TRACE_EVENT(kvm_book3s_mmu_invalidate,
 	TP_PROTO(struct hpte_cache *pte),
@@ -237,7 +237,7 @@ TRACE_EVENT(kvm_book3s_mmu_invalidate,
 	TP_printk("Flush: hva=%llx pfn=%llx ea=%lx vp=%llx ra=%lx [%x]",
 		  __entry->host_va, __entry->pfn, __entry->eaddr,
 		  __entry->vpage, __entry->raddr, __entry->flags)
-);
+)
 
 TRACE_EVENT(kvm_book3s_mmu_flush,
 	TP_PROTO(const char *type, struct kvm_vcpu *vcpu, unsigned long long p1,
@@ -260,7 +260,7 @@ TRACE_EVENT(kvm_book3s_mmu_flush,
 
 	TP_printk("Flush %d %sPTEs: %llx - %llx",
 		  __entry->count, __entry->type, __entry->p1, __entry->p2)
-);
+)
 
 TRACE_EVENT(kvm_book3s_slb_found,
 	TP_PROTO(unsigned long long gvsid, unsigned long long hvsid),
@@ -277,7 +277,7 @@ TRACE_EVENT(kvm_book3s_slb_found,
 	),
 
 	TP_printk("%llx -> %llx", __entry->gvsid, __entry->hvsid)
-);
+)
 
 TRACE_EVENT(kvm_book3s_slb_fail,
 	TP_PROTO(u16 sid_map_mask, unsigned long long gvsid),
@@ -295,7 +295,7 @@ TRACE_EVENT(kvm_book3s_slb_fail,
 
 	TP_printk("%x/%x: %llx", __entry->sid_map_mask,
 		  SID_MAP_MASK - __entry->sid_map_mask, __entry->gvsid)
-);
+)
 
 TRACE_EVENT(kvm_book3s_slb_map,
 	TP_PROTO(u16 sid_map_mask, unsigned long long gvsid,
@@ -316,7 +316,7 @@ TRACE_EVENT(kvm_book3s_slb_map,
 
 	TP_printk("%x: %llx -> %llx", __entry->sid_map_mask,
 		  __entry->guest_vsid, __entry->host_vsid)
-);
+)
 
 TRACE_EVENT(kvm_book3s_slbmte,
 	TP_PROTO(u64 slb_vsid, u64 slb_esid),
@@ -333,7 +333,7 @@ TRACE_EVENT(kvm_book3s_slbmte,
 	),
 
 	TP_printk("%llx, %llx", __entry->slb_vsid, __entry->slb_esid)
-);
+)
 
 #endif /* CONFIG_PPC_BOOK3S */
 
Index: linux-2.6-lttng/arch/x86/kvm/trace.h
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kvm/trace.h
+++ linux-2.6-lttng/arch/x86/kvm/trace.h
@@ -22,7 +22,7 @@ TRACE_EVENT(kvm_entry,
 	),
 
 	TP_printk("vcpu %u", __entry->vcpu_id)
-);
+)
 
 /*
  * Tracepoint for hypercall.
@@ -51,7 +51,7 @@ TRACE_EVENT(kvm_hypercall,
 	TP_printk("nr 0x%lx a0 0x%lx a1 0x%lx a2 0x%lx a3 0x%lx",
 		 __entry->nr, __entry->a0, __entry->a1,  __entry->a2,
 		 __entry->a3)
-);
+)
 
 /*
  * Tracepoint for hypercall.
@@ -83,7 +83,7 @@ TRACE_EVENT(kvm_hv_hypercall,
 		  __entry->code, __entry->fast ? "fast" : "slow",
 		  __entry->rep_cnt, __entry->rep_idx,  __entry->ingpa,
 		  __entry->outgpa)
-);
+)
 
 /*
  * Tracepoint for PIO.
@@ -110,7 +110,7 @@ TRACE_EVENT(kvm_pio,
 	TP_printk("pio_%s at 0x%x size %d count %d",
 		  __entry->rw ? "write" : "read",
 		  __entry->port, __entry->size, __entry->count)
-);
+)
 
 /*
  * Tracepoint for cpuid.
@@ -139,7 +139,7 @@ TRACE_EVENT(kvm_cpuid,
 	TP_printk("func %x rax %lx rbx %lx rcx %lx rdx %lx",
 		  __entry->function, __entry->rax,
 		  __entry->rbx, __entry->rcx, __entry->rdx)
-);
+)
 
 #define AREG(x) { APIC_##x, "APIC_" #x }
 
@@ -173,7 +173,7 @@ TRACE_EVENT(kvm_apic,
 		  __entry->rw ? "write" : "read",
 		  __print_symbolic(__entry->reg, kvm_trace_symbol_apic),
 		  __entry->val)
-);
+)
 
 #define trace_kvm_apic_read(reg, val)		trace_kvm_apic(0, reg, val)
 #define trace_kvm_apic_write(reg, val)		trace_kvm_apic(1, reg, val)
@@ -199,7 +199,7 @@ TRACE_EVENT(kvm_exit,
 		 ftrace_print_symbols_seq(p, __entry->exit_reason,
 					  kvm_x86_ops->exit_reasons_str),
 		 __entry->guest_rip)
-);
+)
 
 /*
  * Tracepoint for kvm interrupt injection:
@@ -217,7 +217,7 @@ TRACE_EVENT(kvm_inj_virq,
 	),
 
 	TP_printk("irq %u", __entry->irq)
-);
+)
 
 #define EXS(x) { x##_VECTOR, "#" #x }
 
@@ -249,7 +249,7 @@ TRACE_EVENT(kvm_inj_exception,
 		  __print_symbolic(__entry->exception, kvm_trace_sym_exc),
 		  /* FIXME: don't print error_code if not present */
 		  __entry->has_error ? __entry->error_code : 0)
-);
+)
 
 /*
  * Tracepoint for page fault.
@@ -270,7 +270,7 @@ TRACE_EVENT(kvm_page_fault,
 
 	TP_printk("address %lx error_code %x",
 		  __entry->fault_address, __entry->error_code)
-);
+)
 
 /*
  * Tracepoint for guest MSR access.
@@ -297,7 +297,7 @@ TRACE_EVENT(kvm_msr,
 		  __entry->write ? "write" : "read",
 		  __entry->ecx, __entry->data,
 		  __entry->exception ? " (#GP)" : "")
-);
+)
 
 #define trace_kvm_msr_read(ecx, data)      trace_kvm_msr(0, ecx, data, false)
 #define trace_kvm_msr_write(ecx, data)     trace_kvm_msr(1, ecx, data, false)
@@ -326,7 +326,7 @@ TRACE_EVENT(kvm_cr,
 	TP_printk("cr_%s %x = 0x%lx",
 		  __entry->rw ? "write" : "read",
 		  __entry->cr, __entry->val)
-);
+)
 
 #define trace_kvm_cr_read(cr, val)		trace_kvm_cr(0, cr, val)
 #define trace_kvm_cr_write(cr, val)		trace_kvm_cr(1, cr, val)
@@ -356,7 +356,7 @@ TRACE_EVENT(kvm_pic_set_irq,
 		  (__entry->elcr & (1 << __entry->pin)) ? "level":"edge",
 		  (__entry->imr & (1 << __entry->pin)) ? "|masked":"",
 		  __entry->coalesced ? " (coalesced)" : "")
-);
+)
 
 #define kvm_apic_dst_shorthand		\
 	{0x0, "dst"},			\
@@ -387,7 +387,7 @@ TRACE_EVENT(kvm_apic_ipi,
 		  (__entry->icr_low & (1<<15)) ? "level" : "edge",
 		  __print_symbolic((__entry->icr_low >> 18 & 0x3),
 				   kvm_apic_dst_shorthand))
-);
+)
 
 TRACE_EVENT(kvm_apic_accept_irq,
 	    TP_PROTO(__u32 apicid, __u16 dm, __u8 tm, __u8 vec, bool coalesced),
@@ -414,7 +414,7 @@ TRACE_EVENT(kvm_apic_accept_irq,
 		  __print_symbolic((__entry->dm >> 8 & 0x7), kvm_deliver_mode),
 		  __entry->tm ? "level" : "edge",
 		  __entry->coalesced ? " (coalesced)" : "")
-);
+)
 
 /*
  * Tracepoint for nested VMRUN
@@ -447,7 +447,7 @@ TRACE_EVENT(kvm_nested_vmrun,
 		__entry->rip, __entry->vmcb, __entry->nested_rip,
 		__entry->int_ctl, __entry->event_inj,
 		__entry->npt ? "on" : "off")
-);
+)
 
 TRACE_EVENT(kvm_nested_intercepts,
 	    TP_PROTO(__u16 cr_read, __u16 cr_write, __u32 exceptions, __u64 intercept),
@@ -470,7 +470,7 @@ TRACE_EVENT(kvm_nested_intercepts,
 	TP_printk("cr_read: %04x cr_write: %04x excp: %08x intercept: %016llx",
 		__entry->cr_read, __entry->cr_write, __entry->exceptions,
 		__entry->intercept)
-);
+)
 /*
  * Tracepoint for #VMEXIT while nested
  */
@@ -505,7 +505,7 @@ TRACE_EVENT(kvm_nested_vmexit,
 					   kvm_x86_ops->exit_reasons_str),
 		  __entry->exit_info1, __entry->exit_info2,
 		  __entry->exit_int_info, __entry->exit_int_info_err)
-);
+)
 
 /*
  * Tracepoint for #VMEXIT reinjected to the guest
@@ -539,7 +539,7 @@ TRACE_EVENT(kvm_nested_vmexit_inject,
 					   kvm_x86_ops->exit_reasons_str),
 		__entry->exit_info1, __entry->exit_info2,
 		__entry->exit_int_info, __entry->exit_int_info_err)
-);
+)
 
 /*
  * Tracepoint for nested #vmexit because of interrupt pending
@@ -557,7 +557,7 @@ TRACE_EVENT(kvm_nested_intr_vmexit,
 	),
 
 	TP_printk("rip: 0x%016llx", __entry->rip)
-);
+)
 
 /*
  * Tracepoint for nested #vmexit because of interrupt pending
@@ -580,7 +580,7 @@ TRACE_EVENT(kvm_invlpga,
 
 	TP_printk("rip: 0x%016llx asid: %d address: 0x%016llx",
 		  __entry->rip, __entry->asid, __entry->address)
-);
+)
 
 /*
  * Tracepoint for nested #vmexit because of interrupt pending
@@ -601,7 +601,7 @@ TRACE_EVENT(kvm_skinit,
 
 	TP_printk("rip: 0x%016llx slb: 0x%08x",
 		  __entry->rip, __entry->slb)
-);
+)
 
 #define __print_insn(insn, ilen) ({		                 \
 	int i;							 \
Index: linux-2.6-lttng/arch/x86/kvm/mmutrace.h
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kvm/mmutrace.h
+++ linux-2.6-lttng/arch/x86/kvm/mmutrace.h
@@ -70,7 +70,7 @@ TRACE_EVENT(
 
 	TP_printk("addr %llx pferr %x %s", __entry->addr, __entry->pferr,
 		  __print_flags(__entry->pferr, "|", kvm_mmu_trace_pferr_flags))
-);
+)
 
 
 /* We just walked a paging element */
@@ -90,7 +90,7 @@ TRACE_EVENT(
 		),
 
 	TP_printk("pte %llx level %u", __entry->pte, __entry->level)
-);
+)
 
 DECLARE_EVENT_CLASS(kvm_mmu_set_bit_class,
 
@@ -108,7 +108,7 @@ DECLARE_EVENT_CLASS(kvm_mmu_set_bit_clas
 		),
 
 	TP_printk("gpa %llx", __entry->gpa)
-);
+)
 
 /* We set a pte accessed bit */
 DEFINE_EVENT(kvm_mmu_set_bit_class, kvm_mmu_set_accessed_bit,
@@ -116,7 +116,7 @@ DEFINE_EVENT(kvm_mmu_set_bit_class, kvm_
 	TP_PROTO(unsigned long table_gfn, unsigned index, unsigned size),
 
 	TP_ARGS(table_gfn, index, size)
-);
+)
 
 /* We set a pte dirty bit */
 DEFINE_EVENT(kvm_mmu_set_bit_class, kvm_mmu_set_dirty_bit,
@@ -124,7 +124,7 @@ DEFINE_EVENT(kvm_mmu_set_bit_class, kvm_
 	TP_PROTO(unsigned long table_gfn, unsigned index, unsigned size),
 
 	TP_ARGS(table_gfn, index, size)
-);
+)
 
 TRACE_EVENT(
 	kvm_mmu_walker_error,
@@ -141,7 +141,7 @@ TRACE_EVENT(
 
 	TP_printk("pferr %x %s", __entry->pferr,
 		  __print_flags(__entry->pferr, "|", kvm_mmu_trace_pferr_flags))
-);
+)
 
 TRACE_EVENT(
 	kvm_mmu_get_page,
@@ -160,7 +160,7 @@ TRACE_EVENT(
 
 	TP_printk("%s %s", KVM_MMU_PAGE_PRINTK(),
 		  __entry->created ? "new" : "existing")
-);
+)
 
 DECLARE_EVENT_CLASS(kvm_mmu_page_class,
 
@@ -176,25 +176,25 @@ DECLARE_EVENT_CLASS(kvm_mmu_page_class,
 	),
 
 	TP_printk("%s", KVM_MMU_PAGE_PRINTK())
-);
+)
 
 DEFINE_EVENT(kvm_mmu_page_class, kvm_mmu_sync_page,
 	TP_PROTO(struct kvm_mmu_page *sp),
 
 	TP_ARGS(sp)
-);
+)
 
 DEFINE_EVENT(kvm_mmu_page_class, kvm_mmu_unsync_page,
 	TP_PROTO(struct kvm_mmu_page *sp),
 
 	TP_ARGS(sp)
-);
+)
 
 DEFINE_EVENT(kvm_mmu_page_class, kvm_mmu_prepare_zap_page,
 	TP_PROTO(struct kvm_mmu_page *sp),
 
 	TP_ARGS(sp)
-);
+)
 
 TRACE_EVENT(
 	kvm_mmu_audit,
@@ -213,7 +213,7 @@ TRACE_EVENT(
 
 	TP_printk("vcpu:%d %s", __entry->vcpu->cpu,
 		  audit_point_name[__entry->audit_point])
-);
+)
 #endif /* _TRACE_KVMMMU_H */
 
 #undef TRACE_INCLUDE_PATH

