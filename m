Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760132Ab2CTOIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 10:08:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31337 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760115Ab2CTOIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 10:08:12 -0400
Message-ID: <4F688F48.6090303@redhat.com>
Date: Tue, 20 Mar 2012 16:08:08 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [GIT PULL] KVM updates for the 3.4 merge window
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

  ra.kernel.org:/pub/scm/virt/kvm/kvm.git kvm-updates/3.4

(ssh URL as git.kernel.org is down at the moment) to receive the KVM
updates for the 3.4 merge window.  Changes include  timekeeping
improvements, support for assigning host PCI devices that share
interrupt lines, s390 user-controlled guests, a large ppc update, and
random fixes.

----------------------------------------------------------------
Alex Shi (1):
      KVM: use correct tlbs dirty type in cmpxchg

Alexander Graf (13):
      KVM: PPC: E500: Support hugetlbfs
      KVM: PPC: Book3s: PR: Disable preemption in vcpu_run
      KVM: PPC: Book3s: PR: No irq_disable in vcpu_run
      KVM: PPC: Use get/set for to_svcpu to help preemption
      KVM: PPC: align vcpu_kick with x86
      KVM: PPC: Book3S: PR: Fix signal check race
      KVM: PPC: Add generic single register ioctls
      KVM: PPC: Add support for explicit HIOR setting
      KVM: PPC: Rename MMIO register identifiers
      KVM: PPC: E500: Fail init when not on e500v2
      KVM: PPC: Convert RMA allocation into generic code
      KVM: PPC: Initialize linears with zeros
      KVM: PPC: Add HPT preallocator

Avi Kivity (5):
      KVM: x86 emulator: add 8-bit memory operands
      KVM: x86 emulator: Remove byte-sized MOVSX/MOVZX hack
      KVM: x86 emulator: reject SYSENTER in compatibility mode on AMD guests
      KVM: Ensure all vcpus are consistent with in-kernel irqchip settings
      KVM: VMX: Fix delayed load of shared MSRs

Bharat Bhushan (3):
      PPC: Fix race in mtmsr paravirt implementation
      KVM: PPC: Fix DEC truncation for greater than 0xffff_ffff/1000
      KVM: PPC: booke: Do Not start decrementer when SPRN_DEC set 0

Boris Ostrovsky (1):
      KVM: SVM: Add support for AMD's OSVW feature in guests

Carsten Otte (11):
      KVM: s390: add parameter for KVM_CREATE_VM
      KVM: s390: ucontrol: per vcpu address spaces
      KVM: s390: ucontrol: export page faults to user
      KVM: s390: ucontrol: export SIE control block to user
      KVM: s390: ucontrol: disable in-kernel handling of SIE intercepts
      KVM: s390: ucontrol: disable in-kernel irq stack
      KVM: s390: ucontrol: interface to inject faults on a vcpu page table
      KVM: s390: ucontrol: disable sca
      KVM: s390: fix assumption for KVM_MAX_VCPUS
      KVM: s390: ucontrol: announce capability for user controlled vms
      KVM: s390: Fix return code for unknown ioctl numbers

Christian Borntraeger (7):
      KVM: s390: rework code that sets the prefix
      KVM: provide synchronous registers in kvm_run
      KVM: s390: provide the prefix register via kvm_run
      KVM: s390: provide general purpose guest registers via kvm_run
      KVM: s390: provide access guest registers via kvm_run
      KVM: s390: Sanitize fpc registers for KVM_SET_FPU
      KVM: s390: provide control registers via kvm_run

Danny Kukawka (1):
      arch/powerpc/kvm/book3s_hv.c: included linux/sched.h twice

Davidlohr Bueso (3):
      KVM: MMU: unnecessary NX state assignment
      KVM: SVM: comment nested paging and virtualization module parameters
      KVM: MMU: make use of ->root_level in reset_rsvds_bits_mask

Gleb Natapov (5):
      KVM: x86: reset edge sense circuit of i8259 on init
      KVM: x86 emulator: correctly mask pmc index bits in RDPMC
instruction emulation
      KVM: PMU: warn when pin control is set in eventsel msr
      KVM: PMU: Fix raw event check
      KVM: PMU: add proper support for fixed counter 2

Igor Mammedov (1):
      x86: Introduce x86_cpuinit.early_percpu_clock_init hook

Jan Kiszka (2):
      KVM: Allow host IRQ sharing for assigned PCI 2.3 devices
      KVM: Convert intx_mask_lock to spin lock

Jens Freimann (4):
      KVM: s390: do store status after handling STOP_ON_STOP bit
      KVM: s390: make sigp restart return busy when stop pending
      KVM: s390: ignore sigp stop overinitiative
      KVM: s390: add stop_on_stop flag when doing stop and store

Julian Stecklina (1):
      KVM: Don't mistreat edge-triggered INIT IPI as INIT de-assert. (LAPIC)

Kevin Wolf (4):
      KVM: x86 emulator: Fix task switch privilege checks
      KVM: x86 emulator: VM86 segments must have DPL 3
      KVM: SVM: Fix CPL updates
      KVM: x86 emulator: Allow PM/VM86 switch during task switch

Liu Yu (1):
      KVM: PPC: booke: Add booke206 TLB trace

Liu Yu-B13201 (1):
      KVM: PPC: Avoid patching paravirt template code

Marcelo Tosatti (4):
      KVM: x86: increase recommended max vcpus to 160
      KVM: Allow adjust_tsc_offset to be in host or guest cycles
      x86: kvmclock: abstract save/restore sched_clock_state
      KVM: x86: fix kvm_write_tsc() TSC matching thinko

Matt Evans (2):
      KVM: PPC: Fix vcpu_create dereference before validity check.
      KVM: PPC: Add KVM_CAP_NR_VCPUS and KVM_CAP_MAX_VCPUS

Michael S. Tsirkin (1):
      KVM: fix error handling for out of range irq

Nadav Har'El (1):
      KVM: nVMX: Fix erroneous exception bitmap check

Nicolae Mogoreanu (1):
      KVM: Ignore the writes to MSR_K7_HWCR(3)

Paul Mackerras (19):
      KVM: PPC: Make wakeups work again for Book3S HV guests
      KVM: PPC: Keep a record of HV guest view of hashed page table entries
      KVM: PPC: Keep page physical addresses in per-slot arrays
      KVM: PPC: Add an interface for pinning guest pages in Book3s HV guests
      KVM: PPC: Make the H_ENTER hcall more reliable
      KVM: PPC: Only get pages when actually needed, not in
prepare_memory_region()
      KVM: PPC: Allow use of small pages to back Book3S HV guests
      KVM: PPC: Allow I/O mappings in memory slots
      KVM: PPC: Maintain a doubly-linked list of guest HPTEs for each gfn
      KVM: PPC: Implement MMIO emulation support for Book3S HV guests
      KVM: PPC: Implement MMU notifiers for Book3S HV guests
      KVM: Add barriers to allow mmu_notifier_retry to be used locklessly
      KVM: PPC: Allow for read-only pages backing a Book3S HV guest
      KVM: PPC: Book3S HV: Keep HPTE locked when invalidating
      KVM: PPC: Book3s HV: Maintain separate guest and host views of R
and C bits
      KVM: PPC: Book3S HV: Use the hardware referenced bit for kvm_age_hva
      KVM: PPC: Book3s HV: Implement get_dirty_log using hardware
changed bit
      KVM: PPC: Move kvm_vcpu_ioctl_[gs]et_one_reg down to
platform-specific code
      KVM: Move gfn_to_memslot() to kvm_host.h

Raghavendra K T (1):
      KVM: VMX: remove yield_on_hlt

Sasha Levin (1):
      KVM: PPC: Use the vcpu kmem_cache when allocating new VCPUs

Scott Wood (17):
      KVM: PPC: e500: don't translate gfn to pfn with preemption disabled
      KVM: PPC: e500: Eliminate preempt_disable in local_sid_destroy_all
      KVM: PPC: e500: clear up confusion between host and guest entries
      KVM: PPC: e500: MMU API
      KVM: PPC: e500: tlbsx: fix tlb0 esel
      KVM: PPC: e500: Don't hardcode PIR=0
      KVM: PPC: booke: check for signals in kvmppc_vcpu_run
      KVM: PPC: Rename deliver_interrupts to prepare_to_enter
      KVM: PPC: Move prepare_to_enter call site into subarch code
      KVM: PPC: booke: Check for MSR[WE] in prepare_to_enter
      KVM: PPC: booke: Fix int_pending calculation for MSR[EE] paravirt
      KVM: PPC: booke: Paravirtualize wrtee
      KVM: PPC: Paravirtualize SPRG4-7, ESR, PIR, MASn
      KVM: PPC: booke: Improve timer register emulation
      KVM: PPC: e500: Fix TLBnCFG in KVM_CONFIG_TLB
      KVM: PPC: e500: use hardware hint when loading TLB0 entries
      KVM: PPC: refer to paravirt docs in header file

Takuya Yoshikawa (11):
      KVM: MMU: Remove for_each_unsync_children() macro
      KVM: MMU: Add missing large page accounting to drop_large_spte()
      KVM: MMU: Remove unused kvm_pte_chain
      KVM: MMU: Remove unused kvm parameter from __gfn_to_rmap()
      KVM: MMU: Remove unused kvm parameter from rmap_next()
      KVM: Fix write protection race during dirty logging
      KVM: Introduce gfn_to_index() which returns the index for a given
level
      KVM: Split lpage_info creation out from __kvm_set_memory_region()
      KVM: Simplify ifndef conditional usage in __kvm_set_memory_region()
      KVM: Introduce kvm_memory_slot::arch and move lpage_info into it
      KVM: mmu_notifier: Flush TLBs before releasing mmu_lock

Xiao Guangrong (1):
      KVM: MMU: remove the redundant get_written_sptes

Zachary Amsden (7):
      KVM: Infrastructure for software and hardware based TSC rate scaling
      KVM: Improve TSC offset matching
      KVM: Leave TSC synchronization window open with each new sync
      KVM: Fix last_guest_tsc / tsc_offset semantics
      KVM: Add last_host_tsc tracking back to KVM
      KVM: Dont mark TSC unstable due to S4 suspend
      KVM: Track TSC synchronization in generations

 Documentation/virtual/kvm/api.txt        |  259 +++++++++-
 Documentation/virtual/kvm/ppc-pv.txt     |   24 +-
 arch/ia64/include/asm/kvm.h              |    4 +
 arch/ia64/include/asm/kvm_host.h         |    3 +
 arch/ia64/kvm/kvm-ia64.c                 |   25 +-
 arch/powerpc/include/asm/kvm.h           |   46 ++-
 arch/powerpc/include/asm/kvm_book3s.h    |   98 +++-
 arch/powerpc/include/asm/kvm_book3s_32.h |    6 +-
 arch/powerpc/include/asm/kvm_book3s_64.h |  180 ++++++-
 arch/powerpc/include/asm/kvm_e500.h      |   52 +-
 arch/powerpc/include/asm/kvm_host.h      |   90 +++-
 arch/powerpc/include/asm/kvm_para.h      |   41 ++-
 arch/powerpc/include/asm/kvm_ppc.h       |   25 +-
 arch/powerpc/include/asm/mmu-book3e.h    |    6 +-
 arch/powerpc/include/asm/mmu-hash64.h    |    2 +-
 arch/powerpc/include/asm/ppc-opcode.h    |    4 +-
 arch/powerpc/include/asm/reg.h           |    5 +
 arch/powerpc/kernel/asm-offsets.c        |   16 +-
 arch/powerpc/kernel/exceptions-64s.S     |    8 +-
 arch/powerpc/kernel/kvm.c                |  307 +++++++++--
 arch/powerpc/kernel/kvm_emul.S           |  112 +++-
 arch/powerpc/kernel/setup_64.c           |    2 +-
 arch/powerpc/kvm/Kconfig                 |    1 +
 arch/powerpc/kvm/book3s.c                |   57 +--
 arch/powerpc/kvm/book3s_32_mmu_host.c    |   21 +-
 arch/powerpc/kvm/book3s_64_mmu_host.c    |   66 ++-
 arch/powerpc/kvm/book3s_64_mmu_hv.c      |  919
++++++++++++++++++++++++++++--
 arch/powerpc/kvm/book3s_emulate.c        |    8 +-
 arch/powerpc/kvm/book3s_hv.c             |  466 ++++++++++------
 arch/powerpc/kvm/book3s_hv_builtin.c     |  209 +++++---
 arch/powerpc/kvm/book3s_hv_rm_mmu.c      |  835 +++++++++++++++++++++------
 arch/powerpc/kvm/book3s_hv_rmhandlers.S  |  176 +++++-
 arch/powerpc/kvm/book3s_paired_singles.c |    9 +-
 arch/powerpc/kvm/book3s_pr.c             |  178 +++++-
 arch/powerpc/kvm/booke.c                 |  150 ++++--
 arch/powerpc/kvm/booke.h                 |    4 +
 arch/powerpc/kvm/booke_emulate.c         |   23 +-
 arch/powerpc/kvm/booke_interrupts.S      |   18 +-
 arch/powerpc/kvm/e500.c                  |   32 +-
 arch/powerpc/kvm/e500_emulate.c          |   38 +-
 arch/powerpc/kvm/e500_tlb.c              |  775 ++++++++++++++++++--------
 arch/powerpc/kvm/e500_tlb.h              |   80 +--
 arch/powerpc/kvm/emulate.c               |   61 +-
 arch/powerpc/kvm/powerpc.c               |  148 ++++--
 arch/powerpc/kvm/trace.h                 |   62 ++-
 arch/powerpc/mm/hugetlbpage.c            |    2 +
 arch/s390/include/asm/kvm.h              |   11 +
 arch/s390/include/asm/kvm_host.h         |   12 +-
 arch/s390/kvm/Kconfig                    |    9 +
 arch/s390/kvm/diag.c                     |    6 +-
 arch/s390/kvm/intercept.c                |   24 +-
 arch/s390/kvm/interrupt.c                |    3 +-
 arch/s390/kvm/kvm-s390.c                 |  221 ++++++--
 arch/s390/kvm/kvm-s390.h                 |   18 +
 arch/s390/kvm/priv.c                     |   27 +-
 arch/s390/kvm/sigp.c                     |   57 ++-
 arch/x86/include/asm/kvm.h               |    4 +
 arch/x86/include/asm/kvm_emulate.h       |    3 +-
 arch/x86/include/asm/kvm_host.h          |   63 ++-
 arch/x86/include/asm/perf_event.h        |    1 +
 arch/x86/include/asm/tsc.h               |    4 +-
 arch/x86/include/asm/x86_init.h          |    6 +
 arch/x86/kernel/kvmclock.c               |   15 +-
 arch/x86/kernel/smpboot.c                |    1 +
 arch/x86/kernel/tsc.c                    |    4 +-
 arch/x86/kernel/x86_init.c               |    5 +-
 arch/x86/kvm/cpuid.c                     |    2 +-
 arch/x86/kvm/cpuid.h                     |    8 +
 arch/x86/kvm/emulate.c                   |  112 ++++-
 arch/x86/kvm/i8259.c                     |    1 +
 arch/x86/kvm/lapic.c                     |    4 +-
 arch/x86/kvm/mmu.c                       |   85 ++--
 arch/x86/kvm/mmu_audit.c                 |    4 +-
 arch/x86/kvm/pmu.c                       |   10 +-
 arch/x86/kvm/svm.c                       |  119 ++++-
 arch/x86/kvm/vmx.c                       |   53 +-
 arch/x86/kvm/x86.c                       |  403 ++++++++++---
 arch/x86/power/cpu.c                     |    4 +-
 include/linux/kvm.h                      |   98 ++++
 include/linux/kvm_host.h                 |   69 ++-
 virt/kvm/assigned-dev.c                  |  213 ++++++-
 virt/kvm/kvm_main.c                      |  144 ++----
 82 files changed, 5808 insertions(+), 1668 deletions(-)

-- 
error compiling committee.c: too many arguments to function

