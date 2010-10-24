Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932753Ab0JXN33 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 09:29:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26974 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932564Ab0JXN30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 09:29:26 -0400
Message-ID: <4CC434A8.1000903@redhat.com>
Date: Sun, 24 Oct 2010 15:29:12 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [GIT PULL] KVM updates for the 2.6.37 merge window
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Linus, the repository and branch

   git://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/2.6.37

contains the kvm updates for the 2.6.37 merge window.  Major changes 
this time around include powerpc paravirtualization, a virtual tsc 
rework, and exposing npt to the guest for fast nested virtualization.  
Please pull.

Shortlog/diffstat:

Alexander Graf (68):
       KVM: PPC: Introduce shared page
       KVM: PPC: Convert MSR to shared page
       KVM: PPC: Convert DSISR to shared page
       KVM: PPC: Convert DAR to shared page.
       KVM: PPC: Convert SRR0 and SRR1 to shared page
       KVM: PPC: Convert SPRG[0-4] to shared page
       KVM: PPC: Implement hypervisor interface
       KVM: PPC: Add PV guest critical sections
       KVM: PPC: Add PV guest scratch registers
       KVM: PPC: Tell guest about pending interrupts
       KVM: PPC: Make PAM a define
       KVM: PPC: First magic page steps
       KVM: PPC: Magic Page Book3s support
       KVM: PPC: Expose magic page support to guest
       KVM: Move kvm_guest_init out of generic code
       KVM: PPC: Generic KVM PV guest support
       KVM: PPC: KVM PV guest stubs
       KVM: PPC: PV instructions to loads and stores
       KVM: PPC: PV tlbsync to nop
       KVM: PPC: Introduce kvm_tmp framework
       KVM: PPC: Introduce branch patching helper
       KVM: PPC: PV assembler helpers
       KVM: PPC: PV mtmsrd L=1
       KVM: PPC: PV mtmsrd L=0 and mtmsr
       KVM: PPC: PV wrteei
       KVM: PPC: Add Documentation about PV interface
       KVM: PPC: Add get_pvinfo interface to query hypercall instructions
       KVM: PPC: Book3S_32 MMU debug compile fixes
       KVM: PPC: RCU'ify the Book3s MMU
       KVM: PPC: Add book3s_32 tlbie flush acceleration
       KVM: PPC: Use MSR_DR for external load_up
       KVM: PPC: Make long relocations be ulong
       KVM: PPC: Move KVM trampolines before __end_interrupts
       KVM: S390: take a full byte as ext_param indicator
       KVM: S390: Add virtio hotplug add support
       KVM: S390: Export kvm_virtio.h
       KVM: PPC: Fix CONFIG_KVM_GUEST && !CONFIG_KVM case
       KVM: PPC: Move EXIT_DEBUG partially to tracepoints
       KVM: PPC: Move book3s_64 mmu map debug print to trace point
       KVM: PPC: Add tracepoint for generic mmu map
       KVM: PPC: Move pte invalidate debug code to tracepoint
       KVM: PPC: Fix sid map search after flush
       KVM: PPC: Add tracepoints for generic spte flushes
       KVM: PPC: Preload magic page when in kernel mode
       KVM: PPC: Don't flush PTEs on NX/RO hit
       KVM: PPC: Make invalidation code more reliable
       KVM: PPC: Move slb debugging to tracepoints
       KVM: PPC: Revert "KVM: PPC: Use kernel hash function"
       KVM: PPC: Remove unused define
       KVM: PPC: Add feature bitmap for magic page
       KVM: PPC: Move BAT handling code into spr handler
       KVM: PPC: Interpret SR registers on demand
       KVM: PPC: Put segment registers in shared page
       KVM: PPC: Add mtsrin PV code
       KVM: PPC: Make PV mtmsr work with r30 and r31
       KVM: PPC: Update int_pending also on dequeue
       KVM: PPC: Make PV mtmsrd L=1 work with r30 and r31
       KVM: PPC: Force enable nap on KVM
       KVM: PPC: Implement correct SID mapping on Book3s_32
       KVM: PPC: Don't put MSR_POW in MSR
       KVM: PPC: Enable napping only for Book3s_64
       KVM: PPC: Implement Level interrupts on Book3S
       KVM: PPC: Expose level based interrupt cap
       KVM: PPC: Implement level interrupts for BookE
       KVM: PPC: Document KVM_INTERRUPT ioctl
       KVM: PPC: Fix compile error in e500_tlb.c
       KVM: PPC: Add documentation for magic page enhancements
       KVM: PPC: Move of include to __KERNEL__ section

Arjan Koers (1):
       KVM guest: Move a printk that's using the clock before it's ready

Avi Kivity (102):
       KVM: x86 emulator: fix handling for unemulated instructions
       KVM: x86 emulator: add macros for repetitive instructions
       KVM: x86 emulator: consolidate inc/dec reg decoding
       KVM: x86 emulator: consolidate push/pop reg decoding
       KVM: x86 emulator: consolidate Jcc rel8 decoding
       KVM: x86 emulator: consolidate MOV reg, imm decoding
       KVM: x86 emulator: consolidate CMOVcc decoding
       KVM: x86 emulator: consolidate Jcc rel32 decoding
       KVM: x86 emulator: Make group storage bits separate from operand bits
       KVM: x86 emulator: add Undefined decode flag
       KVM: x86 emulator: mix decode bits from opcode and group decode 
tables
       KVM: x86 emulator: simplify Group 1 decoding
       KVM: x86 emulator: Allow LOCK prefix for NEG and NOT
       KVM: x86 emulator: unify the two Group 3 variants
       KVM: VMX: Use host_gdt variable wherever we need the host gdt
       KVM: x86 emulator: drop parentheses in repreat macros
       KVM: x86 emulator: introduce 'struct opcode'
       KVM: x86 emulator: Add wrappers for easily defining opcodes
       KVM: x86 emulator: move group tables to top
       KVM: x86 emulator: reserve group code 0
       KVM: x86 emulator: allow specifying group directly in opcode
       KVM: x86 emulator: convert group 1 to new style
       KVM: x86 emulator: convert group 1A to new style
       KVM: x86 emulator: convert group 3 to new style
       KVM: x86 emulator: convert group 4 to new style
       KVM: x86 emulator: convert group 5 to new style
       KVM: x86 emulator: convert group 7 to new style
       KVM: x86 emulator: convert group 8 to new style
       KVM: x86 emulator: convert group 9 to new style
       KVM: x86 emulator: drop support for old-style groups
       KVM: x86 emulator: move ByteOp and Dst back to bits 0:3
       KVM: x86 emulator: store x86_emulate_ops in emulation context
       KVM: x86 emulator: allow storing emulator execution function in 
decode tables
       KVM: x86 emulator: move x86_decode_insn() downwards
       KVM: x86 emulator: move decode tables downwards
       KVM: x86 emulator: allow repeat macro arguments to contain commas
       KVM: x86 emulator: convert some push instructions to direct decode
       KVM: x86 emulator: fix LMSW able to clear cr0.pe
       KVM: x86 emulator: push segment override out of decode_modrm()
       KVM: x86 emulator: use correct type for memory address in operands
       KVM: x86 emulator: simplify xchg decode tables
       KVM: x86 emulator: use SrcAcc to simplify xchg decoding
       KVM: x86 emulator: put register operand fetch into a function
       KVM: x86 emulator: drop use_modrm_ea
       KVM: x86 emulator: simplify REX.W check
       KVM: x86 emulator: introduce Op3264 for mov cr and mov dr 
instructions
       KVM: x86 emulator: mark mov cr and mov dr as 64-bit instructions 
in long mode
       KVM: x86 emulator: use struct operand for mov reg,cr and mov 
cr,reg for reg op
       KVM: x86 emulator: use struct operand for mov reg,dr and mov 
dr,reg for reg op
       KVM: x86 emulator: add NoAccess flag for memory instructions that 
skip access
       KVM: x86 emulator: switch LEA to use SrcMem decoding
       KVM: x86 emulator: change invlpg emulation to use src.mem.addr
       KVM: x86 emulator: Decode memory operands directly into a 'struct 
operand'
       KVM: x86 emulator: fix INTn emulation not pushing EFLAGS and CS
       KVM: x86 emulator: implement SCAS (opcodes AE, AF)
       KVM: x86 emulator: fix REPZ/REPNZ termination condition
       KVM: x86 emulator: pass destination type to ____emulate_2op()
       KVM: x86 emulator: Use a register for ____emulate_2op() destination
       KVM: x86 emulator: implement DAS (opcode 2F)
       KVM: x86 emulator: implement CALL FAR (FF /3)
       KVM: x86 emulator: add SrcImmU16 operand type
       KVM: x86 emulator: implement RET imm16 (opcode C2)
       KVM: x86 emulator: implement IMUL REG, R/M, imm8 (opcode 6B)
       KVM: x86 emulator: implement IMUL REG, R/M (opcode 0F AF)
       KVM: x86 emulator: remove SrcImplicit
       KVM: x86 emulator: implement RDTSC (opcode 0F 31)
       KVM: x86 emulator: consolidate immediate decode into a function
       KVM: x86 emulator: add Src2Imm decoding
       KVM: x86 emulator: implement IMUL REG, R/M, IMM (opcode 69)
       KVM: x86 emulator: implement CWD (opcode 99)
       KVM: x86 emulator: refuse SrcMemFAddr (e.g. LDS) with register 
operand
       KVM: x86 emulator: support byte/word opcode pairs
       KVM: x86 emulator: simplify ALU block (opcodes 00-3F) decode flags
       KVM: x86 emulator: simplify string instruction decode flags
       KVM: x86 emulator: simplify instruction decode flags for opcodes 
80-8F
       KVM: x86 emulator: simplify instruction decode flags for opcodes 
A0-AF
       KVM: x86 emulator: simplify instruction decode flags for opcodes 
C0-DF
       KVM: x86 emulator: simplify instruction decode flags for opcodes 
E0-FF
       KVM: x86 emulator: simplify instruction decode flags for opcodes 
0F 00-FF
       KVM: x86 emulator: add macros for executing instructions that may 
trap
       KVM: x86 emulator: trap and propagate #DE from DIV and IDIV
       KVM: Fix build error due to 64-bit division in nsec_to_cycles()
       KVM: x86 emulator: simplify ALU opcode block decode further
       KVM: Fix pio trace direction
       KVM: Don't save/restore MSR_IA32_PERF_STATUS
       KVM: x86 emulator: use single stage decoding for mov instructions
       KVM: x86 emulator: fix group 11 decoding for reg != 0
       KVM: x86 emulator: clean up control flow in x86_emulate_insn()
       KVM: i8259: Make ICW1 conform to spec
       KVM: Document that KVM_GET_SUPPORTED_CPUID may return emulated values
       KVM: MMU: Fix regression with ept memory types merged into 
non-ept page tables
       KVM: Check for pending events before attempting injection
       KVM: VMX: Split up vmx_complete_interrupts()
       KVM: VMX: Move real-mode interrupt injection fixup to 
vmx_complete_interrupts()
       KVM: VMX: Parameterize vmx_complete_interrupts() for both exit 
and entry
       KVM: Non-atomic interrupt injection
       KVM: VMX: Move fixup_rmode_irq() to avoid forward declaration
       KVM: Convert PIC lock from raw spinlock to ordinary spinlock
       KVM: VMX: Respect interrupt window in big real mode
       KVM: cpu_relax() during spin waiting for reboot
       KVM: MMU: Avoid sign extension in mmu_alloc_direct_roots() pae 
root address
       KVM: Disable interrupts around get_kernel_ns()

Dave Hansen (4):
       KVM: abstract kvm x86 mmu->n_free_mmu_pages
       KVM: rename x86 kvm->arch.n_alloc_mmu_pages
       KVM: replace x86 kvm n_free_mmu_pages with n_used_mmu_pages
       KVM: create aggregate kvm_total_used_mmu_pages value

Gleb Natapov (7):
       KVM: x86 emulator: don't update vcpu state if instruction is 
restarted
       KVM: x86 emulator: check io permissions only once for string pio
       KVM: PPC: correctly check gfn_to_pfn() return value
       KVM: x86 emulator: Rename variable that shadows another local 
variable.
       KVM: x86 emulator: move string instruction completion check into 
separate function
       KVM: x86 emulator: get rid of "restart" in emulation context.
       KVM: SVM: do not generate "external interrupt exit" if other exit 
is pending

Hillf Danton (1):
       KVM: MMU: fix counting of rmap entries in rmap_add()

Hollis Blanchard (3):
       KVM: PPC: initialize IVORs in addition to IVPR
       KVM: PPC: fix compilation of "dump tlbs" debug function
       KVM: PPC: allow ppc440gp to pass the compatibility check

Huang Ying (2):
       KVM: MCE: Add MCG_SER_P into KVM_MCE_CAP_SUPPORTED
       KVM: MCE: Send SRAR SIGBUS directly

Jan Kiszka (4):
       KVM: VMX: Add AX to list of registers clobbered by guest switch
       KVM: x86: Fix constant type in kvm_get_time_scale
       KVM: Fix signature of kvm_iommu_map_pages stub
       KVM: Drop CONFIG_DMAR dependency around kvm_iommu_map_pages

Jason Wang (1):
       KVM: pit: Do not check pending pit timer in vcpu thread

Jes Sorensen (3):
       KVM: Fix guest kernel crash on MSR_K7_CLK_CTL
       x86: Define MSR_EBC_FREQUENCY_ID
       KVM: x86: Emulate MSR_EBC_FREQUENCY_ID

Jiri Kosina (1):
       KVM: x86: explain 'no-kvmclock' kernel parameter

Joerg Roedel (36):
       KVM: SVM: Sync efer back into nested vmcb
       KVM: SVM: Emulate next_rip svm feature
       KVM: SVM: Check for nested vmrun intercept before emulating vmrun
       KVM: SVM: Check for asid != 0 on nested vmrun
       KVM: MMU: Fix 32 bit legacy paging with NPT
       KVM: SVM: Restore correct registers after sel_cr0 intercept emulation
       KVM: MMU: Check for root_level instead of long mode
       KVM: MMU: Make tdp_enabled a mmu-context parameter
       KVM: MMU: Make set_cr3 a function pointer in kvm_mmu
       KVM: X86: Introduce a tdp_set_cr3 function
       KVM: MMU: Introduce get_cr3 function pointer
       KVM: MMU: Introduce inject_page_fault function pointer
       KVM: MMU: Introduce kvm_init_shadow_mmu helper function
       KVM: MMU: Let is_rsvd_bits_set take mmu context instead of vcpu
       KVM: MMU: Track page fault data in struct vcpu
       KVM: MMU: Introduce generic walk_addr function
       KVM: MMU: Add infrastructure for two-level page walker
       KVM: X86: Introduce pointer to mmu context used for gva_to_gpa
       KVM: MMU: Implement nested gva_to_gpa functions
       KVM: X86: Add kvm_read_guest_page_mmu function
       KVM: MMU: Make walk_addr_generic capable for two-level walking
       KVM: MMU: Introduce kvm_read_nested_guest_page()
       KVM: MMU: Introduce init_kvm_nested_mmu()
       KVM: MMU: Propagate the right fault back to the guest after 
gva_to_gpa
       KVM: X86: Propagate fetch faults
       KVM: MMU: Add kvm_mmu parameter to load_pdptrs function
       KVM: MMU: Introduce kvm_pdptr_read_mmu
       KVM: MMU: Refactor mmu_alloc_roots function
       KVM: MMU: Allow long mode shadows for legacy page tables
       KVM: MMU: Track NX state in struct kvm_mmu
       KVM: SVM: Implement MMU helper functions for Nested Nested Paging
       KVM: SVM: Initialize Nested Nested MMU context on VMRUN
       KVM: SVM: Expect two more candiates for exit_int_info
       KVM: SVM: Report Nested Paging support to userspace
       KVM: X86: Report SVM bit to userspace only when supported
       KVM: MMU: Don't track nested fault info in error-code

Kyle Moffett (1):
       KVM: PPC: e500_tlb: Fix a minor copy-paste tracing bug

Marcelo Tosatti (2):
       KVM: SVM: reset mmu context in init_vmcb
       KVM: SVM: init_vmcb should reset vcpu->efer

Mohammed Gamal (11):
       KVM: x86 emulator: Add IRET instruction
       KVM: x86 emulator: Fix nop emulation
       KVM: x86 emulator: Allow accessing IDT via emulator ops
       KVM: x86 emulator: Add into, int, and int3 instructions (opcodes 
0xcc-0xce)
       KVM: x86 emulator: Add stc instruction (opcode 0xf9)
       KVM: x86 emulator: Add unary mul, imul, div, and idiv instructions
       KVM: x86 emulator: Fix emulate_grp3 return values
       KVM: Separate emulation context initialization in a separate function
       KVM: x86 emulator: Expose emulate_int_real()
       KVM: Add kvm_inject_realmode_interrupt() wrapper
       KVM: VMX: Emulated real mode interrupt injection

Nicolas Kaiser (1):
       KVM: fix typo in copyright notice

Roedel, Joerg (1):
       KVM: SVM: Clean up rip handling in vmrun emulation

Sheng Yang (1):
       KVM: x86 emulator: Eliminate compilation warning in x86_decode_insn()

Takuya Yoshikawa (1):
       KVM: ia64: define kvm_lapic_enabled() to fix a compile error

Wei Yongjun (22):
       KVM: x86 emulator: simplify two-byte opcode check
       KVM: x86 emulator: use SrcAcc to simplify stos decoding
       KVM: x86 emulator: disable writeback when decode dest operand
       KVM: x86 emulator: using SrcOne for instruction d0/d1 decoding
       KVM: x86 emulator: fix negative bit offset BitOp instruction 
emulation
       KVM: x86 emulator: do not adjust the address for immediate source
       KVM: x86 emulator: mask group 8 instruction as BitOp
       KVM: x86 emulator: add bsf/bsr instruction emulation
       KVM: PPC: fix leakage of error page in kvmppc_patch_dcbz()
       KVM: x86 emulator: put register operand write back to a function
       KVM: x86 emulator: add XADD instruction emulation
       KVM: x86 emulator: add setcc instruction emulation
       KVM: x86 emulator: remove useless label from x86_emulate_insn()
       KVM: x86 emulator: introduce DstImmUByte for dst operand decode
       KVM: x86 emulator: change OUT instruction to use dst instead of src
       KVM: x86 emulator: remove dup code of in/out instruction
       KVM: x86 emulator: add CBW/CWDE/CDQE instruction emulation
       KVM: x86 emulator: add LOOP/LOOPcc instruction emulation
       KVM: x86 emulator: add LDS/LES/LFS/LGS/LSS instruction emulation
       KVM: x86 emulator: add JrCXZ instruction emulation
       KVM: MMU: fix missing percpu counter destroy
       KVM: x86 emulator: add CALL FAR instruction emulation (opcode 9a)

Xiao Guangrong (29):
       KVM: MMU: remove valueless output message
       KVM: MMU: using kvm_set_pfn_accessed() instead of 
mark_page_accessed()
       KVM: MMU: move bits lost judgement into a separate function
       KVM: MMU: mark page dirty only when page is really written
       export __get_user_pages_fast() function
       KVM: MMU: introduce hva_to_pfn_atomic function
       KVM: MMU: introduce gfn_to_page_many_atomic() function
       KVM: MMU: prefetch ptes when intercepted guest #PF
       KVM: MMU: combine guest pte read between fetch and pte prefetch
       KVM: MMU: fix compile warning in audit code
       KVM: MMU: check rmap for every spte
       KVM: MMU: fix wrong not write protected sp report
       KVM: MMU: rewrite audit_mappings_page() function
       KVM: MMU: remove count_rmaps()
       KVM: MMU: support disable/enable mmu audit dynamicly
       KVM: MMU: move audit to a separate file
       KVM: MMU: improve active sp audit
       KVM: MMU: improve spte audit
       KVM: MMU: lower the aduit frequency
       KVM: fix the description of kvm-amd.nested in documentation
       KVM: document 'kvm.mmu_audit' parameter
       KVM: MMU: update 'root_hpa' out of loop in PAE shadow path
       KVM: MMU: cleanup for error mask set while walk guest page table
       KVM: MMU: set access bit for direct mapping
       KVM: MMU: audit: fix vcpu's spte walking
       KVM: MMU: audit: unregister audit tracepoints before module unloaded
       KVM: MMU: audit: introduce audit_printk to cleanup audit code
       KVM: MMU: audit: check whether have unsync sps after root sync
       KVM: MMU: move access code parsing to FNAME(walk_addr) function

Xiaotian Feng (1):
       KVM: MMU: fix regression from rework mmu_shrink() code

Zachary Amsden (18):
       KVM: x86: Drop vm_init_tsc
       KVM: x86: Convert TSC writes to TSC offset writes
       KVM: x86: Move TSC offset writes to common code
       KVM: x86: TSC reset compensation
       KVM: x86: Make cpu_tsc_khz updates use local CPU
       KVM: x86: Warn about unstable TSC
       KVM: x86: Unify TSC logic
       KVM: x86: Fix deep C-state TSC desynchronization
       KVM: x86: Add helper functions for time computation
       KVM: x86: Robust TSC compensation
       KVM: x86: Add clock sync request to hardware enable
       x86: pvclock: Move scale_delta into common header
       KVM: x86: Fix a possible backwards warp of kvmclock
       KVM: x86: Add timekeeping documentation
       KVM: x86: Fix kvmclock bug
       KVM: x86: Make math work for other scales
       KVM: x86: Rename timer function
       KVM: x86: TSC catchup mode

  Documentation/kernel-parameters.txt      |    8 +-
  Documentation/kvm/api.txt                |   61 +-
  Documentation/kvm/ppc-pv.txt             |  196 +++
  Documentation/kvm/timekeeping.txt        |  612 ++++++++
  arch/ia64/kvm/lapic.h                    |    1 +
  arch/powerpc/include/asm/kvm.h           |    1 +
  arch/powerpc/include/asm/kvm_asm.h       |    4 +-
  arch/powerpc/include/asm/kvm_book3s.h    |   31 +-
  arch/powerpc/include/asm/kvm_host.h      |   21 +-
  arch/powerpc/include/asm/kvm_para.h      |  139 ++-
  arch/powerpc/include/asm/kvm_ppc.h       |    1 +
  arch/powerpc/kernel/Makefile             |    2 +
  arch/powerpc/kernel/asm-offsets.c        |   25 +-
  arch/powerpc/kernel/exceptions-64s.S     |    6 +
  arch/powerpc/kernel/head_64.S            |    6 -
  arch/powerpc/kernel/kvm.c                |  596 +++++++
  arch/powerpc/kernel/kvm_emul.S           |  302 ++++
  arch/powerpc/kvm/44x.c                   |   10 +-
  arch/powerpc/kvm/44x_tlb.c               |    9 +-
  arch/powerpc/kvm/book3s.c                |  272 +++--
  arch/powerpc/kvm/book3s_32_mmu.c         |  111 +-
  arch/powerpc/kvm/book3s_32_mmu_host.c    |   75 +-
  arch/powerpc/kvm/book3s_64_mmu.c         |   42 +-
  arch/powerpc/kvm/book3s_64_mmu_host.c    |   74 +-
  arch/powerpc/kvm/book3s_emulate.c        |   73 +-
  arch/powerpc/kvm/book3s_mmu_hpte.c       |  140 ++-
  arch/powerpc/kvm/book3s_paired_singles.c |   11 +-
  arch/powerpc/kvm/book3s_rmhandlers.S     |   32 +-
  arch/powerpc/kvm/booke.c                 |  108 +-
  arch/powerpc/kvm/booke.h                 |   10 +-
  arch/powerpc/kvm/booke_emulate.c         |   14 +-
  arch/powerpc/kvm/booke_interrupts.S      |    3 +-
  arch/powerpc/kvm/e500.c                  |    7 +
  arch/powerpc/kvm/e500_tlb.c              |   18 +-
  arch/powerpc/kvm/e500_tlb.h              |    2 +-
  arch/powerpc/kvm/emulate.c               |   36 +-
  arch/powerpc/kvm/powerpc.c               |   88 +-
  arch/powerpc/kvm/trace.h                 |  239 +++
  arch/powerpc/platforms/Kconfig           |   10 +
  arch/s390/include/asm/Kbuild             |    1 +
  arch/s390/include/asm/kvm_virtio.h       |    7 +
  arch/x86/include/asm/kvm_emulate.h       |   30 +-
  arch/x86/include/asm/kvm_host.h          |   81 +-
  arch/x86/include/asm/kvm_para.h          |    6 +
  arch/x86/include/asm/msr-index.h         |    1 +
  arch/x86/include/asm/pvclock.h           |   38 +
  arch/x86/kernel/kvmclock.c               |    6 +-
  arch/x86/kernel/pvclock.c                |    3 +-
  arch/x86/kvm/Kconfig                     |    7 +
  arch/x86/kvm/emulate.c                   | 2498 
+++++++++++++++++-------------
  arch/x86/kvm/i8254.c                     |   11 +-
  arch/x86/kvm/i8259.c                     |   25 +-
  arch/x86/kvm/irq.c                       |    9 +-
  arch/x86/kvm/irq.h                       |    2 +-
  arch/x86/kvm/kvm_cache_regs.h            |    9 +-
  arch/x86/kvm/lapic.c                     |   15 +-
  arch/x86/kvm/mmu.c                       |  918 ++++++------
  arch/x86/kvm/mmu.h                       |    9 +-
  arch/x86/kvm/mmu_audit.c                 |  299 ++++
  arch/x86/kvm/mmutrace.h                  |   19 +
  arch/x86/kvm/paging_tmpl.h               |  202 ++-
  arch/x86/kvm/svm.c                       |  283 +++-
  arch/x86/kvm/timer.c                     |    2 +-
  arch/x86/kvm/vmx.c                       |  219 ++--
  arch/x86/kvm/x86.c                       |  780 +++++++---
  arch/x86/kvm/x86.h                       |    8 +
  drivers/s390/kvm/kvm_virtio.c            |   66 +-
  include/linux/kvm.h                      |   12 +
  include/linux/kvm_host.h                 |   22 +-
  include/linux/kvm_para.h                 |    7 +-
  mm/util.c                                |   13 +
  virt/kvm/irq_comm.c                      |    2 +-
  virt/kvm/kvm_main.c                      |   84 +-
  73 files changed, 6701 insertions(+), 2389 deletions(-)
  create mode 100644 Documentation/kvm/ppc-pv.txt
  create mode 100644 Documentation/kvm/timekeeping.txt
  create mode 100644 arch/powerpc/kernel/kvm.c
  create mode 100644 arch/powerpc/kernel/kvm_emul.S
  create mode 100644 arch/x86/kvm/mmu_audit.c

-- 
error compiling committee.c: too many arguments to function

