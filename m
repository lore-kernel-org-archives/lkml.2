Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071Ab0ESIxn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 04:53:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25701 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358Ab0ESIxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 04:53:38 -0400
Message-ID: <4BF3A705.3020904@redhat.com>
Date: Wed, 19 May 2010 11:53:25 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: kvm-devel <kvm@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] KVM updates for the 2.6.35 merge window
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

   git://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/2.6.35

to receive the KVM updates for the 2.6.35 merge window.  Highlights 
include a ppc64 port, timekeeping improvements, a lot of emulator work, 
and perf integration.

Shortlog/diffstat below.  Messy due to a merge of tip's perf/core, which 
you have already pulled.

Alexander Graf (84):
       KVM: PPC: Add QPR registers
       KVM: PPC: Make fpscr 64-bit
       KVM: PPC: Enable MMIO to do 64 bits, fprs and qprs
       KVM: PPC: Teach MMIO Signedness
       KVM: PPC: Add AGAIN type for emulation return
       KVM: PPC: Add hidden flag for paired singles
       KVM: PPC: Add Gekko SPRs
       KVM: PPC: Combine extension interrupt handlers
       KVM: PPC: Preload FPU when possible
       KVM: PPC: Fix typo in book3s_32 debug code
       KVM: PPC: Implement mtsr instruction emulation
       KVM: PPC: Make software load/store return eaddr
       KVM: PPC: Make ext giveup non-static
       KVM: PPC: Add helpers to call FPU instructions
       KVM: PPC: Fix error in BAT assignment
       KVM: PPC: Add helpers to modify ppc fields
       KVM: PPC: Enable program interrupt to do MMIO
       KVM: PPC: Implement Paired Single emulation
       KVM: PPC: Add capability for paired singles
       KVM: PPC: Enable use of secondary htab bucket
       KVM: PPC: Simplify kvmppc_load_up_(FPU|VMX|VSX)
       KVM: PPC: Allocate vcpu struct using vmalloc
       KVM: PPC: Memset vcpu to zeros
       KVM: PPC: Destory timer on vcpu destruction
       KVM: PPC: Ensure split mode works
       KVM: PPC: Allow userspace to unset the IRQ line
       KVM: PPC: Make DSISR 32 bits wide
       KVM: PPC: Book3S_32 guest MMU fixes
       KVM: PPC: Split instruction reading out
       KVM: PPC: Don't reload FPU with invalid values
       KVM: PPC: Load VCPU for register fetching
       KVM: PPC: Implement mfsr emulation
       KVM: PPC: Implement BAT reads
       KVM: PPC: Make XER load 32 bit
       KVM: PPC: Implement emulation for lbzux and lhax
       KVM: PPC: Implement alignment interrupt
       KVM: Add support for enabling capabilities per-vcpu
       KVM: PPC: Add OSI hypercall interface
       KVM: PPC: Make build work without CONFIG_VSX/ALTIVEC
       KVM: PPC: Fix dcbz emulation
       KVM: PPC: Add emulation for dcba
       KVM: PPC: Add check if pte was mapped secondary
       KVM: PPC: Use ULL for big numbers
       KVM: PPC: Make bools bitfields
       KVM: PPC: Disable MSR_FEx for Cell hosts
       KVM: PPC: Only use QPRs when available
       KVM: PPC: Don't export Book3S symbols on BookE
       KVM: PPC: Add dequeue for external on BookE
       KVM: PPC: Name generic 64-bit code generic
       KVM: PPC: Add host MMU Support
       KVM: PPC: Add SR swapping code
       KVM: PPC: Add generic segment switching code
       PPC: Split context init/destroy functions
       KVM: PPC: Add kvm_book3s_64.h
       KVM: PPC: Add kvm_book3s_32.h
       KVM: PPC: Add fields to shadow vcpu
       KVM: PPC: Improve indirect svcpu accessors
       KVM: PPC: Use KVM_BOOK3S_HANDLER
       KVM: PPC: Use CONFIG_PPC_BOOK3S define
       PPC: Add STLU
       KVM: PPC: Use now shadowed vcpu fields
       KVM: PPC: Extract MMU init
       KVM: PPC: Make real mode handler generic
       KVM: PPC: Make highmem code generic
       KVM: PPC: Make SLB switching code the new segment framework
       KVM: PPC: Release clean pages as clean
       KVM: PPC: Remove fetch fail code
       KVM: PPC: Add SVCPU to Book3S_32
       KVM: PPC: Emulate segment fault
       KVM: PPC: Add Book3S compatibility code
       KVM: PPC: Export MMU variables
       PPC: Export SWITCH_FRAME_SIZE
       KVM: PPC: Check max IRQ prio
       KVM: PPC: Add KVM intercept handlers
       KVM: PPC: Enable Book3S_32 KVM building
       KVM: PPC: Convert u64 -> ulong
       KVM: PPC: Make Performance Counters work
       KVM: PPC: Improve split mode
       KVM: PPC: Make Alignment interrupts work again
       KVM: PPC: Be more informative on BUG
       KVM: PPC: Set VSID_PR also for Book3S_64
       KVM: PPC: Fix Book3S_64 Host MMU debug output
       KVM: PPC: Find HTAB ourselves
       KVM: PPC: Enable native paired singles

Andre Przywara (1):
       KVM: SVM: implement NEXTRIPsave SVM feature

Andrea Gelmini (1):
       KVM: arch/x86/kvm/kvm_timer.h checkpatch cleanup

Avi Kivity (32):
       KVM: Move kvm_exit tracepoint rip reading inside tracepoint
       KVM: Trace exception injection
       KVM: MMU: Consolidate two guest pte reads in kvm_mmu_pte_write()
       KVM: Make locked operations truly atomic
       KVM: Don't follow an atomic operation by a non-atomic one
       KVM: MMU: Do not instantiate nontrapping spte on unsync page
       KVM: MMU: Reinstate pte prefetch on invlpg
       KVM: MMU: Disassociate direct maps from guest levels
       KVM: Document KVM_SET_USER_MEMORY_REGION
       KVM: Document KVM_SET_TSS_ADDR
       KVM: Document replacements for KVM_EXIT_HYPERCALL
       KVM: x86 emulator: Don't overwrite decode cache
       KVM: Trace emulated instructions
       KVM: Fix MAXPHYADDR calculation when cpuid does not support it
       KVM: MMU: Replace role.glevels with role.cr4_pae
       Merge branch 'perf'
       KVM: MMU: Drop cr4.pge from shadow page role
       KVM: Document mmu
       Merge remote branch 'tip/perf/core'
       KVM: Document KVM_GET_MP_STATE and KVM_SET_MP_STATE
       KVM: Minor MMU documentation edits
       KVM: Let vcpu structure alignment be determined at runtime
       KVM: VMX: Add definition for msr autoload entry
       KVM: VMX: Add definitions for guest and host EFER autoswitch vmcs 
entries
       KVM: VMX: Add facility to atomically switch MSRs on guest entry/exit
       KVM: VMX: Atomically switch efer if EPT && !EFER.NX
       KVM: MMU: Don't read pdptrs with mmu spinlock held in mmu_alloc_roots
       KVM: Fix wallclock version writing race
       KVM: Don't allow lmsw to clear cr0.pe
       KVM: MMU: Segregate shadow pages with different cr0.wp
       KVM: PPC: Add missing vcpu_load()/vcpu_put() in vcpu ioctls
       KVM: x86: Add missing locking to arch specific vcpu ioctls

Eric Northup (1):
       KVM: MMU: fix hashing for TDP and non-paging modes

Glauber Costa (9):
       x86, paravirt: Enable pvclock flags in vcpu_time_info structure
       x86, paravirt: Add a global synchronization point for pvclock
       KVM: x86: change msr numbers for kvmclock
       KVM: x86: add new KVMCLOCK cpuid feature
       KVM: x86: export paravirtual cpuid flags in KVM_GET_SUPPORTED_CPUID
       x86: KVM guest: Try using new kvm clock msrs
       x86, paravirt: don't compute pvclock adjustments if we trust the tsc
       KVM: x86: Tell the guest we'll warn it about tsc stability
       KVM: Add cpuid.txt file

Gleb Natapov (46):
       KVM: use desc_ptr struct instead of kvm private descriptor_table
       KVM: inject #UD in 64bit mode from instruction that are not valid 
there
       KVM: drop unneeded kvm_run check in emulate_instruction()
       KVM: Drop kvm_get_gdt() in favor of generic linux function
       KVM: fix segment_base() error checking
       KVM: move segment_base() into vmx.c
       KVM: x86 emulator: Add decoding of 16bit second in memory argument
       KVM: x86 emulator: Implement jmp far opcode ff/5
       KVM: x86 emulator mark VMMCALL and LMSW as privileged
       KVM: x86 emulator: Fix DstAcc decoding.
       KVM: x86 emulator: fix RCX access during rep emulation
       KVM: x86 emulator: check return value against correct define
       KVM: Remove pointer to rflags from realmode_set_cr parameters.
       KVM: Provide callback to get/set control registers in emulator ops.
       KVM: remove realmode_lmsw function.
       KVM: Provide x86_emulate_ctxt callback to get current cpl
       KVM: Provide current eip as part of emulator context.
       KVM: x86 emulator: fix mov r/m, sreg emulation.
       KVM: x86 emulator: fix 0f 01 /5 emulation
       KVM: x86 emulator: 0f (20|21|22|23) ignore mod bits.
       KVM: x86 emulator: inject #UD on access to non-existing CR
       KVM: x86 emulator: fix mov dr to inject #UD when needed.
       KVM: x86 emulator: fix return values of syscall/sysenter/sysexit 
emulations
       KVM: x86 emulator: do not call writeback if msr access fails.
       KVM: x86 emulator: If LOCK prefix is used dest arg should be memory.
       KVM: x86 emulator: cleanup grp3 return value
       KVM: x86 emulator: Provide more callbacks for x86 emulator.
       KVM: x86 emulator: Emulate task switch in emulator.c
       KVM: x86 emulator: Use load_segment_descriptor() instead of 
kvm_load_segment_descriptor()
       KVM: Use task switch from emulator.c
       KVM: x86 emulator: populate OP_MEM operand during decoding.
       KVM: x86 emulator: add decoding of X,Y parameters from Intel SDM
       KVM: x86 emulator: during rep emulation decrement ECX only if 
emulation succeeded
       KVM: x86 emulator: fix in/out emulation.
       KVM: x86 emulator: Move string pio emulation into emulator.c
       KVM: x86 emulator: remove saved_eip
       KVM: x86 emulator: restart string instruction without going back 
to a guest.
       KVM: x86 emulator: introduce pio in string read ahead.
       KVM: small kvm_arch_vcpu_ioctl_run() cleanup.
       KVM: x86 emulator: commit rflags as part of registers commit
       KVM: x86 emulator: add decoding of CMPXCHG8B dst operand
       KVM: x86 emulator: fix unlocked CMPXCHG8B emulation
       KVM: move DR register access handling into generic code
       KVM: x86: get rid of mmu_only parameter in emulator_write_emulated()
       KVM: fix emulator_task_switch() return value.
       KVM: prevent spurious exit to userspace during task switch emulation.

Gui Jianfeng (7):
       KVM: VMX: change to use bool return values
       KVM: MMU: Move sync_page() first pte address calculation out of loop
       KVM: MMU: Make use of is_large_pte() in walker
       KVM: MMU: Remove unused varialbe in rmap_next()
       KVM: Get rid of dead function gva_to_page()
       KVM: MMU: fix sp->unsync type error in trace event definition
       KVM: Fix mmu shrinker error

Jan Kiszka (12):
       KVM: x86: Do not return soft events in vcpu_events
       KVM: x86: Save&restore interrupt shadow mask
       KVM: x86: Add support for saving&restoring debug registers
       KVM: x86: Kick VCPU outside PIC lock again
       KVM: SVM: Move svm_queue_exception
       KVM: x86: Add kvm_is_linear_rip
       KVM: SVM: Emulate nRIP feature when reinjecting INT3
       KVM: x86: Drop RF manipulation for guest single-stepping
       KVM: x86: Preserve injected TF across emulation
       KVM: x86: Fix 32-bit build breakage due to typo
       KVM: x86: Terminate early if task_switch_16/32 failed
       KVM: x86: Push potential exception error code on task switches

Joerg Roedel (37):
       KVM: SVM: Don't use kmap_atomic in nested_svm_map
       KVM: SVM: Fix schedule-while-atomic on nested exception handling
       KVM: SVM: Sync all control registers on nested vmexit
       KVM: SVM: Annotate nested_svm_map with might_sleep()
       KVM: SVM: Fix nested msr intercept handling
       KVM: SVM: Don't sync nested cr8 to lapic and back
       KVM: SVM: Activate nested state only when guest state is complete
       KVM: SVM: Make lazy FPU switching work with nested svm
       KVM: SVM: Remove newlines from nested trace points
       KVM: SVM: Fix wrong interrupt injection in enable_irq_windows
       KVM: SVM: Coding style cleanup
       KVM: SVM: Reset MMU on nested_svm_vmrun for NPT too
       KVM: SVM: Check for nested intercepts on NMI injection
       KVM: SVM: Restore tracing of nested vmcb address
       KVM: SVM: Add kvm_nested_intercepts tracepoint
       KVM: SVM: Implement emulation of vm_cr msr
       KVM: SVM: Ignore write of hwcr.ignne
       KVM: x86: Don't set arch.cr0 in kvm_set_cr0
       KVM: SVM: Handle nested selective_cr0 intercept correctly
       KVM: SVM: Clear exit_info for injected INTR exits
       KVM: SVM: Return correct values in nested_svm_exit_handled_msr
       KVM: SVM: Move msrpm offset calculation to seperate function
       KVM: SVM: Introduce direct access msr list
       KVM: SVM: Optimize nested svm msrpm merging
       KVM: SVM: Use svm_msrpm_offset in nested_svm_exit_handled_msr
       KVM; SVM: Add correct handling of nested iopm
       KVM: SVM: Ignore lower 12 bit of nested msrpm_pa
       KVM: SVM: Fix nested nmi handling
       KVM: SVM: Make sure rip is synced to vmcb before nested vmexit
       KVM: SVM: Sync cr0 and cr3 to kvm state before nested handling
       KVM: SVM: Propagate nested entry failure into guest hypervisor
       KVM: x86: Add callback to let modules decide over some supported 
cpuid bits
       KVM: SVM: Report emulated SVM features to userspace
       KVM: x86: Allow marking an exception as reinjected
       KVM: SVM: Handle MCE intercepts always on host level
       KVM: x86: Fix exception reinjection forced to true
       KVM: SVM: Don't allow nested guest to VMMCALL into host

Lai Jiangshan (3):
       KVM: use the correct RCU API for PROVE_RCU=y
       KVM: do not call hardware_disable() on CPU_UP_CANCELED
       KVM: VMX: free vpid when fail to create vcpu

Marcelo Tosatti (3):
       KVM: add doc note about PIO/MMIO completion API
       KVM: x86: document KVM_REQ_PENDING_TIMER usage
       KVM: x86: properly update ready_for_interrupt_injection

Minchan Kim (1):
       KVM: remove redundant initialization of page->private

Roedel, Joerg (1):
       KVM: x86: Inject #GP with the right rip on efer writes

Shane Wang (1):
       KVM: VMX: enable VMXON check with SMX enabled (Intel TXT)

Sheng Yang (1):
       KVM: x86: Check LMA bit before set_efer

Stephen Rothwell (1):
       KVM: powerpc: use of kzalloc/kfree requires including slab.h

Takuya Yoshikawa (8):
       KVM: x86 emulator: X86EMUL macro replacements: from 
do_fetch_insn_byte() to x86_decode_insn()
       KVM: x86 emulator: X86EMUL macro replacements: x86_emulate_insn() 
and its helpers
       KVM: x86 emulator: Fix x86_emulate_insn() not to use the variable 
rc for non-X86EMUL values
       KVM: remove redundant prototype of load_pdptrs()
       KVM: update gfn_to_hva() to use gfn_to_hva_memslot()
       KVM: coalesced_mmio: fix kvm_coalesced_mmio_init()'s error handling
       KVM: limit the number of pages per memory slot
       KVM: Remove test-before-set optimization for dirty bits

Wei Yongjun (8):
       KVM: s390: Fix possible memory leak of in kvm_arch_vcpu_create()
       KVM: PPC: Do not create debugfs if fail to create vcpu
       KVM: x86: Use native_store_idt() instead of kvm_get_idt()
       KVM: ia64: fix the error code of ioctl KVM_IA64_VCPU_GET_STACK 
failure
       KVM: x86: fix the error of ioctl KVM_IRQ_LINE if no irq chip
       KVM: ia64: fix the error of ioctl KVM_IRQ_LINE if no irq chip
       KVM: fix the errno of ioctl KVM_[UN]REGISTER_COALESCED_MMIO failure
       KVM: MMU: cleanup for function unaccount_shadowed()

Xiao Guangrong (13):
       KVM: cleanup kvm trace
       KVM: MMU: check reserved bits only if CR4.PSE=1 or CR4.PAE=1
       KVM: MMU: cleanup/fix mmu audit code
       KVM: MMU: remove unused field
       KVM: MMU: remove unnecessary NX check in walk_addr
       KVM: MMU: remove unused struct kvm_unsync_walk
       KVM: MMU: reduce 'struct kvm_mmu_page' size
       KVM: MMU: remove unused parameter in mmu_parent_walk()
       KVM: MMU: cleanup for hlist walk restart
       KVM: MMU: fix for calculating gpa in invlpg code
       KVM: MMU: convert mmu tracepoints
       KVM: MMU: move unsync/sync tracpoints to proper place
       KVM: MMU: cleanup invlpg code

jing zhang (1):
       KVM: fix assigned_device_enable_host_msix error handling

  Documentation/kprobes.txt                          |   10 +-
  Documentation/kvm/api.txt                          |  208 +++-
  Documentation/kvm/cpuid.txt                        |   42 +
  Documentation/kvm/mmu.txt                          |  304 ++++
  Documentation/trace/kprobetrace.txt                |    4 +-
  MAINTAINERS                                        |   10 +-
  arch/Kconfig                                       |    9 +-
  arch/ia64/kvm/kvm-ia64.c                           |    8 +-
  arch/ia64/kvm/vmm.c                                |    2 +-
  arch/powerpc/include/asm/asm-compat.h              |    2 +
  arch/powerpc/include/asm/kvm.h                     |   10 +
  arch/powerpc/include/asm/kvm_asm.h                 |    2 +
  arch/powerpc/include/asm/kvm_book3s.h              |  157 ++-
  .../asm/kvm_book3s_32.h}                           |   36 +-
  .../asm/kvm_book3s_64.h}                           |   22 +-
  .../asm/{kvm_book3s_64_asm.h => kvm_book3s_asm.h}  |   25 +-
  arch/powerpc/include/asm/kvm_booke.h               |   96 ++
  arch/powerpc/include/asm/kvm_fpu.h                 |   85 +
  arch/powerpc/include/asm/kvm_host.h                |   38 +-
  arch/powerpc/include/asm/kvm_ppc.h                 |   97 +-
  arch/powerpc/include/asm/mmu_context.h             |    2 +
  arch/powerpc/include/asm/paca.h                    |   10 +-
  arch/powerpc/include/asm/processor.h               |    3 +
  arch/powerpc/include/asm/reg.h                     |   10 +
  arch/powerpc/kernel/asm-offsets.c                  |  102 +-
  arch/powerpc/kernel/head_32.S                      |   14 +
  arch/powerpc/kernel/head_64.S                      |    4 +-
  arch/powerpc/kernel/ppc_ksyms.c                    |    4 +
  arch/powerpc/kvm/44x.c                             |    2 +-
  arch/powerpc/kvm/Kconfig                           |   24 +-
  arch/powerpc/kvm/Makefile                          |   20 +-
  arch/powerpc/kvm/book3s.c                          |  503 +++++--
  arch/powerpc/kvm/book3s_32_mmu.c                   |   54 +-
  arch/powerpc/kvm/book3s_32_mmu_host.c              |  483 ++++++
  arch/powerpc/kvm/book3s_32_sr.S                    |  143 ++
  arch/powerpc/kvm/book3s_64_emulate.c               |  348 -----
  arch/powerpc/kvm/book3s_64_mmu.c                   |   36 +-
  arch/powerpc/kvm/book3s_64_mmu_host.c              |  102 +-
  arch/powerpc/kvm/book3s_64_slb.S                   |  183 +--
  arch/powerpc/kvm/book3s_emulate.c                  |  573 +++++++
  .../kvm/{book3s_64_exports.c => book3s_exports.c}  |    0
  ...{book3s_64_interrupts.S => book3s_interrupts.S} |  204 ++--
  arch/powerpc/kvm/book3s_paired_singles.c           | 1289 +++++++++++++++
  ...{book3s_64_rmhandlers.S => book3s_rmhandlers.S} |  135 ++-
  arch/powerpc/kvm/book3s_segment.S                  |  259 +++
  arch/powerpc/kvm/booke.c                           |   21 +-
  arch/powerpc/kvm/e500.c                            |    2 +-
  arch/powerpc/kvm/emulate.c                         |   55 +-
  arch/powerpc/kvm/fpu.S                             |  273 ++++
  arch/powerpc/kvm/powerpc.c                         |  110 ++-
  arch/powerpc/mm/mmu_context_hash32.c               |   29 +-
  arch/s390/kvm/kvm-s390.c                           |    6 +-
  arch/s390/kvm/kvm-s390.h                           |    2 +-
  arch/x86/Kconfig                                   |    3 +
  arch/x86/Kconfig.cpu                               |   20 -
  arch/x86/Kconfig.debug                             |    9 -
  arch/x86/include/asm/apic.h                        |   13 +-
  arch/x86/include/asm/ds.h                          |  302 ----
  arch/x86/include/asm/insn.h                        |    2 +
  arch/x86/include/asm/kprobes.h                     |    2 +-
  arch/x86/include/asm/kvm.h                         |   17 +-
  arch/x86/include/asm/kvm_emulate.h                 |   46 +-
  arch/x86/include/asm/kvm_host.h                    |   80 +-
  arch/x86/include/asm/kvm_para.h                    |   13 +
  arch/x86/include/asm/msr-index.h                   |   20 +-
  arch/x86/include/asm/perf_event.h                  |   76 +-
  arch/x86/include/asm/perf_event_p4.h               |  794 ++++++++++
  arch/x86/include/asm/processor.h                   |   35 +-
  arch/x86/include/asm/ptrace-abi.h                  |   57 +-
  arch/x86/include/asm/ptrace.h                      |    6 -
  arch/x86/include/asm/pvclock-abi.h                 |    4 +-
  arch/x86/include/asm/pvclock.h                     |    1 +
  arch/x86/include/asm/svm.h                         |    9 +-
  arch/x86/include/asm/thread_info.h                 |    8 +-
  arch/x86/include/asm/vmx.h                         |   12 +-
  arch/x86/kernel/Makefile                           |    2 -
  arch/x86/kernel/cpu/intel.c                        |    2 -
  arch/x86/kernel/cpu/perf_event.c                   |  560 ++++----
  arch/x86/kernel/cpu/perf_event_amd.c               |   46 +-
  arch/x86/kernel/cpu/perf_event_intel.c             |  354 +++--
  arch/x86/kernel/cpu/perf_event_intel_ds.c          |  664 ++++++++
  arch/x86/kernel/cpu/perf_event_intel_lbr.c         |  218 +++
  arch/x86/kernel/cpu/perf_event_p4.c                |  834 ++++++++++
  arch/x86/kernel/cpu/perf_event_p6.c                |   31 +-
  arch/x86/kernel/ds.c                               | 1437 
-----------------
  arch/x86/kernel/ds_selftest.c                      |  408 -----
  arch/x86/kernel/ds_selftest.h                      |   15 -
  arch/x86/kernel/dumpstack.c                        |    5 -
  arch/x86/kernel/kprobes.c                          |   16 +-
  arch/x86/kernel/kvmclock.c                         |   56 +-
  arch/x86/kernel/process.c                          |   18 +-
  arch/x86/kernel/process_32.c                       |    8 -
  arch/x86/kernel/process_64.c                       |    8 -
  arch/x86/kernel/ptrace.c                           |  382 -----
  arch/x86/kernel/pvclock.c                          |   37 +
  arch/x86/kernel/step.c                             |   46 +-
  arch/x86/kernel/tboot.c                            |    1 +
  arch/x86/kernel/traps.c                            |    4 +-
  arch/x86/kvm/emulate.c                             | 1247 +++++++++++----
  arch/x86/kvm/i8259.c                               |   53 +-
  arch/x86/kvm/irq.h                                 |    1 +
  arch/x86/kvm/kvm_timer.h                           |    4 +-
  arch/x86/kvm/mmu.c                                 |  225 ++--
  arch/x86/kvm/mmutrace.h                            |   84 +-
  arch/x86/kvm/paging_tmpl.h                         |   46 +-
  arch/x86/kvm/svm.c                                 |  944 ++++++++----
  arch/x86/kvm/timer.c                               |    3 +-
  arch/x86/kvm/trace.h                               |  165 ++-
  arch/x86/kvm/vmx.c                                 |  383 +++--
  arch/x86/kvm/x86.c                                 | 1649 
++++++++------------
  arch/x86/kvm/x86.h                                 |   10 +
  arch/x86/lib/Makefile                              |    2 +-
  arch/x86/oprofile/op_model_ppro.c                  |    4 +-
  include/linux/ftrace.h                             |   12 -
  include/linux/kvm.h                                |   26 +
  include/linux/kvm_host.h                           |   16 +-
  include/linux/mm.h                                 |    4 -
  include/linux/perf_event.h                         |   51 +-
  include/linux/ptrace.h                             |   12 -
  include/linux/sched.h                              |    9 -
  include/linux/tboot.h                              |    1 +
  include/trace/events/kvm.h                         |    1 -
  include/trace/ftrace.h                             |   23 +-
  kernel/fork.c                                      |    3 -
  kernel/perf_event.c                                |  283 +++-
  kernel/ptrace.c                                    |    1 -
  kernel/sched.c                                     |   43 -
  kernel/trace/Kconfig                               |   11 -
  kernel/trace/Makefile                              |    1 -
  kernel/trace/trace.h                               |   20 +-
  kernel/trace/trace_entries.h                       |   12 -
  kernel/trace/trace_hw_branches.c                   |  312 ----
  kernel/trace/trace_kprobe.c                        |  535 ++++---
  kernel/trace/trace_selftest.c                      |   57 -
  mm/mlock.c                                         |   41 -
  tools/perf/Documentation/perf-bench.txt            |    6 +-
  tools/perf/Documentation/perf-kvm.txt              |   67 +
  tools/perf/Documentation/perf-probe.txt            |   18 +-
  tools/perf/Documentation/perf-record.txt           |    4 +-
  tools/perf/Documentation/perf-sched.txt            |    4 +-
  tools/perf/Makefile                                |  340 +++--
  tools/perf/bench/mem-memcpy.c                      |    3 +-
  tools/perf/bench/sched-messaging.c                 |    4 +-
  tools/perf/bench/sched-pipe.c                      |    2 +-
  tools/perf/builtin-annotate.c                      |   57 +-
  tools/perf/builtin-buildid-cache.c                 |    2 +-
  tools/perf/builtin-buildid-list.c                  |    6 +-
  tools/perf/builtin-diff.c                          |   10 +-
  tools/perf/builtin-help.c                          |    2 +-
  tools/perf/builtin-kmem.c                          |   16 +-
  tools/perf/builtin-kvm.c                           |  144 ++
  tools/perf/builtin-lock.c                          |    2 +-
  tools/perf/builtin-probe.c                         |  279 ++---
  tools/perf/builtin-record.c                        |  498 ++++--
  tools/perf/builtin-report.c                        |   99 +-
  tools/perf/builtin-sched.c                         |    8 +-
  tools/perf/builtin-stat.c                          |  155 ++-
  tools/perf/builtin-timechart.c                     |    5 +-
  tools/perf/builtin-top.c                           |  290 +++-
  tools/perf/builtin-trace.c                         |   77 +-
  tools/perf/builtin.h                               |    1 +
  tools/perf/command-list.txt                        |    1 +
  tools/perf/perf-archive.sh                         |    3 +
  tools/perf/perf.c                                  |    6 +-
  tools/perf/perf.h                                  |    8 +-
  .../perl/Perf-Trace-Util/lib/Perf/Trace/Util.pm    |    6 +
  tools/perf/scripts/perl/bin/failed-syscalls-record |    2 +-
  tools/perf/scripts/perl/bin/failed-syscalls-report |    8 +-
  tools/perf/scripts/perl/bin/rw-by-file-record      |    3 +-
  tools/perf/scripts/perl/bin/rw-by-file-report      |    8 +-
  tools/perf/scripts/perl/bin/rw-by-pid-record       |    2 +-
  tools/perf/scripts/perl/bin/rw-by-pid-report       |    2 +-
  tools/perf/scripts/perl/bin/rwtop-record           |    2 +
  tools/perf/scripts/perl/bin/rwtop-report           |   23 +
  tools/perf/scripts/perl/bin/wakeup-latency-record  |    2 +-
  tools/perf/scripts/perl/bin/wakeup-latency-report  |    2 +-
  tools/perf/scripts/perl/bin/workqueue-stats-record |    2 +-
  tools/perf/scripts/perl/bin/workqueue-stats-report |    2 +-
  tools/perf/scripts/perl/rwtop.pl                   |  177 +++
  .../python/Perf-Trace-Util/lib/Perf/Trace/Util.py  |    3 +
  .../python/bin/failed-syscalls-by-pid-record       |    2 +-
  .../python/bin/failed-syscalls-by-pid-report       |    8 +-
  tools/perf/scripts/python/bin/sctop-record         |    2 +
  tools/perf/scripts/python/bin/sctop-report         |   24 +
  .../python/bin/syscall-counts-by-pid-record        |    2 +-
  .../python/bin/syscall-counts-by-pid-report        |    8 +-
  .../perf/scripts/python/bin/syscall-counts-record  |    2 +-
  .../perf/scripts/python/bin/syscall-counts-report  |    8 +-
  tools/perf/scripts/python/sctop.py                 |   78 +
  tools/perf/util/PERF-VERSION-GEN                   |    6 +-
  tools/perf/util/build-id.c                         |    2 +-
  tools/perf/util/cache.h                            |   14 +
  tools/perf/util/callchain.c                        |  110 +-
  tools/perf/util/callchain.h                        |    6 +-
  tools/perf/util/color.c                            |   48 +
  tools/perf/util/color.h                            |    4 +
  tools/perf/util/debug.c                            |    8 +-
  tools/perf/util/debug.h                            |   30 +-
  tools/perf/util/event.c                            |  324 +++--
  tools/perf/util/event.h                            |   49 +-
  tools/perf/util/header.c                           |  524 ++++++-
  tools/perf/util/header.h                           |   41 +-
  tools/perf/util/hist.c                             |  219 ++-
  tools/perf/util/hist.h                             |   15 +-
  tools/perf/util/include/linux/compiler.h           |    2 +
  tools/perf/util/include/linux/kernel.h             |    9 +-
  tools/perf/util/map.c                              |  426 +++++-
  tools/perf/util/map.h                              |  121 ++-
  tools/perf/util/newt.c                             |  725 +++++++++
  tools/perf/util/parse-events.c                     |   21 +-
  tools/perf/util/parse-options.c                    |    7 +
  tools/perf/util/parse-options.h                    |    4 +-
  tools/perf/util/probe-event.c                      | 1574 
++++++++++++++-----
  tools/perf/util/probe-event.h                      |  130 ++-
  tools/perf/util/probe-finder.c                     |  990 +++++++++---
  tools/perf/util/probe-finder.h                     |   65 +-
  tools/perf/util/session.c                          |  325 +++--
  tools/perf/util/session.h                          |   50 +-
  tools/perf/util/sort.c                             |  145 +-
  tools/perf/util/sort.h                             |   30 +-
  tools/perf/util/string.c                           |   45 +-
  tools/perf/util/string.h                           |   18 -
  tools/perf/util/symbol.c                           |  494 +++++--
  tools/perf/util/symbol.h                           |   74 +-
  tools/perf/util/thread.c                           |  242 +---
  tools/perf/util/thread.h                           |   53 +-
  tools/perf/util/trace-event-info.c                 |   24 +
  tools/perf/util/trace-event-parse.c                |   53 +-
  tools/perf/util/trace-event-read.c                 |   89 +-
  tools/perf/util/trace-event.h                      |    7 +-
  tools/perf/util/util.h                             |   21 +
  virt/kvm/assigned-dev.c                            |    8 +-
  virt/kvm/coalesced_mmio.c                          |    6 +-
  virt/kvm/iommu.c                                   |    4 +-
  virt/kvm/kvm_main.c                                |   63 +-
  235 files changed, 19197 insertions(+), 9670 deletions(-)
  create mode 100644 Documentation/kvm/cpuid.txt
  create mode 100644 Documentation/kvm/mmu.txt
  copy arch/powerpc/{kvm/book3s_64_exports.c => 
include/asm/kvm_book3s_32.h} (53%)
  copy arch/powerpc/{kvm/book3s_64_exports.c => 
include/asm/kvm_book3s_64.h} (64%)
  rename arch/powerpc/include/asm/{kvm_book3s_64_asm.h => 
kvm_book3s_asm.h} (82%)
  create mode 100644 arch/powerpc/include/asm/kvm_booke.h
  create mode 100644 arch/powerpc/include/asm/kvm_fpu.h
  create mode 100644 arch/powerpc/kvm/book3s_32_mmu_host.c
  create mode 100644 arch/powerpc/kvm/book3s_32_sr.S
  delete mode 100644 arch/powerpc/kvm/book3s_64_emulate.c
  create mode 100644 arch/powerpc/kvm/book3s_emulate.c
  rename arch/powerpc/kvm/{book3s_64_exports.c => book3s_exports.c} (100%)
  rename arch/powerpc/kvm/{book3s_64_interrupts.S => 
book3s_interrupts.S} (62%)
  create mode 100644 arch/powerpc/kvm/book3s_paired_singles.c
  rename arch/powerpc/kvm/{book3s_64_rmhandlers.S => 
book3s_rmhandlers.S} (62%)
  create mode 100644 arch/powerpc/kvm/book3s_segment.S
  create mode 100644 arch/powerpc/kvm/fpu.S
  delete mode 100644 arch/x86/include/asm/ds.h
  create mode 100644 arch/x86/include/asm/perf_event_p4.h
  create mode 100644 arch/x86/kernel/cpu/perf_event_intel_ds.c
  create mode 100644 arch/x86/kernel/cpu/perf_event_intel_lbr.c
  create mode 100644 arch/x86/kernel/cpu/perf_event_p4.c
  delete mode 100644 arch/x86/kernel/ds.c
  delete mode 100644 arch/x86/kernel/ds_selftest.c
  delete mode 100644 arch/x86/kernel/ds_selftest.h
  delete mode 100644 kernel/trace/trace_hw_branches.c
  create mode 100644 tools/perf/Documentation/perf-kvm.txt
  create mode 100644 tools/perf/builtin-kvm.c
  create mode 100644 tools/perf/scripts/perl/bin/rwtop-record
  create mode 100644 tools/perf/scripts/perl/bin/rwtop-report
  create mode 100644 tools/perf/scripts/perl/rwtop.pl
  create mode 100644 tools/perf/scripts/python/bin/sctop-record
  create mode 100644 tools/perf/scripts/python/bin/sctop-report
  create mode 100644 tools/perf/scripts/python/sctop.py
  create mode 100644 tools/perf/util/newt.c
  delete mode 100644 tools/perf/util/string.h

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

