Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab1EWIIf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 04:08:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45540 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751485Ab1EWIId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 04:08:33 -0400
Message-ID: <4DDA15DB.1040308@redhat.com>
Date: Mon, 23 May 2011 11:07:55 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] KVM updates for 2.6.40
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from:

   git://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/2.6.40

to receive the KVM updates for the 2.6.40 cycle.  Changes this time 
include emulator correctness (segment checks, nested SVM intercepts), 
16-byte MMIO, Via CPU feature support, virtual TSC rate for newer AMD 
processors, better RCU integration, and performance improvements.

Changelog/diffstat (includes already-merged RCU commits):

Avi Kivity (56):
       KVM: Use kvm_get_rflags() and kvm_set_rflags() instead of the raw 
versions
       KVM: VMX: Optimize vmx_get_rflags()
       KVM: VMX: Optimize vmx_get_cpl()
       KVM: VMX: Cache cpl
       KVM: VMX: Avoid vmx_recover_nmi_blocking() when unneeded
       KVM: VMX: Qualify check for host NMI
       KVM: VMX: Refactor vmx_complete_atomic_exit()
       KVM: VMX: Don't VMREAD VM_EXIT_INTR_INFO unconditionally
       KVM: VMX: Use cached VM_EXIT_INTR_INFO in handle_exception
       KVM: VMX: simplify NMI mask management
       KVM: extend in-kernel mmio to handle >8 byte transactions
       KVM: Split mmio completion into a function
       KVM: 16-byte mmio support
       KVM: x86 emulator: do not munge rep prefix
       KVM: x86 emulator: define callbacks for using the guest fpu 
within the emulator
       KVM: x86 emulator: Specialize decoding for insns with 66/f2/f3 
prefixes
       KVM: x86 emulator: SSE support
       KVM: x86 emulator: implement movdqu instruction (f3 0f 6f, f3 0f 7f)
       KVM: x86 emulator: add framework for instruction intercepts
       KVM: x86 emulator: add SVM intercepts
       KVM: x86 emulator: Re-add VendorSpecific tag to VMMCALL insn
       KVM: x86 emulator: Drop EFER.SVME requirement from VMMCALL
       KVM: x86 emulator: Add helpers for memory access using segmented 
addresses
       KVM: x86 emulator: move invlpg emulation into a function
       KVM: x86 emulator: change address linearization to return an 
error code
       KVM: x86 emulator: pass access size and read/write intent to 
linearize()
       KVM: x86 emulator: move linearize() downwards
       KVM: x86 emulator: move desc_limit_scaled()
       KVM: x86 emulator: implement segment permission checks
       KVM: x86 emulator: whitespace cleanups
       KVM: x86 emulator: drop vcpu argument from memory read/write 
callbacks
       KVM: x86 emulator: drop vcpu argument from pio callbacks
       KVM: x86 emulator: drop vcpu argument from segment/gdt/idt callbacks
       KVM: x86 emulator: drop vcpu argument from cr/dr/cpl/msr callbacks
       KVM: x86 emulator: drop vcpu argument from intercept callback
       KVM: x86 emulator: avoid using ctxt->vcpu in check_perm() callbacks
       KVM: x86 emulator: add and use new callbacks set_idt(), set_gdt()
       KVM: x86 emulator: drop use of is_long_mode()
       KVM: x86 emulator: Replace calls to is_pae() and is_paging with 
->get_cr()
       KVM: x86 emulator: emulate CLTS internally
       KVM: x86 emulator: make emulate_invlpg() an emulator callback
       KVM: x86 emulator: add new ->halt() callback
       KVM: x86 emulator: add ->fix_hypercall() callback
       KVM: x86 emulator: add new ->wbinvd() callback
       KVM: Avoid using x86_emulate_ctxt.vcpu
       KVM: x86 emulator: drop x86_emulate_ctxt::vcpu
       KVM: x86 emulator: move 0F 01 sub-opcodes into their own functions
       KVM: x86 emulator: Don't force #UD for 0F 01 /5
       KVM: x86 emulator: Use opcode::execute for 0F 01 opcode
       KVM: SVM: Get rid of x86_intercept_map::valid
       KVM: MMU: Add unlikely() annotations to walk_addr_generic()
       KVM: x86 emulator: consolidate group handling
       KVM: VMX: Avoid reading %rip unnecessarily when handling exceptions
       KVM: x86 emulator: consolidate segment accessors
       KVM: VMX: Cache vmcs segment fields
       Merge commit '29ce831000081dd757d3116bf774aafffc4b6b20' into next

Bharat Bhushan (1):
       KVM: PPC: Fix issue clearing exit timing counters

BrillyWu@viatech.com.cn (1):
       KVM: Add CPUID support for VIA CPU

Clemens Noss (1):
       KVM: x86 emulator: avoid calling wbinvd() macro

Duan Jiong (2):
       KVM: remove useless function declarations from file 
arch/x86/kvm/irq.h
       KVM: remove useless function declaration kvm_inject_pit_timer_irqs()

Glauber Costa (1):
       KVM: expose async pf through our standard mechanism

Gleb Natapov (8):
       KVM: x86: better fix for race between nmi injection and enabling 
nmi window
       KVM: x86 emulator: do not open code return values from the emulator
       KVM: emulator: do not needlesly sync registers from emulator ctxt 
to vcpu
       KVM: mmio_fault_cr2 is not used
       KVM: emulator: Propagate fault in far jump emulation
       KVM: Fix compound mmio
       KVM: call cache_all_regs() only once during instruction emulation
       KVM: make guest mode entry to be rcu quiescent state

Jan Kiszka (2):
       KVM: SVM: Remove unused svm_features
       KVM: VMX: Ensure that vmx_create_vcpu always returns proper error

Jeff Mahoney (2):
       KVM: Fix off by one in kvm_for_each_vcpu iteration
       KVM: ia64: fix sparse warnings

Joe Perches (1):
       KVM: SVM: Make dump_vmcb static, reduce text

Joerg Roedel (22):
       KVM: x86 emulator: Don't write-back cpu-state on X86EMUL_INTERCEPTED
       KVM: x86 emulator: Add check_perm callback
       KVM: x86 emulator: Add flag to check for protected mode instructions
       KVM: x86: Add x86 callback for intercept check
       KVM: SVM: Add intercept check for emulated cr accesses
       KVM: SVM: Add intercept check for accessing dr registers
       KVM: SVM: Add intercept checks for descriptor table accesses
       KVM: SVM: Add intercept checks for SVM instructions
       KVM: SVM: Add intercept checks for remaining group7 instructions
       KVM: SVM: Add intercept checks for remaining twobyte instructions
       KVM: SVM: Add intercept checks for one-byte instructions
       KVM: SVM: Add checks for IO instructions
       KVM: SVM: Remove nested sel_cr0_write handling code
       KVM: SVM: Implement infrastructure for TSC_RATE_MSR
       KVM: X86: Let kvm-clock report the right tsc frequency
       KVM: X86: Make tsc_delta calculation a function of guest tsc
       KVM: X86: Implement call-back to propagate virtual_tsc_khz
       KVM: X86: Delegate tsc-offset calculation to architecture code
       KVM: X86: Implement userspace interface to set virtual_tsc_khz
       KVM: SVM: Fix fault-rip on vmsave/vmload emulation
       KVM: SVM: Fix nested sel_cr0 intercept path with decode-assists
       KVM: X86: Update last_guest_tsc in vcpu_put

Justin P. Mattock (1):
       KVM: Remove base_addresss in kvm_pit since it is unused

Liu Yuan (1):
       KVM: ioapic: Fix an error field reference

Marcelo Tosatti (1):
       Revert "KVM: Fix race between nmi injection and enabling nmi window"

Nelson Elhage (2):
       KVM: x86 emulator: Handle wraparound in (cs_base + offset) when 
fetching insns
       KVM: emulator: Use linearize() when fetching instructions

OGAWA Hirofumi (1):
       KVM: Fix kvm mmu_notifier initialization order

Pekka Enberg (1):
       KVM: Add documentation for KVM_CAP_NR_VCPUS

Randy Dunlap (1):
       KVM: x86 emulator: fix const value warning on i386 in svm insn 
RAX check

Roedel, Joerg (1):
       KVM: MMU: Make cmpxchg_gpte aware of nesting too

Scott Wood (4):
       KVM: PPC: e500: emulate SVR
       KVM: PPC: fix exit accounting for SPRs, tlbwe, tlbsx
       KVM: PPC: booke: save/restore VRSAVE (a.k.a. USPRG0)
       KVM: PPC: booke: add sregs support

Serge E. Hallyn (1):
       KVM: fix push of wrong eip when doing softint

Stuart Yoder (1):
       KVM: PPC: use ticks, not usecs, for exit timing

Takuya Yoshikawa (18):
       KVM: x86 emulator: Disable writeback for CMP emulation
       KVM: x86 emulator: Make emulate_push() store the value directly
       KVM: x86 emulator: Use em_push() instead of emulate_push()
       KVM: MMU: Optimize guest page table walk
       KVM: x86 emulator: Use opcode::execute for Group 1, CMPS and SCAS
       KVM: x86 emulator: Use opcode::execute for POP reg (58-5F)
       KVM: x86 emulator: Use opcode::execute for PUSHA/POPA (60/61)
       KVM: x86 emulator: Use opcode::execute for PUSHF/POPF (9C/9D)
       KVM: MMU: Fix 64-bit paging breakage on x86_32
       KVM: MMU: Clean up gpte reading with copy_from_user()
       KVM: Validate userspace_addr of memslot when registered
       KVM: x86 emulator: Remove unused arg from seg_override()
       KVM: x86 emulator: Remove unused arg from read_descriptor()
       KVM: x86 emulator: Remove unused arg from writeback()
       KVM: x86 emulator: Remove unused arg from emulate_pop()
       KVM: x86 emulator: Rename emulate_grpX() to em_grpX()
       KVM: x86 emulator: Make jmp far emulation into a separate function
       KVM: MMU: Use ptep_user for cmpxchg_gpte()

Xiao Guangrong (2):
       KVM: cleanup memslot_id function
       KVM: MMU: remove mmu_seq verification on pte update path

  Documentation/RCU/00-INDEX          |    2 +-
  Documentation/RCU/stallwarn.txt     |   23 +-
  Documentation/RCU/trace.txt         |  295 +++++--
  Documentation/filesystems/proc.txt  |    1 -
  Documentation/kvm/api.txt           |   34 +-
  arch/ia64/kvm/vti.h                 |   26 +-
  arch/powerpc/include/asm/kvm.h      |  184 ++++
  arch/powerpc/include/asm/kvm_44x.h  |    1 -
  arch/powerpc/include/asm/kvm_e500.h |    2 +
  arch/powerpc/include/asm/kvm_host.h |    5 +
  arch/powerpc/include/asm/kvm_ppc.h  |    9 +
  arch/powerpc/kernel/asm-offsets.c   |    1 +
  arch/powerpc/kvm/44x.c              |   10 +
  arch/powerpc/kvm/44x_emulate.c      |    2 -
  arch/powerpc/kvm/booke.c            |  154 +++-
  arch/powerpc/kvm/booke_interrupts.S |    1 -
  arch/powerpc/kvm/e500.c             |   76 ++
  arch/powerpc/kvm/e500_emulate.c     |    7 +-
  arch/powerpc/kvm/e500_tlb.c         |   13 +-
  arch/powerpc/kvm/emulate.c          |   15 +-
  arch/powerpc/kvm/powerpc.c          |   21 +
  arch/powerpc/kvm/timing.c           |   31 +-
  arch/x86/include/asm/kvm_emulate.h  |  193 +++-
  arch/x86/include/asm/kvm_host.h     |   55 +-
  arch/x86/include/asm/msr-index.h    |    1 +
  arch/x86/kvm/emulate.c              | 1806 
+++++++++++++++++++++++------------
  arch/x86/kvm/i8254.h                |    2 -
  arch/x86/kvm/irq.h                  |    2 -
  arch/x86/kvm/mmu.c                  |   16 +-
  arch/x86/kvm/paging_tmpl.h          |   83 ++-
  arch/x86/kvm/svm.c                  |  585 +++++++++---
  arch/x86/kvm/vmx.c                  |  228 ++++-
  arch/x86/kvm/x86.c                  |  570 ++++++++----
  arch/x86/kvm/x86.h                  |    2 +-
  include/linux/interrupt.h           |    1 -
  include/linux/kvm.h                 |    6 +
  include/linux/kvm_host.h            |   30 +-
  include/linux/rcupdate.h            |   70 ++-
  include/linux/rcutiny.h             |    8 +
  include/linux/rcutree.h             |   13 +
  include/trace/events/irq.h          |    3 +-
  init/Kconfig                        |    2 +-
  kernel/rcupdate.c                   |   32 +-
  kernel/rcutiny.c                    |   45 +-
  kernel/rcutiny_plugin.h             |  203 ++---
  kernel/rcutorture.c                 |   26 +-
  kernel/rcutree.c                    |  672 +++++++++++---
  kernel/rcutree.h                    |  116 ++-
  kernel/rcutree_plugin.h             |  595 +++++++++---
  kernel/rcutree_trace.c              |  192 ++++-
  kernel/softirq.c                    |    2 +-
  lib/Kconfig.debug                   |   32 +-
  tools/perf/util/trace-event-parse.c |    1 -
  virt/kvm/ioapic.c                   |    2 +-
  virt/kvm/kvm_main.c                 |   26 +-
  55 files changed, 4863 insertions(+), 1670 deletions(-)

-- 
error compiling committee.c: too many arguments to function

