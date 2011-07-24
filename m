Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab1GXMxk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 08:53:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22214 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752625Ab1GXMxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 08:53:33 -0400
Message-ID: <4E2C15C4.30402@redhat.com>
Date: Sun, 24 Jul 2011 15:53:24 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Thunderbird/3.1.11
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [GIT PULL] KVM updates for the Linux 3.1 merge window
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

   git://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/3.1

to get the KVM updates for the current merge window.  Major features 
include powerpc hypervisor-mode support and an initial version of VMX 
nesting.  Other changes include steal time support (both host and 
guest), faster MMIO, and additional cpu features exposed to the guest 
(most importantly SMEP).

[The steal time changes touch the core scheduler; these changes have 
been acked by Peter]

Alex Williamson (1):
       KVM: IOMMU: Disable device assignment without interrupt remapping

Alexander Graf (3):
       KVM: Add compat ioctl for KVM_SET_SIGNAL_MASK
       KVM: PPC: Resolve real-mode handlers through function exports
       KVM: PPC: Remove prog_flags

Andre Przywara (1):
       KVM: fix XSAVE bit scanning (now properly)

Avi Kivity (8):
       KVM: Document KVM_GET_LAPIC, KVM_SET_LAPIC ioctl
       KVM: VMX: Move VMREAD cleanup to exception handler
       KVM: VMX: always_inline VMREADs
       KVM: Sanitize cpuid
       KVM: x86 emulator: rename decode_cache::eip to _eip
       KVM: x86 emulator: fold decode_cache into x86_emulate_ctxt
       KVM: MMU: Adjust shadow paging to work when SMEP=1 and CR0.WP=0
       KVM: MMU: make kvm_mmu_reset_context() flush the guest TLB

David Gibson (1):
       KVM: PPC: Accelerate H_PUT_TCE by implementing it in real mode

Glauber Costa (8):
       KVM: Add constant to represent KVM MSRs enabled bit in guest/host 
interface
       KVM: KVM Steal time guest/host interface
       KVM: Steal time implementation
       KVM guest: Add a pv_ops stub for steal time
       ia64: add jump labels for paravirt
       KVM guest: Steal time accounting
       sched: adjust scheduler cpu power for stolen time
       KVM guest: KVM Steal time registration

Gleb Natapov (1):
       KVM: introduce kvm_read_guest_cached

Jan Kiszka (6):
       KVM: Clean up error handling during VCPU creation
       KVM: VMX: Silence warning on 32-bit hosts
       KVM: Fixup documentation section numbering
       KVM: Clarify KVM_ASSIGN_PCI_DEVICE documentation
       KVM: Fix off-by-one in overflow check of KVM_ASSIGN_SET_MSIX_NR
       KVM: Fix KVM_ASSIGN_SET_MSIX_ENTRY documentation

Liu Yu (2):
       KVM: PPC: e500: Stop keeping shadow TLB
       KVM: PPC: e500: Add shadow PID support

Marcelo Tosatti (1):
       Revert "KVM: MMU: make kvm_mmu_reset_context() flush the guest TLB"

Nadav Har'El (32):
       KVM: VMX: Keep list of loaded VMCSs, instead of vcpus
       KVM: nVMX: Add "nested" module option to kvm_intel
       KVM: nVMX: Implement VMXON and VMXOFF
       KVM: nVMX: Allow setting the VMXE bit in CR4
       KVM: nVMX: Introduce vmcs12: a VMCS structure for L1
       KVM: nVMX: Implement reading and writing of VMX MSRs
       KVM: nVMX: Decoding memory operands of VMX instructions
       KVM: nVMX: Introduce vmcs02: VMCS used to run L2
       KVM: nVMX: Add VMCS fields to the vmcs12
       KVM: nVMX: Success/failure of VMX instructions.
       KVM: nVMX: Implement VMCLEAR
       KVM: nVMX: Implement VMPTRLD
       KVM: nVMX: Implement VMPTRST
       KVM: nVMX: Implement VMREAD and VMWRITE
       KVM: nVMX: Move host-state field setup to a function
       KVM: nVMX: Move control field setup to functions
       KVM: nVMX: Prepare vmcs02 from vmcs01 and vmcs12
       KVM: nVMX: Implement VMLAUNCH and VMRESUME
       KVM: nVMX: No need for handle_vmx_insn function any more
       KVM: nVMX: Exiting from L2 to L1
       KVM: nVMX: vmcs12 checks on nested entry
       KVM: nVMX: Deciding if L0 or L1 should handle an L2 exit
       KVM: nVMX: Correct handling of interrupt injection
       KVM: nVMX: Correct handling of exception injection
       KVM: nVMX: Correct handling of idt vectoring info
       KVM: nVMX: Handling of CR0 and CR4 modifying instructions
       KVM: nVMX: Further fixes for lazy FPU loading
       KVM: nVMX: Additional TSC-offset handling
       KVM: nVMX: Add VMX to list of supported cpuid features
       KVM: nVMX: Miscellenous small corrections
       KVM: nVMX: Documentation
       KVM: nVMX: Fix bug preventing more than two levels of nesting

Paul Mackerras (15):
       KVM: PPC: Fix machine checks on 32-bit Book3S
       KVM: PPC: Move fields between struct kvm_vcpu_arch and 
kvmppc_vcpu_book3s
       KVM: PPC: Split out code from book3s.c into book3s_pr.c
       powerpc, KVM: Rework KVM checks in first-level interrupt handlers
       KVM: PPC: Deliver program interrupts right away instead of 
queueing them
       KVM: PPC: Pass init/destroy vm and prepare/commit memory region 
ops down
       KVM: PPC: Move guest enter/exit down into subarch-specific code
       powerpc: Set up LPCR for running guest partitions
       KVM: PPC: Split host-state fields out of kvmppc_book3s_shadow_vcpu
       KVM: PPC: Add support for Book3S processors in hypervisor mode
       KVM: PPC: Handle some PAPR hcalls in the kernel
       KVM: PPC: Allow book3s_hv guests to use SMT processor modes
       KVM: PPC: Allocate RMAs (Real Mode Areas) at boot for use by guests
       powerpc, KVM: Split HVMODE_206 cpu feature bit into separate HV 
and architecture bits
       KVM: PPC: book3s_hv: Add support for PPC970-family processors

Sasha Levin (1):
       KVM: Document KVM_IOEVENTFD

Scott Wood (9):
       powerpc/e500: SPE register saving: take arbitrary struct offset
       KVM: PPC: booke: use shadow_msr
       KVM: PPC: e500: Save/restore SPE state
       KVM: PPC: e500: Disable preloading TLB1 in tlb_load().
       KVM: PPC: e500: don't use MAS0 as intermediate storage.
       KVM: PPC: e500: Eliminate shadow_pages[], and use pfns instead.
       KVM: PPC: e500: Support large page mappings of PFNMAP vmas.
       KVM: PPC: e500: enable magic page
       KVM: PPC: e500: Don't search over the entire TLB0.

Stuart Yoder (1):
       KVM: PPC: fix partial application of "exit timing in ticks"

Takuya Yoshikawa (18):
       KVM: x86 emulator: Place insn_fetch helpers together
       KVM: x86 emulator: Stop passing ctxt->ops as arg of decode helpers
       KVM: x86 emulator: Stop passing ctxt->ops as arg of emul functions
       KVM: x86 emulator: Clean up init_emulate_ctxt()
       KVM: x86 emulator: Avoid clearing the whole decode_cache
       KVM: x86 emulator: Use the pointers ctxt and c consistently
       KVM: x86 emulator: Rename emulate_xxx() to em_xxx()
       KVM: x86 emulator: Use opcode::execute for some instructions
       KVM: x86 emulator: Use opcode::execute for TEST(84/85, A8/A9)
       KVM: x86 emulator: Use opcode::execute for XCHG(86/87)
       KVM: x86 emulator: Use opcode::execute for RET(C3)
       KVM: x86 emulator: Use opcode::execute for MOV(8C/8E)
       KVM: x86 emulator: Clean up INT n/INTO/INT 3(CC/CD/CE)
       KVM: x86 emulator: Use opcode::execute for LOOP/JCXZ
       KVM: x86 emulator: Use opcode::execute for CLI/STI(FA/FB)
       KVM: MMU: Clean up the error handling of walk_addr_generic()
       KVM: MMU: Rename the walk label in walk_addr_generic()
       KVM: MMU: Introduce is_last_gpte() to clean up walk_addr_generic()

Xiao Guangrong (25):
       KVM: MMU: optimize pte write path if don't have protected sp
       KVM: use __copy_to_user/__clear_user to write guest page
       KVM: fix uninitialized warning
       KVM: MMU: abstract the operation of rmap
       KVM: MMU: remove the arithmetic of parent pte rmap
       KVM: MMU: cleanup for kvm_mmu_page_unlink_children
       KVM: MMU: cleanup for dropping parent pte
       KVM: MMU: fix walking shadow page table
       KVM: MMU: do not update slot bitmap if spte is nonpresent
       KVM: x86: introduce vcpu_mmio_gva_to_gpa to cleanup the code
       KVM: MMU: cache mmio info on page fault path
       KVM: MMU: optimize to handle dirty bit
       KVM: MMU: cleanup for FNAME(fetch)
       KVM: MMU: rename 'pt_write' to 'emulate'
       KVM: MMU: count used shadow pages on prepareing path
       KVM: MMU: split kvm_mmu_free_page
       KVM: MMU: remove bypass_guest_pf
       KVM: MMU: filter out the mmio pfn from the fault pfn
       KVM: MMU: abstract some functions to handle fault pfn
       KVM: MMU: introduce the rules to modify shadow page table
       KVM: MMU: do not need atomicly to set/clear spte
       KVM: MMU: lockless walking shadow page table
       KVM: MMU: reorganize struct kvm_shadow_walk_iterator
       KVM: MMU: mmio page fault support
       KVM: MMU: trace mmio page fault

Yang, Wei (4):
       KVM: Remove RDWRGSFS bit from CR4_RESERVED_BITS
       KVM: Add RDWRGSFS support when setting CR4
       KVM: Expose RDWRGSFS bit to KVM guests
       KVM: Enable ERMS feature support for KVM

Yang, Wei Y (5):
       KVM: Remove SMEP bit from CR4_RESERVED_BITS
       KVM: Add SMEP support when setting CR4
       KVM: Mask function7 ebx against host capability word9
       KVM: Add instruction fetch checking when walking guest page table
       KVM: Enable DRNG feature support for KVM

yu liu (1):
       powerpc/e500: Save SPEFCSR in flush_spe_to_thread()

  Documentation/kernel-parameters.txt        |    8 +-
  Documentation/virtual/kvm/api.txt          |  172 ++-
  Documentation/virtual/kvm/mmu.txt          |   18 +
  Documentation/virtual/kvm/msr.txt          |   34 +
  Documentation/virtual/kvm/nested-vmx.txt   |  251 +++
  Documentation/virtual/kvm/ppc-pv.txt       |    8 +-
  arch/ia64/include/asm/paravirt.h           |    4 +
  arch/ia64/kernel/paravirt.c                |    2 +
  arch/powerpc/include/asm/cputable.h        |   14 +-
  arch/powerpc/include/asm/exception-64s.h   |  136 +-
  arch/powerpc/include/asm/hvcall.h          |    5 +
  arch/powerpc/include/asm/kvm.h             |   15 +
  arch/powerpc/include/asm/kvm_asm.h         |    4 +
  arch/powerpc/include/asm/kvm_book3s.h      |  196 ++-
  arch/powerpc/include/asm/kvm_book3s_64.h   |    4 +
  arch/powerpc/include/asm/kvm_book3s_asm.h  |   41 +-
  arch/powerpc/include/asm/kvm_booke.h       |    4 +
  arch/powerpc/include/asm/kvm_e500.h        |   30 +-
  arch/powerpc/include/asm/kvm_host.h        |  169 ++-
  arch/powerpc/include/asm/kvm_ppc.h         |   41 +
  arch/powerpc/include/asm/mmu-hash64.h      |   10 +-
  arch/powerpc/include/asm/paca.h            |    3 +
  arch/powerpc/include/asm/ppc_asm.h         |   28 +-
  arch/powerpc/include/asm/reg.h             |   25 +-
  arch/powerpc/include/asm/reg_booke.h       |    1 +
  arch/powerpc/kernel/asm-offsets.c          |  190 ++-
  arch/powerpc/kernel/cpu_setup_power7.S     |   22 +-
  arch/powerpc/kernel/cpu_setup_ppc970.S     |   26 +-
  arch/powerpc/kernel/exceptions-64s.S       |  228 ++-
  arch/powerpc/kernel/head_fsl_booke.S       |    8 +-
  arch/powerpc/kernel/idle_power7.S          |    2 -
  arch/powerpc/kernel/paca.c                 |    2 +-
  arch/powerpc/kernel/process.c              |    4 +
  arch/powerpc/kernel/setup-common.c         |    3 +
  arch/powerpc/kernel/setup_64.c             |    3 +
  arch/powerpc/kernel/smp.c                  |    1 +
  arch/powerpc/kernel/traps.c                |    5 +-
  arch/powerpc/kvm/44x_tlb.c                 |    4 +-
  arch/powerpc/kvm/Kconfig                   |   34 +-
  arch/powerpc/kvm/Makefile                  |   27 +-
  arch/powerpc/kvm/book3s.c                  | 1007 +---------
  arch/powerpc/kvm/book3s_64_mmu.c           |   54 +-
  arch/powerpc/kvm/book3s_64_mmu_hv.c        |  180 ++
  arch/powerpc/kvm/book3s_64_vio_hv.c        |   73 +
  arch/powerpc/kvm/book3s_exports.c          |    9 +-
  arch/powerpc/kvm/book3s_hv.c               | 1269 ++++++++++++
  arch/powerpc/kvm/book3s_hv_builtin.c       |  155 ++
  arch/powerpc/kvm/book3s_hv_interrupts.S    |  166 ++
  arch/powerpc/kvm/book3s_hv_rm_mmu.c        |  370 ++++
  arch/powerpc/kvm/book3s_hv_rmhandlers.S    | 1345 +++++++++++++
  arch/powerpc/kvm/book3s_interrupts.S       |   21 +-
  arch/powerpc/kvm/book3s_mmu_hpte.c         |   71 +-
  arch/powerpc/kvm/book3s_pr.c               | 1029 ++++++++++
  arch/powerpc/kvm/book3s_rmhandlers.S       |  102 +-
  arch/powerpc/kvm/book3s_segment.S          |  117 +-
  arch/powerpc/kvm/booke.c                   |  132 ++-
  arch/powerpc/kvm/booke.h                   |   23 +-
  arch/powerpc/kvm/booke_interrupts.S        |   66 +-
  arch/powerpc/kvm/e500.c                    |    7 +-
  arch/powerpc/kvm/e500_emulate.c            |    4 +
  arch/powerpc/kvm/e500_tlb.c                |  800 +++++---
  arch/powerpc/kvm/e500_tlb.h                |   13 +-
  arch/powerpc/kvm/powerpc.c                 |   78 +-
  arch/powerpc/kvm/timing.c                  |    9 -
  arch/powerpc/kvm/trace.h                   |    4 +-
  arch/powerpc/mm/hash_native_64.c           |    6 +-
  arch/powerpc/platforms/iseries/exception.S |    2 +-
  arch/powerpc/platforms/iseries/exception.h |    4 +-
  arch/powerpc/sysdev/xics/icp-native.c      |    9 +
  arch/x86/Kconfig                           |   12 +
  arch/x86/include/asm/kvm_emulate.h         |   52 +-
  arch/x86/include/asm/kvm_host.h            |   46 +-
  arch/x86/include/asm/kvm_para.h            |   20 +
  arch/x86/include/asm/msr-index.h           |   12 +
  arch/x86/include/asm/paravirt.h            |    9 +
  arch/x86/include/asm/paravirt_types.h      |    1 +
  arch/x86/include/asm/processor-flags.h     |    1 +
  arch/x86/include/asm/vmx.h                 |   43 +
  arch/x86/kernel/kvm.c                      |   72 +
  arch/x86/kernel/kvmclock.c                 |    2 +
  arch/x86/kernel/paravirt.c                 |    9 +
  arch/x86/kvm/Kconfig                       |    1 +
  arch/x86/kvm/emulate.c                     | 1749 ++++++++---------
  arch/x86/kvm/mmu.c                         | 1226 +++++++-----
  arch/x86/kvm/mmu.h                         |   25 +
  arch/x86/kvm/mmu_audit.c                   |   12 -
  arch/x86/kvm/mmutrace.h                    |   48 +
  arch/x86/kvm/paging_tmpl.h                 |  258 ++--
  arch/x86/kvm/svm.c                         |    6 +-
  arch/x86/kvm/trace.h                       |   31 +-
  arch/x86/kvm/vmx.c                         | 3002 
+++++++++++++++++++++++++---
  arch/x86/kvm/x86.c                         |  374 +++-
  arch/x86/kvm/x86.h                         |   44 +
  include/linux/kvm.h                        |   20 +-
  include/linux/kvm_host.h                   |    8 +
  kernel/compat.c                            |    1 +
  kernel/delayacct.c                         |    2 +
  kernel/sched.c                             |   90 +-
  kernel/sched_features.h                    |    4 +-
  virt/kvm/assigned-dev.c                    |    2 +-
  virt/kvm/iommu.c                           |   18 +
  virt/kvm/kvm_main.c                        |  110 +-
  102 files changed, 12429 insertions(+), 3788 deletions(-)
  create mode 100644 Documentation/virtual/kvm/nested-vmx.txt
  create mode 100644 arch/powerpc/kvm/book3s_64_mmu_hv.c
  create mode 100644 arch/powerpc/kvm/book3s_64_vio_hv.c
  create mode 100644 arch/powerpc/kvm/book3s_hv.c
  create mode 100644 arch/powerpc/kvm/book3s_hv_builtin.c
  create mode 100644 arch/powerpc/kvm/book3s_hv_interrupts.S
  create mode 100644 arch/powerpc/kvm/book3s_hv_rm_mmu.c
  create mode 100644 arch/powerpc/kvm/book3s_hv_rmhandlers.S
  create mode 100644 arch/powerpc/kvm/book3s_pr.c

-- 
error compiling committee.c: too many arguments to function

