Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab2AHMvl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 07:51:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17817 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388Ab2AHMvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 07:51:40 -0500
Message-ID: <4F099156.20700@redhat.com>
Date: Sun, 08 Jan 2012 14:51:34 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] KVM updates for the 3.3 merge window
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/3.3

to receive the KVM updates for the 3.3 cycle.  Changes include a virtual
PMU available for guests, an MMU/MMIO speedup, more cpuid feature
whitelisting, and cleanups.

The branch contains tip/perf, which you've already merged, so much of
the diffstat below won't appear once you've merged it.


Alex,Shi (1):
      KVM: use this_cpu_xxx replace percpu_xxx funcs

Alexander Graf (2):
      KVM: Fix whitespace in kvm_para.h
      KVM: PPC: Whitespace fix for kvm.h

Avi Kivity (10):
      KVM: Move cpuid code to new file
      KVM: Document KVM_NMI
      Merge remote-tracking branch 'tip/perf/core' into kvm-updates/3.3
      KVM: Make KVM_INTEL depend on CPU_SUP_INTEL
      KVM: Expose kvm_lapic_local_deliver()
      KVM: Add generic RDPMC support
      KVM: SVM: Intercept RDPMC
      KVM: VMX: Intercept RDPMC
      KVM: x86 emulator: fix RDPMC privilege check
      KVM: x86 emulator: implement RDPMC (0F 33)

Chris Wright (2):
      KVM guest: remove KVM guest pv mmu support
      KVM: MMU: remove KVM host pv mmu support

Dan Carpenter (1):
      KVM: make checks stricter in coalesced_mmio_in_range()

Eric B Munson (1):
      KVM: Fix include dependency for mmu_notifier

Gleb Natapov (4):
      KVM: VMX: remove unneeded vmx_load_host_state() calls.
      KVM: drop bsp_vcpu pointer from kvm struct
      KVM: Expose a version 2 architectural PMU to a guests
      KVM: Expose the architectural performance monitoring CPUID leaf

Hamo (1):
      KVM: ensure that debugfs entries have been created

Jan Kiszka (5):
      KVM: x86: Simplify kvm timer handler
      KVM: MMU: Drop unused return value of
kvm_mmu_remove_some_alloc_mmu_pages
      KVM: x86 emulator: Remove set-but-unused cr4 from check_cr_write
      KVM: x86: Do not rely on implicit inclusions
      KVM: x86: Consolidate PIT legacy test

Julian Stecklina (1):
      KVM: Allow aligned byte and word writes to IOAPIC registers.

Liu, Jinsong (1):
      KVM: expose latest Intel cpu new features (BMI1/BMI2/FMA/AVX2) to
guest

Nadav Har'El (2):
      KVM: nVMX: Add KVM_REQ_IMMEDIATE_EXIT
      KVM: nVMX: Fix warning-causing idt-vectoring-info behavior

Nishanth Aravamudan (1):
      KVM: PPC: annotate kvm_rma_init as __init

Sasha Levin (3):
      KVM: Refactor and simplify kvm_dev_ioctl_get_supported_cpuid
      KVM: Use kmemdup() instead of kmalloc/memcpy
      KVM: Use memdup_user instead of kmalloc/copy_from_user

Takuya Yoshikawa (15):
      KVM: MMU: Clean up BUG_ON() conditions in rmap_write_protect()
      KVM: MMU: Split gfn_to_rmap() into two functions
      KVM: Count the number of dirty pages for dirty logging
      KVM: Optimize dirty logging by rmap_write_protect()
      KVM: x86 emulator: Use opcode::execute for IN/OUT
      KVM: x86 emulator: Use opcode::execute for BT family
      KVM: x86 emulator: Use opcode::execute for CALL
      KVM: x86 emulator: Use opcode::execute for MOV to cr/dr
      KVM: x86 emulator: Use opcode::execute for WRMSR/RDMSR
      KVM: x86 emulator: Use opcode::execute for CMPXCHG
      KVM: x86 emulator: Use opcode::execute for BSF/BSR
      KVM: x86 emulator: Use opcode::execute for INS/OUTS from/to port in DX
      KVM: x86 emulator: Use opcode::execute for Group 1A instruction
      KVM: x86 emulator: Use opcode::execute for Group 4/5 instructions
      KVM: x86 emulator: Use opcode::execute for Group 9 instruction

Thomas Meyer (1):
      KVM: Use kmemdup rather than duplicating its implementation

Xiao Guangrong (24):
      KVM: MMU: avoid pte_list_desc running out in kvm_mmu_pte_write
      KVM: x86: tag the instructions which are used to write page table
      KVM: x86: retry non-page-table writing instructions
      KVM: x86: cleanup port-in/port-out emulated
      KVM: MMU: do not mark accessed bit on pte write path
      KVM: MMU: cleanup FNAME(invlpg)
      KVM: MMU: fast prefetch spte on invlpg path
      KVM: MMU: remove unnecessary kvm_mmu_free_some_pages
      KVM: MMU: split kvm_mmu_pte_write function
      KVM: MMU: fix detecting misaligned accessed
      KVM: MMU: improve write flooding detected
      KVM: introduce KVM_MEM_SLOTS_NUM macro
      KVM: introduce update_memslots function
      KVM: introduce kvm_for_each_memslot macro
      KVM: introduce id_to_memslot function
      KVM: sort memslots by its size and use line search
      KVM: introduce a table to map slot id to index in memslots array
      KVM: IA64: fix struct redefinition
      jump-label: export jump_label_inc/jump_label_dec
      KVM: MMU: audit: replace mmu audit tracepoint with jump-label
      KVM: x86: remove the dead code of KVM_EXIT_HYPERCALL
      KVM: MMU: move the relevant mmu code to mmu.c
      KVM: MMU: remove oos_shadow parameter
      KVM: MMU: audit: inline audit function

 Documentation/feature-removal-schedule.txt         |    9 -
 Documentation/kernel-parameters.txt                |    6 +-
 Documentation/trace/events.txt                     |    2 -
 Documentation/virtual/kvm/api.txt                  |   25 +
 arch/Kconfig                                       |    4 +
 arch/ia64/kvm/kvm-ia64.c                           |   12 +-
 arch/powerpc/include/asm/kvm.h                     |    4 +-
 arch/powerpc/kvm/book3s.c                          |    2 +-
 arch/powerpc/kvm/book3s_hv_builtin.c               |    2 +-
 arch/x86/include/asm/cpufeature.h                  |    3 +
 arch/x86/include/asm/insn.h                        |    7 +
 arch/x86/include/asm/kvm_emulate.h                 |    2 +
 arch/x86/include/asm/kvm_host.h                    |   90 ++-
 arch/x86/include/asm/perf_event.h                  |   29 +
 arch/x86/kernel/cpu/perf_event.c                   |  254 ++++--
 arch/x86/kernel/cpu/perf_event.h                   |   51 +-
 arch/x86/kernel/cpu/perf_event_amd.c               |    2 +-
 arch/x86/kernel/cpu/perf_event_intel.c             |   72 ++-
 arch/x86/kernel/jump_label.c                       |    2 +-
 arch/x86/kernel/kvm.c                              |  181 ----
 arch/x86/kvm/Kconfig                               |    3 +
 arch/x86/kvm/Makefile                              |    2 +-
 arch/x86/kvm/cpuid.c                               |  670 +++++++++++++
 arch/x86/kvm/cpuid.h                               |   46 +
 arch/x86/kvm/emulate.c                             |  436 +++++----
 arch/x86/kvm/i8254.c                               |   10 +-
 arch/x86/kvm/i8259.c                               |   24 +-
 arch/x86/kvm/lapic.c                               |    3 +-
 arch/x86/kvm/lapic.h                               |    1 +
 arch/x86/kvm/mmu.c                                 |  545 +++++-------
 arch/x86/kvm/mmu_audit.c                           |   29 +-
 arch/x86/kvm/mmutrace.h                            |   19 -
 arch/x86/kvm/paging_tmpl.h                         |   86 +-
 arch/x86/kvm/pmu.c                                 |  533 +++++++++++
 arch/x86/kvm/svm.c                                 |   15 +
 arch/x86/kvm/timer.c                               |   26 +-
 arch/x86/kvm/vmx.c                                 |   45 +-
 arch/x86/kvm/x86.c                                 | 1001
+++++---------------
 arch/x86/kvm/x86.h                                 |    5 +-
 arch/x86/lib/inat.c                                |    9 +-
 arch/x86/lib/insn.c                                |    4 +-
 arch/x86/lib/x86-opcode-map.txt                    |  606 +++++++------
 arch/x86/oprofile/Makefile                         |    3 +-
 arch/x86/oprofile/init.c                           |   30 +-
 arch/x86/oprofile/nmi_int.c                        |   27 +-
 arch/x86/oprofile/nmi_timer_int.c                  |   50 -
 arch/x86/tools/Makefile                            |   11 +-
 arch/x86/tools/gen-insn-attr-x86.awk               |   21 +-
 arch/x86/tools/insn_sanity.c                       |  275 ++++++
 drivers/oprofile/nmi_timer_int.c                   |  173 ++++
 drivers/oprofile/oprof.c                           |   30 +-
 drivers/oprofile/oprof.h                           |    9 +
 drivers/oprofile/timer_int.c                       |   30 +-
 include/linux/bitops.h                             |   10 +-
 include/linux/jump_label.h                         |   27 +
 include/linux/kvm_host.h                           |   39 +-
 include/linux/kvm_para.h                           |    1 -
 include/linux/perf_event.h                         |    7 +-
 kernel/events/Makefile                             |    2 +-
 kernel/events/callchain.c                          |  191 ++++
 kernel/events/core.c                               |  296 +-----
 kernel/events/internal.h                           |   39 +-
 kernel/jump_label.c                                |   51 +-
 kernel/lockdep.c                                   |   30 +-
 kernel/trace/trace.c                               |  105 ++-
 kernel/trace/trace.h                               |    2 +
 kernel/trace/trace_events_filter.c                 |   26 +-
 kernel/trace/trace_irqsoff.c                       |   13 +-
 kernel/trace/trace_output.c                        |   16 +-
 kernel/trace/trace_sched_wakeup.c                  |   13 +-
 tools/perf/Documentation/perf-annotate.txt         |    2 +-
 tools/perf/Documentation/perf-report.txt           |    4 +-
 tools/perf/Documentation/perf-script.txt           |    7 +-
 tools/perf/Documentation/perf-test.txt             |    8 +-
 tools/perf/Makefile                                |    1 +
 tools/perf/builtin-annotate.c                      |  133 ++--
 tools/perf/builtin-diff.c                          |   21 +-
 tools/perf/builtin-inject.c                        |  118 ++-
 tools/perf/builtin-kmem.c                          |   14 +-
 tools/perf/builtin-lock.c                          |   10 +-
 tools/perf/builtin-probe.c                         |    1 -
 tools/perf/builtin-record.c                        |  585 +++++-------
 tools/perf/builtin-report.c                        |  225 +++--
 tools/perf/builtin-sched.c                         |  198 ++--
 tools/perf/builtin-script.c                        |   50 +-
 tools/perf/builtin-stat.c                          |   43 +-
 tools/perf/builtin-test.c                          |  418 ++++++++-
 tools/perf/builtin-timechart.c                     |   34 +-
 tools/perf/builtin-top.c                           |  557 ++++++------
 tools/perf/perf.c                                  |   33 +-
 tools/perf/perf.h                                  |   23 +
 tools/perf/util/annotate.c                         |    6 +-
 tools/perf/util/annotate.h                         |    5 +-
 tools/perf/util/build-id.c                         |   26 +-
 tools/perf/util/build-id.h                         |    2 +-
 tools/perf/util/callchain.h                        |    3 +
 tools/perf/util/cgroup.c                           |   15 +-
 tools/perf/util/debugfs.c                          |   35 +-
 tools/perf/util/debugfs.h                          |   31 +-
 tools/perf/util/event.c                            |  243 +++--
 tools/perf/util/event.h                            |   65 +-
 tools/perf/util/evlist.c                           |  293 ++++++-
 tools/perf/util/evlist.h                           |   43 +-
 tools/perf/util/evsel.c                            |   70 ++
 tools/perf/util/evsel.h                            |    8 +
 tools/perf/util/header.c                           |   75 +-
 tools/perf/util/header.h                           |   45 +-
 tools/perf/util/hist.h                             |    3 +-
 tools/perf/util/map.c                              |    4 +
 tools/perf/util/map.h                              |   19 +
 tools/perf/util/parse-events.c                     |   28 +-
 tools/perf/util/parse-events.h                     |    1 -
 tools/perf/util/probe-finder.h                     |    1 -
 .../perf/util/scripting-engines/trace-event-perl.c |    4 +-
 .../util/scripting-engines/trace-event-python.c    |    4 +-
 tools/perf/util/session.c                          |  326 ++++---
 tools/perf/util/session.h                          |   62 +-
 tools/perf/util/setup.py                           |    3 +-
 tools/perf/util/symbol.h                           |    1 +
 tools/perf/util/thread.c                           |    6 +-
 tools/perf/util/thread.h                           |   14 +-
 tools/perf/util/tool.h                             |   50 +
 tools/perf/util/top.h                              |   20 +-
 tools/perf/util/trace-event-info.c                 |   28 +-
 tools/perf/util/trace-event-scripting.c            |    2 +-
 tools/perf/util/trace-event.h                      |    8 +-
 tools/perf/util/ui/browsers/annotate.c             |   16 +-
 tools/perf/util/ui/browsers/hists.c                |    2 +-
 tools/perf/util/ui/progress.c                      |    3 +
 virt/kvm/coalesced_mmio.c                          |   12 +-
 virt/kvm/ioapic.c                                  |   17 +-
 virt/kvm/iommu.c                                   |   17 +-
 virt/kvm/kvm_main.c                                |  204 +++--
 133 files changed, 6568 insertions(+), 4141 deletions(-)
 create mode 100644 arch/x86/kvm/cpuid.c
 create mode 100644 arch/x86/kvm/cpuid.h
 create mode 100644 arch/x86/kvm/pmu.c
 delete mode 100644 arch/x86/oprofile/nmi_timer_int.c
 create mode 100644 arch/x86/tools/insn_sanity.c
 create mode 100644 drivers/oprofile/nmi_timer_int.c
 create mode 100644 kernel/events/callchain.c
 create mode 100644 tools/perf/util/tool.h

-- 
error compiling committee.c: too many arguments to function

