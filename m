Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934001Ab1J3Lvt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 07:51:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31517 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933965Ab1J3Lvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 07:51:45 -0400
Message-ID: <4EAD3A4C.3030101@redhat.com>
Date: Sun, 30 Oct 2011 13:51:40 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [GIT PULL] KVM updates for the 3.2 merge window
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/avi/kvm.git kvm-updates/3.2

(temporary location until virt/kvm is restored) to receive the KVM
updates for the 3.2 cycle:

Alexander Graf (12):
      KVM: PPC: move compute_tlbie_rb to book3s common header
      KVM: PPC: Add papr_enabled flag
      KVM: PPC: Check privilege level on SPRs
      KVM: PPC: Interpret SDR1 as HVA in PAPR mode
      KVM: PPC: Read out syscall instruction on trap
      KVM: PPC: Add support for explicit HIOR setting
      KVM: PPC: Add PAPR hypercall code for PR mode
      KVM: PPC: Stub emulate CFAR and PURR SPRs
      KVM: PPC: Support SC1 hypercalls for PAPR in PR mode
      KVM: PPC: Enable the PAPR CAP for Book3S
      KVM: PPC: Add sanity checking to vcpu_run
      KVM: Update documentation to include detailed ENABLE_CAP description

Avi Kivity (23):
      KVM: MMU: Do not unconditionally read PDPTE from guest memory
      KVM: Restore missing powerpc API docs
      KVM: x86 emulator: simplify emulate_2op_SrcV()
      KVM: x86 emulator: simplify emulate_2op_cl()
      KVM: x86 emulator: simplify emulate_2op_cl()
      KVM: x86 emulator: simplify emulate_1op()
      KVM: x86 emulator: merge the two emulate_1op_rax_rdx implementations
      KVM: x86 emulator: simplify emulate_1op_rax_rdx()
      KVM: x86 emulator: disable writeback for TEST
      KVM: x86 emulator: convert group 3 instructions to direct decode
      KVM: x86 emulator: move memop, memopp into emulation context
      KVM: x86 emulator: split dst decode to a generic decode_operand()
      KVM: x86 emulator: expand decode flags to 64 bits
      KVM: x86 emulator: switch src2 to generic decode_operand()
      KVM: x86 emulator: free up some flag bits near src, dst
      KVM: x86 emulator: switch OpImmUByte decode to decode_imm()
      KVM: x86 emulator: qualify OpReg inhibit_byte_regs hack
      KVM: x86 emulator: switch src decode to decode_operand()
      KVM: x86 emulator: simplify OpMem64 decode
      KVM: x86 emulator: streamline decode of segment registers
      KVM: x86 emulator: switch lds/les/lss/lfs/lgs to direct decode
      KVM: x86 emulator: convert push %sreg/pop %sreg to direct decode
      KVM: Fix simultaneous NMIs

Carsten Otte (3):
      KVM: s390: check cpu_id prior to using it
      KVM: s390: fix return value of kvm_arch_init_vm
      KVM: s390: fix register setting

Christian Ehrhardt (1):
      KVM: s390: implement sigp external call

Jan Kiszka (8):
      KVM: Clean up unneeded void pointer casts
      KVM: Avoid needless registrations of IRQ ack notifier for assigned
devices
      KVM: x86: Move kvm_trace_exit into atomic vmexit section
      KVM: x86: Avoid guest-triggerable printks in APIC model
      KVM: Clean up and extend rate-limited output
      KVM: x86: Add module parameter for lapic periodic timer limit
      KVM: Split up MSI-X assigned device IRQ handler
      KVM: SVM: Keep intercepting task switching with NPT enabled

Julia Lawall (1):
      KVM: VMX: trivial: use BUG_ON

Kevin Tian (1):
      KVM: APIC: avoid instruction emulation for EOI writes

Liu, Jinsong (2):
      x86: TSC deadline definitions
      KVM: emulate lapic tsc deadline timer for guest

Marcelo Tosatti (1):
      KVM: x86: report valid microcode update ID

Mike Waychison (2):
      KVM: x86: get_msr support for HV_X64_MSR_APIC_ASSIST_PAGE
      KVM: Really fix HV_X64_MSR_APIC_ASSIST_PAGE

Nadav Har'El (3):
      KVM: L1 TSC handling
      KVM: nVMX: Fix nested VMX TSC emulation
      KVM: SVM: Fix TSC MSR read in nested SVM

Paul Mackerras (3):
      KVM: PPC: Assemble book3s{,_hv}_rmhandlers.S separately
      KVM: PPC: book3s_pr: Simplify transitions between virtual and real
mode
      KVM: PPC: Implement H_CEDE hcall for book3s_hv in real-mode code

Sasha Levin (5):
      KVM: MMIO: Lock coalesced device when checking for available entry
      KVM: x86: Raise the hard VCPU count limit
      KVM: Make coalesced mmio use a device per zone
      KVM: Intelligent device lookup on I/O bus
      KVM: nVMX: Document 'nested' parameter

Stefan Hajnoczi (2):
      KVM: Record instruction set in all vmexit tracepoints
      KVM: Use __print_symbolic() for vmexit tracepoints

Takuya Yoshikawa (4):
      KVM: x86 emulator: Use ctxt->_eip directly in do_insn_fetch_byte()
      KVM: x86 emulator: Drop _size argument from insn_fetch()
      KVM: x86 emulator: Let compiler know insn_fetch() rarely fails
      KVM: x86 emulator: Make x86_decode_insn() return proper macros

Xiao Guangrong (3):
      KVM: x86: fix broken read emulation spans a page boundary
      KVM: x86: abstract the operation for read/write emulation
      KVM: x86: cleanup the code of read/write emulation

Yang, Wei Y (1):
      KVM: MMU: Fix SMEP failure during fetch

 Documentation/kernel-parameters.txt       |    4 +
 Documentation/virtual/kvm/api.txt         |   71 +++-
 arch/powerpc/include/asm/kvm.h            |   13 +
 arch/powerpc/include/asm/kvm_book3s.h     |   40 ++-
 arch/powerpc/include/asm/kvm_book3s_asm.h |    2 +
 arch/powerpc/include/asm/kvm_host.h       |   30 +-
 arch/powerpc/include/asm/kvm_ppc.h        |    1 +
 arch/powerpc/kernel/asm-offsets.c         |   13 +-
 arch/powerpc/kernel/exceptions-64s.S      |   10 -
 arch/powerpc/kvm/44x.c                    |    2 +
 arch/powerpc/kvm/Makefile                 |    4 +
 arch/powerpc/kvm/book3s_32_sr.S           |    2 +-
 arch/powerpc/kvm/book3s_64_mmu.c          |    8 +-
 arch/powerpc/kvm/book3s_64_slb.S          |    2 +-
 arch/powerpc/kvm/book3s_emulate.c         |   29 +
 arch/powerpc/kvm/book3s_exports.c         |    4 +-
 arch/powerpc/kvm/book3s_hv.c              |  343 +++++++-----
 arch/powerpc/kvm/book3s_hv_rm_mmu.c       |   33 --
 arch/powerpc/kvm/book3s_hv_rmhandlers.S   |  300 +++++++++--
 arch/powerpc/kvm/book3s_interrupts.S      |  129 +----
 arch/powerpc/kvm/book3s_pr.c              |   58 ++-
 arch/powerpc/kvm/book3s_pr_papr.c         |  158 ++++++
 arch/powerpc/kvm/book3s_rmhandlers.S      |   54 +--
 arch/powerpc/kvm/book3s_segment.S         |  117 ++++-
 arch/powerpc/kvm/booke.c                  |   10 +-
 arch/powerpc/kvm/e500.c                   |    2 +
 arch/powerpc/kvm/powerpc.c                |   55 ++-
 arch/s390/include/asm/kvm_host.h          |    7 +
 arch/s390/kvm/interrupt.c                 |   30 +
 arch/s390/kvm/kvm-s390.c                  |   20 +-
 arch/s390/kvm/sigp.c                      |   45 ++-
 arch/x86/include/asm/apicdef.h            |    2 +
 arch/x86/include/asm/cpufeature.h         |    1 +
 arch/x86/include/asm/kvm_emulate.h        |    4 +-
 arch/x86/include/asm/kvm_host.h           |   14 +-
 arch/x86/include/asm/msr-index.h          |    2 +
 arch/x86/include/asm/vmx.h                |   12 +
 arch/x86/kvm/emulate.c                    |  867
++++++++++++++---------------
 arch/x86/kvm/i8254.c                      |    6 +-
 arch/x86/kvm/i8259.c                      |  123 ++++-
 arch/x86/kvm/irq.h                        |    4 +-
 arch/x86/kvm/kvm_cache_regs.h             |    7 -
 arch/x86/kvm/kvm_timer.h                  |    2 +
 arch/x86/kvm/lapic.c                      |  167 +++++--
 arch/x86/kvm/lapic.h                      |    4 +
 arch/x86/kvm/mmu.c                        |    5 +-
 arch/x86/kvm/mmu_audit.c                  |    6 +-
 arch/x86/kvm/paging_tmpl.h                |   24 +-
 arch/x86/kvm/svm.c                        |   93 +---
 arch/x86/kvm/trace.h                      |  118 ++++-
 arch/x86/kvm/vmx.c                        |  131 +++---
 arch/x86/kvm/x86.c                        |  274 ++++++----
 include/linux/kvm.h                       |    6 +-
 include/linux/kvm_host.h                  |   32 +-
 virt/kvm/assigned-dev.c                   |   62 ++-
 virt/kvm/coalesced_mmio.c                 |  131 ++---
 virt/kvm/coalesced_mmio.h                 |    7 +-
 virt/kvm/eventfd.c                        |    3 +-
 virt/kvm/ioapic.c                         |    3 +-
 virt/kvm/kvm_main.c                       |  112 ++++-
 60 files changed, 2449 insertions(+), 1369 deletions(-)
 create mode 100644 arch/powerpc/kvm/book3s_pr_papr.c

-- 
error compiling committee.c: too many arguments to function

