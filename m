Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986Ab1CQQcA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 12:32:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63126 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751279Ab1CQQb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 12:31:56 -0400
Date: Thu, 17 Mar 2011 13:30:52 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>
Subject: [GIT PULL] KVM updates for 2.6.39
Message-ID: <20110317163052.GA18669@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull from

    git://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/2.6.39

To receive the following updates.

Avi Kivity (11):
      KVM: MMU: Don't flush shadow when enabling dirty tracking
      KVM: VMX: Save and restore tr selector across mode switches
      KVM: VMX: Avoid leaking fake realmode state to userspace
      KVM: VMX: Simplify saving guest rcx in vmx_vcpu_run
      KVM: VMX: Avoid atomic operation in vmx_vcpu_run
      KVM: Drop bogus x86_decode_insn() error check
      KVM: x86 emulator: vendor specific instructions
      KVM: Drop ad-hoc vendor specific instruction restriction
      KVM: Fix race between nmi injection and enabling nmi window
      KVM: SVM: check for progress after IRET interception
      KVM: SVM: Load %gs earlier if CONFIG_X86_32_LAZY_GS=n

Glauber Costa (1):
      KVM: x86: release kvmclock page on reset

Gleb Natapov (6):
      KVM: remove isr_ack logic from PIC
      KVM: VMX: update live TR selector if it changes in real mode
      KVM: VMX: Initialize vm86 TSS only once.
      KVM: emulator: Fix io permission checking for 64bit guest
      KVM: emulator: Fix permission checking in io permission bitmap
      KVM: unbreak userspace that does not sets tss address

Heiko Carstens (1):
      KVM: fix build warning within __kvm_set_memory_region() on s390

Huang Ying (4):
      mm: export __get_user_pages
      mm: make __get_user_pages return -EHWPOISON for HWPOISON page optionally
      KVM: Replace is_hwpoison_address with __get_user_pages
      mm: remove is_hwpoison_address

Jan Kiszka (5):
      KVM: x86: Remove user space triggerable MCE error message
      KVM: x86: Drop obsolete warning about INIT on runnable VCPU
      KVM: Convert kvm_lock to raw_spinlock
      KVM: x86: Convert tsc_write_lock to raw_spinlock
      KVM: Start lock documentation

Joerg Roedel (1):
      KVM: SVM: Add support for perf-kvm

Joseph Cihula (1):
      KVM: VMX: fix detection of BIOS disabling VMX

Lai Jiangshan (3):
      KVM: VMX: add the __noclone attribute to vmx_vcpu_run
      KVM: Clear async page fault hash after switching to real mode
      KVM: better readability of efer_reserved_bits

Michael S. Tsirkin (1):
      KVM: improve comment on rcu use in irqfd_deassign

Nikola Ciprich (1):
      KVM: fix kvmclock regression due to missing clock update

Peter Tyser (1):
      KVM: PPC: Fix SPRG get/set for Book3S and BookE

Rik van Riel (4):
      KVM: VMX: increase ple_gap default to 128
      export pid symbols needed for kvm_vcpu_on_spin
      KVM: keep track of which task is running a KVM vcpu
      KVM: use yield_to instead of sleep in kvm_vcpu_on_spin

Sedat Dilek (1):
      KVM guest: Fix section mismatch derived from kvm_guest_cpu_online()

Takuya Yoshikawa (1):
      KVM: x86: Remove useless regs_page pointer from kvm_lapic

Xiao Guangrong (12):
      KVM: fix rcu usage warning in kvm_arch_vcpu_ioctl_set_sregs()
      KVM: Add "exiting guest mode" state
      KVM: make make_all_cpus_request() lockless
      KVM: MMU: fix kvm_mmu_slot_remove_write_access dropping intermediate W bits
      KVM: MMU: set spte accessed bit properly
      KVM: MMU: move mmu pages calculated out of mmu lock
      KVM: MMU: do not record gfn in kvm_mmu_pte_write
      KVM: MMU: cleanup page alloc and free
      KVM: MMU: remove unused macros
      KVM: fix rcu usage in init_rmode_* functions
      KVM: MMU: introduce a common function to get no-dirty-logged slot
      KVM: MMU: cleanup pte write path

john cooper (1):
      KVM: x86: handle guest access to BBL_CR_CTL3 MSR


 Documentation/kvm/locking.txt                  |   25 ++++
 arch/alpha/include/asm/errno.h                 |    2 
 arch/ia64/kvm/kvm-ia64.c                       |    2 
 arch/mips/include/asm/errno.h                  |    2 
 arch/parisc/include/asm/errno.h                |    2 
 arch/powerpc/kvm/book3s.c                      |   14 +-
 arch/powerpc/kvm/booke.c                       |   14 +-
 arch/sparc/include/asm/errno.h                 |    2 
 arch/x86/include/asm/kvm_emulate.h             |    5 
 arch/x86/include/asm/kvm_host.h                |   12 -
 arch/x86/include/asm/msr-index.h               |    1 
 arch/x86/kernel/kvm.c                          |    2 
 arch/x86/kvm/emulate.c                         |   54 +++++---
 arch/x86/kvm/i8259.c                           |   25 ----
 arch/x86/kvm/lapic.c                           |   13 --
 arch/x86/kvm/lapic.h                           |    1 
 arch/x86/kvm/mmu.c                             |  154 ++++++++++---------------
 arch/x86/kvm/paging_tmpl.h                     |   17 +-
 arch/x86/kvm/svm.c                             |   27 +++-
 arch/x86/kvm/vmx.c                             |  128 +++++++++++++-------
 arch/x86/kvm/x86.c                             |  153 +++++++++++++-----------
 drivers/infiniband/hw/ipath/ipath_user_pages.c |    6 
 drivers/infiniband/hw/qib/qib_user_pages.c     |    6 
 include/asm-generic/errno.h                    |    2 
 include/linux/kvm_host.h                       |   31 +++--
 include/linux/mm.h                             |   13 --
 kernel/fork.c                                  |    1 
 kernel/pid.c                                   |    2 
 mm/internal.h                                  |    5 
 mm/memory-failure.c                            |   32 -----
 mm/memory.c                                    |   63 +++++++++-
 virt/kvm/eventfd.c                             |    5 
 virt/kvm/kvm_main.c                            |  139 +++++++++++++++-------
 33 files changed, 557 insertions(+), 403 deletions(-)
