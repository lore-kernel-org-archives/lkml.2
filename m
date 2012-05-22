Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914Ab2EVNIj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 09:08:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13733 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878Ab2EVNIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 09:08:37 -0400
Message-ID: <4FBB8FD0.9050804@redhat.com>
Date: Tue, 22 May 2012 16:08:32 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [GIT PULL] KVM updates for Linux 3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull the KVM updates for the 3.5 cycle from

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git next

Changes include additional instruction emulation, page-crossing MMIO,
faster dirty logging, preventing the watchdog from killing a stopped
guest, module autoload, a new MSI ABI, and some minor optimizations and
fixes.  Outside x86 we have a small s390 and a very large ppc update.

Regarding the new (for kvm) rebaseless workflow, some of the patches
that were merged before we switch trees had to be rebased, while others
are true pulls.  In either case the signoffs should be correct now.

----------------------------------------------------------------
Alexander Graf (37):
      KVM: PPC: Rework wqp conditional code
      KVM: PPC: e500mc: Add doorbell emulation support
      KVM: PPC: e500mc: implicitly set MSR_GS
      KVM: PPC: e500mc: Move r1/r2 restoration very early
      KVM: PPC: e500mc: add load inst fixup
      KVM: PPC: rename CONFIG_KVM_E500 -> CONFIG_KVM_E500V2
      KVM: PPC: make e500v2 kvm and e500mc cpu mutually exclusive
      KVM: PPC: booke: remove leftover debugging
      KVM: PPC: booke: deliver program int on emulation failure
      KVM: PPC: booke: rework rescheduling checks
      KVM: PPC: booke: BOOKE_IRQPRIO_MAX is n+1
      KVM: PPC: bookehv: fix exit timing
      KVM: PPC: bookehv: remove negation for CONFIG_64BIT
      KVM: PPC: bookehv: remove SET_VCPU
      KVM: PPC: bookehv: disable MAS register updates early
      KVM: PPC: bookehv: add comment about shadow_msr
      KVM: PPC: booke: Readd debug abort code for machine check
      KVM: PPC: booke: add GS documentation for program interrupt
      KVM: PPC: bookehv: remove unused code
      KVM: PPC: e500: fix typo in tlb code
      KVM: PPC: booke: Support perfmon interrupts
      KVM: PPC: booke: expose good state on irq reinject
      KVM: PPC: booke: Reinject performance monitor interrupts
      KVM: PPC: Booke: only prepare to enter when we enter
      KVM: PPC: Save/Restore CR over vcpu_run
      KVM: PPC: Pass EA to updating emulation ops
      KVM: PPC: Emulate tw and td instructions
      KVM: PPC: Book3s: PR: Add HV traps so we can run in HV=1 mode on p7
      KVM: PPC: Ignore unhalt request from kvm_vcpu_block
      KVM: PPC: Restrict PPC_[L|ST]D macro to asm code
      KVM: PPC: Book3S: PR: Optimize entry path
      KVM: PPC: Book3S: PR: No isync in slbie path
      KVM: PPC: Fix stbux emulation
      KVM: PPC: Fix PR KVM on POWER7 bare metal
      KVM: PPC: Book3S: Enable IRQs during exit handling
      KVM: PPC: Emulator: clean up instruction parsing
      KVM: PPC: Emulator: clean up SPR reads and writes

Amos Kong (2):
      KVM: resize kvm_io_range array dynamically
      KVM: set upper bounds for iobus dev to limit userspace

Avi Kivity (13):
      KVM: schedule debugfs statistics for removal
      KVM: x86 emulator: add support for vector alignment
      KVM: x86 emulator: implement movntps
      KVM: x86 emulator: MMX support
      KVM: x86 emulator: implement MMX MOVQ (opcodes 0f 6f, 0f 7f)
      KVM: Fix page-crossing MMIO
      KVM: ia64: fix build due to typo
      KVM: x86 emulator: fix asm constraint in flush_pending_x87_faults
      Merge branch 'for-upstream' of git://github.com/agraf/linux-2.6
into next
      KVM: VMX: Fix %ds/%es clobber
      KVM: VMX: Optimize %ds, %es reload
      KVM: MMU: Don't use RCU for lockless shadow walking
      KVM: Fix mmu_reload() clash with nested vmx event injection

Benjamin Herrenschmidt (3):
      powerpc/kvm: Fix magic page vs. 32-bit RTAS on ppc64
      kvm/book3s: Make kernel emulated H_PUT_TCE available for "PR" KVM
      kvm/powerpc: Add new ioctl to retreive server MMU infos

Bharat Bhushan (3):
      Restore guest CR after exit timing calculation
      KVM: Use minimum and maximum address mapped by TLB1
      KVM: PPC: Use clockevent multiplier and shifter for decrementer

Carsten Otte (2):
      KVM: s390: KVM_GET/SET_ONEREG for s390
      KVM: s390: epoch difference and TOD programmable field

Christian Borntraeger (3):
      KVM: s390: use kvm_vcpu_on_spin for diag 0x44
      KVM: s390: implement KVM_CAP_NR/MAX_VCPUS
      KVM: s390: add capability indicating COW support

Christoffer Dall (1):
      KVM: Factor out kvm_vcpu_kick to arch-generic code

Cornelia Huck (1):
      KVM: s390: Handle sckpf instruction

Davidlohr Bueso (2):
      KVM: x86: add paging gcc optimization
      KVM: MMU: use page table level macro

Eric B Munson (5):
      x86: pvclock: Add flag to indicate that a vm was stopped by the host
      kvmclock: Add functions to check if the host has stopped the vm
      KVM: x86: Add ioctl for KVM_KVMCLOCK_CTRL
      watchdog: add check for suspended vm in softlockup detector
      kvmclock: remove unneeded EXPORT macro

Gleb Natapov (2):
      KVM: Introduce bitmask for apic attention reasons
      KVM guest: make kvm_para_available() check hypervisor bit reading
cpuid leaf

Jan Kiszka (4):
      KVM: Introduce direct MSI message injection for in-kernel irqchips
      KVM: Improve readability of KVM API doc
      KVM: x86: Document in-kernel PIT API
      KVM: x86: Run PIT work in own kthread

Jason J. herne (1):
      KVM: s390: onereg for timer related registers

Jason Wang (1):
      KVM: SVM: count all irq windows exit

Joerg Roedel (1):
      KVM: x86 emulator: convert bsf/bsr instructions to
emulate_2op_SrcV_nobyte()

Josh Triplett (2):
      KVM: VMX: Auto-load on CPUs with VMX
      KVM: SVM: Auto-load on CPUs with SVM

Konstantin Weitz (1):
      KVM: s390: Implement the directed yield (diag 9c) hypervisor call
for KVM

Liu, Jinsong (1):
      KVM: x86: expose Intel cpu new features (HLE, RTM) to guest

Marcelo Tosatti (3):
      KVM: fix kvm_vcpu_kick build failure on S390
      Merge branch 'linus' into queue
      KVM: add kvm_arch_para_features stub to asm-generic/kvm_para.h

Matt Evans (1):
      KVM: PPC: Book3s: PR: Add SPAPR H_BULK_REMOVE support

Michael S. Tsirkin (2):
      KVM: dont clear TMR on EOI
      KVM: fix cpuid eax for KVM leaf

Mihai Caraman (2):
      KVM: PPC: bookehv: Use lwz/stw instead of PPC_LL/PPC_STL for
32-bit fields
      KVM: PPC: bookehv: Fix r8/r13 storing in level exception handler

Paul Gortmaker (1):
      KVM: make asm-generic/kvm_para.h have an ifdef __KERNEL__ block

Paul Mackerras (5):
      KVM: PPC: Book3S HV: Make secondary threads more robust against
stray IPIs
      KVM: PPC: Book3S HV: Make virtual processor area registration more
robust
      KVM: PPC: Book3S HV: Report stolen time to guest through dispatch
trace log
      KVM: PPC: Book 3S: Fix compilation for !HV configs
      KVM: PPC: Work around POWER7 DABR corruption problem

Scott Wood (16):
      powerpc/booke: Set CPU_FTR_DEBUG_LVL_EXC on 32-bit
      powerpc/e500: split CPU_FTRS_ALWAYS/CPU_FTRS_POSSIBLE
      KVM: PPC: factor out lpid allocator from book3s_64_mmu_hv
      KVM: PPC: booke: add booke-level vcpu load/put
      KVM: PPC: booke: Move vm core init/destroy out of booke.c
      KVM: PPC: e500: rename e500_tlb.h to e500.h
      KVM: PPC: e500: merge <asm/kvm_e500.h> into arch/powerpc/kvm/e500.h
      KVM: PPC: e500: clean up arch/powerpc/kvm/e500.h
      KVM: PPC: e500: refactor core-specific TLB code
      KVM: PPC: e500: Track TLB1 entries with a bitmap
      KVM: PPC: e500: emulate tlbilx
      powerpc/booke: Provide exception macros with interrupt name
      KVM: PPC: booke: category E.HV (GS-mode) support
      KVM: PPC: booke: standard PPC floating point support
      KVM: PPC: e500mc support
      KVM: PPC: add CPU_FTR_EMB_HV to CPU table

Stefan Hajnoczi (1):
      KVM: x86: emulate movdqa

Takuya Yoshikawa (8):
      KVM: MMU: Split the main body of rmap_write_protect() off from others
      KVM: Avoid checking huge page mappings in get_dirty_log()
      KVM: Switch to srcu-less get_dirty_log()
      KVM: Remove unused dirty_bitmap_head and nr_dirty_pages
      KVM: MMU: Make pte_list_desc fit cache lines well
      KVM: MMU: Improve iteration through sptes from rmap
      KVM: x86 emulator: Move ModRM flags for groups to top level opcode
tables
      KVM: x86 emulator: Avoid pushing back ModRM byte fetched for group
decoding

Varun Sethi (2):
      KVM: PPC: bookehv: Use a Macro for saving/restoring guest
registers to/from their 64 bit copies.
      KVM: PPC: booke(hv): Fix save/restore of guest accessible SPRGs.

Xiao Guangrong (1):
      KVM: VMX: unlike vmcs on fail path

 Documentation/feature-removal-schedule.txt  |    8 +
 Documentation/virtual/kvm/api.txt           |  281 ++++++++++-
 Documentation/virtual/kvm/cpuid.txt         |    6 +-
 Documentation/virtual/kvm/msr.txt           |    4 +
 arch/alpha/include/asm/kvm_para.h           |    1 +
 arch/arm/include/asm/kvm_para.h             |    1 +
 arch/avr32/include/asm/kvm_para.h           |    1 +
 arch/blackfin/include/asm/kvm_para.h        |    1 +
 arch/c6x/include/asm/kvm_para.h             |    1 +
 arch/frv/include/asm/kvm_para.h             |    1 +
 arch/h8300/include/asm/kvm_para.h           |    1 +
 arch/hexagon/include/asm/kvm_para.h         |    1 +
 arch/ia64/include/asm/kvm_host.h            |    3 +
 arch/ia64/include/asm/kvm_para.h            |    5 +
 arch/ia64/kvm/kvm-ia64.c                    |   32 +-
 arch/m68k/include/asm/kvm_para.h            |    1 +
 arch/microblaze/include/asm/kvm_para.h      |    1 +
 arch/mips/include/asm/kvm_para.h            |    1 +
 arch/mn10300/include/asm/kvm_para.h         |    1 +
 arch/openrisc/include/asm/kvm_para.h        |    1 +
 arch/parisc/include/asm/kvm_para.h          |    1 +
 arch/powerpc/include/asm/cputable.h         |   23 +-
 arch/powerpc/include/asm/dbell.h            |    3 +
 arch/powerpc/include/asm/hvcall.h           |   10 +
 arch/powerpc/include/asm/hw_irq.h           |    1 +
 arch/powerpc/include/asm/kvm.h              |    1 +
 arch/powerpc/include/asm/kvm_asm.h          |   18 +
 arch/powerpc/include/asm/kvm_book3s.h       |    3 +
 arch/powerpc/include/asm/kvm_book3s_asm.h   |    8 +
 arch/powerpc/include/asm/kvm_booke.h        |    3 +
 arch/powerpc/include/asm/kvm_booke_hv_asm.h |   49 ++
 arch/powerpc/include/asm/kvm_e500.h         |   96 ----
 arch/powerpc/include/asm/kvm_host.h         |   60 ++-
 arch/powerpc/include/asm/kvm_para.h         |    5 +
 arch/powerpc/include/asm/kvm_ppc.h          |   20 +-
 arch/powerpc/include/asm/mmu-book3e.h       |    6 +
 arch/powerpc/include/asm/processor.h        |    3 +
 arch/powerpc/include/asm/reg.h              |    2 +
 arch/powerpc/include/asm/reg_booke.h        |   34 ++
 arch/powerpc/include/asm/switch_to.h        |    1 +
 arch/powerpc/include/asm/time.h             |    1 +
 arch/powerpc/kernel/asm-offsets.c           |   19 +-
 arch/powerpc/kernel/cpu_setup_fsl_booke.S   |    1 +
 arch/powerpc/kernel/exceptions-64s.S        |   12 +-
 arch/powerpc/kernel/head_44x.S              |   23 +-
 arch/powerpc/kernel/head_booke.h            |   69 ++-
 arch/powerpc/kernel/head_fsl_booke.S        |   98 +++-
 arch/powerpc/kernel/idle_power7.S           |    7 +
 arch/powerpc/kernel/ppc_ksyms.c             |    4 +
 arch/powerpc/kernel/time.c                  |    3 +-
 arch/powerpc/kvm/44x.c                      |   12 +
 arch/powerpc/kvm/44x_emulate.c              |   51 +-
 arch/powerpc/kvm/Kconfig                    |   28 +-
 arch/powerpc/kvm/Makefile                   |   17 +-
 arch/powerpc/kvm/book3s.c                   |    7 +-
 arch/powerpc/kvm/book3s_64_mmu_hv.c         |   31 +-
 arch/powerpc/kvm/book3s_64_slb.S            |    2 -
 arch/powerpc/kvm/book3s_64_vio.c            |  150 ++++++
 arch/powerpc/kvm/book3s_64_vio_hv.c         |    3 +
 arch/powerpc/kvm/book3s_emulate.c           |  106 ++---
 arch/powerpc/kvm/book3s_hv.c                |  467 +++++++++++--------
 arch/powerpc/kvm/book3s_hv_interrupts.S     |    9 +-
 arch/powerpc/kvm/book3s_hv_rmhandlers.S     |  185 ++++----
 arch/powerpc/kvm/book3s_pr.c                |   59 +++
 arch/powerpc/kvm/book3s_pr_papr.c           |  101 +++-
 arch/powerpc/kvm/book3s_segment.S           |   48 +-
 arch/powerpc/kvm/booke.c                    |  471 +++++++++++++++----
 arch/powerpc/kvm/booke.h                    |   62 ++-
 arch/powerpc/kvm/booke_emulate.c            |  118 +++--
 arch/powerpc/kvm/booke_interrupts.S         |    8 +-
 arch/powerpc/kvm/bookehv_interrupts.S       |  597 ++++++++++++++++++++++++
 arch/powerpc/kvm/e500.c                     |  372 ++++++++++++---
 arch/powerpc/kvm/e500.h                     |  306 ++++++++++++
 arch/powerpc/kvm/e500_emulate.c             |  210 +++++++--
 arch/powerpc/kvm/e500_tlb.c                 |  666
+++++++++++++--------------
 arch/powerpc/kvm/e500_tlb.h                 |  174 -------
 arch/powerpc/kvm/e500mc.c                   |  342 ++++++++++++++
 arch/powerpc/kvm/emulate.c                  |  197 +++-----
 arch/powerpc/kvm/powerpc.c                  |   94 +++-
 arch/powerpc/kvm/timing.h                   |    6 +
 arch/s390/include/asm/kvm.h                 |    5 +
 arch/s390/include/asm/kvm_host.h            |    1 +
 arch/s390/include/asm/kvm_para.h            |    5 +
 arch/s390/include/asm/sclp.h                |    1 +
 arch/s390/kvm/diag.c                        |   29 +-
 arch/s390/kvm/intercept.c                   |    1 +
 arch/s390/kvm/kvm-s390.c                    |   87 ++++
 arch/s390/kvm/kvm-s390.h                    |    1 +
 arch/s390/kvm/priv.c                        |   31 ++
 arch/score/include/asm/kvm_para.h           |    1 +
 arch/sh/include/asm/kvm_para.h              |    1 +
 arch/sparc/include/asm/kvm_para.h           |    1 +
 arch/tile/include/asm/kvm_para.h            |    1 +
 arch/um/include/asm/kvm_para.h              |    1 +
 arch/unicore32/include/asm/kvm_para.h       |    1 +
 arch/x86/include/asm/kvm_emulate.h          |    4 +-
 arch/x86/include/asm/kvm_host.h             |   13 +-
 arch/x86/include/asm/kvm_para.h             |   24 +-
 arch/x86/include/asm/pvclock-abi.h          |    1 +
 arch/x86/kernel/kvmclock.c                  |   20 +
 arch/x86/kvm/Kconfig                        |    1 +
 arch/x86/kvm/cpuid.c                        |    5 +-
 arch/x86/kvm/emulate.c                      |  293 ++++++++----
 arch/x86/kvm/i8254.c                        |   31 +-
 arch/x86/kvm/i8254.h                        |    7 +-
 arch/x86/kvm/lapic.c                        |   31 +-
 arch/x86/kvm/mmu.c                          |  345 ++++++++------
 arch/x86/kvm/mmu_audit.c                    |   10 +-
 arch/x86/kvm/paging_tmpl.h                  |    2 +-
 arch/x86/kvm/svm.c                          |    9 +-
 arch/x86/kvm/vmx.c                          |   41 +-
 arch/x86/kvm/x86.c                          |  280 ++++++-----
 arch/x86/kvm/x86.h                          |    2 +-
 arch/xtensa/include/asm/kvm_para.h          |    1 +
 drivers/s390/char/sclp_cmd.c                |   12 +-
 include/asm-generic/kvm_para.h              |   22 +
 include/linux/kvm.h                         |   42 ++
 include/linux/kvm_host.h                    |   55 ++-
 kernel/watchdog.c                           |   12 +
 virt/kvm/Kconfig                            |    3 +
 virt/kvm/ioapic.c                           |   10 +-
 virt/kvm/ioapic.h                           |    1 +
 virt/kvm/irq_comm.c                         |   14 +
 virt/kvm/kvm_main.c                         |  132 ++++--
 124 files changed, 5443 insertions(+), 1982 deletions(-)
 create mode 100644 arch/alpha/include/asm/kvm_para.h
 create mode 100644 arch/arm/include/asm/kvm_para.h
 create mode 100644 arch/avr32/include/asm/kvm_para.h
 create mode 100644 arch/blackfin/include/asm/kvm_para.h
 create mode 100644 arch/c6x/include/asm/kvm_para.h
 create mode 100644 arch/frv/include/asm/kvm_para.h
 create mode 100644 arch/h8300/include/asm/kvm_para.h
 create mode 100644 arch/hexagon/include/asm/kvm_para.h
 create mode 100644 arch/m68k/include/asm/kvm_para.h
 create mode 100644 arch/microblaze/include/asm/kvm_para.h
 create mode 100644 arch/mips/include/asm/kvm_para.h
 create mode 100644 arch/mn10300/include/asm/kvm_para.h
 create mode 100644 arch/openrisc/include/asm/kvm_para.h
 create mode 100644 arch/parisc/include/asm/kvm_para.h
 create mode 100644 arch/powerpc/include/asm/kvm_booke_hv_asm.h
 delete mode 100644 arch/powerpc/include/asm/kvm_e500.h
 create mode 100644 arch/powerpc/kvm/book3s_64_vio.c
 create mode 100644 arch/powerpc/kvm/bookehv_interrupts.S
 create mode 100644 arch/powerpc/kvm/e500.h
 delete mode 100644 arch/powerpc/kvm/e500_tlb.h
 create mode 100644 arch/powerpc/kvm/e500mc.c
 create mode 100644 arch/score/include/asm/kvm_para.h
 create mode 100644 arch/sh/include/asm/kvm_para.h
 create mode 100644 arch/sparc/include/asm/kvm_para.h
 create mode 100644 arch/tile/include/asm/kvm_para.h
 create mode 100644 arch/um/include/asm/kvm_para.h
 create mode 100644 arch/unicore32/include/asm/kvm_para.h
 create mode 100644 arch/xtensa/include/asm/kvm_para.h
 create mode 100644 include/asm-generic/kvm_para.h

-- 
error compiling committee.c: too many arguments to function

