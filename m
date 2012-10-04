Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965109Ab2JDO1z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 10:27:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17022 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964963Ab2JDO1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 10:27:53 -0400
Message-ID: <506D9CE5.9010404@redhat.com>
Date: Thu, 04 Oct 2012 16:27:49 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: [GIT PULL] KVM updates for the 3.7 merge window
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the repo and tag at:

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/kvm-3.7-1

to receive the KVM updates for the 3.7 merge windows.  Highlights of the
changes for this release include support for vfio level triggered interrupts,
improved big real mode support on older Intels, a streamlines guest page table
walker, guest APIC speedups, PIO optimizations, better overcommit handling, and
read-only memory.

Shortlog and diffstat follow.

----------------------------------------------------------------
KVM updates for the 3.7 merge window

----------------------------------------------------------------
Alex Williamson (1):
      KVM: Add resampling irqfds for level triggered interrupts

Alexander Graf (1):
      KVM: Add ppc hypercall documentation

Avi Kivity (36):
      Merge branch 'queue' into next
      KVM: Don't update PPR on any APIC read
      KVM: Remove internal timer abstraction
      KVM: Simplify kvm_timer
      KVM: Simplify kvm_pit_timer
      KVM: fold kvm_pit_timer into kvm_kpit_state
      Merge remote-tracking branch 'upstream' into next
      KVM: VMX: Advertize RDTSC exiting to nested guests
      KVM: x86 emulator: access GPRs on demand
      KVM: VMX: Separate saving pre-realmode state from setting segments
      KVM: VMX: Fix incorrect lookup of segment S flag in fix_pmode_dataseg()
      KVM: VMX: Use kvm_segment to save protected-mode segments when entering realmode
      KVM: VMX: Retain limit and attributes when entering protected mode
      KVM: VMX: Allow real mode emulation using vm86 with dpl=0
      KVM: VMX: Allow vm86 virtualization of big real mode
      KVM: x86 emulator: Leave segment limit and attributs alone in real mode
      KVM: x86 emulator: Check segment limits in real mode too
      KVM: x86 emulator: Fix #GP error code during linearization
      KVM: VMX: Return real real-mode segment data even if emulate_invalid_guest_state=1
      KVM: VMX: Preserve segment limit and access rights in real mode
      KVM: VMX: Save all segment data in real mode
      KVM: VMX: Ignore segment G and D bits when considering whether we can virtualize
      KVM: VMX: Make lto-friendly
      KVM: VMX: Make use of asm.h
      KVM: SVM: Make use of asm.h
      KVM: MMU: Push clean gpte write protection out of gpte_access()
      KVM: MMU: Optimize gpte_access() slightly
      KVM: MMU: Move gpte_access() out of paging_tmpl.h
      KVM: MMU: Update accessed and dirty bits after guest pagetable walk
      KVM: MMU: Optimize pte permission checks
      KVM: MMU: Simplify walk_addr_generic() loop
      KVM: MMU: Optimize is_last_gpte()
      KVM: MMU: Eliminate eperm temporary
      KVM: MMU: Avoid access/dirty update loop if all is well
      KVM: MMU: Eliminate pointless temporary 'ac'
      Merge branch 'queue' into next

Christian Borntraeger (1):
      KVM: s390: Fix vcpu_load handling in interrupt code

Christoffer Dall (1):
      KVM: Move KVM_IRQ_LINE to arch-generic code

Cornelia Huck (3):
      s390/dis: Instruction decoding interface
      KVM: s390: Add architectural trace events
      KVM: s390: Add implementation-specific trace events

Florian Westphal (1):
      KVM guest: disable stealtime on reboot to avoid mem corruption

Gavin Shan (1):
      KVM: PPC: book3s: fix build error caused by gfn_to_hva_memslot()

Gleb Natapov (18):
      KVM: x86 emulator: drop unneeded call to get_segment()
      KVM: x86: update KVM_SAVE_MSRS_BEGIN to correct value
      KVM: clean up kvm_(set|get)_apic_base
      KVM: use kvm_lapic_set_base() to change apic_base
      KVM: mark apic enabled on start up
      jump_label: Export jump_label_rate_limit()
      KVM: use jump label to optimize checking for HW enabled APIC in APIC_BASE MSR
      KVM: use jump label to optimize checking for SW enabled apic in spurious interrupt register
      KVM: use jump label to optimize checking for in kernel local apic presence
      KVM: inline kvm_apic_present() and kvm_lapic_enabled()
      KVM: correctly detect APIC SW state in kvm_apic_post_state_restore()
      KVM: VMX: restore MSR_IA32_DEBUGCTLMSR after VMEXIT
      KVM: cleanup pic reset
      KVM: Provide userspace IO exit completion callback
      KVM: emulator: make x86 emulation modes enum instead of defines
      KVM: emulator: string_addr_inc() cleanup
      KVM: emulator: optimize "rep ins" handling
      KVM: optimize apic interrupt delivery

Guo Chao (7):
      KVM: VMX: Fix typos
      KVM: SVM: Fix typos
      KVM: x86: Fix typos in x86.c
      KVM: x86: Fix typos in emulate.c
      KVM: x86: Fix typos in cpuid.c
      KVM: x86: Fix typos in lapic.c
      KVM: x86: Fix typos in pmu.c

Jan Kiszka (2):
      KVM: Improve wording of KVM_SET_USER_MEMORY_REGION documentation
      KVM: x86: Fix guest debug across vcpu INIT reset

Liu, Jinsong (1):
      KVM: Depend on HIGH_RES_TIMERS

Marcelo Tosatti (7):
      KVM: x86: fix pvclock guest stopped flag reporting
      x86: KVM guest: merge CONFIG_KVM_CLOCK into CONFIG_KVM_GUEST
      Merge remote-tracking branch 'upstream/master' into queue
      KVM: x86: remove unused variable from kvm_task_switch()
      KVM: split kvm_arch_flush_shadow
      KVM: perform an invalid memslot step for gpa base change
      KVM: move postcommit flush to x86, as mmio sptes are x86 specific

Mathias Krause (8):
      KVM: x86: minor size optimization
      KVM: x86 emulator: use aligned variants of SSE register ops
      KVM: x86 emulator: mark opcode tables const
      KVM: x86 emulator: constify emulate_ops
      KVM: x86: constify read_write_emulator_ops
      KVM: x86: more constification
      KVM: VMX: constify lookup tables
      KVM: SVM: constify lookup tables

Michael S. Tsirkin (4):
      KVM: switch to symbolic name for irq_states size
      KVM: x86: drop parameter validation in ioapic/pic
      KVM: use symbolic constant for nr interrupts
      KVM: make processes waiting on vcpu mutex killable

Raghavendra K T (5):
      KVM: Add config to support ple or cpu relax optimzation
      KVM: Note down when cpu relax intercepted or pause loop exited
      KVM: Choose better candidate for directed yield
      KVM: Add documentation on hypercalls
      KVM: Correct vmrun to vmcall typo

Stefan Fritsch (1):
      KVM: clarify kvmclock documentation

Takuya Yoshikawa (12):
      KVM: MMU: Use __gfn_to_rmap() to clean up kvm_handle_hva()
      KVM: Introduce hva_to_gfn_memslot() for kvm_handle_hva()
      KVM: MMU: Make kvm_handle_hva() handle range of addresses
      KVM: Introduce kvm_unmap_hva_range() for kvm_mmu_notifier_invalidate_range_start()
      KVM: Separate rmap_pde from kvm_lpage_info->write_count
      KVM: MMU: Add memslot parameter to hva handlers
      KVM: MMU: Push trace_kvm_age_page() into kvm_age_rmapp()
      KVM: MMU: Avoid handling same rmap_pde in kvm_handle_hva_range()
      KVM: Stop checking rmap to see if slot is being created
      KVM: MMU: Use gfn_to_rmap() instead of directly reading rmap array
      KVM: Push rmap into kvm_arch_memory_slot
      KVM: x86: lapic: Clean up find_highest_vector() and count_vectors()

Xiao Guangrong (32):
      KVM: x86: remove unnecessary mark_page_dirty
      KVM: MMU: track the refcount when unmap the page
      KVM: using get_fault_pfn to get the fault pfn
      KVM: make bad_pfn static to kvm_main.c
      KVM: remove is_error_hpa
      KVM: remove the unused parameter of gfn_to_pfn_memslot
      KVM: MMU: use kvm_release_pfn_clean to release pfn
      KVM: use kvm_release_page_clean to release the page
      KVM: remove dummy pages
      KVM: x86 emulator: simplify read_emulated
      KVM: iommu: fix releasing unmapped page
      KVM: introduce KVM_PFN_ERR_FAULT
      KVM: introduce KVM_PFN_ERR_HWPOISON
      KVM: introduce KVM_PFN_ERR_BAD
      KVM: inline is_*_pfn functions
      KVM: remove the unused declare
      KVM: introduce KVM_ERR_PTR_BAD_PAGE
      KVM: do not release the error pfn
      KVM: do not release the error page
      KVM: let the error pfn not depend on error code
      KVM: x86: fix possible infinite loop caused by reexecute_instruction
      KVM: fix missing check for memslot flags
      KVM: hide KVM_MEMSLOT_INVALID from userspace
      KVM: introduce gfn_to_pfn_memslot_atomic
      KVM: introduce gfn_to_hva_read/kvm_read_hva/kvm_read_hva_atomic
      KVM: reorganize hva_to_pfn
      KVM: use 'writable' as a hint to map writable pfn
      KVM: introduce KVM_PFN_ERR_RO_FAULT
      KVM: introduce KVM_HVA_ERR_BAD
      KVM: introduce KVM_HVA_ERR_RO_BAD
      KVM: introduce readonly memslot
      KVM: MMU: remove unnecessary check

 Documentation/virtual/kvm/api.txt        |  33 +-
 Documentation/virtual/kvm/hypercalls.txt |  66 ++++
 Documentation/virtual/kvm/msr.txt        |  32 +-
 Documentation/virtual/kvm/ppc-pv.txt     |  22 ++
 arch/ia64/kvm/kvm-ia64.c                 |  41 +--
 arch/powerpc/include/asm/kvm_host.h      |   3 +
 arch/powerpc/kvm/44x_tlb.c               |   1 -
 arch/powerpc/kvm/book3s_64_mmu_hv.c      |  51 ++-
 arch/powerpc/kvm/book3s_hv_rm_mmu.c      |   6 +-
 arch/powerpc/kvm/book3s_pr.c             |   4 +-
 arch/powerpc/kvm/e500_tlb.c              |   3 +-
 arch/powerpc/kvm/powerpc.c               |  14 +-
 arch/s390/include/asm/processor.h        |   1 +
 arch/s390/kernel/dis.c                   |  27 ++
 arch/s390/kvm/Kconfig                    |   1 +
 arch/s390/kvm/diag.c                     |   4 +
 arch/s390/kvm/intercept.c                |  11 +
 arch/s390/kvm/interrupt.c                |  25 +-
 arch/s390/kvm/kvm-s390.c                 |  17 +-
 arch/s390/kvm/priv.c                     |   9 +-
 arch/s390/kvm/sigp.c                     |   2 +
 arch/s390/kvm/trace-s390.h               | 210 ++++++++++++
 arch/s390/kvm/trace.h                    | 341 +++++++++++++++++++
 arch/x86/Kconfig                         |  21 +-
 arch/x86/include/asm/kvm.h               |   1 +
 arch/x86/include/asm/kvm_emulate.h       |  48 ++-
 arch/x86/include/asm/kvm_host.h          |  36 +-
 arch/x86/include/asm/kvm_para.h          |   6 +-
 arch/x86/kernel/Makefile                 |   3 +-
 arch/x86/kernel/kvm.c                    |   3 +-
 arch/x86/kernel/setup.c                  |   2 +-
 arch/x86/kvm/Kconfig                     |   2 +
 arch/x86/kvm/Makefile                    |   2 +-
 arch/x86/kvm/cpuid.c                     |  14 +-
 arch/x86/kvm/emulate.c                   | 538 +++++++++++++++++-------------
 arch/x86/kvm/i8254.c                     |  64 ++--
 arch/x86/kvm/i8254.h                     |   6 +-
 arch/x86/kvm/i8259.c                     |  70 ++--
 arch/x86/kvm/irq.h                       |   2 +-
 arch/x86/kvm/kvm_timer.h                 |  18 -
 arch/x86/kvm/lapic.c                     | 484 +++++++++++++++++++--------
 arch/x86/kvm/lapic.h                     |  61 +++-
 arch/x86/kvm/mmu.c                       | 240 ++++++++++----
 arch/x86/kvm/mmu.h                       |  25 +-
 arch/x86/kvm/mmu_audit.c                 |   8 +-
 arch/x86/kvm/paging_tmpl.h               | 199 +++++------
 arch/x86/kvm/pmu.c                       |   2 +-
 arch/x86/kvm/svm.c                       |  82 ++---
 arch/x86/kvm/timer.c                     |  47 ---
 arch/x86/kvm/vmx.c                       | 233 ++++++-------
 arch/x86/kvm/x86.c                       | 384 +++++++++++++---------
 arch/x86/kvm/x86.h                       |   1 +
 include/linux/kvm.h                      |  25 +-
 include/linux/kvm_host.h                 | 145 +++++++--
 kernel/jump_label.c                      |   1 +
 virt/kvm/Kconfig                         |   3 +
 virt/kvm/async_pf.c                      |  11 +-
 virt/kvm/eventfd.c                       | 150 ++++++++-
 virt/kvm/ioapic.c                        |  37 ++-
 virt/kvm/iommu.c                         |  16 +-
 virt/kvm/irq_comm.c                      |  17 +-
 virt/kvm/kvm_main.c                      | 543 +++++++++++++++++++------------
 62 files changed, 3007 insertions(+), 1467 deletions(-)
 create mode 100644 Documentation/virtual/kvm/hypercalls.txt
 create mode 100644 arch/s390/kvm/trace-s390.h
 create mode 100644 arch/s390/kvm/trace.h
 delete mode 100644 arch/x86/kvm/kvm_timer.h
 delete mode 100644 arch/x86/kvm/timer.c

-- 
error compiling committee.c: too many arguments to function
