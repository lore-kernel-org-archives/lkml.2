Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768Ab2KLLtn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 06:49:43 -0500
Received: from us02smtp2.synopsys.com ([198.182.60.77]:51518 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590Ab2KLLtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 06:49:40 -0500
From: <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tglx@linutronix.de>, <arnd@arndb.de>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [RFC Patch v1 00/55] Addons to Synopsys ARC Linux kernel Port
Date: Mon, 12 Nov 2012 17:18:49 +0530
Message-ID: <1352720953-24321-1-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vineet Gupta <vgupta@synopsys.com>

Hi,

This is a follow-up on ARC Linux port, whose #1 was posted last week.
This is part #2 of the port containing optional features.

Kindly review and provide comments !

The v2 series incorporating the review comments will combine both #1 and #2.

Thx,
-Vineet

Mischa Jonker (1):
  ARC: kgdb support

Vineet Gupta (23):
  ARC: [optim] Cache "current" in Register r25
  ARC: ptrace support
  ARC: futex
  ARC: oprofile support
  ARC: ARCompact 2 levels IRQ (high/low priority) Handling
  ARC: dynamic loadable module support
  ARC: Low level event capture/logging
  ARC: kernel diagnostics: show_regs() etc
  ARC: SMP support
  ARC: dwarf2 stack unwinder
  ARC: stacktracing APIs based on dw2 unwinder
  ARC: disassembly (needed by kprobes/kgdb/unaligned-access-emul)
  ARC: kprobes support
  ARC: unaligned access emulation
  ARC: startup #2: Verbose Boot reporting / feature verification
  ARC: [plat-arfpga] BVCI Latency Unit setup
  perf, ARC: Enable building perf tools for ARC
  ARC: perf support (software counters only)
  modpost: Ignore ARC specific non-alloc section
  ARC: Support for single cycle Close Coupled Mem (CCM)
  ARC: Hostlink Pseudo-Driver for Metaware Debugger
  ARC: [plat-arcfpga] defconfig
  ARC: Add self to MAINTAINERS

 MAINTAINERS                              |    6 +
 arch/arc/Kconfig                         |  136 +++
 arch/arc/Makefile                        |   19 +
 arch/arc/configs/fpga_defconfig          |  137 +++-
 arch/arc/include/asm/Kbuild              |    2 -
 arch/arc/include/asm/arcregs.h           |  122 +++-
 arch/arc/include/asm/current.h           |   32 +
 arch/arc/include/asm/defines.h           |   56 ++
 arch/arc/include/asm/disasm.h            |  116 +++
 arch/arc/include/asm/entry.h             |  189 +++++
 arch/arc/include/asm/event-log-asm.h     |  185 +++++
 arch/arc/include/asm/event-log.h         |  102 +++
 arch/arc/include/asm/futex.h             |  151 ++++
 arch/arc/include/asm/irqflags.h          |    6 +-
 arch/arc/include/asm/kgdb.h              |   61 ++
 arch/arc/include/asm/kprobes.h           |   62 ++
 arch/arc/include/asm/linkage.h           |   33 +
 arch/arc/include/asm/mmu_context.h       |    4 +
 arch/arc/include/asm/module.h            |   11 +
 arch/arc/include/asm/mutex.h             |    9 +
 arch/arc/include/asm/perf_event.h        |   19 +
 arch/arc/include/asm/pgtable.h           |    4 +
 arch/arc/include/asm/processor.h         |   11 +
 arch/arc/include/asm/ptrace.h            |   19 +-
 arch/arc/include/asm/setup.h             |   14 +
 arch/arc/include/asm/smp.h               |  108 +++
 arch/arc/include/asm/unaligned.h         |   29 +
 arch/arc/include/asm/unwind.h            |  163 ++++
 arch/arc/kernel/Makefile                 |   19 +-
 arch/arc/kernel/arc_hostlink.c           |  114 +++
 arch/arc/kernel/asm-offsets.c            |   18 +
 arch/arc/kernel/ctx_sw.c                 |   18 +
 arch/arc/kernel/disasm.c                 |  538 ++++++++++++
 arch/arc/kernel/entry.S                  |  259 ++++++-
 arch/arc/kernel/event-log.c              |  304 +++++++
 arch/arc/kernel/head.S                   |   33 +
 arch/arc/kernel/irq.c                    |  109 +++
 arch/arc/kernel/kgdb.c                   |  205 +++++
 arch/arc/kernel/kprobes.c                |  525 ++++++++++++
 arch/arc/kernel/module.c                 |  159 ++++
 arch/arc/kernel/ptrace.c                 |  164 ++++-
 arch/arc/kernel/setup.c                  |  281 +++++++-
 arch/arc/kernel/signal.c                 |    3 +
 arch/arc/kernel/smp.c                    |  295 +++++++
 arch/arc/kernel/stacktrace.c             |  215 +++++-
 arch/arc/kernel/traps.c                  |   45 +
 arch/arc/kernel/troubleshoot.c           |  304 +++++++
 arch/arc/kernel/unaligned.c              |  225 +++++
 arch/arc/kernel/unwind.c                 | 1329 ++++++++++++++++++++++++++++++
 arch/arc/kernel/vmlinux.lds.S            |   44 +-
 arch/arc/mm/cache_arc700.c               |   46 +
 arch/arc/mm/tlb.c                        |   47 ++
 arch/arc/mm/tlbex.S                      |   70 ++-
 arch/arc/oprofile/Makefile               |    9 +
 arch/arc/oprofile/common.c               |   22 +
 arch/arc/plat-arcfpga/Kconfig            |   57 ++
 arch/arc/plat-arcfpga/Makefile           |    1 +
 arch/arc/plat-arcfpga/include/plat/irq.h |   10 +-
 arch/arc/plat-arcfpga/include/plat/smp.h |  115 +++
 arch/arc/plat-arcfpga/irq.c              |   10 +
 arch/arc/plat-arcfpga/platform.c         |   56 ++
 arch/arc/plat-arcfpga/smp.c              |  192 +++++
 scripts/mod/modpost.c                    |    1 +
 tools/perf/perf.h                        |    6 +
 64 files changed, 7621 insertions(+), 33 deletions(-)
 create mode 100644 arch/arc/include/asm/current.h
 create mode 100644 arch/arc/include/asm/defines.h
 create mode 100644 arch/arc/include/asm/disasm.h
 create mode 100644 arch/arc/include/asm/event-log-asm.h
 create mode 100644 arch/arc/include/asm/event-log.h
 create mode 100644 arch/arc/include/asm/futex.h
 create mode 100644 arch/arc/include/asm/kgdb.h
 create mode 100644 arch/arc/include/asm/kprobes.h
 create mode 100644 arch/arc/include/asm/perf_event.h
 create mode 100644 arch/arc/include/asm/unaligned.h
 create mode 100644 arch/arc/include/asm/unwind.h
 create mode 100644 arch/arc/kernel/arc_hostlink.c
 create mode 100644 arch/arc/kernel/disasm.c
 create mode 100644 arch/arc/kernel/event-log.c
 create mode 100644 arch/arc/kernel/kgdb.c
 create mode 100644 arch/arc/kernel/kprobes.c
 create mode 100644 arch/arc/kernel/module.c
 create mode 100644 arch/arc/kernel/smp.c
 create mode 100644 arch/arc/kernel/unaligned.c
 create mode 100644 arch/arc/kernel/unwind.c
 create mode 100644 arch/arc/oprofile/Makefile
 create mode 100644 arch/arc/oprofile/common.c
 create mode 100644 arch/arc/plat-arcfpga/include/plat/smp.h
 create mode 100644 arch/arc/plat-arcfpga/smp.c

-- 
1.7.4.1

