Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab1ALMV0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 07:21:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63341 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751947Ab1ALMVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 07:21:23 -0500
Message-ID: <4D2D9C9F.6060502@redhat.com>
Date: Wed, 12 Jan 2011 14:20:47 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [GIT PULL v2] KVM updates for the 2.6.38 merge window
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please find an amended 2.6.38 KVM queue in

   git://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/2.6.38

changes from v1:
- dropped the patch introducing FAULT_FLAG_MINOR
- changed the following patch not to use the new get_user_pages_noio()
- tacked on a late sleeping-while-atomic fix

Alexander Graf (1):
       KVM: PPC: Fix compile warning

Andi Kleen (1):
       KVM: Move KVM context switch into own function

Andre Przywara (8):
       KVM: x86: fix CR8 handling
       KVM: move complete_insn_gp() into x86.c
       KVM: cleanup emulate_instruction
       KVM: SVM: add new SVM feature bit names
       KVM: SVM: enhance MOV CR intercept handler
       KVM: SVM: enhance mov DR intercept handler
       KVM: SVM: implement enhanced INVLPG intercept
       KVM: SVM: copy instruction bytes from VMCB

Anthony Liguori (1):
       KVM: VMX: add module parameter to avoid trapping HLT instructions 
(v5)

Avi Kivity (37):
       KVM: Don't reset mmu context unnecessarily when updating EFER
       KVM: SVM: Move guest register save out of interrupts disabled section
       KVM: SVM: Move svm->host_gs_base into a separate structure
       KVM: SVM: Move fs/gs/ldt save/restore to heavyweight exit path
       KVM: SVM: Fold save_host_msrs() and load_host_msrs() into their 
callers
       KVM: Avoid double interrupt injection with vapic
       KVM: VMX: Disallow NMI while blocked by STI
       KVM: SVM: Replace svm_has() by standard Linux cpuid accessors
       KVM: Mask KVM_GET_SUPPORTED_CPUID data with Linux cpuid info
       KVM: x86 emulator: drop unused #ifndef __KERNEL__
       KVM: x86 emulator: drop DPRINTF()
       KVM: x86 emulator: preserve an operand's segment identity
       KVM: x86 emulator: do not perform address calculations on linear 
addresses
       KVM: VMX: Fold __vmx_vcpu_run() into vmx_vcpu_run()
       KVM: Record instruction set in kvm_exit tracepoint
       KVM: Add instruction-set-specific exit qualifications to kvm_exit 
trace
       KVM: x86 emulator: introduce struct x86_exception to communicate 
faults
       KVM: x86 emulator: make emulator memory callbacks return full 
exception
       KVM: x86 emulator: drop dead pf injection in emulate_popf()
       KVM: x86 emulator: tighen up ->read_std() and ->write_std() error 
checks
       KVM: x86 emulator: simplify exception generation
       KVM: Push struct x86_exception info the various gva_to_gpa variants
       KVM: Push struct x86_exception into walk_addr()
       KVM: Pull extra page fault information into struct x86_exception
       KVM: Don't spin on virt instruction faults during reboot
       KVM: VMX: Return 0 from a failed VMREAD
       KVM: Fix build error on s390 due to missing tlbs_dirty
       KVM: MMU: Fix incorrect direct page write protection due to ro 
host page
       KVM: Correct kvm_pio tracepoint count field
       KVM guest: Fix kvm clock initialization when it's configured out
       KVM: VMX: Add definitions for more vm entry/exit control bits
       KVM: VMX: Optimize atomic EFER load
       KVM: MMU: Initialize base_role for tdp mmus
       KVM: VMX: Correct asm constraint in vmcs_load()/vmcs_clear()
       KVM: Replace reads of vcpu->arch.cr3 by an accessor
       KVM: Fetch guest cr3 from hardware on demand
       KVM: Initialize fpu state in preemptible context

Gleb Natapov (15):
       KVM: Halt vcpu if page it tries to access is swapped out
       KVM: Retry fault before vmentry
       KVM: Add memory slot versioning and use it to provide fast guest 
write interface
       KVM paravirt: Move kvm_smp_prepare_boot_cpu() from kvmclock.c to 
kvm.c.
       KVM: Add PV MSR to enable asynchronous page faults delivery.
       KVM paravirt: Add async PF initialization to PV guest.
       KVM: Handle async PF in a guest.
       KVM: Inject asynchronous page fault into a PV guest if page is 
swapped out.
       KVM paravirt: Handle async PF in non preemptable context
       KVM: Let host know whether the guest can handle async PF in 
non-userspace context.
       KVM: Send async PF when guest is not in userspace too.
       KVM: improve hva_to_pfn() readability
       KVM: x86: trace "exit to userspace" event
       KVM: handle exit due to INVD in VMX
       KVM: VMX: when entering real mode align segment base to 16 bytes

Heiko Carstens (2):
       KVM: add cast within kvm_clear_guest_page to fix warning
       KVM: get rid of warning within kvm_dev_ioctl_create_vm

Jan Kiszka (11):
       KVM: x86: Mark kvm_arch_setup_async_pf static
       KVM: x86: Add missing inline tag to kvm_read_and_reset_pf_reason
       KVM: x86: Avoid issuing wbinvd twice
       KVM: Refactor srcu struct release on early errors
       KVM: Clean up vm creation and release
       KVM: Clear assigned guest IRQ on release
       KVM: Switch assigned device IRQ forwarding to threaded handler
       KVM: Refactor IRQ names of assigned devices
       KVM: Save/restore state of assigned PCI device
       KVM: Clean up kvm_vm_ioctl_assigned_device
       KVM: Document device assigment API

Joerg Roedel (23):
       KVM: X86: Introduce generic guest-mode representation
       KVM: SVM: Make Use of the generic guest-mode functions
       KVM: X86: Don't report L2 emulation failures to user-space
       KVM: SVM: Add function to recalculate intercept masks
       KVM: SVM: Add manipulation functions for DRx intercepts
       KVM: SVM: Add manipulation functions for exception intercepts
       KVM: SVM: Add manipulation functions for misc intercepts
       KVM: SVM: Use get_host_vmcb function in svm_get_msr for TSC
       KVM: SVM: Add clean-bit for intercetps, tsc-offset and pause 
filter count
       KVM: SVM: Add clean-bit for IOPM_BASE and MSRPM_BASE
       KVM: SVM: Add clean-bit for the ASID
       KVM: SVM: Add clean-bit for interrupt state
       KVM: SVM: Add clean-bit for NPT state
       KVM: SVM: Add clean-bit for control registers
       KVM: SVM: Add clean-bit for DR6 and DR7
       KVM: SVM: Add clean-bit for GDT and IDT
       KVM: SVM: Add clean-bit for Segements and CPL
       KVM: SVM: Add clean-bit for CR2 register
       KVM: SVM: Add clean-bit for LBR state
       KVM: SVM: Remove flush_guest_tlb function
       KVM: SVM: Use svm_flush_tlb instead of force_new_asid
       KVM: SVM: Implement Flush-By-Asid feature
       KVM: SVM: Add xsetbv intercept

Lai Jiangshan (2):
       KVM: MMU: rename 'reset_host_protection' to 'host_writable'
       KVM: return true when user space query KVM_CAP_USER_NMI extension

Marcelo Tosatti (5):
       KVM: VMX: remove setting of shadow_base_ptes for EPT
       KVM: MMU: remove kvm_mmu_set_base_ptes
       KVM: MMU: flush TLBs on writable -> read-only spte overwrite
       KVM: propagate fault r/w information to gup(), allow read-only memory
       KVM: MMU: only write protect mappings at pagetable level

Michael S. Tsirkin (1):
       KVM: fast-path msi injection with irqfd

Roedel, Joerg (2):
       KVM: SVM: Add manipulation functions for CRx intercepts
       KVM: SVM: Add clean-bits infrastructure code

Shane Wang (1):
       KVM: VMX: Inform user about INTEL_TXT dependency

Takuya Yoshikawa (9):
       KVM: introduce wrapper functions for creating/destroying dirty 
bitmaps
       KVM: pre-allocate one more dirty bitmap to avoid vmalloc()
       KVM: use kmalloc() for small dirty bitmaps
       KVM: replace vmalloc and memset with vzalloc
       KVM: take kvm_lock for hardware_disable() during cpu hotplug
       KVM: rename hardware_[dis|en]able() to *_nolock() and add locking 
wrappers
       KVM: MMU: Avoid dropping accessed bit while removing write access
       KVM: MMU: Make the way of accessing lpage_info more generic
       KVM: Take missing slots_lock for kvm_io_bus_unregister_dev()

Tracey Dent (1):
       KVM: x86: Makefile clean up

Xiao Guangrong (22):
       KVM: fix tracing kvm_try_async_get_page
       KVM: cleanup async_pf tracepoints
       KVM: fix searching async gfn in kvm_async_pf_gfn_slot
       KVM: avoid unnecessary wait for a async pf
       KVM: handle more completed apfs if possible
       KVM: fix the race while wakeup all pv guest
       KVM: remove unused function declaration
       KVM: MMU: fix missing post sync audit
       KVM: MMU: clear apfs if page state is changed
       KVM: MMU: support apf for nonpaing guest
       KVM: MMU: fix apf prefault if nested guest is enabled
       KVM: MMU: don't mark spte notrap if reserved bit set
       KVM: MMU: fix forgot flush tlbs on sync_page path
       KVM: MMU: don't drop spte if overwrite it from W to RO
       KVM: MMU: remove 'clear_unsync' parameter
       KVM: MMU: abstract invalid guest pte mapping
       KVM: MMU: delay flush all tlbs on sync_page path
       KVM: MMU: rename 'no_apf' to 'prefault'
       KVM: MMU: fix accessed bit set on prefault path
       KVM: MMU: retry #PF for softmmu
       KVM: MMU: audit: allow audit more guests at the same time
       KVM: MMU: handle 'map_writable' in set_spte() function

  Documentation/kernel-parameters.txt |    3 +
  Documentation/kvm/api.txt           |  178 +++++++
  Documentation/kvm/cpuid.txt         |    3 +
  Documentation/kvm/msr.txt           |   36 ++-
  arch/ia64/include/asm/kvm_host.h    |    4 +
  arch/ia64/kvm/kvm-ia64.c            |   30 +-
  arch/powerpc/kvm/book3s.c           |    4 +-
  arch/powerpc/kvm/powerpc.c          |   20 +-
  arch/s390/kvm/kvm-s390.c            |   23 +-
  arch/x86/include/asm/kvm_emulate.h  |   35 +-
  arch/x86/include/asm/kvm_host.h     |   99 +++--
  arch/x86/include/asm/kvm_para.h     |   24 +
  arch/x86/include/asm/svm.h          |   57 ++-
  arch/x86/include/asm/traps.h        |    1 +
  arch/x86/include/asm/vmx.h          |   15 +
  arch/x86/kernel/entry_32.S          |   10 +
  arch/x86/kernel/entry_64.S          |    3 +
  arch/x86/kernel/i387.c              |    1 +
  arch/x86/kernel/kvm.c               |  317 +++++++++++++
  arch/x86/kernel/kvmclock.c          |   13 +-
  arch/x86/kvm/Kconfig                |    1 +
  arch/x86/kvm/Makefile               |    3 +-
  arch/x86/kvm/emulate.c              |  367 +++++++---------
  arch/x86/kvm/kvm_cache_regs.h       |   22 +
  arch/x86/kvm/lapic.c                |    3 +-
  arch/x86/kvm/mmu.c                  |  251 +++++++----
  arch/x86/kvm/mmu_audit.c            |   39 +-
  arch/x86/kvm/paging_tmpl.h          |  147 ++++---
  arch/x86/kvm/svm.c                  |  865 
++++++++++++++++++++++-------------
  arch/x86/kvm/trace.h                |   17 +-
  arch/x86/kvm/vmx.c                  |  156 +++++--
  arch/x86/kvm/x86.c                  |  474 ++++++++++++++-----
  include/linux/kvm.h                 |    1 +
  include/linux/kvm_host.h            |  101 ++++-
  include/linux/kvm_types.h           |    7 +
  include/trace/events/kvm.h          |  121 +++++
  virt/kvm/Kconfig                    |    3 +
  virt/kvm/assigned-dev.c             |  125 ++----
  virt/kvm/async_pf.c                 |  216 +++++++++
  virt/kvm/async_pf.h                 |   36 ++
  virt/kvm/eventfd.c                  |   91 ++++-
  virt/kvm/irq_comm.c                 |    7 +-
  virt/kvm/kvm_main.c                 |  334 ++++++++++----
  43 files changed, 3078 insertions(+), 1185 deletions(-)
  create mode 100644 virt/kvm/async_pf.c
  create mode 100644 virt/kvm/async_pf.h



-- 
error compiling committee.c: too many arguments to function

