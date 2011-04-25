Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751186Ab1DYFAx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 01:00:53 -0400
Received: from mail.perches.com ([173.55.12.10]:4944 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801Ab1DYFAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 01:00:51 -0400
From: Joe Perches <joe@perches.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: SVM: Make dump_vmcb static, reduce text
Date: Sun, 24 Apr 2011 22:00:50 -0700
Message-Id: <78024a3a74353a4d73be69b4e4f42da942b8fe15.1303707337.git.joe@perches.com>
X-Mailer: git-send-email 1.7.5.rc3.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dump_vmcb isn't used outside this module, make it static.
Shrink text and object by ~1% by standardizing formats.

$ size arch/x86/kvm/svm.o*
   text	   data	    bss	    dec	    hex	filename
  52910	    580	  10072	  63562	   f84a	arch/x86/kvm/svm.o.new
  53563	    580	  10072	  64215	   fad7	arch/x86/kvm/svm.o.old

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/x86/kvm/svm.c |  176 ++++++++++++++++++++++++++++------------------------
 1 files changed, 94 insertions(+), 82 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index a6bf2ad..1b9f67e 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3188,97 +3188,109 @@ static int (*svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_NPF]				= pf_interception,
 };
 
-void dump_vmcb(struct kvm_vcpu *vcpu)
+static void dump_vmcb(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct vmcb_control_area *control = &svm->vmcb->control;
 	struct vmcb_save_area *save = &svm->vmcb->save;
 
 	pr_err("VMCB Control Area:\n");
-	pr_err("cr_read:            %04x\n", control->intercept_cr & 0xffff);
-	pr_err("cr_write:           %04x\n", control->intercept_cr >> 16);
-	pr_err("dr_read:            %04x\n", control->intercept_dr & 0xffff);
-	pr_err("dr_write:           %04x\n", control->intercept_dr >> 16);
-	pr_err("exceptions:         %08x\n", control->intercept_exceptions);
-	pr_err("intercepts:         %016llx\n", control->intercept);
-	pr_err("pause filter count: %d\n", control->pause_filter_count);
-	pr_err("iopm_base_pa:       %016llx\n", control->iopm_base_pa);
-	pr_err("msrpm_base_pa:      %016llx\n", control->msrpm_base_pa);
-	pr_err("tsc_offset:         %016llx\n", control->tsc_offset);
-	pr_err("asid:               %d\n", control->asid);
-	pr_err("tlb_ctl:            %d\n", control->tlb_ctl);
-	pr_err("int_ctl:            %08x\n", control->int_ctl);
-	pr_err("int_vector:         %08x\n", control->int_vector);
-	pr_err("int_state:          %08x\n", control->int_state);
-	pr_err("exit_code:          %08x\n", control->exit_code);
-	pr_err("exit_info1:         %016llx\n", control->exit_info_1);
-	pr_err("exit_info2:         %016llx\n", control->exit_info_2);
-	pr_err("exit_int_info:      %08x\n", control->exit_int_info);
-	pr_err("exit_int_info_err:  %08x\n", control->exit_int_info_err);
-	pr_err("nested_ctl:         %lld\n", control->nested_ctl);
-	pr_err("nested_cr3:         %016llx\n", control->nested_cr3);
-	pr_err("event_inj:          %08x\n", control->event_inj);
-	pr_err("event_inj_err:      %08x\n", control->event_inj_err);
-	pr_err("lbr_ctl:            %lld\n", control->lbr_ctl);
-	pr_err("next_rip:           %016llx\n", control->next_rip);
+	pr_err("%-20s%04x\n", "cr_read:", control->intercept_cr & 0xffff);
+	pr_err("%-20s%04x\n", "cr_write:", control->intercept_cr >> 16);
+	pr_err("%-20s%04x\n", "dr_read:", control->intercept_dr & 0xffff);
+	pr_err("%-20s%04x\n", "dr_write:", control->intercept_dr >> 16);
+	pr_err("%-20s%08x\n", "exceptions:", control->intercept_exceptions);
+	pr_err("%-20s%016llx\n", "intercepts:", control->intercept);
+	pr_err("%-20s%d\n", "pause filter count:", control->pause_filter_count);
+	pr_err("%-20s%016llx\n", "iopm_base_pa:", control->iopm_base_pa);
+	pr_err("%-20s%016llx\n", "msrpm_base_pa:", control->msrpm_base_pa);
+	pr_err("%-20s%016llx\n", "tsc_offset:", control->tsc_offset);
+	pr_err("%-20s%d\n", "asid:", control->asid);
+	pr_err("%-20s%d\n", "tlb_ctl:", control->tlb_ctl);
+	pr_err("%-20s%08x\n", "int_ctl:", control->int_ctl);
+	pr_err("%-20s%08x\n", "int_vector:", control->int_vector);
+	pr_err("%-20s%08x\n", "int_state:", control->int_state);
+	pr_err("%-20s%08x\n", "exit_code:", control->exit_code);
+	pr_err("%-20s%016llx\n", "exit_info1:", control->exit_info_1);
+	pr_err("%-20s%016llx\n", "exit_info2:", control->exit_info_2);
+	pr_err("%-20s%08x\n", "exit_int_info:", control->exit_int_info);
+	pr_err("%-20s%08x\n", "exit_int_info_err:", control->exit_int_info_err);
+	pr_err("%-20s%lld\n", "nested_ctl:", control->nested_ctl);
+	pr_err("%-20s%016llx\n", "nested_cr3:", control->nested_cr3);
+	pr_err("%-20s%08x\n", "event_inj:", control->event_inj);
+	pr_err("%-20s%08x\n", "event_inj_err:", control->event_inj_err);
+	pr_err("%-20s%lld\n", "lbr_ctl:", control->lbr_ctl);
+	pr_err("%-20s%016llx\n", "next_rip:", control->next_rip);
 	pr_err("VMCB State Save Area:\n");
-	pr_err("es:   s: %04x a: %04x l: %08x b: %016llx\n",
-		save->es.selector, save->es.attrib,
-		save->es.limit, save->es.base);
-	pr_err("cs:   s: %04x a: %04x l: %08x b: %016llx\n",
-		save->cs.selector, save->cs.attrib,
-		save->cs.limit, save->cs.base);
-	pr_err("ss:   s: %04x a: %04x l: %08x b: %016llx\n",
-		save->ss.selector, save->ss.attrib,
-		save->ss.limit, save->ss.base);
-	pr_err("ds:   s: %04x a: %04x l: %08x b: %016llx\n",
-		save->ds.selector, save->ds.attrib,
-		save->ds.limit, save->ds.base);
-	pr_err("fs:   s: %04x a: %04x l: %08x b: %016llx\n",
-		save->fs.selector, save->fs.attrib,
-		save->fs.limit, save->fs.base);
-	pr_err("gs:   s: %04x a: %04x l: %08x b: %016llx\n",
-		save->gs.selector, save->gs.attrib,
-		save->gs.limit, save->gs.base);
-	pr_err("gdtr: s: %04x a: %04x l: %08x b: %016llx\n",
-		save->gdtr.selector, save->gdtr.attrib,
-		save->gdtr.limit, save->gdtr.base);
-	pr_err("ldtr: s: %04x a: %04x l: %08x b: %016llx\n",
-		save->ldtr.selector, save->ldtr.attrib,
-		save->ldtr.limit, save->ldtr.base);
-	pr_err("idtr: s: %04x a: %04x l: %08x b: %016llx\n",
-		save->idtr.selector, save->idtr.attrib,
-		save->idtr.limit, save->idtr.base);
-	pr_err("tr:   s: %04x a: %04x l: %08x b: %016llx\n",
-		save->tr.selector, save->tr.attrib,
-		save->tr.limit, save->tr.base);
+	pr_err("%-5s s: %04x a: %04x l: %08x b: %016llx\n",
+	       "es:",
+	       save->es.selector, save->es.attrib,
+	       save->es.limit, save->es.base);
+	pr_err("%-5s s: %04x a: %04x l: %08x b: %016llx\n",
+	       "cs:",
+	       save->cs.selector, save->cs.attrib,
+	       save->cs.limit, save->cs.base);
+	pr_err("%-5s s: %04x a: %04x l: %08x b: %016llx\n",
+	       "ss:",
+	       save->ss.selector, save->ss.attrib,
+	       save->ss.limit, save->ss.base);
+	pr_err("%-5s s: %04x a: %04x l: %08x b: %016llx\n",
+	       "ds:",
+	       save->ds.selector, save->ds.attrib,
+	       save->ds.limit, save->ds.base);
+	pr_err("%-5s s: %04x a: %04x l: %08x b: %016llx\n",
+	       "fs:",
+	       save->fs.selector, save->fs.attrib,
+	       save->fs.limit, save->fs.base);
+	pr_err("%-5s s: %04x a: %04x l: %08x b: %016llx\n",
+	       "gs:",
+	       save->gs.selector, save->gs.attrib,
+	       save->gs.limit, save->gs.base);
+	pr_err("%-5s s: %04x a: %04x l: %08x b: %016llx\n",
+	       "gdtr:",
+	       save->gdtr.selector, save->gdtr.attrib,
+	       save->gdtr.limit, save->gdtr.base);
+	pr_err("%-5s s: %04x a: %04x l: %08x b: %016llx\n",
+	       "ldtr:",
+	       save->ldtr.selector, save->ldtr.attrib,
+	       save->ldtr.limit, save->ldtr.base);
+	pr_err("%-5s s: %04x a: %04x l: %08x b: %016llx\n",
+	       "idtr:",
+	       save->idtr.selector, save->idtr.attrib,
+	       save->idtr.limit, save->idtr.base);
+	pr_err("%-5s s: %04x a: %04x l: %08x b: %016llx\n",
+	       "tr:",
+	       save->tr.selector, save->tr.attrib,
+	       save->tr.limit, save->tr.base);
 	pr_err("cpl:            %d                efer:         %016llx\n",
 		save->cpl, save->efer);
-	pr_err("cr0:            %016llx cr2:          %016llx\n",
-		save->cr0, save->cr2);
-	pr_err("cr3:            %016llx cr4:          %016llx\n",
-		save->cr3, save->cr4);
-	pr_err("dr6:            %016llx dr7:          %016llx\n",
-		save->dr6, save->dr7);
-	pr_err("rip:            %016llx rflags:       %016llx\n",
-		save->rip, save->rflags);
-	pr_err("rsp:            %016llx rax:          %016llx\n",
-		save->rsp, save->rax);
-	pr_err("star:           %016llx lstar:        %016llx\n",
-		save->star, save->lstar);
-	pr_err("cstar:          %016llx sfmask:       %016llx\n",
-		save->cstar, save->sfmask);
-	pr_err("kernel_gs_base: %016llx sysenter_cs:  %016llx\n",
-		save->kernel_gs_base, save->sysenter_cs);
-	pr_err("sysenter_esp:   %016llx sysenter_eip: %016llx\n",
-		save->sysenter_esp, save->sysenter_eip);
-	pr_err("gpat:           %016llx dbgctl:       %016llx\n",
-		save->g_pat, save->dbgctl);
-	pr_err("br_from:        %016llx br_to:        %016llx\n",
-		save->br_from, save->br_to);
-	pr_err("excp_from:      %016llx excp_to:      %016llx\n",
-		save->last_excp_from, save->last_excp_to);
-
+	pr_err("%-15s %016llx %-13s %016llx\n",
+	       "cr0:", save->cr0, "cr2:", save->cr2);
+	pr_err("%-15s %016llx %-13s %016llx\n",
+	       "cr3:", save->cr3, "cr4:", save->cr4);
+	pr_err("%-15s %016llx %-13s %016llx\n",
+	       "dr6:", save->dr6, "dr7:", save->dr7);
+	pr_err("%-15s %016llx %-13s %016llx\n",
+	       "rip:", save->rip, "rflags:", save->rflags);
+	pr_err("%-15s %016llx %-13s %016llx\n",
+	       "rsp:", save->rsp, "rax:", save->rax);
+	pr_err("%-15s %016llx %-13s %016llx\n",
+	       "star:", save->star, "lstar:", save->lstar);
+	pr_err("%-15s %016llx %-13s %016llx\n",
+	       "cstar:", save->cstar, "sfmask:", save->sfmask);
+	pr_err("%-15s %016llx %-13s %016llx\n",
+	       "kernel_gs_base:", save->kernel_gs_base,
+	       "sysenter_cs:", save->sysenter_cs);
+	pr_err("%-15s %016llx %-13s %016llx\n",
+	       "sysenter_esp:", save->sysenter_esp,
+	       "sysenter_eip:", save->sysenter_eip);
+	pr_err("%-15s %016llx %-13s %016llx\n",
+	       "gpat:", save->g_pat, "dbgctl:", save->dbgctl);
+	pr_err("%-15s %016llx %-13s %016llx\n",
+	       "br_from:", save->br_from, "br_to:", save->br_to);
+	pr_err("%-15s %016llx %-13s %016llx\n",
+	       "excp_from:", save->last_excp_from,
+	       "excp_to:", save->last_excp_to);
 }
 
 static void svm_get_exit_info(struct kvm_vcpu *vcpu, u64 *info1, u64 *info2)
-- 
1.7.5.rc3.dirty

