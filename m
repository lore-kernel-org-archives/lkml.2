Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab2LLMhF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 07:37:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61302 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908Ab2LLMhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 07:37:01 -0500
Date: Wed, 12 Dec 2012 10:35:19 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Avi Kivity <avi.kivity@gmail.com>
Subject: [GIT PULL] KVM updates for the 3.8 merge window
Message-ID: <20121212123519.GA11549@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Please pull from

git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/kvm-3.8-1 

to receive the KVM updates for the 3.8 merge window, including
considerable KVM/PPC work, x86 kvmclock vsyscall support, IA32_TSC_ADJUST
MSR emulation, amongst others.

----


Alex Williamson (2):
      KVM: Fix user memslot overlap check
      kvm: Fix irqfd resampler list walk

Alexander Graf (37):
      KVM: PPC: PR: Use generic tracepoint for guest exit
      KVM: PPC: Expose SYNC cap based on mmu notifiers
      KVM: PPC: BookE: Expose remote TLB flushes in debugfs
      KVM: PPC: E500: Fix clear_tlb_refs
      KVM: PPC: BookE: Add check_requests helper function
      KVM: PPC: BookE: Add support for vcpu->mode
      KVM: PPC: E500: Implement MMU notifiers
      KVM: PPC: BookE: Add some more trace points
      KVM: PPC: BookE: No duplicate request != 0 check
      KVM: PPC: Use same kvmppc_prepare_to_enter code for booke and book3s_pr
      KVM: PPC: Book3s: PR: Add (dumb) MMU Notifier support
      KVM: PPC: BookE: Drop redundant vcpu->mode set
      KVM: PPC: Book3S: PR: Only do resched check once per exit
      KVM: PPC: Exit guest context while handling exit
      KVM: PPC: Book3S: PR: Indicate we're out of guest mode
      KVM: PPC: Consistentify vcpu exit path
      KVM: PPC: Book3S: PR: Rework irq disabling
      KVM: PPC: Move kvm_guest_enter call into generic code
      KVM: PPC: Ignore EXITING_GUEST_MODE mode
      KVM: PPC: Add return value in prepare_to_enter
      KVM: PPC: Add return value to core_check_requests
      KVM: PPC: 44x: Initialize PVR
      KVM: PPC: BookE: Add MCSR SPR support
      KVM: PPC: Use symbols for exit trace
      KVM: PPC: E500: Remove E500_TLB_DIRTY flag
      KVM: PPC: 440: Implement mtdcrx
      KVM: PPC: 440: Implement mfdcrx
      KVM: PPC: BookE: Support FPU on non-hv systems
      KVM: PPC: 44x: fix DCR read/write
      KVM: Documentation: Fix reentry-to-be-consistent paragraph
      KVM: PPC: Move mtspr/mfspr emulation into own functions
      PPC: ePAPR: Convert header to uapi
      Merge commit 'origin/queue' into for-queue
      PPC: ePAPR: Convert hcall header to uapi (round 2)
      KVM: Distangle eventfd code from irqchip
      KVM: PPC: Support eventfd
      KVM: PPC: Make EPCR a valid field for booke64 and bookehv

Bharat Bhushan (3):
      KVM: PPC: booke: Add watchdog emulation
      booke: Added ONE_REG interface for IAC/DAC debug registers
      Document IACx/DACx registers access using ONE_REG API

Borislav Petkov (1):
      KVM: SVM: Cleanup error statements

Christian Borntraeger (1):
      s390/kvm: dont announce RRBM support

Christoffer Dall (1):
      KVM: Take kvm instead of vcpu to mmu_notifier_retry

Cornelia Huck (1):
      s390/kvm: Add documentation for KVM_S390_INTERRUPT

Gleb Natapov (5):
      KVM: do not de-cache cr4 bits needlessly
      KVM: use is_idle_task() instead of idle_cpu() to decide when to halt in async_pf
      KVM: VMX: fix DPL during entry to protected mode
      VMX: remove unneeded enable_unrestricted_guest check
      KVM: emulator: fix real mode segment checks in address linearization

Guo Chao (3):
      KVM: do not kfree error pointer
      KVM: x86: fix return value of kvm_vm_ioctl_set_tss_addr()
      KVM: remove unnecessary return value check

Jan Kiszka (3):
      KVM: x86: Convert kvm_arch_vcpu_reset into private kvm_vcpu_reset
      KVM: x86: Make emulator_fix_hypercall static
      KVM: x86: Fix uninitialized return code

Jason J. Herne (1):
      s390/kvm: Interrupt injection bugfix

Joerg Roedel (1):
      KVM: SVM: update MAINTAINERS entry

Julia Lawall (1):
      arch/powerpc/kvm/e500_tlb.c: fix error return code

Julian Stecklina (1):
      KVM: x86: Make register state after reset conform to specification

Liu Yu-B13201 (3):
      KVM: PPC: Add support for ePAPR idle hcall in host kernel
      KVM: PPC: ev_idle hcall support for e500 guests
      PPC: Don't use hardcoded opcode for ePAPR hcall invocation

Marcelo Tosatti (22):
      Merge branch 'for-upstream' of http://github.com/agraf/linux-2.6 into queue
      Merge remote-tracking branch 'master' into queue
      Merge branch 'for-queue' of https://github.com/agraf/linux-2.6 into queue
      KVM: x86: retain pvclock guest stopped bit in guest memory
      x86: kvmclock: allocate pvclock shared memory area
      x86: pvclock: make sure rdtsc doesnt speculate out of region
      x86: pvclock: remove pvclock_shadow_time
      x86: pvclock: create helper for pvclock data retrieval
      x86: pvclock: introduce helper to read flags
      x86: pvclock: add note about rdtsc barriers
      sched: add notifier for cross-cpu migrations
      x86: pvclock: generic pvclock vsyscall initialization
      x86: kvm guest: pvclock vsyscall support
      x86: vdso: pvclock gettime support
      KVM: x86: pass host_tsc to read_l1_tsc
      time: export time information for KVM pvclock
      KVM: x86: notifier for clocksource changes
      KVM: x86: implement PVCLOCK_TSC_STABLE_BIT pvclock flag
      KVM: x86: add kvm_arch_vcpu_postcreate callback, move TSC initialization
      KVM: x86: require matched TSC offsets for master clock
      KVM: x86: update pvclock area conditionally, on cpu migration
      Merge branch 'for-upstream' of https://github.com/agraf/linux-2.6 into queue

Michael Ellerman (1):
      MAINTAINERS: Add git tree link for PPC KVM

Michael S. Tsirkin (2):
      kvm: add kvm_set_irq_inatomic
      kvm: deliver msi interrupts from irq handler

Mihai Caraman (12):
      KVM: PPC: bookehv: Allow duplicate calls of DO_KVM macro
      KVM: PPC: e500: Silence bogus GCC warning in tlb code
      KVM: PPC: booke: Fix get_tb() compile error on 64-bit
      KVM: PPC: bookehv: Remove GET_VCPU macro from exception handler
      KVM: PPC: bookehv64: Add support for interrupt handling
      KVM: PPC: e500: Add emulation helper for getting instruction ea
      KVM: PPC: Mask ea's high 32-bits in 32/64 instr emulation
      KVM: PPC: e500: Mask MAS2 EPN high 32-bits in 32/64 tlbwe emulation
      KVM: PPC: booke: Extend MAS2 EPN mask for 64-bit
      KVM: PPC: bookehv: Add guest computation mode for irq delivery
      KVM: PPC: bookehv: Add EPCR support in mtspr/mfspr emulation
      KVM: PPC: booke: Get/set guest EPCR register using ONE_REG interface

Paul Mackerras (32):
      KVM: PPC: Quieten message about allocating linear regions
      KVM: PPC: Book3S HV: Take the SRCU read lock before looking up memslots
      KVM: PPC: Move kvm->arch.slot_phys into memslot.arch
      KVM: PPC: Book3S HV: Handle memory slot deletion and modification correctly
      KVM: Move some PPC ioctl definitions to the correct place
      KVM: PPC: Book3S HV: Fix updates of vcpu->cpu
      KVM: PPC: Book3S HV: Remove bogus update of physical thread IDs
      KVM: PPC: Book3S HV: Fix calculation of guest phys address for MMIO emulation
      KVM: PPC: Book3S: Get/set guest SPRs using the GET/SET_ONE_REG interface
      KVM: PPC: Book3S: Get/set guest FP regs using the GET/SET_ONE_REG interface
      KVM: PPC: Book3S HV: Provide a way for userspace to get/set per-vCPU areas
      KVM: PPC: Book3S HV: Allow KVM guests to stop secondary threads coming online
      KVM: PPC: Book3S HV: Fix some races in starting secondary threads
      KVM: PPC: Book3s HV: Don't access runnable threads list without vcore lock
      KVM: PPC: Book3S HV: Fixes for late-joining threads
      KVM: PPC: Book3S HV: Run virtual core whenever any vcpus in it can run
      KVM: PPC: Book3S HV: Fix accounting of stolen time
      KVM: PPC: Book3S HV: Allow DTL to be set to address 0, length 0
      KVM: PPC: Book3S HV: Fix thinko in try_lock_hpte()
      KVM: PPC: Book3S HV: Restructure HPT entry creation code
      KVM: PPC: Book3S HV: Fix bug causing loss of page dirty state
      KVM: PPC: Book3S HV: Add a mechanism for recording modified HPTEs
      KVM: PPC: Book3S HV: Make a HPTE removal function available
      KVM: PPC: Book3S HV: Provide a method for userspace to read and write the HPT
      KVM: PPC: Book3S HV: Reset reverse-map chains when resetting the HPT
      KVM: PPC: Book3S HV: Report correct HPT entry index when reading HPT
      KVM: PPC: Book3S HV: Don't give the guest RW access to RO pages
      KVM: PPC: Book3S PR: Emulate PURR, SPURR and DSCR registers
      KVM: PPC: Book3S PR: Fix VSX handling
      KVM: PPC: Book3S PR: MSR_DE doesn't exist on Book 3S
      KVM: PPC: Book3S HV: Improve handling of local vs. global TLB invalidations
      KVM: PPC: Book3S HV: Handle guest-caused machine checks on POWER7 without panicking

Scott Wood (5):
      powerpc/fsl-soc: use CONFIG_EPAPR_PARAVIRT for hcalls
      powerpc/epapr: export epapr_hypercall_start
      KVM: PPC: e500: fix allocation size error on g2h_tlb1_map
      KVM: PPC: e500: MMU API: fix leak of shared_tlb_pages
      KVM: PPC: set IN_GUEST_MODE before checking requests

Shuah Khan (1):
      KVM: change kvm_assign_device() to print return value when iommu_attach_device() fails

Stuart Yoder (4):
      PPC: epapr: create define for return code value of success
      KVM: PPC: use definitions in epapr header for hcalls
      KVM: PPC: add pvinfo for hcall opcodes on e500mc/e5500
      PPC: select EPAPR_PARAVIRT for all users of epapr hcalls

Wei Yongjun (1):
      KVM: ia64: remove unused variable in kvm_release_vm_pages()

Will Auld (2):
      KVM: x86: Add code to track call origin for msr assignment
      KVM: x86: Emulate IA32_TSC_ADJUST MSR

Xiao Guangrong (10):
      KVM: MMU: remove mmu_is_invalid
      KVM: MMU: cleanup FNAME(page_fault)
      KVM: MMU: move prefetch_invalid_gpte out of pagaing_tmp.h
      KVM: MMU: introduce FNAME(prefetch_gpte)
      KVM: VMX: report internal error for the unhandleable event
      KVM: VMX: report internal error for MMIO #PF due to delivery event
      KVM: do not treat noslot pfn as a error pfn
      KVM: VMX: fix invalid cpu passed to smp_call_function_single
      KVM: VMX: fix memory order between loading vmcs and clearing vmcs
      KVM: MMU: optimize for set_spte

Zhang Xiantao (2):
      kvm: remove unnecessary bit checking for ept violation
      kvm: don't use bit24 for detecting address-specific invalidation capability

Zhang Yanfei (3):
      x86/kexec: VMCLEAR VMCSs loaded on all cpus if necessary
      KVM: VMX: provide the vmclear function and a bitmap to support VMCLEAR in kdump
      x86/kexec: crash_vmclear_local_vmcss needs __rcu



 Documentation/virtual/kvm/api.txt            |  140 +++++
 MAINTAINERS                                  |    5 
 arch/ia64/kvm/kvm-ia64.c                     |    7 
 arch/powerpc/include/asm/Kbuild              |    2 
 arch/powerpc/include/asm/epapr_hcalls.h      |  549 ++++++++++++++++++--
 arch/powerpc/include/asm/fsl_hcalls.h        |   36 -
 arch/powerpc/include/asm/kvm.h               |   59 ++
 arch/powerpc/include/asm/kvm_asm.h           |    1 
 arch/powerpc/include/asm/kvm_book3s.h        |   12 
 arch/powerpc/include/asm/kvm_book3s_64.h     |   33 +
 arch/powerpc/include/asm/kvm_booke_hv_asm.h  |   29 +
 arch/powerpc/include/asm/kvm_host.h          |   72 ++
 arch/powerpc/include/asm/kvm_para.h          |   21 
 arch/powerpc/include/asm/kvm_ppc.h           |   89 +++
 arch/powerpc/include/asm/mmu-book3e.h        |    2 
 arch/powerpc/include/asm/mmu-hash64.h        |   10 
 arch/powerpc/include/asm/reg.h               |    1 
 arch/powerpc/include/asm/reg_booke.h         |    7 
 arch/powerpc/include/asm/smp.h               |    8 
 arch/powerpc/include/uapi/asm/Kbuild         |    1 
 arch/powerpc/include/uapi/asm/epapr_hcalls.h |  576 +++++----------------
 arch/powerpc/include/uapi/asm/kvm.h          |   27 +
 arch/powerpc/kernel/asm-offsets.c            |    4 
 arch/powerpc/kernel/epapr_hcalls.S           |   28 +
 arch/powerpc/kernel/epapr_paravirt.c         |   11 
 arch/powerpc/kernel/kvm.c                    |    2 
 arch/powerpc/kernel/ppc_ksyms.c              |    5 
 arch/powerpc/kernel/smp.c                    |   46 +
 arch/powerpc/kvm/44x.c                       |    1 
 arch/powerpc/kvm/44x_emulate.c               |  112 ++--
 arch/powerpc/kvm/Kconfig                     |    4 
 arch/powerpc/kvm/Makefile                    |    5 
 arch/powerpc/kvm/book3s.c                    |  125 ++++
 arch/powerpc/kvm/book3s_32_mmu_host.c        |    3 
 arch/powerpc/kvm/book3s_64_mmu_host.c        |    3 
 arch/powerpc/kvm/book3s_64_mmu_hv.c          |  480 ++++++++++++++++--
 arch/powerpc/kvm/book3s_emulate.c            |   16 
 arch/powerpc/kvm/book3s_exports.c            |    3 
 arch/powerpc/kvm/book3s_hv.c                 |  709 +++++++++++++++++++--------
 arch/powerpc/kvm/book3s_hv_builtin.c         |    4 
 arch/powerpc/kvm/book3s_hv_ras.c             |  144 +++++
 arch/powerpc/kvm/book3s_hv_rm_mmu.c          |  145 ++++-
 arch/powerpc/kvm/book3s_hv_rmhandlers.S      |  142 +++--
 arch/powerpc/kvm/book3s_mmu_hpte.c           |    5 
 arch/powerpc/kvm/book3s_pr.c                 |  310 +++++++----
 arch/powerpc/kvm/book3s_rmhandlers.S         |   18 
 arch/powerpc/kvm/booke.c                     |  434 ++++++++++++----
 arch/powerpc/kvm/booke.h                     |    1 
 arch/powerpc/kvm/booke_emulate.c             |   36 +
 arch/powerpc/kvm/bookehv_interrupts.S        |  145 +++++
 arch/powerpc/kvm/e500.h                      |   11 
 arch/powerpc/kvm/e500_emulate.c              |   14 
 arch/powerpc/kvm/e500_tlb.c                  |  138 +++--
 arch/powerpc/kvm/emulate.c                   |  221 ++++----
 arch/powerpc/kvm/powerpc.c                   |  219 ++++++--
 arch/powerpc/kvm/trace.h                     |  208 ++++++-
 arch/powerpc/platforms/Kconfig               |    1 
 arch/powerpc/sysdev/fsl_msi.c                |    9 
 arch/powerpc/sysdev/fsl_soc.c                |    2 
 arch/s390/kvm/interrupt.c                    |   19 
 arch/s390/kvm/kvm-s390.c                     |    7 
 arch/x86/include/asm/clocksource.h           |    1 
 arch/x86/include/asm/cpufeature.h            |    1 
 arch/x86/include/asm/fixmap.h                |    5 
 arch/x86/include/asm/kexec.h                 |    5 
 arch/x86/include/asm/kvm_guest.h             |    6 
 arch/x86/include/asm/kvm_host.h              |   24 
 arch/x86/include/asm/msr-index.h             |    1 
 arch/x86/include/asm/pvclock.h               |   47 +
 arch/x86/include/asm/vmx.h                   |    3 
 arch/x86/include/asm/vsyscall.h              |   20 
 arch/x86/kernel/crash.c                      |   36 +
 arch/x86/kernel/kvm.c                        |   20 
 arch/x86/kernel/kvmclock.c                   |  112 +++-
 arch/x86/kernel/pvclock.c                    |  163 +++---
 arch/x86/kvm/cpuid.c                         |    3 
 arch/x86/kvm/cpuid.h                         |    8 
 arch/x86/kvm/emulate.c                       |    5 
 arch/x86/kvm/lapic.c                         |    2 
 arch/x86/kvm/mmu.c                           |   65 +-
 arch/x86/kvm/paging_tmpl.h                   |  121 +---
 arch/x86/kvm/svm.c                           |   48 +
 arch/x86/kvm/trace.h                         |   69 ++
 arch/x86/kvm/vmx.c                           |  203 +++++--
 arch/x86/kvm/x86.c                           |  564 ++++++++++++++++++---
 arch/x86/kvm/x86.h                           |    2 
 arch/x86/vdso/vclock_gettime.c               |   81 ++-
 arch/x86/vdso/vgetcpu.c                      |   11 
 drivers/tty/Kconfig                          |    1 
 drivers/virt/Kconfig                         |    1 
 include/linux/kvm.h                          |   18 
 include/linux/kvm_host.h                     |   53 +-
 include/linux/pvclock_gtod.h                 |    9 
 include/linux/sched.h                        |    8 
 include/uapi/linux/kvm.h                     |    3 
 kernel/sched/core.c                          |   15 
 kernel/time/timekeeping.c                    |   50 +
 virt/kvm/assigned-dev.c                      |   36 -
 virt/kvm/eventfd.c                           |    8 
 virt/kvm/iommu.c                             |   10 
 virt/kvm/irq_comm.c                          |   83 ++-
 virt/kvm/kvm_main.c                          |   57 --
 102 files changed, 5596 insertions(+), 1859 deletions(-)

