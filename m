Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290Ab0HCIaj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 04:30:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52095 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076Ab0HCIad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 04:30:33 -0400
Message-ID: <4C57D38D.2090400@redhat.com>
Date: Tue, 03 Aug 2010 11:30:05 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] KVM updates for the 2.6.36 merge window
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Linus, please pull from

   git://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/2.6.36

to receive the KVM updates for the 2.6.36 cycle.  No major features: 
mostly improved mmu and emulator correctness, some performance 
improvements, and support for guest XSAVE and AVX.

Alex Williamson (1):
       KVM: remove CAP_SYS_RAWIO requirement from kvm_vm_ioctl_assign_irq

Alexander Graf (5):
       KVM: PPC: Remove obsolete kvmppc_mmu_find_pte
       KVM: PPC: Use kernel hash function
       KVM: PPC: Make BAT only guest segments work
       KVM: PPC: Add generic hpte management functions
       KVM: PPC: Make use of hash based Shadow MMU

Andi Kleen (2):
       KVM: Fix KVM_SET_SIGNAL_MASK with arg == NULL
       KVM: Fix unused but set warnings

Andrea Arcangeli (1):
       KVM: MMU: fix mmu notifier invalidate handler for huge spte

Andreas Schwab (1):
       KVM: PPC: elide struct thread_struct instances from stack

Asias He (1):
       KVM: PPC: fix uninitialized variable warning in 
kvm_ppc_core_deliver_interrupts

Avi Kivity (50):
       KVM: VMX: Simplify vmx_get_nmi_mask()
       KVM: kvm_pdptr_read() may sleep
       KVM: VMX: Avoid writing HOST_CR0 every entry
       KVM: Get rid of KVM_REQ_KICK
       KVM: Document KVM_SET_IDENTITY_MAP ioctl
       KVM: Document KVM_SET_BOOT_CPU_ID
       KVM: MMU: Fix free memory accounting race in mmu_alloc_roots()
       KVM: move vcpu locking to dispatcher for generic vcpu ioctls
       KVM: x86: Lock arch specific vcpu ioctls centrally
       KVM: s390: Centrally lock arch specific vcpu ioctls
       KVM: PPC: Centralize locking of arch specific vcpu ioctls
       KVM: Consolidate arch specific vcpu ioctl locking
       KVM: Update Red Hat copyrights
       KVM: MMU: Allow spte.w=1 for gpte.w=0 and cr0.wp=0 only in shadow 
mode
       KVM: MMU: Document cr0.wp emulation
       KVM: MMU: Document large pages
       KVM: VMX: Fix incorrect rcu deref in rmode_tss_base()
       KVM: Fix mov cr0 #GP at wrong instruction
       KVM: Fix mov cr4 #GP at wrong instruction
       KVM: Fix mov cr3 #GP at wrong instruction
       KVM: Fix xsave and xcr save/restore memory leak
       KVM: Consolidate load/save temporary buffer allocation and freeing
       KVM: Remove memory alias support
       KVM: Remove kernel-allocated memory regions
       KVM: i8259: reduce excessive abstraction for pic_irq_request()
       KVM: i8259: simplify pic_irq_request() calling sequence
       KVM: Add mini-API for vcpu->requests
       KVM: Reduce atomic operations on vcpu->requests
       KVM: Keep slot ID in memory slot structure
       KVM: Prevent internal slots from being COWed
       KVM: Simplify vcpu_enter_guest() mmu reload logic slightly
       KVM: Document KVM specific review items
       KVM: MMU: Introduce drop_spte()
       KVM: MMU: Move accessed/dirty bit checks from rmap_remove() to 
drop_spte()
       KVM: MMU: Atomically check for accessed bit when dropping an spte
       KVM: MMU: Don't drop accessed bit while updating an spte
       KVM: MMU: Only indicate a fetch fault in page fault error code if 
nx is enabled
       KVM: MMU: Keep going on permission error
       KVM: Expose MCE control MSRs to userspace
       KVM: Document MCE banks non-exposure via KVM_GET_MSR_INDEX_LIST
       KVM: MMU: Add link_shadow_page() helper
       KVM: MMU: Use __set_spte to link shadow pages
       KVM: MMU: Add drop_large_spte() helper
       KVM: MMU: Add validate_direct_spte() helper
       KVM: MMU: Add gpte_valid() helper
       KVM: MMU: Simplify spte fetch() function
       KVM: MMU: Validate all gptes during fetch, not just those used 
for new pages
       KVM: MMU: Eliminate redundant temporaries in FNAME(fetch)
       KVM: Document KVM_GET_SUPPORTED_CPUID2 ioctl
       KVM: VMX: Fix host GDT.LIMIT corruption

Chris Lalancette (4):
       KVM: x86: Introduce a workqueue to deliver PIT timer interrupts
       KVM: x86: Allow any LAPIC to accept PIC interrupts
       KVM: x86: In DM_LOWEST, only deliver interrupts to vcpus with 
enabled LAPIC's
       KVM: Search the LAPIC's for one that will accept a PIC interrupt

Christian Borntraeger (2):
       KVM: s390: Fix build failure due to centralized vcpu locking patches
       KVM: s390: Don't exit SIE on SIGP sense running

Denis Kirjanov (1):
       KVM: PPC: fix build warning in kvm_arch_vcpu_ioctl_run

Dexuan Cui (1):
       KVM: VMX: Enable XSAVE/XRSTOR for guest

Dongxiao Xu (4):
       KVM: VMX: Define new functions to wrapper direct call of asm code
       KVM: VMX: Some minor changes to code structure
       KVM: VMX: VMCLEAR/VMPTRLD usage changes
       KVM: VMX: VMXON/VMXOFF usage changes

Glauber Costa (1):
       KVM: Add Documentation/kvm/msr.txt

Gleb Natapov (32):
       KVM: x86 emulator: introduce read cache
       KVM: x86 emulator: fix Move r/m16 to segment register decoding
       KVM: x86 emulator: cleanup xchg emulation
       KVM: x86 emulator: cleanup nop emulation
       KVM: x86 emulator: handle "far address" source operand
       KVM: x86 emulator: add (set|get)_dr callbacks to x86_emulate_ops
       KVM: x86 emulator: add (set|get)_msr callbacks to x86_emulate_ops
       KVM: x86 emulator: add get_cached_segment_base() callback to 
x86_emulate_ops
       KVM: x86 emulator: cleanup some direct calls into kvm to use 
existing callbacks
       KVM: x86 emulator: make set_cr() callback return error if it fails
       KVM: x86 emulator: make (get|set)_dr() callback return error if 
it fails
       KVM: x86 emulator: fix X86EMUL_RETRY_INSTR and 
X86EMUL_CMPXCHG_FAILED values
       KVM: fill in run->mmio details in (read|write)_emulated function
       KVM: x86 emulator: x86_emulate_insn() return -1 only in case of 
emulation failure
       KVM: remove export of emulator_write_emulated()
       KVM: do not inject #PF in (read|write)_emulated() callbacks
       KVM: handle emulation failure case first
       KVM: x86 emulator: advance RIP outside x86 emulator code
       KVM: x86 emulator: set RFLAGS outside x86 emulator code
       KVM: x86 emulator: use shadowed register in emulate_sysexit()
       KVM: x86 emulator: handle shadowed registers outside emulator
       KVM: x86 emulator: move interruptibility state tracking out of 
emulator
       KVM: x86 emulator: do not inject exception directly into vcpu
       KVM: inject #UD if instruction emulation fails and exit to userspace
       KVM: SVM: correctly trace irq injection
       KVM: define hwpoison variables static
       KVM: Return EFAULT from kvm ioctl when guest accesses bad area
       KVM: Reenter guest after emulation failure if due to access to 
non-mmio address
       KVM: Convert mask notifiers to use irqchip/pin instead of gsi
       KVM: x86: emulator: inc/dec can have lock prefix
       KVM: x86: never re-execute instruction with enabled tdp
       KVM: x86: Call mask notifiers from pic

Gui Jianfeng (9):
       KVM: MMU: mark page table dirty when a pte is actually modified
       KVM: MMU: Fix debug output error in walk_addr()
       KVM: MMU: make kvm_mmu_zap_page() return the number of pages it 
actually freed
       KVM: update mmu documetation for role.nxe
       KVM: MMU: don't check PT_WRITABLE_MASK directly
       KVM: MMU: Don't calculate quadrant if tdp_enabled
       KVM: VMX: Make sure single type invvpid is supported before 
issuing invvpid instruction
       KVM: VMX: Add all-context INVVPID type support
       KVM: VMX: rename vpid_sync_vcpu_all() to vpid_sync_vcpu_single()

Huang Ying (2):
       KVM: Avoid killing userspace through guest SRAO MCE on unmapped pages
       KVM: Fix a race condition for usage of is_hwpoison_address()

Jan Kiszka (1):
       KVM: x86: Propagate fpu_alloc errors

Jason Wang (1):
       KVM: Fix typos in Documentation/kvm/mmu.txt

Jiri Slaby (1):
       KVM: fix lock imbalance in kvm_create_pit()

Joerg Roedel (4):
       KVM: SVM: Dump vmcb contents on failed vmrun
       KVM: SVM: Allow EFER.LMSLE to be set with nested svm
       KVM: Remove unnecessary divide operations
       KVM: Use u64 for frame data types

Lai Jiangshan (5):
       KVM: MMU: Don't allocate gfns page for direct mmu pages
       KVM: MMU: Calculate correct base gfn for direct non-DIR level
       KVM: MMU: calculate correct gfn for small host pages backing 
large guest pages
       KVM: cleanup "*new.rmap" type
       KVM: x86: use linux/uaccess.h instead of asm/uaccess.h

Marcelo Tosatti (1):
       KVM: pass correct parameter to kvm_mmu_free_some_pages

Mohammed Gamal (5):
       KVM: x86 emulator: Add test acc, imm instruction (opcodes 0xA8 - 
0xA9)
       KVM: x86 emulator: Add missing decoder flags for sub instruction
       KVM: x86 emulator: Add missing decoder flags for xor instructions
       KVM: VMX: Add constant for invalid guest state exit reason
       KVM: VMX: Properly return error to userspace on vmentry failure

Sheng Yang (10):
       KVM: x86: Clean up duplicate assignment
       KVM: VMX: Only reset MMU when necessary
       x86: Export FPU API for KVM use
       KVM: x86: Use unlazy_fpu() for host FPU
       KVM: x86: Use FPU API
       KVM: VMX: Enforce EPT pagetable level checking
       KVM: x86: XSAVE/XRSTOR live migration support
       KVM: x86: Enable AVX for guest
       KVM: VMX: Execute WBINVD to keep data consistency with assigned 
devices
       KVM: Fix IOMMU memslot reference warning

Takuya Yoshikawa (3):
       KVM: x86: avoid unnecessary bitmap allocation when memslot is clean
       KVM: ia64: fix dirty_log_lock spin_lock section not to include 
get_dirty_log()
       KVM: ia64: cleanup kvm_ia64_sync_dirty_log()

Wei Yongjun (9):
       KVM: x86 emulator: fix pusha instruction emulation
       KVM: x86 emulator: fix group3 instruction decoding
       KVM: x86 emulator: fix 'mov sreg,rm16' instruction decoding
       KVM: x86 emulator: fix the comment of out instruction
       KVM: x86 emulator: fix 'and AL,imm8' instruction decoding
       KVM: x86 emulator: fix 'mov rm,sreg' instruction decoding
       KVM: x86 emulator: fix cli/sti instruction emulation
       KVM: x86 emulator: re-implementing 'mov AL,moffs' instruction 
decoding
       KVM: x86 emulator: fix xchg instruction emulation

Xiao Guangrong (39):
       KVM: MMU: use proper cache object freeing function
       KVM: MMU: remove rmap before clear spte
       KVM: MMU: unalias gfn before sp->gfns[] comparison in sync_page
       KVM: x86: cleanup unused local variable
       KVM: MMU: split kvm_sync_page() function
       KVM: MMU: don't write-protect if have new mapping to unsync page
       KVM: MMU: only update unsync page in invlpg path
       KVM: MMU: allow more page become unsync at gfn mapping time
       KVM: MMU: allow more page become unsync at getting sp time
       KVM: MMU: skip invalid sp when unprotect page
       KVM: MMU: introduce some macros to cleanup hlist traverseing
       KVM: MMU: split the operations of kvm_mmu_zap_page()
       KVM: MMU: don't get free page number in the loop
       KVM: MMU: gather remote tlb flush which occurs during page zapped
       KVM: MMU: traverse sp hlish safely
       KVM: MMU: reduce remote tlb flush in kvm_mmu_pte_write()
       KVM: VMX: fix rcu usage warning in init_rmode()
       KVM: MMU: remove unnecessary remote tlb flush
       KVM: MMU: use wrapper function to flush local tlb
       KVM: MMU: delay local tlb flush
       KVM: MMU: rename 'page' and 'shadow_page' to 'sp'
       KVM: MMU: cleanup for dirty page judgment
       KVM: MMU: avoid double write protected in sync page path
       KVM: MMU: don't mark pte notrap if it's just sync transient
       KVM: MMU: cleanup for __mmu_unsync_walk()
       KVM: MMU: clear unsync_child_bitmap completely
       KVM: MMU: don't walk every parent pages while mark unsync
       KVM: MMU: fix writable sync sp mapping
       KVM: MMU: fix conflict access permissions in direct sp
       KVM: MMU: fix direct sp's access corrupted
       KVM: MMU: cleanup FNAME(fetch)() functions
       KVM: VMX: fix tlb flush with invalid root
       KVM: PIT: stop vpit before freeing irq_routing
       KVM: MMU: add missing reserved bits check in speculative path
       KVM: MMU: fix broken page accessed tracking with ept enabled
       KVM: MMU: fix page dirty tracking lost while sync page
       KVM: MMU: don't atomicly set spte if it's not present
       KVM: MMU: cleanup spte set and accssed/dirty tracking
       KVM: MMU: using __xchg_spte more smarter

Zachary Amsden (2):
       KVM: SVM: Fix EFER.LME being stripped
       KVM: x86: fix -DDEBUG oops

  Documentation/feature-removal-schedule.txt |   21 -
  Documentation/kvm/api.txt                  |  208 ++++-
  Documentation/kvm/mmu.txt                  |   52 ++-
  Documentation/kvm/msr.txt                  |  153 ++++
  Documentation/kvm/review-checklist.txt     |   38 +
  arch/ia64/include/asm/kvm_host.h           |    1 +
  arch/ia64/kvm/kvm-ia64.c                   |   50 +-
  arch/powerpc/include/asm/kvm_book3s.h      |   10 +-
  arch/powerpc/include/asm/kvm_fpu.h         |   27 +-
  arch/powerpc/include/asm/kvm_host.h        |   18 +-
  arch/powerpc/kernel/ppc_ksyms.c            |    4 -
  arch/powerpc/kvm/44x_tlb.c                 |    3 +-
  arch/powerpc/kvm/Makefile                  |    2 +
  arch/powerpc/kvm/book3s.c                  |   79 +-
  arch/powerpc/kvm/book3s_32_mmu.c           |    8 +-
  arch/powerpc/kvm/book3s_32_mmu_host.c      |  134 +---
  arch/powerpc/kvm/book3s_64_mmu_host.c      |  129 +---
  arch/powerpc/kvm/book3s_mmu_hpte.c         |  277 +++++++
  arch/powerpc/kvm/book3s_paired_singles.c   |   94 +--
  arch/powerpc/kvm/booke.c                   |   12 +-
  arch/powerpc/kvm/fpu.S                     |   18 +
  arch/powerpc/kvm/powerpc.c                 |   14 +-
  arch/s390/include/asm/kvm_host.h           |    5 +-
  arch/s390/kvm/intercept.c                  |    2 +-
  arch/s390/kvm/kvm-s390.c                   |   64 +--
  arch/s390/kvm/kvm-s390.h                   |    2 +-
  arch/x86/include/asm/i387.h                |    2 +
  arch/x86/include/asm/kvm.h                 |   22 +
  arch/x86/include/asm/kvm_emulate.h         |   30 +-
  arch/x86/include/asm/kvm_host.h            |   70 +--
  arch/x86/include/asm/msr-index.h           |    2 +
  arch/x86/include/asm/vmx.h                 |    5 +
  arch/x86/include/asm/xsave.h               |    6 +
  arch/x86/kernel/i387.c                     |    3 +-
  arch/x86/kernel/process.c                  |    1 +
  arch/x86/kvm/emulate.c                     |  749 ++++++++++--------
  arch/x86/kvm/i8254.c                       |  146 +++--
  arch/x86/kvm/i8254.h                       |    4 +-
  arch/x86/kvm/i8259.c                       |   48 +-
  arch/x86/kvm/irq.c                         |    2 +-
  arch/x86/kvm/irq.h                         |    4 -
  arch/x86/kvm/kvm_cache_regs.h              |    8 +
  arch/x86/kvm/lapic.c                       |   17 +-
  arch/x86/kvm/mmu.c                         |  807 ++++++++++++--------
  arch/x86/kvm/mmutrace.h                    |    2 +-
  arch/x86/kvm/paging_tmpl.h                 |  252 ++++---
  arch/x86/kvm/svm.c                         |  138 +++-
  arch/x86/kvm/timer.c                       |   16 +-
  arch/x86/kvm/vmx.c                         |  253 +++++--
  arch/x86/kvm/x86.c                         | 1174 
+++++++++++++++-------------
  arch/x86/kvm/x86.h                         |    7 -
  include/linux/kvm.h                        |   13 +
  include/linux/kvm_host.h                   |   35 +-
  include/linux/kvm_types.h                  |    4 +-
  include/linux/mm.h                         |    8 +
  mm/memory-failure.c                        |   33 +
  virt/kvm/assigned-dev.c                    |    7 +-
  virt/kvm/coalesced_mmio.c                  |    1 +
  virt/kvm/eventfd.c                         |    1 +
  virt/kvm/ioapic.c                          |    3 +-
  virt/kvm/iommu.c                           |   12 +-
  virt/kvm/irq_comm.c                        |   15 +-
  virt/kvm/kvm_main.c                        |  106 ++-
  63 files changed, 3328 insertions(+), 2103 deletions(-)
  create mode 100644 Documentation/kvm/msr.txt
  create mode 100644 Documentation/kvm/review-checklist.txt
  create mode 100644 arch/powerpc/kvm/book3s_mmu_hpte.c

-- 
error compiling committee.c: too many arguments to function

