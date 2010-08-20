Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751171Ab0HTMFX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 08:05:23 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:35433 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab0HTMFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 08:05:20 -0400
Date: Fri, 20 Aug 2010 21:04:24 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.36-rc2
Message-ID: <20100820120424.GC30659@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git

Which contains:

Andrew Murray (1):
      sh: Use __GFP_ZERO for dma_generic_alloc_coherent().

Guennadi Liakhovetski (3):
      dmaengine: initialise DMA engine before MMC
      sh: move a debug printk() to a more meaningful location in the clock driver
      sh: remove bogus highest / lowest logic from clock rate rounding

Hitoshi Mitake (1):
      sh: SH-2007 board support.

Kulikov Vasiliy (1):
      sh: dma: check return value of create_proc_read_entry()

Magnus Damm (3):
      clocksource: sh_cmt: One-off clockevent fix V2
      clocksource: sh_cmt: Rate calculation fix
      i2c: i2c-sh_mobile irq rollback fix

Markus Pietrek (1):
      sound/soc/sh/siu: Fixed undefined dma_length of scatter gather list

Matt Fleming (1):
      sh: Fix typos in PCI initialization message

Nobuhiro Iwamatsu (1):
      sh: Drop dependence for 29bit mode of trigger_address_error()

Paul Mundt (15):
      sh: Add kprobe-based event tracer.
      sh: split out ptrace header for _32/_64 variants.
      sh: kprobes SMP support.
      sh: update the FDPIC relocations.
      sh: fix up an off-by-1 in the number of early ioremap fixmaps.
      sh: Fix up PUD trampling in ranged page table init for X2TLB.
      sh: Provide a global TLB flush for U/I-TLB clear.
      sh: wire up fanotify/prlimit64 syscalls.
      sh: fix up fallout from syscall arg constification.
      sh: stub __flush_tlb_global() definition for nommu.
      sh: Support type 1 accesses for SH7786 PCI.
      sh: Fix up SH7786 PCIe PHY initialization.
      sh: reinstate clock framework rate rounding.
      sh: Relax devfn constraints for SH7786 PCIe.
      sh: sh2007/sh7757lcr defconfig reduction.

Phil Edworthy (1):
      sh: Add sh7724 BEU resources

Sam Ravnborg (1):
      sh: fix recursive dependency in Kconfig

Yoshihiro Shimoda (7):
      sh: modify NR_IRQS from 256 to 512
      sh: change PVR of SH7757 for 2nd cut
      sh: fix the id of scif in setup-sh7757
      sh: add some INTC_VECT for setup-sh7757
      sh: modify pinmux for SH7757 2nd cut
      sh: modify clock framework of SH7757
      sh: add sh7757lcr board support

 arch/sh/Kconfig                           |    5 +-
 arch/sh/boards/Kconfig                    |   16 +
 arch/sh/boards/Makefile                   |    2 +
 arch/sh/boards/board-sh2007.c             |  133 +++
 arch/sh/boards/board-sh7757lcr.c          |  374 +++++++
 arch/sh/configs/sh2007_defconfig          |  213 ++++
 arch/sh/configs/sh7757lcr_defconfig       |   85 ++
 arch/sh/drivers/dma/dma-api.c             |    4 +-
 arch/sh/drivers/pci/ops-sh7786.c          |   27 +-
 arch/sh/drivers/pci/pci-sh7751.c          |    2 +-
 arch/sh/drivers/pci/pci-sh7780.c          |    2 +-
 arch/sh/drivers/pci/pcie-sh7786.c         |   32 +-
 arch/sh/include/asm/Kbuild                |    2 +
 arch/sh/include/asm/elf.h                 |   27 +-
 arch/sh/include/asm/fixmap.h              |    4 +-
 arch/sh/include/asm/irq.h                 |    2 +-
 arch/sh/include/asm/kprobes.h             |    1 -
 arch/sh/include/asm/processor_32.h        |    3 -
 arch/sh/include/asm/processor_64.h        |    3 -
 arch/sh/include/asm/ptrace.h              |  169 ++--
 arch/sh/include/asm/ptrace_32.h           |   83 ++
 arch/sh/include/asm/ptrace_64.h           |   20 +
 arch/sh/include/asm/syscalls_32.h         |    7 +-
 arch/sh/include/asm/system_32.h           |   13 +-
 arch/sh/include/asm/tlbflush.h            |    2 +
 arch/sh/include/asm/unistd_32.h           |    5 +-
 arch/sh/include/asm/unistd_64.h           |    5 +-
 arch/sh/include/cpu-sh4/cpu/sh7757.h      |  301 +++---
 arch/sh/include/mach-common/mach/sh2007.h |  117 +++
 arch/sh/kernel/Makefile                   |    2 +-
 arch/sh/kernel/cpu/sh4/probe.c            |    2 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7757.c    |  199 ++--
 arch/sh/kernel/cpu/sh4a/pinmux-sh7757.c   | 1582 +++++++++++++++++------------
 arch/sh/kernel/cpu/sh4a/setup-sh7724.c    |   66 ++
 arch/sh/kernel/cpu/sh4a/setup-sh7757.c    |  222 +++--
 arch/sh/kernel/kprobes.c                  |  100 +-
 arch/sh/kernel/ptrace.c                   |   33 +
 arch/sh/kernel/ptrace_32.c                |   27 +
 arch/sh/kernel/ptrace_64.c                |   79 ++
 arch/sh/kernel/reboot.c                   |    4 +
 arch/sh/kernel/syscalls_32.S              |    3 +
 arch/sh/kernel/syscalls_64.S              |    3 +
 arch/sh/mm/consistent.c                   |    3 +-
 arch/sh/mm/init.c                         |   52 +-
 arch/sh/mm/nommu.c                        |    4 +
 arch/sh/mm/tlbflush_32.c                  |   16 +
 arch/sh/mm/tlbflush_64.c                  |    5 +
 arch/sh/tools/mach-types                  |    2 +
 drivers/Makefile                          |    2 +-
 drivers/clocksource/sh_cmt.c              |   12 +-
 drivers/i2c/busses/i2c-sh_mobile.c        |   23 +-
 drivers/serial/sh-sci.h                   |   17 +-
 drivers/sh/clk.c                          |    9 +-
 sound/soc/sh/siu_pcm.c                    |    2 +
 54 files changed, 2919 insertions(+), 1209 deletions(-)
 create mode 100644 arch/sh/boards/board-sh2007.c
 create mode 100644 arch/sh/boards/board-sh7757lcr.c
 create mode 100644 arch/sh/configs/sh2007_defconfig
 create mode 100644 arch/sh/configs/sh7757lcr_defconfig
 create mode 100644 arch/sh/include/asm/ptrace_32.h
 create mode 100644 arch/sh/include/asm/ptrace_64.h
 create mode 100644 arch/sh/include/mach-common/mach/sh2007.h
 create mode 100644 arch/sh/kernel/ptrace.c
