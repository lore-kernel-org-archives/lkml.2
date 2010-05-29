Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762Ab0E2Def (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 23:34:35 -0400
Received: from king.tilera.com ([72.1.168.226]:16063 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755477Ab0E2DeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 23:34:09 -0400
Message-Id: <201005290334.o4T3Y1FX029944@farm-0002.internal.tilera.com>
In-Reply-To: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com>
References: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 28 May 2010 23:10:07 -0400
Subject: [PATCH 3/8] arch/tile: header files for the Tile architecture.
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, torvalds@linux-foundation.org
X-OriginalArrivalTime: 29 May 2010 03:34:01.0858 (UTC) FILETIME=[C7E90620:01CAFEDF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This includes the relevant Linux headers in asm/; the low-level
low-level "Tile architecture" headers in arch/, which are
shared with the hypervisor, etc., and are build-system agnostic;
and the relevant hypervisor headers in hv/.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/arch/abi.h                |   93 ++
 arch/tile/include/arch/chip.h               |   23 +
 arch/tile/include/arch/chip_tile64.h        |  252 +++
 arch/tile/include/arch/chip_tilepro.h       |  252 +++
 arch/tile/include/arch/interrupts.h         |   19 +
 arch/tile/include/arch/interrupts_32.h      |  304 ++++
 arch/tile/include/arch/sim_def.h            |  512 ++++++
 arch/tile/include/arch/spr_def.h            |   19 +
 arch/tile/include/arch/spr_def_32.h         |  162 ++
 arch/tile/include/asm/Kbuild                |    3 +
 arch/tile/include/asm/asm-offsets.h         |    1 +
 arch/tile/include/asm/atomic.h              |  159 ++
 arch/tile/include/asm/atomic_32.h           |  353 ++++
 arch/tile/include/asm/auxvec.h              |   20 +
 arch/tile/include/asm/backtrace.h           |  193 +++
 arch/tile/include/asm/bitops.h              |  126 ++
 arch/tile/include/asm/bitops_32.h           |  132 ++
 arch/tile/include/asm/bitsperlong.h         |   26 +
 arch/tile/include/asm/bug.h                 |    1 +
 arch/tile/include/asm/bugs.h                |    1 +
 arch/tile/include/asm/byteorder.h           |    1 +
 arch/tile/include/asm/cache.h               |   50 +
 arch/tile/include/asm/cacheflush.h          |  145 ++
 arch/tile/include/asm/checksum.h            |   24 +
 arch/tile/include/asm/compat.h              |  308 ++++
 arch/tile/include/asm/cputime.h             |    1 +
 arch/tile/include/asm/current.h             |   31 +
 arch/tile/include/asm/delay.h               |   34 +
 arch/tile/include/asm/device.h              |    1 +
 arch/tile/include/asm/div64.h               |    1 +
 arch/tile/include/asm/dma-mapping.h         |  106 ++
 arch/tile/include/asm/dma.h                 |   25 +
 arch/tile/include/asm/elf.h                 |  169 ++
 arch/tile/include/asm/emergency-restart.h   |    1 +
 arch/tile/include/asm/errno.h               |    1 +
 arch/tile/include/asm/fcntl.h               |    1 +
 arch/tile/include/asm/fixmap.h              |  124 ++
 arch/tile/include/asm/ftrace.h              |   20 +
 arch/tile/include/asm/futex.h               |  136 ++
 arch/tile/include/asm/hardirq.h             |   47 +
 arch/tile/include/asm/highmem.h             |   73 +
 arch/tile/include/asm/homecache.h           |  125 ++
 arch/tile/include/asm/hugetlb.h             |  109 ++
 arch/tile/include/asm/hv_driver.h           |   60 +
 arch/tile/include/asm/hw_irq.h              |   18 +
 arch/tile/include/asm/ide.h                 |   25 +
 arch/tile/include/asm/io.h                  |  220 +++
 arch/tile/include/asm/ioctl.h               |    1 +
 arch/tile/include/asm/ioctls.h              |    1 +
 arch/tile/include/asm/ipc.h                 |    1 +
 arch/tile/include/asm/ipcbuf.h              |    1 +
 arch/tile/include/asm/irq.h                 |   37 +
 arch/tile/include/asm/irq_regs.h            |    1 +
 arch/tile/include/asm/irqflags.h            |  267 +++
 arch/tile/include/asm/kdebug.h              |    1 +
 arch/tile/include/asm/kexec.h               |   53 +
 arch/tile/include/asm/kmap_types.h          |   43 +
 arch/tile/include/asm/linkage.h             |   51 +
 arch/tile/include/asm/local.h               |    1 +
 arch/tile/include/asm/memprof.h             |   33 +
 arch/tile/include/asm/mman.h                |   40 +
 arch/tile/include/asm/mmu.h                 |   31 +
 arch/tile/include/asm/mmu_context.h         |  131 ++
 arch/tile/include/asm/mmzone.h              |   81 +
 arch/tile/include/asm/module.h              |    1 +
 arch/tile/include/asm/msgbuf.h              |    1 +
 arch/tile/include/asm/mutex.h               |    1 +
 arch/tile/include/asm/opcode-tile.h         |   30 +
 arch/tile/include/asm/opcode-tile_32.h      | 1597 ++++++++++++++++++
 arch/tile/include/asm/opcode-tile_64.h      | 1597 ++++++++++++++++++
 arch/tile/include/asm/opcode_constants.h    |   26 +
 arch/tile/include/asm/opcode_constants_32.h |  480 ++++++
 arch/tile/include/asm/opcode_constants_64.h |  480 ++++++
 arch/tile/include/asm/page.h                |  334 ++++
 arch/tile/include/asm/param.h               |    1 +
 arch/tile/include/asm/pci-bridge.h          |  117 ++
 arch/tile/include/asm/pci.h                 |  128 ++
 arch/tile/include/asm/percpu.h              |   24 +
 arch/tile/include/asm/pgalloc.h             |  119 ++
 arch/tile/include/asm/pgtable.h             |  475 ++++++
 arch/tile/include/asm/pgtable_32.h          |  117 ++
 arch/tile/include/asm/poll.h                |    1 +
 arch/tile/include/asm/posix_types.h         |    1 +
 arch/tile/include/asm/processor.h           |  339 ++++
 arch/tile/include/asm/ptrace.h              |  163 ++
 arch/tile/include/asm/resource.h            |    1 +
 arch/tile/include/asm/scatterlist.h         |    1 +
 arch/tile/include/asm/sections.h            |   37 +
 arch/tile/include/asm/sembuf.h              |    1 +
 arch/tile/include/asm/setup.h               |   32 +
 arch/tile/include/asm/shmbuf.h              |    1 +
 arch/tile/include/asm/shmparam.h            |    1 +
 arch/tile/include/asm/sigcontext.h          |   27 +
 arch/tile/include/asm/sigframe.h            |   33 +
 arch/tile/include/asm/siginfo.h             |   30 +
 arch/tile/include/asm/signal.h              |   31 +
 arch/tile/include/asm/smp.h                 |  126 ++
 arch/tile/include/asm/socket.h              |    1 +
 arch/tile/include/asm/sockios.h             |    1 +
 arch/tile/include/asm/spinlock.h            |   24 +
 arch/tile/include/asm/spinlock_32.h         |  200 +++
 arch/tile/include/asm/spinlock_types.h      |   60 +
 arch/tile/include/asm/stack.h               |   68 +
 arch/tile/include/asm/stat.h                |    1 +
 arch/tile/include/asm/statfs.h              |    1 +
 arch/tile/include/asm/string.h              |   32 +
 arch/tile/include/asm/swab.h                |   29 +
 arch/tile/include/asm/syscall.h             |   79 +
 arch/tile/include/asm/syscalls.h            |   60 +
 arch/tile/include/asm/system.h              |  220 +++
 arch/tile/include/asm/termbits.h            |    1 +
 arch/tile/include/asm/termios.h             |    1 +
 arch/tile/include/asm/thread_info.h         |  165 ++
 arch/tile/include/asm/timex.h               |   47 +
 arch/tile/include/asm/tlb.h                 |   25 +
 arch/tile/include/asm/tlbflush.h            |  128 ++
 arch/tile/include/asm/topology.h            |   85 +
 arch/tile/include/asm/traps.h               |   36 +
 arch/tile/include/asm/types.h               |    1 +
 arch/tile/include/asm/uaccess.h             |  578 +++++++
 arch/tile/include/asm/ucontext.h            |    1 +
 arch/tile/include/asm/unaligned.h           |   24 +
 arch/tile/include/asm/unistd.h              |   47 +
 arch/tile/include/asm/user.h                |   21 +
 arch/tile/include/asm/xor.h                 |    1 +
 arch/tile/include/hv/drv_pcie_rc_intf.h     |   38 +
 arch/tile/include/hv/hypervisor.h           | 2366 +++++++++++++++++++++++++++
 arch/tile/include/hv/syscall_public.h       |   42 +
 128 files changed, 16017 insertions(+), 0 deletions(-)
 create mode 100644 arch/tile/include/arch/abi.h
 create mode 100644 arch/tile/include/arch/chip.h
 create mode 100644 arch/tile/include/arch/chip_tile64.h
 create mode 100644 arch/tile/include/arch/chip_tilepro.h
 create mode 100644 arch/tile/include/arch/interrupts.h
 create mode 100644 arch/tile/include/arch/interrupts_32.h
 create mode 100644 arch/tile/include/arch/sim_def.h
 create mode 100644 arch/tile/include/arch/spr_def.h
 create mode 100644 arch/tile/include/arch/spr_def_32.h
 create mode 100644 arch/tile/include/asm/Kbuild
 create mode 100644 arch/tile/include/asm/asm-offsets.h
 create mode 100644 arch/tile/include/asm/atomic.h
 create mode 100644 arch/tile/include/asm/atomic_32.h
 create mode 100644 arch/tile/include/asm/auxvec.h
 create mode 100644 arch/tile/include/asm/backtrace.h
 create mode 100644 arch/tile/include/asm/bitops.h
 create mode 100644 arch/tile/include/asm/bitops_32.h
 create mode 100644 arch/tile/include/asm/bitsperlong.h
 create mode 100644 arch/tile/include/asm/bug.h
 create mode 100644 arch/tile/include/asm/bugs.h
 create mode 100644 arch/tile/include/asm/byteorder.h
 create mode 100644 arch/tile/include/asm/cache.h
 create mode 100644 arch/tile/include/asm/cacheflush.h
 create mode 100644 arch/tile/include/asm/checksum.h
 create mode 100644 arch/tile/include/asm/compat.h
 create mode 100644 arch/tile/include/asm/cputime.h
 create mode 100644 arch/tile/include/asm/current.h
 create mode 100644 arch/tile/include/asm/delay.h
 create mode 100644 arch/tile/include/asm/device.h
 create mode 100644 arch/tile/include/asm/div64.h
 create mode 100644 arch/tile/include/asm/dma-mapping.h
 create mode 100644 arch/tile/include/asm/dma.h
 create mode 100644 arch/tile/include/asm/elf.h
 create mode 100644 arch/tile/include/asm/emergency-restart.h
 create mode 100644 arch/tile/include/asm/errno.h
 create mode 100644 arch/tile/include/asm/fcntl.h
 create mode 100644 arch/tile/include/asm/fixmap.h
 create mode 100644 arch/tile/include/asm/ftrace.h
 create mode 100644 arch/tile/include/asm/futex.h
 create mode 100644 arch/tile/include/asm/hardirq.h
 create mode 100644 arch/tile/include/asm/highmem.h
 create mode 100644 arch/tile/include/asm/homecache.h
 create mode 100644 arch/tile/include/asm/hugetlb.h
 create mode 100644 arch/tile/include/asm/hv_driver.h
 create mode 100644 arch/tile/include/asm/hw_irq.h
 create mode 100644 arch/tile/include/asm/ide.h
 create mode 100644 arch/tile/include/asm/io.h
 create mode 100644 arch/tile/include/asm/ioctl.h
 create mode 100644 arch/tile/include/asm/ioctls.h
 create mode 100644 arch/tile/include/asm/ipc.h
 create mode 100644 arch/tile/include/asm/ipcbuf.h
 create mode 100644 arch/tile/include/asm/irq.h
 create mode 100644 arch/tile/include/asm/irq_regs.h
 create mode 100644 arch/tile/include/asm/irqflags.h
 create mode 100644 arch/tile/include/asm/kdebug.h
 create mode 100644 arch/tile/include/asm/kexec.h
 create mode 100644 arch/tile/include/asm/kmap_types.h
 create mode 100644 arch/tile/include/asm/linkage.h
 create mode 100644 arch/tile/include/asm/local.h
 create mode 100644 arch/tile/include/asm/memprof.h
 create mode 100644 arch/tile/include/asm/mman.h
 create mode 100644 arch/tile/include/asm/mmu.h
 create mode 100644 arch/tile/include/asm/mmu_context.h
 create mode 100644 arch/tile/include/asm/mmzone.h
 create mode 100644 arch/tile/include/asm/module.h
 create mode 100644 arch/tile/include/asm/msgbuf.h
 create mode 100644 arch/tile/include/asm/mutex.h
 create mode 100644 arch/tile/include/asm/opcode-tile.h
 create mode 100644 arch/tile/include/asm/opcode-tile_32.h
 create mode 100644 arch/tile/include/asm/opcode-tile_64.h
 create mode 100644 arch/tile/include/asm/opcode_constants.h
 create mode 100644 arch/tile/include/asm/opcode_constants_32.h
 create mode 100644 arch/tile/include/asm/opcode_constants_64.h
 create mode 100644 arch/tile/include/asm/page.h
 create mode 100644 arch/tile/include/asm/param.h
 create mode 100644 arch/tile/include/asm/pci-bridge.h
 create mode 100644 arch/tile/include/asm/pci.h
 create mode 100644 arch/tile/include/asm/percpu.h
 create mode 100644 arch/tile/include/asm/pgalloc.h
 create mode 100644 arch/tile/include/asm/pgtable.h
 create mode 100644 arch/tile/include/asm/pgtable_32.h
 create mode 100644 arch/tile/include/asm/poll.h
 create mode 100644 arch/tile/include/asm/posix_types.h
 create mode 100644 arch/tile/include/asm/processor.h
 create mode 100644 arch/tile/include/asm/ptrace.h
 create mode 100644 arch/tile/include/asm/resource.h
 create mode 100644 arch/tile/include/asm/scatterlist.h
 create mode 100644 arch/tile/include/asm/sections.h
 create mode 100644 arch/tile/include/asm/sembuf.h
 create mode 100644 arch/tile/include/asm/setup.h
 create mode 100644 arch/tile/include/asm/shmbuf.h
 create mode 100644 arch/tile/include/asm/shmparam.h
 create mode 100644 arch/tile/include/asm/sigcontext.h
 create mode 100644 arch/tile/include/asm/sigframe.h
 create mode 100644 arch/tile/include/asm/siginfo.h
 create mode 100644 arch/tile/include/asm/signal.h
 create mode 100644 arch/tile/include/asm/smp.h
 create mode 100644 arch/tile/include/asm/socket.h
 create mode 100644 arch/tile/include/asm/sockios.h
 create mode 100644 arch/tile/include/asm/spinlock.h
 create mode 100644 arch/tile/include/asm/spinlock_32.h
 create mode 100644 arch/tile/include/asm/spinlock_types.h
 create mode 100644 arch/tile/include/asm/stack.h
 create mode 100644 arch/tile/include/asm/stat.h
 create mode 100644 arch/tile/include/asm/statfs.h
 create mode 100644 arch/tile/include/asm/string.h
 create mode 100644 arch/tile/include/asm/swab.h
 create mode 100644 arch/tile/include/asm/syscall.h
 create mode 100644 arch/tile/include/asm/syscalls.h
 create mode 100644 arch/tile/include/asm/system.h
 create mode 100644 arch/tile/include/asm/termbits.h
 create mode 100644 arch/tile/include/asm/termios.h
 create mode 100644 arch/tile/include/asm/thread_info.h
 create mode 100644 arch/tile/include/asm/timex.h
 create mode 100644 arch/tile/include/asm/tlb.h
 create mode 100644 arch/tile/include/asm/tlbflush.h
 create mode 100644 arch/tile/include/asm/topology.h
 create mode 100644 arch/tile/include/asm/traps.h
 create mode 100644 arch/tile/include/asm/types.h
 create mode 100644 arch/tile/include/asm/uaccess.h
 create mode 100644 arch/tile/include/asm/ucontext.h
 create mode 100644 arch/tile/include/asm/unaligned.h
 create mode 100644 arch/tile/include/asm/unistd.h
 create mode 100644 arch/tile/include/asm/user.h
 create mode 100644 arch/tile/include/asm/xor.h
 create mode 100644 arch/tile/include/hv/drv_pcie_rc_intf.h
 create mode 100644 arch/tile/include/hv/hypervisor.h
 create mode 100644 arch/tile/include/hv/syscall_public.h

diff --git a/arch/tile/include/arch/abi.h b/arch/tile/include/arch/abi.h
new file mode 100644
index 0000000..7cdc47b
--- /dev/null
+++ b/arch/tile/include/arch/abi.h
@@ -0,0 +1,93 @@
+// Copyright 2010 Tilera Corporation. All Rights Reserved.
+//
+//   This program is free software; you can redistribute it and/or
+//   modify it under the terms of the GNU General Public License
+//   as published by the Free Software Foundation, version 2.
+//
+//   This program is distributed in the hope that it will be useful, but
+//   WITHOUT ANY WARRANTY; without even the implied warranty of
+//   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+//   NON INFRINGEMENT.  See the GNU General Public License for
+//   more details.
+
+//! @file
+//!
+//! ABI-related register definitions helpful when writing assembly code.
+//!
+
+#ifndef __ARCH_ABI_H__
+#define __ARCH_ABI_H__
+
+#include <arch/chip.h>
+
+// Registers 0 - 55 are "normal", but some perform special roles.
+
+#define TREG_FP       52   /**< Frame pointer. */
+#define TREG_TP       53   /**< Thread pointer. */
+#define TREG_SP       54   /**< Stack pointer. */
+#define TREG_LR       55   /**< Link to calling function PC. */
+
+/** Index of last normal general-purpose register. */
+#define TREG_LAST_GPR 55
+
+// Registers 56 - 62 are "special" network registers.
+
+#define TREG_SN       56   /**< Static network access. */
+#define TREG_IDN0     57   /**< IDN demux 0 access. */
+#define TREG_IDN1     58   /**< IDN demux 1 access. */
+#define TREG_UDN0     59   /**< UDN demux 0 access. */
+#define TREG_UDN1     60   /**< UDN demux 1 access. */
+#define TREG_UDN2     61   /**< UDN demux 2 access. */
+#define TREG_UDN3     62   /**< UDN demux 3 access. */
+
+// Register 63 is the "special" zero register.
+
+#define TREG_ZERO     63   /**< "Zero" register; always reads as "0". */
+
+
+/** By convention, this register is used to hold the syscall number. */
+#define TREG_SYSCALL_NR      10
+
+/** Name of register that holds the syscall number, for use in assembly. */
+#define TREG_SYSCALL_NR_NAME r10
+
+
+//! The ABI requires callers to allocate a caller state save area of
+//! this many bytes at the bottom of each stack frame.
+//!
+#ifdef __tile__
+#define C_ABI_SAVE_AREA_SIZE (2 * __SIZEOF_POINTER__)
+#endif
+
+//! The operand to an 'info' opcode directing the backtracer to not
+//! try to find the calling frame.
+//!
+#define INFO_OP_CANNOT_BACKTRACE 2
+
+#ifndef __ASSEMBLER__
+#if CHIP_WORD_SIZE() > 32
+
+//! Unsigned type that can hold a register.
+typedef unsigned long long uint_reg_t;
+
+//! Signed type that can hold a register.
+typedef long long int_reg_t;
+
+//! String prefix to use for printf().
+#define INT_REG_FMT "ll"
+
+#elif !defined(__LP64__)   /* avoid confusion with LP64 cross-build tools */
+
+//! Unsigned type that can hold a register.
+typedef unsigned long uint_reg_t;
+
+//! Signed type that can hold a register.
+typedef long int_reg_t;
+
+//! String prefix to use for printf().
+#define INT_REG_FMT "l"
+
+#endif
+#endif /* __ASSEMBLER__ */
+
+#endif // !__ARCH_ABI_H__
diff --git a/arch/tile/include/arch/chip.h b/arch/tile/include/arch/chip.h
new file mode 100644
index 0000000..926d3db
--- /dev/null
+++ b/arch/tile/include/arch/chip.h
@@ -0,0 +1,23 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#if __tile_chip__ == 0
+#include <arch/chip_tile64.h>
+#elif __tile_chip__ == 1
+#include <arch/chip_tilepro.h>
+#elif defined(__tilegx__)
+#include <arch/chip_tilegx.h>
+#else
+#error Unexpected Tilera chip type
+#endif
diff --git a/arch/tile/include/arch/chip_tile64.h b/arch/tile/include/arch/chip_tile64.h
new file mode 100644
index 0000000..18b5bc8
--- /dev/null
+++ b/arch/tile/include/arch/chip_tile64.h
@@ -0,0 +1,252 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+/*
+ * @file
+ * Global header file.
+ * This header file specifies defines for TILE64.
+ */
+
+#ifndef __ARCH_CHIP_H__
+#define __ARCH_CHIP_H__
+
+/** Specify chip version.
+ * When possible, prefer the CHIP_xxx symbols below for future-proofing.
+ * This is intended for cross-compiling; native compilation should
+ * use the predefined __tile_chip__ symbol.
+ */
+#define TILE_CHIP 0
+
+/** Specify chip revision.
+ * This provides for the case of a respin of a particular chip type;
+ * the normal value for this symbol is "0".
+ * This is intended for cross-compiling; native compilation should
+ * use the predefined __tile_chip_rev__ symbol.
+ */
+#define TILE_CHIP_REV 0
+
+/** The name of this architecture. */
+#define CHIP_ARCH_NAME "tile64"
+
+/** The ELF e_machine type for binaries for this chip. */
+#define CHIP_ELF_TYPE() EM_TILE64
+
+/** The alternate ELF e_machine type for binaries for this chip. */
+#define CHIP_COMPAT_ELF_TYPE() 0x2506
+
+/** What is the native word size of the machine? */
+#define CHIP_WORD_SIZE() 32
+
+/** How many bits of a virtual address are used. Extra bits must be
+ * the sign extension of the low bits.
+ */
+#define CHIP_VA_WIDTH() 32
+
+/** How many bits are in a physical address? */
+#define CHIP_PA_WIDTH() 36
+
+/** Size of the L2 cache, in bytes. */
+#define CHIP_L2_CACHE_SIZE() 65536
+
+/** Log size of an L2 cache line in bytes. */
+#define CHIP_L2_LOG_LINE_SIZE() 6
+
+/** Size of an L2 cache line, in bytes. */
+#define CHIP_L2_LINE_SIZE() (1 << CHIP_L2_LOG_LINE_SIZE())
+
+/** Associativity of the L2 cache. */
+#define CHIP_L2_ASSOC() 2
+
+/** Size of the L1 data cache, in bytes. */
+#define CHIP_L1D_CACHE_SIZE() 8192
+
+/** Log size of an L1 data cache line in bytes. */
+#define CHIP_L1D_LOG_LINE_SIZE() 4
+
+/** Size of an L1 data cache line, in bytes. */
+#define CHIP_L1D_LINE_SIZE() (1 << CHIP_L1D_LOG_LINE_SIZE())
+
+/** Associativity of the L1 data cache. */
+#define CHIP_L1D_ASSOC() 2
+
+/** Size of the L1 instruction cache, in bytes. */
+#define CHIP_L1I_CACHE_SIZE() 8192
+
+/** Log size of an L1 instruction cache line in bytes. */
+#define CHIP_L1I_LOG_LINE_SIZE() 6
+
+/** Size of an L1 instruction cache line, in bytes. */
+#define CHIP_L1I_LINE_SIZE() (1 << CHIP_L1I_LOG_LINE_SIZE())
+
+/** Associativity of the L1 instruction cache. */
+#define CHIP_L1I_ASSOC() 1
+
+/** Stride with which flush instructions must be issued. */
+#define CHIP_FLUSH_STRIDE() CHIP_L2_LINE_SIZE()
+
+/** Stride with which inv instructions must be issued. */
+#define CHIP_INV_STRIDE() CHIP_L1D_LINE_SIZE()
+
+/** Stride with which finv instructions must be issued. */
+#define CHIP_FINV_STRIDE() CHIP_L1D_LINE_SIZE()
+
+/** Can the local cache coherently cache data that is homed elsewhere? */
+#define CHIP_HAS_COHERENT_LOCAL_CACHE() 0
+
+/** How many simultaneous outstanding victims can the L2 cache have? */
+#define CHIP_MAX_OUTSTANDING_VICTIMS() 2
+
+/** Does the TLB support the NC and NOALLOC bits? */
+#define CHIP_HAS_NC_AND_NOALLOC_BITS() 0
+
+/** Does the chip support hash-for-home caching? */
+#define CHIP_HAS_CBOX_HOME_MAP() 0
+
+/** Number of entries in the chip's home map tables. */
+/* #define CHIP_CBOX_HOME_MAP_SIZE() -- does not apply to chip 0 */
+
+/** Do uncacheable requests miss in the cache regardless of whether
+ * there is matching data? */
+#define CHIP_HAS_ENFORCED_UNCACHEABLE_REQUESTS() 0
+
+/** Does the mf instruction wait for victims? */
+#define CHIP_HAS_MF_WAITS_FOR_VICTIMS() 1
+
+/** Does the chip have an "inv" instruction that doesn't also flush? */
+#define CHIP_HAS_INV() 0
+
+/** Does the chip have a "wh64" instruction? */
+#define CHIP_HAS_WH64() 0
+
+/** Does this chip have a 'dword_align' instruction? */
+#define CHIP_HAS_DWORD_ALIGN() 0
+
+/** Number of performance counters. */
+#define CHIP_PERFORMANCE_COUNTERS() 2
+
+/** Does this chip have auxiliary performance counters? */
+#define CHIP_HAS_AUX_PERF_COUNTERS() 0
+
+/** Is the CBOX_MSR1 SPR supported? */
+#define CHIP_HAS_CBOX_MSR1() 0
+
+/** Is the TILE_RTF_HWM SPR supported? */
+#define CHIP_HAS_TILE_RTF_HWM() 0
+
+/** Is the TILE_WRITE_PENDING SPR supported? */
+#define CHIP_HAS_TILE_WRITE_PENDING() 0
+
+/** Is the PROC_STATUS SPR supported? */
+#define CHIP_HAS_PROC_STATUS_SPR() 0
+
+/** Log of the number of mshims we have. */
+#define CHIP_LOG_NUM_MSHIMS() 2
+
+/** Are the bases of the interrupt vector areas fixed? */
+#define CHIP_HAS_FIXED_INTVEC_BASE() 1
+
+/** Are the interrupt masks split up into 2 SPRs? */
+#define CHIP_HAS_SPLIT_INTR_MASK() 1
+
+/** Is the cycle count split up into 2 SPRs? */
+#define CHIP_HAS_SPLIT_CYCLE() 1
+
+/** Does the chip have a static network? */
+#define CHIP_HAS_SN() 1
+
+/** Does the chip have a static network processor? */
+#define CHIP_HAS_SN_PROC() 1
+
+/** Size of the L1 static network processor instruction cache, in bytes. */
+#define CHIP_L1SNI_CACHE_SIZE() 2048
+
+/** Does the chip have DMA support in each tile? */
+#define CHIP_HAS_TILE_DMA() 1
+
+/** Does the chip have the second revision of the directly accessible
+ *  dynamic networks?  This encapsulates a number of characteristics,
+ *  including the absence of the catch-all, the absence of inline message
+ *  tags, the absence of support for network context-switching, and so on.
+ */
+#define CHIP_HAS_REV1_XDN() 0
+
+/** Does the chip have cmpexch and similar (fetchadd, exch, etc.)? */
+#define CHIP_HAS_CMPEXCH() 0
+
+/** Does the chip have memory-mapped I/O support? */
+#define CHIP_HAS_MMIO() 0
+
+/** Does the chip have post-completion interrupts? */
+#define CHIP_HAS_POST_COMPLETION_INTERRUPTS() 0
+
+/** Does the chip have native single step support? */
+#define CHIP_HAS_SINGLE_STEP() 0
+
+#ifndef __OPEN_SOURCE__  /* features only relevant to hypervisor-level code */
+
+/** How many entries are present in the instruction TLB? */
+#define CHIP_ITLB_ENTRIES() 8
+
+/** How many entries are present in the data TLB? */
+#define CHIP_DTLB_ENTRIES() 16
+
+/** How many MAF entries does the XAUI shim have? */
+#define CHIP_XAUI_MAF_ENTRIES() 16
+
+/** Does the memory shim have a source-id table? */
+#define CHIP_HAS_MSHIM_SRCID_TABLE() 1
+
+/** Does the L1 instruction cache clear on reset? */
+#define CHIP_HAS_L1I_CLEAR_ON_RESET() 0
+
+/** Does the chip come out of reset with valid coordinates on all tiles?
+ * Note that if defined, this also implies that the upper left is 1,1.
+ */
+#define CHIP_HAS_VALID_TILE_COORD_RESET() 0
+
+/** Does the chip have unified packet formats? */
+#define CHIP_HAS_UNIFIED_PACKET_FORMATS() 0
+
+/** Does the chip support write reordering? */
+#define CHIP_HAS_WRITE_REORDERING() 0
+
+/** Does the chip support Y-X routing as well as X-Y? */
+#define CHIP_HAS_Y_X_ROUTING() 0
+
+/** Is INTCTRL_3 managed with the correct MPL? */
+#define CHIP_HAS_INTCTRL_3_STATUS_FIX() 0
+
+/** Is it possible to configure the chip to be big-endian? */
+#define CHIP_HAS_BIG_ENDIAN_CONFIG() 0
+
+/** Is the CACHE_RED_WAY_OVERRIDDEN SPR supported? */
+#define CHIP_HAS_CACHE_RED_WAY_OVERRIDDEN() 0
+
+/** Is the DIAG_TRACE_WAY SPR supported? */
+#define CHIP_HAS_DIAG_TRACE_WAY() 0
+
+/** Is the MEM_STRIPE_CONFIG SPR supported? */
+#define CHIP_HAS_MEM_STRIPE_CONFIG() 0
+
+/** Are the TLB_PERF SPRs supported? */
+#define CHIP_HAS_TLB_PERF() 0
+
+/** Is the VDN_SNOOP_SHIM_CTL SPR supported? */
+#define CHIP_HAS_VDN_SNOOP_SHIM_CTL() 0
+
+/** Does the chip support rev1 DMA packets? */
+#define CHIP_HAS_REV1_DMA_PACKETS() 0
+
+#endif /* !__OPEN_SOURCE__ */
+#endif /* __ARCH_CHIP_H__ */
diff --git a/arch/tile/include/arch/chip_tilepro.h b/arch/tile/include/arch/chip_tilepro.h
new file mode 100644
index 0000000..9852af1
--- /dev/null
+++ b/arch/tile/include/arch/chip_tilepro.h
@@ -0,0 +1,252 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+/*
+ * @file
+ * Global header file.
+ * This header file specifies defines for TILEPro.
+ */
+
+#ifndef __ARCH_CHIP_H__
+#define __ARCH_CHIP_H__
+
+/** Specify chip version.
+ * When possible, prefer the CHIP_xxx symbols below for future-proofing.
+ * This is intended for cross-compiling; native compilation should
+ * use the predefined __tile_chip__ symbol.
+ */
+#define TILE_CHIP 1
+
+/** Specify chip revision.
+ * This provides for the case of a respin of a particular chip type;
+ * the normal value for this symbol is "0".
+ * This is intended for cross-compiling; native compilation should
+ * use the predefined __tile_chip_rev__ symbol.
+ */
+#define TILE_CHIP_REV 0
+
+/** The name of this architecture. */
+#define CHIP_ARCH_NAME "tilepro"
+
+/** The ELF e_machine type for binaries for this chip. */
+#define CHIP_ELF_TYPE() EM_TILEPRO
+
+/** The alternate ELF e_machine type for binaries for this chip. */
+#define CHIP_COMPAT_ELF_TYPE() 0x2507
+
+/** What is the native word size of the machine? */
+#define CHIP_WORD_SIZE() 32
+
+/** How many bits of a virtual address are used. Extra bits must be
+ * the sign extension of the low bits.
+ */
+#define CHIP_VA_WIDTH() 32
+
+/** How many bits are in a physical address? */
+#define CHIP_PA_WIDTH() 36
+
+/** Size of the L2 cache, in bytes. */
+#define CHIP_L2_CACHE_SIZE() 65536
+
+/** Log size of an L2 cache line in bytes. */
+#define CHIP_L2_LOG_LINE_SIZE() 6
+
+/** Size of an L2 cache line, in bytes. */
+#define CHIP_L2_LINE_SIZE() (1 << CHIP_L2_LOG_LINE_SIZE())
+
+/** Associativity of the L2 cache. */
+#define CHIP_L2_ASSOC() 4
+
+/** Size of the L1 data cache, in bytes. */
+#define CHIP_L1D_CACHE_SIZE() 8192
+
+/** Log size of an L1 data cache line in bytes. */
+#define CHIP_L1D_LOG_LINE_SIZE() 4
+
+/** Size of an L1 data cache line, in bytes. */
+#define CHIP_L1D_LINE_SIZE() (1 << CHIP_L1D_LOG_LINE_SIZE())
+
+/** Associativity of the L1 data cache. */
+#define CHIP_L1D_ASSOC() 2
+
+/** Size of the L1 instruction cache, in bytes. */
+#define CHIP_L1I_CACHE_SIZE() 16384
+
+/** Log size of an L1 instruction cache line in bytes. */
+#define CHIP_L1I_LOG_LINE_SIZE() 6
+
+/** Size of an L1 instruction cache line, in bytes. */
+#define CHIP_L1I_LINE_SIZE() (1 << CHIP_L1I_LOG_LINE_SIZE())
+
+/** Associativity of the L1 instruction cache. */
+#define CHIP_L1I_ASSOC() 1
+
+/** Stride with which flush instructions must be issued. */
+#define CHIP_FLUSH_STRIDE() CHIP_L2_LINE_SIZE()
+
+/** Stride with which inv instructions must be issued. */
+#define CHIP_INV_STRIDE() CHIP_L2_LINE_SIZE()
+
+/** Stride with which finv instructions must be issued. */
+#define CHIP_FINV_STRIDE() CHIP_L2_LINE_SIZE()
+
+/** Can the local cache coherently cache data that is homed elsewhere? */
+#define CHIP_HAS_COHERENT_LOCAL_CACHE() 1
+
+/** How many simultaneous outstanding victims can the L2 cache have? */
+#define CHIP_MAX_OUTSTANDING_VICTIMS() 4
+
+/** Does the TLB support the NC and NOALLOC bits? */
+#define CHIP_HAS_NC_AND_NOALLOC_BITS() 1
+
+/** Does the chip support hash-for-home caching? */
+#define CHIP_HAS_CBOX_HOME_MAP() 1
+
+/** Number of entries in the chip's home map tables. */
+#define CHIP_CBOX_HOME_MAP_SIZE() 64
+
+/** Do uncacheable requests miss in the cache regardless of whether
+ * there is matching data? */
+#define CHIP_HAS_ENFORCED_UNCACHEABLE_REQUESTS() 1
+
+/** Does the mf instruction wait for victims? */
+#define CHIP_HAS_MF_WAITS_FOR_VICTIMS() 0
+
+/** Does the chip have an "inv" instruction that doesn't also flush? */
+#define CHIP_HAS_INV() 1
+
+/** Does the chip have a "wh64" instruction? */
+#define CHIP_HAS_WH64() 1
+
+/** Does this chip have a 'dword_align' instruction? */
+#define CHIP_HAS_DWORD_ALIGN() 1
+
+/** Number of performance counters. */
+#define CHIP_PERFORMANCE_COUNTERS() 4
+
+/** Does this chip have auxiliary performance counters? */
+#define CHIP_HAS_AUX_PERF_COUNTERS() 1
+
+/** Is the CBOX_MSR1 SPR supported? */
+#define CHIP_HAS_CBOX_MSR1() 1
+
+/** Is the TILE_RTF_HWM SPR supported? */
+#define CHIP_HAS_TILE_RTF_HWM() 1
+
+/** Is the TILE_WRITE_PENDING SPR supported? */
+#define CHIP_HAS_TILE_WRITE_PENDING() 1
+
+/** Is the PROC_STATUS SPR supported? */
+#define CHIP_HAS_PROC_STATUS_SPR() 1
+
+/** Log of the number of mshims we have. */
+#define CHIP_LOG_NUM_MSHIMS() 2
+
+/** Are the bases of the interrupt vector areas fixed? */
+#define CHIP_HAS_FIXED_INTVEC_BASE() 1
+
+/** Are the interrupt masks split up into 2 SPRs? */
+#define CHIP_HAS_SPLIT_INTR_MASK() 1
+
+/** Is the cycle count split up into 2 SPRs? */
+#define CHIP_HAS_SPLIT_CYCLE() 1
+
+/** Does the chip have a static network? */
+#define CHIP_HAS_SN() 1
+
+/** Does the chip have a static network processor? */
+#define CHIP_HAS_SN_PROC() 0
+
+/** Size of the L1 static network processor instruction cache, in bytes. */
+/* #define CHIP_L1SNI_CACHE_SIZE() -- does not apply to chip 1 */
+
+/** Does the chip have DMA support in each tile? */
+#define CHIP_HAS_TILE_DMA() 1
+
+/** Does the chip have the second revision of the directly accessible
+ *  dynamic networks?  This encapsulates a number of characteristics,
+ *  including the absence of the catch-all, the absence of inline message
+ *  tags, the absence of support for network context-switching, and so on.
+ */
+#define CHIP_HAS_REV1_XDN() 0
+
+/** Does the chip have cmpexch and similar (fetchadd, exch, etc.)? */
+#define CHIP_HAS_CMPEXCH() 0
+
+/** Does the chip have memory-mapped I/O support? */
+#define CHIP_HAS_MMIO() 0
+
+/** Does the chip have post-completion interrupts? */
+#define CHIP_HAS_POST_COMPLETION_INTERRUPTS() 0
+
+/** Does the chip have native single step support? */
+#define CHIP_HAS_SINGLE_STEP() 0
+
+#ifndef __OPEN_SOURCE__  /* features only relevant to hypervisor-level code */
+
+/** How many entries are present in the instruction TLB? */
+#define CHIP_ITLB_ENTRIES() 16
+
+/** How many entries are present in the data TLB? */
+#define CHIP_DTLB_ENTRIES() 16
+
+/** How many MAF entries does the XAUI shim have? */
+#define CHIP_XAUI_MAF_ENTRIES() 32
+
+/** Does the memory shim have a source-id table? */
+#define CHIP_HAS_MSHIM_SRCID_TABLE() 0
+
+/** Does the L1 instruction cache clear on reset? */
+#define CHIP_HAS_L1I_CLEAR_ON_RESET() 1
+
+/** Does the chip come out of reset with valid coordinates on all tiles?
+ * Note that if defined, this also implies that the upper left is 1,1.
+ */
+#define CHIP_HAS_VALID_TILE_COORD_RESET() 1
+
+/** Does the chip have unified packet formats? */
+#define CHIP_HAS_UNIFIED_PACKET_FORMATS() 1
+
+/** Does the chip support write reordering? */
+#define CHIP_HAS_WRITE_REORDERING() 1
+
+/** Does the chip support Y-X routing as well as X-Y? */
+#define CHIP_HAS_Y_X_ROUTING() 1
+
+/** Is INTCTRL_3 managed with the correct MPL? */
+#define CHIP_HAS_INTCTRL_3_STATUS_FIX() 1
+
+/** Is it possible to configure the chip to be big-endian? */
+#define CHIP_HAS_BIG_ENDIAN_CONFIG() 1
+
+/** Is the CACHE_RED_WAY_OVERRIDDEN SPR supported? */
+#define CHIP_HAS_CACHE_RED_WAY_OVERRIDDEN() 1
+
+/** Is the DIAG_TRACE_WAY SPR supported? */
+#define CHIP_HAS_DIAG_TRACE_WAY() 1
+
+/** Is the MEM_STRIPE_CONFIG SPR supported? */
+#define CHIP_HAS_MEM_STRIPE_CONFIG() 1
+
+/** Are the TLB_PERF SPRs supported? */
+#define CHIP_HAS_TLB_PERF() 1
+
+/** Is the VDN_SNOOP_SHIM_CTL SPR supported? */
+#define CHIP_HAS_VDN_SNOOP_SHIM_CTL() 1
+
+/** Does the chip support rev1 DMA packets? */
+#define CHIP_HAS_REV1_DMA_PACKETS() 1
+
+#endif /* !__OPEN_SOURCE__ */
+#endif /* __ARCH_CHIP_H__ */
diff --git a/arch/tile/include/arch/interrupts.h b/arch/tile/include/arch/interrupts.h
new file mode 100644
index 0000000..20f8f07
--- /dev/null
+++ b/arch/tile/include/arch/interrupts.h
@@ -0,0 +1,19 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifdef __tilegx__
+#include <arch/interrupts_64.h>
+#else
+#include <arch/interrupts_32.h>
+#endif
diff --git a/arch/tile/include/arch/interrupts_32.h b/arch/tile/include/arch/interrupts_32.h
new file mode 100644
index 0000000..feffada
--- /dev/null
+++ b/arch/tile/include/arch/interrupts_32.h
@@ -0,0 +1,304 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef __ARCH_INTERRUPTS_H__
+#define __ARCH_INTERRUPTS_H__
+
+/** Mask for an interrupt. */
+#ifdef __ASSEMBLER__
+/* Note: must handle breaking interrupts into high and low words manually. */
+#define INT_MASK(intno) (1 << (intno))
+#else
+#define INT_MASK(intno) (1ULL << (intno))
+#endif
+
+
+/** Where a given interrupt executes */
+#define INTERRUPT_VECTOR(i, pl) (0xFC000000 + ((pl) << 24) + ((i) << 8))
+
+/** Where to store a vector for a given interrupt. */
+#define USER_INTERRUPT_VECTOR(i) INTERRUPT_VECTOR(i, 0)
+
+/** The base address of user-level interrupts. */
+#define USER_INTERRUPT_VECTOR_BASE INTERRUPT_VECTOR(0, 0)
+
+
+/** Additional synthetic interrupt. */
+#define INT_BREAKPOINT (63)
+
+#define INT_ITLB_MISS    0
+#define INT_MEM_ERROR    1
+#define INT_ILL    2
+#define INT_GPV    3
+#define INT_SN_ACCESS    4
+#define INT_IDN_ACCESS    5
+#define INT_UDN_ACCESS    6
+#define INT_IDN_REFILL    7
+#define INT_UDN_REFILL    8
+#define INT_IDN_COMPLETE    9
+#define INT_UDN_COMPLETE   10
+#define INT_SWINT_3   11
+#define INT_SWINT_2   12
+#define INT_SWINT_1   13
+#define INT_SWINT_0   14
+#define INT_UNALIGN_DATA   15
+#define INT_DTLB_MISS   16
+#define INT_DTLB_ACCESS   17
+#define INT_DMATLB_MISS   18
+#define INT_DMATLB_ACCESS   19
+#define INT_SNITLB_MISS   20
+#define INT_SN_NOTIFY   21
+#define INT_SN_FIREWALL   22
+#define INT_IDN_FIREWALL   23
+#define INT_UDN_FIREWALL   24
+#define INT_TILE_TIMER   25
+#define INT_IDN_TIMER   26
+#define INT_UDN_TIMER   27
+#define INT_DMA_NOTIFY   28
+#define INT_IDN_CA   29
+#define INT_UDN_CA   30
+#define INT_IDN_AVAIL   31
+#define INT_UDN_AVAIL   32
+#define INT_PERF_COUNT   33
+#define INT_INTCTRL_3   34
+#define INT_INTCTRL_2   35
+#define INT_INTCTRL_1   36
+#define INT_INTCTRL_0   37
+#define INT_BOOT_ACCESS   38
+#define INT_WORLD_ACCESS   39
+#define INT_I_ASID   40
+#define INT_D_ASID   41
+#define INT_DMA_ASID   42
+#define INT_SNI_ASID   43
+#define INT_DMA_CPL   44
+#define INT_SN_CPL   45
+#define INT_DOUBLE_FAULT   46
+#define INT_SN_STATIC_ACCESS   47
+#define INT_AUX_PERF_COUNT   48
+
+#define NUM_INTERRUPTS 49
+
+#define QUEUED_INTERRUPTS ( \
+    INT_MASK(INT_MEM_ERROR) | \
+    INT_MASK(INT_DMATLB_MISS) | \
+    INT_MASK(INT_DMATLB_ACCESS) | \
+    INT_MASK(INT_SNITLB_MISS) | \
+    INT_MASK(INT_SN_NOTIFY) | \
+    INT_MASK(INT_SN_FIREWALL) | \
+    INT_MASK(INT_IDN_FIREWALL) | \
+    INT_MASK(INT_UDN_FIREWALL) | \
+    INT_MASK(INT_TILE_TIMER) | \
+    INT_MASK(INT_IDN_TIMER) | \
+    INT_MASK(INT_UDN_TIMER) | \
+    INT_MASK(INT_DMA_NOTIFY) | \
+    INT_MASK(INT_IDN_CA) | \
+    INT_MASK(INT_UDN_CA) | \
+    INT_MASK(INT_IDN_AVAIL) | \
+    INT_MASK(INT_UDN_AVAIL) | \
+    INT_MASK(INT_PERF_COUNT) | \
+    INT_MASK(INT_INTCTRL_3) | \
+    INT_MASK(INT_INTCTRL_2) | \
+    INT_MASK(INT_INTCTRL_1) | \
+    INT_MASK(INT_INTCTRL_0) | \
+    INT_MASK(INT_BOOT_ACCESS) | \
+    INT_MASK(INT_WORLD_ACCESS) | \
+    INT_MASK(INT_I_ASID) | \
+    INT_MASK(INT_D_ASID) | \
+    INT_MASK(INT_DMA_ASID) | \
+    INT_MASK(INT_SNI_ASID) | \
+    INT_MASK(INT_DMA_CPL) | \
+    INT_MASK(INT_SN_CPL) | \
+    INT_MASK(INT_DOUBLE_FAULT) | \
+    INT_MASK(INT_AUX_PERF_COUNT) | \
+    0)
+#define NONQUEUED_INTERRUPTS ( \
+    INT_MASK(INT_ITLB_MISS) | \
+    INT_MASK(INT_ILL) | \
+    INT_MASK(INT_GPV) | \
+    INT_MASK(INT_SN_ACCESS) | \
+    INT_MASK(INT_IDN_ACCESS) | \
+    INT_MASK(INT_UDN_ACCESS) | \
+    INT_MASK(INT_IDN_REFILL) | \
+    INT_MASK(INT_UDN_REFILL) | \
+    INT_MASK(INT_IDN_COMPLETE) | \
+    INT_MASK(INT_UDN_COMPLETE) | \
+    INT_MASK(INT_SWINT_3) | \
+    INT_MASK(INT_SWINT_2) | \
+    INT_MASK(INT_SWINT_1) | \
+    INT_MASK(INT_SWINT_0) | \
+    INT_MASK(INT_UNALIGN_DATA) | \
+    INT_MASK(INT_DTLB_MISS) | \
+    INT_MASK(INT_DTLB_ACCESS) | \
+    INT_MASK(INT_SN_STATIC_ACCESS) | \
+    0)
+#define CRITICAL_MASKED_INTERRUPTS ( \
+    INT_MASK(INT_MEM_ERROR) | \
+    INT_MASK(INT_DMATLB_MISS) | \
+    INT_MASK(INT_DMATLB_ACCESS) | \
+    INT_MASK(INT_SNITLB_MISS) | \
+    INT_MASK(INT_SN_NOTIFY) | \
+    INT_MASK(INT_SN_FIREWALL) | \
+    INT_MASK(INT_IDN_FIREWALL) | \
+    INT_MASK(INT_UDN_FIREWALL) | \
+    INT_MASK(INT_TILE_TIMER) | \
+    INT_MASK(INT_IDN_TIMER) | \
+    INT_MASK(INT_UDN_TIMER) | \
+    INT_MASK(INT_DMA_NOTIFY) | \
+    INT_MASK(INT_IDN_CA) | \
+    INT_MASK(INT_UDN_CA) | \
+    INT_MASK(INT_IDN_AVAIL) | \
+    INT_MASK(INT_UDN_AVAIL) | \
+    INT_MASK(INT_PERF_COUNT) | \
+    INT_MASK(INT_INTCTRL_3) | \
+    INT_MASK(INT_INTCTRL_2) | \
+    INT_MASK(INT_INTCTRL_1) | \
+    INT_MASK(INT_INTCTRL_0) | \
+    INT_MASK(INT_AUX_PERF_COUNT) | \
+    0)
+#define CRITICAL_UNMASKED_INTERRUPTS ( \
+    INT_MASK(INT_ITLB_MISS) | \
+    INT_MASK(INT_ILL) | \
+    INT_MASK(INT_GPV) | \
+    INT_MASK(INT_SN_ACCESS) | \
+    INT_MASK(INT_IDN_ACCESS) | \
+    INT_MASK(INT_UDN_ACCESS) | \
+    INT_MASK(INT_IDN_REFILL) | \
+    INT_MASK(INT_UDN_REFILL) | \
+    INT_MASK(INT_IDN_COMPLETE) | \
+    INT_MASK(INT_UDN_COMPLETE) | \
+    INT_MASK(INT_SWINT_3) | \
+    INT_MASK(INT_SWINT_2) | \
+    INT_MASK(INT_SWINT_1) | \
+    INT_MASK(INT_SWINT_0) | \
+    INT_MASK(INT_UNALIGN_DATA) | \
+    INT_MASK(INT_DTLB_MISS) | \
+    INT_MASK(INT_DTLB_ACCESS) | \
+    INT_MASK(INT_BOOT_ACCESS) | \
+    INT_MASK(INT_WORLD_ACCESS) | \
+    INT_MASK(INT_I_ASID) | \
+    INT_MASK(INT_D_ASID) | \
+    INT_MASK(INT_DMA_ASID) | \
+    INT_MASK(INT_SNI_ASID) | \
+    INT_MASK(INT_DMA_CPL) | \
+    INT_MASK(INT_SN_CPL) | \
+    INT_MASK(INT_DOUBLE_FAULT) | \
+    INT_MASK(INT_SN_STATIC_ACCESS) | \
+    0)
+#define MASKABLE_INTERRUPTS ( \
+    INT_MASK(INT_MEM_ERROR) | \
+    INT_MASK(INT_IDN_REFILL) | \
+    INT_MASK(INT_UDN_REFILL) | \
+    INT_MASK(INT_IDN_COMPLETE) | \
+    INT_MASK(INT_UDN_COMPLETE) | \
+    INT_MASK(INT_DMATLB_MISS) | \
+    INT_MASK(INT_DMATLB_ACCESS) | \
+    INT_MASK(INT_SNITLB_MISS) | \
+    INT_MASK(INT_SN_NOTIFY) | \
+    INT_MASK(INT_SN_FIREWALL) | \
+    INT_MASK(INT_IDN_FIREWALL) | \
+    INT_MASK(INT_UDN_FIREWALL) | \
+    INT_MASK(INT_TILE_TIMER) | \
+    INT_MASK(INT_IDN_TIMER) | \
+    INT_MASK(INT_UDN_TIMER) | \
+    INT_MASK(INT_DMA_NOTIFY) | \
+    INT_MASK(INT_IDN_CA) | \
+    INT_MASK(INT_UDN_CA) | \
+    INT_MASK(INT_IDN_AVAIL) | \
+    INT_MASK(INT_UDN_AVAIL) | \
+    INT_MASK(INT_PERF_COUNT) | \
+    INT_MASK(INT_INTCTRL_3) | \
+    INT_MASK(INT_INTCTRL_2) | \
+    INT_MASK(INT_INTCTRL_1) | \
+    INT_MASK(INT_INTCTRL_0) | \
+    INT_MASK(INT_AUX_PERF_COUNT) | \
+    0)
+#define UNMASKABLE_INTERRUPTS ( \
+    INT_MASK(INT_ITLB_MISS) | \
+    INT_MASK(INT_ILL) | \
+    INT_MASK(INT_GPV) | \
+    INT_MASK(INT_SN_ACCESS) | \
+    INT_MASK(INT_IDN_ACCESS) | \
+    INT_MASK(INT_UDN_ACCESS) | \
+    INT_MASK(INT_SWINT_3) | \
+    INT_MASK(INT_SWINT_2) | \
+    INT_MASK(INT_SWINT_1) | \
+    INT_MASK(INT_SWINT_0) | \
+    INT_MASK(INT_UNALIGN_DATA) | \
+    INT_MASK(INT_DTLB_MISS) | \
+    INT_MASK(INT_DTLB_ACCESS) | \
+    INT_MASK(INT_BOOT_ACCESS) | \
+    INT_MASK(INT_WORLD_ACCESS) | \
+    INT_MASK(INT_I_ASID) | \
+    INT_MASK(INT_D_ASID) | \
+    INT_MASK(INT_DMA_ASID) | \
+    INT_MASK(INT_SNI_ASID) | \
+    INT_MASK(INT_DMA_CPL) | \
+    INT_MASK(INT_SN_CPL) | \
+    INT_MASK(INT_DOUBLE_FAULT) | \
+    INT_MASK(INT_SN_STATIC_ACCESS) | \
+    0)
+#define SYNC_INTERRUPTS ( \
+    INT_MASK(INT_ITLB_MISS) | \
+    INT_MASK(INT_ILL) | \
+    INT_MASK(INT_GPV) | \
+    INT_MASK(INT_SN_ACCESS) | \
+    INT_MASK(INT_IDN_ACCESS) | \
+    INT_MASK(INT_UDN_ACCESS) | \
+    INT_MASK(INT_IDN_REFILL) | \
+    INT_MASK(INT_UDN_REFILL) | \
+    INT_MASK(INT_IDN_COMPLETE) | \
+    INT_MASK(INT_UDN_COMPLETE) | \
+    INT_MASK(INT_SWINT_3) | \
+    INT_MASK(INT_SWINT_2) | \
+    INT_MASK(INT_SWINT_1) | \
+    INT_MASK(INT_SWINT_0) | \
+    INT_MASK(INT_UNALIGN_DATA) | \
+    INT_MASK(INT_DTLB_MISS) | \
+    INT_MASK(INT_DTLB_ACCESS) | \
+    INT_MASK(INT_SN_STATIC_ACCESS) | \
+    0)
+#define NON_SYNC_INTERRUPTS ( \
+    INT_MASK(INT_MEM_ERROR) | \
+    INT_MASK(INT_DMATLB_MISS) | \
+    INT_MASK(INT_DMATLB_ACCESS) | \
+    INT_MASK(INT_SNITLB_MISS) | \
+    INT_MASK(INT_SN_NOTIFY) | \
+    INT_MASK(INT_SN_FIREWALL) | \
+    INT_MASK(INT_IDN_FIREWALL) | \
+    INT_MASK(INT_UDN_FIREWALL) | \
+    INT_MASK(INT_TILE_TIMER) | \
+    INT_MASK(INT_IDN_TIMER) | \
+    INT_MASK(INT_UDN_TIMER) | \
+    INT_MASK(INT_DMA_NOTIFY) | \
+    INT_MASK(INT_IDN_CA) | \
+    INT_MASK(INT_UDN_CA) | \
+    INT_MASK(INT_IDN_AVAIL) | \
+    INT_MASK(INT_UDN_AVAIL) | \
+    INT_MASK(INT_PERF_COUNT) | \
+    INT_MASK(INT_INTCTRL_3) | \
+    INT_MASK(INT_INTCTRL_2) | \
+    INT_MASK(INT_INTCTRL_1) | \
+    INT_MASK(INT_INTCTRL_0) | \
+    INT_MASK(INT_BOOT_ACCESS) | \
+    INT_MASK(INT_WORLD_ACCESS) | \
+    INT_MASK(INT_I_ASID) | \
+    INT_MASK(INT_D_ASID) | \
+    INT_MASK(INT_DMA_ASID) | \
+    INT_MASK(INT_SNI_ASID) | \
+    INT_MASK(INT_DMA_CPL) | \
+    INT_MASK(INT_SN_CPL) | \
+    INT_MASK(INT_DOUBLE_FAULT) | \
+    INT_MASK(INT_AUX_PERF_COUNT) | \
+    0)
+#endif // !__ARCH_INTERRUPTS_H__
diff --git a/arch/tile/include/arch/sim_def.h b/arch/tile/include/arch/sim_def.h
new file mode 100644
index 0000000..6418fbd
--- /dev/null
+++ b/arch/tile/include/arch/sim_def.h
@@ -0,0 +1,512 @@
+// Copyright 2010 Tilera Corporation. All Rights Reserved.
+//
+//   This program is free software; you can redistribute it and/or
+//   modify it under the terms of the GNU General Public License
+//   as published by the Free Software Foundation, version 2.
+//
+//   This program is distributed in the hope that it will be useful, but
+//   WITHOUT ANY WARRANTY; without even the implied warranty of
+//   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+//   NON INFRINGEMENT.  See the GNU General Public License for
+//   more details.
+
+//! @file
+//!
+//! Some low-level simulator definitions.
+//!
+
+#ifndef __ARCH_SIM_DEF_H__
+#define __ARCH_SIM_DEF_H__
+
+
+//! Internal: the low bits of the SIM_CONTROL_* SPR values specify
+//! the operation to perform, and the remaining bits are
+//! an operation-specific parameter (often unused).
+//!
+#define _SIM_CONTROL_OPERATOR_BITS 8
+
+
+//== Values which can be written to SPR_SIM_CONTROL.
+
+//! If written to SPR_SIM_CONTROL, stops profiling.
+//!
+#define SIM_CONTROL_PROFILER_DISABLE 0
+
+//! If written to SPR_SIM_CONTROL, starts profiling.
+//!
+#define SIM_CONTROL_PROFILER_ENABLE 1
+
+//! If written to SPR_SIM_CONTROL, clears profiling counters.
+//!
+#define SIM_CONTROL_PROFILER_CLEAR 2
+
+//! If written to SPR_SIM_CONTROL, checkpoints the simulator.
+//!
+#define SIM_CONTROL_CHECKPOINT 3
+
+//! If written to SPR_SIM_CONTROL, combined with a mask (shifted by 8),
+//! sets the tracing mask to the given mask. See "sim_set_tracing()".
+//!
+#define SIM_CONTROL_SET_TRACING 4
+
+//! If written to SPR_SIM_CONTROL, combined with a mask (shifted by 8),
+//! dumps the requested items of machine state to the log.
+//!
+#define SIM_CONTROL_DUMP 5
+
+//! If written to SPR_SIM_CONTROL, clears chip-level profiling counters.
+//!
+#define SIM_CONTROL_PROFILER_CHIP_CLEAR 6
+
+//! If written to SPR_SIM_CONTROL, disables chip-level profiling.
+//!
+#define SIM_CONTROL_PROFILER_CHIP_DISABLE 7
+
+//! If written to SPR_SIM_CONTROL, enables chip-level profiling.
+//!
+#define SIM_CONTROL_PROFILER_CHIP_ENABLE 8
+
+//! If written to SPR_SIM_CONTROL, enables chip-level functional mode
+//!
+#define SIM_CONTROL_ENABLE_FUNCTIONAL 9
+
+//! If written to SPR_SIM_CONTROL, disables chip-level functional mode.
+//!
+#define SIM_CONTROL_DISABLE_FUNCTIONAL 10
+
+//! If written to SPR_SIM_CONTROL, enables chip-level functional mode.
+//! All tiles must perform this write for functional mode to be enabled.
+//! Ignored in naked boot mode unless --functional is specified.
+//! WARNING: Only the hypervisor startup code should use this!
+//!
+#define SIM_CONTROL_ENABLE_FUNCTIONAL_BARRIER 11
+
+//! If written to SPR_SIM_CONTROL, combined with a character (shifted by 8),
+//! writes a string directly to the simulator output.  Written to once for
+//! each character in the string, plus a final NUL.  Instead of NUL,
+//! you can also use "SIM_PUTC_FLUSH_STRING" or "SIM_PUTC_FLUSH_BINARY".
+//!
+// ISSUE: Document the meaning of "newline", and the handling of NUL.
+//
+#define SIM_CONTROL_PUTC 12
+
+//! If written to SPR_SIM_CONTROL, clears the --grind-coherence state for
+//! this core.  This is intended to be used before a loop that will
+//! invalidate the cache by loading new data and evicting all current data.
+//! Generally speaking, this API should only be used by system code.
+//!
+#define SIM_CONTROL_GRINDER_CLEAR 13
+
+//! If written to SPR_SIM_CONTROL, shuts down the simulator.
+//!
+#define SIM_CONTROL_SHUTDOWN 14
+
+//! If written to SPR_SIM_CONTROL, combined with a pid (shifted by 8),
+//! indicates that a fork syscall just created the given process.
+//!
+#define SIM_CONTROL_OS_FORK 15
+
+//! If written to SPR_SIM_CONTROL, combined with a pid (shifted by 8),
+//! indicates that an exit syscall was just executed by the given process.
+//!
+#define SIM_CONTROL_OS_EXIT 16
+
+//! If written to SPR_SIM_CONTROL, combined with a pid (shifted by 8),
+//! indicates that the OS just switched to the given process.
+//!
+#define SIM_CONTROL_OS_SWITCH 17
+
+//! If written to SPR_SIM_CONTROL, combined with a character (shifted by 8),
+//! indicates that an exec syscall was just executed. Written to once for
+//! each character in the executable name, plus a final NUL.
+//!
+#define SIM_CONTROL_OS_EXEC 18
+
+//! If written to SPR_SIM_CONTROL, combined with a character (shifted by 8),
+//! indicates that an interpreter (PT_INTERP) was loaded.  Written to once
+//! for each character in "ADDR:PATH", plus a final NUL, where "ADDR" is a
+//! hex load address starting with "0x", and "PATH" is the executable name.
+//!
+#define SIM_CONTROL_OS_INTERP 19
+
+//! If written to SPR_SIM_CONTROL, combined with a character (shifted by 8),
+//! indicates that a dll was loaded.  Written to once for each character
+//! in "ADDR:PATH", plus a final NUL, where "ADDR" is a hexadecimal load
+//! address starting with "0x", and "PATH" is the executable name.
+//!
+#define SIM_CONTROL_DLOPEN 20
+
+//! If written to SPR_SIM_CONTROL, combined with a character (shifted by 8),
+//! indicates that a dll was unloaded.  Written to once for each character
+//! in "ADDR", plus a final NUL, where "ADDR" is a hexadecimal load
+//! address starting with "0x".
+//!
+#define SIM_CONTROL_DLCLOSE 21
+
+//! If written to SPR_SIM_CONTROL, combined with a flag (shifted by 8),
+//! indicates whether to allow data reads to remotely-cached
+//! dirty cache lines to be cached locally without grinder warnings or
+//! assertions (used by Linux kernel fast memcpy).
+//!
+#define SIM_CONTROL_ALLOW_MULTIPLE_CACHING 22
+
+//! If written to SPR_SIM_CONTROL, enables memory tracing.
+//!
+#define SIM_CONTROL_ENABLE_MEM_LOGGING 23
+
+//! If written to SPR_SIM_CONTROL, disables memory tracing.
+//!
+#define SIM_CONTROL_DISABLE_MEM_LOGGING 24
+
+//! If written to SPR_SIM_CONTROL, changes the shaping parameters of one of
+//! the gbe or xgbe shims. Must specify the shim id, the type, the units, and
+//! the rate, as defined in SIM_SHAPING_SPR_ARG.
+//!
+#define SIM_CONTROL_SHAPING 25
+
+//! If written to SPR_SIM_CONTROL, combined with character (shifted by 8),
+//! requests that a simulator command be executed.  Written to once for each
+//! character in the command, plus a final NUL.
+//!
+#define SIM_CONTROL_COMMAND 26
+
+//! If written to SPR_SIM_CONTROL, indicates that the simulated system
+//! is panicking, to allow debugging via --debug-on-panic.
+//!
+#define SIM_CONTROL_PANIC 27
+
+//! If written to SPR_SIM_CONTROL, triggers a simulator syscall.
+//! See "sim_syscall()" for more info.
+//!
+#define SIM_CONTROL_SYSCALL 32
+
+//! If written to SPR_SIM_CONTROL, combined with a pid (shifted by 8),
+//! provides the pid that subsequent SIM_CONTROL_OS_FORK writes should
+//! use as the pid, rather than the default previous SIM_CONTROL_OS_SWITCH.
+//!
+#define SIM_CONTROL_OS_FORK_PARENT 33
+
+//! If written to SPR_SIM_CONTROL, combined with a mPIPE shim number
+//! (shifted by 8), clears the pending magic data section.  The cleared
+//! pending magic data section and any subsequently appended magic bytes
+//! will only take effect when the classifier blast programmer is run.
+#define SIM_CONTROL_CLEAR_MPIPE_MAGIC_BYTES 34
+
+//! If written to SPR_SIM_CONTROL, combined with a mPIPE shim number
+//! (shifted by 8) and a byte of data (shifted by 16), appends that byte
+//! to the shim's pending magic data section.  The pending magic data
+//! section takes effect when the classifier blast programmer is run.
+#define SIM_CONTROL_APPEND_MPIPE_MAGIC_BYTE 35
+
+//! If written to SPR_SIM_CONTROL, combined with a mPIPE shim number
+//! (shifted by 8), an enable=1/disable=0 bit (shifted by 16), and a
+//! mask of links (shifted by 32), enable or disable the corresponding
+//! mPIPE links.
+#define SIM_CONTROL_ENABLE_MPIPE_LINK_MAGIC_BYTE 36
+
+//== Syscall numbers for use with "sim_syscall()".
+
+//! Syscall number for sim_add_watchpoint().
+//!
+#define SIM_SYSCALL_ADD_WATCHPOINT 2
+
+//! Syscall number for sim_remove_watchpoint().
+//!
+#define SIM_SYSCALL_REMOVE_WATCHPOINT 3
+
+//! Syscall number for sim_query_watchpoint().
+//!
+#define SIM_SYSCALL_QUERY_WATCHPOINT 4
+
+//! Syscall number that asserts that the cache lines whose 64-bit PA
+//! is passed as the second argument to sim_syscall(), and over a
+//! range passed as the third argument, are no longer in cache.
+//! The simulator raises an error if this is not the case.
+//!
+#define SIM_SYSCALL_VALIDATE_LINES_EVICTED 5
+
+
+//== Bit masks which can be shifted by 8, combined with
+//== SIM_CONTROL_SET_TRACING, and written to SPR_SIM_CONTROL.
+
+//! @addtogroup arch_sim
+//! @{
+
+//! Enable --trace-cycle when passed to simulator_set_tracing().
+//!
+#define SIM_TRACE_CYCLES          0x01
+
+//! Enable --trace-router when passed to simulator_set_tracing().
+//!
+#define SIM_TRACE_ROUTER          0x02
+
+//! Enable --trace-register-writes when passed to simulator_set_tracing().
+//!
+#define SIM_TRACE_REGISTER_WRITES 0x04
+
+//! Enable --trace-disasm when passed to simulator_set_tracing().
+//!
+#define SIM_TRACE_DISASM          0x08
+
+//! Enable --trace-stall-info when passed to simulator_set_tracing().
+//!
+#define SIM_TRACE_STALL_INFO      0x10
+
+//! Enable --trace-memory-controller when passed to simulator_set_tracing().
+//!
+#define SIM_TRACE_MEMORY_CONTROLLER 0x20
+
+//! Enable --trace-l2 when passed to simulator_set_tracing().
+//!
+#define SIM_TRACE_L2_CACHE 0x40
+
+//! Enable --trace-lines when passed to simulator_set_tracing().
+//!
+#define SIM_TRACE_LINES 0x80
+
+//! Turn off all tracing when passed to simulator_set_tracing().
+//!
+#define SIM_TRACE_NONE 0
+
+//! Turn on all tracing when passed to simulator_set_tracing().
+//!
+#define SIM_TRACE_ALL (-1)
+
+//! @}
+
+//! Computes the value to write to SPR_SIM_CONTROL to set tracing flags.
+//!
+#define SIM_TRACE_SPR_ARG(mask) \
+  (SIM_CONTROL_SET_TRACING | ((mask) << _SIM_CONTROL_OPERATOR_BITS))
+
+
+//== Bit masks which can be shifted by 8, combined with
+//== SIM_CONTROL_DUMP, and written to SPR_SIM_CONTROL.
+
+//! @addtogroup arch_sim
+//! @{
+
+//! Dump the general-purpose registers.
+//!
+#define SIM_DUMP_REGS          0x001
+
+//! Dump the SPRs.
+//!
+#define SIM_DUMP_SPRS          0x002
+
+//! Dump the ITLB.
+//!
+#define SIM_DUMP_ITLB          0x004
+
+//! Dump the DTLB.
+//!
+#define SIM_DUMP_DTLB          0x008
+
+//! Dump the L1 I-cache.
+//!
+#define SIM_DUMP_L1I           0x010
+
+//! Dump the L1 D-cache.
+//!
+#define SIM_DUMP_L1D           0x020
+
+//! Dump the L2 cache.
+//!
+#define SIM_DUMP_L2            0x040
+
+//! Dump the switch registers.
+//!
+#define SIM_DUMP_SNREGS        0x080
+
+//! Dump the switch ITLB.
+//!
+#define SIM_DUMP_SNITLB        0x100
+
+//! Dump the switch L1 I-cache.
+//!
+#define SIM_DUMP_SNL1I         0x200
+
+//! Dump the current backtrace.
+//!
+#define SIM_DUMP_BACKTRACE     0x400
+
+//! Only dump valid lines in caches.
+//!
+#define SIM_DUMP_VALID_LINES   0x800
+
+//! Dump everything that is dumpable.
+//!
+#define SIM_DUMP_ALL (-1 & ~SIM_DUMP_VALID_LINES)
+
+// @}
+
+//! Computes the value to write to SPR_SIM_CONTROL to dump machine state.
+//!
+#define SIM_DUMP_SPR_ARG(mask) \
+  (SIM_CONTROL_DUMP | ((mask) << _SIM_CONTROL_OPERATOR_BITS))
+
+
+//== Bit masks which can be shifted by 8, combined with
+//== SIM_CONTROL_PROFILER_CHIP_xxx, and written to SPR_SIM_CONTROL.
+
+//! @addtogroup arch_sim
+//! @{
+
+//! Use with with SIM_PROFILER_CHIP_xxx to control the memory controllers.
+//!
+#define SIM_CHIP_MEMCTL        0x001
+
+//! Use with with SIM_PROFILER_CHIP_xxx to control the XAUI interface.
+//!
+#define SIM_CHIP_XAUI          0x002
+
+//! Use with with SIM_PROFILER_CHIP_xxx to control the PCIe interface.
+//!
+#define SIM_CHIP_PCIE          0x004
+
+//! Use with with SIM_PROFILER_CHIP_xxx to control the MPIPE interface.
+//!
+#define SIM_CHIP_MPIPE         0x008
+
+//! Reference all chip devices.
+//!
+#define SIM_CHIP_ALL (-1)
+
+//! @}
+
+//! Computes the value to write to SPR_SIM_CONTROL to clear chip statistics.
+//!
+#define SIM_PROFILER_CHIP_CLEAR_SPR_ARG(mask) \
+  (SIM_CONTROL_PROFILER_CHIP_CLEAR | ((mask) << _SIM_CONTROL_OPERATOR_BITS))
+
+//! Computes the value to write to SPR_SIM_CONTROL to disable chip statistics.
+//!
+#define SIM_PROFILER_CHIP_DISABLE_SPR_ARG(mask) \
+  (SIM_CONTROL_PROFILER_CHIP_DISABLE | ((mask) << _SIM_CONTROL_OPERATOR_BITS))
+
+//! Computes the value to write to SPR_SIM_CONTROL to enable chip statistics.
+//!
+#define SIM_PROFILER_CHIP_ENABLE_SPR_ARG(mask) \
+  (SIM_CONTROL_PROFILER_CHIP_ENABLE | ((mask) << _SIM_CONTROL_OPERATOR_BITS))
+
+
+
+// Shim bitrate controls.
+
+//! The number of bits used to store the shim id.
+//!
+#define SIM_CONTROL_SHAPING_SHIM_ID_BITS 3
+
+//! @addtogroup arch_sim
+//! @{
+
+//! Change the gbe 0 bitrate.
+//!
+#define SIM_CONTROL_SHAPING_GBE_0 0x0
+
+//! Change the gbe 1 bitrate.
+//!
+#define SIM_CONTROL_SHAPING_GBE_1 0x1
+
+//! Change the gbe 2 bitrate.
+//!
+#define SIM_CONTROL_SHAPING_GBE_2 0x2
+
+//! Change the gbe 3 bitrate.
+//!
+#define SIM_CONTROL_SHAPING_GBE_3 0x3
+
+//! Change the xgbe 0 bitrate.
+//!
+#define SIM_CONTROL_SHAPING_XGBE_0 0x4
+
+//! Change the xgbe 1 bitrate.
+//!
+#define SIM_CONTROL_SHAPING_XGBE_1 0x5
+
+//! The type of shaping to do.
+//!
+#define SIM_CONTROL_SHAPING_TYPE_BITS 2
+
+//! Control the multiplier.
+//!
+#define SIM_CONTROL_SHAPING_MULTIPLIER 0
+
+//! Control the PPS.
+//!
+#define SIM_CONTROL_SHAPING_PPS 1
+
+//! Control the BPS.
+//!
+#define SIM_CONTROL_SHAPING_BPS 2
+
+//! The number of bits for the units for the shaping parameter.
+//!
+#define SIM_CONTROL_SHAPING_UNITS_BITS 2
+
+//! Provide a number in single units.
+//!
+#define SIM_CONTROL_SHAPING_UNITS_SINGLE 0
+
+//! Provide a number in kilo units.
+//!
+#define SIM_CONTROL_SHAPING_UNITS_KILO 1
+
+//! Provide a number in mega units.
+//!
+#define SIM_CONTROL_SHAPING_UNITS_MEGA 2
+
+//! Provide a number in giga units.
+//!
+#define SIM_CONTROL_SHAPING_UNITS_GIGA 3
+
+// @}
+
+//! How many bits are available for the rate.
+//!
+#define SIM_CONTROL_SHAPING_RATE_BITS \
+  (32 - (_SIM_CONTROL_OPERATOR_BITS + \
+         SIM_CONTROL_SHAPING_SHIM_ID_BITS + \
+         SIM_CONTROL_SHAPING_TYPE_BITS + \
+         SIM_CONTROL_SHAPING_UNITS_BITS))
+
+//! Computes the value to write to SPR_SIM_CONTROL to change a bitrate.
+//!
+#define SIM_SHAPING_SPR_ARG(shim, type, units, rate) \
+  (SIM_CONTROL_SHAPING | \
+   ((shim) | \
+   ((type) << (SIM_CONTROL_SHAPING_SHIM_ID_BITS)) | \
+   ((units) << (SIM_CONTROL_SHAPING_SHIM_ID_BITS + \
+                SIM_CONTROL_SHAPING_TYPE_BITS)) | \
+   ((rate) << (SIM_CONTROL_SHAPING_SHIM_ID_BITS + \
+               SIM_CONTROL_SHAPING_TYPE_BITS + \
+               SIM_CONTROL_SHAPING_UNITS_BITS))) << _SIM_CONTROL_OPERATOR_BITS)
+
+
+//== Values returned when reading SPR_SIM_CONTROL.
+// ISSUE: These names should share a longer common prefix.
+
+//! When reading SPR_SIM_CONTROL, the mask of simulator tracing bits
+//! (SIM_TRACE_xxx values).
+//!
+#define SIM_TRACE_FLAG_MASK 0xFFFF
+
+//! When reading SPR_SIM_CONTROL, the mask for whether profiling is enabled.
+//!
+#define SIM_PROFILER_ENABLED_MASK 0x10000
+
+
+//== Special arguments for "SIM_CONTROL_PUTC".
+
+//! Flag value for forcing a PUTC string-flush, including
+//! coordinate/cycle prefix and newline.
+//!
+#define SIM_PUTC_FLUSH_STRING 0x100
+
+//! Flag value for forcing a PUTC binary-data-flush, which skips the
+//! prefix and does not append a newline.
+//!
+#define SIM_PUTC_FLUSH_BINARY 0x101
+
+
+#endif //__ARCH_SIM_DEF_H__
diff --git a/arch/tile/include/arch/spr_def.h b/arch/tile/include/arch/spr_def.h
new file mode 100644
index 0000000..c8fdbd9
--- /dev/null
+++ b/arch/tile/include/arch/spr_def.h
@@ -0,0 +1,19 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifdef __tilegx__
+#include <arch/spr_def_64.h>
+#else
+#include <arch/spr_def_32.h>
+#endif
diff --git a/arch/tile/include/arch/spr_def_32.h b/arch/tile/include/arch/spr_def_32.h
new file mode 100644
index 0000000..b4fc068
--- /dev/null
+++ b/arch/tile/include/arch/spr_def_32.h
@@ -0,0 +1,162 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef __DOXYGEN__
+
+#ifndef __ARCH_SPR_DEF_H__
+#define __ARCH_SPR_DEF_H__
+
+#define SPR_AUX_PERF_COUNT_0 0x6005
+#define SPR_AUX_PERF_COUNT_1 0x6006
+#define SPR_AUX_PERF_COUNT_CTL 0x6007
+#define SPR_AUX_PERF_COUNT_STS 0x6008
+#define SPR_CYCLE_HIGH 0x4e06
+#define SPR_CYCLE_LOW 0x4e07
+#define SPR_DMA_BYTE 0x3900
+#define SPR_DMA_CHUNK_SIZE 0x3901
+#define SPR_DMA_CTR 0x3902
+#define SPR_DMA_CTR__REQUEST_MASK  0x1
+#define SPR_DMA_CTR__SUSPEND_MASK  0x2
+#define SPR_DMA_DST_ADDR 0x3903
+#define SPR_DMA_DST_CHUNK_ADDR 0x3904
+#define SPR_DMA_SRC_ADDR 0x3905
+#define SPR_DMA_SRC_CHUNK_ADDR 0x3906
+#define SPR_DMA_STATUS__DONE_MASK  0x1
+#define SPR_DMA_STATUS__BUSY_MASK  0x2
+#define SPR_DMA_STATUS__RUNNING_MASK  0x10
+#define SPR_DMA_STRIDE 0x3907
+#define SPR_DMA_USER_STATUS 0x3908
+#define SPR_DONE 0x4e08
+#define SPR_EVENT_BEGIN 0x4e0d
+#define SPR_EVENT_END 0x4e0e
+#define SPR_EX_CONTEXT_0_0 0x4a05
+#define SPR_EX_CONTEXT_0_1 0x4a06
+#define SPR_EX_CONTEXT_0_1__PL_SHIFT 0
+#define SPR_EX_CONTEXT_0_1__PL_RMASK 0x3
+#define SPR_EX_CONTEXT_0_1__PL_MASK  0x3
+#define SPR_EX_CONTEXT_0_1__ICS_SHIFT 2
+#define SPR_EX_CONTEXT_0_1__ICS_RMASK 0x1
+#define SPR_EX_CONTEXT_0_1__ICS_MASK  0x4
+#define SPR_EX_CONTEXT_1_0 0x4805
+#define SPR_EX_CONTEXT_1_1 0x4806
+#define SPR_EX_CONTEXT_1_1__PL_SHIFT 0
+#define SPR_EX_CONTEXT_1_1__PL_RMASK 0x3
+#define SPR_EX_CONTEXT_1_1__PL_MASK  0x3
+#define SPR_EX_CONTEXT_1_1__ICS_SHIFT 2
+#define SPR_EX_CONTEXT_1_1__ICS_RMASK 0x1
+#define SPR_EX_CONTEXT_1_1__ICS_MASK  0x4
+#define SPR_FAIL 0x4e09
+#define SPR_INTCTRL_0_STATUS 0x4a07
+#define SPR_INTCTRL_1_STATUS 0x4807
+#define SPR_INTERRUPT_CRITICAL_SECTION 0x4e0a
+#define SPR_INTERRUPT_MASK_0_0 0x4a08
+#define SPR_INTERRUPT_MASK_0_1 0x4a09
+#define SPR_INTERRUPT_MASK_1_0 0x4809
+#define SPR_INTERRUPT_MASK_1_1 0x480a
+#define SPR_INTERRUPT_MASK_RESET_0_0 0x4a0a
+#define SPR_INTERRUPT_MASK_RESET_0_1 0x4a0b
+#define SPR_INTERRUPT_MASK_RESET_1_0 0x480b
+#define SPR_INTERRUPT_MASK_RESET_1_1 0x480c
+#define SPR_INTERRUPT_MASK_SET_0_0 0x4a0c
+#define SPR_INTERRUPT_MASK_SET_0_1 0x4a0d
+#define SPR_INTERRUPT_MASK_SET_1_0 0x480d
+#define SPR_INTERRUPT_MASK_SET_1_1 0x480e
+#define SPR_MPL_DMA_CPL_SET_0 0x5800
+#define SPR_MPL_DMA_CPL_SET_1 0x5801
+#define SPR_MPL_DMA_NOTIFY_SET_0 0x3800
+#define SPR_MPL_DMA_NOTIFY_SET_1 0x3801
+#define SPR_MPL_INTCTRL_0_SET_0 0x4a00
+#define SPR_MPL_INTCTRL_0_SET_1 0x4a01
+#define SPR_MPL_INTCTRL_1_SET_0 0x4800
+#define SPR_MPL_INTCTRL_1_SET_1 0x4801
+#define SPR_MPL_SN_ACCESS_SET_0 0x0800
+#define SPR_MPL_SN_ACCESS_SET_1 0x0801
+#define SPR_MPL_SN_CPL_SET_0 0x5a00
+#define SPR_MPL_SN_CPL_SET_1 0x5a01
+#define SPR_MPL_SN_FIREWALL_SET_0 0x2c00
+#define SPR_MPL_SN_FIREWALL_SET_1 0x2c01
+#define SPR_MPL_SN_NOTIFY_SET_0 0x2a00
+#define SPR_MPL_SN_NOTIFY_SET_1 0x2a01
+#define SPR_MPL_UDN_ACCESS_SET_0 0x0c00
+#define SPR_MPL_UDN_ACCESS_SET_1 0x0c01
+#define SPR_MPL_UDN_AVAIL_SET_0 0x4000
+#define SPR_MPL_UDN_AVAIL_SET_1 0x4001
+#define SPR_MPL_UDN_CA_SET_0 0x3c00
+#define SPR_MPL_UDN_CA_SET_1 0x3c01
+#define SPR_MPL_UDN_COMPLETE_SET_0 0x1400
+#define SPR_MPL_UDN_COMPLETE_SET_1 0x1401
+#define SPR_MPL_UDN_FIREWALL_SET_0 0x3000
+#define SPR_MPL_UDN_FIREWALL_SET_1 0x3001
+#define SPR_MPL_UDN_REFILL_SET_0 0x1000
+#define SPR_MPL_UDN_REFILL_SET_1 0x1001
+#define SPR_MPL_UDN_TIMER_SET_0 0x3600
+#define SPR_MPL_UDN_TIMER_SET_1 0x3601
+#define SPR_MPL_WORLD_ACCESS_SET_0 0x4e00
+#define SPR_MPL_WORLD_ACCESS_SET_1 0x4e01
+#define SPR_PASS 0x4e0b
+#define SPR_PERF_COUNT_0 0x4205
+#define SPR_PERF_COUNT_1 0x4206
+#define SPR_PERF_COUNT_CTL 0x4207
+#define SPR_PERF_COUNT_STS 0x4208
+#define SPR_PROC_STATUS 0x4f00
+#define SPR_SIM_CONTROL 0x4e0c
+#define SPR_SNCTL 0x0805
+#define SPR_SNCTL__FRZFABRIC_MASK  0x1
+#define SPR_SNCTL__FRZPROC_MASK  0x2
+#define SPR_SNPC 0x080b
+#define SPR_SNSTATIC 0x080c
+#define SPR_SYSTEM_SAVE_0_0 0x4b00
+#define SPR_SYSTEM_SAVE_0_1 0x4b01
+#define SPR_SYSTEM_SAVE_0_2 0x4b02
+#define SPR_SYSTEM_SAVE_0_3 0x4b03
+#define SPR_SYSTEM_SAVE_1_0 0x4900
+#define SPR_SYSTEM_SAVE_1_1 0x4901
+#define SPR_SYSTEM_SAVE_1_2 0x4902
+#define SPR_SYSTEM_SAVE_1_3 0x4903
+#define SPR_TILE_COORD 0x4c17
+#define SPR_TILE_RTF_HWM 0x4e10
+#define SPR_TILE_TIMER_CONTROL 0x3205
+#define SPR_TILE_WRITE_PENDING 0x4e0f
+#define SPR_UDN_AVAIL_EN 0x4005
+#define SPR_UDN_CA_DATA 0x0d00
+#define SPR_UDN_DATA_AVAIL 0x0d03
+#define SPR_UDN_DEADLOCK_TIMEOUT 0x3606
+#define SPR_UDN_DEMUX_CA_COUNT 0x0c05
+#define SPR_UDN_DEMUX_COUNT_0 0x0c06
+#define SPR_UDN_DEMUX_COUNT_1 0x0c07
+#define SPR_UDN_DEMUX_COUNT_2 0x0c08
+#define SPR_UDN_DEMUX_COUNT_3 0x0c09
+#define SPR_UDN_DEMUX_CTL 0x0c0a
+#define SPR_UDN_DEMUX_QUEUE_SEL 0x0c0c
+#define SPR_UDN_DEMUX_STATUS 0x0c0d
+#define SPR_UDN_DEMUX_WRITE_FIFO 0x0c0e
+#define SPR_UDN_DIRECTION_PROTECT 0x3005
+#define SPR_UDN_REFILL_EN 0x1005
+#define SPR_UDN_SP_FIFO_DATA 0x0c11
+#define SPR_UDN_SP_FIFO_SEL 0x0c12
+#define SPR_UDN_SP_FREEZE 0x0c13
+#define SPR_UDN_SP_FREEZE__SP_FRZ_MASK  0x1
+#define SPR_UDN_SP_FREEZE__DEMUX_FRZ_MASK  0x2
+#define SPR_UDN_SP_FREEZE__NON_DEST_EXT_MASK  0x4
+#define SPR_UDN_SP_STATE 0x0c14
+#define SPR_UDN_TAG_0 0x0c15
+#define SPR_UDN_TAG_1 0x0c16
+#define SPR_UDN_TAG_2 0x0c17
+#define SPR_UDN_TAG_3 0x0c18
+#define SPR_UDN_TAG_VALID 0x0c19
+#define SPR_UDN_TILE_COORD 0x0c1a
+
+#endif /* !defined(__ARCH_SPR_DEF_H__) */
+
+#endif /* !defined(__DOXYGEN__) */
diff --git a/arch/tile/include/asm/Kbuild b/arch/tile/include/asm/Kbuild
new file mode 100644
index 0000000..3b8f55b
--- /dev/null
+++ b/arch/tile/include/asm/Kbuild
@@ -0,0 +1,3 @@
+include include/asm-generic/Kbuild.asm
+
+header-y += ucontext.h
diff --git a/arch/tile/include/asm/asm-offsets.h b/arch/tile/include/asm/asm-offsets.h
new file mode 100644
index 0000000..d370ee3
--- /dev/null
+++ b/arch/tile/include/asm/asm-offsets.h
@@ -0,0 +1 @@
+#include <generated/asm-offsets.h>
diff --git a/arch/tile/include/asm/atomic.h b/arch/tile/include/asm/atomic.h
new file mode 100644
index 0000000..b8c49f9
--- /dev/null
+++ b/arch/tile/include/asm/atomic.h
@@ -0,0 +1,159 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ *
+ * Atomic primitives.
+ */
+
+#ifndef _ASM_TILE_ATOMIC_H
+#define _ASM_TILE_ATOMIC_H
+
+#ifndef __ASSEMBLY__
+
+#include <linux/compiler.h>
+#include <asm/system.h>
+
+#define ATOMIC_INIT(i)	{ (i) }
+
+/**
+ * atomic_read - read atomic variable
+ * @v: pointer of type atomic_t
+ *
+ * Atomically reads the value of @v.
+ */
+static inline int atomic_read(const atomic_t *v)
+{
+       return v->counter;
+}
+
+/**
+ * atomic_sub_return - subtract integer and return
+ * @v: pointer of type atomic_t
+ * @i: integer value to subtract
+ *
+ * Atomically subtracts @i from @v and returns @v - @i
+ */
+#define atomic_sub_return(i, v)		atomic_add_return((int)(-(i)), (v))
+
+/**
+ * atomic_sub - subtract integer from atomic variable
+ * @i: integer value to subtract
+ * @v: pointer of type atomic_t
+ *
+ * Atomically subtracts @i from @v.
+ */
+#define atomic_sub(i, v)		atomic_add((int)(-(i)), (v))
+
+/**
+ * atomic_sub_and_test - subtract value from variable and test result
+ * @i: integer value to subtract
+ * @v: pointer of type atomic_t
+ *
+ * Atomically subtracts @i from @v and returns true if the result is
+ * zero, or false for all other cases.
+ */
+#define atomic_sub_and_test(i, v)	(atomic_sub_return((i), (v)) == 0)
+
+/**
+ * atomic_inc_return - increment memory and return
+ * @v: pointer of type atomic_t
+ *
+ * Atomically increments @v by 1 and returns the new value.
+ */
+#define atomic_inc_return(v)		atomic_add_return(1, (v))
+
+/**
+ * atomic_dec_return - decrement memory and return
+ * @v: pointer of type atomic_t
+ *
+ * Atomically decrements @v by 1 and returns the new value.
+ */
+#define atomic_dec_return(v)		atomic_sub_return(1, (v))
+
+/**
+ * atomic_inc - increment atomic variable
+ * @v: pointer of type atomic_t
+ *
+ * Atomically increments @v by 1.
+ */
+#define atomic_inc(v)			atomic_add(1, (v))
+
+/**
+ * atomic_dec - decrement atomic variable
+ * @v: pointer of type atomic_t
+ *
+ * Atomically decrements @v by 1.
+ */
+#define atomic_dec(v)			atomic_sub(1, (v))
+
+/**
+ * atomic_dec_and_test - decrement and test
+ * @v: pointer of type atomic_t
+ *
+ * Atomically decrements @v by 1 and returns true if the result is 0.
+ */
+#define atomic_dec_and_test(v)		(atomic_dec_return(v) == 0)
+
+/**
+ * atomic_inc_and_test - increment and test
+ * @v: pointer of type atomic_t
+ *
+ * Atomically increments @v by 1 and returns true if the result is 0.
+ */
+#define atomic_inc_and_test(v)		(atomic_inc_return(v) == 0)
+
+/**
+ * atomic_add_negative - add and test if negative
+ * @v: pointer of type atomic_t
+ * @i: integer value to add
+ *
+ * Atomically adds @i to @v and returns true if the result is
+ * negative, or false when result is greater than or equal to zero.
+ */
+#define atomic_add_negative(i, v)	(atomic_add_return((i), (v)) < 0)
+
+/**
+ * atomic_inc_not_zero - increment unless the number is zero
+ * @v: pointer of type atomic_t
+ *
+ * Atomically increments @v by 1, so long as @v is non-zero.
+ * Returns non-zero if @v was non-zero, and zero otherwise.
+ */
+#define atomic_inc_not_zero(v)		atomic_add_unless((v), 1, 0)
+
+
+/*
+ * We define xchg() and cmpxchg() in the included headers.
+ * Note that we do not define __HAVE_ARCH_CMPXCHG, since that would imply
+ * that cmpxchg() is an efficient operation, which is not particularly true.
+ */
+
+/* Nonexistent functions intended to cause link errors. */
+extern unsigned long __xchg_called_with_bad_pointer(void);
+extern unsigned long __cmpxchg_called_with_bad_pointer(void);
+
+#define tas(ptr) (xchg((ptr), 1))
+
+#endif /* __ASSEMBLY__ */
+
+#ifndef __tilegx__
+#include <asm/atomic_32.h>
+#else
+#include <asm/atomic_64.h>
+#endif
+
+/* Provide the appropriate atomic_long_t definitions. */
+#ifndef __ASSEMBLY__
+#include <asm-generic/atomic-long.h>
+#endif
+
+#endif /* _ASM_TILE_ATOMIC_H */
diff --git a/arch/tile/include/asm/atomic_32.h b/arch/tile/include/asm/atomic_32.h
new file mode 100644
index 0000000..e4f8b4f
--- /dev/null
+++ b/arch/tile/include/asm/atomic_32.h
@@ -0,0 +1,353 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ *
+ * Do not include directly; use <asm/atomic.h>.
+ */
+
+#ifndef _ASM_TILE_ATOMIC_32_H
+#define _ASM_TILE_ATOMIC_32_H
+
+#include <arch/chip.h>
+
+#ifndef __ASSEMBLY__
+
+/* Tile-specific routines to support <asm/atomic.h>. */
+int _atomic_xchg(atomic_t *v, int n);
+int _atomic_xchg_add(atomic_t *v, int i);
+int _atomic_xchg_add_unless(atomic_t *v, int a, int u);
+int _atomic_cmpxchg(atomic_t *v, int o, int n);
+
+/**
+ * atomic_xchg - atomically exchange contents of memory with a new value
+ * @v: pointer of type atomic_t
+ * @i: integer value to store in memory
+ *
+ * Atomically sets @v to @i and returns old @v
+ */
+static inline int atomic_xchg(atomic_t *v, int n)
+{
+	smp_mb();  /* barrier for proper semantics */
+	return _atomic_xchg(v, n);
+}
+
+/**
+ * atomic_cmpxchg - atomically exchange contents of memory if it matches
+ * @v: pointer of type atomic_t
+ * @o: old value that memory should have
+ * @n: new value to write to memory if it matches
+ *
+ * Atomically checks if @v holds @o and replaces it with @n if so.
+ * Returns the old value at @v.
+ */
+static inline int atomic_cmpxchg(atomic_t *v, int o, int n)
+{
+	smp_mb();  /* barrier for proper semantics */
+	return _atomic_cmpxchg(v, o, n);
+}
+
+/**
+ * atomic_add - add integer to atomic variable
+ * @i: integer value to add
+ * @v: pointer of type atomic_t
+ *
+ * Atomically adds @i to @v.
+ */
+static inline void atomic_add(int i, atomic_t *v)
+{
+	_atomic_xchg_add(v, i);
+}
+
+/**
+ * atomic_add_return - add integer and return
+ * @v: pointer of type atomic_t
+ * @i: integer value to add
+ *
+ * Atomically adds @i to @v and returns @i + @v
+ */
+static inline int atomic_add_return(int i, atomic_t *v)
+{
+	smp_mb();  /* barrier for proper semantics */
+	return _atomic_xchg_add(v, i) + i;
+}
+
+/**
+ * atomic_add_unless - add unless the number is already a given value
+ * @v: pointer of type atomic_t
+ * @a: the amount to add to v...
+ * @u: ...unless v is equal to u.
+ *
+ * Atomically adds @a to @v, so long as @v was not already @u.
+ * Returns non-zero if @v was not @u, and zero otherwise.
+ */
+static inline int atomic_add_unless(atomic_t *v, int a, int u)
+{
+	smp_mb();  /* barrier for proper semantics */
+	return _atomic_xchg_add_unless(v, a, u) != u;
+}
+
+/**
+ * atomic_set - set atomic variable
+ * @v: pointer of type atomic_t
+ * @i: required value
+ *
+ * Atomically sets the value of @v to @i.
+ *
+ * atomic_set() can't be just a raw store, since it would be lost if it
+ * fell between the load and store of one of the other atomic ops.
+ */
+static inline void atomic_set(atomic_t *v, int n)
+{
+	_atomic_xchg(v, n);
+}
+
+#define xchg(ptr, x) ((typeof(*(ptr))) \
+  ((sizeof(*(ptr)) == sizeof(atomic_t)) ? \
+   atomic_xchg((atomic_t *)(ptr), (long)(x)) : \
+   __xchg_called_with_bad_pointer()))
+
+#define cmpxchg(ptr, o, n) ((typeof(*(ptr))) \
+  ((sizeof(*(ptr)) == sizeof(atomic_t)) ? \
+   atomic_cmpxchg((atomic_t *)(ptr), (long)(o), (long)(n)) : \
+   __cmpxchg_called_with_bad_pointer()))
+
+/* A 64bit atomic type */
+
+typedef struct {
+	u64 __aligned(8) counter;
+} atomic64_t;
+
+#define ATOMIC64_INIT(val) { (val) }
+
+u64 _atomic64_xchg(atomic64_t *v, u64 n);
+u64 _atomic64_xchg_add(atomic64_t *v, u64 i);
+u64 _atomic64_xchg_add_unless(atomic64_t *v, u64 a, u64 u);
+u64 _atomic64_cmpxchg(atomic64_t *v, u64 o, u64 n);
+
+/**
+ * atomic64_read - read atomic variable
+ * @v: pointer of type atomic64_t
+ *
+ * Atomically reads the value of @v.
+ */
+static inline u64 atomic64_read(const atomic64_t *v)
+{
+	/*
+	 * Requires an atomic op to read both 32-bit parts consistently.
+	 * Casting away const is safe since the atomic support routines
+	 * do not write to memory if the value has not been modified.
+	 */
+	return _atomic64_xchg_add((atomic64_t *)v, 0);
+}
+
+/**
+ * atomic64_xchg - atomically exchange contents of memory with a new value
+ * @v: pointer of type atomic64_t
+ * @i: integer value to store in memory
+ *
+ * Atomically sets @v to @i and returns old @v
+ */
+static inline u64 atomic64_xchg(atomic64_t *v, u64 n)
+{
+	smp_mb();  /* barrier for proper semantics */
+	return _atomic64_xchg(v, n);
+}
+
+/**
+ * atomic64_cmpxchg - atomically exchange contents of memory if it matches
+ * @v: pointer of type atomic64_t
+ * @o: old value that memory should have
+ * @n: new value to write to memory if it matches
+ *
+ * Atomically checks if @v holds @o and replaces it with @n if so.
+ * Returns the old value at @v.
+ */
+static inline u64 atomic64_cmpxchg(atomic64_t *v, u64 o, u64 n)
+{
+	smp_mb();  /* barrier for proper semantics */
+	return _atomic64_cmpxchg(v, o, n);
+}
+
+/**
+ * atomic64_add - add integer to atomic variable
+ * @i: integer value to add
+ * @v: pointer of type atomic64_t
+ *
+ * Atomically adds @i to @v.
+ */
+static inline void atomic64_add(u64 i, atomic64_t *v)
+{
+	_atomic64_xchg_add(v, i);
+}
+
+/**
+ * atomic64_add_return - add integer and return
+ * @v: pointer of type atomic64_t
+ * @i: integer value to add
+ *
+ * Atomically adds @i to @v and returns @i + @v
+ */
+static inline u64 atomic64_add_return(u64 i, atomic64_t *v)
+{
+	smp_mb();  /* barrier for proper semantics */
+	return _atomic64_xchg_add(v, i) + i;
+}
+
+/**
+ * atomic64_add_unless - add unless the number is already a given value
+ * @v: pointer of type atomic64_t
+ * @a: the amount to add to v...
+ * @u: ...unless v is equal to u.
+ *
+ * Atomically adds @a to @v, so long as @v was not already @u.
+ * Returns non-zero if @v was not @u, and zero otherwise.
+ */
+static inline u64 atomic64_add_unless(atomic64_t *v, u64 a, u64 u)
+{
+	smp_mb();  /* barrier for proper semantics */
+	return _atomic64_xchg_add_unless(v, a, u) != u;
+}
+
+/**
+ * atomic64_set - set atomic variable
+ * @v: pointer of type atomic64_t
+ * @i: required value
+ *
+ * Atomically sets the value of @v to @i.
+ *
+ * atomic64_set() can't be just a raw store, since it would be lost if it
+ * fell between the load and store of one of the other atomic ops.
+ */
+static inline void atomic64_set(atomic64_t *v, u64 n)
+{
+	_atomic64_xchg(v, n);
+}
+
+#define atomic64_add_negative(a, v)	(atomic64_add_return((a), (v)) < 0)
+#define atomic64_inc(v)			atomic64_add(1LL, (v))
+#define atomic64_inc_return(v)		atomic64_add_return(1LL, (v))
+#define atomic64_inc_and_test(v)	(atomic64_inc_return(v) == 0)
+#define atomic64_sub_return(i, v)	atomic64_add_return(-(i), (v))
+#define atomic64_sub_and_test(a, v)	(atomic64_sub_return((a), (v)) == 0)
+#define atomic64_sub(i, v)		atomic64_add(-(i), (v))
+#define atomic64_dec(v)			atomic64_sub(1LL, (v))
+#define atomic64_dec_return(v)		atomic64_sub_return(1LL, (v))
+#define atomic64_dec_and_test(v)	(atomic64_dec_return((v)) == 0)
+#define atomic64_inc_not_zero(v)	atomic64_add_unless((v), 1LL, 0LL)
+
+/*
+ * We need to barrier before modifying the word, since the _atomic_xxx()
+ * routines just tns the lock and then read/modify/write of the word.
+ * But after the word is updated, the routine issues an "mf" before returning,
+ * and since it's a function call, we don't even need a compiler barrier.
+ */
+#define smp_mb__before_atomic_dec()	smp_mb()
+#define smp_mb__before_atomic_inc()	smp_mb()
+#define smp_mb__after_atomic_dec()	do { } while (0)
+#define smp_mb__after_atomic_inc()	do { } while (0)
+
+
+/*
+ * Support "tns" atomic integers.  These are atomic integers that can
+ * hold any value but "1".  They are more efficient than regular atomic
+ * operations because the "lock" (aka acquire) step is a single "tns"
+ * in the uncontended case, and the "unlock" (aka release) step is a
+ * single "store" without an mf.  (However, note that on tilepro the
+ * "tns" will evict the local cache line, so it's not all upside.)
+ *
+ * Note that you can ONLY observe the value stored in the pointer
+ * using these operations; a direct read of the value may confusingly
+ * return the special value "1".
+ */
+
+int __tns_atomic_acquire(atomic_t *);
+void __tns_atomic_release(atomic_t *p, int v);
+
+static inline void tns_atomic_set(atomic_t *v, int i)
+{
+	__tns_atomic_acquire(v);
+	__tns_atomic_release(v, i);
+}
+
+static inline int tns_atomic_cmpxchg(atomic_t *v, int o, int n)
+{
+	int ret = __tns_atomic_acquire(v);
+	__tns_atomic_release(v, (ret == o) ? n : ret);
+	return ret;
+}
+
+static inline int tns_atomic_xchg(atomic_t *v, int n)
+{
+	int ret = __tns_atomic_acquire(v);
+	__tns_atomic_release(v, n);
+	return ret;
+}
+
+#endif /* !__ASSEMBLY__ */
+
+/*
+ * Internal definitions only beyond this point.
+ */
+
+#define ATOMIC_LOCKS_FOUND_VIA_TABLE() \
+  (!CHIP_HAS_CBOX_HOME_MAP() && defined(CONFIG_SMP))
+
+#if ATOMIC_LOCKS_FOUND_VIA_TABLE()
+
+/* Number of entries in atomic_lock_ptr[]. */
+#define ATOMIC_HASH_L1_SHIFT 6
+#define ATOMIC_HASH_L1_SIZE (1 << ATOMIC_HASH_L1_SHIFT)
+
+/* Number of locks in each struct pointed to by atomic_lock_ptr[]. */
+#define ATOMIC_HASH_L2_SHIFT (CHIP_L2_LOG_LINE_SIZE() - 2)
+#define ATOMIC_HASH_L2_SIZE (1 << ATOMIC_HASH_L2_SHIFT)
+
+#else /* ATOMIC_LOCKS_FOUND_VIA_TABLE() */
+
+/*
+ * Number of atomic locks in atomic_locks[]. Must be a power of two.
+ * There is no reason for more than PAGE_SIZE / 8 entries, since that
+ * is the maximum number of pointer bits we can use to index this.
+ * And we cannot have more than PAGE_SIZE / 4, since this has to
+ * fit on a single page and each entry takes 4 bytes.
+ */
+#define ATOMIC_HASH_SHIFT (PAGE_SHIFT - 3)
+#define ATOMIC_HASH_SIZE (1 << ATOMIC_HASH_SHIFT)
+
+#ifndef __ASSEMBLY__
+extern int atomic_locks[];
+#endif
+
+#endif /* ATOMIC_LOCKS_FOUND_VIA_TABLE() */
+
+/*
+ * All the code that may fault while holding an atomic lock must
+ * place the pointer to the lock in ATOMIC_LOCK_REG so the fault code
+ * can correctly release and reacquire the lock.  Note that we
+ * mention the register number in a comment in "lib/atomic_asm.S" to help
+ * assembly coders from using this register by mistake, so if it
+ * is changed here, change that comment as well.
+ */
+#define ATOMIC_LOCK_REG 20
+#define ATOMIC_LOCK_REG_NAME r20
+
+#ifndef __ASSEMBLY__
+/* Called from setup to initialize a hash table to point to per_cpu locks. */
+void __init_atomic_per_cpu(void);
+
+#ifdef CONFIG_SMP
+/* Support releasing the atomic lock in do_page_fault_ics(). */
+void __atomic_fault_unlock(int *lock_ptr);
+#endif
+#endif /* !__ASSEMBLY__ */
+
+#endif /* _ASM_TILE_ATOMIC_32_H */
diff --git a/arch/tile/include/asm/auxvec.h b/arch/tile/include/asm/auxvec.h
new file mode 100644
index 0000000..1d393ed
--- /dev/null
+++ b/arch/tile/include/asm/auxvec.h
@@ -0,0 +1,20 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_AUXVEC_H
+#define _ASM_TILE_AUXVEC_H
+
+/* No extensions to auxvec */
+
+#endif /* _ASM_TILE_AUXVEC_H */
diff --git a/arch/tile/include/asm/backtrace.h b/arch/tile/include/asm/backtrace.h
new file mode 100644
index 0000000..6970bfc
--- /dev/null
+++ b/arch/tile/include/asm/backtrace.h
@@ -0,0 +1,193 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _TILE_BACKTRACE_H
+#define _TILE_BACKTRACE_H
+
+
+
+#include <linux/types.h>
+
+#include <arch/chip.h>
+
+#if CHIP_VA_WIDTH() > 32
+typedef unsigned long long VirtualAddress;
+#else
+typedef unsigned int VirtualAddress;
+#endif
+
+
+/** Reads 'size' bytes from 'address' and writes the data to 'result'.
+ * Returns true if successful, else false (e.g. memory not readable).
+ */
+typedef bool (*BacktraceMemoryReader)(void *result,
+				      VirtualAddress address,
+				      unsigned int size,
+				      void *extra);
+
+typedef struct {
+	/** Current PC. */
+	VirtualAddress pc;
+
+	/** Current stack pointer value. */
+	VirtualAddress sp;
+
+	/** Current frame pointer value (i.e. caller's stack pointer) */
+	VirtualAddress fp;
+
+	/** Internal use only: caller's PC for first frame. */
+	VirtualAddress initial_frame_caller_pc;
+
+	/** Internal use only: callback to read memory. */
+	BacktraceMemoryReader read_memory_func;
+
+	/** Internal use only: arbitrary argument to read_memory_func. */
+	void *read_memory_func_extra;
+
+} BacktraceIterator;
+
+
+/** Initializes a backtracer to start from the given location.
+ *
+ * If the frame pointer cannot be determined it is set to -1.
+ *
+ * @param state The state to be filled in.
+ * @param read_memory_func A callback that reads memory. If NULL, a default
+ *        value is provided.
+ * @param read_memory_func_extra An arbitrary argument to read_memory_func.
+ * @param pc The current PC.
+ * @param lr The current value of the 'lr' register.
+ * @param sp The current value of the 'sp' register.
+ * @param r52 The current value of the 'r52' register.
+ */
+extern void backtrace_init(BacktraceIterator *state,
+			   BacktraceMemoryReader read_memory_func,
+			   void *read_memory_func_extra,
+			   VirtualAddress pc, VirtualAddress lr,
+			   VirtualAddress sp, VirtualAddress r52);
+
+
+/** Advances the backtracing state to the calling frame, returning
+ * true iff successful.
+ */
+extern bool backtrace_next(BacktraceIterator *state);
+
+
+typedef enum {
+
+	/* We have no idea what the caller's pc is. */
+	PC_LOC_UNKNOWN,
+
+	/* The caller's pc is currently in lr. */
+	PC_LOC_IN_LR,
+
+	/* The caller's pc can be found by dereferencing the caller's sp. */
+	PC_LOC_ON_STACK
+
+} CallerPCLocation;
+
+
+typedef enum {
+
+	/* We have no idea what the caller's sp is. */
+	SP_LOC_UNKNOWN,
+
+	/* The caller's sp is currently in r52. */
+	SP_LOC_IN_R52,
+
+	/* The caller's sp can be found by adding a certain constant
+	 * to the current value of sp.
+	 */
+	SP_LOC_OFFSET
+
+} CallerSPLocation;
+
+
+/* Bit values ORed into CALLER_* values for info ops. */
+enum {
+	/* Setting the low bit on any of these values means the info op
+	 * applies only to one bundle ago.
+	 */
+	ONE_BUNDLE_AGO_FLAG = 1,
+
+	/* Setting this bit on a CALLER_SP_* value means the PC is in LR.
+	 * If not set, PC is on the stack.
+	 */
+	PC_IN_LR_FLAG = 2,
+
+	/* This many of the low bits of a CALLER_SP_* value are for the
+	 * flag bits above.
+	 */
+	NUM_INFO_OP_FLAGS = 2,
+
+	/* We cannot have one in the memory pipe so this is the maximum. */
+	MAX_INFO_OPS_PER_BUNDLE = 2
+};
+
+
+/** Internal constants used to define 'info' operands. */
+enum {
+	/* 0 and 1 are reserved, as are all negative numbers. */
+
+	CALLER_UNKNOWN_BASE = 2,
+
+	CALLER_SP_IN_R52_BASE = 4,
+
+	CALLER_SP_OFFSET_BASE = 8
+};
+
+
+/** Current backtracer state describing where it thinks the caller is. */
+typedef struct {
+	/*
+	 * Public fields
+	 */
+
+	/* How do we find the caller's PC? */
+	CallerPCLocation pc_location : 8;
+
+	/* How do we find the caller's SP? */
+	CallerSPLocation sp_location : 8;
+
+	/* If sp_location == SP_LOC_OFFSET, then caller_sp == sp +
+	 * loc->sp_offset. Else this field is undefined.
+	 */
+	uint16_t sp_offset;
+
+	/* In the most recently visited bundle a terminating bundle? */
+	bool at_terminating_bundle;
+
+	/*
+	 * Private fields
+	 */
+
+	/* Will the forward scanner see someone clobbering sp
+	 * (i.e. changing it with something other than addi sp, sp, N?)
+	 */
+	bool sp_clobber_follows;
+
+	/* Operand to next "visible" info op (no more than one bundle past
+	 * the next terminating bundle), or -32768 if none.
+	 */
+	int16_t next_info_operand;
+
+	/* Is the info of in next_info_op in the very next bundle? */
+	bool is_next_info_operand_adjacent;
+
+} CallerLocation;
+
+
+
+
+#endif /* _TILE_BACKTRACE_H */
diff --git a/arch/tile/include/asm/bitops.h b/arch/tile/include/asm/bitops.h
new file mode 100644
index 0000000..84600f3
--- /dev/null
+++ b/arch/tile/include/asm/bitops.h
@@ -0,0 +1,126 @@
+/*
+ * Copyright 1992, Linus Torvalds.
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_BITOPS_H
+#define _ASM_TILE_BITOPS_H
+
+#include <linux/types.h>
+
+#ifndef _LINUX_BITOPS_H
+#error only <linux/bitops.h> can be included directly
+#endif
+
+#ifdef __tilegx__
+#include <asm/bitops_64.h>
+#else
+#include <asm/bitops_32.h>
+#endif
+
+/**
+ * __ffs - find first set bit in word
+ * @word: The word to search
+ *
+ * Undefined if no set bit exists, so code should check against 0 first.
+ */
+static inline unsigned long __ffs(unsigned long word)
+{
+	return __builtin_ctzl(word);
+}
+
+/**
+ * ffz - find first zero bit in word
+ * @word: The word to search
+ *
+ * Undefined if no zero exists, so code should check against ~0UL first.
+ */
+static inline unsigned long ffz(unsigned long word)
+{
+	return __builtin_ctzl(~word);
+}
+
+/**
+ * __fls - find last set bit in word
+ * @word: The word to search
+ *
+ * Undefined if no set bit exists, so code should check against 0 first.
+ */
+static inline unsigned long __fls(unsigned long word)
+{
+	return (sizeof(word) * 8) - 1 - __builtin_clzl(word);
+}
+
+/**
+ * ffs - find first set bit in word
+ * @x: the word to search
+ *
+ * This is defined the same way as the libc and compiler builtin ffs
+ * routines, therefore differs in spirit from the other bitops.
+ *
+ * ffs(value) returns 0 if value is 0 or the position of the first
+ * set bit if value is nonzero. The first (least significant) bit
+ * is at position 1.
+ */
+static inline int ffs(int x)
+{
+	return __builtin_ffs(x);
+}
+
+/**
+ * fls - find last set bit in word
+ * @x: the word to search
+ *
+ * This is defined in a similar way as the libc and compiler builtin
+ * ffs, but returns the position of the most significant set bit.
+ *
+ * fls(value) returns 0 if value is 0 or the position of the last
+ * set bit if value is nonzero. The last (most significant) bit is
+ * at position 32.
+ */
+static inline int fls(int x)
+{
+	return (sizeof(int) * 8) - __builtin_clz(x);
+}
+
+static inline int fls64(__u64 w)
+{
+	return (sizeof(__u64) * 8) - __builtin_clzll(w);
+}
+
+static inline unsigned int hweight32(unsigned int w)
+{
+	return __builtin_popcount(w);
+}
+
+static inline unsigned int hweight16(unsigned int w)
+{
+	return __builtin_popcount(w & 0xffff);
+}
+
+static inline unsigned int hweight8(unsigned int w)
+{
+	return __builtin_popcount(w & 0xff);
+}
+
+static inline unsigned long hweight64(__u64 w)
+{
+	return __builtin_popcountll(w);
+}
+
+#include <asm-generic/bitops/lock.h>
+#include <asm-generic/bitops/sched.h>
+#include <asm-generic/bitops/ext2-non-atomic.h>
+#include <asm-generic/bitops/minix.h>
+
+#endif /* _ASM_TILE_BITOPS_H */
diff --git a/arch/tile/include/asm/bitops_32.h b/arch/tile/include/asm/bitops_32.h
new file mode 100644
index 0000000..7a93c00
--- /dev/null
+++ b/arch/tile/include/asm/bitops_32.h
@@ -0,0 +1,132 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_BITOPS_32_H
+#define _ASM_TILE_BITOPS_32_H
+
+#include <linux/compiler.h>
+#include <asm/atomic.h>
+#include <asm/system.h>
+
+/* Tile-specific routines to support <asm/bitops.h>. */
+unsigned long _atomic_or(volatile unsigned long *p, unsigned long mask);
+unsigned long _atomic_andn(volatile unsigned long *p, unsigned long mask);
+unsigned long _atomic_xor(volatile unsigned long *p, unsigned long mask);
+
+/**
+ * set_bit - Atomically set a bit in memory
+ * @nr: the bit to set
+ * @addr: the address to start counting from
+ *
+ * This function is atomic and may not be reordered.
+ * See __set_bit() if you do not require the atomic guarantees.
+ * Note that @nr may be almost arbitrarily large; this function is not
+ * restricted to acting on a single-word quantity.
+ */
+static inline void set_bit(unsigned nr, volatile unsigned long *addr)
+{
+	_atomic_or(addr + BIT_WORD(nr), BIT_MASK(nr));
+}
+
+/**
+ * clear_bit - Clears a bit in memory
+ * @nr: Bit to clear
+ * @addr: Address to start counting from
+ *
+ * clear_bit() is atomic and may not be reordered.
+ * See __clear_bit() if you do not require the atomic guarantees.
+ * Note that @nr may be almost arbitrarily large; this function is not
+ * restricted to acting on a single-word quantity.
+ *
+ * clear_bit() may not contain a memory barrier, so if it is used for
+ * locking purposes, you should call smp_mb__before_clear_bit() and/or
+ * smp_mb__after_clear_bit() to ensure changes are visible on other cpus.
+ */
+static inline void clear_bit(unsigned nr, volatile unsigned long *addr)
+{
+	_atomic_andn(addr + BIT_WORD(nr), BIT_MASK(nr));
+}
+
+/**
+ * change_bit - Toggle a bit in memory
+ * @nr: Bit to change
+ * @addr: Address to start counting from
+ *
+ * change_bit() is atomic and may not be reordered.
+ * See __change_bit() if you do not require the atomic guarantees.
+ * Note that @nr may be almost arbitrarily large; this function is not
+ * restricted to acting on a single-word quantity.
+ */
+static inline void change_bit(unsigned nr, volatile unsigned long *addr)
+{
+	_atomic_xor(addr + BIT_WORD(nr), BIT_MASK(nr));
+}
+
+/**
+ * test_and_set_bit - Set a bit and return its old value
+ * @nr: Bit to set
+ * @addr: Address to count from
+ *
+ * This operation is atomic and cannot be reordered.
+ * It also implies a memory barrier.
+ */
+static inline int test_and_set_bit(unsigned nr, volatile unsigned long *addr)
+{
+	unsigned long mask = BIT_MASK(nr);
+	addr += BIT_WORD(nr);
+	smp_mb();  /* barrier for proper semantics */
+	return (_atomic_or(addr, mask) & mask) != 0;
+}
+
+/**
+ * test_and_clear_bit - Clear a bit and return its old value
+ * @nr: Bit to clear
+ * @addr: Address to count from
+ *
+ * This operation is atomic and cannot be reordered.
+ * It also implies a memory barrier.
+ */
+static inline int test_and_clear_bit(unsigned nr, volatile unsigned long *addr)
+{
+	unsigned long mask = BIT_MASK(nr);
+	addr += BIT_WORD(nr);
+	smp_mb();  /* barrier for proper semantics */
+	return (_atomic_andn(addr, mask) & mask) != 0;
+}
+
+/**
+ * test_and_change_bit - Change a bit and return its old value
+ * @nr: Bit to change
+ * @addr: Address to count from
+ *
+ * This operation is atomic and cannot be reordered.
+ * It also implies a memory barrier.
+ */
+static inline int test_and_change_bit(unsigned nr,
+				      volatile unsigned long *addr)
+{
+	unsigned long mask = BIT_MASK(nr);
+	addr += BIT_WORD(nr);
+	smp_mb();  /* barrier for proper semantics */
+	return (_atomic_xor(addr, mask) & mask) != 0;
+}
+
+/* See discussion at smp_mb__before_atomic_dec() in <asm/atomic.h>. */
+#define smp_mb__before_clear_bit()	smp_mb()
+#define smp_mb__after_clear_bit()	do {} while (0)
+
+#include <asm-generic/bitops/non-atomic.h>
+#include <asm-generic/bitops/ext2-atomic.h>
+
+#endif /* _ASM_TILE_BITOPS_32_H */
diff --git a/arch/tile/include/asm/bitsperlong.h b/arch/tile/include/asm/bitsperlong.h
new file mode 100644
index 0000000..58c771f
--- /dev/null
+++ b/arch/tile/include/asm/bitsperlong.h
@@ -0,0 +1,26 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_BITSPERLONG_H
+#define _ASM_TILE_BITSPERLONG_H
+
+#ifdef __LP64__
+# define __BITS_PER_LONG 64
+#else
+# define __BITS_PER_LONG 32
+#endif
+
+#include <asm-generic/bitsperlong.h>
+
+#endif /* _ASM_TILE_BITSPERLONG_H */
diff --git a/arch/tile/include/asm/bug.h b/arch/tile/include/asm/bug.h
new file mode 100644
index 0000000..b12fd89
--- /dev/null
+++ b/arch/tile/include/asm/bug.h
@@ -0,0 +1 @@
+#include <asm-generic/bug.h>
diff --git a/arch/tile/include/asm/bugs.h b/arch/tile/include/asm/bugs.h
new file mode 100644
index 0000000..61791e1
--- /dev/null
+++ b/arch/tile/include/asm/bugs.h
@@ -0,0 +1 @@
+#include <asm-generic/bugs.h>
diff --git a/arch/tile/include/asm/byteorder.h b/arch/tile/include/asm/byteorder.h
new file mode 100644
index 0000000..9558416
--- /dev/null
+++ b/arch/tile/include/asm/byteorder.h
@@ -0,0 +1 @@
+#include <linux/byteorder/little_endian.h>
diff --git a/arch/tile/include/asm/cache.h b/arch/tile/include/asm/cache.h
new file mode 100644
index 0000000..c2b7dcf
--- /dev/null
+++ b/arch/tile/include/asm/cache.h
@@ -0,0 +1,50 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_CACHE_H
+#define _ASM_TILE_CACHE_H
+
+#include <arch/chip.h>
+
+/* bytes per L1 data cache line */
+#define L1_CACHE_SHIFT		CHIP_L1D_LOG_LINE_SIZE()
+#define L1_CACHE_BYTES		(1 << L1_CACHE_SHIFT)
+#define L1_CACHE_ALIGN(x)	(((x)+(L1_CACHE_BYTES-1)) & -L1_CACHE_BYTES)
+
+/* bytes per L1 instruction cache line */
+#define L1I_CACHE_SHIFT		CHIP_L1I_LOG_LINE_SIZE()
+#define L1I_CACHE_BYTES		(1 << L1I_CACHE_SHIFT)
+#define L1I_CACHE_ALIGN(x)	(((x)+(L1I_CACHE_BYTES-1)) & -L1I_CACHE_BYTES)
+
+/* bytes per L2 cache line */
+#define L2_CACHE_SHIFT		CHIP_L2_LOG_LINE_SIZE()
+#define L2_CACHE_BYTES		(1 << L2_CACHE_SHIFT)
+#define L2_CACHE_ALIGN(x)	(((x)+(L2_CACHE_BYTES-1)) & -L2_CACHE_BYTES)
+
+/* use the cache line size for the L2, which is where it counts */
+#define SMP_CACHE_BYTES_SHIFT	L2_CACHE_SHIFT
+#define SMP_CACHE_BYTES		L2_CACHE_BYTES
+#define INTERNODE_CACHE_SHIFT   L2_CACHE_SHIFT
+#define INTERNODE_CACHE_BYTES   L2_CACHE_BYTES
+
+/* Group together read-mostly things to avoid cache false sharing */
+#define __read_mostly __attribute__((__section__(".data.read_mostly")))
+
+/*
+ * Attribute for data that is kept read/write coherent until the end of
+ * initialization, then bumped to read/only incoherent for performance.
+ */
+#define __write_once __attribute__((__section__(".w1data")))
+
+#endif /* _ASM_TILE_CACHE_H */
diff --git a/arch/tile/include/asm/cacheflush.h b/arch/tile/include/asm/cacheflush.h
new file mode 100644
index 0000000..7e2096a
--- /dev/null
+++ b/arch/tile/include/asm/cacheflush.h
@@ -0,0 +1,145 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_CACHEFLUSH_H
+#define _ASM_TILE_CACHEFLUSH_H
+
+#include <arch/chip.h>
+
+/* Keep includes the same across arches.  */
+#include <linux/mm.h>
+#include <linux/cache.h>
+#include <asm/system.h>
+
+/* Caches are physically-indexed and so don't need special treatment */
+#define flush_cache_all()			do { } while (0)
+#define flush_cache_mm(mm)			do { } while (0)
+#define flush_cache_dup_mm(mm)			do { } while (0)
+#define flush_cache_range(vma, start, end)	do { } while (0)
+#define flush_cache_page(vma, vmaddr, pfn)	do { } while (0)
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 0
+#define flush_dcache_page(page)			do { } while (0)
+#define flush_dcache_mmap_lock(mapping)		do { } while (0)
+#define flush_dcache_mmap_unlock(mapping)	do { } while (0)
+#define flush_cache_vmap(start, end)		do { } while (0)
+#define flush_cache_vunmap(start, end)		do { } while (0)
+#define flush_icache_page(vma, pg)		do { } while (0)
+#define flush_icache_user_range(vma, pg, adr, len)	do { } while (0)
+
+/* See "arch/tile/lib/__invalidate_icache.S". */
+extern void __invalidate_icache(unsigned long start, unsigned long size);
+
+/* Flush the icache just on this cpu */
+static inline void __flush_icache_range(unsigned long start, unsigned long end)
+{
+	__invalidate_icache(start, end - start);
+}
+
+/* Flush the entire icache on this cpu. */
+#define __flush_icache() __flush_icache_range(0, CHIP_L1I_CACHE_SIZE())
+
+#ifdef CONFIG_SMP
+/*
+ * When the kernel writes to its own text we need to do an SMP
+ * broadcast to make the L1I coherent everywhere.  This includes
+ * module load and single step.
+ */
+extern void flush_icache_range(unsigned long start, unsigned long end);
+#else
+#define flush_icache_range __flush_icache_range
+#endif
+
+/*
+ * An update to an executable user page requires icache flushing.
+ * We could carefully update only tiles that are running this process,
+ * and rely on the fact that we flush the icache on every context
+ * switch to avoid doing extra work here.  But for now, I'll be
+ * conservative and just do a global icache flush.
+ */
+static inline void copy_to_user_page(struct vm_area_struct *vma,
+				     struct page *page, unsigned long vaddr,
+				     void *dst, void *src, int len)
+{
+	memcpy(dst, src, len);
+	if (vma->vm_flags & VM_EXEC) {
+		flush_icache_range((unsigned long) dst,
+				   (unsigned long) dst + len);
+	}
+}
+
+#define copy_from_user_page(vma, page, vaddr, dst, src, len) \
+	memcpy((dst), (src), (len))
+
+/*
+ * Invalidate a VA range; pads to L2 cacheline boundaries.
+ *
+ * Note that on TILE64, __inv_buffer() actually flushes modified
+ * cache lines in addition to invalidating them, i.e., it's the
+ * same as __finv_buffer().
+ */
+static inline void __inv_buffer(void *buffer, size_t size)
+{
+	char *next = (char *)((long)buffer & -L2_CACHE_BYTES);
+	char *finish = (char *)L2_CACHE_ALIGN((long)buffer + size);
+	while (next < finish) {
+		__insn_inv(next);
+		next += CHIP_INV_STRIDE();
+	}
+}
+
+/* Flush a VA range; pads to L2 cacheline boundaries. */
+static inline void __flush_buffer(void *buffer, size_t size)
+{
+	char *next = (char *)((long)buffer & -L2_CACHE_BYTES);
+	char *finish = (char *)L2_CACHE_ALIGN((long)buffer + size);
+	while (next < finish) {
+		__insn_flush(next);
+		next += CHIP_FLUSH_STRIDE();
+	}
+}
+
+/* Flush & invalidate a VA range; pads to L2 cacheline boundaries. */
+static inline void __finv_buffer(void *buffer, size_t size)
+{
+	char *next = (char *)((long)buffer & -L2_CACHE_BYTES);
+	char *finish = (char *)L2_CACHE_ALIGN((long)buffer + size);
+	while (next < finish) {
+		__insn_finv(next);
+		next += CHIP_FINV_STRIDE();
+	}
+}
+
+
+/* Invalidate a VA range, then memory fence. */
+static inline void inv_buffer(void *buffer, size_t size)
+{
+	__inv_buffer(buffer, size);
+	mb_incoherent();
+}
+
+/* Flush a VA range, then memory fence. */
+static inline void flush_buffer(void *buffer, size_t size)
+{
+	__flush_buffer(buffer, size);
+	mb_incoherent();
+}
+
+/* Flush & invalidate a VA range, then memory fence. */
+static inline void finv_buffer(void *buffer, size_t size)
+{
+	__finv_buffer(buffer, size);
+	mb_incoherent();
+}
+
+#endif /* _ASM_TILE_CACHEFLUSH_H */
diff --git a/arch/tile/include/asm/checksum.h b/arch/tile/include/asm/checksum.h
new file mode 100644
index 0000000..a120766
--- /dev/null
+++ b/arch/tile/include/asm/checksum.h
@@ -0,0 +1,24 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_CHECKSUM_H
+#define _ASM_TILE_CHECKSUM_H
+
+#include <asm-generic/checksum.h>
+
+/* Allow us to provide a more optimized do_csum(). */
+__wsum do_csum(const unsigned char *buff, int len);
+#define do_csum do_csum
+
+#endif /* _ASM_TILE_CHECKSUM_H */
diff --git a/arch/tile/include/asm/compat.h b/arch/tile/include/asm/compat.h
new file mode 100644
index 0000000..e133c53
--- /dev/null
+++ b/arch/tile/include/asm/compat.h
@@ -0,0 +1,308 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_COMPAT_H
+#define _ASM_TILE_COMPAT_H
+
+/*
+ * Architecture specific compatibility types
+ */
+#include <linux/types.h>
+#include <linux/sched.h>
+
+#define COMPAT_USER_HZ	100
+
+/* "long" and pointer-based types are different. */
+typedef s32		compat_long_t;
+typedef u32		compat_ulong_t;
+typedef u32		compat_size_t;
+typedef s32		compat_ssize_t;
+typedef s32		compat_off_t;
+typedef s32		compat_time_t;
+typedef s32		compat_clock_t;
+typedef u32		compat_ino_t;
+typedef u32		compat_caddr_t;
+typedef	u32		compat_uptr_t;
+
+/* Many types are "int" or otherwise the same. */
+typedef __kernel_pid_t compat_pid_t;
+typedef __kernel_uid_t __compat_uid_t;
+typedef __kernel_gid_t __compat_gid_t;
+typedef __kernel_uid32_t __compat_uid32_t;
+typedef __kernel_uid32_t __compat_gid32_t;
+typedef __kernel_mode_t compat_mode_t;
+typedef __kernel_dev_t compat_dev_t;
+typedef __kernel_loff_t compat_loff_t;
+typedef __kernel_nlink_t compat_nlink_t;
+typedef __kernel_ipc_pid_t compat_ipc_pid_t;
+typedef __kernel_daddr_t compat_daddr_t;
+typedef __kernel_fsid_t	compat_fsid_t;
+typedef __kernel_timer_t compat_timer_t;
+typedef __kernel_key_t compat_key_t;
+typedef int compat_int_t;
+typedef s64 compat_s64;
+typedef uint compat_uint_t;
+typedef u64 compat_u64;
+
+/* We use the same register dump format in 32-bit images. */
+typedef unsigned long compat_elf_greg_t;
+#define COMPAT_ELF_NGREG (sizeof(struct pt_regs) / sizeof(compat_elf_greg_t))
+typedef compat_elf_greg_t compat_elf_gregset_t[COMPAT_ELF_NGREG];
+
+struct compat_timespec {
+	compat_time_t	tv_sec;
+	s32		tv_nsec;
+};
+
+struct compat_timeval {
+	compat_time_t	tv_sec;
+	s32		tv_usec;
+};
+
+struct compat_stat {
+	unsigned int	st_dev;
+	unsigned int	st_ino;
+	unsigned int	st_mode;
+	unsigned int	st_nlink;
+	unsigned int	st_uid;
+	unsigned int	st_gid;
+	unsigned int	st_rdev;
+	unsigned int    __pad1;
+	int		st_size;
+	int		st_blksize;
+	int		__pad2;
+	int		st_blocks;
+	int		st_atime;
+	unsigned int	st_atime_nsec;
+	int		st_mtime;
+	unsigned int	st_mtime_nsec;
+	int		st_ctime;
+	unsigned int	st_ctime_nsec;
+	unsigned int	__unused[2];
+};
+
+struct compat_stat64 {
+	unsigned long	st_dev;
+	unsigned long	st_ino;
+	unsigned int	st_mode;
+	unsigned int	st_nlink;
+	unsigned int	st_uid;
+	unsigned int	st_gid;
+	unsigned long	st_rdev;
+	long		st_size;
+	unsigned int	st_blksize;
+	unsigned long	st_blocks __attribute__((packed));
+	unsigned int	st_atime;
+	unsigned int	st_atime_nsec;
+	unsigned int	st_mtime;
+	unsigned int	st_mtime_nsec;
+	unsigned int	st_ctime;
+	unsigned int	st_ctime_nsec;
+	unsigned int	__unused8;
+};
+
+#define compat_statfs statfs
+
+struct compat_sysctl {
+	unsigned int	name;
+	int		nlen;
+	unsigned int	oldval;
+	unsigned int	oldlenp;
+	unsigned int	newval;
+	unsigned int	newlen;
+	unsigned int	__unused[4];
+};
+
+
+struct compat_flock {
+	short		l_type;
+	short		l_whence;
+	compat_off_t	l_start;
+	compat_off_t	l_len;
+	compat_pid_t	l_pid;
+};
+
+#define F_GETLK64	12	/*  using 'struct flock64' */
+#define F_SETLK64	13
+#define F_SETLKW64	14
+
+struct compat_flock64 {
+	short		l_type;
+	short		l_whence;
+	compat_loff_t	l_start;
+	compat_loff_t	l_len;
+	compat_pid_t	l_pid;
+};
+
+#define COMPAT_RLIM_INFINITY		0xffffffff
+
+#define _COMPAT_NSIG		64
+#define _COMPAT_NSIG_BPW	32
+
+typedef u32               compat_sigset_word;
+
+#define COMPAT_OFF_T_MAX	0x7fffffff
+#define COMPAT_LOFF_T_MAX	0x7fffffffffffffffL
+
+struct compat_ipc64_perm {
+	compat_key_t key;
+	__compat_uid32_t uid;
+	__compat_gid32_t gid;
+	__compat_uid32_t cuid;
+	__compat_gid32_t cgid;
+	unsigned short mode;
+	unsigned short __pad1;
+	unsigned short seq;
+	unsigned short __pad2;
+	compat_ulong_t unused1;
+	compat_ulong_t unused2;
+};
+
+struct compat_semid64_ds {
+	struct compat_ipc64_perm sem_perm;
+	compat_time_t  sem_otime;
+	compat_ulong_t __unused1;
+	compat_time_t  sem_ctime;
+	compat_ulong_t __unused2;
+	compat_ulong_t sem_nsems;
+	compat_ulong_t __unused3;
+	compat_ulong_t __unused4;
+};
+
+struct compat_msqid64_ds {
+	struct compat_ipc64_perm msg_perm;
+	compat_time_t  msg_stime;
+	compat_ulong_t __unused1;
+	compat_time_t  msg_rtime;
+	compat_ulong_t __unused2;
+	compat_time_t  msg_ctime;
+	compat_ulong_t __unused3;
+	compat_ulong_t msg_cbytes;
+	compat_ulong_t msg_qnum;
+	compat_ulong_t msg_qbytes;
+	compat_pid_t   msg_lspid;
+	compat_pid_t   msg_lrpid;
+	compat_ulong_t __unused4;
+	compat_ulong_t __unused5;
+};
+
+struct compat_shmid64_ds {
+	struct compat_ipc64_perm shm_perm;
+	compat_size_t  shm_segsz;
+	compat_time_t  shm_atime;
+	compat_ulong_t __unused1;
+	compat_time_t  shm_dtime;
+	compat_ulong_t __unused2;
+	compat_time_t  shm_ctime;
+	compat_ulong_t __unused3;
+	compat_pid_t   shm_cpid;
+	compat_pid_t   shm_lpid;
+	compat_ulong_t shm_nattch;
+	compat_ulong_t __unused4;
+	compat_ulong_t __unused5;
+};
+
+/*
+ * A pointer passed in from user mode. This should not
+ * be used for syscall parameters, just declare them
+ * as pointers because the syscall entry code will have
+ * appropriately converted them already.
+ */
+
+static inline void __user *compat_ptr(compat_uptr_t uptr)
+{
+	return (void __user *)(unsigned long)uptr;
+}
+
+static inline compat_uptr_t ptr_to_compat(void __user *uptr)
+{
+	return (u32)(unsigned long)uptr;
+}
+
+/* Sign-extend when storing a kernel pointer to a user's ptregs. */
+static inline unsigned long ptr_to_compat_reg(void __user *uptr)
+{
+	return (long)(int)(long)uptr;
+}
+
+static inline void __user *compat_alloc_user_space(long len)
+{
+	struct pt_regs *regs = task_pt_regs(current);
+	return (void __user *)regs->sp - len;
+}
+
+static inline int is_compat_task(void)
+{
+	return current_thread_info()->status & TS_COMPAT;
+}
+
+extern int compat_setup_rt_frame(int sig, struct k_sigaction *ka,
+				 siginfo_t *info, sigset_t *set,
+				 struct pt_regs *regs);
+
+/* Compat syscalls. */
+struct compat_sigaction;
+struct compat_siginfo;
+struct compat_sigaltstack;
+long compat_sys_execve(char __user *path, compat_uptr_t __user *argv,
+		       compat_uptr_t __user *envp);
+long compat_sys_rt_sigaction(int sig, struct compat_sigaction __user *act,
+			     struct compat_sigaction __user *oact,
+			     size_t sigsetsize);
+long compat_sys_rt_sigqueueinfo(int pid, int sig,
+				struct compat_siginfo __user *uinfo);
+long compat_sys_rt_sigreturn(void);
+long compat_sys_sigaltstack(const struct compat_sigaltstack __user *uss_ptr,
+			    struct compat_sigaltstack __user *uoss_ptr);
+long compat_sys_truncate64(char __user *filename, u32 dummy, u32 low, u32 high);
+long compat_sys_ftruncate64(unsigned int fd, u32 dummy, u32 low, u32 high);
+long compat_sys_pread64(unsigned int fd, char __user *ubuf, size_t count,
+			u32 dummy, u32 low, u32 high);
+long compat_sys_pwrite64(unsigned int fd, char __user *ubuf, size_t count,
+			 u32 dummy, u32 low, u32 high);
+long compat_sys_lookup_dcookie(u32 low, u32 high, char __user *buf, size_t len);
+long compat_sys_sync_file_range2(int fd, unsigned int flags,
+				 u32 offset_lo, u32 offset_hi,
+				 u32 nbytes_lo, u32 nbytes_hi);
+long compat_sys_fallocate(int fd, int mode,
+			  u32 offset_lo, u32 offset_hi,
+			  u32 len_lo, u32 len_hi);
+long compat_sys_stat64(char __user *filename,
+		       struct compat_stat64 __user *statbuf);
+long compat_sys_lstat64(char __user *filename,
+			struct compat_stat64 __user *statbuf);
+long compat_sys_fstat64(unsigned int fd, struct compat_stat64 __user *statbuf);
+long compat_sys_fstatat64(int dfd, char __user *filename,
+			  struct compat_stat64 __user *statbuf, int flag);
+long compat_sys_sched_rr_get_interval(compat_pid_t pid,
+				      struct compat_timespec __user *interval);
+ssize_t compat_sys_sendfile(int out_fd, int in_fd, compat_off_t __user *offset,
+			    size_t count);
+
+/* Versions of compat functions that differ from generic Linux. */
+struct compat_msgbuf;
+long tile_compat_sys_msgsnd(int msqid,
+			    struct compat_msgbuf __user *msgp,
+			    size_t msgsz, int msgflg);
+long tile_compat_sys_msgrcv(int msqid,
+			    struct compat_msgbuf __user *msgp,
+			    size_t msgsz, long msgtyp, int msgflg);
+long tile_compat_sys_ptrace(compat_long_t request, compat_long_t pid,
+			    compat_long_t addr, compat_long_t data);
+
+/* Tilera Linux syscalls that don't have "compat" versions. */
+#define compat_sys_raise_fpe sys_raise_fpe
+#define compat_sys_flush_cache sys_flush_cache
+
+#endif /* _ASM_TILE_COMPAT_H */
diff --git a/arch/tile/include/asm/cputime.h b/arch/tile/include/asm/cputime.h
new file mode 100644
index 0000000..6d68ad7
--- /dev/null
+++ b/arch/tile/include/asm/cputime.h
@@ -0,0 +1 @@
+#include <asm-generic/cputime.h>
diff --git a/arch/tile/include/asm/current.h b/arch/tile/include/asm/current.h
new file mode 100644
index 0000000..da21acf
--- /dev/null
+++ b/arch/tile/include/asm/current.h
@@ -0,0 +1,31 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_CURRENT_H
+#define _ASM_TILE_CURRENT_H
+
+#include <linux/thread_info.h>
+
+struct task_struct;
+
+static inline struct task_struct *get_current(void)
+{
+	return current_thread_info()->task;
+}
+#define current get_current()
+
+/* Return a usable "task_struct" pointer even if the real one is corrupt. */
+struct task_struct *validate_current(void);
+
+#endif /* _ASM_TILE_CURRENT_H */
diff --git a/arch/tile/include/asm/delay.h b/arch/tile/include/asm/delay.h
new file mode 100644
index 0000000..97b0e69
--- /dev/null
+++ b/arch/tile/include/asm/delay.h
@@ -0,0 +1,34 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_DELAY_H
+#define _ASM_TILE_DELAY_H
+
+/* Undefined functions to get compile-time errors. */
+extern void __bad_udelay(void);
+extern void __bad_ndelay(void);
+
+extern void __udelay(unsigned long usecs);
+extern void __ndelay(unsigned long nsecs);
+extern void __delay(unsigned long loops);
+
+#define udelay(n) (__builtin_constant_p(n) ? \
+	((n) > 20000 ? __bad_udelay() : __ndelay((n) * 1000)) : \
+	__udelay(n))
+
+#define ndelay(n) (__builtin_constant_p(n) ? \
+	((n) > 20000 ? __bad_ndelay() : __ndelay(n)) : \
+	__ndelay(n))
+
+#endif /* _ASM_TILE_DELAY_H */
diff --git a/arch/tile/include/asm/device.h b/arch/tile/include/asm/device.h
new file mode 100644
index 0000000..f0a4c25
--- /dev/null
+++ b/arch/tile/include/asm/device.h
@@ -0,0 +1 @@
+#include <asm-generic/device.h>
diff --git a/arch/tile/include/asm/div64.h b/arch/tile/include/asm/div64.h
new file mode 100644
index 0000000..6cd978c
--- /dev/null
+++ b/arch/tile/include/asm/div64.h
@@ -0,0 +1 @@
+#include <asm-generic/div64.h>
diff --git a/arch/tile/include/asm/dma-mapping.h b/arch/tile/include/asm/dma-mapping.h
new file mode 100644
index 0000000..7083e42
--- /dev/null
+++ b/arch/tile/include/asm/dma-mapping.h
@@ -0,0 +1,106 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_DMA_MAPPING_H
+#define _ASM_TILE_DMA_MAPPING_H
+
+/*
+ * IOMMU interface. See Documentation/PCI/PCI-DMA-mapping.txt and
+ * Documentation/DMA-API.txt for documentation.
+ */
+
+#include <linux/mm.h>
+#include <linux/scatterlist.h>
+#include <linux/cache.h>
+#include <linux/io.h>
+
+/*
+ * Note that on x86 and powerpc, there is a "struct dma_mapping_ops"
+ * that is used for all the DMA operations.  For now, we don't have an
+ * equivalent on tile, because we only have a single way of doing DMA.
+ */
+
+#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
+#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
+
+extern dma_addr_t dma_map_single(struct device *dev, void *ptr, size_t size,
+			  enum dma_data_direction);
+extern void dma_unmap_single(struct device *dev, dma_addr_t dma_addr,
+			     size_t size, enum dma_data_direction);
+extern int dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
+	       enum dma_data_direction);
+extern void dma_unmap_sg(struct device *dev, struct scatterlist *sg,
+			 int nhwentries, enum dma_data_direction);
+extern dma_addr_t dma_map_page(struct device *dev, struct page *page,
+			       unsigned long offset, size_t size,
+			       enum dma_data_direction);
+extern void dma_unmap_page(struct device *dev, dma_addr_t dma_address,
+			   size_t size, enum dma_data_direction);
+extern void dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
+				int nelems, enum dma_data_direction);
+extern void dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
+				   int nelems, enum dma_data_direction);
+
+
+void *dma_alloc_coherent(struct device *dev, size_t size,
+			   dma_addr_t *dma_handle, gfp_t flag);
+
+void dma_free_coherent(struct device *dev, size_t size,
+			 void *vaddr, dma_addr_t dma_handle);
+
+extern void dma_sync_single_for_cpu(struct device *, dma_addr_t, size_t,
+				    enum dma_data_direction);
+extern void dma_sync_single_for_device(struct device *, dma_addr_t,
+				       size_t, enum dma_data_direction);
+extern void dma_sync_single_range_for_cpu(struct device *, dma_addr_t,
+					  unsigned long offset, size_t,
+					  enum dma_data_direction);
+extern void dma_sync_single_range_for_device(struct device *, dma_addr_t,
+					     unsigned long offset, size_t,
+					     enum dma_data_direction);
+extern void dma_cache_sync(void *vaddr, size_t, enum dma_data_direction);
+
+static inline int
+dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
+{
+	return 0;
+}
+
+static inline int
+dma_supported(struct device *dev, u64 mask)
+{
+	return 1;
+}
+
+static inline int
+dma_set_mask(struct device *dev, u64 mask)
+{
+	if (!dev->dma_mask || !dma_supported(dev, mask))
+		return -EIO;
+
+	*dev->dma_mask = mask;
+
+	return 0;
+}
+
+static inline int
+dma_get_cache_alignment(void)
+{
+	return L2_CACHE_BYTES;
+}
+
+#define dma_is_consistent(d, h)	(1)
+
+
+#endif /* _ASM_TILE_DMA_MAPPING_H */
diff --git a/arch/tile/include/asm/dma.h b/arch/tile/include/asm/dma.h
new file mode 100644
index 0000000..12a7ca1
--- /dev/null
+++ b/arch/tile/include/asm/dma.h
@@ -0,0 +1,25 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_DMA_H
+#define _ASM_TILE_DMA_H
+
+#include <asm-generic/dma.h>
+
+/* Needed by drivers/pci/quirks.c */
+#ifdef CONFIG_PCI
+extern int isa_dma_bridge_buggy;
+#endif
+
+#endif /* _ASM_TILE_DMA_H */
diff --git a/arch/tile/include/asm/elf.h b/arch/tile/include/asm/elf.h
new file mode 100644
index 0000000..1bca0de
--- /dev/null
+++ b/arch/tile/include/asm/elf.h
@@ -0,0 +1,169 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_ELF_H
+#define _ASM_TILE_ELF_H
+
+/*
+ * ELF register definitions.
+ */
+
+#include <arch/chip.h>
+
+#include <linux/ptrace.h>
+#include <asm/byteorder.h>
+#include <asm/page.h>
+
+typedef unsigned long elf_greg_t;
+
+#define ELF_NGREG (sizeof(struct pt_regs) / sizeof(elf_greg_t))
+typedef elf_greg_t elf_gregset_t[ELF_NGREG];
+
+#define EM_TILE64  187
+#define EM_TILEPRO 188
+#define EM_TILEGX  191
+
+/* Provide a nominal data structure. */
+#define ELF_NFPREG	0
+typedef double elf_fpreg_t;
+typedef elf_fpreg_t elf_fpregset_t[ELF_NFPREG];
+
+#ifdef __tilegx__
+#define ELF_CLASS	ELFCLASS64
+#else
+#define ELF_CLASS	ELFCLASS32
+#endif
+#define ELF_DATA	ELFDATA2LSB
+
+/*
+ * There seems to be a bug in how compat_binfmt_elf.c works: it
+ * #undefs ELF_ARCH, but it is then used in binfmt_elf.c for fill_note_info().
+ * Hack around this by providing an enum value of ELF_ARCH.
+ */
+enum { ELF_ARCH = CHIP_ELF_TYPE() };
+#define ELF_ARCH ELF_ARCH
+
+/*
+ * This is used to ensure we don't load something for the wrong architecture.
+ */
+#define elf_check_arch(x)  \
+	((x)->e_ident[EI_CLASS] == ELF_CLASS && \
+	 ((x)->e_machine == CHIP_ELF_TYPE() || \
+	  (x)->e_machine == CHIP_COMPAT_ELF_TYPE()))
+
+/* The module loader only handles a few relocation types. */
+#ifndef __tilegx__
+#define R_TILE_32                 1
+#define R_TILE_JOFFLONG_X1       15
+#define R_TILE_IMM16_X0_LO       25
+#define R_TILE_IMM16_X1_LO       26
+#define R_TILE_IMM16_X0_HA       29
+#define R_TILE_IMM16_X1_HA       30
+#else
+#define R_TILEGX_64                       1
+#define R_TILEGX_JUMPOFF_X1              21
+#define R_TILEGX_IMM16_X0_HW0            36
+#define R_TILEGX_IMM16_X1_HW0            37
+#define R_TILEGX_IMM16_X0_HW1            38
+#define R_TILEGX_IMM16_X1_HW1            39
+#define R_TILEGX_IMM16_X0_HW2_LAST       48
+#define R_TILEGX_IMM16_X1_HW2_LAST       49
+#endif
+
+/* Use standard page size for core dumps. */
+#define ELF_EXEC_PAGESIZE	PAGE_SIZE
+
+/*
+ * This is the location that an ET_DYN program is loaded if exec'ed.  Typical
+ * use of this is to invoke "./ld.so someprog" to test out a new version of
+ * the loader.  We need to make sure that it is out of the way of the program
+ * that it will "exec", and that there is sufficient room for the brk.
+ */
+#define ELF_ET_DYN_BASE         (TASK_SIZE / 3 * 2)
+
+#define ELF_CORE_COPY_REGS(_dest, _regs)			\
+	memcpy((char *) &_dest, (char *) _regs,			\
+	       sizeof(struct pt_regs));
+
+/* No additional FP registers to copy. */
+#define ELF_CORE_COPY_FPREGS(t, fpu) 0
+
+/*
+ * This yields a mask that user programs can use to figure out what
+ * instruction set this CPU supports.  This could be done in user space,
+ * but it's not easy, and we've already done it here.
+ */
+#define ELF_HWCAP	(0)
+
+/*
+ * This yields a string that ld.so will use to load implementation
+ * specific libraries for optimization.  This is more specific in
+ * intent than poking at uname or /proc/cpuinfo.
+ */
+#define ELF_PLATFORM  (NULL)
+
+extern void elf_plat_init(struct pt_regs *regs, unsigned long load_addr);
+
+#define ELF_PLAT_INIT(_r, load_addr) elf_plat_init(_r, load_addr)
+
+extern int dump_task_regs(struct task_struct *, elf_gregset_t *);
+#define ELF_CORE_COPY_TASK_REGS(tsk, elf_regs) dump_task_regs(tsk, elf_regs)
+
+/* Tilera Linux has no personalities currently, so no need to do anything. */
+#define SET_PERSONALITY(ex) do { } while (0)
+
+#define ARCH_HAS_SETUP_ADDITIONAL_PAGES
+/* Support auto-mapping of the user interrupt vectors. */
+struct linux_binprm;
+extern int arch_setup_additional_pages(struct linux_binprm *bprm,
+				       int executable_stack);
+#ifdef CONFIG_COMPAT
+
+#define COMPAT_ELF_PLATFORM "tilegx-m32"
+
+/*
+ * "Compat" binaries have the same machine type, but 32-bit class,
+ * since they're not a separate machine type, but just a 32-bit
+ * variant of the standard 64-bit architecture.
+ */
+#define compat_elf_check_arch(x)  \
+	((x)->e_ident[EI_CLASS] == ELFCLASS32 && \
+	 ((x)->e_machine == CHIP_ELF_TYPE() || \
+	  (x)->e_machine == CHIP_COMPAT_ELF_TYPE()))
+
+#define compat_start_thread(regs, ip, usp) do { \
+		regs->pc = ptr_to_compat_reg((void *)(ip)); \
+		regs->sp = ptr_to_compat_reg((void *)(usp)); \
+	} while (0)
+
+/*
+ * Use SET_PERSONALITY to indicate compatibility via TS_COMPAT.
+ */
+#undef SET_PERSONALITY
+#define SET_PERSONALITY(ex) \
+do { \
+	current->personality = PER_LINUX; \
+	current_thread_info()->status &= ~TS_COMPAT; \
+} while (0)
+#define COMPAT_SET_PERSONALITY(ex) \
+do { \
+	current->personality = PER_LINUX_32BIT; \
+	current_thread_info()->status |= TS_COMPAT; \
+} while (0)
+
+#define COMPAT_ELF_ET_DYN_BASE (0xffffffff / 3 * 2)
+
+#endif /* CONFIG_COMPAT */
+
+#endif /* _ASM_TILE_ELF_H */
diff --git a/arch/tile/include/asm/emergency-restart.h b/arch/tile/include/asm/emergency-restart.h
new file mode 100644
index 0000000..3711bd9
--- /dev/null
+++ b/arch/tile/include/asm/emergency-restart.h
@@ -0,0 +1 @@
+#include <asm-generic/emergency-restart.h>
diff --git a/arch/tile/include/asm/errno.h b/arch/tile/include/asm/errno.h
new file mode 100644
index 0000000..4c82b50
--- /dev/null
+++ b/arch/tile/include/asm/errno.h
@@ -0,0 +1 @@
+#include <asm-generic/errno.h>
diff --git a/arch/tile/include/asm/fcntl.h b/arch/tile/include/asm/fcntl.h
new file mode 100644
index 0000000..46ab12d
--- /dev/null
+++ b/arch/tile/include/asm/fcntl.h
@@ -0,0 +1 @@
+#include <asm-generic/fcntl.h>
diff --git a/arch/tile/include/asm/fixmap.h b/arch/tile/include/asm/fixmap.h
new file mode 100644
index 0000000..51537ff
--- /dev/null
+++ b/arch/tile/include/asm/fixmap.h
@@ -0,0 +1,124 @@
+/*
+ * Copyright (C) 1998 Ingo Molnar
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_FIXMAP_H
+#define _ASM_TILE_FIXMAP_H
+
+#include <asm/page.h>
+
+#ifndef __ASSEMBLY__
+#include <linux/kernel.h>
+#ifdef CONFIG_HIGHMEM
+#include <linux/threads.h>
+#include <asm/kmap_types.h>
+#endif
+
+#define __fix_to_virt(x)	(FIXADDR_TOP - ((x) << PAGE_SHIFT))
+#define __virt_to_fix(x)	((FIXADDR_TOP - ((x)&PAGE_MASK)) >> PAGE_SHIFT)
+
+/*
+ * Here we define all the compile-time 'special' virtual
+ * addresses. The point is to have a constant address at
+ * compile time, but to set the physical address only
+ * in the boot process. We allocate these special addresses
+ * from the end of supervisor virtual memory backwards.
+ * Also this lets us do fail-safe vmalloc(), we
+ * can guarantee that these special addresses and
+ * vmalloc()-ed addresses never overlap.
+ *
+ * these 'compile-time allocated' memory buffers are
+ * fixed-size 4k pages. (or larger if used with an increment
+ * higher than 1) use fixmap_set(idx,phys) to associate
+ * physical memory with fixmap indices.
+ *
+ * TLB entries of such buffers will not be flushed across
+ * task switches.
+ *
+ * We don't bother with a FIX_HOLE since above the fixmaps
+ * is unmapped memory in any case.
+ */
+enum fixed_addresses {
+#ifdef CONFIG_HIGHMEM
+	FIX_KMAP_BEGIN,	/* reserved pte's for temporary kernel mappings */
+	FIX_KMAP_END = FIX_KMAP_BEGIN+(KM_TYPE_NR*NR_CPUS)-1,
+#endif
+	__end_of_permanent_fixed_addresses,
+
+	/*
+	 * Temporary boot-time mappings, used before ioremap() is functional.
+	 * Not currently needed by the Tile architecture.
+	 */
+#define NR_FIX_BTMAPS	0
+#if NR_FIX_BTMAPS
+	FIX_BTMAP_END = __end_of_permanent_fixed_addresses,
+	FIX_BTMAP_BEGIN = FIX_BTMAP_END + NR_FIX_BTMAPS - 1,
+	__end_of_fixed_addresses
+#else
+	__end_of_fixed_addresses = __end_of_permanent_fixed_addresses
+#endif
+};
+
+extern void __set_fixmap(enum fixed_addresses idx,
+			 unsigned long phys, pgprot_t flags);
+
+#define set_fixmap(idx, phys) \
+		__set_fixmap(idx, phys, PAGE_KERNEL)
+/*
+ * Some hardware wants to get fixmapped without caching.
+ */
+#define set_fixmap_nocache(idx, phys) \
+		__set_fixmap(idx, phys, PAGE_KERNEL_NOCACHE)
+
+#define clear_fixmap(idx) \
+		__set_fixmap(idx, 0, __pgprot(0))
+
+#define __FIXADDR_SIZE	(__end_of_permanent_fixed_addresses << PAGE_SHIFT)
+#define __FIXADDR_BOOT_SIZE	(__end_of_fixed_addresses << PAGE_SHIFT)
+#define FIXADDR_START		(FIXADDR_TOP + PAGE_SIZE - __FIXADDR_SIZE)
+#define FIXADDR_BOOT_START	(FIXADDR_TOP + PAGE_SIZE - __FIXADDR_BOOT_SIZE)
+
+extern void __this_fixmap_does_not_exist(void);
+
+/*
+ * 'index to address' translation. If anyone tries to use the idx
+ * directly without tranlation, we catch the bug with a NULL-deference
+ * kernel oops. Illegal ranges of incoming indices are caught too.
+ */
+static __always_inline unsigned long fix_to_virt(const unsigned int idx)
+{
+	/*
+	 * this branch gets completely eliminated after inlining,
+	 * except when someone tries to use fixaddr indices in an
+	 * illegal way. (such as mixing up address types or using
+	 * out-of-range indices).
+	 *
+	 * If it doesn't get removed, the linker will complain
+	 * loudly with a reasonably clear error message..
+	 */
+	if (idx >= __end_of_fixed_addresses)
+		__this_fixmap_does_not_exist();
+
+	return __fix_to_virt(idx);
+}
+
+static inline unsigned long virt_to_fix(const unsigned long vaddr)
+{
+	BUG_ON(vaddr >= FIXADDR_TOP || vaddr < FIXADDR_START);
+	return __virt_to_fix(vaddr);
+}
+
+#endif /* !__ASSEMBLY__ */
+
+#endif /* _ASM_TILE_FIXMAP_H */
diff --git a/arch/tile/include/asm/ftrace.h b/arch/tile/include/asm/ftrace.h
new file mode 100644
index 0000000..461459b
--- /dev/null
+++ b/arch/tile/include/asm/ftrace.h
@@ -0,0 +1,20 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_FTRACE_H
+#define _ASM_TILE_FTRACE_H
+
+/* empty */
+
+#endif /* _ASM_TILE_FTRACE_H */
diff --git a/arch/tile/include/asm/futex.h b/arch/tile/include/asm/futex.h
new file mode 100644
index 0000000..9eaeb3c
--- /dev/null
+++ b/arch/tile/include/asm/futex.h
@@ -0,0 +1,136 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ *
+ * These routines make two important assumptions:
+ *
+ * 1. atomic_t is really an int and can be freely cast back and forth
+ *    (validated in __init_atomic_per_cpu).
+ *
+ * 2. userspace uses sys_cmpxchg() for all atomic operations, thus using
+ *    the same locking convention that all the kernel atomic routines use.
+ */
+
+#ifndef _ASM_TILE_FUTEX_H
+#define _ASM_TILE_FUTEX_H
+
+#ifndef __ASSEMBLY__
+
+#include <linux/futex.h>
+#include <linux/uaccess.h>
+#include <linux/errno.h>
+
+extern struct __get_user futex_set(int *v, int i);
+extern struct __get_user futex_add(int *v, int n);
+extern struct __get_user futex_or(int *v, int n);
+extern struct __get_user futex_andn(int *v, int n);
+extern struct __get_user futex_cmpxchg(int *v, int o, int n);
+
+#ifndef __tilegx__
+extern struct __get_user futex_xor(int *v, int n);
+#else
+static inline struct __get_user futex_xor(int __user *uaddr, int n)
+{
+	struct __get_user asm_ret = __get_user_4(uaddr);
+	if (!asm_ret.err) {
+		int oldval, newval;
+		do {
+			oldval = asm_ret.val;
+			newval = oldval ^ n;
+			asm_ret = futex_cmpxchg(uaddr, oldval, newval);
+		} while (asm_ret.err == 0 && oldval != asm_ret.val);
+	}
+	return asm_ret;
+}
+#endif
+
+static inline int futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
+{
+	int op = (encoded_op >> 28) & 7;
+	int cmp = (encoded_op >> 24) & 15;
+	int oparg = (encoded_op << 8) >> 20;
+	int cmparg = (encoded_op << 20) >> 20;
+	int ret;
+	struct __get_user asm_ret;
+
+	if (encoded_op & (FUTEX_OP_OPARG_SHIFT << 28))
+		oparg = 1 << oparg;
+
+	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
+		return -EFAULT;
+
+	pagefault_disable();
+	switch (op) {
+	case FUTEX_OP_SET:
+		asm_ret = futex_set(uaddr, oparg);
+		break;
+	case FUTEX_OP_ADD:
+		asm_ret = futex_add(uaddr, oparg);
+		break;
+	case FUTEX_OP_OR:
+		asm_ret = futex_or(uaddr, oparg);
+		break;
+	case FUTEX_OP_ANDN:
+		asm_ret = futex_andn(uaddr, oparg);
+		break;
+	case FUTEX_OP_XOR:
+		asm_ret = futex_xor(uaddr, oparg);
+		break;
+	default:
+		asm_ret.err = -ENOSYS;
+	}
+	pagefault_enable();
+
+	ret = asm_ret.err;
+
+	if (!ret) {
+		switch (cmp) {
+		case FUTEX_OP_CMP_EQ:
+			ret = (asm_ret.val == cmparg);
+			break;
+		case FUTEX_OP_CMP_NE:
+			ret = (asm_ret.val != cmparg);
+			break;
+		case FUTEX_OP_CMP_LT:
+			ret = (asm_ret.val < cmparg);
+			break;
+		case FUTEX_OP_CMP_GE:
+			ret = (asm_ret.val >= cmparg);
+			break;
+		case FUTEX_OP_CMP_LE:
+			ret = (asm_ret.val <= cmparg);
+			break;
+		case FUTEX_OP_CMP_GT:
+			ret = (asm_ret.val > cmparg);
+			break;
+		default:
+			ret = -ENOSYS;
+		}
+	}
+	return ret;
+}
+
+static inline int futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval,
+						int newval)
+{
+	struct __get_user asm_ret;
+
+	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
+		return -EFAULT;
+
+	asm_ret = futex_cmpxchg(uaddr, oldval, newval);
+	return asm_ret.err ? asm_ret.err : asm_ret.val;
+}
+
+#endif /* !__ASSEMBLY__ */
+
+#endif /* _ASM_TILE_FUTEX_H */
diff --git a/arch/tile/include/asm/hardirq.h b/arch/tile/include/asm/hardirq.h
new file mode 100644
index 0000000..822390f
--- /dev/null
+++ b/arch/tile/include/asm/hardirq.h
@@ -0,0 +1,47 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_HARDIRQ_H
+#define _ASM_TILE_HARDIRQ_H
+
+#include <linux/threads.h>
+#include <linux/cache.h>
+
+#include <asm/irq.h>
+
+typedef struct {
+	unsigned int __softirq_pending;
+	long idle_timestamp;
+
+	/* Hard interrupt statistics. */
+	unsigned int irq_timer_count;
+	unsigned int irq_syscall_count;
+	unsigned int irq_resched_count;
+	unsigned int irq_hv_flush_count;
+	unsigned int irq_call_count;
+	unsigned int irq_hv_msg_count;
+	unsigned int irq_dev_intr_count;
+
+} ____cacheline_aligned irq_cpustat_t;
+
+DECLARE_PER_CPU(irq_cpustat_t, irq_stat);
+
+#define __ARCH_IRQ_STAT
+#define __IRQ_STAT(cpu, member) (per_cpu(irq_stat, cpu).member)
+
+#include <linux/irq_cpustat.h>	/* Standard mappings for irq_cpustat_t above */
+
+#define HARDIRQ_BITS	8
+
+#endif /* _ASM_TILE_HARDIRQ_H */
diff --git a/arch/tile/include/asm/highmem.h b/arch/tile/include/asm/highmem.h
new file mode 100644
index 0000000..efdd12e
--- /dev/null
+++ b/arch/tile/include/asm/highmem.h
@@ -0,0 +1,73 @@
+/*
+ * Copyright (C) 1999 Gerhard Wichert, Siemens AG
+ *                   Gerhard.Wichert@pdb.siemens.de
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ *
+ * Used in CONFIG_HIGHMEM systems for memory pages which
+ * are not addressable by direct kernel virtual addresses.
+ *
+ */
+
+#ifndef _ASM_TILE_HIGHMEM_H
+#define _ASM_TILE_HIGHMEM_H
+
+#include <linux/interrupt.h>
+#include <linux/threads.h>
+#include <asm/kmap_types.h>
+#include <asm/tlbflush.h>
+#include <asm/homecache.h>
+
+/* declarations for highmem.c */
+extern unsigned long highstart_pfn, highend_pfn;
+
+extern pte_t *pkmap_page_table;
+
+/*
+ * Ordering is:
+ *
+ * FIXADDR_TOP
+ *			fixed_addresses
+ * FIXADDR_START
+ *			temp fixed addresses
+ * FIXADDR_BOOT_START
+ *			Persistent kmap area
+ * PKMAP_BASE
+ * VMALLOC_END
+ *			Vmalloc area
+ * VMALLOC_START
+ * high_memory
+ */
+#define LAST_PKMAP_MASK (LAST_PKMAP-1)
+#define PKMAP_NR(virt)  ((virt-PKMAP_BASE) >> PAGE_SHIFT)
+#define PKMAP_ADDR(nr)  (PKMAP_BASE + ((nr) << PAGE_SHIFT))
+
+void *kmap_high(struct page *page);
+void kunmap_high(struct page *page);
+void *kmap(struct page *page);
+void kunmap(struct page *page);
+void *kmap_fix_kpte(struct page *page, int finished);
+
+/* This macro is used only in map_new_virtual() to map "page". */
+#define kmap_prot page_to_kpgprot(page)
+
+void kunmap_atomic(void *kvaddr, enum km_type type);
+void *kmap_atomic_pfn(unsigned long pfn, enum km_type type);
+void *kmap_atomic_prot_pfn(unsigned long pfn, enum km_type type, pgprot_t prot);
+struct page *kmap_atomic_to_page(void *ptr);
+void *kmap_atomic_prot(struct page *page, enum km_type type, pgprot_t prot);
+void *kmap_atomic(struct page *page, enum km_type type);
+void kmap_atomic_fix_kpte(struct page *page, int finished);
+
+#define flush_cache_kmaps()	do { } while (0)
+
+#endif /* _ASM_TILE_HIGHMEM_H */
diff --git a/arch/tile/include/asm/homecache.h b/arch/tile/include/asm/homecache.h
new file mode 100644
index 0000000..a824386
--- /dev/null
+++ b/arch/tile/include/asm/homecache.h
@@ -0,0 +1,125 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ *
+ * Handle issues around the Tile "home cache" model of coherence.
+ */
+
+#ifndef _ASM_TILE_HOMECACHE_H
+#define _ASM_TILE_HOMECACHE_H
+
+#include <asm/page.h>
+#include <linux/cpumask.h>
+
+struct page;
+struct task_struct;
+struct vm_area_struct;
+struct zone;
+
+/*
+ * Coherence point for the page is its memory controller.
+ * It is not present in any cache (L1 or L2).
+ */
+#define PAGE_HOME_UNCACHED -1
+
+/*
+ * Is this page immutable (unwritable) and thus able to be cached more
+ * widely than would otherwise be possible?  On tile64 this means we
+ * mark the PTE to cache locally; on tilepro it means we have "nc" set.
+ */
+#define PAGE_HOME_IMMUTABLE -2
+
+/*
+ * Each cpu considers its own cache to be the home for the page,
+ * which makes it incoherent.
+ */
+#define PAGE_HOME_INCOHERENT -3
+
+#if CHIP_HAS_CBOX_HOME_MAP()
+/* Home for the page is distributed via hash-for-home. */
+#define PAGE_HOME_HASH -4
+#endif
+
+/* Homing is unknown or unspecified.  Not valid for page_home(). */
+#define PAGE_HOME_UNKNOWN -5
+
+/* Home on the current cpu.  Not valid for page_home(). */
+#define PAGE_HOME_HERE -6
+
+/* Support wrapper to use instead of explicit hv_flush_remote(). */
+extern void flush_remote(unsigned long cache_pfn, unsigned long cache_length,
+			 const struct cpumask *cache_cpumask,
+			 HV_VirtAddr tlb_va, unsigned long tlb_length,
+			 unsigned long tlb_pgsize,
+			 const struct cpumask *tlb_cpumask,
+			 HV_Remote_ASID *asids, int asidcount);
+
+/* Set homing-related bits in a PTE (can also pass a pgprot_t). */
+extern pte_t pte_set_home(pte_t pte, int home);
+
+/* Do a cache eviction on the specified cpus. */
+extern void homecache_evict(const struct cpumask *mask);
+
+/*
+ * Change a kernel page's homecache.  It must not be mapped in user space.
+ * If !CONFIG_HOMECACHE, only usable on LOWMEM, and can only be called when
+ * no other cpu can reference the page, and causes a full-chip cache/TLB flush.
+ */
+extern void homecache_change_page_home(struct page *, int order, int home);
+
+/*
+ * Flush a page out of whatever cache(s) it is in.
+ * This is more than just finv, since it properly handles waiting
+ * for the data to reach memory on tilepro, but it can be quite
+ * heavyweight, particularly on hash-for-home memory.
+ */
+extern void homecache_flush_cache(struct page *, int order);
+
+/*
+ * Allocate a page with the given GFP flags, home, and optionally
+ * node.  These routines are actually just wrappers around the normal
+ * alloc_pages() / alloc_pages_node() functions, which set and clear
+ * a per-cpu variable to communicate with homecache_new_kernel_page().
+ * If !CONFIG_HOMECACHE, uses homecache_change_page_home().
+ */
+extern struct page *homecache_alloc_pages(gfp_t gfp_mask,
+					  unsigned int order, int home);
+extern struct page *homecache_alloc_pages_node(int nid, gfp_t gfp_mask,
+					       unsigned int order, int home);
+#define homecache_alloc_page(gfp_mask, home) \
+  homecache_alloc_pages(gfp_mask, 0, home)
+
+/*
+ * These routines are just pass-throughs to free_pages() when
+ * we support full homecaching.  If !CONFIG_HOMECACHE, then these
+ * routines use homecache_change_page_home() to reset the home
+ * back to the default before returning the page to the allocator.
+ */
+void homecache_free_pages(unsigned long addr, unsigned int order);
+#define homecache_free_page(page) \
+  homecache_free_pages((page), 0)
+
+
+
+/*
+ * Report the page home for LOWMEM pages by examining their kernel PTE,
+ * or for highmem pages as the default home.
+ */
+extern int page_home(struct page *);
+
+#define homecache_migrate_kthread() do {} while (0)
+
+#define homecache_kpte_lock() 0
+#define homecache_kpte_unlock(flags) do {} while (0)
+
+
+#endif /* _ASM_TILE_HOMECACHE_H */
diff --git a/arch/tile/include/asm/hugetlb.h b/arch/tile/include/asm/hugetlb.h
new file mode 100644
index 0000000..0521c27
--- /dev/null
+++ b/arch/tile/include/asm/hugetlb.h
@@ -0,0 +1,109 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_HUGETLB_H
+#define _ASM_TILE_HUGETLB_H
+
+#include <asm/page.h>
+
+
+static inline int is_hugepage_only_range(struct mm_struct *mm,
+					 unsigned long addr,
+					 unsigned long len) {
+	return 0;
+}
+
+/*
+ * If the arch doesn't supply something else, assume that hugepage
+ * size aligned regions are ok without further preparation.
+ */
+static inline int prepare_hugepage_range(struct file *file,
+					 unsigned long addr, unsigned long len)
+{
+	struct hstate *h = hstate_file(file);
+	if (len & ~huge_page_mask(h))
+		return -EINVAL;
+	if (addr & ~huge_page_mask(h))
+		return -EINVAL;
+	return 0;
+}
+
+static inline void hugetlb_prefault_arch_hook(struct mm_struct *mm)
+{
+}
+
+static inline void hugetlb_free_pgd_range(struct mmu_gather *tlb,
+					  unsigned long addr, unsigned long end,
+					  unsigned long floor,
+					  unsigned long ceiling)
+{
+	free_pgd_range(tlb, addr, end, floor, ceiling);
+}
+
+static inline void set_huge_pte_at(struct mm_struct *mm, unsigned long addr,
+				   pte_t *ptep, pte_t pte)
+{
+	set_pte_order(ptep, pte, HUGETLB_PAGE_ORDER);
+}
+
+static inline pte_t huge_ptep_get_and_clear(struct mm_struct *mm,
+					    unsigned long addr, pte_t *ptep)
+{
+	return ptep_get_and_clear(mm, addr, ptep);
+}
+
+static inline void huge_ptep_clear_flush(struct vm_area_struct *vma,
+					 unsigned long addr, pte_t *ptep)
+{
+	ptep_clear_flush(vma, addr, ptep);
+}
+
+static inline int huge_pte_none(pte_t pte)
+{
+	return pte_none(pte);
+}
+
+static inline pte_t huge_pte_wrprotect(pte_t pte)
+{
+	return pte_wrprotect(pte);
+}
+
+static inline void huge_ptep_set_wrprotect(struct mm_struct *mm,
+					   unsigned long addr, pte_t *ptep)
+{
+	ptep_set_wrprotect(mm, addr, ptep);
+}
+
+static inline int huge_ptep_set_access_flags(struct vm_area_struct *vma,
+					     unsigned long addr, pte_t *ptep,
+					     pte_t pte, int dirty)
+{
+	return ptep_set_access_flags(vma, addr, ptep, pte, dirty);
+}
+
+static inline pte_t huge_ptep_get(pte_t *ptep)
+{
+	return *ptep;
+}
+
+static inline int arch_prepare_hugepage(struct page *page)
+{
+	return 0;
+}
+
+static inline void arch_release_hugepage(struct page *page)
+{
+}
+
+#endif /* _ASM_TILE_HUGETLB_H */
diff --git a/arch/tile/include/asm/hv_driver.h b/arch/tile/include/asm/hv_driver.h
new file mode 100644
index 0000000..ad614de
--- /dev/null
+++ b/arch/tile/include/asm/hv_driver.h
@@ -0,0 +1,60 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ *
+ * This header defines a wrapper interface for managing hypervisor
+ * device calls that will result in an interrupt at some later time.
+ * In particular, this provides wrappers for hv_preada() and
+ * hv_pwritea().
+ */
+
+#ifndef _ASM_TILE_HV_DRIVER_H
+#define _ASM_TILE_HV_DRIVER_H
+
+#include <hv/hypervisor.h>
+
+struct hv_driver_cb;
+
+/* A callback to be invoked when an operation completes. */
+typedef void hv_driver_callback_t(struct hv_driver_cb *cb, __hv32 result);
+
+/*
+ * A structure to hold information about an outstanding call.
+ * The driver must allocate a separate structure for each call.
+ */
+struct hv_driver_cb {
+	hv_driver_callback_t *callback;  /* Function to call on interrupt. */
+	void *dev;                       /* Driver-specific state variable. */
+};
+
+/* Wrapper for invoking hv_dev_preada(). */
+static inline int
+tile_hv_dev_preada(int devhdl, __hv32 flags, __hv32 sgl_len,
+		   HV_SGL sgl[/* sgl_len */], __hv64 offset,
+		   struct hv_driver_cb *callback)
+{
+	return hv_dev_preada(devhdl, flags, sgl_len, sgl,
+			     offset, (HV_IntArg)callback);
+}
+
+/* Wrapper for invoking hv_dev_pwritea(). */
+static inline int
+tile_hv_dev_pwritea(int devhdl, __hv32 flags, __hv32 sgl_len,
+		    HV_SGL sgl[/* sgl_len */], __hv64 offset,
+		    struct hv_driver_cb *callback)
+{
+	return hv_dev_pwritea(devhdl, flags, sgl_len, sgl,
+			      offset, (HV_IntArg)callback);
+}
+
+
+#endif /* _ASM_TILE_HV_DRIVER_H */
diff --git a/arch/tile/include/asm/hw_irq.h b/arch/tile/include/asm/hw_irq.h
new file mode 100644
index 0000000..4fac5fb
--- /dev/null
+++ b/arch/tile/include/asm/hw_irq.h
@@ -0,0 +1,18 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_HW_IRQ_H
+#define _ASM_TILE_HW_IRQ_H
+
+#endif /* _ASM_TILE_HW_IRQ_H */
diff --git a/arch/tile/include/asm/ide.h b/arch/tile/include/asm/ide.h
new file mode 100644
index 0000000..3c6f2ed
--- /dev/null
+++ b/arch/tile/include/asm/ide.h
@@ -0,0 +1,25 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_IDE_H
+#define _ASM_TILE_IDE_H
+
+/* For IDE on PCI */
+#define MAX_HWIFS       10
+
+#define ide_default_io_ctl(base)	(0)
+
+#include <asm-generic/ide_iops.h>
+
+#endif /* _ASM_TILE_IDE_H */
diff --git a/arch/tile/include/asm/io.h b/arch/tile/include/asm/io.h
new file mode 100644
index 0000000..f6fcf18
--- /dev/null
+++ b/arch/tile/include/asm/io.h
@@ -0,0 +1,220 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_IO_H
+#define _ASM_TILE_IO_H
+
+#include <linux/kernel.h>
+#include <linux/bug.h>
+#include <asm/page.h>
+
+#define IO_SPACE_LIMIT 0xfffffffful
+
+/*
+ * Convert a physical pointer to a virtual kernel pointer for /dev/mem
+ * access.
+ */
+#define xlate_dev_mem_ptr(p)	__va(p)
+
+/*
+ * Convert a virtual cached pointer to an uncached pointer.
+ */
+#define xlate_dev_kmem_ptr(p)	p
+
+/*
+ * Change "struct page" to physical address.
+ */
+#define page_to_phys(page)    ((dma_addr_t)page_to_pfn(page) << PAGE_SHIFT)
+
+/*
+ * Some places try to pass in an loff_t for PHYSADDR (?!), so we cast it to
+ * long before casting it to a pointer to avoid compiler warnings.
+ */
+#if CHIP_HAS_MMIO()
+extern void __iomem *ioremap(resource_size_t offset, unsigned long size);
+extern void __iomem *ioremap_prot(resource_size_t offset, unsigned long size,
+	pgprot_t pgprot);
+extern void iounmap(volatile void __iomem *addr);
+#else
+#define ioremap(physaddr, size)	((void __iomem *)(unsigned long)(physaddr))
+#define iounmap(addr)		((void)0)
+#endif
+
+#define ioremap_nocache(physaddr, size)		ioremap(physaddr, size)
+#define ioremap_writethrough(physaddr, size)	ioremap(physaddr, size)
+#define ioremap_fullcache(physaddr, size)	ioremap(physaddr, size)
+
+void __iomem *ioport_map(unsigned long port, unsigned int len);
+extern inline void ioport_unmap(void __iomem *addr) {}
+
+#define mmiowb()
+
+/* Conversion between virtual and physical mappings.  */
+#define mm_ptov(addr)		((void *)phys_to_virt(addr))
+#define mm_vtop(addr)		((unsigned long)virt_to_phys(addr))
+
+#ifdef CONFIG_PCI
+
+extern u8 _tile_readb(unsigned long addr);
+extern u16 _tile_readw(unsigned long addr);
+extern u32 _tile_readl(unsigned long addr);
+extern u64 _tile_readq(unsigned long addr);
+extern void _tile_writeb(u8  val, unsigned long addr);
+extern void _tile_writew(u16 val, unsigned long addr);
+extern void _tile_writel(u32 val, unsigned long addr);
+extern void _tile_writeq(u64 val, unsigned long addr);
+
+#define readb(addr) _tile_readb((unsigned long)addr)
+#define readw(addr) _tile_readw((unsigned long)addr)
+#define readl(addr) _tile_readl((unsigned long)addr)
+#define readq(addr) _tile_readq((unsigned long)addr)
+#define writeb(val, addr) _tile_writeb(val, (unsigned long)addr)
+#define writew(val, addr) _tile_writew(val, (unsigned long)addr)
+#define writel(val, addr) _tile_writel(val, (unsigned long)addr)
+#define writeq(val, addr) _tile_writeq(val, (unsigned long)addr)
+
+#define __raw_readb readb
+#define __raw_readw readw
+#define __raw_readl readl
+#define __raw_readq readq
+#define __raw_writeb writeb
+#define __raw_writew writew
+#define __raw_writel writel
+#define __raw_writeq writeq
+
+#define readb_relaxed readb
+#define readw_relaxed readw
+#define readl_relaxed readl
+#define readq_relaxed readq
+
+#define ioread8 readb
+#define ioread16 readw
+#define ioread32 readl
+#define ioread64 readq
+#define iowrite8 writeb
+#define iowrite16 writew
+#define iowrite32 writel
+#define iowrite64 writeq
+
+static inline void *memcpy_fromio(void *dst, void *src, int len)
+{
+	int x;
+	BUG_ON((unsigned long)src & 0x3);
+	for (x = 0; x < len; x += 4)
+		*(u32 *)(dst + x) = readl(src + x);
+	return dst;
+}
+
+static inline void *memcpy_toio(void *dst, void *src, int len)
+{
+	int x;
+	BUG_ON((unsigned long)dst & 0x3);
+	for (x = 0; x < len; x += 4)
+		writel(*(u32 *)(src + x), dst + x);
+	return dst;
+}
+
+#endif
+
+/*
+ * The Tile architecture does not support IOPORT, even with PCI.
+ * Unfortunately we can't yet simply not declare these methods,
+ * since some generic code that compiles into the kernel, but
+ * we never run, uses them unconditionally.
+ */
+
+extern int ioport_panic(void);
+
+static inline u8 inb(unsigned long addr)
+{
+	return ioport_panic();
+}
+
+static inline u16 inw(unsigned long addr)
+{
+	return ioport_panic();
+}
+
+static inline u32 inl(unsigned long addr)
+{
+	return ioport_panic();
+}
+
+static inline void outb(u8 b, unsigned long addr)
+{
+	ioport_panic();
+}
+
+static inline void outw(u16 b, unsigned long addr)
+{
+	ioport_panic();
+}
+
+static inline void outl(u32 b, unsigned long addr)
+{
+	ioport_panic();
+}
+
+#define inb_p(addr)	inb(addr)
+#define inw_p(addr)	inw(addr)
+#define inl_p(addr)	inl(addr)
+#define outb_p(x, addr)	outb((x), (addr))
+#define outw_p(x, addr)	outw((x), (addr))
+#define outl_p(x, addr)	outl((x), (addr))
+
+static inline void insb(unsigned long addr, void *buffer, int count)
+{
+	ioport_panic();
+}
+
+static inline void insw(unsigned long addr, void *buffer, int count)
+{
+	ioport_panic();
+}
+
+static inline void insl(unsigned long addr, void *buffer, int count)
+{
+	ioport_panic();
+}
+
+static inline void outsb(unsigned long addr, const void *buffer, int count)
+{
+	ioport_panic();
+}
+
+static inline void outsw(unsigned long addr, const void *buffer, int count)
+{
+	ioport_panic();
+}
+
+static inline void outsl(unsigned long addr, const void *buffer, int count)
+{
+	ioport_panic();
+}
+
+#define ioread8_rep(p, dst, count) \
+	insb((unsigned long) (p), (dst), (count))
+#define ioread16_rep(p, dst, count) \
+	insw((unsigned long) (p), (dst), (count))
+#define ioread32_rep(p, dst, count) \
+	insl((unsigned long) (p), (dst), (count))
+
+#define iowrite8_rep(p, src, count) \
+	outsb((unsigned long) (p), (src), (count))
+#define iowrite16_rep(p, src, count) \
+	outsw((unsigned long) (p), (src), (count))
+#define iowrite32_rep(p, src, count) \
+	outsl((unsigned long) (p), (src), (count))
+
+#endif /* _ASM_TILE_IO_H */
diff --git a/arch/tile/include/asm/ioctl.h b/arch/tile/include/asm/ioctl.h
new file mode 100644
index 0000000..b279fe0
--- /dev/null
+++ b/arch/tile/include/asm/ioctl.h
@@ -0,0 +1 @@
+#include <asm-generic/ioctl.h>
diff --git a/arch/tile/include/asm/ioctls.h b/arch/tile/include/asm/ioctls.h
new file mode 100644
index 0000000..ec34c76
--- /dev/null
+++ b/arch/tile/include/asm/ioctls.h
@@ -0,0 +1 @@
+#include <asm-generic/ioctls.h>
diff --git a/arch/tile/include/asm/ipc.h b/arch/tile/include/asm/ipc.h
new file mode 100644
index 0000000..a46e3d9
--- /dev/null
+++ b/arch/tile/include/asm/ipc.h
@@ -0,0 +1 @@
+#include <asm-generic/ipc.h>
diff --git a/arch/tile/include/asm/ipcbuf.h b/arch/tile/include/asm/ipcbuf.h
new file mode 100644
index 0000000..84c7e51
--- /dev/null
+++ b/arch/tile/include/asm/ipcbuf.h
@@ -0,0 +1 @@
+#include <asm-generic/ipcbuf.h>
diff --git a/arch/tile/include/asm/irq.h b/arch/tile/include/asm/irq.h
new file mode 100644
index 0000000..9be1f84
--- /dev/null
+++ b/arch/tile/include/asm/irq.h
@@ -0,0 +1,37 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_IRQ_H
+#define _ASM_TILE_IRQ_H
+
+#include <linux/hardirq.h>
+
+/* The hypervisor interface provides 32 IRQs. */
+#define NR_IRQS 32
+
+/* IRQ numbers used for linux IPIs. */
+#define IRQ_RESCHEDULE 1
+
+/* The HV interrupt state object. */
+DECLARE_PER_CPU(HV_IntrState, dev_intr_state);
+
+void ack_bad_irq(unsigned int irq);
+
+/*
+ * Paravirtualized drivers should call this when their init calls
+ * discover a valid HV IRQ.
+ */
+void tile_irq_activate(unsigned int irq);
+
+#endif /* _ASM_TILE_IRQ_H */
diff --git a/arch/tile/include/asm/irq_regs.h b/arch/tile/include/asm/irq_regs.h
new file mode 100644
index 0000000..3dd9c0b
--- /dev/null
+++ b/arch/tile/include/asm/irq_regs.h
@@ -0,0 +1 @@
+#include <asm-generic/irq_regs.h>
diff --git a/arch/tile/include/asm/irqflags.h b/arch/tile/include/asm/irqflags.h
new file mode 100644
index 0000000..cf5bffd
--- /dev/null
+++ b/arch/tile/include/asm/irqflags.h
@@ -0,0 +1,267 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_IRQFLAGS_H
+#define _ASM_TILE_IRQFLAGS_H
+
+#include <asm/processor.h>
+#include <arch/interrupts.h>
+#include <arch/chip.h>
+
+/*
+ * The set of interrupts we want to allow when interrupts are nominally
+ * disabled.  The remainder are effectively "NMI" interrupts from
+ * the point of view of the generic Linux code.  Note that synchronous
+ * interrupts (aka "non-queued") are not blocked by the mask in any case.
+ */
+#if CHIP_HAS_AUX_PERF_COUNTERS()
+#define LINUX_MASKABLE_INTERRUPTS \
+	(~(INT_MASK(INT_PERF_COUNT) | INT_MASK(INT_AUX_PERF_COUNT)))
+#else
+#define LINUX_MASKABLE_INTERRUPTS \
+	(~(INT_MASK(INT_PERF_COUNT)))
+#endif
+
+#ifndef __ASSEMBLY__
+
+/* NOTE: we can't include <linux/percpu.h> due to #include dependencies. */
+#include <asm/percpu.h>
+#include <arch/spr_def.h>
+
+/* Set and clear kernel interrupt masks. */
+#if CHIP_HAS_SPLIT_INTR_MASK()
+#if INT_PERF_COUNT < 32 || INT_AUX_PERF_COUNT < 32 || INT_MEM_ERROR >= 32
+# error Fix assumptions about which word various interrupts are in
+#endif
+#define interrupt_mask_set(n) do { \
+	int __n = (n); \
+	int __mask = 1 << (__n & 0x1f); \
+	if (__n < 32) \
+		__insn_mtspr(SPR_INTERRUPT_MASK_SET_1_0, __mask); \
+	else \
+		__insn_mtspr(SPR_INTERRUPT_MASK_SET_1_1, __mask); \
+} while (0)
+#define interrupt_mask_reset(n) do { \
+	int __n = (n); \
+	int __mask = 1 << (__n & 0x1f); \
+	if (__n < 32) \
+		__insn_mtspr(SPR_INTERRUPT_MASK_RESET_1_0, __mask); \
+	else \
+		__insn_mtspr(SPR_INTERRUPT_MASK_RESET_1_1, __mask); \
+} while (0)
+#define interrupt_mask_check(n) ({ \
+	int __n = (n); \
+	(((__n < 32) ? \
+	 __insn_mfspr(SPR_INTERRUPT_MASK_1_0) : \
+	 __insn_mfspr(SPR_INTERRUPT_MASK_1_1)) \
+	  >> (__n & 0x1f)) & 1; \
+})
+#define interrupt_mask_set_mask(mask) do { \
+	unsigned long long __m = (mask); \
+	__insn_mtspr(SPR_INTERRUPT_MASK_SET_1_0, (unsigned long)(__m)); \
+	__insn_mtspr(SPR_INTERRUPT_MASK_SET_1_1, (unsigned long)(__m>>32)); \
+} while (0)
+#define interrupt_mask_reset_mask(mask) do { \
+	unsigned long long __m = (mask); \
+	__insn_mtspr(SPR_INTERRUPT_MASK_RESET_1_0, (unsigned long)(__m)); \
+	__insn_mtspr(SPR_INTERRUPT_MASK_RESET_1_1, (unsigned long)(__m>>32)); \
+} while (0)
+#else
+#define interrupt_mask_set(n) \
+	__insn_mtspr(SPR_INTERRUPT_MASK_SET_1, (1UL << (n)))
+#define interrupt_mask_reset(n) \
+	__insn_mtspr(SPR_INTERRUPT_MASK_RESET_1, (1UL << (n)))
+#define interrupt_mask_check(n) \
+	((__insn_mfspr(SPR_INTERRUPT_MASK_1) >> (n)) & 1)
+#define interrupt_mask_set_mask(mask) \
+	__insn_mtspr(SPR_INTERRUPT_MASK_SET_1, (mask))
+#define interrupt_mask_reset_mask(mask) \
+	__insn_mtspr(SPR_INTERRUPT_MASK_RESET_1, (mask))
+#endif
+
+/*
+ * The set of interrupts we want active if irqs are enabled.
+ * Note that in particular, the tile timer interrupt comes and goes
+ * from this set, since we have no other way to turn off the timer.
+ * Likewise, INTCTRL_1 is removed and re-added during device
+ * interrupts, as is the the hardwall UDN_FIREWALL interrupt.
+ * We use a low bit (MEM_ERROR) as our sentinel value and make sure it
+ * is always claimed as an "active interrupt" so we can query that bit
+ * to know our current state.
+ */
+DECLARE_PER_CPU(unsigned long long, interrupts_enabled_mask);
+#define INITIAL_INTERRUPTS_ENABLED INT_MASK(INT_MEM_ERROR)
+
+/* Disable interrupts. */
+#define raw_local_irq_disable() \
+	interrupt_mask_set_mask(LINUX_MASKABLE_INTERRUPTS)
+
+/* Disable all interrupts, including NMIs. */
+#define raw_local_irq_disable_all() \
+	interrupt_mask_set_mask(-1UL)
+
+/* Re-enable all maskable interrupts. */
+#define raw_local_irq_enable() \
+	interrupt_mask_reset_mask(__get_cpu_var(interrupts_enabled_mask))
+
+/* Disable or enable interrupts based on flag argument. */
+#define raw_local_irq_restore(disabled) do { \
+	if (disabled) \
+		raw_local_irq_disable(); \
+	else \
+		raw_local_irq_enable(); \
+} while (0)
+
+/* Return true if "flags" argument means interrupts are disabled. */
+#define raw_irqs_disabled_flags(flags) ((flags) != 0)
+
+/* Return true if interrupts are currently disabled. */
+#define raw_irqs_disabled() interrupt_mask_check(INT_MEM_ERROR)
+
+/* Save whether interrupts are currently disabled. */
+#define raw_local_save_flags(flags) ((flags) = raw_irqs_disabled())
+
+/* Save whether interrupts are currently disabled, then disable them. */
+#define raw_local_irq_save(flags) \
+	do { raw_local_save_flags(flags); raw_local_irq_disable(); } while (0)
+
+/* Prevent the given interrupt from being enabled next time we enable irqs. */
+#define raw_local_irq_mask(interrupt) \
+	(__get_cpu_var(interrupts_enabled_mask) &= ~INT_MASK(interrupt))
+
+/* Prevent the given interrupt from being enabled immediately. */
+#define raw_local_irq_mask_now(interrupt) do { \
+	raw_local_irq_mask(interrupt); \
+	interrupt_mask_set(interrupt); \
+} while (0)
+
+/* Allow the given interrupt to be enabled next time we enable irqs. */
+#define raw_local_irq_unmask(interrupt) \
+	(__get_cpu_var(interrupts_enabled_mask) |= INT_MASK(interrupt))
+
+/* Allow the given interrupt to be enabled immediately, if !irqs_disabled. */
+#define raw_local_irq_unmask_now(interrupt) do { \
+	raw_local_irq_unmask(interrupt); \
+	if (!irqs_disabled()) \
+		interrupt_mask_reset(interrupt); \
+} while (0)
+
+#else /* __ASSEMBLY__ */
+
+/* We provide a somewhat more restricted set for assembly. */
+
+#ifdef __tilegx__
+
+#if INT_MEM_ERROR != 0
+# error Fix IRQ_DISABLED() macro
+#endif
+
+/* Return 0 or 1 to indicate whether interrupts are currently disabled. */
+#define IRQS_DISABLED(tmp)					\
+	mfspr   tmp, INTERRUPT_MASK_1;				\
+	andi    tmp, tmp, 1
+
+/* Load up a pointer to &interrupts_enabled_mask. */
+#define GET_INTERRUPTS_ENABLED_MASK_PTR(reg)			\
+	moveli reg, hw2_last(interrupts_enabled_mask); \
+	shl16insli reg, reg, hw1(interrupts_enabled_mask); \
+	shl16insli reg, reg, hw0(interrupts_enabled_mask); \
+	add     reg, reg, tp
+
+/* Disable interrupts. */
+#define IRQ_DISABLE(tmp0, tmp1)					\
+	moveli  tmp0, hw2_last(LINUX_MASKABLE_INTERRUPTS);	\
+	shl16insli tmp0, tmp0, hw1(LINUX_MASKABLE_INTERRUPTS);	\
+	shl16insli tmp0, tmp0, hw0(LINUX_MASKABLE_INTERRUPTS);	\
+	mtspr   INTERRUPT_MASK_SET_1, tmp0
+
+/* Disable ALL synchronous interrupts (used by NMI entry). */
+#define IRQ_DISABLE_ALL(tmp)					\
+	movei   tmp, -1;					\
+	mtspr   INTERRUPT_MASK_SET_1, tmp
+
+/* Enable interrupts. */
+#define IRQ_ENABLE(tmp0, tmp1)					\
+	GET_INTERRUPTS_ENABLED_MASK_PTR(tmp0);			\
+	ld      tmp0, tmp0;					\
+	mtspr   INTERRUPT_MASK_RESET_1, tmp0
+
+#else /* !__tilegx__ */
+
+/*
+ * Return 0 or 1 to indicate whether interrupts are currently disabled.
+ * Note that it's important that we use a bit from the "low" mask word,
+ * since when we are enabling, that is the word we write first, so if we
+ * are interrupted after only writing half of the mask, the interrupt
+ * handler will correctly observe that we have interrupts enabled, and
+ * will enable interrupts itself on return from the interrupt handler
+ * (making the original code's write of the "high" mask word idempotent).
+ */
+#define IRQS_DISABLED(tmp)					\
+	mfspr   tmp, INTERRUPT_MASK_1_0;			\
+	shri    tmp, tmp, INT_MEM_ERROR;			\
+	andi    tmp, tmp, 1
+
+/* Load up a pointer to &interrupts_enabled_mask. */
+#define GET_INTERRUPTS_ENABLED_MASK_PTR(reg)			\
+	moveli  reg, lo16(interrupts_enabled_mask);	\
+	auli    reg, reg, ha16(interrupts_enabled_mask);\
+	add     reg, reg, tp
+
+/* Disable interrupts. */
+#define IRQ_DISABLE(tmp0, tmp1)					\
+	{							\
+	 movei  tmp0, -1;					\
+	 moveli tmp1, lo16(LINUX_MASKABLE_INTERRUPTS)		\
+	};							\
+	{							\
+	 mtspr  INTERRUPT_MASK_SET_1_0, tmp0;			\
+	 auli   tmp1, tmp1, ha16(LINUX_MASKABLE_INTERRUPTS)	\
+	};							\
+	mtspr   INTERRUPT_MASK_SET_1_1, tmp1
+
+/* Disable ALL synchronous interrupts (used by NMI entry). */
+#define IRQ_DISABLE_ALL(tmp)					\
+	movei   tmp, -1;					\
+	mtspr   INTERRUPT_MASK_SET_1_0, tmp;			\
+	mtspr   INTERRUPT_MASK_SET_1_1, tmp
+
+/* Enable interrupts. */
+#define IRQ_ENABLE(tmp0, tmp1)					\
+	GET_INTERRUPTS_ENABLED_MASK_PTR(tmp0);			\
+	{							\
+	 lw     tmp0, tmp0;					\
+	 addi   tmp1, tmp0, 4					\
+	};							\
+	lw      tmp1, tmp1;					\
+	mtspr   INTERRUPT_MASK_RESET_1_0, tmp0;			\
+	mtspr   INTERRUPT_MASK_RESET_1_1, tmp1
+#endif
+
+/*
+ * Do the CPU's IRQ-state tracing from assembly code. We call a
+ * C function, but almost everywhere we do, we don't mind clobbering
+ * all the caller-saved registers.
+ */
+#ifdef CONFIG_TRACE_IRQFLAGS
+# define TRACE_IRQS_ON  jal trace_hardirqs_on
+# define TRACE_IRQS_OFF jal trace_hardirqs_off
+#else
+# define TRACE_IRQS_ON
+# define TRACE_IRQS_OFF
+#endif
+
+#endif /* __ASSEMBLY__ */
+
+#endif /* _ASM_TILE_IRQFLAGS_H */
diff --git a/arch/tile/include/asm/kdebug.h b/arch/tile/include/asm/kdebug.h
new file mode 100644
index 0000000..6ece1b0
--- /dev/null
+++ b/arch/tile/include/asm/kdebug.h
@@ -0,0 +1 @@
+#include <asm-generic/kdebug.h>
diff --git a/arch/tile/include/asm/kexec.h b/arch/tile/include/asm/kexec.h
new file mode 100644
index 0000000..c11a6cc
--- /dev/null
+++ b/arch/tile/include/asm/kexec.h
@@ -0,0 +1,53 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ *
+ * based on kexec.h from other architectures in linux-2.6.18
+ */
+
+#ifndef _ASM_TILE_KEXEC_H
+#define _ASM_TILE_KEXEC_H
+
+#include <asm/page.h>
+
+/* Maximum physical address we can use pages from. */
+#define KEXEC_SOURCE_MEMORY_LIMIT TASK_SIZE
+/* Maximum address we can reach in physical address mode. */
+#define KEXEC_DESTINATION_MEMORY_LIMIT TASK_SIZE
+/* Maximum address we can use for the control code buffer. */
+#define KEXEC_CONTROL_MEMORY_LIMIT TASK_SIZE
+
+#define KEXEC_CONTROL_PAGE_SIZE	PAGE_SIZE
+
+/*
+ * We don't bother to provide a unique identifier, since we can only
+ * reboot with a single type of kernel image anyway.
+ */
+#define KEXEC_ARCH KEXEC_ARCH_DEFAULT
+
+/* Use the tile override for the page allocator. */
+struct page *kimage_alloc_pages_arch(gfp_t gfp_mask, unsigned int order);
+#define kimage_alloc_pages_arch kimage_alloc_pages_arch
+
+#define MAX_NOTE_BYTES 1024
+
+/* Defined in arch/tile/kernel/relocate_kernel.S */
+extern const unsigned char relocate_new_kernel[];
+extern const unsigned long relocate_new_kernel_size;
+extern void relocate_new_kernel_end(void);
+
+/* Provide a dummy definition to avoid build failures. */
+static inline void crash_setup_regs(struct pt_regs *n, struct pt_regs *o)
+{
+}
+
+#endif /* _ASM_TILE_KEXEC_H */
diff --git a/arch/tile/include/asm/kmap_types.h b/arch/tile/include/asm/kmap_types.h
new file mode 100644
index 0000000..1480106
--- /dev/null
+++ b/arch/tile/include/asm/kmap_types.h
@@ -0,0 +1,43 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_KMAP_TYPES_H
+#define _ASM_TILE_KMAP_TYPES_H
+
+/*
+ * In TILE Linux each set of four of these uses another 16MB chunk of
+ * address space, given 64 tiles and 64KB pages, so we only enable
+ * ones that are required by the kernel configuration.
+ */
+enum km_type {
+	KM_BOUNCE_READ,
+	KM_SKB_SUNRPC_DATA,
+	KM_SKB_DATA_SOFTIRQ,
+	KM_USER0,
+	KM_USER1,
+	KM_BIO_SRC_IRQ,
+	KM_IRQ0,
+	KM_IRQ1,
+	KM_SOFTIRQ0,
+	KM_SOFTIRQ1,
+	KM_MEMCPY0,
+	KM_MEMCPY1,
+#if defined(CONFIG_HIGHPTE)
+	KM_PTE0,
+	KM_PTE1,
+#endif
+	KM_TYPE_NR
+};
+
+#endif /* _ASM_TILE_KMAP_TYPES_H */
diff --git a/arch/tile/include/asm/linkage.h b/arch/tile/include/asm/linkage.h
new file mode 100644
index 0000000..e121c39
--- /dev/null
+++ b/arch/tile/include/asm/linkage.h
@@ -0,0 +1,51 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_LINKAGE_H
+#define _ASM_TILE_LINKAGE_H
+
+#include <feedback.h>
+
+#define __ALIGN .align 8
+
+/*
+ * The STD_ENTRY and STD_ENDPROC macros put the function in a
+ * self-named .text.foo section, and if linker feedback collection
+ * is enabled, add a suitable call to the feedback collection code.
+ * STD_ENTRY_SECTION lets you specify a non-standard section name.
+ */
+
+#define STD_ENTRY(name) \
+  .pushsection .text.##name, "ax"; \
+  ENTRY(name); \
+  FEEDBACK_ENTER(name)
+
+#define STD_ENTRY_SECTION(name, section) \
+  .pushsection section, "ax"; \
+  ENTRY(name); \
+  FEEDBACK_ENTER_EXPLICIT(name, section, .Lend_##name - name)
+
+#define STD_ENDPROC(name) \
+  ENDPROC(name); \
+  .Lend_##name:; \
+  .popsection
+
+/* Create a file-static function entry set up for feedback gathering. */
+#define STD_ENTRY_LOCAL(name) \
+  .pushsection .text.##name, "ax"; \
+  ALIGN; \
+  name:; \
+  FEEDBACK_ENTER(name)
+
+#endif /* _ASM_TILE_LINKAGE_H */
diff --git a/arch/tile/include/asm/local.h b/arch/tile/include/asm/local.h
new file mode 100644
index 0000000..c11c530
--- /dev/null
+++ b/arch/tile/include/asm/local.h
@@ -0,0 +1 @@
+#include <asm-generic/local.h>
diff --git a/arch/tile/include/asm/memprof.h b/arch/tile/include/asm/memprof.h
new file mode 100644
index 0000000..359949b
--- /dev/null
+++ b/arch/tile/include/asm/memprof.h
@@ -0,0 +1,33 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ *
+ * The hypervisor's memory controller profiling infrastructure allows
+ * the programmer to find out what fraction of the available memory
+ * bandwidth is being consumed at each memory controller.  The
+ * profiler provides start, stop, and clear operations to allows
+ * profiling over a specific time window, as well as an interface for
+ * reading the most recent profile values.
+ *
+ * This header declares IOCTL codes necessary to control memprof.
+ */
+#ifndef _ASM_TILE_MEMPROF_H
+#define _ASM_TILE_MEMPROF_H
+
+#include <linux/ioctl.h>
+
+#define MEMPROF_IOCTL_TYPE 0xB4
+#define MEMPROF_IOCTL_START _IO(MEMPROF_IOCTL_TYPE, 0)
+#define MEMPROF_IOCTL_STOP _IO(MEMPROF_IOCTL_TYPE, 1)
+#define MEMPROF_IOCTL_CLEAR _IO(MEMPROF_IOCTL_TYPE, 2)
+
+#endif /* _ASM_TILE_MEMPROF_H */
diff --git a/arch/tile/include/asm/mman.h b/arch/tile/include/asm/mman.h
new file mode 100644
index 0000000..4c6811e
--- /dev/null
+++ b/arch/tile/include/asm/mman.h
@@ -0,0 +1,40 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_MMAN_H
+#define _ASM_TILE_MMAN_H
+
+#include <asm-generic/mman-common.h>
+#include <arch/chip.h>
+
+/* Standard Linux flags */
+
+#define MAP_POPULATE	0x0040		/* populate (prefault) pagetables */
+#define MAP_NONBLOCK	0x0080		/* do not block on IO */
+#define MAP_GROWSDOWN	0x0100		/* stack-like segment */
+#define MAP_LOCKED	0x0200		/* pages are locked */
+#define MAP_NORESERVE	0x0400		/* don't check for reservations */
+#define MAP_DENYWRITE	0x0800		/* ETXTBSY */
+#define MAP_EXECUTABLE	0x1000		/* mark it as an executable */
+#define MAP_HUGETLB	0x4000		/* create a huge page mapping */
+
+
+/*
+ * Flags for mlockall
+ */
+#define MCL_CURRENT	1		/* lock all current mappings */
+#define MCL_FUTURE	2		/* lock all future mappings */
+
+
+#endif /* _ASM_TILE_MMAN_H */
diff --git a/arch/tile/include/asm/mmu.h b/arch/tile/include/asm/mmu.h
new file mode 100644
index 0000000..92f94c7
--- /dev/null
+++ b/arch/tile/include/asm/mmu.h
@@ -0,0 +1,31 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_MMU_H
+#define _ASM_TILE_MMU_H
+
+/* Capture any arch- and mm-specific information. */
+struct mm_context {
+	/*
+	 * Written under the mmap_sem semaphore; read without the
+	 * semaphore but atomically, but it is conservatively set.
+	 */
+	unsigned int priority_cached;
+};
+
+typedef struct mm_context mm_context_t;
+
+void leave_mm(int cpu);
+
+#endif /* _ASM_TILE_MMU_H */
diff --git a/arch/tile/include/asm/mmu_context.h b/arch/tile/include/asm/mmu_context.h
new file mode 100644
index 0000000..9bc0d07
--- /dev/null
+++ b/arch/tile/include/asm/mmu_context.h
@@ -0,0 +1,131 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_MMU_CONTEXT_H
+#define _ASM_TILE_MMU_CONTEXT_H
+
+#include <linux/smp.h>
+#include <asm/setup.h>
+#include <asm/page.h>
+#include <asm/pgalloc.h>
+#include <asm/pgtable.h>
+#include <asm/tlbflush.h>
+#include <asm/homecache.h>
+#include <asm-generic/mm_hooks.h>
+
+static inline int
+init_new_context(struct task_struct *tsk, struct mm_struct *mm)
+{
+	return 0;
+}
+
+/* Note that arch/tile/kernel/head.S also calls hv_install_context() */
+static inline void __install_page_table(pgd_t *pgdir, int asid, pgprot_t prot)
+{
+	/* FIXME: DIRECTIO should not always be set. FIXME. */
+	int rc = hv_install_context(__pa(pgdir), prot, asid, HV_CTX_DIRECTIO);
+	if (rc < 0)
+		panic("hv_install_context failed: %d", rc);
+}
+
+static inline void install_page_table(pgd_t *pgdir, int asid)
+{
+	pte_t *ptep = virt_to_pte(NULL, (unsigned long)pgdir);
+	__install_page_table(pgdir, asid, *ptep);
+}
+
+/*
+ * "Lazy" TLB mode is entered when we are switching to a kernel task,
+ * which borrows the mm of the previous task.  The goal of this
+ * optimization is to avoid having to install a new page table.  On
+ * early x86 machines (where the concept originated) you couldn't do
+ * anything short of a full page table install for invalidation, so
+ * handling a remote TLB invalidate required doing a page table
+ * re-install.  Someone clearly decided that it was silly to keep
+ * doing this while in "lazy" TLB mode, so the optimization involves
+ * installing the swapper page table instead the first time one
+ * occurs, and clearing the cpu out of cpu_vm_mask, so the cpu running
+ * the kernel task doesn't need to take any more interrupts.  At that
+ * point it's then necessary to explicitly reinstall it when context
+ * switching back to the original mm.
+ *
+ * On Tile, we have to do a page-table install whenever DMA is enabled,
+ * so in that case lazy mode doesn't help anyway.  And more generally,
+ * we have efficient per-page TLB shootdown, and don't expect to spend
+ * that much time in kernel tasks in general, so just leaving the
+ * kernel task borrowing the old page table, but handling TLB
+ * shootdowns, is a reasonable thing to do.  And importantly, this
+ * lets us use the hypervisor's internal APIs for TLB shootdown, which
+ * means we don't have to worry about having TLB shootdowns blocked
+ * when Linux is disabling interrupts; see the page migration code for
+ * an example of where it's important for TLB shootdowns to complete
+ * even when interrupts are disabled at the Linux level.
+ */
+static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *t)
+{
+#if CHIP_HAS_TILE_DMA()
+	/*
+	 * We have to do an "identity" page table switch in order to
+	 * clear any pending DMA interrupts.
+	 */
+	if (current->thread.tile_dma_state.enabled)
+		install_page_table(mm->pgd, __get_cpu_var(current_asid));
+#endif
+}
+
+static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
+			     struct task_struct *tsk)
+{
+	if (likely(prev != next)) {
+
+		int cpu = smp_processor_id();
+
+		/* Pick new ASID. */
+		int asid = __get_cpu_var(current_asid) + 1;
+		if (asid > max_asid) {
+			asid = min_asid;
+			local_flush_tlb();
+		}
+		__get_cpu_var(current_asid) = asid;
+
+		/* Clear cpu from the old mm, and set it in the new one. */
+		cpumask_clear_cpu(cpu, &prev->cpu_vm_mask);
+		cpumask_set_cpu(cpu, &next->cpu_vm_mask);
+
+		/* Re-load page tables */
+		install_page_table(next->pgd, asid);
+
+		/* See how we should set the red/black cache info */
+		check_mm_caching(prev, next);
+
+		/*
+		 * Since we're changing to a new mm, we have to flush
+		 * the icache in case some physical page now being mapped
+		 * has subsequently been repurposed and has new code.
+		 */
+		__flush_icache();
+
+	}
+}
+
+static inline void activate_mm(struct mm_struct *prev_mm,
+			       struct mm_struct *next_mm)
+{
+	switch_mm(prev_mm, next_mm, NULL);
+}
+
+#define destroy_context(mm)		do { } while (0)
+#define deactivate_mm(tsk, mm)          do { } while (0)
+
+#endif /* _ASM_TILE_MMU_CONTEXT_H */
diff --git a/arch/tile/include/asm/mmzone.h b/arch/tile/include/asm/mmzone.h
new file mode 100644
index 0000000..c6344c4
--- /dev/null
+++ b/arch/tile/include/asm/mmzone.h
@@ -0,0 +1,81 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_MMZONE_H
+#define _ASM_TILE_MMZONE_H
+
+extern struct pglist_data node_data[];
+#define NODE_DATA(nid)	(&node_data[nid])
+
+extern void get_memcfg_numa(void);
+
+#ifdef CONFIG_DISCONTIGMEM
+
+#include <asm/page.h>
+
+/*
+ * Generally, memory ranges are always doled out by the hypervisor in
+ * fixed-size, power-of-two increments.  That would make computing the node
+ * very easy.  We could just take a couple high bits of the PA, which
+ * denote the memory shim, and we'd be done.  However, when we're doing
+ * memory striping, this may not be true; PAs with different high bit
+ * values might be in the same node.  Thus, we keep a lookup table to
+ * translate the high bits of the PFN to the node number.
+ */
+extern int highbits_to_node[];
+
+static inline int pfn_to_nid(unsigned long pfn)
+{
+	return highbits_to_node[__pfn_to_highbits(pfn)];
+}
+
+/*
+ * Following are macros that each numa implmentation must define.
+ */
+
+#define node_start_pfn(nid)	(NODE_DATA(nid)->node_start_pfn)
+#define node_end_pfn(nid)						\
+({									\
+	pg_data_t *__pgdat = NODE_DATA(nid);				\
+	__pgdat->node_start_pfn + __pgdat->node_spanned_pages;		\
+})
+
+#define kern_addr_valid(kaddr)	virt_addr_valid((void *)kaddr)
+
+static inline int pfn_valid(int pfn)
+{
+	int nid = pfn_to_nid(pfn);
+
+	if (nid >= 0)
+		return (pfn < node_end_pfn(nid));
+	return 0;
+}
+
+/* Information on the NUMA nodes that we compute early */
+extern unsigned long node_start_pfn[];
+extern unsigned long node_end_pfn[];
+extern unsigned long node_memmap_pfn[];
+extern unsigned long node_percpu_pfn[];
+extern unsigned long node_free_pfn[];
+#ifdef CONFIG_HIGHMEM
+extern unsigned long node_lowmem_end_pfn[];
+#endif
+#ifdef CONFIG_PCI
+extern unsigned long pci_reserve_start_pfn;
+extern unsigned long pci_reserve_end_pfn;
+#endif
+
+#endif /* CONFIG_DISCONTIGMEM */
+
+#endif /* _ASM_TILE_MMZONE_H */
diff --git a/arch/tile/include/asm/module.h b/arch/tile/include/asm/module.h
new file mode 100644
index 0000000..1e4b79f
--- /dev/null
+++ b/arch/tile/include/asm/module.h
@@ -0,0 +1 @@
+#include <asm-generic/module.h>
diff --git a/arch/tile/include/asm/msgbuf.h b/arch/tile/include/asm/msgbuf.h
new file mode 100644
index 0000000..809134c
--- /dev/null
+++ b/arch/tile/include/asm/msgbuf.h
@@ -0,0 +1 @@
+#include <asm-generic/msgbuf.h>
diff --git a/arch/tile/include/asm/mutex.h b/arch/tile/include/asm/mutex.h
new file mode 100644
index 0000000..ff6101a
--- /dev/null
+++ b/arch/tile/include/asm/mutex.h
@@ -0,0 +1 @@
+#include <asm-generic/mutex-dec.h>
diff --git a/arch/tile/include/asm/opcode-tile.h b/arch/tile/include/asm/opcode-tile.h
new file mode 100644
index 0000000..ba38959
--- /dev/null
+++ b/arch/tile/include/asm/opcode-tile.h
@@ -0,0 +1,30 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_OPCODE_TILE_H
+#define _ASM_TILE_OPCODE_TILE_H
+
+#include <arch/chip.h>
+
+#if CHIP_WORD_SIZE() == 64
+#include <asm/opcode-tile_64.h>
+#else
+#include <asm/opcode-tile_32.h>
+#endif
+
+/* These definitions are not correct for TILE64, so just avoid them. */
+#undef TILE_ELF_MACHINE_CODE
+#undef TILE_ELF_NAME
+
+#endif /* _ASM_TILE_OPCODE_TILE_H */
diff --git a/arch/tile/include/asm/opcode-tile_32.h b/arch/tile/include/asm/opcode-tile_32.h
new file mode 100644
index 0000000..90f8dd3
--- /dev/null
+++ b/arch/tile/include/asm/opcode-tile_32.h
@@ -0,0 +1,1597 @@
+/* tile.h -- Header file for TILE opcode table
+   Copyright (C) 2005 Free Software Foundation, Inc.
+   Contributed by Tilera Corp. */
+
+#ifndef opcode_tile_h
+#define opcode_tile_h
+
+typedef unsigned long long tile_bundle_bits;
+
+
+enum
+{
+  TILE_MAX_OPERANDS = 5 /* mm */
+};
+
+typedef enum
+{
+  TILE_OPC_BPT,
+  TILE_OPC_INFO,
+  TILE_OPC_INFOL,
+  TILE_OPC_J,
+  TILE_OPC_JAL,
+  TILE_OPC_MOVE,
+  TILE_OPC_MOVE_SN,
+  TILE_OPC_MOVEI,
+  TILE_OPC_MOVEI_SN,
+  TILE_OPC_MOVELI,
+  TILE_OPC_MOVELI_SN,
+  TILE_OPC_MOVELIS,
+  TILE_OPC_PREFETCH,
+  TILE_OPC_ADD,
+  TILE_OPC_ADD_SN,
+  TILE_OPC_ADDB,
+  TILE_OPC_ADDB_SN,
+  TILE_OPC_ADDBS_U,
+  TILE_OPC_ADDBS_U_SN,
+  TILE_OPC_ADDH,
+  TILE_OPC_ADDH_SN,
+  TILE_OPC_ADDHS,
+  TILE_OPC_ADDHS_SN,
+  TILE_OPC_ADDI,
+  TILE_OPC_ADDI_SN,
+  TILE_OPC_ADDIB,
+  TILE_OPC_ADDIB_SN,
+  TILE_OPC_ADDIH,
+  TILE_OPC_ADDIH_SN,
+  TILE_OPC_ADDLI,
+  TILE_OPC_ADDLI_SN,
+  TILE_OPC_ADDLIS,
+  TILE_OPC_ADDS,
+  TILE_OPC_ADDS_SN,
+  TILE_OPC_ADIFFB_U,
+  TILE_OPC_ADIFFB_U_SN,
+  TILE_OPC_ADIFFH,
+  TILE_OPC_ADIFFH_SN,
+  TILE_OPC_AND,
+  TILE_OPC_AND_SN,
+  TILE_OPC_ANDI,
+  TILE_OPC_ANDI_SN,
+  TILE_OPC_AULI,
+  TILE_OPC_AVGB_U,
+  TILE_OPC_AVGB_U_SN,
+  TILE_OPC_AVGH,
+  TILE_OPC_AVGH_SN,
+  TILE_OPC_BBNS,
+  TILE_OPC_BBNS_SN,
+  TILE_OPC_BBNST,
+  TILE_OPC_BBNST_SN,
+  TILE_OPC_BBS,
+  TILE_OPC_BBS_SN,
+  TILE_OPC_BBST,
+  TILE_OPC_BBST_SN,
+  TILE_OPC_BGEZ,
+  TILE_OPC_BGEZ_SN,
+  TILE_OPC_BGEZT,
+  TILE_OPC_BGEZT_SN,
+  TILE_OPC_BGZ,
+  TILE_OPC_BGZ_SN,
+  TILE_OPC_BGZT,
+  TILE_OPC_BGZT_SN,
+  TILE_OPC_BITX,
+  TILE_OPC_BITX_SN,
+  TILE_OPC_BLEZ,
+  TILE_OPC_BLEZ_SN,
+  TILE_OPC_BLEZT,
+  TILE_OPC_BLEZT_SN,
+  TILE_OPC_BLZ,
+  TILE_OPC_BLZ_SN,
+  TILE_OPC_BLZT,
+  TILE_OPC_BLZT_SN,
+  TILE_OPC_BNZ,
+  TILE_OPC_BNZ_SN,
+  TILE_OPC_BNZT,
+  TILE_OPC_BNZT_SN,
+  TILE_OPC_BYTEX,
+  TILE_OPC_BYTEX_SN,
+  TILE_OPC_BZ,
+  TILE_OPC_BZ_SN,
+  TILE_OPC_BZT,
+  TILE_OPC_BZT_SN,
+  TILE_OPC_CLZ,
+  TILE_OPC_CLZ_SN,
+  TILE_OPC_CRC32_32,
+  TILE_OPC_CRC32_32_SN,
+  TILE_OPC_CRC32_8,
+  TILE_OPC_CRC32_8_SN,
+  TILE_OPC_CTZ,
+  TILE_OPC_CTZ_SN,
+  TILE_OPC_DRAIN,
+  TILE_OPC_DTLBPR,
+  TILE_OPC_DWORD_ALIGN,
+  TILE_OPC_DWORD_ALIGN_SN,
+  TILE_OPC_FINV,
+  TILE_OPC_FLUSH,
+  TILE_OPC_FNOP,
+  TILE_OPC_ICOH,
+  TILE_OPC_ILL,
+  TILE_OPC_INTHB,
+  TILE_OPC_INTHB_SN,
+  TILE_OPC_INTHH,
+  TILE_OPC_INTHH_SN,
+  TILE_OPC_INTLB,
+  TILE_OPC_INTLB_SN,
+  TILE_OPC_INTLH,
+  TILE_OPC_INTLH_SN,
+  TILE_OPC_INV,
+  TILE_OPC_IRET,
+  TILE_OPC_JALB,
+  TILE_OPC_JALF,
+  TILE_OPC_JALR,
+  TILE_OPC_JALRP,
+  TILE_OPC_JB,
+  TILE_OPC_JF,
+  TILE_OPC_JR,
+  TILE_OPC_JRP,
+  TILE_OPC_LB,
+  TILE_OPC_LB_SN,
+  TILE_OPC_LB_U,
+  TILE_OPC_LB_U_SN,
+  TILE_OPC_LBADD,
+  TILE_OPC_LBADD_SN,
+  TILE_OPC_LBADD_U,
+  TILE_OPC_LBADD_U_SN,
+  TILE_OPC_LH,
+  TILE_OPC_LH_SN,
+  TILE_OPC_LH_U,
+  TILE_OPC_LH_U_SN,
+  TILE_OPC_LHADD,
+  TILE_OPC_LHADD_SN,
+  TILE_OPC_LHADD_U,
+  TILE_OPC_LHADD_U_SN,
+  TILE_OPC_LNK,
+  TILE_OPC_LNK_SN,
+  TILE_OPC_LW,
+  TILE_OPC_LW_SN,
+  TILE_OPC_LW_NA,
+  TILE_OPC_LW_NA_SN,
+  TILE_OPC_LWADD,
+  TILE_OPC_LWADD_SN,
+  TILE_OPC_LWADD_NA,
+  TILE_OPC_LWADD_NA_SN,
+  TILE_OPC_MAXB_U,
+  TILE_OPC_MAXB_U_SN,
+  TILE_OPC_MAXH,
+  TILE_OPC_MAXH_SN,
+  TILE_OPC_MAXIB_U,
+  TILE_OPC_MAXIB_U_SN,
+  TILE_OPC_MAXIH,
+  TILE_OPC_MAXIH_SN,
+  TILE_OPC_MF,
+  TILE_OPC_MFSPR,
+  TILE_OPC_MINB_U,
+  TILE_OPC_MINB_U_SN,
+  TILE_OPC_MINH,
+  TILE_OPC_MINH_SN,
+  TILE_OPC_MINIB_U,
+  TILE_OPC_MINIB_U_SN,
+  TILE_OPC_MINIH,
+  TILE_OPC_MINIH_SN,
+  TILE_OPC_MM,
+  TILE_OPC_MNZ,
+  TILE_OPC_MNZ_SN,
+  TILE_OPC_MNZB,
+  TILE_OPC_MNZB_SN,
+  TILE_OPC_MNZH,
+  TILE_OPC_MNZH_SN,
+  TILE_OPC_MTSPR,
+  TILE_OPC_MULHH_SS,
+  TILE_OPC_MULHH_SS_SN,
+  TILE_OPC_MULHH_SU,
+  TILE_OPC_MULHH_SU_SN,
+  TILE_OPC_MULHH_UU,
+  TILE_OPC_MULHH_UU_SN,
+  TILE_OPC_MULHHA_SS,
+  TILE_OPC_MULHHA_SS_SN,
+  TILE_OPC_MULHHA_SU,
+  TILE_OPC_MULHHA_SU_SN,
+  TILE_OPC_MULHHA_UU,
+  TILE_OPC_MULHHA_UU_SN,
+  TILE_OPC_MULHHSA_UU,
+  TILE_OPC_MULHHSA_UU_SN,
+  TILE_OPC_MULHL_SS,
+  TILE_OPC_MULHL_SS_SN,
+  TILE_OPC_MULHL_SU,
+  TILE_OPC_MULHL_SU_SN,
+  TILE_OPC_MULHL_US,
+  TILE_OPC_MULHL_US_SN,
+  TILE_OPC_MULHL_UU,
+  TILE_OPC_MULHL_UU_SN,
+  TILE_OPC_MULHLA_SS,
+  TILE_OPC_MULHLA_SS_SN,
+  TILE_OPC_MULHLA_SU,
+  TILE_OPC_MULHLA_SU_SN,
+  TILE_OPC_MULHLA_US,
+  TILE_OPC_MULHLA_US_SN,
+  TILE_OPC_MULHLA_UU,
+  TILE_OPC_MULHLA_UU_SN,
+  TILE_OPC_MULHLSA_UU,
+  TILE_OPC_MULHLSA_UU_SN,
+  TILE_OPC_MULLL_SS,
+  TILE_OPC_MULLL_SS_SN,
+  TILE_OPC_MULLL_SU,
+  TILE_OPC_MULLL_SU_SN,
+  TILE_OPC_MULLL_UU,
+  TILE_OPC_MULLL_UU_SN,
+  TILE_OPC_MULLLA_SS,
+  TILE_OPC_MULLLA_SS_SN,
+  TILE_OPC_MULLLA_SU,
+  TILE_OPC_MULLLA_SU_SN,
+  TILE_OPC_MULLLA_UU,
+  TILE_OPC_MULLLA_UU_SN,
+  TILE_OPC_MULLLSA_UU,
+  TILE_OPC_MULLLSA_UU_SN,
+  TILE_OPC_MVNZ,
+  TILE_OPC_MVNZ_SN,
+  TILE_OPC_MVZ,
+  TILE_OPC_MVZ_SN,
+  TILE_OPC_MZ,
+  TILE_OPC_MZ_SN,
+  TILE_OPC_MZB,
+  TILE_OPC_MZB_SN,
+  TILE_OPC_MZH,
+  TILE_OPC_MZH_SN,
+  TILE_OPC_NAP,
+  TILE_OPC_NOP,
+  TILE_OPC_NOR,
+  TILE_OPC_NOR_SN,
+  TILE_OPC_OR,
+  TILE_OPC_OR_SN,
+  TILE_OPC_ORI,
+  TILE_OPC_ORI_SN,
+  TILE_OPC_PACKBS_U,
+  TILE_OPC_PACKBS_U_SN,
+  TILE_OPC_PACKHB,
+  TILE_OPC_PACKHB_SN,
+  TILE_OPC_PACKHS,
+  TILE_OPC_PACKHS_SN,
+  TILE_OPC_PACKLB,
+  TILE_OPC_PACKLB_SN,
+  TILE_OPC_PCNT,
+  TILE_OPC_PCNT_SN,
+  TILE_OPC_RL,
+  TILE_OPC_RL_SN,
+  TILE_OPC_RLI,
+  TILE_OPC_RLI_SN,
+  TILE_OPC_S1A,
+  TILE_OPC_S1A_SN,
+  TILE_OPC_S2A,
+  TILE_OPC_S2A_SN,
+  TILE_OPC_S3A,
+  TILE_OPC_S3A_SN,
+  TILE_OPC_SADAB_U,
+  TILE_OPC_SADAB_U_SN,
+  TILE_OPC_SADAH,
+  TILE_OPC_SADAH_SN,
+  TILE_OPC_SADAH_U,
+  TILE_OPC_SADAH_U_SN,
+  TILE_OPC_SADB_U,
+  TILE_OPC_SADB_U_SN,
+  TILE_OPC_SADH,
+  TILE_OPC_SADH_SN,
+  TILE_OPC_SADH_U,
+  TILE_OPC_SADH_U_SN,
+  TILE_OPC_SB,
+  TILE_OPC_SBADD,
+  TILE_OPC_SEQ,
+  TILE_OPC_SEQ_SN,
+  TILE_OPC_SEQB,
+  TILE_OPC_SEQB_SN,
+  TILE_OPC_SEQH,
+  TILE_OPC_SEQH_SN,
+  TILE_OPC_SEQI,
+  TILE_OPC_SEQI_SN,
+  TILE_OPC_SEQIB,
+  TILE_OPC_SEQIB_SN,
+  TILE_OPC_SEQIH,
+  TILE_OPC_SEQIH_SN,
+  TILE_OPC_SH,
+  TILE_OPC_SHADD,
+  TILE_OPC_SHL,
+  TILE_OPC_SHL_SN,
+  TILE_OPC_SHLB,
+  TILE_OPC_SHLB_SN,
+  TILE_OPC_SHLH,
+  TILE_OPC_SHLH_SN,
+  TILE_OPC_SHLI,
+  TILE_OPC_SHLI_SN,
+  TILE_OPC_SHLIB,
+  TILE_OPC_SHLIB_SN,
+  TILE_OPC_SHLIH,
+  TILE_OPC_SHLIH_SN,
+  TILE_OPC_SHR,
+  TILE_OPC_SHR_SN,
+  TILE_OPC_SHRB,
+  TILE_OPC_SHRB_SN,
+  TILE_OPC_SHRH,
+  TILE_OPC_SHRH_SN,
+  TILE_OPC_SHRI,
+  TILE_OPC_SHRI_SN,
+  TILE_OPC_SHRIB,
+  TILE_OPC_SHRIB_SN,
+  TILE_OPC_SHRIH,
+  TILE_OPC_SHRIH_SN,
+  TILE_OPC_SLT,
+  TILE_OPC_SLT_SN,
+  TILE_OPC_SLT_U,
+  TILE_OPC_SLT_U_SN,
+  TILE_OPC_SLTB,
+  TILE_OPC_SLTB_SN,
+  TILE_OPC_SLTB_U,
+  TILE_OPC_SLTB_U_SN,
+  TILE_OPC_SLTE,
+  TILE_OPC_SLTE_SN,
+  TILE_OPC_SLTE_U,
+  TILE_OPC_SLTE_U_SN,
+  TILE_OPC_SLTEB,
+  TILE_OPC_SLTEB_SN,
+  TILE_OPC_SLTEB_U,
+  TILE_OPC_SLTEB_U_SN,
+  TILE_OPC_SLTEH,
+  TILE_OPC_SLTEH_SN,
+  TILE_OPC_SLTEH_U,
+  TILE_OPC_SLTEH_U_SN,
+  TILE_OPC_SLTH,
+  TILE_OPC_SLTH_SN,
+  TILE_OPC_SLTH_U,
+  TILE_OPC_SLTH_U_SN,
+  TILE_OPC_SLTI,
+  TILE_OPC_SLTI_SN,
+  TILE_OPC_SLTI_U,
+  TILE_OPC_SLTI_U_SN,
+  TILE_OPC_SLTIB,
+  TILE_OPC_SLTIB_SN,
+  TILE_OPC_SLTIB_U,
+  TILE_OPC_SLTIB_U_SN,
+  TILE_OPC_SLTIH,
+  TILE_OPC_SLTIH_SN,
+  TILE_OPC_SLTIH_U,
+  TILE_OPC_SLTIH_U_SN,
+  TILE_OPC_SNE,
+  TILE_OPC_SNE_SN,
+  TILE_OPC_SNEB,
+  TILE_OPC_SNEB_SN,
+  TILE_OPC_SNEH,
+  TILE_OPC_SNEH_SN,
+  TILE_OPC_SRA,
+  TILE_OPC_SRA_SN,
+  TILE_OPC_SRAB,
+  TILE_OPC_SRAB_SN,
+  TILE_OPC_SRAH,
+  TILE_OPC_SRAH_SN,
+  TILE_OPC_SRAI,
+  TILE_OPC_SRAI_SN,
+  TILE_OPC_SRAIB,
+  TILE_OPC_SRAIB_SN,
+  TILE_OPC_SRAIH,
+  TILE_OPC_SRAIH_SN,
+  TILE_OPC_SUB,
+  TILE_OPC_SUB_SN,
+  TILE_OPC_SUBB,
+  TILE_OPC_SUBB_SN,
+  TILE_OPC_SUBBS_U,
+  TILE_OPC_SUBBS_U_SN,
+  TILE_OPC_SUBH,
+  TILE_OPC_SUBH_SN,
+  TILE_OPC_SUBHS,
+  TILE_OPC_SUBHS_SN,
+  TILE_OPC_SUBS,
+  TILE_OPC_SUBS_SN,
+  TILE_OPC_SW,
+  TILE_OPC_SWADD,
+  TILE_OPC_SWINT0,
+  TILE_OPC_SWINT1,
+  TILE_OPC_SWINT2,
+  TILE_OPC_SWINT3,
+  TILE_OPC_TBLIDXB0,
+  TILE_OPC_TBLIDXB0_SN,
+  TILE_OPC_TBLIDXB1,
+  TILE_OPC_TBLIDXB1_SN,
+  TILE_OPC_TBLIDXB2,
+  TILE_OPC_TBLIDXB2_SN,
+  TILE_OPC_TBLIDXB3,
+  TILE_OPC_TBLIDXB3_SN,
+  TILE_OPC_TNS,
+  TILE_OPC_TNS_SN,
+  TILE_OPC_WH64,
+  TILE_OPC_XOR,
+  TILE_OPC_XOR_SN,
+  TILE_OPC_XORI,
+  TILE_OPC_XORI_SN,
+  TILE_OPC_NONE
+} tile_mnemonic;
+
+/* 64-bit pattern for a { bpt ; nop } bundle. */
+#define TILE_BPT_BUNDLE 0x400b3cae70166000ULL
+
+
+#define TILE_ELF_MACHINE_CODE EM_TILEPRO
+
+#define TILE_ELF_NAME "elf32-tilepro"
+
+enum
+{
+  TILE_SN_MAX_OPERANDS = 6 /* route */
+};
+
+typedef enum
+{
+  TILE_SN_OPC_BZ,
+  TILE_SN_OPC_BNZ,
+  TILE_SN_OPC_JRR,
+  TILE_SN_OPC_FNOP,
+  TILE_SN_OPC_BLZ,
+  TILE_SN_OPC_NOP,
+  TILE_SN_OPC_MOVEI,
+  TILE_SN_OPC_MOVE,
+  TILE_SN_OPC_BGEZ,
+  TILE_SN_OPC_JR,
+  TILE_SN_OPC_BLEZ,
+  TILE_SN_OPC_BBNS,
+  TILE_SN_OPC_JALRR,
+  TILE_SN_OPC_BPT,
+  TILE_SN_OPC_JALR,
+  TILE_SN_OPC_SHR1,
+  TILE_SN_OPC_BGZ,
+  TILE_SN_OPC_BBS,
+  TILE_SN_OPC_SHL8II,
+  TILE_SN_OPC_ADDI,
+  TILE_SN_OPC_HALT,
+  TILE_SN_OPC_ROUTE,
+  TILE_SN_OPC_NONE
+} tile_sn_mnemonic;
+
+extern const unsigned char tile_sn_route_encode[6 * 6 * 6];
+extern const signed char tile_sn_route_decode[256][3];
+extern const char tile_sn_direction_names[6][5];
+extern const signed char tile_sn_dest_map[6][6];
+
+
+static __inline unsigned int
+get_BrOff_SN(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 0)) & 0x3ff);
+}
+
+static __inline unsigned int
+get_BrOff_X1(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 43)) & 0x00007fff) |
+         (((unsigned int)(n >> 20)) & 0x00018000);
+}
+
+static __inline unsigned int
+get_BrType_X1(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 31)) & 0xf);
+}
+
+static __inline unsigned int
+get_Dest_Imm8_X1(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 31)) & 0x0000003f) |
+         (((unsigned int)(n >> 43)) & 0x000000c0);
+}
+
+static __inline unsigned int
+get_Dest_SN(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 2)) & 0x3);
+}
+
+static __inline unsigned int
+get_Dest_X0(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 0)) & 0x3f);
+}
+
+static __inline unsigned int
+get_Dest_X1(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 31)) & 0x3f);
+}
+
+static __inline unsigned int
+get_Dest_Y0(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 0)) & 0x3f);
+}
+
+static __inline unsigned int
+get_Dest_Y1(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 31)) & 0x3f);
+}
+
+static __inline unsigned int
+get_Imm16_X0(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 12)) & 0xffff);
+}
+
+static __inline unsigned int
+get_Imm16_X1(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 43)) & 0xffff);
+}
+
+static __inline unsigned int
+get_Imm8_SN(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 0)) & 0xff);
+}
+
+static __inline unsigned int
+get_Imm8_X0(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 12)) & 0xff);
+}
+
+static __inline unsigned int
+get_Imm8_X1(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 43)) & 0xff);
+}
+
+static __inline unsigned int
+get_Imm8_Y0(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 12)) & 0xff);
+}
+
+static __inline unsigned int
+get_Imm8_Y1(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 43)) & 0xff);
+}
+
+static __inline unsigned int
+get_ImmOpcodeExtension_X0(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 20)) & 0x7f);
+}
+
+static __inline unsigned int
+get_ImmOpcodeExtension_X1(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 51)) & 0x7f);
+}
+
+static __inline unsigned int
+get_ImmRROpcodeExtension_SN(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 8)) & 0x3);
+}
+
+static __inline unsigned int
+get_JOffLong_X1(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 43)) & 0x00007fff) |
+         (((unsigned int)(n >> 20)) & 0x00018000) |
+         (((unsigned int)(n >> 14)) & 0x001e0000) |
+         (((unsigned int)(n >> 16)) & 0x07e00000) |
+         (((unsigned int)(n >> 31)) & 0x18000000);
+}
+
+static __inline unsigned int
+get_JOff_X1(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 43)) & 0x00007fff) |
+         (((unsigned int)(n >> 20)) & 0x00018000) |
+         (((unsigned int)(n >> 14)) & 0x001e0000) |
+         (((unsigned int)(n >> 16)) & 0x07e00000) |
+         (((unsigned int)(n >> 31)) & 0x08000000);
+}
+
+static __inline unsigned int
+get_MF_Imm15_X1(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 37)) & 0x00003fff) |
+         (((unsigned int)(n >> 44)) & 0x00004000);
+}
+
+static __inline unsigned int
+get_MMEnd_X0(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 18)) & 0x1f);
+}
+
+static __inline unsigned int
+get_MMEnd_X1(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 49)) & 0x1f);
+}
+
+static __inline unsigned int
+get_MMStart_X0(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 23)) & 0x1f);
+}
+
+static __inline unsigned int
+get_MMStart_X1(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 54)) & 0x1f);
+}
+
+static __inline unsigned int
+get_MT_Imm15_X1(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 31)) & 0x0000003f) |
+         (((unsigned int)(n >> 37)) & 0x00003fc0) |
+         (((unsigned int)(n >> 44)) & 0x00004000);
+}
+
+static __inline unsigned int
+get_Mode(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 63)) & 0x1);
+}
+
+static __inline unsigned int
+get_NoRegOpcodeExtension_SN(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 0)) & 0xf);
+}
+
+static __inline unsigned int
+get_Opcode_SN(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 10)) & 0x3f);
+}
+
+static __inline unsigned int
+get_Opcode_X0(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 28)) & 0x7);
+}
+
+static __inline unsigned int
+get_Opcode_X1(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 59)) & 0xf);
+}
+
+static __inline unsigned int
+get_Opcode_Y0(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 27)) & 0xf);
+}
+
+static __inline unsigned int
+get_Opcode_Y1(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 59)) & 0xf);
+}
+
+static __inline unsigned int
+get_Opcode_Y2(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 56)) & 0x7);
+}
+
+static __inline unsigned int
+get_RROpcodeExtension_SN(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 4)) & 0xf);
+}
+
+static __inline unsigned int
+get_RRROpcodeExtension_X0(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 18)) & 0x1ff);
+}
+
+static __inline unsigned int
+get_RRROpcodeExtension_X1(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 49)) & 0x1ff);
+}
+
+static __inline unsigned int
+get_RRROpcodeExtension_Y0(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 18)) & 0x3);
+}
+
+static __inline unsigned int
+get_RRROpcodeExtension_Y1(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 49)) & 0x3);
+}
+
+static __inline unsigned int
+get_RouteOpcodeExtension_SN(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 0)) & 0x3ff);
+}
+
+static __inline unsigned int
+get_S_X0(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 27)) & 0x1);
+}
+
+static __inline unsigned int
+get_S_X1(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 58)) & 0x1);
+}
+
+static __inline unsigned int
+get_ShAmt_X0(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 12)) & 0x1f);
+}
+
+static __inline unsigned int
+get_ShAmt_X1(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 43)) & 0x1f);
+}
+
+static __inline unsigned int
+get_ShAmt_Y0(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 12)) & 0x1f);
+}
+
+static __inline unsigned int
+get_ShAmt_Y1(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 43)) & 0x1f);
+}
+
+static __inline unsigned int
+get_SrcA_X0(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 6)) & 0x3f);
+}
+
+static __inline unsigned int
+get_SrcA_X1(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 37)) & 0x3f);
+}
+
+static __inline unsigned int
+get_SrcA_Y0(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 6)) & 0x3f);
+}
+
+static __inline unsigned int
+get_SrcA_Y1(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 37)) & 0x3f);
+}
+
+static __inline unsigned int
+get_SrcA_Y2(tile_bundle_bits n)
+{
+  return (((n >> 26)) & 0x00000001) |
+         (((unsigned int)(n >> 50)) & 0x0000003e);
+}
+
+static __inline unsigned int
+get_SrcBDest_Y2(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 20)) & 0x3f);
+}
+
+static __inline unsigned int
+get_SrcB_X0(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 12)) & 0x3f);
+}
+
+static __inline unsigned int
+get_SrcB_X1(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 43)) & 0x3f);
+}
+
+static __inline unsigned int
+get_SrcB_Y0(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 12)) & 0x3f);
+}
+
+static __inline unsigned int
+get_SrcB_Y1(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 43)) & 0x3f);
+}
+
+static __inline unsigned int
+get_Src_SN(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 0)) & 0x3);
+}
+
+static __inline unsigned int
+get_UnOpcodeExtension_X0(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 12)) & 0x1f);
+}
+
+static __inline unsigned int
+get_UnOpcodeExtension_X1(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 43)) & 0x1f);
+}
+
+static __inline unsigned int
+get_UnOpcodeExtension_Y0(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 12)) & 0x1f);
+}
+
+static __inline unsigned int
+get_UnOpcodeExtension_Y1(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 43)) & 0x1f);
+}
+
+static __inline unsigned int
+get_UnShOpcodeExtension_X0(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 17)) & 0x3ff);
+}
+
+static __inline unsigned int
+get_UnShOpcodeExtension_X1(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 48)) & 0x3ff);
+}
+
+static __inline unsigned int
+get_UnShOpcodeExtension_Y0(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 17)) & 0x7);
+}
+
+static __inline unsigned int
+get_UnShOpcodeExtension_Y1(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 48)) & 0x7);
+}
+
+
+static __inline int
+sign_extend(int n, int num_bits)
+{
+  int shift = (int)(sizeof(int) * 8 - num_bits);
+  return (n << shift) >> shift;
+}
+
+
+
+static __inline tile_bundle_bits
+create_BrOff_SN(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3ff) << 0);
+}
+
+static __inline tile_bundle_bits
+create_BrOff_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0x00007fff)) << 43) |
+         (((tile_bundle_bits)(n & 0x00018000)) << 20);
+}
+
+static __inline tile_bundle_bits
+create_BrType_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0xf)) << 31);
+}
+
+static __inline tile_bundle_bits
+create_Dest_Imm8_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0x0000003f)) << 31) |
+         (((tile_bundle_bits)(n & 0x000000c0)) << 43);
+}
+
+static __inline tile_bundle_bits
+create_Dest_SN(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3) << 2);
+}
+
+static __inline tile_bundle_bits
+create_Dest_X0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3f) << 0);
+}
+
+static __inline tile_bundle_bits
+create_Dest_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0x3f)) << 31);
+}
+
+static __inline tile_bundle_bits
+create_Dest_Y0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3f) << 0);
+}
+
+static __inline tile_bundle_bits
+create_Dest_Y1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0x3f)) << 31);
+}
+
+static __inline tile_bundle_bits
+create_Imm16_X0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0xffff) << 12);
+}
+
+static __inline tile_bundle_bits
+create_Imm16_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0xffff)) << 43);
+}
+
+static __inline tile_bundle_bits
+create_Imm8_SN(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0xff) << 0);
+}
+
+static __inline tile_bundle_bits
+create_Imm8_X0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0xff) << 12);
+}
+
+static __inline tile_bundle_bits
+create_Imm8_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0xff)) << 43);
+}
+
+static __inline tile_bundle_bits
+create_Imm8_Y0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0xff) << 12);
+}
+
+static __inline tile_bundle_bits
+create_Imm8_Y1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0xff)) << 43);
+}
+
+static __inline tile_bundle_bits
+create_ImmOpcodeExtension_X0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x7f) << 20);
+}
+
+static __inline tile_bundle_bits
+create_ImmOpcodeExtension_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0x7f)) << 51);
+}
+
+static __inline tile_bundle_bits
+create_ImmRROpcodeExtension_SN(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3) << 8);
+}
+
+static __inline tile_bundle_bits
+create_JOffLong_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0x00007fff)) << 43) |
+         (((tile_bundle_bits)(n & 0x00018000)) << 20) |
+         (((tile_bundle_bits)(n & 0x001e0000)) << 14) |
+         (((tile_bundle_bits)(n & 0x07e00000)) << 16) |
+         (((tile_bundle_bits)(n & 0x18000000)) << 31);
+}
+
+static __inline tile_bundle_bits
+create_JOff_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0x00007fff)) << 43) |
+         (((tile_bundle_bits)(n & 0x00018000)) << 20) |
+         (((tile_bundle_bits)(n & 0x001e0000)) << 14) |
+         (((tile_bundle_bits)(n & 0x07e00000)) << 16) |
+         (((tile_bundle_bits)(n & 0x08000000)) << 31);
+}
+
+static __inline tile_bundle_bits
+create_MF_Imm15_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0x00003fff)) << 37) |
+         (((tile_bundle_bits)(n & 0x00004000)) << 44);
+}
+
+static __inline tile_bundle_bits
+create_MMEnd_X0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x1f) << 18);
+}
+
+static __inline tile_bundle_bits
+create_MMEnd_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0x1f)) << 49);
+}
+
+static __inline tile_bundle_bits
+create_MMStart_X0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x1f) << 23);
+}
+
+static __inline tile_bundle_bits
+create_MMStart_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0x1f)) << 54);
+}
+
+static __inline tile_bundle_bits
+create_MT_Imm15_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0x0000003f)) << 31) |
+         (((tile_bundle_bits)(n & 0x00003fc0)) << 37) |
+         (((tile_bundle_bits)(n & 0x00004000)) << 44);
+}
+
+static __inline tile_bundle_bits
+create_Mode(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0x1)) << 63);
+}
+
+static __inline tile_bundle_bits
+create_NoRegOpcodeExtension_SN(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0xf) << 0);
+}
+
+static __inline tile_bundle_bits
+create_Opcode_SN(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3f) << 10);
+}
+
+static __inline tile_bundle_bits
+create_Opcode_X0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x7) << 28);
+}
+
+static __inline tile_bundle_bits
+create_Opcode_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0xf)) << 59);
+}
+
+static __inline tile_bundle_bits
+create_Opcode_Y0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0xf) << 27);
+}
+
+static __inline tile_bundle_bits
+create_Opcode_Y1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0xf)) << 59);
+}
+
+static __inline tile_bundle_bits
+create_Opcode_Y2(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0x7)) << 56);
+}
+
+static __inline tile_bundle_bits
+create_RROpcodeExtension_SN(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0xf) << 4);
+}
+
+static __inline tile_bundle_bits
+create_RRROpcodeExtension_X0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x1ff) << 18);
+}
+
+static __inline tile_bundle_bits
+create_RRROpcodeExtension_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0x1ff)) << 49);
+}
+
+static __inline tile_bundle_bits
+create_RRROpcodeExtension_Y0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3) << 18);
+}
+
+static __inline tile_bundle_bits
+create_RRROpcodeExtension_Y1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0x3)) << 49);
+}
+
+static __inline tile_bundle_bits
+create_RouteOpcodeExtension_SN(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3ff) << 0);
+}
+
+static __inline tile_bundle_bits
+create_S_X0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x1) << 27);
+}
+
+static __inline tile_bundle_bits
+create_S_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0x1)) << 58);
+}
+
+static __inline tile_bundle_bits
+create_ShAmt_X0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x1f) << 12);
+}
+
+static __inline tile_bundle_bits
+create_ShAmt_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0x1f)) << 43);
+}
+
+static __inline tile_bundle_bits
+create_ShAmt_Y0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x1f) << 12);
+}
+
+static __inline tile_bundle_bits
+create_ShAmt_Y1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0x1f)) << 43);
+}
+
+static __inline tile_bundle_bits
+create_SrcA_X0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3f) << 6);
+}
+
+static __inline tile_bundle_bits
+create_SrcA_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0x3f)) << 37);
+}
+
+static __inline tile_bundle_bits
+create_SrcA_Y0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3f) << 6);
+}
+
+static __inline tile_bundle_bits
+create_SrcA_Y1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0x3f)) << 37);
+}
+
+static __inline tile_bundle_bits
+create_SrcA_Y2(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x00000001) << 26) |
+         (((tile_bundle_bits)(n & 0x0000003e)) << 50);
+}
+
+static __inline tile_bundle_bits
+create_SrcBDest_Y2(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3f) << 20);
+}
+
+static __inline tile_bundle_bits
+create_SrcB_X0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3f) << 12);
+}
+
+static __inline tile_bundle_bits
+create_SrcB_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0x3f)) << 43);
+}
+
+static __inline tile_bundle_bits
+create_SrcB_Y0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3f) << 12);
+}
+
+static __inline tile_bundle_bits
+create_SrcB_Y1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0x3f)) << 43);
+}
+
+static __inline tile_bundle_bits
+create_Src_SN(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3) << 0);
+}
+
+static __inline tile_bundle_bits
+create_UnOpcodeExtension_X0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x1f) << 12);
+}
+
+static __inline tile_bundle_bits
+create_UnOpcodeExtension_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0x1f)) << 43);
+}
+
+static __inline tile_bundle_bits
+create_UnOpcodeExtension_Y0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x1f) << 12);
+}
+
+static __inline tile_bundle_bits
+create_UnOpcodeExtension_Y1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0x1f)) << 43);
+}
+
+static __inline tile_bundle_bits
+create_UnShOpcodeExtension_X0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3ff) << 17);
+}
+
+static __inline tile_bundle_bits
+create_UnShOpcodeExtension_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0x3ff)) << 48);
+}
+
+static __inline tile_bundle_bits
+create_UnShOpcodeExtension_Y0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x7) << 17);
+}
+
+static __inline tile_bundle_bits
+create_UnShOpcodeExtension_Y1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0x7)) << 48);
+}
+
+
+typedef unsigned short tile_sn_instruction_bits;
+
+
+typedef enum
+{
+  TILE_PIPELINE_X0,
+  TILE_PIPELINE_X1,
+  TILE_PIPELINE_Y0,
+  TILE_PIPELINE_Y1,
+  TILE_PIPELINE_Y2,
+} tile_pipeline;
+
+#define tile_is_x_pipeline(p) ((int)(p) <= (int)TILE_PIPELINE_X1)
+
+typedef enum
+{
+  TILE_OP_TYPE_REGISTER,
+  TILE_OP_TYPE_IMMEDIATE,
+  TILE_OP_TYPE_ADDRESS,
+  TILE_OP_TYPE_SPR
+} tile_operand_type;
+
+/* This is the bit that determines if a bundle is in the Y encoding. */
+#define TILE_BUNDLE_Y_ENCODING_MASK ((tile_bundle_bits)1 << 63)
+
+enum
+{
+  /* Maximum number of instructions in a bundle (2 for X, 3 for Y). */
+  TILE_MAX_INSTRUCTIONS_PER_BUNDLE = 3,
+
+  /* How many different pipeline encodings are there? X0, X1, Y0, Y1, Y2. */
+  TILE_NUM_PIPELINE_ENCODINGS = 5,
+
+  /* Log base 2 of TILE_BUNDLE_SIZE_IN_BYTES. */
+  TILE_LOG2_BUNDLE_SIZE_IN_BYTES = 3,
+
+  /* Instructions take this many bytes. */
+  TILE_BUNDLE_SIZE_IN_BYTES = 1 << TILE_LOG2_BUNDLE_SIZE_IN_BYTES,
+
+  /* Log base 2 of TILE_BUNDLE_ALIGNMENT_IN_BYTES. */
+  TILE_LOG2_BUNDLE_ALIGNMENT_IN_BYTES = 3,
+
+  /* Bundles should be aligned modulo this number of bytes. */
+  TILE_BUNDLE_ALIGNMENT_IN_BYTES =
+    (1 << TILE_LOG2_BUNDLE_ALIGNMENT_IN_BYTES),
+
+  /* Log base 2 of TILE_SN_INSTRUCTION_SIZE_IN_BYTES. */
+  TILE_LOG2_SN_INSTRUCTION_SIZE_IN_BYTES = 1,
+
+  /* Static network instructions take this many bytes. */
+  TILE_SN_INSTRUCTION_SIZE_IN_BYTES =
+    (1 << TILE_LOG2_SN_INSTRUCTION_SIZE_IN_BYTES),
+
+  /* Number of registers (some are magic, such as network I/O). */
+  TILE_NUM_REGISTERS = 64,
+
+  /* Number of static network registers. */
+  TILE_NUM_SN_REGISTERS = 4
+};
+
+
+struct tile_operand
+{
+  /* Is this operand a register, immediate or address? */
+  tile_operand_type type;
+
+  /* The default relocation type for this operand.  */
+  signed int default_reloc : 16;
+
+  /* How many bits is this value? (used for range checking) */
+  unsigned int num_bits : 5;
+
+  /* Is the value signed? (used for range checking) */
+  unsigned int is_signed : 1;
+
+  /* Is this operand a source register? */
+  unsigned int is_src_reg : 1;
+
+  /* Is this operand written? (i.e. is it a destination register) */
+  unsigned int is_dest_reg : 1;
+
+  /* Is this operand PC-relative? */
+  unsigned int is_pc_relative : 1;
+
+  /* By how many bits do we right shift the value before inserting? */
+  unsigned int rightshift : 2;
+
+  /* Return the bits for this operand to be ORed into an existing bundle. */
+  tile_bundle_bits (*insert) (int op);
+
+  /* Extract this operand and return it. */
+  unsigned int (*extract) (tile_bundle_bits bundle);
+};
+
+
+extern const struct tile_operand tile_operands[];
+
+/* One finite-state machine per pipe for rapid instruction decoding. */
+extern const unsigned short * const
+tile_bundle_decoder_fsms[TILE_NUM_PIPELINE_ENCODINGS];
+
+
+struct tile_opcode
+{
+  /* The opcode mnemonic, e.g. "add" */
+  const char *name;
+
+  /* The enum value for this mnemonic. */
+  tile_mnemonic mnemonic;
+
+  /* A bit mask of which of the five pipes this instruction
+     is compatible with:
+     X0  0x01
+     X1  0x02
+     Y0  0x04
+     Y1  0x08
+     Y2  0x10 */
+  unsigned char pipes;
+
+  /* How many operands are there? */
+  unsigned char num_operands;
+
+  /* Which register does this write implicitly, or TREG_ZERO if none? */
+  unsigned char implicitly_written_register;
+
+  /* Can this be bundled with other instructions (almost always true). */
+  unsigned char can_bundle;
+
+  /* The description of the operands. Each of these is an
+   * index into the tile_operands[] table. */
+  unsigned char operands[TILE_NUM_PIPELINE_ENCODINGS][TILE_MAX_OPERANDS];
+
+  /* A mask of which bits have predefined values for each pipeline.
+   * This is useful for disassembly. */
+  tile_bundle_bits fixed_bit_masks[TILE_NUM_PIPELINE_ENCODINGS];
+
+  /* For each bit set in fixed_bit_masks, what the value is for this
+   * instruction. */
+  tile_bundle_bits fixed_bit_values[TILE_NUM_PIPELINE_ENCODINGS];
+};
+
+extern const struct tile_opcode tile_opcodes[];
+
+struct tile_sn_opcode
+{
+  /* The opcode mnemonic, e.g. "add" */
+  const char *name;
+
+  /* The enum value for this mnemonic. */
+  tile_sn_mnemonic mnemonic;
+
+  /* How many operands are there? */
+  unsigned char num_operands;
+
+  /* The description of the operands. Each of these is an
+   * index into the tile_operands[] table. */
+  unsigned char operands[TILE_SN_MAX_OPERANDS];
+
+  /* A mask of which bits have predefined values.
+   * This is useful for disassembly. */
+  tile_sn_instruction_bits fixed_bit_mask;
+
+  /* For each bit set in fixed_bit_masks, what its value is. */
+  tile_sn_instruction_bits fixed_bit_values;
+};
+
+extern const struct tile_sn_opcode tile_sn_opcodes[];
+
+/* Used for non-textual disassembly into structs. */
+struct tile_decoded_instruction
+{
+  const struct tile_opcode *opcode;
+  const struct tile_operand *operands[TILE_MAX_OPERANDS];
+  int operand_values[TILE_MAX_OPERANDS];
+};
+
+
+/* Disassemble a bundle into a struct for machine processing. */
+extern int parse_insn_tile(tile_bundle_bits bits,
+                           unsigned int pc,
+                           struct tile_decoded_instruction
+                           decoded[TILE_MAX_INSTRUCTIONS_PER_BUNDLE]);
+
+
+/* Canonical names of all the registers. */
+/* ISSUE: This table lives in "tile-dis.c" */
+extern const char * const tile_register_names[];
+
+/* Descriptor for a special-purpose register. */
+struct tile_spr
+{
+  /* The number */
+  int number;
+
+  /* The name */
+  const char *name;
+};
+
+/* List of all the SPRs; ordered by increasing number. */
+extern const struct tile_spr tile_sprs[];
+
+/* Number of special-purpose registers. */
+extern const int tile_num_sprs;
+
+extern const char *
+get_tile_spr_name (int num);
+
+#endif /* opcode_tile_h */
diff --git a/arch/tile/include/asm/opcode-tile_64.h b/arch/tile/include/asm/opcode-tile_64.h
new file mode 100644
index 0000000..90f8dd3
--- /dev/null
+++ b/arch/tile/include/asm/opcode-tile_64.h
@@ -0,0 +1,1597 @@
+/* tile.h -- Header file for TILE opcode table
+   Copyright (C) 2005 Free Software Foundation, Inc.
+   Contributed by Tilera Corp. */
+
+#ifndef opcode_tile_h
+#define opcode_tile_h
+
+typedef unsigned long long tile_bundle_bits;
+
+
+enum
+{
+  TILE_MAX_OPERANDS = 5 /* mm */
+};
+
+typedef enum
+{
+  TILE_OPC_BPT,
+  TILE_OPC_INFO,
+  TILE_OPC_INFOL,
+  TILE_OPC_J,
+  TILE_OPC_JAL,
+  TILE_OPC_MOVE,
+  TILE_OPC_MOVE_SN,
+  TILE_OPC_MOVEI,
+  TILE_OPC_MOVEI_SN,
+  TILE_OPC_MOVELI,
+  TILE_OPC_MOVELI_SN,
+  TILE_OPC_MOVELIS,
+  TILE_OPC_PREFETCH,
+  TILE_OPC_ADD,
+  TILE_OPC_ADD_SN,
+  TILE_OPC_ADDB,
+  TILE_OPC_ADDB_SN,
+  TILE_OPC_ADDBS_U,
+  TILE_OPC_ADDBS_U_SN,
+  TILE_OPC_ADDH,
+  TILE_OPC_ADDH_SN,
+  TILE_OPC_ADDHS,
+  TILE_OPC_ADDHS_SN,
+  TILE_OPC_ADDI,
+  TILE_OPC_ADDI_SN,
+  TILE_OPC_ADDIB,
+  TILE_OPC_ADDIB_SN,
+  TILE_OPC_ADDIH,
+  TILE_OPC_ADDIH_SN,
+  TILE_OPC_ADDLI,
+  TILE_OPC_ADDLI_SN,
+  TILE_OPC_ADDLIS,
+  TILE_OPC_ADDS,
+  TILE_OPC_ADDS_SN,
+  TILE_OPC_ADIFFB_U,
+  TILE_OPC_ADIFFB_U_SN,
+  TILE_OPC_ADIFFH,
+  TILE_OPC_ADIFFH_SN,
+  TILE_OPC_AND,
+  TILE_OPC_AND_SN,
+  TILE_OPC_ANDI,
+  TILE_OPC_ANDI_SN,
+  TILE_OPC_AULI,
+  TILE_OPC_AVGB_U,
+  TILE_OPC_AVGB_U_SN,
+  TILE_OPC_AVGH,
+  TILE_OPC_AVGH_SN,
+  TILE_OPC_BBNS,
+  TILE_OPC_BBNS_SN,
+  TILE_OPC_BBNST,
+  TILE_OPC_BBNST_SN,
+  TILE_OPC_BBS,
+  TILE_OPC_BBS_SN,
+  TILE_OPC_BBST,
+  TILE_OPC_BBST_SN,
+  TILE_OPC_BGEZ,
+  TILE_OPC_BGEZ_SN,
+  TILE_OPC_BGEZT,
+  TILE_OPC_BGEZT_SN,
+  TILE_OPC_BGZ,
+  TILE_OPC_BGZ_SN,
+  TILE_OPC_BGZT,
+  TILE_OPC_BGZT_SN,
+  TILE_OPC_BITX,
+  TILE_OPC_BITX_SN,
+  TILE_OPC_BLEZ,
+  TILE_OPC_BLEZ_SN,
+  TILE_OPC_BLEZT,
+  TILE_OPC_BLEZT_SN,
+  TILE_OPC_BLZ,
+  TILE_OPC_BLZ_SN,
+  TILE_OPC_BLZT,
+  TILE_OPC_BLZT_SN,
+  TILE_OPC_BNZ,
+  TILE_OPC_BNZ_SN,
+  TILE_OPC_BNZT,
+  TILE_OPC_BNZT_SN,
+  TILE_OPC_BYTEX,
+  TILE_OPC_BYTEX_SN,
+  TILE_OPC_BZ,
+  TILE_OPC_BZ_SN,
+  TILE_OPC_BZT,
+  TILE_OPC_BZT_SN,
+  TILE_OPC_CLZ,
+  TILE_OPC_CLZ_SN,
+  TILE_OPC_CRC32_32,
+  TILE_OPC_CRC32_32_SN,
+  TILE_OPC_CRC32_8,
+  TILE_OPC_CRC32_8_SN,
+  TILE_OPC_CTZ,
+  TILE_OPC_CTZ_SN,
+  TILE_OPC_DRAIN,
+  TILE_OPC_DTLBPR,
+  TILE_OPC_DWORD_ALIGN,
+  TILE_OPC_DWORD_ALIGN_SN,
+  TILE_OPC_FINV,
+  TILE_OPC_FLUSH,
+  TILE_OPC_FNOP,
+  TILE_OPC_ICOH,
+  TILE_OPC_ILL,
+  TILE_OPC_INTHB,
+  TILE_OPC_INTHB_SN,
+  TILE_OPC_INTHH,
+  TILE_OPC_INTHH_SN,
+  TILE_OPC_INTLB,
+  TILE_OPC_INTLB_SN,
+  TILE_OPC_INTLH,
+  TILE_OPC_INTLH_SN,
+  TILE_OPC_INV,
+  TILE_OPC_IRET,
+  TILE_OPC_JALB,
+  TILE_OPC_JALF,
+  TILE_OPC_JALR,
+  TILE_OPC_JALRP,
+  TILE_OPC_JB,
+  TILE_OPC_JF,
+  TILE_OPC_JR,
+  TILE_OPC_JRP,
+  TILE_OPC_LB,
+  TILE_OPC_LB_SN,
+  TILE_OPC_LB_U,
+  TILE_OPC_LB_U_SN,
+  TILE_OPC_LBADD,
+  TILE_OPC_LBADD_SN,
+  TILE_OPC_LBADD_U,
+  TILE_OPC_LBADD_U_SN,
+  TILE_OPC_LH,
+  TILE_OPC_LH_SN,
+  TILE_OPC_LH_U,
+  TILE_OPC_LH_U_SN,
+  TILE_OPC_LHADD,
+  TILE_OPC_LHADD_SN,
+  TILE_OPC_LHADD_U,
+  TILE_OPC_LHADD_U_SN,
+  TILE_OPC_LNK,
+  TILE_OPC_LNK_SN,
+  TILE_OPC_LW,
+  TILE_OPC_LW_SN,
+  TILE_OPC_LW_NA,
+  TILE_OPC_LW_NA_SN,
+  TILE_OPC_LWADD,
+  TILE_OPC_LWADD_SN,
+  TILE_OPC_LWADD_NA,
+  TILE_OPC_LWADD_NA_SN,
+  TILE_OPC_MAXB_U,
+  TILE_OPC_MAXB_U_SN,
+  TILE_OPC_MAXH,
+  TILE_OPC_MAXH_SN,
+  TILE_OPC_MAXIB_U,
+  TILE_OPC_MAXIB_U_SN,
+  TILE_OPC_MAXIH,
+  TILE_OPC_MAXIH_SN,
+  TILE_OPC_MF,
+  TILE_OPC_MFSPR,
+  TILE_OPC_MINB_U,
+  TILE_OPC_MINB_U_SN,
+  TILE_OPC_MINH,
+  TILE_OPC_MINH_SN,
+  TILE_OPC_MINIB_U,
+  TILE_OPC_MINIB_U_SN,
+  TILE_OPC_MINIH,
+  TILE_OPC_MINIH_SN,
+  TILE_OPC_MM,
+  TILE_OPC_MNZ,
+  TILE_OPC_MNZ_SN,
+  TILE_OPC_MNZB,
+  TILE_OPC_MNZB_SN,
+  TILE_OPC_MNZH,
+  TILE_OPC_MNZH_SN,
+  TILE_OPC_MTSPR,
+  TILE_OPC_MULHH_SS,
+  TILE_OPC_MULHH_SS_SN,
+  TILE_OPC_MULHH_SU,
+  TILE_OPC_MULHH_SU_SN,
+  TILE_OPC_MULHH_UU,
+  TILE_OPC_MULHH_UU_SN,
+  TILE_OPC_MULHHA_SS,
+  TILE_OPC_MULHHA_SS_SN,
+  TILE_OPC_MULHHA_SU,
+  TILE_OPC_MULHHA_SU_SN,
+  TILE_OPC_MULHHA_UU,
+  TILE_OPC_MULHHA_UU_SN,
+  TILE_OPC_MULHHSA_UU,
+  TILE_OPC_MULHHSA_UU_SN,
+  TILE_OPC_MULHL_SS,
+  TILE_OPC_MULHL_SS_SN,
+  TILE_OPC_MULHL_SU,
+  TILE_OPC_MULHL_SU_SN,
+  TILE_OPC_MULHL_US,
+  TILE_OPC_MULHL_US_SN,
+  TILE_OPC_MULHL_UU,
+  TILE_OPC_MULHL_UU_SN,
+  TILE_OPC_MULHLA_SS,
+  TILE_OPC_MULHLA_SS_SN,
+  TILE_OPC_MULHLA_SU,
+  TILE_OPC_MULHLA_SU_SN,
+  TILE_OPC_MULHLA_US,
+  TILE_OPC_MULHLA_US_SN,
+  TILE_OPC_MULHLA_UU,
+  TILE_OPC_MULHLA_UU_SN,
+  TILE_OPC_MULHLSA_UU,
+  TILE_OPC_MULHLSA_UU_SN,
+  TILE_OPC_MULLL_SS,
+  TILE_OPC_MULLL_SS_SN,
+  TILE_OPC_MULLL_SU,
+  TILE_OPC_MULLL_SU_SN,
+  TILE_OPC_MULLL_UU,
+  TILE_OPC_MULLL_UU_SN,
+  TILE_OPC_MULLLA_SS,
+  TILE_OPC_MULLLA_SS_SN,
+  TILE_OPC_MULLLA_SU,
+  TILE_OPC_MULLLA_SU_SN,
+  TILE_OPC_MULLLA_UU,
+  TILE_OPC_MULLLA_UU_SN,
+  TILE_OPC_MULLLSA_UU,
+  TILE_OPC_MULLLSA_UU_SN,
+  TILE_OPC_MVNZ,
+  TILE_OPC_MVNZ_SN,
+  TILE_OPC_MVZ,
+  TILE_OPC_MVZ_SN,
+  TILE_OPC_MZ,
+  TILE_OPC_MZ_SN,
+  TILE_OPC_MZB,
+  TILE_OPC_MZB_SN,
+  TILE_OPC_MZH,
+  TILE_OPC_MZH_SN,
+  TILE_OPC_NAP,
+  TILE_OPC_NOP,
+  TILE_OPC_NOR,
+  TILE_OPC_NOR_SN,
+  TILE_OPC_OR,
+  TILE_OPC_OR_SN,
+  TILE_OPC_ORI,
+  TILE_OPC_ORI_SN,
+  TILE_OPC_PACKBS_U,
+  TILE_OPC_PACKBS_U_SN,
+  TILE_OPC_PACKHB,
+  TILE_OPC_PACKHB_SN,
+  TILE_OPC_PACKHS,
+  TILE_OPC_PACKHS_SN,
+  TILE_OPC_PACKLB,
+  TILE_OPC_PACKLB_SN,
+  TILE_OPC_PCNT,
+  TILE_OPC_PCNT_SN,
+  TILE_OPC_RL,
+  TILE_OPC_RL_SN,
+  TILE_OPC_RLI,
+  TILE_OPC_RLI_SN,
+  TILE_OPC_S1A,
+  TILE_OPC_S1A_SN,
+  TILE_OPC_S2A,
+  TILE_OPC_S2A_SN,
+  TILE_OPC_S3A,
+  TILE_OPC_S3A_SN,
+  TILE_OPC_SADAB_U,
+  TILE_OPC_SADAB_U_SN,
+  TILE_OPC_SADAH,
+  TILE_OPC_SADAH_SN,
+  TILE_OPC_SADAH_U,
+  TILE_OPC_SADAH_U_SN,
+  TILE_OPC_SADB_U,
+  TILE_OPC_SADB_U_SN,
+  TILE_OPC_SADH,
+  TILE_OPC_SADH_SN,
+  TILE_OPC_SADH_U,
+  TILE_OPC_SADH_U_SN,
+  TILE_OPC_SB,
+  TILE_OPC_SBADD,
+  TILE_OPC_SEQ,
+  TILE_OPC_SEQ_SN,
+  TILE_OPC_SEQB,
+  TILE_OPC_SEQB_SN,
+  TILE_OPC_SEQH,
+  TILE_OPC_SEQH_SN,
+  TILE_OPC_SEQI,
+  TILE_OPC_SEQI_SN,
+  TILE_OPC_SEQIB,
+  TILE_OPC_SEQIB_SN,
+  TILE_OPC_SEQIH,
+  TILE_OPC_SEQIH_SN,
+  TILE_OPC_SH,
+  TILE_OPC_SHADD,
+  TILE_OPC_SHL,
+  TILE_OPC_SHL_SN,
+  TILE_OPC_SHLB,
+  TILE_OPC_SHLB_SN,
+  TILE_OPC_SHLH,
+  TILE_OPC_SHLH_SN,
+  TILE_OPC_SHLI,
+  TILE_OPC_SHLI_SN,
+  TILE_OPC_SHLIB,
+  TILE_OPC_SHLIB_SN,
+  TILE_OPC_SHLIH,
+  TILE_OPC_SHLIH_SN,
+  TILE_OPC_SHR,
+  TILE_OPC_SHR_SN,
+  TILE_OPC_SHRB,
+  TILE_OPC_SHRB_SN,
+  TILE_OPC_SHRH,
+  TILE_OPC_SHRH_SN,
+  TILE_OPC_SHRI,
+  TILE_OPC_SHRI_SN,
+  TILE_OPC_SHRIB,
+  TILE_OPC_SHRIB_SN,
+  TILE_OPC_SHRIH,
+  TILE_OPC_SHRIH_SN,
+  TILE_OPC_SLT,
+  TILE_OPC_SLT_SN,
+  TILE_OPC_SLT_U,
+  TILE_OPC_SLT_U_SN,
+  TILE_OPC_SLTB,
+  TILE_OPC_SLTB_SN,
+  TILE_OPC_SLTB_U,
+  TILE_OPC_SLTB_U_SN,
+  TILE_OPC_SLTE,
+  TILE_OPC_SLTE_SN,
+  TILE_OPC_SLTE_U,
+  TILE_OPC_SLTE_U_SN,
+  TILE_OPC_SLTEB,
+  TILE_OPC_SLTEB_SN,
+  TILE_OPC_SLTEB_U,
+  TILE_OPC_SLTEB_U_SN,
+  TILE_OPC_SLTEH,
+  TILE_OPC_SLTEH_SN,
+  TILE_OPC_SLTEH_U,
+  TILE_OPC_SLTEH_U_SN,
+  TILE_OPC_SLTH,
+  TILE_OPC_SLTH_SN,
+  TILE_OPC_SLTH_U,
+  TILE_OPC_SLTH_U_SN,
+  TILE_OPC_SLTI,
+  TILE_OPC_SLTI_SN,
+  TILE_OPC_SLTI_U,
+  TILE_OPC_SLTI_U_SN,
+  TILE_OPC_SLTIB,
+  TILE_OPC_SLTIB_SN,
+  TILE_OPC_SLTIB_U,
+  TILE_OPC_SLTIB_U_SN,
+  TILE_OPC_SLTIH,
+  TILE_OPC_SLTIH_SN,
+  TILE_OPC_SLTIH_U,
+  TILE_OPC_SLTIH_U_SN,
+  TILE_OPC_SNE,
+  TILE_OPC_SNE_SN,
+  TILE_OPC_SNEB,
+  TILE_OPC_SNEB_SN,
+  TILE_OPC_SNEH,
+  TILE_OPC_SNEH_SN,
+  TILE_OPC_SRA,
+  TILE_OPC_SRA_SN,
+  TILE_OPC_SRAB,
+  TILE_OPC_SRAB_SN,
+  TILE_OPC_SRAH,
+  TILE_OPC_SRAH_SN,
+  TILE_OPC_SRAI,
+  TILE_OPC_SRAI_SN,
+  TILE_OPC_SRAIB,
+  TILE_OPC_SRAIB_SN,
+  TILE_OPC_SRAIH,
+  TILE_OPC_SRAIH_SN,
+  TILE_OPC_SUB,
+  TILE_OPC_SUB_SN,
+  TILE_OPC_SUBB,
+  TILE_OPC_SUBB_SN,
+  TILE_OPC_SUBBS_U,
+  TILE_OPC_SUBBS_U_SN,
+  TILE_OPC_SUBH,
+  TILE_OPC_SUBH_SN,
+  TILE_OPC_SUBHS,
+  TILE_OPC_SUBHS_SN,
+  TILE_OPC_SUBS,
+  TILE_OPC_SUBS_SN,
+  TILE_OPC_SW,
+  TILE_OPC_SWADD,
+  TILE_OPC_SWINT0,
+  TILE_OPC_SWINT1,
+  TILE_OPC_SWINT2,
+  TILE_OPC_SWINT3,
+  TILE_OPC_TBLIDXB0,
+  TILE_OPC_TBLIDXB0_SN,
+  TILE_OPC_TBLIDXB1,
+  TILE_OPC_TBLIDXB1_SN,
+  TILE_OPC_TBLIDXB2,
+  TILE_OPC_TBLIDXB2_SN,
+  TILE_OPC_TBLIDXB3,
+  TILE_OPC_TBLIDXB3_SN,
+  TILE_OPC_TNS,
+  TILE_OPC_TNS_SN,
+  TILE_OPC_WH64,
+  TILE_OPC_XOR,
+  TILE_OPC_XOR_SN,
+  TILE_OPC_XORI,
+  TILE_OPC_XORI_SN,
+  TILE_OPC_NONE
+} tile_mnemonic;
+
+/* 64-bit pattern for a { bpt ; nop } bundle. */
+#define TILE_BPT_BUNDLE 0x400b3cae70166000ULL
+
+
+#define TILE_ELF_MACHINE_CODE EM_TILEPRO
+
+#define TILE_ELF_NAME "elf32-tilepro"
+
+enum
+{
+  TILE_SN_MAX_OPERANDS = 6 /* route */
+};
+
+typedef enum
+{
+  TILE_SN_OPC_BZ,
+  TILE_SN_OPC_BNZ,
+  TILE_SN_OPC_JRR,
+  TILE_SN_OPC_FNOP,
+  TILE_SN_OPC_BLZ,
+  TILE_SN_OPC_NOP,
+  TILE_SN_OPC_MOVEI,
+  TILE_SN_OPC_MOVE,
+  TILE_SN_OPC_BGEZ,
+  TILE_SN_OPC_JR,
+  TILE_SN_OPC_BLEZ,
+  TILE_SN_OPC_BBNS,
+  TILE_SN_OPC_JALRR,
+  TILE_SN_OPC_BPT,
+  TILE_SN_OPC_JALR,
+  TILE_SN_OPC_SHR1,
+  TILE_SN_OPC_BGZ,
+  TILE_SN_OPC_BBS,
+  TILE_SN_OPC_SHL8II,
+  TILE_SN_OPC_ADDI,
+  TILE_SN_OPC_HALT,
+  TILE_SN_OPC_ROUTE,
+  TILE_SN_OPC_NONE
+} tile_sn_mnemonic;
+
+extern const unsigned char tile_sn_route_encode[6 * 6 * 6];
+extern const signed char tile_sn_route_decode[256][3];
+extern const char tile_sn_direction_names[6][5];
+extern const signed char tile_sn_dest_map[6][6];
+
+
+static __inline unsigned int
+get_BrOff_SN(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 0)) & 0x3ff);
+}
+
+static __inline unsigned int
+get_BrOff_X1(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 43)) & 0x00007fff) |
+         (((unsigned int)(n >> 20)) & 0x00018000);
+}
+
+static __inline unsigned int
+get_BrType_X1(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 31)) & 0xf);
+}
+
+static __inline unsigned int
+get_Dest_Imm8_X1(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 31)) & 0x0000003f) |
+         (((unsigned int)(n >> 43)) & 0x000000c0);
+}
+
+static __inline unsigned int
+get_Dest_SN(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 2)) & 0x3);
+}
+
+static __inline unsigned int
+get_Dest_X0(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 0)) & 0x3f);
+}
+
+static __inline unsigned int
+get_Dest_X1(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 31)) & 0x3f);
+}
+
+static __inline unsigned int
+get_Dest_Y0(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 0)) & 0x3f);
+}
+
+static __inline unsigned int
+get_Dest_Y1(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 31)) & 0x3f);
+}
+
+static __inline unsigned int
+get_Imm16_X0(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 12)) & 0xffff);
+}
+
+static __inline unsigned int
+get_Imm16_X1(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 43)) & 0xffff);
+}
+
+static __inline unsigned int
+get_Imm8_SN(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 0)) & 0xff);
+}
+
+static __inline unsigned int
+get_Imm8_X0(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 12)) & 0xff);
+}
+
+static __inline unsigned int
+get_Imm8_X1(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 43)) & 0xff);
+}
+
+static __inline unsigned int
+get_Imm8_Y0(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 12)) & 0xff);
+}
+
+static __inline unsigned int
+get_Imm8_Y1(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 43)) & 0xff);
+}
+
+static __inline unsigned int
+get_ImmOpcodeExtension_X0(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 20)) & 0x7f);
+}
+
+static __inline unsigned int
+get_ImmOpcodeExtension_X1(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 51)) & 0x7f);
+}
+
+static __inline unsigned int
+get_ImmRROpcodeExtension_SN(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 8)) & 0x3);
+}
+
+static __inline unsigned int
+get_JOffLong_X1(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 43)) & 0x00007fff) |
+         (((unsigned int)(n >> 20)) & 0x00018000) |
+         (((unsigned int)(n >> 14)) & 0x001e0000) |
+         (((unsigned int)(n >> 16)) & 0x07e00000) |
+         (((unsigned int)(n >> 31)) & 0x18000000);
+}
+
+static __inline unsigned int
+get_JOff_X1(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 43)) & 0x00007fff) |
+         (((unsigned int)(n >> 20)) & 0x00018000) |
+         (((unsigned int)(n >> 14)) & 0x001e0000) |
+         (((unsigned int)(n >> 16)) & 0x07e00000) |
+         (((unsigned int)(n >> 31)) & 0x08000000);
+}
+
+static __inline unsigned int
+get_MF_Imm15_X1(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 37)) & 0x00003fff) |
+         (((unsigned int)(n >> 44)) & 0x00004000);
+}
+
+static __inline unsigned int
+get_MMEnd_X0(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 18)) & 0x1f);
+}
+
+static __inline unsigned int
+get_MMEnd_X1(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 49)) & 0x1f);
+}
+
+static __inline unsigned int
+get_MMStart_X0(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 23)) & 0x1f);
+}
+
+static __inline unsigned int
+get_MMStart_X1(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 54)) & 0x1f);
+}
+
+static __inline unsigned int
+get_MT_Imm15_X1(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 31)) & 0x0000003f) |
+         (((unsigned int)(n >> 37)) & 0x00003fc0) |
+         (((unsigned int)(n >> 44)) & 0x00004000);
+}
+
+static __inline unsigned int
+get_Mode(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 63)) & 0x1);
+}
+
+static __inline unsigned int
+get_NoRegOpcodeExtension_SN(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 0)) & 0xf);
+}
+
+static __inline unsigned int
+get_Opcode_SN(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 10)) & 0x3f);
+}
+
+static __inline unsigned int
+get_Opcode_X0(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 28)) & 0x7);
+}
+
+static __inline unsigned int
+get_Opcode_X1(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 59)) & 0xf);
+}
+
+static __inline unsigned int
+get_Opcode_Y0(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 27)) & 0xf);
+}
+
+static __inline unsigned int
+get_Opcode_Y1(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 59)) & 0xf);
+}
+
+static __inline unsigned int
+get_Opcode_Y2(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 56)) & 0x7);
+}
+
+static __inline unsigned int
+get_RROpcodeExtension_SN(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 4)) & 0xf);
+}
+
+static __inline unsigned int
+get_RRROpcodeExtension_X0(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 18)) & 0x1ff);
+}
+
+static __inline unsigned int
+get_RRROpcodeExtension_X1(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 49)) & 0x1ff);
+}
+
+static __inline unsigned int
+get_RRROpcodeExtension_Y0(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 18)) & 0x3);
+}
+
+static __inline unsigned int
+get_RRROpcodeExtension_Y1(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 49)) & 0x3);
+}
+
+static __inline unsigned int
+get_RouteOpcodeExtension_SN(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 0)) & 0x3ff);
+}
+
+static __inline unsigned int
+get_S_X0(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 27)) & 0x1);
+}
+
+static __inline unsigned int
+get_S_X1(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 58)) & 0x1);
+}
+
+static __inline unsigned int
+get_ShAmt_X0(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 12)) & 0x1f);
+}
+
+static __inline unsigned int
+get_ShAmt_X1(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 43)) & 0x1f);
+}
+
+static __inline unsigned int
+get_ShAmt_Y0(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 12)) & 0x1f);
+}
+
+static __inline unsigned int
+get_ShAmt_Y1(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 43)) & 0x1f);
+}
+
+static __inline unsigned int
+get_SrcA_X0(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 6)) & 0x3f);
+}
+
+static __inline unsigned int
+get_SrcA_X1(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 37)) & 0x3f);
+}
+
+static __inline unsigned int
+get_SrcA_Y0(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 6)) & 0x3f);
+}
+
+static __inline unsigned int
+get_SrcA_Y1(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 37)) & 0x3f);
+}
+
+static __inline unsigned int
+get_SrcA_Y2(tile_bundle_bits n)
+{
+  return (((n >> 26)) & 0x00000001) |
+         (((unsigned int)(n >> 50)) & 0x0000003e);
+}
+
+static __inline unsigned int
+get_SrcBDest_Y2(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 20)) & 0x3f);
+}
+
+static __inline unsigned int
+get_SrcB_X0(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 12)) & 0x3f);
+}
+
+static __inline unsigned int
+get_SrcB_X1(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 43)) & 0x3f);
+}
+
+static __inline unsigned int
+get_SrcB_Y0(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 12)) & 0x3f);
+}
+
+static __inline unsigned int
+get_SrcB_Y1(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 43)) & 0x3f);
+}
+
+static __inline unsigned int
+get_Src_SN(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 0)) & 0x3);
+}
+
+static __inline unsigned int
+get_UnOpcodeExtension_X0(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 12)) & 0x1f);
+}
+
+static __inline unsigned int
+get_UnOpcodeExtension_X1(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 43)) & 0x1f);
+}
+
+static __inline unsigned int
+get_UnOpcodeExtension_Y0(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 12)) & 0x1f);
+}
+
+static __inline unsigned int
+get_UnOpcodeExtension_Y1(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 43)) & 0x1f);
+}
+
+static __inline unsigned int
+get_UnShOpcodeExtension_X0(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 17)) & 0x3ff);
+}
+
+static __inline unsigned int
+get_UnShOpcodeExtension_X1(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 48)) & 0x3ff);
+}
+
+static __inline unsigned int
+get_UnShOpcodeExtension_Y0(tile_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 17)) & 0x7);
+}
+
+static __inline unsigned int
+get_UnShOpcodeExtension_Y1(tile_bundle_bits n)
+{
+  return (((unsigned int)(n >> 48)) & 0x7);
+}
+
+
+static __inline int
+sign_extend(int n, int num_bits)
+{
+  int shift = (int)(sizeof(int) * 8 - num_bits);
+  return (n << shift) >> shift;
+}
+
+
+
+static __inline tile_bundle_bits
+create_BrOff_SN(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3ff) << 0);
+}
+
+static __inline tile_bundle_bits
+create_BrOff_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0x00007fff)) << 43) |
+         (((tile_bundle_bits)(n & 0x00018000)) << 20);
+}
+
+static __inline tile_bundle_bits
+create_BrType_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0xf)) << 31);
+}
+
+static __inline tile_bundle_bits
+create_Dest_Imm8_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0x0000003f)) << 31) |
+         (((tile_bundle_bits)(n & 0x000000c0)) << 43);
+}
+
+static __inline tile_bundle_bits
+create_Dest_SN(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3) << 2);
+}
+
+static __inline tile_bundle_bits
+create_Dest_X0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3f) << 0);
+}
+
+static __inline tile_bundle_bits
+create_Dest_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0x3f)) << 31);
+}
+
+static __inline tile_bundle_bits
+create_Dest_Y0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3f) << 0);
+}
+
+static __inline tile_bundle_bits
+create_Dest_Y1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0x3f)) << 31);
+}
+
+static __inline tile_bundle_bits
+create_Imm16_X0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0xffff) << 12);
+}
+
+static __inline tile_bundle_bits
+create_Imm16_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0xffff)) << 43);
+}
+
+static __inline tile_bundle_bits
+create_Imm8_SN(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0xff) << 0);
+}
+
+static __inline tile_bundle_bits
+create_Imm8_X0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0xff) << 12);
+}
+
+static __inline tile_bundle_bits
+create_Imm8_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0xff)) << 43);
+}
+
+static __inline tile_bundle_bits
+create_Imm8_Y0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0xff) << 12);
+}
+
+static __inline tile_bundle_bits
+create_Imm8_Y1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0xff)) << 43);
+}
+
+static __inline tile_bundle_bits
+create_ImmOpcodeExtension_X0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x7f) << 20);
+}
+
+static __inline tile_bundle_bits
+create_ImmOpcodeExtension_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0x7f)) << 51);
+}
+
+static __inline tile_bundle_bits
+create_ImmRROpcodeExtension_SN(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3) << 8);
+}
+
+static __inline tile_bundle_bits
+create_JOffLong_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0x00007fff)) << 43) |
+         (((tile_bundle_bits)(n & 0x00018000)) << 20) |
+         (((tile_bundle_bits)(n & 0x001e0000)) << 14) |
+         (((tile_bundle_bits)(n & 0x07e00000)) << 16) |
+         (((tile_bundle_bits)(n & 0x18000000)) << 31);
+}
+
+static __inline tile_bundle_bits
+create_JOff_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0x00007fff)) << 43) |
+         (((tile_bundle_bits)(n & 0x00018000)) << 20) |
+         (((tile_bundle_bits)(n & 0x001e0000)) << 14) |
+         (((tile_bundle_bits)(n & 0x07e00000)) << 16) |
+         (((tile_bundle_bits)(n & 0x08000000)) << 31);
+}
+
+static __inline tile_bundle_bits
+create_MF_Imm15_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0x00003fff)) << 37) |
+         (((tile_bundle_bits)(n & 0x00004000)) << 44);
+}
+
+static __inline tile_bundle_bits
+create_MMEnd_X0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x1f) << 18);
+}
+
+static __inline tile_bundle_bits
+create_MMEnd_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0x1f)) << 49);
+}
+
+static __inline tile_bundle_bits
+create_MMStart_X0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x1f) << 23);
+}
+
+static __inline tile_bundle_bits
+create_MMStart_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0x1f)) << 54);
+}
+
+static __inline tile_bundle_bits
+create_MT_Imm15_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0x0000003f)) << 31) |
+         (((tile_bundle_bits)(n & 0x00003fc0)) << 37) |
+         (((tile_bundle_bits)(n & 0x00004000)) << 44);
+}
+
+static __inline tile_bundle_bits
+create_Mode(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0x1)) << 63);
+}
+
+static __inline tile_bundle_bits
+create_NoRegOpcodeExtension_SN(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0xf) << 0);
+}
+
+static __inline tile_bundle_bits
+create_Opcode_SN(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3f) << 10);
+}
+
+static __inline tile_bundle_bits
+create_Opcode_X0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x7) << 28);
+}
+
+static __inline tile_bundle_bits
+create_Opcode_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0xf)) << 59);
+}
+
+static __inline tile_bundle_bits
+create_Opcode_Y0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0xf) << 27);
+}
+
+static __inline tile_bundle_bits
+create_Opcode_Y1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0xf)) << 59);
+}
+
+static __inline tile_bundle_bits
+create_Opcode_Y2(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0x7)) << 56);
+}
+
+static __inline tile_bundle_bits
+create_RROpcodeExtension_SN(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0xf) << 4);
+}
+
+static __inline tile_bundle_bits
+create_RRROpcodeExtension_X0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x1ff) << 18);
+}
+
+static __inline tile_bundle_bits
+create_RRROpcodeExtension_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0x1ff)) << 49);
+}
+
+static __inline tile_bundle_bits
+create_RRROpcodeExtension_Y0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3) << 18);
+}
+
+static __inline tile_bundle_bits
+create_RRROpcodeExtension_Y1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0x3)) << 49);
+}
+
+static __inline tile_bundle_bits
+create_RouteOpcodeExtension_SN(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3ff) << 0);
+}
+
+static __inline tile_bundle_bits
+create_S_X0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x1) << 27);
+}
+
+static __inline tile_bundle_bits
+create_S_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0x1)) << 58);
+}
+
+static __inline tile_bundle_bits
+create_ShAmt_X0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x1f) << 12);
+}
+
+static __inline tile_bundle_bits
+create_ShAmt_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0x1f)) << 43);
+}
+
+static __inline tile_bundle_bits
+create_ShAmt_Y0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x1f) << 12);
+}
+
+static __inline tile_bundle_bits
+create_ShAmt_Y1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0x1f)) << 43);
+}
+
+static __inline tile_bundle_bits
+create_SrcA_X0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3f) << 6);
+}
+
+static __inline tile_bundle_bits
+create_SrcA_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0x3f)) << 37);
+}
+
+static __inline tile_bundle_bits
+create_SrcA_Y0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3f) << 6);
+}
+
+static __inline tile_bundle_bits
+create_SrcA_Y1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0x3f)) << 37);
+}
+
+static __inline tile_bundle_bits
+create_SrcA_Y2(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x00000001) << 26) |
+         (((tile_bundle_bits)(n & 0x0000003e)) << 50);
+}
+
+static __inline tile_bundle_bits
+create_SrcBDest_Y2(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3f) << 20);
+}
+
+static __inline tile_bundle_bits
+create_SrcB_X0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3f) << 12);
+}
+
+static __inline tile_bundle_bits
+create_SrcB_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0x3f)) << 43);
+}
+
+static __inline tile_bundle_bits
+create_SrcB_Y0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3f) << 12);
+}
+
+static __inline tile_bundle_bits
+create_SrcB_Y1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0x3f)) << 43);
+}
+
+static __inline tile_bundle_bits
+create_Src_SN(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3) << 0);
+}
+
+static __inline tile_bundle_bits
+create_UnOpcodeExtension_X0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x1f) << 12);
+}
+
+static __inline tile_bundle_bits
+create_UnOpcodeExtension_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0x1f)) << 43);
+}
+
+static __inline tile_bundle_bits
+create_UnOpcodeExtension_Y0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x1f) << 12);
+}
+
+static __inline tile_bundle_bits
+create_UnOpcodeExtension_Y1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0x1f)) << 43);
+}
+
+static __inline tile_bundle_bits
+create_UnShOpcodeExtension_X0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3ff) << 17);
+}
+
+static __inline tile_bundle_bits
+create_UnShOpcodeExtension_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0x3ff)) << 48);
+}
+
+static __inline tile_bundle_bits
+create_UnShOpcodeExtension_Y0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x7) << 17);
+}
+
+static __inline tile_bundle_bits
+create_UnShOpcodeExtension_Y1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tile_bundle_bits)(n & 0x7)) << 48);
+}
+
+
+typedef unsigned short tile_sn_instruction_bits;
+
+
+typedef enum
+{
+  TILE_PIPELINE_X0,
+  TILE_PIPELINE_X1,
+  TILE_PIPELINE_Y0,
+  TILE_PIPELINE_Y1,
+  TILE_PIPELINE_Y2,
+} tile_pipeline;
+
+#define tile_is_x_pipeline(p) ((int)(p) <= (int)TILE_PIPELINE_X1)
+
+typedef enum
+{
+  TILE_OP_TYPE_REGISTER,
+  TILE_OP_TYPE_IMMEDIATE,
+  TILE_OP_TYPE_ADDRESS,
+  TILE_OP_TYPE_SPR
+} tile_operand_type;
+
+/* This is the bit that determines if a bundle is in the Y encoding. */
+#define TILE_BUNDLE_Y_ENCODING_MASK ((tile_bundle_bits)1 << 63)
+
+enum
+{
+  /* Maximum number of instructions in a bundle (2 for X, 3 for Y). */
+  TILE_MAX_INSTRUCTIONS_PER_BUNDLE = 3,
+
+  /* How many different pipeline encodings are there? X0, X1, Y0, Y1, Y2. */
+  TILE_NUM_PIPELINE_ENCODINGS = 5,
+
+  /* Log base 2 of TILE_BUNDLE_SIZE_IN_BYTES. */
+  TILE_LOG2_BUNDLE_SIZE_IN_BYTES = 3,
+
+  /* Instructions take this many bytes. */
+  TILE_BUNDLE_SIZE_IN_BYTES = 1 << TILE_LOG2_BUNDLE_SIZE_IN_BYTES,
+
+  /* Log base 2 of TILE_BUNDLE_ALIGNMENT_IN_BYTES. */
+  TILE_LOG2_BUNDLE_ALIGNMENT_IN_BYTES = 3,
+
+  /* Bundles should be aligned modulo this number of bytes. */
+  TILE_BUNDLE_ALIGNMENT_IN_BYTES =
+    (1 << TILE_LOG2_BUNDLE_ALIGNMENT_IN_BYTES),
+
+  /* Log base 2 of TILE_SN_INSTRUCTION_SIZE_IN_BYTES. */
+  TILE_LOG2_SN_INSTRUCTION_SIZE_IN_BYTES = 1,
+
+  /* Static network instructions take this many bytes. */
+  TILE_SN_INSTRUCTION_SIZE_IN_BYTES =
+    (1 << TILE_LOG2_SN_INSTRUCTION_SIZE_IN_BYTES),
+
+  /* Number of registers (some are magic, such as network I/O). */
+  TILE_NUM_REGISTERS = 64,
+
+  /* Number of static network registers. */
+  TILE_NUM_SN_REGISTERS = 4
+};
+
+
+struct tile_operand
+{
+  /* Is this operand a register, immediate or address? */
+  tile_operand_type type;
+
+  /* The default relocation type for this operand.  */
+  signed int default_reloc : 16;
+
+  /* How many bits is this value? (used for range checking) */
+  unsigned int num_bits : 5;
+
+  /* Is the value signed? (used for range checking) */
+  unsigned int is_signed : 1;
+
+  /* Is this operand a source register? */
+  unsigned int is_src_reg : 1;
+
+  /* Is this operand written? (i.e. is it a destination register) */
+  unsigned int is_dest_reg : 1;
+
+  /* Is this operand PC-relative? */
+  unsigned int is_pc_relative : 1;
+
+  /* By how many bits do we right shift the value before inserting? */
+  unsigned int rightshift : 2;
+
+  /* Return the bits for this operand to be ORed into an existing bundle. */
+  tile_bundle_bits (*insert) (int op);
+
+  /* Extract this operand and return it. */
+  unsigned int (*extract) (tile_bundle_bits bundle);
+};
+
+
+extern const struct tile_operand tile_operands[];
+
+/* One finite-state machine per pipe for rapid instruction decoding. */
+extern const unsigned short * const
+tile_bundle_decoder_fsms[TILE_NUM_PIPELINE_ENCODINGS];
+
+
+struct tile_opcode
+{
+  /* The opcode mnemonic, e.g. "add" */
+  const char *name;
+
+  /* The enum value for this mnemonic. */
+  tile_mnemonic mnemonic;
+
+  /* A bit mask of which of the five pipes this instruction
+     is compatible with:
+     X0  0x01
+     X1  0x02
+     Y0  0x04
+     Y1  0x08
+     Y2  0x10 */
+  unsigned char pipes;
+
+  /* How many operands are there? */
+  unsigned char num_operands;
+
+  /* Which register does this write implicitly, or TREG_ZERO if none? */
+  unsigned char implicitly_written_register;
+
+  /* Can this be bundled with other instructions (almost always true). */
+  unsigned char can_bundle;
+
+  /* The description of the operands. Each of these is an
+   * index into the tile_operands[] table. */
+  unsigned char operands[TILE_NUM_PIPELINE_ENCODINGS][TILE_MAX_OPERANDS];
+
+  /* A mask of which bits have predefined values for each pipeline.
+   * This is useful for disassembly. */
+  tile_bundle_bits fixed_bit_masks[TILE_NUM_PIPELINE_ENCODINGS];
+
+  /* For each bit set in fixed_bit_masks, what the value is for this
+   * instruction. */
+  tile_bundle_bits fixed_bit_values[TILE_NUM_PIPELINE_ENCODINGS];
+};
+
+extern const struct tile_opcode tile_opcodes[];
+
+struct tile_sn_opcode
+{
+  /* The opcode mnemonic, e.g. "add" */
+  const char *name;
+
+  /* The enum value for this mnemonic. */
+  tile_sn_mnemonic mnemonic;
+
+  /* How many operands are there? */
+  unsigned char num_operands;
+
+  /* The description of the operands. Each of these is an
+   * index into the tile_operands[] table. */
+  unsigned char operands[TILE_SN_MAX_OPERANDS];
+
+  /* A mask of which bits have predefined values.
+   * This is useful for disassembly. */
+  tile_sn_instruction_bits fixed_bit_mask;
+
+  /* For each bit set in fixed_bit_masks, what its value is. */
+  tile_sn_instruction_bits fixed_bit_values;
+};
+
+extern const struct tile_sn_opcode tile_sn_opcodes[];
+
+/* Used for non-textual disassembly into structs. */
+struct tile_decoded_instruction
+{
+  const struct tile_opcode *opcode;
+  const struct tile_operand *operands[TILE_MAX_OPERANDS];
+  int operand_values[TILE_MAX_OPERANDS];
+};
+
+
+/* Disassemble a bundle into a struct for machine processing. */
+extern int parse_insn_tile(tile_bundle_bits bits,
+                           unsigned int pc,
+                           struct tile_decoded_instruction
+                           decoded[TILE_MAX_INSTRUCTIONS_PER_BUNDLE]);
+
+
+/* Canonical names of all the registers. */
+/* ISSUE: This table lives in "tile-dis.c" */
+extern const char * const tile_register_names[];
+
+/* Descriptor for a special-purpose register. */
+struct tile_spr
+{
+  /* The number */
+  int number;
+
+  /* The name */
+  const char *name;
+};
+
+/* List of all the SPRs; ordered by increasing number. */
+extern const struct tile_spr tile_sprs[];
+
+/* Number of special-purpose registers. */
+extern const int tile_num_sprs;
+
+extern const char *
+get_tile_spr_name (int num);
+
+#endif /* opcode_tile_h */
diff --git a/arch/tile/include/asm/opcode_constants.h b/arch/tile/include/asm/opcode_constants.h
new file mode 100644
index 0000000..37a9f29
--- /dev/null
+++ b/arch/tile/include/asm/opcode_constants.h
@@ -0,0 +1,26 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_OPCODE_CONSTANTS_H
+#define _ASM_TILE_OPCODE_CONSTANTS_H
+
+#include <arch/chip.h>
+
+#if CHIP_WORD_SIZE() == 64
+#include <asm/opcode_constants_64.h>
+#else
+#include <asm/opcode_constants_32.h>
+#endif
+
+#endif /* _ASM_TILE_OPCODE_CONSTANTS_H */
diff --git a/arch/tile/include/asm/opcode_constants_32.h b/arch/tile/include/asm/opcode_constants_32.h
new file mode 100644
index 0000000..227d033
--- /dev/null
+++ b/arch/tile/include/asm/opcode_constants_32.h
@@ -0,0 +1,480 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+/* This file is machine-generated; DO NOT EDIT! */
+
+
+#ifndef _TILE_OPCODE_CONSTANTS_H
+#define _TILE_OPCODE_CONSTANTS_H
+enum
+{
+  ADDBS_U_SPECIAL_0_OPCODE_X0 = 98,
+  ADDBS_U_SPECIAL_0_OPCODE_X1 = 68,
+  ADDB_SPECIAL_0_OPCODE_X0 = 1,
+  ADDB_SPECIAL_0_OPCODE_X1 = 1,
+  ADDHS_SPECIAL_0_OPCODE_X0 = 99,
+  ADDHS_SPECIAL_0_OPCODE_X1 = 69,
+  ADDH_SPECIAL_0_OPCODE_X0 = 2,
+  ADDH_SPECIAL_0_OPCODE_X1 = 2,
+  ADDIB_IMM_0_OPCODE_X0 = 1,
+  ADDIB_IMM_0_OPCODE_X1 = 1,
+  ADDIH_IMM_0_OPCODE_X0 = 2,
+  ADDIH_IMM_0_OPCODE_X1 = 2,
+  ADDI_IMM_0_OPCODE_X0 = 3,
+  ADDI_IMM_0_OPCODE_X1 = 3,
+  ADDI_IMM_1_OPCODE_SN = 1,
+  ADDI_OPCODE_Y0 = 9,
+  ADDI_OPCODE_Y1 = 7,
+  ADDLIS_OPCODE_X0 = 1,
+  ADDLIS_OPCODE_X1 = 2,
+  ADDLI_OPCODE_X0 = 2,
+  ADDLI_OPCODE_X1 = 3,
+  ADDS_SPECIAL_0_OPCODE_X0 = 96,
+  ADDS_SPECIAL_0_OPCODE_X1 = 66,
+  ADD_SPECIAL_0_OPCODE_X0 = 3,
+  ADD_SPECIAL_0_OPCODE_X1 = 3,
+  ADD_SPECIAL_0_OPCODE_Y0 = 0,
+  ADD_SPECIAL_0_OPCODE_Y1 = 0,
+  ADIFFB_U_SPECIAL_0_OPCODE_X0 = 4,
+  ADIFFH_SPECIAL_0_OPCODE_X0 = 5,
+  ANDI_IMM_0_OPCODE_X0 = 1,
+  ANDI_IMM_0_OPCODE_X1 = 4,
+  ANDI_OPCODE_Y0 = 10,
+  ANDI_OPCODE_Y1 = 8,
+  AND_SPECIAL_0_OPCODE_X0 = 6,
+  AND_SPECIAL_0_OPCODE_X1 = 4,
+  AND_SPECIAL_2_OPCODE_Y0 = 0,
+  AND_SPECIAL_2_OPCODE_Y1 = 0,
+  AULI_OPCODE_X0 = 3,
+  AULI_OPCODE_X1 = 4,
+  AVGB_U_SPECIAL_0_OPCODE_X0 = 7,
+  AVGH_SPECIAL_0_OPCODE_X0 = 8,
+  BBNST_BRANCH_OPCODE_X1 = 15,
+  BBNS_BRANCH_OPCODE_X1 = 14,
+  BBNS_OPCODE_SN = 63,
+  BBST_BRANCH_OPCODE_X1 = 13,
+  BBS_BRANCH_OPCODE_X1 = 12,
+  BBS_OPCODE_SN = 62,
+  BGEZT_BRANCH_OPCODE_X1 = 7,
+  BGEZ_BRANCH_OPCODE_X1 = 6,
+  BGEZ_OPCODE_SN = 61,
+  BGZT_BRANCH_OPCODE_X1 = 5,
+  BGZ_BRANCH_OPCODE_X1 = 4,
+  BGZ_OPCODE_SN = 58,
+  BITX_UN_0_SHUN_0_OPCODE_X0 = 1,
+  BITX_UN_0_SHUN_0_OPCODE_Y0 = 1,
+  BLEZT_BRANCH_OPCODE_X1 = 11,
+  BLEZ_BRANCH_OPCODE_X1 = 10,
+  BLEZ_OPCODE_SN = 59,
+  BLZT_BRANCH_OPCODE_X1 = 9,
+  BLZ_BRANCH_OPCODE_X1 = 8,
+  BLZ_OPCODE_SN = 60,
+  BNZT_BRANCH_OPCODE_X1 = 3,
+  BNZ_BRANCH_OPCODE_X1 = 2,
+  BNZ_OPCODE_SN = 57,
+  BPT_NOREG_RR_IMM_0_OPCODE_SN = 1,
+  BRANCH_OPCODE_X1 = 5,
+  BYTEX_UN_0_SHUN_0_OPCODE_X0 = 2,
+  BYTEX_UN_0_SHUN_0_OPCODE_Y0 = 2,
+  BZT_BRANCH_OPCODE_X1 = 1,
+  BZ_BRANCH_OPCODE_X1 = 0,
+  BZ_OPCODE_SN = 56,
+  CLZ_UN_0_SHUN_0_OPCODE_X0 = 3,
+  CLZ_UN_0_SHUN_0_OPCODE_Y0 = 3,
+  CRC32_32_SPECIAL_0_OPCODE_X0 = 9,
+  CRC32_8_SPECIAL_0_OPCODE_X0 = 10,
+  CTZ_UN_0_SHUN_0_OPCODE_X0 = 4,
+  CTZ_UN_0_SHUN_0_OPCODE_Y0 = 4,
+  DRAIN_UN_0_SHUN_0_OPCODE_X1 = 1,
+  DTLBPR_UN_0_SHUN_0_OPCODE_X1 = 2,
+  DWORD_ALIGN_SPECIAL_0_OPCODE_X0 = 95,
+  FINV_UN_0_SHUN_0_OPCODE_X1 = 3,
+  FLUSH_UN_0_SHUN_0_OPCODE_X1 = 4,
+  FNOP_NOREG_RR_IMM_0_OPCODE_SN = 3,
+  FNOP_UN_0_SHUN_0_OPCODE_X0 = 5,
+  FNOP_UN_0_SHUN_0_OPCODE_X1 = 5,
+  FNOP_UN_0_SHUN_0_OPCODE_Y0 = 5,
+  FNOP_UN_0_SHUN_0_OPCODE_Y1 = 1,
+  HALT_NOREG_RR_IMM_0_OPCODE_SN = 0,
+  ICOH_UN_0_SHUN_0_OPCODE_X1 = 6,
+  ILL_UN_0_SHUN_0_OPCODE_X1 = 7,
+  ILL_UN_0_SHUN_0_OPCODE_Y1 = 2,
+  IMM_0_OPCODE_SN = 0,
+  IMM_0_OPCODE_X0 = 4,
+  IMM_0_OPCODE_X1 = 6,
+  IMM_1_OPCODE_SN = 1,
+  IMM_OPCODE_0_X0 = 5,
+  INTHB_SPECIAL_0_OPCODE_X0 = 11,
+  INTHB_SPECIAL_0_OPCODE_X1 = 5,
+  INTHH_SPECIAL_0_OPCODE_X0 = 12,
+  INTHH_SPECIAL_0_OPCODE_X1 = 6,
+  INTLB_SPECIAL_0_OPCODE_X0 = 13,
+  INTLB_SPECIAL_0_OPCODE_X1 = 7,
+  INTLH_SPECIAL_0_OPCODE_X0 = 14,
+  INTLH_SPECIAL_0_OPCODE_X1 = 8,
+  INV_UN_0_SHUN_0_OPCODE_X1 = 8,
+  IRET_UN_0_SHUN_0_OPCODE_X1 = 9,
+  JALB_OPCODE_X1 = 13,
+  JALF_OPCODE_X1 = 12,
+  JALRP_SPECIAL_0_OPCODE_X1 = 9,
+  JALRR_IMM_1_OPCODE_SN = 3,
+  JALR_RR_IMM_0_OPCODE_SN = 5,
+  JALR_SPECIAL_0_OPCODE_X1 = 10,
+  JB_OPCODE_X1 = 11,
+  JF_OPCODE_X1 = 10,
+  JRP_SPECIAL_0_OPCODE_X1 = 11,
+  JRR_IMM_1_OPCODE_SN = 2,
+  JR_RR_IMM_0_OPCODE_SN = 4,
+  JR_SPECIAL_0_OPCODE_X1 = 12,
+  LBADD_IMM_0_OPCODE_X1 = 22,
+  LBADD_U_IMM_0_OPCODE_X1 = 23,
+  LB_OPCODE_Y2 = 0,
+  LB_UN_0_SHUN_0_OPCODE_X1 = 10,
+  LB_U_OPCODE_Y2 = 1,
+  LB_U_UN_0_SHUN_0_OPCODE_X1 = 11,
+  LHADD_IMM_0_OPCODE_X1 = 24,
+  LHADD_U_IMM_0_OPCODE_X1 = 25,
+  LH_OPCODE_Y2 = 2,
+  LH_UN_0_SHUN_0_OPCODE_X1 = 12,
+  LH_U_OPCODE_Y2 = 3,
+  LH_U_UN_0_SHUN_0_OPCODE_X1 = 13,
+  LNK_SPECIAL_0_OPCODE_X1 = 13,
+  LWADD_IMM_0_OPCODE_X1 = 26,
+  LWADD_NA_IMM_0_OPCODE_X1 = 27,
+  LW_NA_UN_0_SHUN_0_OPCODE_X1 = 24,
+  LW_OPCODE_Y2 = 4,
+  LW_UN_0_SHUN_0_OPCODE_X1 = 14,
+  MAXB_U_SPECIAL_0_OPCODE_X0 = 15,
+  MAXB_U_SPECIAL_0_OPCODE_X1 = 14,
+  MAXH_SPECIAL_0_OPCODE_X0 = 16,
+  MAXH_SPECIAL_0_OPCODE_X1 = 15,
+  MAXIB_U_IMM_0_OPCODE_X0 = 4,
+  MAXIB_U_IMM_0_OPCODE_X1 = 5,
+  MAXIH_IMM_0_OPCODE_X0 = 5,
+  MAXIH_IMM_0_OPCODE_X1 = 6,
+  MFSPR_IMM_0_OPCODE_X1 = 7,
+  MF_UN_0_SHUN_0_OPCODE_X1 = 15,
+  MINB_U_SPECIAL_0_OPCODE_X0 = 17,
+  MINB_U_SPECIAL_0_OPCODE_X1 = 16,
+  MINH_SPECIAL_0_OPCODE_X0 = 18,
+  MINH_SPECIAL_0_OPCODE_X1 = 17,
+  MINIB_U_IMM_0_OPCODE_X0 = 6,
+  MINIB_U_IMM_0_OPCODE_X1 = 8,
+  MINIH_IMM_0_OPCODE_X0 = 7,
+  MINIH_IMM_0_OPCODE_X1 = 9,
+  MM_OPCODE_X0 = 6,
+  MM_OPCODE_X1 = 7,
+  MNZB_SPECIAL_0_OPCODE_X0 = 19,
+  MNZB_SPECIAL_0_OPCODE_X1 = 18,
+  MNZH_SPECIAL_0_OPCODE_X0 = 20,
+  MNZH_SPECIAL_0_OPCODE_X1 = 19,
+  MNZ_SPECIAL_0_OPCODE_X0 = 21,
+  MNZ_SPECIAL_0_OPCODE_X1 = 20,
+  MNZ_SPECIAL_1_OPCODE_Y0 = 0,
+  MNZ_SPECIAL_1_OPCODE_Y1 = 1,
+  MOVEI_IMM_1_OPCODE_SN = 0,
+  MOVE_RR_IMM_0_OPCODE_SN = 8,
+  MTSPR_IMM_0_OPCODE_X1 = 10,
+  MULHHA_SS_SPECIAL_0_OPCODE_X0 = 22,
+  MULHHA_SS_SPECIAL_7_OPCODE_Y0 = 0,
+  MULHHA_SU_SPECIAL_0_OPCODE_X0 = 23,
+  MULHHA_UU_SPECIAL_0_OPCODE_X0 = 24,
+  MULHHA_UU_SPECIAL_7_OPCODE_Y0 = 1,
+  MULHHSA_UU_SPECIAL_0_OPCODE_X0 = 25,
+  MULHH_SS_SPECIAL_0_OPCODE_X0 = 26,
+  MULHH_SS_SPECIAL_6_OPCODE_Y0 = 0,
+  MULHH_SU_SPECIAL_0_OPCODE_X0 = 27,
+  MULHH_UU_SPECIAL_0_OPCODE_X0 = 28,
+  MULHH_UU_SPECIAL_6_OPCODE_Y0 = 1,
+  MULHLA_SS_SPECIAL_0_OPCODE_X0 = 29,
+  MULHLA_SU_SPECIAL_0_OPCODE_X0 = 30,
+  MULHLA_US_SPECIAL_0_OPCODE_X0 = 31,
+  MULHLA_UU_SPECIAL_0_OPCODE_X0 = 32,
+  MULHLSA_UU_SPECIAL_0_OPCODE_X0 = 33,
+  MULHLSA_UU_SPECIAL_5_OPCODE_Y0 = 0,
+  MULHL_SS_SPECIAL_0_OPCODE_X0 = 34,
+  MULHL_SU_SPECIAL_0_OPCODE_X0 = 35,
+  MULHL_US_SPECIAL_0_OPCODE_X0 = 36,
+  MULHL_UU_SPECIAL_0_OPCODE_X0 = 37,
+  MULLLA_SS_SPECIAL_0_OPCODE_X0 = 38,
+  MULLLA_SS_SPECIAL_7_OPCODE_Y0 = 2,
+  MULLLA_SU_SPECIAL_0_OPCODE_X0 = 39,
+  MULLLA_UU_SPECIAL_0_OPCODE_X0 = 40,
+  MULLLA_UU_SPECIAL_7_OPCODE_Y0 = 3,
+  MULLLSA_UU_SPECIAL_0_OPCODE_X0 = 41,
+  MULLL_SS_SPECIAL_0_OPCODE_X0 = 42,
+  MULLL_SS_SPECIAL_6_OPCODE_Y0 = 2,
+  MULLL_SU_SPECIAL_0_OPCODE_X0 = 43,
+  MULLL_UU_SPECIAL_0_OPCODE_X0 = 44,
+  MULLL_UU_SPECIAL_6_OPCODE_Y0 = 3,
+  MVNZ_SPECIAL_0_OPCODE_X0 = 45,
+  MVNZ_SPECIAL_1_OPCODE_Y0 = 1,
+  MVZ_SPECIAL_0_OPCODE_X0 = 46,
+  MVZ_SPECIAL_1_OPCODE_Y0 = 2,
+  MZB_SPECIAL_0_OPCODE_X0 = 47,
+  MZB_SPECIAL_0_OPCODE_X1 = 21,
+  MZH_SPECIAL_0_OPCODE_X0 = 48,
+  MZH_SPECIAL_0_OPCODE_X1 = 22,
+  MZ_SPECIAL_0_OPCODE_X0 = 49,
+  MZ_SPECIAL_0_OPCODE_X1 = 23,
+  MZ_SPECIAL_1_OPCODE_Y0 = 3,
+  MZ_SPECIAL_1_OPCODE_Y1 = 2,
+  NAP_UN_0_SHUN_0_OPCODE_X1 = 16,
+  NOP_NOREG_RR_IMM_0_OPCODE_SN = 2,
+  NOP_UN_0_SHUN_0_OPCODE_X0 = 6,
+  NOP_UN_0_SHUN_0_OPCODE_X1 = 17,
+  NOP_UN_0_SHUN_0_OPCODE_Y0 = 6,
+  NOP_UN_0_SHUN_0_OPCODE_Y1 = 3,
+  NOREG_RR_IMM_0_OPCODE_SN = 0,
+  NOR_SPECIAL_0_OPCODE_X0 = 50,
+  NOR_SPECIAL_0_OPCODE_X1 = 24,
+  NOR_SPECIAL_2_OPCODE_Y0 = 1,
+  NOR_SPECIAL_2_OPCODE_Y1 = 1,
+  ORI_IMM_0_OPCODE_X0 = 8,
+  ORI_IMM_0_OPCODE_X1 = 11,
+  ORI_OPCODE_Y0 = 11,
+  ORI_OPCODE_Y1 = 9,
+  OR_SPECIAL_0_OPCODE_X0 = 51,
+  OR_SPECIAL_0_OPCODE_X1 = 25,
+  OR_SPECIAL_2_OPCODE_Y0 = 2,
+  OR_SPECIAL_2_OPCODE_Y1 = 2,
+  PACKBS_U_SPECIAL_0_OPCODE_X0 = 103,
+  PACKBS_U_SPECIAL_0_OPCODE_X1 = 73,
+  PACKHB_SPECIAL_0_OPCODE_X0 = 52,
+  PACKHB_SPECIAL_0_OPCODE_X1 = 26,
+  PACKHS_SPECIAL_0_OPCODE_X0 = 102,
+  PACKHS_SPECIAL_0_OPCODE_X1 = 72,
+  PACKLB_SPECIAL_0_OPCODE_X0 = 53,
+  PACKLB_SPECIAL_0_OPCODE_X1 = 27,
+  PCNT_UN_0_SHUN_0_OPCODE_X0 = 7,
+  PCNT_UN_0_SHUN_0_OPCODE_Y0 = 7,
+  RLI_SHUN_0_OPCODE_X0 = 1,
+  RLI_SHUN_0_OPCODE_X1 = 1,
+  RLI_SHUN_0_OPCODE_Y0 = 1,
+  RLI_SHUN_0_OPCODE_Y1 = 1,
+  RL_SPECIAL_0_OPCODE_X0 = 54,
+  RL_SPECIAL_0_OPCODE_X1 = 28,
+  RL_SPECIAL_3_OPCODE_Y0 = 0,
+  RL_SPECIAL_3_OPCODE_Y1 = 0,
+  RR_IMM_0_OPCODE_SN = 0,
+  S1A_SPECIAL_0_OPCODE_X0 = 55,
+  S1A_SPECIAL_0_OPCODE_X1 = 29,
+  S1A_SPECIAL_0_OPCODE_Y0 = 1,
+  S1A_SPECIAL_0_OPCODE_Y1 = 1,
+  S2A_SPECIAL_0_OPCODE_X0 = 56,
+  S2A_SPECIAL_0_OPCODE_X1 = 30,
+  S2A_SPECIAL_0_OPCODE_Y0 = 2,
+  S2A_SPECIAL_0_OPCODE_Y1 = 2,
+  S3A_SPECIAL_0_OPCODE_X0 = 57,
+  S3A_SPECIAL_0_OPCODE_X1 = 31,
+  S3A_SPECIAL_5_OPCODE_Y0 = 1,
+  S3A_SPECIAL_5_OPCODE_Y1 = 1,
+  SADAB_U_SPECIAL_0_OPCODE_X0 = 58,
+  SADAH_SPECIAL_0_OPCODE_X0 = 59,
+  SADAH_U_SPECIAL_0_OPCODE_X0 = 60,
+  SADB_U_SPECIAL_0_OPCODE_X0 = 61,
+  SADH_SPECIAL_0_OPCODE_X0 = 62,
+  SADH_U_SPECIAL_0_OPCODE_X0 = 63,
+  SBADD_IMM_0_OPCODE_X1 = 28,
+  SB_OPCODE_Y2 = 5,
+  SB_SPECIAL_0_OPCODE_X1 = 32,
+  SEQB_SPECIAL_0_OPCODE_X0 = 64,
+  SEQB_SPECIAL_0_OPCODE_X1 = 33,
+  SEQH_SPECIAL_0_OPCODE_X0 = 65,
+  SEQH_SPECIAL_0_OPCODE_X1 = 34,
+  SEQIB_IMM_0_OPCODE_X0 = 9,
+  SEQIB_IMM_0_OPCODE_X1 = 12,
+  SEQIH_IMM_0_OPCODE_X0 = 10,
+  SEQIH_IMM_0_OPCODE_X1 = 13,
+  SEQI_IMM_0_OPCODE_X0 = 11,
+  SEQI_IMM_0_OPCODE_X1 = 14,
+  SEQI_OPCODE_Y0 = 12,
+  SEQI_OPCODE_Y1 = 10,
+  SEQ_SPECIAL_0_OPCODE_X0 = 66,
+  SEQ_SPECIAL_0_OPCODE_X1 = 35,
+  SEQ_SPECIAL_5_OPCODE_Y0 = 2,
+  SEQ_SPECIAL_5_OPCODE_Y1 = 2,
+  SHADD_IMM_0_OPCODE_X1 = 29,
+  SHL8II_IMM_0_OPCODE_SN = 3,
+  SHLB_SPECIAL_0_OPCODE_X0 = 67,
+  SHLB_SPECIAL_0_OPCODE_X1 = 36,
+  SHLH_SPECIAL_0_OPCODE_X0 = 68,
+  SHLH_SPECIAL_0_OPCODE_X1 = 37,
+  SHLIB_SHUN_0_OPCODE_X0 = 2,
+  SHLIB_SHUN_0_OPCODE_X1 = 2,
+  SHLIH_SHUN_0_OPCODE_X0 = 3,
+  SHLIH_SHUN_0_OPCODE_X1 = 3,
+  SHLI_SHUN_0_OPCODE_X0 = 4,
+  SHLI_SHUN_0_OPCODE_X1 = 4,
+  SHLI_SHUN_0_OPCODE_Y0 = 2,
+  SHLI_SHUN_0_OPCODE_Y1 = 2,
+  SHL_SPECIAL_0_OPCODE_X0 = 69,
+  SHL_SPECIAL_0_OPCODE_X1 = 38,
+  SHL_SPECIAL_3_OPCODE_Y0 = 1,
+  SHL_SPECIAL_3_OPCODE_Y1 = 1,
+  SHR1_RR_IMM_0_OPCODE_SN = 9,
+  SHRB_SPECIAL_0_OPCODE_X0 = 70,
+  SHRB_SPECIAL_0_OPCODE_X1 = 39,
+  SHRH_SPECIAL_0_OPCODE_X0 = 71,
+  SHRH_SPECIAL_0_OPCODE_X1 = 40,
+  SHRIB_SHUN_0_OPCODE_X0 = 5,
+  SHRIB_SHUN_0_OPCODE_X1 = 5,
+  SHRIH_SHUN_0_OPCODE_X0 = 6,
+  SHRIH_SHUN_0_OPCODE_X1 = 6,
+  SHRI_SHUN_0_OPCODE_X0 = 7,
+  SHRI_SHUN_0_OPCODE_X1 = 7,
+  SHRI_SHUN_0_OPCODE_Y0 = 3,
+  SHRI_SHUN_0_OPCODE_Y1 = 3,
+  SHR_SPECIAL_0_OPCODE_X0 = 72,
+  SHR_SPECIAL_0_OPCODE_X1 = 41,
+  SHR_SPECIAL_3_OPCODE_Y0 = 2,
+  SHR_SPECIAL_3_OPCODE_Y1 = 2,
+  SHUN_0_OPCODE_X0 = 7,
+  SHUN_0_OPCODE_X1 = 8,
+  SHUN_0_OPCODE_Y0 = 13,
+  SHUN_0_OPCODE_Y1 = 11,
+  SH_OPCODE_Y2 = 6,
+  SH_SPECIAL_0_OPCODE_X1 = 42,
+  SLTB_SPECIAL_0_OPCODE_X0 = 73,
+  SLTB_SPECIAL_0_OPCODE_X1 = 43,
+  SLTB_U_SPECIAL_0_OPCODE_X0 = 74,
+  SLTB_U_SPECIAL_0_OPCODE_X1 = 44,
+  SLTEB_SPECIAL_0_OPCODE_X0 = 75,
+  SLTEB_SPECIAL_0_OPCODE_X1 = 45,
+  SLTEB_U_SPECIAL_0_OPCODE_X0 = 76,
+  SLTEB_U_SPECIAL_0_OPCODE_X1 = 46,
+  SLTEH_SPECIAL_0_OPCODE_X0 = 77,
+  SLTEH_SPECIAL_0_OPCODE_X1 = 47,
+  SLTEH_U_SPECIAL_0_OPCODE_X0 = 78,
+  SLTEH_U_SPECIAL_0_OPCODE_X1 = 48,
+  SLTE_SPECIAL_0_OPCODE_X0 = 79,
+  SLTE_SPECIAL_0_OPCODE_X1 = 49,
+  SLTE_SPECIAL_4_OPCODE_Y0 = 0,
+  SLTE_SPECIAL_4_OPCODE_Y1 = 0,
+  SLTE_U_SPECIAL_0_OPCODE_X0 = 80,
+  SLTE_U_SPECIAL_0_OPCODE_X1 = 50,
+  SLTE_U_SPECIAL_4_OPCODE_Y0 = 1,
+  SLTE_U_SPECIAL_4_OPCODE_Y1 = 1,
+  SLTH_SPECIAL_0_OPCODE_X0 = 81,
+  SLTH_SPECIAL_0_OPCODE_X1 = 51,
+  SLTH_U_SPECIAL_0_OPCODE_X0 = 82,
+  SLTH_U_SPECIAL_0_OPCODE_X1 = 52,
+  SLTIB_IMM_0_OPCODE_X0 = 12,
+  SLTIB_IMM_0_OPCODE_X1 = 15,
+  SLTIB_U_IMM_0_OPCODE_X0 = 13,
+  SLTIB_U_IMM_0_OPCODE_X1 = 16,
+  SLTIH_IMM_0_OPCODE_X0 = 14,
+  SLTIH_IMM_0_OPCODE_X1 = 17,
+  SLTIH_U_IMM_0_OPCODE_X0 = 15,
+  SLTIH_U_IMM_0_OPCODE_X1 = 18,
+  SLTI_IMM_0_OPCODE_X0 = 16,
+  SLTI_IMM_0_OPCODE_X1 = 19,
+  SLTI_OPCODE_Y0 = 14,
+  SLTI_OPCODE_Y1 = 12,
+  SLTI_U_IMM_0_OPCODE_X0 = 17,
+  SLTI_U_IMM_0_OPCODE_X1 = 20,
+  SLTI_U_OPCODE_Y0 = 15,
+  SLTI_U_OPCODE_Y1 = 13,
+  SLT_SPECIAL_0_OPCODE_X0 = 83,
+  SLT_SPECIAL_0_OPCODE_X1 = 53,
+  SLT_SPECIAL_4_OPCODE_Y0 = 2,
+  SLT_SPECIAL_4_OPCODE_Y1 = 2,
+  SLT_U_SPECIAL_0_OPCODE_X0 = 84,
+  SLT_U_SPECIAL_0_OPCODE_X1 = 54,
+  SLT_U_SPECIAL_4_OPCODE_Y0 = 3,
+  SLT_U_SPECIAL_4_OPCODE_Y1 = 3,
+  SNEB_SPECIAL_0_OPCODE_X0 = 85,
+  SNEB_SPECIAL_0_OPCODE_X1 = 55,
+  SNEH_SPECIAL_0_OPCODE_X0 = 86,
+  SNEH_SPECIAL_0_OPCODE_X1 = 56,
+  SNE_SPECIAL_0_OPCODE_X0 = 87,
+  SNE_SPECIAL_0_OPCODE_X1 = 57,
+  SNE_SPECIAL_5_OPCODE_Y0 = 3,
+  SNE_SPECIAL_5_OPCODE_Y1 = 3,
+  SPECIAL_0_OPCODE_X0 = 0,
+  SPECIAL_0_OPCODE_X1 = 1,
+  SPECIAL_0_OPCODE_Y0 = 1,
+  SPECIAL_0_OPCODE_Y1 = 1,
+  SPECIAL_1_OPCODE_Y0 = 2,
+  SPECIAL_1_OPCODE_Y1 = 2,
+  SPECIAL_2_OPCODE_Y0 = 3,
+  SPECIAL_2_OPCODE_Y1 = 3,
+  SPECIAL_3_OPCODE_Y0 = 4,
+  SPECIAL_3_OPCODE_Y1 = 4,
+  SPECIAL_4_OPCODE_Y0 = 5,
+  SPECIAL_4_OPCODE_Y1 = 5,
+  SPECIAL_5_OPCODE_Y0 = 6,
+  SPECIAL_5_OPCODE_Y1 = 6,
+  SPECIAL_6_OPCODE_Y0 = 7,
+  SPECIAL_7_OPCODE_Y0 = 8,
+  SRAB_SPECIAL_0_OPCODE_X0 = 88,
+  SRAB_SPECIAL_0_OPCODE_X1 = 58,
+  SRAH_SPECIAL_0_OPCODE_X0 = 89,
+  SRAH_SPECIAL_0_OPCODE_X1 = 59,
+  SRAIB_SHUN_0_OPCODE_X0 = 8,
+  SRAIB_SHUN_0_OPCODE_X1 = 8,
+  SRAIH_SHUN_0_OPCODE_X0 = 9,
+  SRAIH_SHUN_0_OPCODE_X1 = 9,
+  SRAI_SHUN_0_OPCODE_X0 = 10,
+  SRAI_SHUN_0_OPCODE_X1 = 10,
+  SRAI_SHUN_0_OPCODE_Y0 = 4,
+  SRAI_SHUN_0_OPCODE_Y1 = 4,
+  SRA_SPECIAL_0_OPCODE_X0 = 90,
+  SRA_SPECIAL_0_OPCODE_X1 = 60,
+  SRA_SPECIAL_3_OPCODE_Y0 = 3,
+  SRA_SPECIAL_3_OPCODE_Y1 = 3,
+  SUBBS_U_SPECIAL_0_OPCODE_X0 = 100,
+  SUBBS_U_SPECIAL_0_OPCODE_X1 = 70,
+  SUBB_SPECIAL_0_OPCODE_X0 = 91,
+  SUBB_SPECIAL_0_OPCODE_X1 = 61,
+  SUBHS_SPECIAL_0_OPCODE_X0 = 101,
+  SUBHS_SPECIAL_0_OPCODE_X1 = 71,
+  SUBH_SPECIAL_0_OPCODE_X0 = 92,
+  SUBH_SPECIAL_0_OPCODE_X1 = 62,
+  SUBS_SPECIAL_0_OPCODE_X0 = 97,
+  SUBS_SPECIAL_0_OPCODE_X1 = 67,
+  SUB_SPECIAL_0_OPCODE_X0 = 93,
+  SUB_SPECIAL_0_OPCODE_X1 = 63,
+  SUB_SPECIAL_0_OPCODE_Y0 = 3,
+  SUB_SPECIAL_0_OPCODE_Y1 = 3,
+  SWADD_IMM_0_OPCODE_X1 = 30,
+  SWINT0_UN_0_SHUN_0_OPCODE_X1 = 18,
+  SWINT1_UN_0_SHUN_0_OPCODE_X1 = 19,
+  SWINT2_UN_0_SHUN_0_OPCODE_X1 = 20,
+  SWINT3_UN_0_SHUN_0_OPCODE_X1 = 21,
+  SW_OPCODE_Y2 = 7,
+  SW_SPECIAL_0_OPCODE_X1 = 64,
+  TBLIDXB0_UN_0_SHUN_0_OPCODE_X0 = 8,
+  TBLIDXB0_UN_0_SHUN_0_OPCODE_Y0 = 8,
+  TBLIDXB1_UN_0_SHUN_0_OPCODE_X0 = 9,
+  TBLIDXB1_UN_0_SHUN_0_OPCODE_Y0 = 9,
+  TBLIDXB2_UN_0_SHUN_0_OPCODE_X0 = 10,
+  TBLIDXB2_UN_0_SHUN_0_OPCODE_Y0 = 10,
+  TBLIDXB3_UN_0_SHUN_0_OPCODE_X0 = 11,
+  TBLIDXB3_UN_0_SHUN_0_OPCODE_Y0 = 11,
+  TNS_UN_0_SHUN_0_OPCODE_X1 = 22,
+  UN_0_SHUN_0_OPCODE_X0 = 11,
+  UN_0_SHUN_0_OPCODE_X1 = 11,
+  UN_0_SHUN_0_OPCODE_Y0 = 5,
+  UN_0_SHUN_0_OPCODE_Y1 = 5,
+  WH64_UN_0_SHUN_0_OPCODE_X1 = 23,
+  XORI_IMM_0_OPCODE_X0 = 2,
+  XORI_IMM_0_OPCODE_X1 = 21,
+  XOR_SPECIAL_0_OPCODE_X0 = 94,
+  XOR_SPECIAL_0_OPCODE_X1 = 65,
+  XOR_SPECIAL_2_OPCODE_Y0 = 3,
+  XOR_SPECIAL_2_OPCODE_Y1 = 3
+};
+
+#endif /* !_TILE_OPCODE_CONSTANTS_H */
diff --git a/arch/tile/include/asm/opcode_constants_64.h b/arch/tile/include/asm/opcode_constants_64.h
new file mode 100644
index 0000000..227d033
--- /dev/null
+++ b/arch/tile/include/asm/opcode_constants_64.h
@@ -0,0 +1,480 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+/* This file is machine-generated; DO NOT EDIT! */
+
+
+#ifndef _TILE_OPCODE_CONSTANTS_H
+#define _TILE_OPCODE_CONSTANTS_H
+enum
+{
+  ADDBS_U_SPECIAL_0_OPCODE_X0 = 98,
+  ADDBS_U_SPECIAL_0_OPCODE_X1 = 68,
+  ADDB_SPECIAL_0_OPCODE_X0 = 1,
+  ADDB_SPECIAL_0_OPCODE_X1 = 1,
+  ADDHS_SPECIAL_0_OPCODE_X0 = 99,
+  ADDHS_SPECIAL_0_OPCODE_X1 = 69,
+  ADDH_SPECIAL_0_OPCODE_X0 = 2,
+  ADDH_SPECIAL_0_OPCODE_X1 = 2,
+  ADDIB_IMM_0_OPCODE_X0 = 1,
+  ADDIB_IMM_0_OPCODE_X1 = 1,
+  ADDIH_IMM_0_OPCODE_X0 = 2,
+  ADDIH_IMM_0_OPCODE_X1 = 2,
+  ADDI_IMM_0_OPCODE_X0 = 3,
+  ADDI_IMM_0_OPCODE_X1 = 3,
+  ADDI_IMM_1_OPCODE_SN = 1,
+  ADDI_OPCODE_Y0 = 9,
+  ADDI_OPCODE_Y1 = 7,
+  ADDLIS_OPCODE_X0 = 1,
+  ADDLIS_OPCODE_X1 = 2,
+  ADDLI_OPCODE_X0 = 2,
+  ADDLI_OPCODE_X1 = 3,
+  ADDS_SPECIAL_0_OPCODE_X0 = 96,
+  ADDS_SPECIAL_0_OPCODE_X1 = 66,
+  ADD_SPECIAL_0_OPCODE_X0 = 3,
+  ADD_SPECIAL_0_OPCODE_X1 = 3,
+  ADD_SPECIAL_0_OPCODE_Y0 = 0,
+  ADD_SPECIAL_0_OPCODE_Y1 = 0,
+  ADIFFB_U_SPECIAL_0_OPCODE_X0 = 4,
+  ADIFFH_SPECIAL_0_OPCODE_X0 = 5,
+  ANDI_IMM_0_OPCODE_X0 = 1,
+  ANDI_IMM_0_OPCODE_X1 = 4,
+  ANDI_OPCODE_Y0 = 10,
+  ANDI_OPCODE_Y1 = 8,
+  AND_SPECIAL_0_OPCODE_X0 = 6,
+  AND_SPECIAL_0_OPCODE_X1 = 4,
+  AND_SPECIAL_2_OPCODE_Y0 = 0,
+  AND_SPECIAL_2_OPCODE_Y1 = 0,
+  AULI_OPCODE_X0 = 3,
+  AULI_OPCODE_X1 = 4,
+  AVGB_U_SPECIAL_0_OPCODE_X0 = 7,
+  AVGH_SPECIAL_0_OPCODE_X0 = 8,
+  BBNST_BRANCH_OPCODE_X1 = 15,
+  BBNS_BRANCH_OPCODE_X1 = 14,
+  BBNS_OPCODE_SN = 63,
+  BBST_BRANCH_OPCODE_X1 = 13,
+  BBS_BRANCH_OPCODE_X1 = 12,
+  BBS_OPCODE_SN = 62,
+  BGEZT_BRANCH_OPCODE_X1 = 7,
+  BGEZ_BRANCH_OPCODE_X1 = 6,
+  BGEZ_OPCODE_SN = 61,
+  BGZT_BRANCH_OPCODE_X1 = 5,
+  BGZ_BRANCH_OPCODE_X1 = 4,
+  BGZ_OPCODE_SN = 58,
+  BITX_UN_0_SHUN_0_OPCODE_X0 = 1,
+  BITX_UN_0_SHUN_0_OPCODE_Y0 = 1,
+  BLEZT_BRANCH_OPCODE_X1 = 11,
+  BLEZ_BRANCH_OPCODE_X1 = 10,
+  BLEZ_OPCODE_SN = 59,
+  BLZT_BRANCH_OPCODE_X1 = 9,
+  BLZ_BRANCH_OPCODE_X1 = 8,
+  BLZ_OPCODE_SN = 60,
+  BNZT_BRANCH_OPCODE_X1 = 3,
+  BNZ_BRANCH_OPCODE_X1 = 2,
+  BNZ_OPCODE_SN = 57,
+  BPT_NOREG_RR_IMM_0_OPCODE_SN = 1,
+  BRANCH_OPCODE_X1 = 5,
+  BYTEX_UN_0_SHUN_0_OPCODE_X0 = 2,
+  BYTEX_UN_0_SHUN_0_OPCODE_Y0 = 2,
+  BZT_BRANCH_OPCODE_X1 = 1,
+  BZ_BRANCH_OPCODE_X1 = 0,
+  BZ_OPCODE_SN = 56,
+  CLZ_UN_0_SHUN_0_OPCODE_X0 = 3,
+  CLZ_UN_0_SHUN_0_OPCODE_Y0 = 3,
+  CRC32_32_SPECIAL_0_OPCODE_X0 = 9,
+  CRC32_8_SPECIAL_0_OPCODE_X0 = 10,
+  CTZ_UN_0_SHUN_0_OPCODE_X0 = 4,
+  CTZ_UN_0_SHUN_0_OPCODE_Y0 = 4,
+  DRAIN_UN_0_SHUN_0_OPCODE_X1 = 1,
+  DTLBPR_UN_0_SHUN_0_OPCODE_X1 = 2,
+  DWORD_ALIGN_SPECIAL_0_OPCODE_X0 = 95,
+  FINV_UN_0_SHUN_0_OPCODE_X1 = 3,
+  FLUSH_UN_0_SHUN_0_OPCODE_X1 = 4,
+  FNOP_NOREG_RR_IMM_0_OPCODE_SN = 3,
+  FNOP_UN_0_SHUN_0_OPCODE_X0 = 5,
+  FNOP_UN_0_SHUN_0_OPCODE_X1 = 5,
+  FNOP_UN_0_SHUN_0_OPCODE_Y0 = 5,
+  FNOP_UN_0_SHUN_0_OPCODE_Y1 = 1,
+  HALT_NOREG_RR_IMM_0_OPCODE_SN = 0,
+  ICOH_UN_0_SHUN_0_OPCODE_X1 = 6,
+  ILL_UN_0_SHUN_0_OPCODE_X1 = 7,
+  ILL_UN_0_SHUN_0_OPCODE_Y1 = 2,
+  IMM_0_OPCODE_SN = 0,
+  IMM_0_OPCODE_X0 = 4,
+  IMM_0_OPCODE_X1 = 6,
+  IMM_1_OPCODE_SN = 1,
+  IMM_OPCODE_0_X0 = 5,
+  INTHB_SPECIAL_0_OPCODE_X0 = 11,
+  INTHB_SPECIAL_0_OPCODE_X1 = 5,
+  INTHH_SPECIAL_0_OPCODE_X0 = 12,
+  INTHH_SPECIAL_0_OPCODE_X1 = 6,
+  INTLB_SPECIAL_0_OPCODE_X0 = 13,
+  INTLB_SPECIAL_0_OPCODE_X1 = 7,
+  INTLH_SPECIAL_0_OPCODE_X0 = 14,
+  INTLH_SPECIAL_0_OPCODE_X1 = 8,
+  INV_UN_0_SHUN_0_OPCODE_X1 = 8,
+  IRET_UN_0_SHUN_0_OPCODE_X1 = 9,
+  JALB_OPCODE_X1 = 13,
+  JALF_OPCODE_X1 = 12,
+  JALRP_SPECIAL_0_OPCODE_X1 = 9,
+  JALRR_IMM_1_OPCODE_SN = 3,
+  JALR_RR_IMM_0_OPCODE_SN = 5,
+  JALR_SPECIAL_0_OPCODE_X1 = 10,
+  JB_OPCODE_X1 = 11,
+  JF_OPCODE_X1 = 10,
+  JRP_SPECIAL_0_OPCODE_X1 = 11,
+  JRR_IMM_1_OPCODE_SN = 2,
+  JR_RR_IMM_0_OPCODE_SN = 4,
+  JR_SPECIAL_0_OPCODE_X1 = 12,
+  LBADD_IMM_0_OPCODE_X1 = 22,
+  LBADD_U_IMM_0_OPCODE_X1 = 23,
+  LB_OPCODE_Y2 = 0,
+  LB_UN_0_SHUN_0_OPCODE_X1 = 10,
+  LB_U_OPCODE_Y2 = 1,
+  LB_U_UN_0_SHUN_0_OPCODE_X1 = 11,
+  LHADD_IMM_0_OPCODE_X1 = 24,
+  LHADD_U_IMM_0_OPCODE_X1 = 25,
+  LH_OPCODE_Y2 = 2,
+  LH_UN_0_SHUN_0_OPCODE_X1 = 12,
+  LH_U_OPCODE_Y2 = 3,
+  LH_U_UN_0_SHUN_0_OPCODE_X1 = 13,
+  LNK_SPECIAL_0_OPCODE_X1 = 13,
+  LWADD_IMM_0_OPCODE_X1 = 26,
+  LWADD_NA_IMM_0_OPCODE_X1 = 27,
+  LW_NA_UN_0_SHUN_0_OPCODE_X1 = 24,
+  LW_OPCODE_Y2 = 4,
+  LW_UN_0_SHUN_0_OPCODE_X1 = 14,
+  MAXB_U_SPECIAL_0_OPCODE_X0 = 15,
+  MAXB_U_SPECIAL_0_OPCODE_X1 = 14,
+  MAXH_SPECIAL_0_OPCODE_X0 = 16,
+  MAXH_SPECIAL_0_OPCODE_X1 = 15,
+  MAXIB_U_IMM_0_OPCODE_X0 = 4,
+  MAXIB_U_IMM_0_OPCODE_X1 = 5,
+  MAXIH_IMM_0_OPCODE_X0 = 5,
+  MAXIH_IMM_0_OPCODE_X1 = 6,
+  MFSPR_IMM_0_OPCODE_X1 = 7,
+  MF_UN_0_SHUN_0_OPCODE_X1 = 15,
+  MINB_U_SPECIAL_0_OPCODE_X0 = 17,
+  MINB_U_SPECIAL_0_OPCODE_X1 = 16,
+  MINH_SPECIAL_0_OPCODE_X0 = 18,
+  MINH_SPECIAL_0_OPCODE_X1 = 17,
+  MINIB_U_IMM_0_OPCODE_X0 = 6,
+  MINIB_U_IMM_0_OPCODE_X1 = 8,
+  MINIH_IMM_0_OPCODE_X0 = 7,
+  MINIH_IMM_0_OPCODE_X1 = 9,
+  MM_OPCODE_X0 = 6,
+  MM_OPCODE_X1 = 7,
+  MNZB_SPECIAL_0_OPCODE_X0 = 19,
+  MNZB_SPECIAL_0_OPCODE_X1 = 18,
+  MNZH_SPECIAL_0_OPCODE_X0 = 20,
+  MNZH_SPECIAL_0_OPCODE_X1 = 19,
+  MNZ_SPECIAL_0_OPCODE_X0 = 21,
+  MNZ_SPECIAL_0_OPCODE_X1 = 20,
+  MNZ_SPECIAL_1_OPCODE_Y0 = 0,
+  MNZ_SPECIAL_1_OPCODE_Y1 = 1,
+  MOVEI_IMM_1_OPCODE_SN = 0,
+  MOVE_RR_IMM_0_OPCODE_SN = 8,
+  MTSPR_IMM_0_OPCODE_X1 = 10,
+  MULHHA_SS_SPECIAL_0_OPCODE_X0 = 22,
+  MULHHA_SS_SPECIAL_7_OPCODE_Y0 = 0,
+  MULHHA_SU_SPECIAL_0_OPCODE_X0 = 23,
+  MULHHA_UU_SPECIAL_0_OPCODE_X0 = 24,
+  MULHHA_UU_SPECIAL_7_OPCODE_Y0 = 1,
+  MULHHSA_UU_SPECIAL_0_OPCODE_X0 = 25,
+  MULHH_SS_SPECIAL_0_OPCODE_X0 = 26,
+  MULHH_SS_SPECIAL_6_OPCODE_Y0 = 0,
+  MULHH_SU_SPECIAL_0_OPCODE_X0 = 27,
+  MULHH_UU_SPECIAL_0_OPCODE_X0 = 28,
+  MULHH_UU_SPECIAL_6_OPCODE_Y0 = 1,
+  MULHLA_SS_SPECIAL_0_OPCODE_X0 = 29,
+  MULHLA_SU_SPECIAL_0_OPCODE_X0 = 30,
+  MULHLA_US_SPECIAL_0_OPCODE_X0 = 31,
+  MULHLA_UU_SPECIAL_0_OPCODE_X0 = 32,
+  MULHLSA_UU_SPECIAL_0_OPCODE_X0 = 33,
+  MULHLSA_UU_SPECIAL_5_OPCODE_Y0 = 0,
+  MULHL_SS_SPECIAL_0_OPCODE_X0 = 34,
+  MULHL_SU_SPECIAL_0_OPCODE_X0 = 35,
+  MULHL_US_SPECIAL_0_OPCODE_X0 = 36,
+  MULHL_UU_SPECIAL_0_OPCODE_X0 = 37,
+  MULLLA_SS_SPECIAL_0_OPCODE_X0 = 38,
+  MULLLA_SS_SPECIAL_7_OPCODE_Y0 = 2,
+  MULLLA_SU_SPECIAL_0_OPCODE_X0 = 39,
+  MULLLA_UU_SPECIAL_0_OPCODE_X0 = 40,
+  MULLLA_UU_SPECIAL_7_OPCODE_Y0 = 3,
+  MULLLSA_UU_SPECIAL_0_OPCODE_X0 = 41,
+  MULLL_SS_SPECIAL_0_OPCODE_X0 = 42,
+  MULLL_SS_SPECIAL_6_OPCODE_Y0 = 2,
+  MULLL_SU_SPECIAL_0_OPCODE_X0 = 43,
+  MULLL_UU_SPECIAL_0_OPCODE_X0 = 44,
+  MULLL_UU_SPECIAL_6_OPCODE_Y0 = 3,
+  MVNZ_SPECIAL_0_OPCODE_X0 = 45,
+  MVNZ_SPECIAL_1_OPCODE_Y0 = 1,
+  MVZ_SPECIAL_0_OPCODE_X0 = 46,
+  MVZ_SPECIAL_1_OPCODE_Y0 = 2,
+  MZB_SPECIAL_0_OPCODE_X0 = 47,
+  MZB_SPECIAL_0_OPCODE_X1 = 21,
+  MZH_SPECIAL_0_OPCODE_X0 = 48,
+  MZH_SPECIAL_0_OPCODE_X1 = 22,
+  MZ_SPECIAL_0_OPCODE_X0 = 49,
+  MZ_SPECIAL_0_OPCODE_X1 = 23,
+  MZ_SPECIAL_1_OPCODE_Y0 = 3,
+  MZ_SPECIAL_1_OPCODE_Y1 = 2,
+  NAP_UN_0_SHUN_0_OPCODE_X1 = 16,
+  NOP_NOREG_RR_IMM_0_OPCODE_SN = 2,
+  NOP_UN_0_SHUN_0_OPCODE_X0 = 6,
+  NOP_UN_0_SHUN_0_OPCODE_X1 = 17,
+  NOP_UN_0_SHUN_0_OPCODE_Y0 = 6,
+  NOP_UN_0_SHUN_0_OPCODE_Y1 = 3,
+  NOREG_RR_IMM_0_OPCODE_SN = 0,
+  NOR_SPECIAL_0_OPCODE_X0 = 50,
+  NOR_SPECIAL_0_OPCODE_X1 = 24,
+  NOR_SPECIAL_2_OPCODE_Y0 = 1,
+  NOR_SPECIAL_2_OPCODE_Y1 = 1,
+  ORI_IMM_0_OPCODE_X0 = 8,
+  ORI_IMM_0_OPCODE_X1 = 11,
+  ORI_OPCODE_Y0 = 11,
+  ORI_OPCODE_Y1 = 9,
+  OR_SPECIAL_0_OPCODE_X0 = 51,
+  OR_SPECIAL_0_OPCODE_X1 = 25,
+  OR_SPECIAL_2_OPCODE_Y0 = 2,
+  OR_SPECIAL_2_OPCODE_Y1 = 2,
+  PACKBS_U_SPECIAL_0_OPCODE_X0 = 103,
+  PACKBS_U_SPECIAL_0_OPCODE_X1 = 73,
+  PACKHB_SPECIAL_0_OPCODE_X0 = 52,
+  PACKHB_SPECIAL_0_OPCODE_X1 = 26,
+  PACKHS_SPECIAL_0_OPCODE_X0 = 102,
+  PACKHS_SPECIAL_0_OPCODE_X1 = 72,
+  PACKLB_SPECIAL_0_OPCODE_X0 = 53,
+  PACKLB_SPECIAL_0_OPCODE_X1 = 27,
+  PCNT_UN_0_SHUN_0_OPCODE_X0 = 7,
+  PCNT_UN_0_SHUN_0_OPCODE_Y0 = 7,
+  RLI_SHUN_0_OPCODE_X0 = 1,
+  RLI_SHUN_0_OPCODE_X1 = 1,
+  RLI_SHUN_0_OPCODE_Y0 = 1,
+  RLI_SHUN_0_OPCODE_Y1 = 1,
+  RL_SPECIAL_0_OPCODE_X0 = 54,
+  RL_SPECIAL_0_OPCODE_X1 = 28,
+  RL_SPECIAL_3_OPCODE_Y0 = 0,
+  RL_SPECIAL_3_OPCODE_Y1 = 0,
+  RR_IMM_0_OPCODE_SN = 0,
+  S1A_SPECIAL_0_OPCODE_X0 = 55,
+  S1A_SPECIAL_0_OPCODE_X1 = 29,
+  S1A_SPECIAL_0_OPCODE_Y0 = 1,
+  S1A_SPECIAL_0_OPCODE_Y1 = 1,
+  S2A_SPECIAL_0_OPCODE_X0 = 56,
+  S2A_SPECIAL_0_OPCODE_X1 = 30,
+  S2A_SPECIAL_0_OPCODE_Y0 = 2,
+  S2A_SPECIAL_0_OPCODE_Y1 = 2,
+  S3A_SPECIAL_0_OPCODE_X0 = 57,
+  S3A_SPECIAL_0_OPCODE_X1 = 31,
+  S3A_SPECIAL_5_OPCODE_Y0 = 1,
+  S3A_SPECIAL_5_OPCODE_Y1 = 1,
+  SADAB_U_SPECIAL_0_OPCODE_X0 = 58,
+  SADAH_SPECIAL_0_OPCODE_X0 = 59,
+  SADAH_U_SPECIAL_0_OPCODE_X0 = 60,
+  SADB_U_SPECIAL_0_OPCODE_X0 = 61,
+  SADH_SPECIAL_0_OPCODE_X0 = 62,
+  SADH_U_SPECIAL_0_OPCODE_X0 = 63,
+  SBADD_IMM_0_OPCODE_X1 = 28,
+  SB_OPCODE_Y2 = 5,
+  SB_SPECIAL_0_OPCODE_X1 = 32,
+  SEQB_SPECIAL_0_OPCODE_X0 = 64,
+  SEQB_SPECIAL_0_OPCODE_X1 = 33,
+  SEQH_SPECIAL_0_OPCODE_X0 = 65,
+  SEQH_SPECIAL_0_OPCODE_X1 = 34,
+  SEQIB_IMM_0_OPCODE_X0 = 9,
+  SEQIB_IMM_0_OPCODE_X1 = 12,
+  SEQIH_IMM_0_OPCODE_X0 = 10,
+  SEQIH_IMM_0_OPCODE_X1 = 13,
+  SEQI_IMM_0_OPCODE_X0 = 11,
+  SEQI_IMM_0_OPCODE_X1 = 14,
+  SEQI_OPCODE_Y0 = 12,
+  SEQI_OPCODE_Y1 = 10,
+  SEQ_SPECIAL_0_OPCODE_X0 = 66,
+  SEQ_SPECIAL_0_OPCODE_X1 = 35,
+  SEQ_SPECIAL_5_OPCODE_Y0 = 2,
+  SEQ_SPECIAL_5_OPCODE_Y1 = 2,
+  SHADD_IMM_0_OPCODE_X1 = 29,
+  SHL8II_IMM_0_OPCODE_SN = 3,
+  SHLB_SPECIAL_0_OPCODE_X0 = 67,
+  SHLB_SPECIAL_0_OPCODE_X1 = 36,
+  SHLH_SPECIAL_0_OPCODE_X0 = 68,
+  SHLH_SPECIAL_0_OPCODE_X1 = 37,
+  SHLIB_SHUN_0_OPCODE_X0 = 2,
+  SHLIB_SHUN_0_OPCODE_X1 = 2,
+  SHLIH_SHUN_0_OPCODE_X0 = 3,
+  SHLIH_SHUN_0_OPCODE_X1 = 3,
+  SHLI_SHUN_0_OPCODE_X0 = 4,
+  SHLI_SHUN_0_OPCODE_X1 = 4,
+  SHLI_SHUN_0_OPCODE_Y0 = 2,
+  SHLI_SHUN_0_OPCODE_Y1 = 2,
+  SHL_SPECIAL_0_OPCODE_X0 = 69,
+  SHL_SPECIAL_0_OPCODE_X1 = 38,
+  SHL_SPECIAL_3_OPCODE_Y0 = 1,
+  SHL_SPECIAL_3_OPCODE_Y1 = 1,
+  SHR1_RR_IMM_0_OPCODE_SN = 9,
+  SHRB_SPECIAL_0_OPCODE_X0 = 70,
+  SHRB_SPECIAL_0_OPCODE_X1 = 39,
+  SHRH_SPECIAL_0_OPCODE_X0 = 71,
+  SHRH_SPECIAL_0_OPCODE_X1 = 40,
+  SHRIB_SHUN_0_OPCODE_X0 = 5,
+  SHRIB_SHUN_0_OPCODE_X1 = 5,
+  SHRIH_SHUN_0_OPCODE_X0 = 6,
+  SHRIH_SHUN_0_OPCODE_X1 = 6,
+  SHRI_SHUN_0_OPCODE_X0 = 7,
+  SHRI_SHUN_0_OPCODE_X1 = 7,
+  SHRI_SHUN_0_OPCODE_Y0 = 3,
+  SHRI_SHUN_0_OPCODE_Y1 = 3,
+  SHR_SPECIAL_0_OPCODE_X0 = 72,
+  SHR_SPECIAL_0_OPCODE_X1 = 41,
+  SHR_SPECIAL_3_OPCODE_Y0 = 2,
+  SHR_SPECIAL_3_OPCODE_Y1 = 2,
+  SHUN_0_OPCODE_X0 = 7,
+  SHUN_0_OPCODE_X1 = 8,
+  SHUN_0_OPCODE_Y0 = 13,
+  SHUN_0_OPCODE_Y1 = 11,
+  SH_OPCODE_Y2 = 6,
+  SH_SPECIAL_0_OPCODE_X1 = 42,
+  SLTB_SPECIAL_0_OPCODE_X0 = 73,
+  SLTB_SPECIAL_0_OPCODE_X1 = 43,
+  SLTB_U_SPECIAL_0_OPCODE_X0 = 74,
+  SLTB_U_SPECIAL_0_OPCODE_X1 = 44,
+  SLTEB_SPECIAL_0_OPCODE_X0 = 75,
+  SLTEB_SPECIAL_0_OPCODE_X1 = 45,
+  SLTEB_U_SPECIAL_0_OPCODE_X0 = 76,
+  SLTEB_U_SPECIAL_0_OPCODE_X1 = 46,
+  SLTEH_SPECIAL_0_OPCODE_X0 = 77,
+  SLTEH_SPECIAL_0_OPCODE_X1 = 47,
+  SLTEH_U_SPECIAL_0_OPCODE_X0 = 78,
+  SLTEH_U_SPECIAL_0_OPCODE_X1 = 48,
+  SLTE_SPECIAL_0_OPCODE_X0 = 79,
+  SLTE_SPECIAL_0_OPCODE_X1 = 49,
+  SLTE_SPECIAL_4_OPCODE_Y0 = 0,
+  SLTE_SPECIAL_4_OPCODE_Y1 = 0,
+  SLTE_U_SPECIAL_0_OPCODE_X0 = 80,
+  SLTE_U_SPECIAL_0_OPCODE_X1 = 50,
+  SLTE_U_SPECIAL_4_OPCODE_Y0 = 1,
+  SLTE_U_SPECIAL_4_OPCODE_Y1 = 1,
+  SLTH_SPECIAL_0_OPCODE_X0 = 81,
+  SLTH_SPECIAL_0_OPCODE_X1 = 51,
+  SLTH_U_SPECIAL_0_OPCODE_X0 = 82,
+  SLTH_U_SPECIAL_0_OPCODE_X1 = 52,
+  SLTIB_IMM_0_OPCODE_X0 = 12,
+  SLTIB_IMM_0_OPCODE_X1 = 15,
+  SLTIB_U_IMM_0_OPCODE_X0 = 13,
+  SLTIB_U_IMM_0_OPCODE_X1 = 16,
+  SLTIH_IMM_0_OPCODE_X0 = 14,
+  SLTIH_IMM_0_OPCODE_X1 = 17,
+  SLTIH_U_IMM_0_OPCODE_X0 = 15,
+  SLTIH_U_IMM_0_OPCODE_X1 = 18,
+  SLTI_IMM_0_OPCODE_X0 = 16,
+  SLTI_IMM_0_OPCODE_X1 = 19,
+  SLTI_OPCODE_Y0 = 14,
+  SLTI_OPCODE_Y1 = 12,
+  SLTI_U_IMM_0_OPCODE_X0 = 17,
+  SLTI_U_IMM_0_OPCODE_X1 = 20,
+  SLTI_U_OPCODE_Y0 = 15,
+  SLTI_U_OPCODE_Y1 = 13,
+  SLT_SPECIAL_0_OPCODE_X0 = 83,
+  SLT_SPECIAL_0_OPCODE_X1 = 53,
+  SLT_SPECIAL_4_OPCODE_Y0 = 2,
+  SLT_SPECIAL_4_OPCODE_Y1 = 2,
+  SLT_U_SPECIAL_0_OPCODE_X0 = 84,
+  SLT_U_SPECIAL_0_OPCODE_X1 = 54,
+  SLT_U_SPECIAL_4_OPCODE_Y0 = 3,
+  SLT_U_SPECIAL_4_OPCODE_Y1 = 3,
+  SNEB_SPECIAL_0_OPCODE_X0 = 85,
+  SNEB_SPECIAL_0_OPCODE_X1 = 55,
+  SNEH_SPECIAL_0_OPCODE_X0 = 86,
+  SNEH_SPECIAL_0_OPCODE_X1 = 56,
+  SNE_SPECIAL_0_OPCODE_X0 = 87,
+  SNE_SPECIAL_0_OPCODE_X1 = 57,
+  SNE_SPECIAL_5_OPCODE_Y0 = 3,
+  SNE_SPECIAL_5_OPCODE_Y1 = 3,
+  SPECIAL_0_OPCODE_X0 = 0,
+  SPECIAL_0_OPCODE_X1 = 1,
+  SPECIAL_0_OPCODE_Y0 = 1,
+  SPECIAL_0_OPCODE_Y1 = 1,
+  SPECIAL_1_OPCODE_Y0 = 2,
+  SPECIAL_1_OPCODE_Y1 = 2,
+  SPECIAL_2_OPCODE_Y0 = 3,
+  SPECIAL_2_OPCODE_Y1 = 3,
+  SPECIAL_3_OPCODE_Y0 = 4,
+  SPECIAL_3_OPCODE_Y1 = 4,
+  SPECIAL_4_OPCODE_Y0 = 5,
+  SPECIAL_4_OPCODE_Y1 = 5,
+  SPECIAL_5_OPCODE_Y0 = 6,
+  SPECIAL_5_OPCODE_Y1 = 6,
+  SPECIAL_6_OPCODE_Y0 = 7,
+  SPECIAL_7_OPCODE_Y0 = 8,
+  SRAB_SPECIAL_0_OPCODE_X0 = 88,
+  SRAB_SPECIAL_0_OPCODE_X1 = 58,
+  SRAH_SPECIAL_0_OPCODE_X0 = 89,
+  SRAH_SPECIAL_0_OPCODE_X1 = 59,
+  SRAIB_SHUN_0_OPCODE_X0 = 8,
+  SRAIB_SHUN_0_OPCODE_X1 = 8,
+  SRAIH_SHUN_0_OPCODE_X0 = 9,
+  SRAIH_SHUN_0_OPCODE_X1 = 9,
+  SRAI_SHUN_0_OPCODE_X0 = 10,
+  SRAI_SHUN_0_OPCODE_X1 = 10,
+  SRAI_SHUN_0_OPCODE_Y0 = 4,
+  SRAI_SHUN_0_OPCODE_Y1 = 4,
+  SRA_SPECIAL_0_OPCODE_X0 = 90,
+  SRA_SPECIAL_0_OPCODE_X1 = 60,
+  SRA_SPECIAL_3_OPCODE_Y0 = 3,
+  SRA_SPECIAL_3_OPCODE_Y1 = 3,
+  SUBBS_U_SPECIAL_0_OPCODE_X0 = 100,
+  SUBBS_U_SPECIAL_0_OPCODE_X1 = 70,
+  SUBB_SPECIAL_0_OPCODE_X0 = 91,
+  SUBB_SPECIAL_0_OPCODE_X1 = 61,
+  SUBHS_SPECIAL_0_OPCODE_X0 = 101,
+  SUBHS_SPECIAL_0_OPCODE_X1 = 71,
+  SUBH_SPECIAL_0_OPCODE_X0 = 92,
+  SUBH_SPECIAL_0_OPCODE_X1 = 62,
+  SUBS_SPECIAL_0_OPCODE_X0 = 97,
+  SUBS_SPECIAL_0_OPCODE_X1 = 67,
+  SUB_SPECIAL_0_OPCODE_X0 = 93,
+  SUB_SPECIAL_0_OPCODE_X1 = 63,
+  SUB_SPECIAL_0_OPCODE_Y0 = 3,
+  SUB_SPECIAL_0_OPCODE_Y1 = 3,
+  SWADD_IMM_0_OPCODE_X1 = 30,
+  SWINT0_UN_0_SHUN_0_OPCODE_X1 = 18,
+  SWINT1_UN_0_SHUN_0_OPCODE_X1 = 19,
+  SWINT2_UN_0_SHUN_0_OPCODE_X1 = 20,
+  SWINT3_UN_0_SHUN_0_OPCODE_X1 = 21,
+  SW_OPCODE_Y2 = 7,
+  SW_SPECIAL_0_OPCODE_X1 = 64,
+  TBLIDXB0_UN_0_SHUN_0_OPCODE_X0 = 8,
+  TBLIDXB0_UN_0_SHUN_0_OPCODE_Y0 = 8,
+  TBLIDXB1_UN_0_SHUN_0_OPCODE_X0 = 9,
+  TBLIDXB1_UN_0_SHUN_0_OPCODE_Y0 = 9,
+  TBLIDXB2_UN_0_SHUN_0_OPCODE_X0 = 10,
+  TBLIDXB2_UN_0_SHUN_0_OPCODE_Y0 = 10,
+  TBLIDXB3_UN_0_SHUN_0_OPCODE_X0 = 11,
+  TBLIDXB3_UN_0_SHUN_0_OPCODE_Y0 = 11,
+  TNS_UN_0_SHUN_0_OPCODE_X1 = 22,
+  UN_0_SHUN_0_OPCODE_X0 = 11,
+  UN_0_SHUN_0_OPCODE_X1 = 11,
+  UN_0_SHUN_0_OPCODE_Y0 = 5,
+  UN_0_SHUN_0_OPCODE_Y1 = 5,
+  WH64_UN_0_SHUN_0_OPCODE_X1 = 23,
+  XORI_IMM_0_OPCODE_X0 = 2,
+  XORI_IMM_0_OPCODE_X1 = 21,
+  XOR_SPECIAL_0_OPCODE_X0 = 94,
+  XOR_SPECIAL_0_OPCODE_X1 = 65,
+  XOR_SPECIAL_2_OPCODE_Y0 = 3,
+  XOR_SPECIAL_2_OPCODE_Y1 = 3
+};
+
+#endif /* !_TILE_OPCODE_CONSTANTS_H */
diff --git a/arch/tile/include/asm/page.h b/arch/tile/include/asm/page.h
new file mode 100644
index 0000000..c8301c4
--- /dev/null
+++ b/arch/tile/include/asm/page.h
@@ -0,0 +1,334 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_PAGE_H
+#define _ASM_TILE_PAGE_H
+
+#include <linux/const.h>
+#include <hv/hypervisor.h>
+#include <arch/chip.h>
+
+/* PAGE_SHIFT and HPAGE_SHIFT determine the page sizes. */
+#define PAGE_SHIFT	16
+#define HPAGE_SHIFT	24
+
+#define PAGE_SIZE	(_AC(1, UL) << PAGE_SHIFT)
+#define HPAGE_SIZE	(_AC(1, UL) << HPAGE_SHIFT)
+
+#define PAGE_MASK	(~(PAGE_SIZE - 1))
+#define HPAGE_MASK	(~(HPAGE_SIZE - 1))
+
+/*
+ * The {,H}PAGE_SHIFT values must match the HV_LOG2_PAGE_SIZE_xxx
+ * definitions in <hv/hypervisor.h>.  We validate this at build time
+ * here, and again at runtime during early boot.  We provide a
+ * separate definition since userspace doesn't have <hv/hypervisor.h>.
+ *
+ * Be careful to distinguish PAGE_SHIFT from HV_PTE_INDEX_PFN, since
+ * they are the same on i386 but not TILE.
+ */
+#if HV_LOG2_PAGE_SIZE_SMALL != PAGE_SHIFT
+# error Small page size mismatch in Linux
+#endif
+#if HV_LOG2_PAGE_SIZE_LARGE != HPAGE_SHIFT
+# error Huge page size mismatch in Linux
+#endif
+
+#ifndef __ASSEMBLY__
+
+#include <linux/types.h>
+#include <linux/string.h>
+
+struct page;
+
+static inline void clear_page(void *page)
+{
+	memset(page, 0, PAGE_SIZE);
+}
+
+static inline void copy_page(void *to, void *from)
+{
+	memcpy(to, from, PAGE_SIZE);
+}
+
+static inline void clear_user_page(void *page, unsigned long vaddr,
+				struct page *pg)
+{
+	clear_page(page);
+}
+
+static inline void copy_user_page(void *to, void *from, unsigned long vaddr,
+				struct page *topage)
+{
+	copy_page(to, from);
+}
+
+/*
+ * Hypervisor page tables are made of the same basic structure.
+ */
+
+typedef __u64 pteval_t;
+typedef __u64 pmdval_t;
+typedef __u64 pudval_t;
+typedef __u64 pgdval_t;
+typedef __u64 pgprotval_t;
+
+typedef HV_PTE pte_t;
+typedef HV_PTE pgd_t;
+typedef HV_PTE pgprot_t;
+
+/*
+ * User L2 page tables are managed as one L2 page table per page,
+ * because we use the page allocator for them.  This keeps the allocation
+ * simple and makes it potentially useful to implement HIGHPTE at some point.
+ * However, it's also inefficient, since L2 page tables are much smaller
+ * than pages (currently 2KB vs 64KB).  So we should revisit this.
+ */
+typedef struct page *pgtable_t;
+
+/* Must be a macro since it is used to create constants. */
+#define __pgprot(val) hv_pte(val)
+
+static inline u64 pgprot_val(pgprot_t pgprot)
+{
+	return hv_pte_val(pgprot);
+}
+
+static inline u64 pte_val(pte_t pte)
+{
+	return hv_pte_val(pte);
+}
+
+static inline u64 pgd_val(pgd_t pgd)
+{
+	return hv_pte_val(pgd);
+}
+
+#ifdef __tilegx__
+
+typedef HV_PTE pmd_t;
+
+static inline u64 pmd_val(pmd_t pmd)
+{
+	return hv_pte_val(pmd);
+}
+
+#endif
+
+#endif /* !__ASSEMBLY__ */
+
+#define HUGETLB_PAGE_ORDER	(HPAGE_SHIFT - PAGE_SHIFT)
+
+#define HUGE_MAX_HSTATE		2
+
+#ifdef CONFIG_HUGETLB_PAGE
+#define HAVE_ARCH_HUGETLB_UNMAPPED_AREA
+#endif
+
+/* Each memory controller has PAs distinct in their high bits. */
+#define NR_PA_HIGHBIT_SHIFT (CHIP_PA_WIDTH() - CHIP_LOG_NUM_MSHIMS())
+#define NR_PA_HIGHBIT_VALUES (1 << CHIP_LOG_NUM_MSHIMS())
+#define __pa_to_highbits(pa) ((phys_addr_t)(pa) >> NR_PA_HIGHBIT_SHIFT)
+#define __pfn_to_highbits(pfn) ((pfn) >> (NR_PA_HIGHBIT_SHIFT - PAGE_SHIFT))
+
+#ifdef __tilegx__
+
+/*
+ * We reserve the lower half of memory for user-space programs, and the
+ * upper half for system code.  We re-map all of physical memory in the
+ * upper half, which takes a quarter of our VA space.  Then we have
+ * the vmalloc regions.  The supervisor code lives at 0xfffffff700000000,
+ * with the hypervisor above that.
+ *
+ * Loadable kernel modules are placed immediately after the static
+ * supervisor code, with each being allocated a 256MB region of
+ * address space, so we don't have to worry about the range of "jal"
+ * and other branch instructions.
+ *
+ * For now we keep life simple and just allocate one pmd (4GB) for vmalloc.
+ * Similarly, for now we don't play any struct page mapping games.
+ */
+
+#if CHIP_PA_WIDTH() + 2 > CHIP_VA_WIDTH()
+# error Too much PA to map with the VA available!
+#endif
+#define HALF_VA_SPACE           (_AC(1, UL) << (CHIP_VA_WIDTH() - 1))
+
+#define MEM_LOW_END		(HALF_VA_SPACE - 1)         /* low half */
+#define MEM_HIGH_START		(-HALF_VA_SPACE)            /* high half */
+#define PAGE_OFFSET		MEM_HIGH_START
+#define _VMALLOC_START		_AC(0xfffffff500000000, UL) /* 4 GB */
+#define HUGE_VMAP_BASE		_AC(0xfffffff600000000, UL) /* 4 GB */
+#define MEM_SV_START		_AC(0xfffffff700000000, UL) /* 256 MB */
+#define MEM_SV_INTRPT		MEM_SV_START
+#define MEM_MODULE_START	_AC(0xfffffff710000000, UL) /* 256 MB */
+#define MEM_MODULE_END		(MEM_MODULE_START + (256*1024*1024))
+#define MEM_HV_START		_AC(0xfffffff800000000, UL) /* 32 GB */
+
+/* Highest DTLB address we will use */
+#define KERNEL_HIGH_VADDR	MEM_SV_START
+
+/* Since we don't currently provide any fixmaps, we use an impossible VA. */
+#define FIXADDR_TOP             MEM_HV_START
+
+#else /* !__tilegx__ */
+
+/*
+ * A PAGE_OFFSET of 0xC0000000 means that the kernel has
+ * a virtual address space of one gigabyte, which limits the
+ * amount of physical memory you can use to about 768MB.
+ * If you want more physical memory than this then see the CONFIG_HIGHMEM
+ * option in the kernel configuration.
+ *
+ * The top two 16MB chunks in the table below (VIRT and HV) are
+ * unavailable to Linux.  Since the kernel interrupt vectors must live
+ * at 0xfd000000, we map all of the bottom of RAM at this address with
+ * a huge page table entry to minimize its ITLB footprint (as well as
+ * at PAGE_OFFSET).  The last architected requirement is that user
+ * interrupt vectors live at 0xfc000000, so we make that range of
+ * memory available to user processes.  The remaining regions are sized
+ * as shown; after the first four addresses, we show "typical" values,
+ * since the actual addresses depend on kernel #defines.
+ *
+ * MEM_VIRT_INTRPT                 0xff000000
+ * MEM_HV_INTRPT                   0xfe000000
+ * MEM_SV_INTRPT (kernel code)     0xfd000000
+ * MEM_USER_INTRPT (user vector)   0xfc000000
+ * FIX_KMAP_xxx                    0xf8000000 (via NR_CPUS * KM_TYPE_NR)
+ * PKMAP_BASE                      0xf7000000 (via LAST_PKMAP)
+ * HUGE_VMAP                       0xf3000000 (via CONFIG_NR_HUGE_VMAPS)
+ * VMALLOC_START                   0xf0000000 (via __VMALLOC_RESERVE)
+ * mapped LOWMEM                   0xc0000000
+ */
+
+#define MEM_USER_INTRPT		_AC(0xfc000000, UL)
+#define MEM_SV_INTRPT		_AC(0xfd000000, UL)
+#define MEM_HV_INTRPT		_AC(0xfe000000, UL)
+#define MEM_VIRT_INTRPT		_AC(0xff000000, UL)
+
+#define INTRPT_SIZE		0x4000
+
+/* Tolerate page size larger than the architecture interrupt region size. */
+#if PAGE_SIZE > INTRPT_SIZE
+#undef INTRPT_SIZE
+#define INTRPT_SIZE PAGE_SIZE
+#endif
+
+#define KERNEL_HIGH_VADDR	MEM_USER_INTRPT
+#define FIXADDR_TOP		(KERNEL_HIGH_VADDR - PAGE_SIZE)
+
+#define PAGE_OFFSET		_AC(CONFIG_PAGE_OFFSET, UL)
+
+/* On 32-bit architectures we mix kernel modules in with other vmaps. */
+#define MEM_MODULE_START	VMALLOC_START
+#define MEM_MODULE_END		VMALLOC_END
+
+#endif /* __tilegx__ */
+
+#ifndef __ASSEMBLY__
+
+#ifdef CONFIG_HIGHMEM
+
+/* Map kernel virtual addresses to page frames, in HPAGE_SIZE chunks. */
+extern unsigned long pbase_map[];
+extern void *vbase_map[];
+
+static inline unsigned long kaddr_to_pfn(const volatile void *_kaddr)
+{
+	unsigned long kaddr = (unsigned long)_kaddr;
+	return pbase_map[kaddr >> HPAGE_SHIFT] +
+		((kaddr & (HPAGE_SIZE - 1)) >> PAGE_SHIFT);
+}
+
+static inline void *pfn_to_kaddr(unsigned long pfn)
+{
+	return vbase_map[__pfn_to_highbits(pfn)] + (pfn << PAGE_SHIFT);
+}
+
+static inline phys_addr_t virt_to_phys(const volatile void *kaddr)
+{
+	unsigned long pfn = kaddr_to_pfn(kaddr);
+	return ((phys_addr_t)pfn << PAGE_SHIFT) +
+		((unsigned long)kaddr & (PAGE_SIZE-1));
+}
+
+static inline void *phys_to_virt(phys_addr_t paddr)
+{
+	return pfn_to_kaddr(paddr >> PAGE_SHIFT) + (paddr & (PAGE_SIZE-1));
+}
+
+/* With HIGHMEM, we pack PAGE_OFFSET through high_memory with all valid VAs. */
+static inline int virt_addr_valid(const volatile void *kaddr)
+{
+	extern void *high_memory;  /* copied from <linux/mm.h> */
+	return ((unsigned long)kaddr >= PAGE_OFFSET && kaddr < high_memory);
+}
+
+#else /* !CONFIG_HIGHMEM */
+
+static inline unsigned long kaddr_to_pfn(const volatile void *kaddr)
+{
+	return ((unsigned long)kaddr - PAGE_OFFSET) >> PAGE_SHIFT;
+}
+
+static inline void *pfn_to_kaddr(unsigned long pfn)
+{
+	return (void *)((pfn << PAGE_SHIFT) + PAGE_OFFSET);
+}
+
+static inline phys_addr_t virt_to_phys(const volatile void *kaddr)
+{
+	return (phys_addr_t)((unsigned long)kaddr - PAGE_OFFSET);
+}
+
+static inline void *phys_to_virt(phys_addr_t paddr)
+{
+	return (void *)((unsigned long)paddr + PAGE_OFFSET);
+}
+
+/* Check that the given address is within some mapped range of PAs. */
+#define virt_addr_valid(kaddr) pfn_valid(kaddr_to_pfn(kaddr))
+
+#endif /* !CONFIG_HIGHMEM */
+
+/* All callers are not consistent in how they call these functions. */
+#define __pa(kaddr) virt_to_phys((void *)(unsigned long)(kaddr))
+#define __va(paddr) phys_to_virt((phys_addr_t)(paddr))
+
+extern int devmem_is_allowed(unsigned long pagenr);
+
+#ifdef CONFIG_FLATMEM
+static inline int pfn_valid(unsigned long pfn)
+{
+	return pfn < max_mapnr;
+}
+#endif
+
+/* Provide as macros since these require some other headers included. */
+#define page_to_pa(page) ((phys_addr_t)(page_to_pfn(page)) << PAGE_SHIFT)
+#define virt_to_page(kaddr) pfn_to_page(kaddr_to_pfn(kaddr))
+#define page_to_virt(page) pfn_to_kaddr(page_to_pfn(page))
+
+struct mm_struct;
+extern pte_t *virt_to_pte(struct mm_struct *mm, unsigned long addr);
+
+#endif /* !__ASSEMBLY__ */
+
+#define VM_DATA_DEFAULT_FLAGS \
+	(VM_READ | VM_WRITE | VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
+
+#include <asm-generic/memory_model.h>
+#include <asm-generic/getorder.h>
+
+#endif /* _ASM_TILE_PAGE_H */
diff --git a/arch/tile/include/asm/param.h b/arch/tile/include/asm/param.h
new file mode 100644
index 0000000..965d454
--- /dev/null
+++ b/arch/tile/include/asm/param.h
@@ -0,0 +1 @@
+#include <asm-generic/param.h>
diff --git a/arch/tile/include/asm/pci-bridge.h b/arch/tile/include/asm/pci-bridge.h
new file mode 100644
index 0000000..e853b0e
--- /dev/null
+++ b/arch/tile/include/asm/pci-bridge.h
@@ -0,0 +1,117 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_PCI_BRIDGE_H
+#define _ASM_TILE_PCI_BRIDGE_H
+
+#include <linux/ioport.h>
+#include <linux/pci.h>
+
+struct device_node;
+struct pci_controller;
+
+/*
+ * pci_io_base returns the memory address at which you can access
+ * the I/O space for PCI bus number `bus' (or NULL on error).
+ */
+extern void __iomem *pci_bus_io_base(unsigned int bus);
+extern unsigned long pci_bus_io_base_phys(unsigned int bus);
+extern unsigned long pci_bus_mem_base_phys(unsigned int bus);
+
+/* Allocate a new PCI host bridge structure */
+extern struct pci_controller *pcibios_alloc_controller(void);
+
+/* Helper function for setting up resources */
+extern void pci_init_resource(struct resource *res, unsigned long start,
+			      unsigned long end, int flags, char *name);
+
+/* Get the PCI host controller for a bus */
+extern struct pci_controller *pci_bus_to_hose(int bus);
+
+/*
+ * Structure of a PCI controller (host bridge)
+ */
+struct pci_controller {
+	int index;		/* PCI domain number */
+	struct pci_bus *root_bus;
+
+	int first_busno;
+	int last_busno;
+
+	int hv_cfg_fd[2];	/* config{0,1} fds for this PCIe controller */
+	int hv_mem_fd;		/* fd to Hypervisor for MMIO operations */
+
+	struct pci_ops *ops;
+
+	int irq_base;		/* Base IRQ from the Hypervisor	*/
+	int plx_gen1;		/* flag for PLX Gen 1 configuration */
+
+	/* Address ranges that are routed to this controller/bridge. */
+	struct resource mem_resources[3];
+};
+
+static inline struct pci_controller *pci_bus_to_host(struct pci_bus *bus)
+{
+	return bus->sysdata;
+}
+
+extern void setup_indirect_pci_nomap(struct pci_controller *hose,
+			       void __iomem *cfg_addr, void __iomem *cfg_data);
+extern void setup_indirect_pci(struct pci_controller *hose,
+			       u32 cfg_addr, u32 cfg_data);
+extern void setup_grackle(struct pci_controller *hose);
+
+extern unsigned char common_swizzle(struct pci_dev *, unsigned char *);
+
+/*
+ *   The following code swizzles for exactly one bridge.  The routine
+ *   common_swizzle below handles multiple bridges.  But there are a
+ *   some boards that don't follow the PCI spec's suggestion so we
+ *   break this piece out separately.
+ */
+static inline unsigned char bridge_swizzle(unsigned char pin,
+		unsigned char idsel)
+{
+	return (((pin-1) + idsel) % 4) + 1;
+}
+
+/*
+ * The following macro is used to lookup irqs in a standard table
+ * format for those PPC systems that do not already have PCI
+ * interrupts properly routed.
+ */
+/* FIXME - double check this */
+#define PCI_IRQ_TABLE_LOOKUP ({ \
+	long _ctl_ = -1; \
+	if (idsel >= min_idsel && idsel <= max_idsel && pin <= irqs_per_slot) \
+		_ctl_ = pci_irq_table[idsel - min_idsel][pin-1]; \
+	_ctl_; \
+})
+
+/*
+ * Scan the buses below a given PCI host bridge and assign suitable
+ * resources to all devices found.
+ */
+extern int pciauto_bus_scan(struct pci_controller *, int);
+
+#ifdef CONFIG_PCI
+extern unsigned long pci_address_to_pio(phys_addr_t address);
+#else
+static inline unsigned long pci_address_to_pio(phys_addr_t address)
+{
+	return (unsigned long)-1;
+}
+#endif
+
+#endif /* _ASM_TILE_PCI_BRIDGE_H */
diff --git a/arch/tile/include/asm/pci.h b/arch/tile/include/asm/pci.h
new file mode 100644
index 0000000..b0c15da
--- /dev/null
+++ b/arch/tile/include/asm/pci.h
@@ -0,0 +1,128 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_PCI_H
+#define _ASM_TILE_PCI_H
+
+#include <asm/pci-bridge.h>
+
+/*
+ * The hypervisor maps the entirety of CPA-space as bus addresses, so
+ * bus addresses are physical addresses.  The networking and block
+ * device layers use this boolean for bounce buffer decisions.
+ */
+#define PCI_DMA_BUS_IS_PHYS     1
+
+struct pci_controller *pci_bus_to_hose(int bus);
+unsigned char __init common_swizzle(struct pci_dev *dev, unsigned char *pinp);
+int __init tile_pci_init(void);
+void pci_iounmap(struct pci_dev *dev, void __iomem *addr);
+void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
+void __devinit pcibios_fixup_bus(struct pci_bus *bus);
+
+int __devinit _tile_cfg_read(struct pci_controller *hose,
+				    int bus,
+				    int slot,
+				    int function,
+				    int offset,
+				    int size,
+				    u32 *val);
+int __devinit _tile_cfg_write(struct pci_controller *hose,
+				     int bus,
+				     int slot,
+				     int function,
+				     int offset,
+				     int size,
+				     u32 val);
+
+/*
+ * These are used to to config reads and writes in the early stages of
+ * setup before the driver infrastructure has been set up enough to be
+ * able to do config reads and writes.
+ */
+#define early_cfg_read(where, size, value) \
+	_tile_cfg_read(controller, \
+		       current_bus, \
+		       pci_slot, \
+		       pci_fn, \
+		       where, \
+		       size, \
+		       value)
+
+#define early_cfg_write(where, size, value) \
+	_tile_cfg_write(controller, \
+		       current_bus, \
+		       pci_slot, \
+		       pci_fn, \
+		       where, \
+		       size, \
+		       value)
+
+
+
+#define PCICFG_BYTE	1
+#define PCICFG_WORD	2
+#define PCICFG_DWORD	4
+
+#define	TILE_NUM_PCIE	2
+
+#define pci_domain_nr(bus) (((struct pci_controller *)(bus)->sysdata)->index)
+
+/*
+ * This decides whether to display the domain number in /proc.
+ */
+static inline int pci_proc_domain(struct pci_bus *bus)
+{
+	return 1;
+}
+
+/*
+ * I/O space is currently not supported.
+ */
+
+#define TILE_PCIE_LOWER_IO		0x0
+#define TILE_PCIE_UPPER_IO		0x10000
+#define TILE_PCIE_PCIE_IO_SIZE		0x0000FFFF
+
+#define _PAGE_NO_CACHE		0
+#define _PAGE_GUARDED		0
+
+
+#define pcibios_assign_all_busses()    pci_assign_all_buses
+extern int pci_assign_all_buses;
+
+static inline void pcibios_set_master(struct pci_dev *dev)
+{
+	/* No special bus mastering setup handling */
+}
+
+#define PCIBIOS_MIN_MEM		0
+#define PCIBIOS_MIN_IO		TILE_PCIE_LOWER_IO
+
+/*
+ * This flag tells if the platform is TILEmpower that needs
+ * special configuration for the PLX switch chip.
+ */
+extern int blade_pci;
+
+/* implement the pci_ DMA API in terms of the generic device dma_ one */
+#include <asm-generic/pci-dma-compat.h>
+
+/* generic pci stuff */
+#include <asm-generic/pci.h>
+
+/* Use any cpu for PCI. */
+#define cpumask_of_pcibus(bus) cpu_online_mask
+
+#endif /* _ASM_TILE_PCI_H */
diff --git a/arch/tile/include/asm/percpu.h b/arch/tile/include/asm/percpu.h
new file mode 100644
index 0000000..63294f5
--- /dev/null
+++ b/arch/tile/include/asm/percpu.h
@@ -0,0 +1,24 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_PERCPU_H
+#define _ASM_TILE_PERCPU_H
+
+register unsigned long __my_cpu_offset __asm__("tp");
+#define __my_cpu_offset __my_cpu_offset
+#define set_my_cpu_offset(tp) (__my_cpu_offset = (tp))
+
+#include <asm-generic/percpu.h>
+
+#endif /* _ASM_TILE_PERCPU_H */
diff --git a/arch/tile/include/asm/pgalloc.h b/arch/tile/include/asm/pgalloc.h
new file mode 100644
index 0000000..cf52791
--- /dev/null
+++ b/arch/tile/include/asm/pgalloc.h
@@ -0,0 +1,119 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_PGALLOC_H
+#define _ASM_TILE_PGALLOC_H
+
+#include <linux/threads.h>
+#include <linux/mm.h>
+#include <linux/mmzone.h>
+#include <asm/fixmap.h>
+#include <hv/hypervisor.h>
+
+/* Bits for the size of the second-level page table. */
+#define L2_KERNEL_PGTABLE_SHIFT \
+  (HV_LOG2_PAGE_SIZE_LARGE - HV_LOG2_PAGE_SIZE_SMALL + HV_LOG2_PTE_SIZE)
+
+/* We currently allocate user L2 page tables by page (unlike kernel L2s). */
+#if L2_KERNEL_PGTABLE_SHIFT < HV_LOG2_PAGE_SIZE_SMALL
+#define L2_USER_PGTABLE_SHIFT HV_LOG2_PAGE_SIZE_SMALL
+#else
+#define L2_USER_PGTABLE_SHIFT L2_KERNEL_PGTABLE_SHIFT
+#endif
+
+/* How many pages do we need, as an "order", for a user L2 page table? */
+#define L2_USER_PGTABLE_ORDER (L2_USER_PGTABLE_SHIFT - HV_LOG2_PAGE_SIZE_SMALL)
+
+/* How big is a kernel L2 page table? */
+#define L2_KERNEL_PGTABLE_SIZE (1 << L2_KERNEL_PGTABLE_SHIFT)
+
+static inline void set_pmd(pmd_t *pmdp, pmd_t pmd)
+{
+#ifdef CONFIG_64BIT
+	set_pte_order(pmdp, pmd, L2_USER_PGTABLE_ORDER);
+#else
+	set_pte_order(&pmdp->pud.pgd, pmd.pud.pgd, L2_USER_PGTABLE_ORDER);
+#endif
+}
+
+static inline void pmd_populate_kernel(struct mm_struct *mm,
+				       pmd_t *pmd, pte_t *ptep)
+{
+	set_pmd(pmd, ptfn_pmd(__pa(ptep) >> HV_LOG2_PAGE_TABLE_ALIGN,
+			      __pgprot(_PAGE_PRESENT)));
+}
+
+static inline void pmd_populate(struct mm_struct *mm, pmd_t *pmd,
+				pgtable_t page)
+{
+	set_pmd(pmd, ptfn_pmd(HV_PFN_TO_PTFN(page_to_pfn(page)),
+			      __pgprot(_PAGE_PRESENT)));
+}
+
+/*
+ * Allocate and free page tables.
+ */
+
+extern pgd_t *pgd_alloc(struct mm_struct *mm);
+extern void pgd_free(struct mm_struct *mm, pgd_t *pgd);
+
+extern pgtable_t pte_alloc_one(struct mm_struct *mm, unsigned long address);
+extern void pte_free(struct mm_struct *mm, struct page *pte);
+
+#define pmd_pgtable(pmd) pmd_page(pmd)
+
+static inline pte_t *
+pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
+{
+	return pfn_to_kaddr(page_to_pfn(pte_alloc_one(mm, address)));
+}
+
+static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
+{
+	BUG_ON((unsigned long)pte & (PAGE_SIZE-1));
+	pte_free(mm, virt_to_page(pte));
+}
+
+extern void __pte_free_tlb(struct mmu_gather *tlb, struct page *pte,
+			   unsigned long address);
+
+#define check_pgt_cache()	do { } while (0)
+
+/*
+ * Get the small-page pte_t lowmem entry for a given pfn.
+ * This may or may not be in use, depending on whether the initial
+ * huge-page entry for the page has already been shattered.
+ */
+pte_t *get_prealloc_pte(unsigned long pfn);
+
+/* During init, we can shatter kernel huge pages if needed. */
+void shatter_pmd(pmd_t *pmd);
+
+#ifdef __tilegx__
+/* We share a single page allocator for both L1 and L2 page tables. */
+#if HV_L1_SIZE != HV_L2_SIZE
+# error Rework assumption that L1 and L2 page tables are same size.
+#endif
+#define L1_USER_PGTABLE_ORDER L2_USER_PGTABLE_ORDER
+#define pud_populate(mm, pud, pmd) \
+  pmd_populate_kernel((mm), (pmd_t *)(pud), (pte_t *)(pmd))
+#define pmd_alloc_one(mm, addr) \
+  ((pmd_t *)page_to_virt(pte_alloc_one((mm), (addr))))
+#define pmd_free(mm, pmdp) \
+  pte_free((mm), virt_to_page(pmdp))
+#define __pmd_free_tlb(tlb, pmdp, address) \
+  __pte_free_tlb((tlb), virt_to_page(pmdp), (address))
+#endif
+
+#endif /* _ASM_TILE_PGALLOC_H */
diff --git a/arch/tile/include/asm/pgtable.h b/arch/tile/include/asm/pgtable.h
new file mode 100644
index 0000000..beb1504
--- /dev/null
+++ b/arch/tile/include/asm/pgtable.h
@@ -0,0 +1,475 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ *
+ * This file contains the functions and defines necessary to modify and use
+ * the TILE page table tree.
+ */
+
+#ifndef _ASM_TILE_PGTABLE_H
+#define _ASM_TILE_PGTABLE_H
+
+#include <hv/hypervisor.h>
+
+#ifndef __ASSEMBLY__
+
+#include <linux/bitops.h>
+#include <linux/threads.h>
+#include <linux/slab.h>
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include <asm/processor.h>
+#include <asm/fixmap.h>
+#include <asm/system.h>
+
+struct mm_struct;
+struct vm_area_struct;
+
+/*
+ * ZERO_PAGE is a global shared page that is always zero: used
+ * for zero-mapped memory areas etc..
+ */
+extern unsigned long empty_zero_page[PAGE_SIZE/sizeof(unsigned long)];
+#define ZERO_PAGE(vaddr) (virt_to_page(empty_zero_page))
+
+extern pgd_t swapper_pg_dir[];
+extern pgprot_t swapper_pgprot;
+extern struct kmem_cache *pgd_cache;
+extern spinlock_t pgd_lock;
+extern struct list_head pgd_list;
+
+/*
+ * The very last slots in the pgd_t are for addresses unusable by Linux
+ * (pgd_addr_invalid() returns true).  So we use them for the list structure.
+ * The x86 code we are modelled on uses the page->private/index fields
+ * (older 2.6 kernels) or the lru list (newer 2.6 kernels), but since
+ * our pgds are so much smaller than a page, it seems a waste to
+ * spend a whole page on each pgd.
+ */
+#define PGD_LIST_OFFSET \
+  ((PTRS_PER_PGD * sizeof(pgd_t)) - sizeof(struct list_head))
+#define pgd_to_list(pgd) \
+  ((struct list_head *)((char *)(pgd) + PGD_LIST_OFFSET))
+#define list_to_pgd(list) \
+  ((pgd_t *)((char *)(list) - PGD_LIST_OFFSET))
+
+extern void pgtable_cache_init(void);
+extern void paging_init(void);
+extern void set_page_homes(void);
+
+#define FIRST_USER_ADDRESS	0
+
+#define _PAGE_PRESENT           HV_PTE_PRESENT
+#define _PAGE_HUGE_PAGE         HV_PTE_PAGE
+#define _PAGE_READABLE          HV_PTE_READABLE
+#define _PAGE_WRITABLE          HV_PTE_WRITABLE
+#define _PAGE_EXECUTABLE        HV_PTE_EXECUTABLE
+#define _PAGE_ACCESSED          HV_PTE_ACCESSED
+#define _PAGE_DIRTY             HV_PTE_DIRTY
+#define _PAGE_GLOBAL            HV_PTE_GLOBAL
+#define _PAGE_USER              HV_PTE_USER
+
+/*
+ * All the "standard" bits.  Cache-control bits are managed elsewhere.
+ * This is used to test for valid level-2 page table pointers by checking
+ * all the bits, and to mask away the cache control bits for mprotect.
+ */
+#define _PAGE_ALL (\
+  _PAGE_PRESENT | \
+  _PAGE_HUGE_PAGE | \
+  _PAGE_READABLE | \
+  _PAGE_WRITABLE | \
+  _PAGE_EXECUTABLE | \
+  _PAGE_ACCESSED | \
+  _PAGE_DIRTY | \
+  _PAGE_GLOBAL | \
+  _PAGE_USER \
+)
+
+#define PAGE_NONE \
+	__pgprot(_PAGE_PRESENT | _PAGE_ACCESSED)
+#define PAGE_SHARED \
+	__pgprot(_PAGE_PRESENT | _PAGE_READABLE | _PAGE_WRITABLE | \
+		 _PAGE_USER | _PAGE_ACCESSED)
+
+#define PAGE_SHARED_EXEC \
+	__pgprot(_PAGE_PRESENT | _PAGE_READABLE | _PAGE_WRITABLE | \
+		 _PAGE_EXECUTABLE | _PAGE_USER | _PAGE_ACCESSED)
+#define PAGE_COPY_NOEXEC \
+	__pgprot(_PAGE_PRESENT | _PAGE_USER | _PAGE_ACCESSED | _PAGE_READABLE)
+#define PAGE_COPY_EXEC \
+	__pgprot(_PAGE_PRESENT | _PAGE_USER | _PAGE_ACCESSED | \
+		 _PAGE_READABLE | _PAGE_EXECUTABLE)
+#define PAGE_COPY \
+	PAGE_COPY_NOEXEC
+#define PAGE_READONLY \
+	__pgprot(_PAGE_PRESENT | _PAGE_USER | _PAGE_ACCESSED | _PAGE_READABLE)
+#define PAGE_READONLY_EXEC \
+	__pgprot(_PAGE_PRESENT | _PAGE_USER | _PAGE_ACCESSED | \
+		 _PAGE_READABLE | _PAGE_EXECUTABLE)
+
+#define _PAGE_KERNEL_RO \
+ (_PAGE_PRESENT | _PAGE_GLOBAL | _PAGE_READABLE | _PAGE_ACCESSED)
+#define _PAGE_KERNEL \
+ (_PAGE_KERNEL_RO | _PAGE_WRITABLE | _PAGE_DIRTY)
+#define _PAGE_KERNEL_EXEC       (_PAGE_KERNEL_RO | _PAGE_EXECUTABLE)
+
+#define PAGE_KERNEL		__pgprot(_PAGE_KERNEL)
+#define PAGE_KERNEL_RO		__pgprot(_PAGE_KERNEL_RO)
+#define PAGE_KERNEL_EXEC	__pgprot(_PAGE_KERNEL_EXEC)
+
+#define page_to_kpgprot(p) PAGE_KERNEL
+
+/*
+ * We could tighten these up, but for now writable or executable
+ * implies readable.
+ */
+#define __P000	PAGE_NONE
+#define __P001	PAGE_READONLY
+#define __P010	PAGE_COPY      /* this is write-only, which we won't support */
+#define __P011	PAGE_COPY
+#define __P100	PAGE_READONLY_EXEC
+#define __P101	PAGE_READONLY_EXEC
+#define __P110	PAGE_COPY_EXEC
+#define __P111	PAGE_COPY_EXEC
+
+#define __S000	PAGE_NONE
+#define __S001	PAGE_READONLY
+#define __S010	PAGE_SHARED
+#define __S011	PAGE_SHARED
+#define __S100	PAGE_READONLY_EXEC
+#define __S101	PAGE_READONLY_EXEC
+#define __S110	PAGE_SHARED_EXEC
+#define __S111	PAGE_SHARED_EXEC
+
+/*
+ * All the normal _PAGE_ALL bits are ignored for PMDs, except PAGE_PRESENT
+ * and PAGE_HUGE_PAGE, which must be one and zero, respectively.
+ * We set the ignored bits to zero.
+ */
+#define _PAGE_TABLE     _PAGE_PRESENT
+
+/* Inherit the caching flags from the old protection bits. */
+#define pgprot_modify(oldprot, newprot) \
+  (pgprot_t) { ((oldprot).val & ~_PAGE_ALL) | (newprot).val }
+
+/* Just setting the PFN to zero suffices. */
+#define pte_pgprot(x) hv_pte_set_pfn((x), 0)
+
+/*
+ * For PTEs and PDEs, we must clear the Present bit first when
+ * clearing a page table entry, so clear the bottom half first and
+ * enforce ordering with a barrier.
+ */
+static inline void __pte_clear(pte_t *ptep)
+{
+#ifdef __tilegx__
+	ptep->val = 0;
+#else
+	u32 *tmp = (u32 *)ptep;
+	tmp[0] = 0;
+	barrier();
+	tmp[1] = 0;
+#endif
+}
+#define pte_clear(mm, addr, ptep) __pte_clear(ptep)
+
+/*
+ * The following only work if pte_present() is true.
+ * Undefined behaviour if not..
+ */
+#define pte_present hv_pte_get_present
+#define pte_user hv_pte_get_user
+#define pte_read hv_pte_get_readable
+#define pte_dirty hv_pte_get_dirty
+#define pte_young hv_pte_get_accessed
+#define pte_write hv_pte_get_writable
+#define pte_exec hv_pte_get_executable
+#define pte_huge hv_pte_get_page
+#define pte_rdprotect hv_pte_clear_readable
+#define pte_exprotect hv_pte_clear_executable
+#define pte_mkclean hv_pte_clear_dirty
+#define pte_mkold hv_pte_clear_accessed
+#define pte_wrprotect hv_pte_clear_writable
+#define pte_mksmall hv_pte_clear_page
+#define pte_mkread hv_pte_set_readable
+#define pte_mkexec hv_pte_set_executable
+#define pte_mkdirty hv_pte_set_dirty
+#define pte_mkyoung hv_pte_set_accessed
+#define pte_mkwrite hv_pte_set_writable
+#define pte_mkhuge hv_pte_set_page
+
+#define pte_special(pte) 0
+#define pte_mkspecial(pte) (pte)
+
+/*
+ * Use some spare bits in the PTE for user-caching tags.
+ */
+#define pte_set_forcecache hv_pte_set_client0
+#define pte_get_forcecache hv_pte_get_client0
+#define pte_clear_forcecache hv_pte_clear_client0
+#define pte_set_anyhome hv_pte_set_client1
+#define pte_get_anyhome hv_pte_get_client1
+#define pte_clear_anyhome hv_pte_clear_client1
+
+/*
+ * A migrating PTE has PAGE_PRESENT clear but all the other bits preserved.
+ */
+#define pte_migrating hv_pte_get_migrating
+#define pte_mkmigrate(x) hv_pte_set_migrating(hv_pte_clear_present(x))
+#define pte_donemigrate(x) hv_pte_set_present(hv_pte_clear_migrating(x))
+
+#define pte_ERROR(e) \
+	printk("%s:%d: bad pte 0x%016llx.\n", __FILE__, __LINE__, pte_val(e))
+#define pgd_ERROR(e) \
+	printk("%s:%d: bad pgd 0x%016llx.\n", __FILE__, __LINE__, pgd_val(e))
+
+/*
+ * set_pte_order() sets the given PTE and also sanity-checks the
+ * requested PTE against the page homecaching.  Unspecified parts
+ * of the PTE are filled in when it is written to memory, i.e. all
+ * caching attributes if "!forcecache", or the home cpu if "anyhome".
+ */
+extern void set_pte_order(pte_t *ptep, pte_t pte, int order);
+
+#define set_pte(ptep, pteval) set_pte_order(ptep, pteval, 0)
+#define set_pte_at(mm, addr, ptep, pteval) set_pte(ptep, pteval)
+#define set_pte_atomic(pteptr, pteval) set_pte(pteptr, pteval)
+
+#define pte_page(x)		pfn_to_page(pte_pfn(x))
+
+static inline int pte_none(pte_t pte)
+{
+	return !pte.val;
+}
+
+static inline unsigned long pte_pfn(pte_t pte)
+{
+	return hv_pte_get_pfn(pte);
+}
+
+/* Set or get the remote cache cpu in a pgprot with remote caching. */
+extern pgprot_t set_remote_cache_cpu(pgprot_t prot, int cpu);
+extern int get_remote_cache_cpu(pgprot_t prot);
+
+static inline pte_t pfn_pte(unsigned long pfn, pgprot_t prot)
+{
+	return hv_pte_set_pfn(prot, pfn);
+}
+
+/* Support for priority mappings. */
+extern void start_mm_caching(struct mm_struct *mm);
+extern void check_mm_caching(struct mm_struct *prev, struct mm_struct *next);
+
+/*
+ * Support non-linear file mappings (see sys_remap_file_pages).
+ * This is defined by CLIENT1 set but CLIENT0 and _PAGE_PRESENT clear, and the
+ * file offset in the 32 high bits.
+ */
+#define _PAGE_FILE        HV_PTE_CLIENT1
+#define PTE_FILE_MAX_BITS 32
+#define pte_file(pte)     (hv_pte_get_client1(pte) && !hv_pte_get_client0(pte))
+#define pte_to_pgoff(pte) ((pte).val >> 32)
+#define pgoff_to_pte(off) ((pte_t) { (((long long)(off)) << 32) | _PAGE_FILE })
+
+/*
+ * Encode and de-code a swap entry (see <linux/swapops.h>).
+ * We put the swap file type+offset in the 32 high bits;
+ * I believe we can just leave the low bits clear.
+ */
+#define __swp_type(swp)		((swp).val & 0x1f)
+#define __swp_offset(swp)	((swp).val >> 5)
+#define __swp_entry(type, off)	((swp_entry_t) { (type) | ((off) << 5) })
+#define __pte_to_swp_entry(pte)	((swp_entry_t) { (pte).val >> 32 })
+#define __swp_entry_to_pte(swp)	((pte_t) { (((long long) ((swp).val)) << 32) })
+
+/*
+ * clone_pgd_range(pgd_t *dst, pgd_t *src, int count);
+ *
+ *  dst - pointer to pgd range anwhere on a pgd page
+ *  src - ""
+ *  count - the number of pgds to copy.
+ *
+ * dst and src can be on the same page, but the range must not overlap,
+ * and must not cross a page boundary.
+ */
+static inline void clone_pgd_range(pgd_t *dst, pgd_t *src, int count)
+{
+       memcpy(dst, src, count * sizeof(pgd_t));
+}
+
+/*
+ * Conversion functions: convert a page and protection to a page entry,
+ * and a page entry and page directory to the page they refer to.
+ */
+
+#define mk_pte(page, pgprot)	pfn_pte(page_to_pfn(page), (pgprot))
+
+/*
+ * If we are doing an mprotect(), just accept the new vma->vm_page_prot
+ * value and combine it with the PFN from the old PTE to get a new PTE.
+ */
+static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
+{
+	return pfn_pte(hv_pte_get_pfn(pte), newprot);
+}
+
+/*
+ * The pgd page can be thought of an array like this: pgd_t[PTRS_PER_PGD]
+ *
+ * This macro returns the index of the entry in the pgd page which would
+ * control the given virtual address.
+ */
+#define pgd_index(address) (((address) >> PGDIR_SHIFT) & (PTRS_PER_PGD - 1))
+
+/*
+ * pgd_offset() returns a (pgd_t *)
+ * pgd_index() is used get the offset into the pgd page's array of pgd_t's.
+ */
+#define pgd_offset(mm, address) ((mm)->pgd + pgd_index(address))
+
+/*
+ * A shortcut which implies the use of the kernel's pgd, instead
+ * of a process's.
+ */
+#define pgd_offset_k(address) pgd_offset(&init_mm, address)
+
+#if defined(CONFIG_HIGHPTE)
+extern pte_t *_pte_offset_map(pmd_t *, unsigned long address, enum km_type);
+#define pte_offset_map(dir, address) \
+	_pte_offset_map(dir, address, KM_PTE0)
+#define pte_offset_map_nested(dir, address) \
+	_pte_offset_map(dir, address, KM_PTE1)
+#define pte_unmap(pte) kunmap_atomic(pte, KM_PTE0)
+#define pte_unmap_nested(pte) kunmap_atomic(pte, KM_PTE1)
+#else
+#define pte_offset_map(dir, address) pte_offset_kernel(dir, address)
+#define pte_offset_map_nested(dir, address) pte_offset_map(dir, address)
+#define pte_unmap(pte) do { } while (0)
+#define pte_unmap_nested(pte) do { } while (0)
+#endif
+
+/* Clear a non-executable kernel PTE and flush it from the TLB. */
+#define kpte_clear_flush(ptep, vaddr)		\
+do {						\
+	pte_clear(&init_mm, (vaddr), (ptep));	\
+	local_flush_tlb_page(FLUSH_NONEXEC, (vaddr), PAGE_SIZE); \
+} while (0)
+
+/*
+ * The kernel page tables contain what we need, and we flush when we
+ * change specific page table entries.
+ */
+#define update_mmu_cache(vma, address, pte) do { } while (0)
+
+#ifdef CONFIG_FLATMEM
+#define kern_addr_valid(addr)	(1)
+#endif /* CONFIG_FLATMEM */
+
+#define io_remap_pfn_range(vma, vaddr, pfn, size, prot)		\
+		remap_pfn_range(vma, vaddr, pfn, size, prot)
+
+extern void vmalloc_sync_all(void);
+
+#endif /* !__ASSEMBLY__ */
+
+#ifdef __tilegx__
+#include <asm/pgtable_64.h>
+#else
+#include <asm/pgtable_32.h>
+#endif
+
+#ifndef __ASSEMBLY__
+
+static inline int pmd_none(pmd_t pmd)
+{
+	/*
+	 * Only check low word on 32-bit platforms, since it might be
+	 * out of sync with upper half.
+	 */
+	return (unsigned long)pmd_val(pmd) == 0;
+}
+
+static inline int pmd_present(pmd_t pmd)
+{
+	return pmd_val(pmd) & _PAGE_PRESENT;
+}
+
+static inline int pmd_bad(pmd_t pmd)
+{
+	return ((pmd_val(pmd) & _PAGE_ALL) != _PAGE_TABLE);
+}
+
+static inline unsigned long pages_to_mb(unsigned long npg)
+{
+	return npg >> (20 - PAGE_SHIFT);
+}
+
+/*
+ * The pmd can be thought of an array like this: pmd_t[PTRS_PER_PMD]
+ *
+ * This function returns the index of the entry in the pmd which would
+ * control the given virtual address.
+ */
+static inline unsigned long pmd_index(unsigned long address)
+{
+	return (address >> PMD_SHIFT) & (PTRS_PER_PMD - 1);
+}
+
+/*
+ * A given kernel pmd_t maps to a specific virtual address (either a
+ * kernel huge page or a kernel pte_t table).  Since kernel pte_t
+ * tables can be aligned at sub-page granularity, this function can
+ * return non-page-aligned pointers, despite its name.
+ */
+static inline unsigned long pmd_page_vaddr(pmd_t pmd)
+{
+	phys_addr_t pa =
+		(phys_addr_t)pmd_ptfn(pmd) << HV_LOG2_PAGE_TABLE_ALIGN;
+	return (unsigned long)__va(pa);
+}
+
+/*
+ * A pmd_t points to the base of a huge page or to a pte_t array.
+ * If a pte_t array, since we can have multiple per page, we don't
+ * have a one-to-one mapping of pmd_t's to pages.  However, this is
+ * OK for pte_lockptr(), since we just end up with potentially one
+ * lock being used for several pte_t arrays.
+ */
+#define pmd_page(pmd) pfn_to_page(HV_PTFN_TO_PFN(pmd_ptfn(pmd)))
+
+/*
+ * The pte page can be thought of an array like this: pte_t[PTRS_PER_PTE]
+ *
+ * This macro returns the index of the entry in the pte page which would
+ * control the given virtual address.
+ */
+static inline unsigned long pte_index(unsigned long address)
+{
+	return (address >> PAGE_SHIFT) & (PTRS_PER_PTE - 1);
+}
+
+static inline pte_t *pte_offset_kernel(pmd_t *pmd, unsigned long address)
+{
+       return (pte_t *)pmd_page_vaddr(*pmd) + pte_index(address);
+}
+
+static inline int pmd_huge_page(pmd_t pmd)
+{
+	return pmd_val(pmd) & _PAGE_HUGE_PAGE;
+}
+
+#include <asm-generic/pgtable.h>
+
+#endif /* !__ASSEMBLY__ */
+
+#endif /* _ASM_TILE_PGTABLE_H */
diff --git a/arch/tile/include/asm/pgtable_32.h b/arch/tile/include/asm/pgtable_32.h
new file mode 100644
index 0000000..b935fb2
--- /dev/null
+++ b/arch/tile/include/asm/pgtable_32.h
@@ -0,0 +1,117 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ *
+ */
+
+#ifndef _ASM_TILE_PGTABLE_32_H
+#define _ASM_TILE_PGTABLE_32_H
+
+/*
+ * The level-1 index is defined by the huge page size.  A PGD is composed
+ * of PTRS_PER_PGD pgd_t's and is the top level of the page table.
+ */
+#define PGDIR_SHIFT	HV_LOG2_PAGE_SIZE_LARGE
+#define PGDIR_SIZE	HV_PAGE_SIZE_LARGE
+#define PGDIR_MASK	(~(PGDIR_SIZE-1))
+#define PTRS_PER_PGD	(1 << (32 - PGDIR_SHIFT))
+
+/*
+ * The level-2 index is defined by the difference between the huge
+ * page size and the normal page size.  A PTE is composed of
+ * PTRS_PER_PTE pte_t's and is the bottom level of the page table.
+ * Note that the hypervisor docs use PTE for what we call pte_t, so
+ * this nomenclature is somewhat confusing.
+ */
+#define PTRS_PER_PTE (1 << (HV_LOG2_PAGE_SIZE_LARGE - HV_LOG2_PAGE_SIZE_SMALL))
+
+#ifndef __ASSEMBLY__
+
+/*
+ * Right now we initialize only a single pte table. It can be extended
+ * easily, subsequent pte tables have to be allocated in one physical
+ * chunk of RAM.
+ *
+ * HOWEVER, if we are using an allocation scheme with slop after the
+ * end of the page table (e.g. where our L2 page tables are 2KB but
+ * our pages are 64KB and we are allocating via the page allocator)
+ * we can't extend it easily.
+ */
+#define LAST_PKMAP PTRS_PER_PTE
+
+#define PKMAP_BASE   ((FIXADDR_BOOT_START - PAGE_SIZE*LAST_PKMAP) & PGDIR_MASK)
+
+#ifdef CONFIG_HIGHMEM
+# define __VMAPPING_END	(PKMAP_BASE & ~(HPAGE_SIZE-1))
+#else
+# define __VMAPPING_END	(FIXADDR_START & ~(HPAGE_SIZE-1))
+#endif
+
+#ifdef CONFIG_HUGEVMAP
+#define HUGE_VMAP_END	__VMAPPING_END
+#define HUGE_VMAP_BASE	(HUGE_VMAP_END - CONFIG_NR_HUGE_VMAPS * HPAGE_SIZE)
+#define _VMALLOC_END	HUGE_VMAP_BASE
+#else
+#define _VMALLOC_END	__VMAPPING_END
+#endif
+
+/*
+ * Align the vmalloc area to an L2 page table, and leave a guard page
+ * at the beginning and end.  The vmalloc code also puts in an internal
+ * guard page between each allocation.
+ */
+#define VMALLOC_END	(_VMALLOC_END - PAGE_SIZE)
+extern unsigned long VMALLOC_RESERVE /* = CONFIG_VMALLOC_RESERVE */;
+#define _VMALLOC_START	(_VMALLOC_END - VMALLOC_RESERVE)
+#define VMALLOC_START	(_VMALLOC_START + PAGE_SIZE)
+
+/* This is the maximum possible amount of lowmem. */
+#define MAXMEM		(_VMALLOC_START - PAGE_OFFSET)
+
+/* We have no pmd or pud since we are strictly a two-level page table */
+#include <asm-generic/pgtable-nopmd.h>
+
+/* We don't define any pgds for these addresses. */
+static inline int pgd_addr_invalid(unsigned long addr)
+{
+	return addr >= MEM_HV_INTRPT;
+}
+
+/*
+ * Provide versions of these routines that can be used safely when
+ * the hypervisor may be asynchronously modifying dirty/accessed bits.
+ */
+#define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
+#define __HAVE_ARCH_PTEP_SET_WRPROTECT
+
+extern int ptep_test_and_clear_young(struct vm_area_struct *,
+				     unsigned long addr, pte_t *);
+extern void ptep_set_wrprotect(struct mm_struct *,
+			       unsigned long addr, pte_t *);
+
+/* Create a pmd from a PTFN. */
+static inline pmd_t ptfn_pmd(unsigned long ptfn, pgprot_t prot)
+{
+	return (pmd_t){ { hv_pte_set_ptfn(prot, ptfn) } };
+}
+
+/* Return the page-table frame number (ptfn) that a pmd_t points at. */
+#define pmd_ptfn(pmd) hv_pte_get_ptfn((pmd).pud.pgd)
+
+static inline void pmd_clear(pmd_t *pmdp)
+{
+	__pte_clear(&pmdp->pud.pgd);
+}
+
+#endif /* __ASSEMBLY__ */
+
+#endif /* _ASM_TILE_PGTABLE_32_H */
diff --git a/arch/tile/include/asm/poll.h b/arch/tile/include/asm/poll.h
new file mode 100644
index 0000000..c98509d
--- /dev/null
+++ b/arch/tile/include/asm/poll.h
@@ -0,0 +1 @@
+#include <asm-generic/poll.h>
diff --git a/arch/tile/include/asm/posix_types.h b/arch/tile/include/asm/posix_types.h
new file mode 100644
index 0000000..22cae62
--- /dev/null
+++ b/arch/tile/include/asm/posix_types.h
@@ -0,0 +1 @@
+#include <asm-generic/posix_types.h>
diff --git a/arch/tile/include/asm/processor.h b/arch/tile/include/asm/processor.h
new file mode 100644
index 0000000..96c50d2
--- /dev/null
+++ b/arch/tile/include/asm/processor.h
@@ -0,0 +1,339 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_PROCESSOR_H
+#define _ASM_TILE_PROCESSOR_H
+
+#ifndef __ASSEMBLY__
+
+/*
+ * NOTE: we don't include <linux/ptrace.h> or <linux/percpu.h> as one
+ * normally would, due to #include dependencies.
+ */
+#include <asm/ptrace.h>
+#include <asm/percpu.h>
+
+#include <arch/chip.h>
+#include <arch/spr_def.h>
+
+struct task_struct;
+struct thread_struct;
+struct list_head;
+
+typedef struct {
+	unsigned long seg;
+} mm_segment_t;
+
+/*
+ * Default implementation of macro that returns current
+ * instruction pointer ("program counter").
+ */
+void *current_text_addr(void);
+
+#if CHIP_HAS_TILE_DMA()
+/* Capture the state of a suspended DMA. */
+struct tile_dma_state {
+	int enabled;
+	unsigned long src;
+	unsigned long dest;
+	unsigned long strides;
+	unsigned long chunk_size;
+	unsigned long src_chunk;
+	unsigned long dest_chunk;
+	unsigned long byte;
+	unsigned long status;
+};
+
+/*
+ * A mask of the DMA status register for selecting only the 'running'
+ * and 'done' bits.
+ */
+#define DMA_STATUS_MASK \
+  (SPR_DMA_STATUS__RUNNING_MASK | SPR_DMA_STATUS__DONE_MASK)
+#endif
+
+/*
+ * Track asynchronous TLB events (faults and access violations)
+ * that occur while we are in kernel mode from DMA or the SN processor.
+ */
+struct async_tlb {
+	short fault_num;         /* original fault number; 0 if none */
+	char is_fault;           /* was it a fault (vs an access violation) */
+	char is_write;           /* for fault: was it caused by a write? */
+	unsigned long address;   /* what address faulted? */
+};
+
+
+struct thread_struct {
+	/* kernel stack pointer */
+	unsigned long  ksp;
+	/* kernel PC */
+	unsigned long  pc;
+	/* starting user stack pointer (for page migration) */
+	unsigned long  usp0;
+	/* pid of process that created this one */
+	pid_t creator_pid;
+#if CHIP_HAS_TILE_DMA()
+	/* DMA info for suspended threads (byte == 0 means no DMA state) */
+	struct tile_dma_state tile_dma_state;
+#endif
+	/* User EX_CONTEXT registers */
+	unsigned long ex_context[2];
+	/* User SYSTEM_SAVE registers */
+	unsigned long system_save[4];
+	/* User interrupt mask */
+	unsigned long long interrupt_mask;
+	/* User interrupt-control 0 state */
+	unsigned long intctrl_0;
+#if CHIP_HAS_PROC_STATUS_SPR()
+	/* Any other miscellaneous processor state bits */
+	unsigned long proc_status;
+#endif
+#if CHIP_HAS_TILE_DMA()
+	/* Async DMA TLB fault information */
+	struct async_tlb dma_async_tlb;
+#endif
+#if CHIP_HAS_SN_PROC()
+	/* Was static network processor when we were switched out? */
+	int sn_proc_running;
+	/* Async SNI TLB fault information */
+	struct async_tlb sn_async_tlb;
+#endif
+};
+
+#endif /* !__ASSEMBLY__ */
+
+/*
+ * Start with "sp" this many bytes below the top of the kernel stack.
+ * This preserves the invariant that a called function may write to *sp.
+ */
+#define STACK_TOP_DELTA 8
+
+/*
+ * When entering the kernel via a fault, start with the top of the
+ * pt_regs structure this many bytes below the top of the page.
+ * This aligns the pt_regs structure optimally for cache-line access.
+ */
+#ifdef __tilegx__
+#define KSTK_PTREGS_GAP  48
+#else
+#define KSTK_PTREGS_GAP  56
+#endif
+
+#ifndef __ASSEMBLY__
+
+#ifdef __tilegx__
+#define TASK_SIZE_MAX		(MEM_LOW_END + 1)
+#else
+#define TASK_SIZE_MAX		PAGE_OFFSET
+#endif
+
+/* TASK_SIZE and related variables are always checked in "current" context. */
+#ifdef CONFIG_COMPAT
+#define COMPAT_TASK_SIZE	(1UL << 31)
+#define TASK_SIZE		((current_thread_info()->status & TS_COMPAT) ?\
+				 COMPAT_TASK_SIZE : TASK_SIZE_MAX)
+#else
+#define TASK_SIZE		TASK_SIZE_MAX
+#endif
+
+/* We provide a minimal "vdso" a la x86; just the sigreturn code for now. */
+#define VDSO_BASE		(TASK_SIZE - PAGE_SIZE)
+
+#define STACK_TOP		VDSO_BASE
+
+/* STACK_TOP_MAX is used temporarily in execve and should not check COMPAT. */
+#define STACK_TOP_MAX		TASK_SIZE_MAX
+
+/*
+ * This decides where the kernel will search for a free chunk of vm
+ * space during mmap's, if it is using bottom-up mapping.
+ */
+#define TASK_UNMAPPED_BASE	(PAGE_ALIGN(TASK_SIZE / 3))
+
+#define HAVE_ARCH_PICK_MMAP_LAYOUT
+
+#define INIT_THREAD {                                                   \
+	.ksp = (unsigned long)init_stack + THREAD_SIZE - STACK_TOP_DELTA, \
+	.interrupt_mask = -1ULL                                         \
+}
+
+/* Kernel stack top for the task that first boots on this cpu. */
+DECLARE_PER_CPU(unsigned long, boot_sp);
+
+/* PC to boot from on this cpu. */
+DECLARE_PER_CPU(unsigned long, boot_pc);
+
+/* Do necessary setup to start up a newly executed thread. */
+static inline void start_thread(struct pt_regs *regs,
+				unsigned long pc, unsigned long usp)
+{
+	regs->pc = pc;
+	regs->sp = usp;
+}
+
+/* Free all resources held by a thread. */
+static inline void release_thread(struct task_struct *dead_task)
+{
+	/* Nothing for now */
+}
+
+/* Prepare to copy thread state - unlazy all lazy status. */
+#define prepare_to_copy(tsk)	do { } while (0)
+
+extern int kernel_thread(int (*fn)(void *), void *arg, unsigned long flags);
+
+/* Helper routines for setting home cache modes at exec() time. */
+
+
+/*
+ * Return saved (kernel) PC of a blocked thread.
+ * Only used in a printk() in kernel/sched.c, so don't work too hard.
+ */
+#define thread_saved_pc(t)   ((t)->thread.pc)
+
+unsigned long get_wchan(struct task_struct *p);
+
+/* Return initial ksp value for given task. */
+#define task_ksp0(task) ((unsigned long)(task)->stack + THREAD_SIZE)
+
+/* Return some info about the user process TASK. */
+#define KSTK_TOP(task)	(task_ksp0(task) - STACK_TOP_DELTA)
+#define task_pt_regs(task) \
+  ((struct pt_regs *)(task_ksp0(task) - KSTK_PTREGS_GAP) - 1)
+#define task_sp(task)	(task_pt_regs(task)->sp)
+#define task_pc(task)	(task_pt_regs(task)->pc)
+/* Aliases for pc and sp (used in fs/proc/array.c) */
+#define KSTK_EIP(task)	task_pc(task)
+#define KSTK_ESP(task)	task_sp(task)
+
+/* Standard format for printing registers and other word-size data. */
+#ifdef __tilegx__
+# define REGFMT "0x%016lx"
+#else
+# define REGFMT "0x%08lx"
+#endif
+
+/*
+ * Do some slow action (e.g. read a slow SPR).
+ * Note that this must also have compiler-barrier semantics since
+ * it may be used in a busy loop reading memory.
+ */
+static inline void cpu_relax(void)
+{
+	__insn_mfspr(SPR_PASS);
+	barrier();
+}
+
+struct siginfo;
+extern void arch_coredump_signal(struct siginfo *, struct pt_regs *);
+#define arch_coredump_signal arch_coredump_signal
+
+/* Provide information about the chip model. */
+extern char chip_model[64];
+
+/* Data on which physical memory controller corresponds to which NUMA node. */
+extern int node_controller[];
+
+
+/* Do we dump information to the console when a user application crashes? */
+extern int show_crashinfo;
+
+#if CHIP_HAS_CBOX_HOME_MAP()
+/* Does the heap allocator return hash-for-home pages by default? */
+extern int hash_default;
+
+/* Should kernel stack pages be hash-for-home? */
+extern int kstack_hash;
+#else
+#define hash_default 0
+#define kstack_hash 0
+#endif
+
+/* Are we using huge pages in the TLB for kernel data? */
+extern int kdata_huge;
+
+/*
+ * Note that with OLOC the prefetch will return an unused read word to
+ * the issuing tile, which will cause some MDN traffic.  Benchmarking
+ * should be done to see whether this outweighs prefetching.
+ */
+#define ARCH_HAS_PREFETCH
+#define ARCH_HAS_PREFETCHW
+#define ARCH_HAS_SPINLOCK_PREFETCH
+
+#define prefetch(ptr) __builtin_prefetch((ptr), 0, 3)
+#define prefetchw(ptr) __builtin_prefetch((ptr), 1, 3)
+
+#ifdef CONFIG_SMP
+#define spin_lock_prefetch(ptr) prefetchw(ptr)
+#else
+/* Nothing to prefetch. */
+#define spin_lock_prefetch(lock)	do { } while (0)
+#endif
+
+#else /* __ASSEMBLY__ */
+
+/* Do some slow action (e.g. read a slow SPR). */
+#define CPU_RELAX       mfspr zero, SPR_PASS
+
+#endif /* !__ASSEMBLY__ */
+
+/* Assembly code assumes that the PL is in the low bits. */
+#if SPR_EX_CONTEXT_1_1__PL_SHIFT != 0
+# error Fix assembly assumptions about PL
+#endif
+
+/* We sometimes use these macros for EX_CONTEXT_0_1 as well. */
+#if SPR_EX_CONTEXT_1_1__PL_SHIFT != SPR_EX_CONTEXT_0_1__PL_SHIFT || \
+    SPR_EX_CONTEXT_1_1__PL_RMASK != SPR_EX_CONTEXT_0_1__PL_RMASK || \
+    SPR_EX_CONTEXT_1_1__ICS_SHIFT != SPR_EX_CONTEXT_0_1__ICS_SHIFT || \
+    SPR_EX_CONTEXT_1_1__ICS_RMASK != SPR_EX_CONTEXT_0_1__ICS_RMASK
+# error Fix assumptions that EX1 macros work for both PL0 and PL1
+#endif
+
+/* Allow pulling apart and recombining the PL and ICS bits in EX_CONTEXT. */
+#define EX1_PL(ex1) \
+  (((ex1) >> SPR_EX_CONTEXT_1_1__PL_SHIFT) & SPR_EX_CONTEXT_1_1__PL_RMASK)
+#define EX1_ICS(ex1) \
+  (((ex1) >> SPR_EX_CONTEXT_1_1__ICS_SHIFT) & SPR_EX_CONTEXT_1_1__ICS_RMASK)
+#define PL_ICS_EX1(pl, ics) \
+  (((pl) << SPR_EX_CONTEXT_1_1__PL_SHIFT) | \
+   ((ics) << SPR_EX_CONTEXT_1_1__ICS_SHIFT))
+
+/*
+ * Provide symbolic constants for PLs.
+ * Note that assembly code assumes that USER_PL is zero.
+ */
+#define USER_PL 0
+#define KERNEL_PL 1
+
+/* SYSTEM_SAVE_1_0 holds the current cpu number ORed with ksp0. */
+#define CPU_LOG_MASK_VALUE 12
+#define CPU_MASK_VALUE ((1 << CPU_LOG_MASK_VALUE) - 1)
+#if CONFIG_NR_CPUS > CPU_MASK_VALUE
+# error Too many cpus!
+#endif
+#define raw_smp_processor_id() \
+	((int)__insn_mfspr(SPR_SYSTEM_SAVE_1_0) & CPU_MASK_VALUE)
+#define get_current_ksp0() \
+	(__insn_mfspr(SPR_SYSTEM_SAVE_1_0) & ~CPU_MASK_VALUE)
+#define next_current_ksp0(task) ({ \
+	unsigned long __ksp0 = task_ksp0(task); \
+	int __cpu = raw_smp_processor_id(); \
+	BUG_ON(__ksp0 & CPU_MASK_VALUE); \
+	__ksp0 | __cpu; \
+})
+
+#endif /* _ASM_TILE_PROCESSOR_H */
diff --git a/arch/tile/include/asm/ptrace.h b/arch/tile/include/asm/ptrace.h
new file mode 100644
index 0000000..4d1d995
--- /dev/null
+++ b/arch/tile/include/asm/ptrace.h
@@ -0,0 +1,163 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_PTRACE_H
+#define _ASM_TILE_PTRACE_H
+
+#include <arch/chip.h>
+#include <arch/abi.h>
+
+/* These must match struct pt_regs, below. */
+#if CHIP_WORD_SIZE() == 32
+#define PTREGS_OFFSET_REG(n)    ((n)*4)
+#else
+#define PTREGS_OFFSET_REG(n)    ((n)*8)
+#endif
+#define PTREGS_OFFSET_BASE      0
+#define PTREGS_OFFSET_TP        PTREGS_OFFSET_REG(53)
+#define PTREGS_OFFSET_SP        PTREGS_OFFSET_REG(54)
+#define PTREGS_OFFSET_LR        PTREGS_OFFSET_REG(55)
+#define PTREGS_NR_GPRS          56
+#define PTREGS_OFFSET_PC        PTREGS_OFFSET_REG(56)
+#define PTREGS_OFFSET_EX1       PTREGS_OFFSET_REG(57)
+#define PTREGS_OFFSET_FAULTNUM  PTREGS_OFFSET_REG(58)
+#define PTREGS_OFFSET_ORIG_R0   PTREGS_OFFSET_REG(59)
+#define PTREGS_OFFSET_FLAGS     PTREGS_OFFSET_REG(60)
+#if CHIP_HAS_CMPEXCH()
+#define PTREGS_OFFSET_CMPEXCH   PTREGS_OFFSET_REG(61)
+#endif
+#define PTREGS_SIZE             PTREGS_OFFSET_REG(64)
+
+#ifndef __ASSEMBLY__
+
+#ifdef __KERNEL__
+/* Benefit from consistent use of "long" on all chips. */
+typedef unsigned long pt_reg_t;
+#else
+/* Provide appropriate length type to userspace regardless of -m32/-m64. */
+typedef uint_reg_t pt_reg_t;
+#endif
+
+/*
+ * This struct defines the way the registers are stored on the stack during a
+ * system call/exception.  It should be a multiple of 8 bytes to preserve
+ * normal stack alignment rules.
+ *
+ * Must track <sys/ucontext.h> and <sys/procfs.h>
+ */
+struct pt_regs {
+	/* Saved main processor registers; 56..63 are special. */
+	/* tp, sp, and lr must immediately follow regs[] for aliasing. */
+	pt_reg_t regs[53];
+	pt_reg_t tp;		/* aliases regs[TREG_TP] */
+	pt_reg_t sp;		/* aliases regs[TREG_SP] */
+	pt_reg_t lr;		/* aliases regs[TREG_LR] */
+
+	/* Saved special registers. */
+	pt_reg_t pc;		/* stored in EX_CONTEXT_1_0 */
+	pt_reg_t ex1;		/* stored in EX_CONTEXT_1_1 (PL and ICS bit) */
+	pt_reg_t faultnum;	/* fault number (INT_SWINT_1 for syscall) */
+	pt_reg_t orig_r0;	/* r0 at syscall entry, else zero */
+	pt_reg_t flags;		/* flags (see below) */
+#if !CHIP_HAS_CMPEXCH()
+	pt_reg_t pad[3];
+#else
+	pt_reg_t cmpexch;	/* value of CMPEXCH_VALUE SPR at interrupt */
+	pt_reg_t pad[2];
+#endif
+};
+
+#endif /* __ASSEMBLY__ */
+
+/* Flag bits in pt_regs.flags */
+#define PT_FLAGS_DISABLE_IRQ    1  /* on return to kernel, disable irqs */
+#define PT_FLAGS_CALLER_SAVES   2  /* caller-save registers are valid */
+#define PT_FLAGS_RESTORE_REGS   4  /* restore callee-save regs on return */
+
+#define PTRACE_GETREGS		12
+#define PTRACE_SETREGS		13
+#define PTRACE_GETFPREGS	14
+#define PTRACE_SETFPREGS	15
+
+/* Support TILE-specific ptrace options, with events starting at 16. */
+#define PTRACE_O_TRACEMIGRATE	0x00010000
+#define PTRACE_EVENT_MIGRATE	16
+#ifdef __KERNEL__
+#define PTRACE_O_MASK_TILE	(PTRACE_O_TRACEMIGRATE)
+#define PT_TRACE_MIGRATE	0x00080000
+#define PT_TRACE_MASK_TILE	(PT_TRACE_MIGRATE)
+#endif
+
+#ifdef __KERNEL__
+
+#ifndef __ASSEMBLY__
+
+#define instruction_pointer(regs) ((regs)->pc)
+#define profile_pc(regs) instruction_pointer(regs)
+
+/* Does the process account for user or for system time? */
+#define user_mode(regs) (EX1_PL((regs)->ex1) == USER_PL)
+
+/* Fill in a struct pt_regs with the current kernel registers. */
+struct pt_regs *get_pt_regs(struct pt_regs *);
+
+extern void show_regs(struct pt_regs *);
+
+#define arch_has_single_step()	(1)
+
+/*
+ * A structure for all single-stepper state.
+ *
+ * Also update defines in assembler section if it changes
+ */
+struct single_step_state {
+	/* the page to which we will write hacked-up bundles */
+	void *buffer;
+
+	union {
+		int flags;
+		struct {
+			unsigned long is_enabled:1, update:1, update_reg:6;
+		};
+	};
+
+	unsigned long orig_pc;		/* the original PC */
+	unsigned long next_pc;		/* return PC if no branch (PC + 1) */
+	unsigned long branch_next_pc;	/* return PC if we did branch/jump */
+	unsigned long update_value;	/* value to restore to update_target */
+};
+
+/* Single-step the instruction at regs->pc */
+extern void single_step_once(struct pt_regs *regs);
+
+struct task_struct;
+
+extern void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs,
+			 int error_code);
+
+#ifdef __tilegx__
+/* We need this since sigval_t has a user pointer in it, for GETSIGINFO etc. */
+#define __ARCH_WANT_COMPAT_SYS_PTRACE
+#endif
+
+#endif /* !__ASSEMBLY__ */
+
+#define SINGLESTEP_STATE_MASK_IS_ENABLED      0x1
+#define SINGLESTEP_STATE_MASK_UPDATE          0x2
+#define SINGLESTEP_STATE_TARGET_LB              2
+#define SINGLESTEP_STATE_TARGET_UB              7
+
+#endif /* !__KERNEL__ */
+
+#endif /* _ASM_TILE_PTRACE_H */
diff --git a/arch/tile/include/asm/resource.h b/arch/tile/include/asm/resource.h
new file mode 100644
index 0000000..04bc4db
--- /dev/null
+++ b/arch/tile/include/asm/resource.h
@@ -0,0 +1 @@
+#include <asm-generic/resource.h>
diff --git a/arch/tile/include/asm/scatterlist.h b/arch/tile/include/asm/scatterlist.h
new file mode 100644
index 0000000..35d786f
--- /dev/null
+++ b/arch/tile/include/asm/scatterlist.h
@@ -0,0 +1 @@
+#include <asm-generic/scatterlist.h>
diff --git a/arch/tile/include/asm/sections.h b/arch/tile/include/asm/sections.h
new file mode 100644
index 0000000..6c11149
--- /dev/null
+++ b/arch/tile/include/asm/sections.h
@@ -0,0 +1,37 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_SECTIONS_H
+#define _ASM_TILE_SECTIONS_H
+
+#define arch_is_kernel_data arch_is_kernel_data
+
+#include <asm-generic/sections.h>
+
+/* Text and data are at different areas in the kernel VA space. */
+extern char _sinitdata[], _einitdata[];
+
+/* Write-once data is writable only till the end of initialization. */
+extern char __w1data_begin[], __w1data_end[];
+
+extern char __feedback_section_start[], __feedback_section_end[];
+
+/* Handle the discontiguity between _sdata and _stext. */
+static inline int arch_is_kernel_data(unsigned long addr)
+{
+	return addr >= (unsigned long)_sdata &&
+		addr < (unsigned long)_end;
+}
+
+#endif /* _ASM_TILE_SECTIONS_H */
diff --git a/arch/tile/include/asm/sembuf.h b/arch/tile/include/asm/sembuf.h
new file mode 100644
index 0000000..7673b83
--- /dev/null
+++ b/arch/tile/include/asm/sembuf.h
@@ -0,0 +1 @@
+#include <asm-generic/sembuf.h>
diff --git a/arch/tile/include/asm/setup.h b/arch/tile/include/asm/setup.h
new file mode 100644
index 0000000..823ddd4
--- /dev/null
+++ b/arch/tile/include/asm/setup.h
@@ -0,0 +1,32 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_SETUP_H
+#define _ASM_TILE_SETUP_H
+
+#include <linux/pfn.h>
+#include <linux/init.h>
+
+/*
+ * Reserved space for vmalloc and iomap - defined in asm/page.h
+ */
+#define MAXMEM_PFN	PFN_DOWN(MAXMEM)
+
+#define COMMAND_LINE_SIZE	2048
+
+void early_panic(const char *fmt, ...);
+void warn_early_printk(void);
+void __init disable_early_printk(void);
+
+#endif /* _ASM_TILE_SETUP_H */
diff --git a/arch/tile/include/asm/shmbuf.h b/arch/tile/include/asm/shmbuf.h
new file mode 100644
index 0000000..83c05fc
--- /dev/null
+++ b/arch/tile/include/asm/shmbuf.h
@@ -0,0 +1 @@
+#include <asm-generic/shmbuf.h>
diff --git a/arch/tile/include/asm/shmparam.h b/arch/tile/include/asm/shmparam.h
new file mode 100644
index 0000000..93f30de
--- /dev/null
+++ b/arch/tile/include/asm/shmparam.h
@@ -0,0 +1 @@
+#include <asm-generic/shmparam.h>
diff --git a/arch/tile/include/asm/sigcontext.h b/arch/tile/include/asm/sigcontext.h
new file mode 100644
index 0000000..7cd7672
--- /dev/null
+++ b/arch/tile/include/asm/sigcontext.h
@@ -0,0 +1,27 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_SIGCONTEXT_H
+#define _ASM_TILE_SIGCONTEXT_H
+
+/* NOTE: we can't include <linux/ptrace.h> due to #include dependencies. */
+#include <asm/ptrace.h>
+
+/* Must track <sys/ucontext.h> */
+
+struct sigcontext {
+	struct pt_regs regs;
+};
+
+#endif /* _ASM_TILE_SIGCONTEXT_H */
diff --git a/arch/tile/include/asm/sigframe.h b/arch/tile/include/asm/sigframe.h
new file mode 100644
index 0000000..994d3d3
--- /dev/null
+++ b/arch/tile/include/asm/sigframe.h
@@ -0,0 +1,33 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_SIGFRAME_H
+#define _ASM_TILE_SIGFRAME_H
+
+/* Indicate that syscall return should not examine r0 */
+#define INT_SWINT_1_SIGRETURN (~0)
+
+#ifndef __ASSEMBLY__
+
+#include <arch/abi.h>
+
+struct rt_sigframe {
+	unsigned char save_area[C_ABI_SAVE_AREA_SIZE]; /* caller save area */
+	struct siginfo info;
+	struct ucontext uc;
+};
+
+#endif /* !__ASSEMBLY__ */
+
+#endif /* _ASM_TILE_SIGFRAME_H */
diff --git a/arch/tile/include/asm/siginfo.h b/arch/tile/include/asm/siginfo.h
new file mode 100644
index 0000000..0c12d1b
--- /dev/null
+++ b/arch/tile/include/asm/siginfo.h
@@ -0,0 +1,30 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_SIGINFO_H
+#define _ASM_TILE_SIGINFO_H
+
+#define __ARCH_SI_TRAPNO
+
+#include <asm-generic/siginfo.h>
+
+/*
+ * Additional Tile-specific SIGILL si_codes
+ */
+#define ILL_DBLFLT	(__SI_FAULT|9)	/* double fault */
+#define ILL_HARDWALL	(__SI_FAULT|10)	/* user networks hardwall violation */
+#undef NSIGILL
+#define NSIGILL		10
+
+#endif /* _ASM_TILE_SIGINFO_H */
diff --git a/arch/tile/include/asm/signal.h b/arch/tile/include/asm/signal.h
new file mode 100644
index 0000000..d20d326
--- /dev/null
+++ b/arch/tile/include/asm/signal.h
@@ -0,0 +1,31 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_SIGNAL_H
+#define _ASM_TILE_SIGNAL_H
+
+/* Do not notify a ptracer when this signal is handled. */
+#define SA_NOPTRACE 0x02000000u
+
+/* Used in earlier Tilera releases, so keeping for binary compatibility. */
+#define SA_RESTORER 0x04000000u
+
+#include <asm-generic/signal.h>
+
+#if defined(__KERNEL__) && !defined(__ASSEMBLY__)
+int restore_sigcontext(struct pt_regs *, struct sigcontext __user *, long *);
+int setup_sigcontext(struct sigcontext __user *, struct pt_regs *);
+#endif
+
+#endif /* _ASM_TILE_SIGNAL_H */
diff --git a/arch/tile/include/asm/smp.h b/arch/tile/include/asm/smp.h
new file mode 100644
index 0000000..da24858
--- /dev/null
+++ b/arch/tile/include/asm/smp.h
@@ -0,0 +1,126 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_SMP_H
+#define _ASM_TILE_SMP_H
+
+#ifdef CONFIG_SMP
+
+#include <asm/processor.h>
+#include <linux/cpumask.h>
+#include <linux/irqreturn.h>
+
+/* Set up this tile to support receiving hypervisor messages */
+void init_messaging(void);
+
+/* Set up this tile to support receiving device interrupts and IPIs. */
+void init_per_tile_IRQs(void);
+
+/* Send a message to processors specified in mask */
+void send_IPI_many(const struct cpumask *mask, int tag);
+
+/* Send a message to all but the sending processor */
+void send_IPI_allbutself(int tag);
+
+/* Send a message to a specific processor */
+void send_IPI_single(int dest, int tag);
+
+/* Process an IPI message */
+void evaluate_message(int tag);
+
+/* Process an IRQ_RESCHEDULE IPI. */
+irqreturn_t handle_reschedule_ipi(int irq, void *token);
+
+/* Boot a secondary cpu */
+void online_secondary(void);
+
+/* Call a function on a specified set of CPUs (may include this one). */
+extern void on_each_cpu_mask(const struct cpumask *mask,
+			     void (*func)(void *), void *info, bool wait);
+
+/* Topology of the supervisor tile grid, and coordinates of boot processor */
+extern HV_Topology smp_topology;
+
+/* Accessors for grid size */
+#define smp_height		(smp_topology.height)
+#define smp_width		(smp_topology.width)
+
+/* Hypervisor message tags sent via the tile send_IPI*() routines. */
+#define MSG_TAG_START_CPU		1
+#define MSG_TAG_STOP_CPU		2
+#define MSG_TAG_CALL_FUNCTION_MANY	3
+#define MSG_TAG_CALL_FUNCTION_SINGLE	4
+
+/* Hook for the generic smp_call_function_many() routine. */
+static inline void arch_send_call_function_ipi_mask(struct cpumask *mask)
+{
+	send_IPI_many(mask, MSG_TAG_CALL_FUNCTION_MANY);
+}
+
+/* Hook for the generic smp_call_function_single() routine. */
+static inline void arch_send_call_function_single_ipi(int cpu)
+{
+	send_IPI_single(cpu, MSG_TAG_CALL_FUNCTION_SINGLE);
+}
+
+/* Print out the boot string describing which cpus were disabled. */
+void print_disabled_cpus(void);
+
+#else /* !CONFIG_SMP */
+
+#define on_each_cpu_mask(mask, func, info, wait)		\
+  do { if (cpumask_test_cpu(0, (mask))) func(info); } while (0)
+
+#define smp_master_cpu		0
+#define smp_height		1
+#define smp_width		1
+
+#endif /* !CONFIG_SMP */
+
+
+/* Which cpus may be used as the lotar in a page table entry. */
+extern struct cpumask cpu_lotar_map;
+#define cpu_is_valid_lotar(cpu) cpumask_test_cpu((cpu), &cpu_lotar_map)
+
+#if CHIP_HAS_CBOX_HOME_MAP()
+/* Which processors are used for hash-for-home mapping */
+extern struct cpumask hash_for_home_map;
+#endif
+
+/* Which cpus can have their cache flushed by hv_flush_remote(). */
+extern struct cpumask cpu_cacheable_map;
+#define cpu_cacheable(cpu) cpumask_test_cpu((cpu), &cpu_cacheable_map)
+
+/* Convert an HV_LOTAR value into a cpu. */
+static inline int hv_lotar_to_cpu(HV_LOTAR lotar)
+{
+	return HV_LOTAR_X(lotar) + (HV_LOTAR_Y(lotar) * smp_width);
+}
+
+/*
+ * Extension of <linux/cpumask.h> functionality when you just want
+ * to express a mask or suppression or inclusion region without
+ * being too concerned about exactly which cpus are valid in that region.
+ */
+int bitmap_parselist_crop(const char *bp, unsigned long *maskp, int nmaskbits);
+
+#define cpulist_parse_crop(buf, dst) \
+			__cpulist_parse_crop((buf), (dst), NR_CPUS)
+static inline int __cpulist_parse_crop(const char *buf, struct cpumask *dstp,
+					int nbits)
+{
+	return bitmap_parselist_crop(buf, cpumask_bits(dstp), nbits);
+}
+
+#endif /* _ASM_TILE_SMP_H */
diff --git a/arch/tile/include/asm/socket.h b/arch/tile/include/asm/socket.h
new file mode 100644
index 0000000..6b71384
--- /dev/null
+++ b/arch/tile/include/asm/socket.h
@@ -0,0 +1 @@
+#include <asm-generic/socket.h>
diff --git a/arch/tile/include/asm/sockios.h b/arch/tile/include/asm/sockios.h
new file mode 100644
index 0000000..def6d47
--- /dev/null
+++ b/arch/tile/include/asm/sockios.h
@@ -0,0 +1 @@
+#include <asm-generic/sockios.h>
diff --git a/arch/tile/include/asm/spinlock.h b/arch/tile/include/asm/spinlock.h
new file mode 100644
index 0000000..1a8bd47
--- /dev/null
+++ b/arch/tile/include/asm/spinlock.h
@@ -0,0 +1,24 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_SPINLOCK_H
+#define _ASM_TILE_SPINLOCK_H
+
+#ifdef __tilegx__
+#include <asm/spinlock_64.h>
+#else
+#include <asm/spinlock_32.h>
+#endif
+
+#endif /* _ASM_TILE_SPINLOCK_H */
diff --git a/arch/tile/include/asm/spinlock_32.h b/arch/tile/include/asm/spinlock_32.h
new file mode 100644
index 0000000..f3a8473
--- /dev/null
+++ b/arch/tile/include/asm/spinlock_32.h
@@ -0,0 +1,200 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ *
+ * 32-bit SMP spinlocks.
+ */
+
+#ifndef _ASM_TILE_SPINLOCK_32_H
+#define _ASM_TILE_SPINLOCK_32_H
+
+#include <asm/atomic.h>
+#include <asm/page.h>
+#include <asm/system.h>
+#include <linux/compiler.h>
+
+/*
+ * We only use even ticket numbers so the '1' inserted by a tns is
+ * an unambiguous "ticket is busy" flag.
+ */
+#define TICKET_QUANTUM 2
+
+
+/*
+ * SMP ticket spinlocks, allowing only a single CPU anywhere
+ *
+ * (the type definitions are in asm/spinlock_types.h)
+ */
+static inline int arch_spin_is_locked(arch_spinlock_t *lock)
+{
+	/*
+	 * Note that even if a new ticket is in the process of being
+	 * acquired, so lock->next_ticket is 1, it's still reasonable
+	 * to claim the lock is held, since it will be momentarily
+	 * if not already.  There's no need to wait for a "valid"
+	 * lock->next_ticket to become available.
+	 */
+	return lock->next_ticket != lock->current_ticket;
+}
+
+void arch_spin_lock(arch_spinlock_t *lock);
+
+/* We cannot take an interrupt after getting a ticket, so don't enable them. */
+#define arch_spin_lock_flags(lock, flags) arch_spin_lock(lock)
+
+int arch_spin_trylock(arch_spinlock_t *lock);
+
+static inline void arch_spin_unlock(arch_spinlock_t *lock)
+{
+	/* For efficiency, overlap fetching the old ticket with the wmb(). */
+	int old_ticket = lock->current_ticket;
+	wmb();  /* guarantee anything modified under the lock is visible */
+	lock->current_ticket = old_ticket + TICKET_QUANTUM;
+}
+
+void arch_spin_unlock_wait(arch_spinlock_t *lock);
+
+/*
+ * Read-write spinlocks, allowing multiple readers
+ * but only one writer.
+ *
+ * We use a "tns/store-back" technique on a single word to manage
+ * the lock state, looping around to retry if the tns returns 1.
+ */
+
+/* Internal layout of the word; do not use. */
+#define _WR_NEXT_SHIFT	8
+#define _WR_CURR_SHIFT  16
+#define _WR_WIDTH       8
+#define _RD_COUNT_SHIFT 24
+#define _RD_COUNT_WIDTH 8
+
+/* Internal functions; do not use. */
+void arch_read_lock_slow(arch_rwlock_t *, u32);
+int arch_read_trylock_slow(arch_rwlock_t *);
+void arch_read_unlock_slow(arch_rwlock_t *);
+void arch_write_lock_slow(arch_rwlock_t *, u32);
+void arch_write_unlock_slow(arch_rwlock_t *, u32);
+
+/**
+ * arch_read_can_lock() - would read_trylock() succeed?
+ */
+static inline int arch_read_can_lock(arch_rwlock_t *rwlock)
+{
+	return (rwlock->lock << _RD_COUNT_WIDTH) == 0;
+}
+
+/**
+ * arch_write_can_lock() - would write_trylock() succeed?
+ */
+static inline int arch_write_can_lock(arch_rwlock_t *rwlock)
+{
+	return rwlock->lock == 0;
+}
+
+/**
+ * arch_read_lock() - acquire a read lock.
+ */
+static inline void arch_read_lock(arch_rwlock_t *rwlock)
+{
+	u32 val = __insn_tns((int *)&rwlock->lock);
+	if (unlikely(val << _RD_COUNT_WIDTH)) {
+		arch_read_lock_slow(rwlock, val);
+		return;
+	}
+	rwlock->lock = val + (1 << _RD_COUNT_SHIFT);
+}
+
+/**
+ * arch_read_lock() - acquire a write lock.
+ */
+static inline void arch_write_lock(arch_rwlock_t *rwlock)
+{
+	u32 val = __insn_tns((int *)&rwlock->lock);
+	if (unlikely(val != 0)) {
+		arch_write_lock_slow(rwlock, val);
+		return;
+	}
+	rwlock->lock = 1 << _WR_NEXT_SHIFT;
+}
+
+/**
+ * arch_read_trylock() - try to acquire a read lock.
+ */
+static inline int arch_read_trylock(arch_rwlock_t *rwlock)
+{
+	int locked;
+	u32 val = __insn_tns((int *)&rwlock->lock);
+	if (unlikely(val & 1)) {
+		return arch_read_trylock_slow(rwlock);
+	}
+	locked = (val << _RD_COUNT_WIDTH) == 0;
+	rwlock->lock = val + (locked << _RD_COUNT_SHIFT);
+	return locked;
+}
+
+/**
+ * arch_write_trylock() - try to acquire a write lock.
+ */
+static inline int arch_write_trylock(arch_rwlock_t *rwlock)
+{
+	u32 val = __insn_tns((int *)&rwlock->lock);
+
+	/*
+	 * If a tns is in progress, or there's a waiting or active locker,
+	 * or active readers, we can't take the lock, so give up.
+	 */
+	if (unlikely(val != 0)) {
+		if (!(val & 1))
+			rwlock->lock = val;
+		return 0;
+	}
+
+	/* Set the "next" field to mark it locked. */
+	rwlock->lock = 1 << _WR_NEXT_SHIFT;
+	return 1;
+}
+
+/**
+ * arch_read_unlock() - release a read lock.
+ */
+static inline void arch_read_unlock(arch_rwlock_t *rwlock)
+{
+	u32 val;
+	mb();  /* guarantee anything modified under the lock is visible */
+	val = __insn_tns((int *)&rwlock->lock);
+	if (unlikely(val & 1)) {
+		arch_read_unlock_slow(rwlock);
+		return;
+	}
+	rwlock->lock = val - (1 << _RD_COUNT_SHIFT);
+}
+
+/**
+ * arch_write_unlock() - release a write lock.
+ */
+static inline void arch_write_unlock(arch_rwlock_t *rwlock)
+{
+	u32 val;
+	mb();  /* guarantee anything modified under the lock is visible */
+	val = __insn_tns((int *)&rwlock->lock);
+	if (unlikely(val != (1 << _WR_NEXT_SHIFT))) {
+		arch_write_unlock_slow(rwlock, val);
+		return;
+	}
+	rwlock->lock = 0;
+}
+
+#define arch_read_lock_flags(lock, flags) arch_read_lock(lock)
+#define arch_write_lock_flags(lock, flags) arch_write_lock(lock)
+
+#endif /* _ASM_TILE_SPINLOCK_32_H */
diff --git a/arch/tile/include/asm/spinlock_types.h b/arch/tile/include/asm/spinlock_types.h
new file mode 100644
index 0000000..a71f59b
--- /dev/null
+++ b/arch/tile/include/asm/spinlock_types.h
@@ -0,0 +1,60 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_SPINLOCK_TYPES_H
+#define _ASM_TILE_SPINLOCK_TYPES_H
+
+#ifndef __LINUX_SPINLOCK_TYPES_H
+# error "please don't include this file directly"
+#endif
+
+#ifdef __tilegx__
+
+/* Low 15 bits are "next"; high 15 bits are "current". */
+typedef struct arch_spinlock {
+	unsigned int lock;
+} arch_spinlock_t;
+
+#define __ARCH_SPIN_LOCK_UNLOCKED	{ 0 }
+
+/* High bit is "writer owns"; low 31 bits are a count of readers. */
+typedef struct arch_rwlock {
+	unsigned int lock;
+} arch_rwlock_t;
+
+#define __ARCH_RW_LOCK_UNLOCKED		{ 0 }
+
+#else
+
+typedef struct arch_spinlock {
+	/* Next ticket number to hand out. */
+	int next_ticket;
+	/* The ticket number that currently owns this lock. */
+	int current_ticket;
+} arch_spinlock_t;
+
+#define __ARCH_SPIN_LOCK_UNLOCKED	{ 0, 0 }
+
+/*
+ * Byte 0 for tns (only the low bit is used), byte 1 for ticket-lock "next",
+ * byte 2 for ticket-lock "current", byte 3 for reader count.
+ */
+typedef struct arch_rwlock {
+	unsigned int lock;
+} arch_rwlock_t;
+
+#define __ARCH_RW_LOCK_UNLOCKED		{ 0 }
+
+#endif
+#endif /* _ASM_TILE_SPINLOCK_TYPES_H */
diff --git a/arch/tile/include/asm/stack.h b/arch/tile/include/asm/stack.h
new file mode 100644
index 0000000..864913b
--- /dev/null
+++ b/arch/tile/include/asm/stack.h
@@ -0,0 +1,68 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_STACK_H
+#define _ASM_TILE_STACK_H
+
+#include <linux/types.h>
+#include <linux/sched.h>
+#include <asm/backtrace.h>
+#include <hv/hypervisor.h>
+
+/* Everything we need to keep track of a backtrace iteration */
+struct KBacktraceIterator {
+	BacktraceIterator it;
+	struct task_struct *task;     /* task we are backtracing */
+	HV_PTE *pgtable;	      /* page table for user space access */
+	int end;		      /* iteration complete. */
+	int new_context;              /* new context is starting */
+	int profile;                  /* profiling, so stop on async intrpt */
+	int verbose;		      /* printk extra info (don't want to
+				       * do this for profiling) */
+	int is_current;               /* backtracing current task */
+};
+
+/* Iteration methods for kernel backtraces */
+
+/*
+ * Initialize a KBacktraceIterator from a task_struct, and optionally from
+ * a set of registers.  If the registers are omitted, the process is
+ * assumed to be descheduled, and registers are read from the process's
+ * thread_struct and stack.  "verbose" means to printk some additional
+ * information about fault handlers as we pass them on the stack.
+ */
+extern void KBacktraceIterator_init(struct KBacktraceIterator *kbt,
+				    struct task_struct *, struct pt_regs *);
+
+/* Initialize iterator based on current stack. */
+extern void KBacktraceIterator_init_current(struct KBacktraceIterator *kbt);
+
+/* No more frames? */
+extern int KBacktraceIterator_end(struct KBacktraceIterator *kbt);
+
+/* Advance to the next frame. */
+extern void KBacktraceIterator_next(struct KBacktraceIterator *kbt);
+
+/*
+ * Dump stack given complete register info. Use only from the
+ * architecture-specific code; show_stack()
+ * and dump_stack() (in entry.S) are architecture-independent entry points.
+ */
+extern void tile_show_stack(struct KBacktraceIterator *, int headers);
+
+/* Dump stack of current process, with registers to seed the backtrace. */
+extern void dump_stack_regs(struct pt_regs *);
+
+
+#endif /* _ASM_TILE_STACK_H */
diff --git a/arch/tile/include/asm/stat.h b/arch/tile/include/asm/stat.h
new file mode 100644
index 0000000..3dc90fa
--- /dev/null
+++ b/arch/tile/include/asm/stat.h
@@ -0,0 +1 @@
+#include <asm-generic/stat.h>
diff --git a/arch/tile/include/asm/statfs.h b/arch/tile/include/asm/statfs.h
new file mode 100644
index 0000000..0b91fe1
--- /dev/null
+++ b/arch/tile/include/asm/statfs.h
@@ -0,0 +1 @@
+#include <asm-generic/statfs.h>
diff --git a/arch/tile/include/asm/string.h b/arch/tile/include/asm/string.h
new file mode 100644
index 0000000..7535cf1
--- /dev/null
+++ b/arch/tile/include/asm/string.h
@@ -0,0 +1,32 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_STRING_H
+#define _ASM_TILE_STRING_H
+
+#define __HAVE_ARCH_MEMCHR
+#define __HAVE_ARCH_MEMSET
+#define __HAVE_ARCH_MEMCPY
+#define __HAVE_ARCH_MEMMOVE
+#define __HAVE_ARCH_STRCHR
+#define __HAVE_ARCH_STRLEN
+
+extern __kernel_size_t strlen(const char *);
+extern char *strchr(const char *s, int c);
+extern void *memchr(const void *s, int c, size_t n);
+extern void *memset(void *, int, __kernel_size_t);
+extern void *memcpy(void *, const void *, __kernel_size_t);
+extern void *memmove(void *, const void *, __kernel_size_t);
+
+#endif /* _ASM_TILE_STRING_H */
diff --git a/arch/tile/include/asm/swab.h b/arch/tile/include/asm/swab.h
new file mode 100644
index 0000000..25c686a
--- /dev/null
+++ b/arch/tile/include/asm/swab.h
@@ -0,0 +1,29 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_SWAB_H
+#define _ASM_TILE_SWAB_H
+
+/* Tile gcc is always >= 4.3.0, so we use __builtin_bswap. */
+#define __arch_swab32(x) __builtin_bswap32(x)
+#define __arch_swab64(x) __builtin_bswap64(x)
+
+/* Use the variant that is natural for the wordsize. */
+#ifdef CONFIG_64BIT
+#define __arch_swab16(x) (__builtin_bswap64(x) >> 48)
+#else
+#define __arch_swab16(x) (__builtin_bswap32(x) >> 16)
+#endif
+
+#endif /* _ASM_TILE_SWAB_H */
diff --git a/arch/tile/include/asm/syscall.h b/arch/tile/include/asm/syscall.h
new file mode 100644
index 0000000..d35e0dc
--- /dev/null
+++ b/arch/tile/include/asm/syscall.h
@@ -0,0 +1,79 @@
+/*
+ * Copyright (C) 2008-2009 Red Hat, Inc.  All rights reserved.
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ *
+ * See asm-generic/syscall.h for descriptions of what we must do here.
+ */
+
+#ifndef _ASM_TILE_SYSCALL_H
+#define _ASM_TILE_SYSCALL_H
+
+#include <linux/sched.h>
+#include <linux/err.h>
+#include <arch/abi.h>
+
+/*
+ * Only the low 32 bits of orig_r0 are meaningful, so we return int.
+ * This importantly ignores the high bits on 64-bit, so comparisons
+ * sign-extend the low 32 bits.
+ */
+static inline int syscall_get_nr(struct task_struct *t, struct pt_regs *regs)
+{
+	return regs->regs[TREG_SYSCALL_NR];
+}
+
+static inline void syscall_rollback(struct task_struct *task,
+				    struct pt_regs *regs)
+{
+	regs->regs[0] = regs->orig_r0;
+}
+
+static inline long syscall_get_error(struct task_struct *task,
+				     struct pt_regs *regs)
+{
+	unsigned long error = regs->regs[0];
+	return IS_ERR_VALUE(error) ? error : 0;
+}
+
+static inline long syscall_get_return_value(struct task_struct *task,
+					    struct pt_regs *regs)
+{
+	return regs->regs[0];
+}
+
+static inline void syscall_set_return_value(struct task_struct *task,
+					    struct pt_regs *regs,
+					    int error, long val)
+{
+	regs->regs[0] = (long) error ?: val;
+}
+
+static inline void syscall_get_arguments(struct task_struct *task,
+					 struct pt_regs *regs,
+					 unsigned int i, unsigned int n,
+					 unsigned long *args)
+{
+	BUG_ON(i + n > 6);
+	memcpy(args, &regs[i], n * sizeof(args[0]));
+}
+
+static inline void syscall_set_arguments(struct task_struct *task,
+					 struct pt_regs *regs,
+					 unsigned int i, unsigned int n,
+					 const unsigned long *args)
+{
+	BUG_ON(i + n > 6);
+	memcpy(&regs[i], args, n * sizeof(args[0]));
+}
+
+#endif	/* _ASM_TILE_SYSCALL_H */
diff --git a/arch/tile/include/asm/syscalls.h b/arch/tile/include/asm/syscalls.h
new file mode 100644
index 0000000..e1be54d
--- /dev/null
+++ b/arch/tile/include/asm/syscalls.h
@@ -0,0 +1,60 @@
+/*
+ * syscalls.h - Linux syscall interfaces (arch-specific)
+ *
+ * Copyright (c) 2008 Jaswinder Singh Rajput
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_SYSCALLS_H
+#define _ASM_TILE_SYSCALLS_H
+
+#include <linux/compiler.h>
+#include <linux/linkage.h>
+#include <linux/signal.h>
+#include <linux/types.h>
+
+/* kernel/process.c */
+int sys_fork(struct pt_regs *);
+int sys_vfork(struct pt_regs *);
+int sys_clone(unsigned long clone_flags, unsigned long newsp,
+	      int __user *parent_tidptr, int __user *child_tidptr,
+	      struct pt_regs *);
+int sys_execve(char __user *path, char __user *__user *argv,
+	       char __user *__user *envp, struct pt_regs *);
+
+/* kernel/signal.c */
+int sys_sigaltstack(const stack_t __user *, stack_t __user *,
+		    struct pt_regs *);
+long sys_rt_sigreturn(struct pt_regs *);
+int sys_raise_fpe(int code, unsigned long addr, struct pt_regs*);
+
+/* kernel/sys.c */
+ssize_t sys32_readahead(int fd, u32 offset_lo, u32 offset_hi, u32 count);
+long sys32_fadvise64(int fd, u32 offset_lo, u32 offset_hi,
+		     u32 len, int advice);
+int sys32_fadvise64_64(int fd, u32 offset_lo, u32 offset_hi,
+		       u32 len_lo, u32 len_hi, int advice);
+long sys_flush_cache(void);
+long sys_mmap(unsigned long addr, unsigned long len,
+	      unsigned long prot, unsigned long flags,
+	      unsigned long fd, unsigned long offset);
+long sys_mmap2(unsigned long addr, unsigned long len,
+	       unsigned long prot, unsigned long flags,
+	       unsigned long fd, unsigned long offset);
+
+#ifndef __tilegx__
+/* mm/fault.c */
+int sys_cmpxchg_badaddr(unsigned long address, struct pt_regs *);
+#endif
+
+#endif /* _ASM_TILE_SYSCALLS_H */
diff --git a/arch/tile/include/asm/system.h b/arch/tile/include/asm/system.h
new file mode 100644
index 0000000..d6ca7f8
--- /dev/null
+++ b/arch/tile/include/asm/system.h
@@ -0,0 +1,220 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_SYSTEM_H
+#define _ASM_TILE_SYSTEM_H
+
+#ifndef __ASSEMBLY__
+
+#include <linux/types.h>
+#include <linux/irqflags.h>
+
+/* NOTE: we can't include <linux/ptrace.h> due to #include dependencies. */
+#include <asm/ptrace.h>
+
+#include <arch/chip.h>
+#include <arch/sim_def.h>
+#include <arch/spr_def.h>
+
+/*
+ * read_barrier_depends - Flush all pending reads that subsequents reads
+ * depend on.
+ *
+ * No data-dependent reads from memory-like regions are ever reordered
+ * over this barrier.  All reads preceding this primitive are guaranteed
+ * to access memory (but not necessarily other CPUs' caches) before any
+ * reads following this primitive that depend on the data return by
+ * any of the preceding reads.  This primitive is much lighter weight than
+ * rmb() on most CPUs, and is never heavier weight than is
+ * rmb().
+ *
+ * These ordering constraints are respected by both the local CPU
+ * and the compiler.
+ *
+ * Ordering is not guaranteed by anything other than these primitives,
+ * not even by data dependencies.  See the documentation for
+ * memory_barrier() for examples and URLs to more information.
+ *
+ * For example, the following code would force ordering (the initial
+ * value of "a" is zero, "b" is one, and "p" is "&a"):
+ *
+ * <programlisting>
+ *	CPU 0				CPU 1
+ *
+ *	b = 2;
+ *	memory_barrier();
+ *	p = &b;				q = p;
+ *					read_barrier_depends();
+ *					d = *q;
+ * </programlisting>
+ *
+ * because the read of "*q" depends on the read of "p" and these
+ * two reads are separated by a read_barrier_depends().  However,
+ * the following code, with the same initial values for "a" and "b":
+ *
+ * <programlisting>
+ *	CPU 0				CPU 1
+ *
+ *	a = 2;
+ *	memory_barrier();
+ *	b = 3;				y = b;
+ *					read_barrier_depends();
+ *					x = a;
+ * </programlisting>
+ *
+ * does not enforce ordering, since there is no data dependency between
+ * the read of "a" and the read of "b".  Therefore, on some CPUs, such
+ * as Alpha, "y" could be set to 3 and "x" to 0.  Use rmb()
+ * in cases like this where there are no data dependencies.
+ */
+
+#define read_barrier_depends()	do { } while (0)
+
+#define __sync()	__insn_mf()
+
+#if CHIP_HAS_SPLIT_CYCLE()
+#define get_cycles_low() __insn_mfspr(SPR_CYCLE_LOW)
+#else
+#define get_cycles_low() __insn_mfspr(SPR_CYCLE)   /* just get all 64 bits */
+#endif
+
+/* Fence to guarantee visibility of stores to incoherent memory. */
+static inline void
+mb_incoherent(void)
+{
+	__insn_mf();
+
+#if !CHIP_HAS_MF_WAITS_FOR_VICTIMS()
+	{
+		int __mb_incoherent(void);
+#if CHIP_HAS_TILE_WRITE_PENDING()
+		const unsigned long WRITE_TIMEOUT_CYCLES = 400;
+		unsigned long start = get_cycles_low();
+		do {
+			if (__insn_mfspr(SPR_TILE_WRITE_PENDING) == 0)
+				return;
+		} while ((get_cycles_low() - start) < WRITE_TIMEOUT_CYCLES);
+#endif /* CHIP_HAS_TILE_WRITE_PENDING() */
+		(void) __mb_incoherent();
+	}
+#endif /* CHIP_HAS_MF_WAITS_FOR_VICTIMS() */
+}
+
+#define fast_wmb()	__sync()
+#define fast_rmb()	__sync()
+#define fast_mb()	__sync()
+#define fast_iob()	mb_incoherent()
+
+#define wmb()		fast_wmb()
+#define rmb()		fast_rmb()
+#define mb()		fast_mb()
+#define iob()		fast_iob()
+
+#ifdef CONFIG_SMP
+#define smp_mb()	mb()
+#define smp_rmb()	rmb()
+#define smp_wmb()	wmb()
+#define smp_read_barrier_depends()	read_barrier_depends()
+#else
+#define smp_mb()	barrier()
+#define smp_rmb()	barrier()
+#define smp_wmb()	barrier()
+#define smp_read_barrier_depends()	do { } while (0)
+#endif
+
+#define set_mb(var, value) \
+	do { var = value; mb(); } while (0)
+
+#include <linux/irqflags.h>
+
+/*
+ * Pause the DMA engine and static network before task switching.
+ */
+#define prepare_arch_switch(next) _prepare_arch_switch(next)
+void _prepare_arch_switch(struct task_struct *next);
+
+
+/*
+ * switch_to(n) should switch tasks to task nr n, first
+ * checking that n isn't the current task, in which case it does nothing.
+ * The number of callee-saved registers saved on the kernel stack
+ * is defined here for use in copy_thread() and must agree with __switch_to().
+ */
+#endif /* !__ASSEMBLY__ */
+#define CALLEE_SAVED_FIRST_REG 30
+#define CALLEE_SAVED_REGS_COUNT 24   /* r30 to r52, plus an empty to align */
+#ifndef __ASSEMBLY__
+struct task_struct;
+#define switch_to(prev, next, last) ((last) = _switch_to((prev), (next)))
+extern struct task_struct *_switch_to(struct task_struct *prev,
+				      struct task_struct *next);
+
+/*
+ * On SMP systems, when the scheduler does migration-cost autodetection,
+ * it needs a way to flush as much of the CPU's caches as possible:
+ *
+ * TODO: fill this in!
+ */
+static inline void sched_cacheflush(void)
+{
+}
+
+#define arch_align_stack(x) (x)
+
+/*
+ * Is the kernel doing fixups of unaligned accesses?  If <0, no kernel
+ * intervention occurs and SIGBUS is delivered with no data address
+ * info.  If 0, the kernel single-steps the instruction to discover
+ * the data address to provide with the SIGBUS.  If 1, the kernel does
+ * a fixup.
+ */
+extern int unaligned_fixup;
+
+/* Is the kernel printing on each unaligned fixup? */
+extern int unaligned_printk;
+
+/* Number of unaligned fixups performed */
+extern unsigned int unaligned_fixup_count;
+
+/* User-level DMA management functions */
+void grant_dma_mpls(void);
+void restrict_dma_mpls(void);
+
+
+/* Invoke the simulator "syscall" mechanism (see arch/tile/kernel/entry.S). */
+extern int _sim_syscall(int syscall_num, ...);
+#define sim_syscall(syscall_num, ...) \
+	_sim_syscall(SIM_CONTROL_SYSCALL + \
+		((syscall_num) << _SIM_CONTROL_OPERATOR_BITS), \
+		## __VA_ARGS__)
+
+/*
+ * Kernel threads can check to see if they need to migrate their
+ * stack whenever they return from a context switch; for user
+ * threads, we defer until they are returning to user-space.
+ */
+#define finish_arch_switch(prev) do {                                     \
+	if (unlikely((prev)->state == TASK_DEAD))                         \
+		__insn_mtspr(SPR_SIM_CONTROL, SIM_CONTROL_OS_EXIT |       \
+			((prev)->pid << _SIM_CONTROL_OPERATOR_BITS));     \
+	__insn_mtspr(SPR_SIM_CONTROL, SIM_CONTROL_OS_SWITCH |             \
+		(current->pid << _SIM_CONTROL_OPERATOR_BITS));            \
+	if (current->mm == NULL && !kstack_hash &&                        \
+	    current_thread_info()->homecache_cpu != smp_processor_id())   \
+		homecache_migrate_kthread();                              \
+} while (0)
+
+#endif /* !__ASSEMBLY__ */
+
+#endif /* _ASM_TILE_SYSTEM_H */
diff --git a/arch/tile/include/asm/termbits.h b/arch/tile/include/asm/termbits.h
new file mode 100644
index 0000000..3935b10
--- /dev/null
+++ b/arch/tile/include/asm/termbits.h
@@ -0,0 +1 @@
+#include <asm-generic/termbits.h>
diff --git a/arch/tile/include/asm/termios.h b/arch/tile/include/asm/termios.h
new file mode 100644
index 0000000..280d78a
--- /dev/null
+++ b/arch/tile/include/asm/termios.h
@@ -0,0 +1 @@
+#include <asm-generic/termios.h>
diff --git a/arch/tile/include/asm/thread_info.h b/arch/tile/include/asm/thread_info.h
new file mode 100644
index 0000000..9024bf3
--- /dev/null
+++ b/arch/tile/include/asm/thread_info.h
@@ -0,0 +1,165 @@
+/*
+ * Copyright (C) 2002  David Howells (dhowells@redhat.com)
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_THREAD_INFO_H
+#define _ASM_TILE_THREAD_INFO_H
+
+#include <asm/processor.h>
+#include <asm/page.h>
+#ifndef __ASSEMBLY__
+
+/*
+ * Low level task data that assembly code needs immediate access to.
+ * The structure is placed at the bottom of the supervisor stack.
+ */
+struct thread_info {
+	struct task_struct	*task;		/* main task structure */
+	struct exec_domain	*exec_domain;	/* execution domain */
+	unsigned long		flags;		/* low level flags */
+	unsigned long		status;		/* thread-synchronous flags */
+	__u32			homecache_cpu;	/* CPU we are homecached on */
+	__u32			cpu;		/* current CPU */
+	int			preempt_count;	/* 0 => preemptable,
+						   <0 => BUG */
+
+	mm_segment_t		addr_limit;	/* thread address space
+						   (KERNEL_DS or USER_DS) */
+	struct restart_block	restart_block;
+	struct single_step_state *step_state;	/* single step state
+						   (if non-zero) */
+};
+
+/*
+ * macros/functions for gaining access to the thread information structure.
+ */
+#define INIT_THREAD_INFO(tsk)			\
+{						\
+	.task		= &tsk,			\
+	.exec_domain	= &default_exec_domain,	\
+	.flags		= 0,			\
+	.cpu		= 0,			\
+	.preempt_count	= INIT_PREEMPT_COUNT,	\
+	.addr_limit	= KERNEL_DS,		\
+	.restart_block	= {			\
+		.fn = do_no_restart_syscall,	\
+	},					\
+	.step_state	= 0,			\
+}
+
+#define init_thread_info	(init_thread_union.thread_info)
+#define init_stack		(init_thread_union.stack)
+
+#endif /* !__ASSEMBLY__ */
+
+#if PAGE_SIZE < 8192
+#define THREAD_SIZE_ORDER (13 - PAGE_SHIFT)
+#else
+#define THREAD_SIZE_ORDER (0)
+#endif
+
+#define THREAD_SIZE (PAGE_SIZE << THREAD_SIZE_ORDER)
+#define LOG2_THREAD_SIZE (PAGE_SHIFT + THREAD_SIZE_ORDER)
+
+#define STACK_WARN             (THREAD_SIZE/8)
+
+#ifndef __ASSEMBLY__
+
+/* How to get the thread information struct from C. */
+register unsigned long stack_pointer __asm__("sp");
+
+#define current_thread_info() \
+  ((struct thread_info *)(stack_pointer & -THREAD_SIZE))
+
+#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
+extern struct thread_info *alloc_thread_info(struct task_struct *task);
+extern void free_thread_info(struct thread_info *info);
+
+/* Switch boot idle thread to a freshly-allocated stack and free old stack. */
+extern void cpu_idle_on_new_stack(struct thread_info *old_ti,
+				  unsigned long new_sp,
+				  unsigned long new_ss10);
+
+#else /* __ASSEMBLY__ */
+
+/* how to get the thread information struct from ASM */
+#ifdef __tilegx__
+#define GET_THREAD_INFO(reg) move reg, sp; mm reg, zero, LOG2_THREAD_SIZE, 63
+#else
+#define GET_THREAD_INFO(reg) mm reg, sp, zero, LOG2_THREAD_SIZE, 31
+#endif
+
+#endif /* !__ASSEMBLY__ */
+
+#define PREEMPT_ACTIVE		0x10000000
+
+/*
+ * Thread information flags that various assembly files may need to access.
+ * Keep flags accessed frequently in low bits, particular since it makes
+ * it easier to build constants in assembly.
+ */
+#define TIF_SIGPENDING		0	/* signal pending */
+#define TIF_NEED_RESCHED	1	/* rescheduling necessary */
+#define TIF_SINGLESTEP		2	/* restore singlestep on return to
+					   user mode */
+#define TIF_ASYNC_TLB		3	/* got an async TLB fault in kernel */
+#define TIF_SYSCALL_TRACE	4	/* syscall trace active */
+#define TIF_SYSCALL_AUDIT	5	/* syscall auditing active */
+#define TIF_SECCOMP		6	/* secure computing */
+#define TIF_MEMDIE		7	/* OOM killer at work */
+
+#define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
+#define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
+#define _TIF_SINGLESTEP		(1<<TIF_SINGLESTEP)
+#define _TIF_ASYNC_TLB		(1<<TIF_ASYNC_TLB)
+#define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
+#define _TIF_SYSCALL_AUDIT	(1<<TIF_SYSCALL_AUDIT)
+#define _TIF_SECCOMP		(1<<TIF_SECCOMP)
+#define _TIF_MEMDIE		(1<<TIF_MEMDIE)
+
+/* Work to do on any return to user space. */
+#define _TIF_ALLWORK_MASK \
+  (_TIF_SIGPENDING|_TIF_NEED_RESCHED|_TIF_SINGLESTEP|_TIF_ASYNC_TLB)
+
+/*
+ * Thread-synchronous status.
+ *
+ * This is different from the flags in that nobody else
+ * ever touches our thread-synchronous status, so we don't
+ * have to worry about atomic accesses.
+ */
+#ifdef __tilegx__
+#define TS_COMPAT		0x0001	/* 32-bit compatibility mode */
+#endif
+#define TS_POLLING		0x0004	/* in idle loop but not sleeping */
+#define TS_RESTORE_SIGMASK	0x0008	/* restore signal mask in do_signal */
+#define TS_EXEC_HASH_SET	0x0010	/* apply TS_EXEC_HASH_xxx flags */
+#define TS_EXEC_HASH_RO		0x0020	/* during exec, hash r/o segments */
+#define TS_EXEC_HASH_RW		0x0040	/* during exec, hash r/w segments */
+#define TS_EXEC_HASH_STACK	0x0080	/* during exec, hash the stack */
+#define TS_EXEC_HASH_FLAGS	0x00f0	/* mask for TS_EXEC_HASH_xxx flags */
+
+#define tsk_is_polling(t) (task_thread_info(t)->status & TS_POLLING)
+
+#ifndef __ASSEMBLY__
+#define HAVE_SET_RESTORE_SIGMASK	1
+static inline void set_restore_sigmask(void)
+{
+	struct thread_info *ti = current_thread_info();
+	ti->status |= TS_RESTORE_SIGMASK;
+	set_bit(TIF_SIGPENDING, &ti->flags);
+}
+#endif	/* !__ASSEMBLY__ */
+
+#endif /* _ASM_TILE_THREAD_INFO_H */
diff --git a/arch/tile/include/asm/timex.h b/arch/tile/include/asm/timex.h
new file mode 100644
index 0000000..3baf5fc
--- /dev/null
+++ b/arch/tile/include/asm/timex.h
@@ -0,0 +1,47 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_TIMEX_H
+#define _ASM_TILE_TIMEX_H
+
+/*
+ * This rate should be a multiple of the possible HZ values (100, 250, 1000)
+ * and a fraction of the possible hardware timer frequencies.  Our timer
+ * frequency is highly tunable but also quite precise, so for the primary use
+ * of this value (setting ACT_HZ from HZ) we just pick a value that causes
+ * ACT_HZ to be set to HZ.  We make the value somewhat large just to be
+ * more robust in case someone tries out a new value of HZ.
+ */
+#define CLOCK_TICK_RATE	1000000
+
+typedef unsigned long long cycles_t;
+
+#if CHIP_HAS_SPLIT_CYCLE()
+cycles_t get_cycles(void);
+#else
+static inline cycles_t get_cycles(void)
+{
+	return __insn_mfspr(SPR_CYCLE);
+}
+#endif
+
+cycles_t get_clock_rate(void);
+
+/* Called at cpu initialization to set some low-level constants. */
+void setup_clock(void);
+
+/* Called at cpu initialization to start the tile-timer clock device. */
+void setup_tile_timer(void);
+
+#endif /* _ASM_TILE_TIMEX_H */
diff --git a/arch/tile/include/asm/tlb.h b/arch/tile/include/asm/tlb.h
new file mode 100644
index 0000000..4a891a1
--- /dev/null
+++ b/arch/tile/include/asm/tlb.h
@@ -0,0 +1,25 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_TLB_H
+#define _ASM_TILE_TLB_H
+
+#define tlb_start_vma(tlb, vma) do { } while (0)
+#define tlb_end_vma(tlb, vma) do { } while (0)
+#define __tlb_remove_tlb_entry(tlb, ptep, address) do { } while (0)
+#define tlb_flush(tlb) flush_tlb_mm((tlb)->mm)
+
+#include <asm-generic/tlb.h>
+
+#endif /* _ASM_TILE_TLB_H */
diff --git a/arch/tile/include/asm/tlbflush.h b/arch/tile/include/asm/tlbflush.h
new file mode 100644
index 0000000..96199d2
--- /dev/null
+++ b/arch/tile/include/asm/tlbflush.h
@@ -0,0 +1,128 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_TLBFLUSH_H
+#define _ASM_TILE_TLBFLUSH_H
+
+#include <linux/mm.h>
+#include <linux/sched.h>
+#include <linux/smp.h>
+#include <asm/cacheflush.h>
+#include <asm/page.h>
+#include <hv/hypervisor.h>
+
+/*
+ * Rather than associating each mm with its own ASID, we just use
+ * ASIDs to allow us to lazily flush the TLB when we switch mms.
+ * This way we only have to do an actual TLB flush on mm switch
+ * every time we wrap ASIDs, not every single time we switch.
+ *
+ * FIXME: We might improve performance by keeping ASIDs around
+ * properly, though since the hypervisor direct-maps VAs to TSB
+ * entries, we're likely to have lost at least the executable page
+ * mappings by the time we switch back to the original mm.
+ */
+DECLARE_PER_CPU(int, current_asid);
+
+/* The hypervisor tells us what ASIDs are available to us. */
+extern int min_asid, max_asid;
+
+static inline unsigned long hv_page_size(const struct vm_area_struct *vma)
+{
+	return (vma->vm_flags & VM_HUGETLB) ? HPAGE_SIZE : PAGE_SIZE;
+}
+
+/* Pass as vma pointer for non-executable mapping, if no vma available. */
+#define FLUSH_NONEXEC ((const struct vm_area_struct *)-1UL)
+
+/* Flush a single user page on this cpu. */
+static inline void local_flush_tlb_page(const struct vm_area_struct *vma,
+					unsigned long addr,
+					unsigned long page_size)
+{
+	int rc = hv_flush_page(addr, page_size);
+	if (rc < 0)
+		panic("hv_flush_page(%#lx,%#lx) failed: %d",
+		      addr, page_size, rc);
+	if (!vma || (vma != FLUSH_NONEXEC && (vma->vm_flags & VM_EXEC)))
+		__flush_icache();
+}
+
+/* Flush range of user pages on this cpu. */
+static inline void local_flush_tlb_pages(const struct vm_area_struct *vma,
+					 unsigned long addr,
+					 unsigned long page_size,
+					 unsigned long len)
+{
+	int rc = hv_flush_pages(addr, page_size, len);
+	if (rc < 0)
+		panic("hv_flush_pages(%#lx,%#lx,%#lx) failed: %d",
+		      addr, page_size, len, rc);
+	if (!vma || (vma != FLUSH_NONEXEC && (vma->vm_flags & VM_EXEC)))
+		__flush_icache();
+}
+
+/* Flush all user pages on this cpu. */
+static inline void local_flush_tlb(void)
+{
+	int rc = hv_flush_all(1);   /* preserve global mappings */
+	if (rc < 0)
+		panic("hv_flush_all(1) failed: %d", rc);
+	__flush_icache();
+}
+
+/*
+ * Global pages have to be flushed a bit differently. Not a real
+ * performance problem because this does not happen often.
+ */
+static inline void local_flush_tlb_all(void)
+{
+	int i;
+	for (i = 0; ; ++i) {
+		HV_VirtAddrRange r = hv_inquire_virtual(i);
+		if (r.size == 0)
+			break;
+		local_flush_tlb_pages(NULL, r.start, PAGE_SIZE, r.size);
+		local_flush_tlb_pages(NULL, r.start, HPAGE_SIZE, r.size);
+	}
+}
+
+/*
+ * TLB flushing:
+ *
+ *  - flush_tlb() flushes the current mm struct TLBs
+ *  - flush_tlb_all() flushes all processes TLBs
+ *  - flush_tlb_mm(mm) flushes the specified mm context TLB's
+ *  - flush_tlb_page(vma, vmaddr) flushes one page
+ *  - flush_tlb_range(vma, start, end) flushes a range of pages
+ *  - flush_tlb_kernel_range(start, end) flushes a range of kernel pages
+ *  - flush_tlb_others(cpumask, mm, va) flushes TLBs on other cpus
+ *
+ * Here (as in vm_area_struct), "end" means the first byte after
+ * our end address.
+ */
+
+extern void flush_tlb_all(void);
+extern void flush_tlb_kernel_range(unsigned long start, unsigned long end);
+extern void flush_tlb_current_task(void);
+extern void flush_tlb_mm(struct mm_struct *);
+extern void flush_tlb_page(const struct vm_area_struct *, unsigned long);
+extern void flush_tlb_page_mm(const struct vm_area_struct *,
+			      struct mm_struct *, unsigned long);
+extern void flush_tlb_range(const struct vm_area_struct *,
+			    unsigned long start, unsigned long end);
+
+#define flush_tlb()     flush_tlb_current_task()
+
+#endif /* _ASM_TILE_TLBFLUSH_H */
diff --git a/arch/tile/include/asm/topology.h b/arch/tile/include/asm/topology.h
new file mode 100644
index 0000000..343172d
--- /dev/null
+++ b/arch/tile/include/asm/topology.h
@@ -0,0 +1,85 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_TOPOLOGY_H
+#define _ASM_TILE_TOPOLOGY_H
+
+#ifdef CONFIG_NUMA
+
+#include <linux/cpumask.h>
+
+/* Mappings between logical cpu number and node number. */
+extern struct cpumask node_2_cpu_mask[];
+extern char cpu_2_node[];
+
+/* Returns the number of the node containing CPU 'cpu'. */
+static inline int cpu_to_node(int cpu)
+{
+	return cpu_2_node[cpu];
+}
+
+/*
+ * Returns the number of the node containing Node 'node'.
+ * This architecture is flat, so it is a pretty simple function!
+ */
+#define parent_node(node) (node)
+
+/* Returns a bitmask of CPUs on Node 'node'. */
+static inline const struct cpumask *cpumask_of_node(int node)
+{
+	return &node_2_cpu_mask[node];
+}
+
+/* For now, use numa node -1 for global allocation. */
+#define pcibus_to_node(bus)		((void)(bus), -1)
+
+/* sched_domains SD_NODE_INIT for TILE architecture */
+#define SD_NODE_INIT (struct sched_domain) {		\
+	.min_interval		= 8,			\
+	.max_interval		= 32,			\
+	.busy_factor		= 32,			\
+	.imbalance_pct		= 125,			\
+	.cache_nice_tries	= 1,			\
+	.busy_idx		= 3,			\
+	.idle_idx		= 1,			\
+	.newidle_idx		= 2,			\
+	.wake_idx		= 1,			\
+	.flags			= SD_LOAD_BALANCE	\
+				| SD_BALANCE_NEWIDLE	\
+				| SD_BALANCE_EXEC	\
+				| SD_BALANCE_FORK	\
+				| SD_WAKE_AFFINE	\
+				| SD_SERIALIZE,		\
+	.last_balance		= jiffies,		\
+	.balance_interval	= 1,			\
+}
+
+/* By definition, we create nodes based on online memory. */
+#define node_has_online_mem(nid) 1
+
+#endif /* CONFIG_NUMA */
+
+#include <asm-generic/topology.h>
+
+#ifdef CONFIG_SMP
+#define topology_physical_package_id(cpu)       ((void)(cpu), 0)
+#define topology_core_id(cpu)                   (cpu)
+#define topology_core_cpumask(cpu)              ((void)(cpu), cpu_online_mask)
+#define topology_thread_cpumask(cpu)            cpumask_of(cpu)
+
+/* indicates that pointers to the topology struct cpumask maps are valid */
+#define arch_provides_topology_pointers         yes
+#endif
+
+#endif /* _ASM_TILE_TOPOLOGY_H */
diff --git a/arch/tile/include/asm/traps.h b/arch/tile/include/asm/traps.h
new file mode 100644
index 0000000..eab33d4
--- /dev/null
+++ b/arch/tile/include/asm/traps.h
@@ -0,0 +1,36 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_TRAPS_H
+#define _ASM_TILE_TRAPS_H
+
+/* mm/fault.c */
+void do_page_fault(struct pt_regs *, int fault_num,
+		   unsigned long address, unsigned long write);
+
+/* kernel/traps.c */
+void do_trap(struct pt_regs *, int fault_num, unsigned long reason);
+
+/* kernel/time.c */
+void do_timer_interrupt(struct pt_regs *, int fault_num);
+
+/* kernel/messaging.c */
+void hv_message_intr(struct pt_regs *, int intnum);
+
+/* kernel/irq.c */
+void tile_dev_intr(struct pt_regs *, int intnum);
+
+
+
+#endif /* _ASM_TILE_SYSCALLS_H */
diff --git a/arch/tile/include/asm/types.h b/arch/tile/include/asm/types.h
new file mode 100644
index 0000000..b9e79bc
--- /dev/null
+++ b/arch/tile/include/asm/types.h
@@ -0,0 +1 @@
+#include <asm-generic/types.h>
diff --git a/arch/tile/include/asm/uaccess.h b/arch/tile/include/asm/uaccess.h
new file mode 100644
index 0000000..f3058af
--- /dev/null
+++ b/arch/tile/include/asm/uaccess.h
@@ -0,0 +1,578 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_UACCESS_H
+#define _ASM_TILE_UACCESS_H
+
+/*
+ * User space memory access functions
+ */
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <asm-generic/uaccess-unaligned.h>
+#include <asm/processor.h>
+#include <asm/page.h>
+
+#define VERIFY_READ	0
+#define VERIFY_WRITE	1
+
+/*
+ * The fs value determines whether argument validity checking should be
+ * performed or not.  If get_fs() == USER_DS, checking is performed, with
+ * get_fs() == KERNEL_DS, checking is bypassed.
+ *
+ * For historical reasons, these macros are grossly misnamed.
+ */
+#define MAKE_MM_SEG(a)  ((mm_segment_t) { (a) })
+
+#define KERNEL_DS	MAKE_MM_SEG(-1UL)
+#define USER_DS		MAKE_MM_SEG(PAGE_OFFSET)
+
+#define get_ds()	(KERNEL_DS)
+#define get_fs()	(current_thread_info()->addr_limit)
+#define set_fs(x)	(current_thread_info()->addr_limit = (x))
+
+#define segment_eq(a, b) ((a).seg == (b).seg)
+
+#ifndef __tilegx__
+/*
+ * We could allow mapping all 16 MB at 0xfc000000, but we set up a
+ * special hack in arch_setup_additional_pages() to auto-create a mapping
+ * for the first 16 KB, and it would seem strange to have different
+ * user-accessible semantics for memory at 0xfc000000 and above 0xfc004000.
+ */
+static inline int is_arch_mappable_range(unsigned long addr,
+					 unsigned long size)
+{
+	return (addr >= MEM_USER_INTRPT &&
+		addr < (MEM_USER_INTRPT + INTRPT_SIZE) &&
+		size <= (MEM_USER_INTRPT + INTRPT_SIZE) - addr);
+}
+#define is_arch_mappable_range is_arch_mappable_range
+#else
+#define is_arch_mappable_range(addr, size) 0
+#endif
+
+/*
+ * Test whether a block of memory is a valid user space address.
+ * Returns 0 if the range is valid, nonzero otherwise.
+ */
+int __range_ok(unsigned long addr, unsigned long size);
+
+/**
+ * access_ok: - Checks if a user space pointer is valid
+ * @type: Type of access: %VERIFY_READ or %VERIFY_WRITE.  Note that
+ *        %VERIFY_WRITE is a superset of %VERIFY_READ - if it is safe
+ *        to write to a block, it is always safe to read from it.
+ * @addr: User space pointer to start of block to check
+ * @size: Size of block to check
+ *
+ * Context: User context only.  This function may sleep.
+ *
+ * Checks if a pointer to a block of memory in user space is valid.
+ *
+ * Returns true (nonzero) if the memory block may be valid, false (zero)
+ * if it is definitely invalid.
+ *
+ * Note that, depending on architecture, this function probably just
+ * checks that the pointer is in the user space range - after calling
+ * this function, memory access functions may still return -EFAULT.
+ */
+#define access_ok(type, addr, size) \
+	(likely(__range_ok((unsigned long)addr, size) == 0))
+
+/*
+ * The exception table consists of pairs of addresses: the first is the
+ * address of an instruction that is allowed to fault, and the second is
+ * the address at which the program should continue.  No registers are
+ * modified, so it is entirely up to the continuation code to figure out
+ * what to do.
+ *
+ * All the routines below use bits of fixup code that are out of line
+ * with the main instruction path.  This means when everything is well,
+ * we don't even have to jump over them.  Further, they do not intrude
+ * on our cache or tlb entries.
+ */
+
+struct exception_table_entry {
+	unsigned long insn, fixup;
+};
+
+extern int fixup_exception(struct pt_regs *regs);
+
+/*
+ * We return the __get_user_N function results in a structure,
+ * thus in r0 and r1.  If "err" is zero, "val" is the result
+ * of the read; otherwise, "err" is -EFAULT.
+ *
+ * We rarely need 8-byte values on a 32-bit architecture, but
+ * we size the structure to accommodate.  In practice, for the
+ * the smaller reads, we can zero the high word for free, and
+ * the caller will ignore it by virtue of casting anyway.
+ */
+struct __get_user {
+	unsigned long long val;
+	int err;
+};
+
+/*
+ * FIXME: we should express these as inline extended assembler, since
+ * they're fundamentally just a variable dereference and some
+ * supporting exception_table gunk.  Note that (a la i386) we can
+ * extend the copy_to_user and copy_from_user routines to call into
+ * such extended assembler routines, though we will have to use a
+ * different return code in that case (1, 2, or 4, rather than -EFAULT).
+ */
+extern struct __get_user __get_user_1(const void *);
+extern struct __get_user __get_user_2(const void *);
+extern struct __get_user __get_user_4(const void *);
+extern struct __get_user __get_user_8(const void *);
+extern int __put_user_1(long, void *);
+extern int __put_user_2(long, void *);
+extern int __put_user_4(long, void *);
+extern int __put_user_8(long long, void *);
+
+/* Unimplemented routines to cause linker failures */
+extern struct __get_user __get_user_bad(void);
+extern int __put_user_bad(void);
+
+/*
+ * Careful: we have to cast the result to the type of the pointer
+ * for sign reasons.
+ */
+/**
+ * __get_user: - Get a simple variable from user space, with less checking.
+ * @x:   Variable to store result.
+ * @ptr: Source address, in user space.
+ *
+ * Context: User context only.  This function may sleep.
+ *
+ * This macro copies a single simple variable from user space to kernel
+ * space.  It supports simple types like char and int, but not larger
+ * data types like structures or arrays.
+ *
+ * @ptr must have pointer-to-simple-variable type, and the result of
+ * dereferencing @ptr must be assignable to @x without a cast.
+ *
+ * Returns zero on success, or -EFAULT on error.
+ * On error, the variable @x is set to zero.
+ *
+ * Caller must check the pointer with access_ok() before calling this
+ * function.
+ */
+#define __get_user(x, ptr)						\
+({	struct __get_user __ret;					\
+	__typeof__(*(ptr)) const __user *__gu_addr = (ptr);		\
+	__chk_user_ptr(__gu_addr);					\
+	switch (sizeof(*(__gu_addr))) {					\
+	case 1:								\
+		__ret = __get_user_1(__gu_addr);			\
+		break;							\
+	case 2:								\
+		__ret = __get_user_2(__gu_addr);			\
+		break;							\
+	case 4:								\
+		__ret = __get_user_4(__gu_addr);			\
+		break;							\
+	case 8:								\
+		__ret = __get_user_8(__gu_addr);			\
+		break;							\
+	default:							\
+		__ret = __get_user_bad();				\
+		break;							\
+	}								\
+	(x) = (__typeof__(*__gu_addr)) (__typeof__(*__gu_addr - *__gu_addr)) \
+	  __ret.val;			                                \
+	__ret.err;							\
+})
+
+/**
+ * __put_user: - Write a simple value into user space, with less checking.
+ * @x:   Value to copy to user space.
+ * @ptr: Destination address, in user space.
+ *
+ * Context: User context only.  This function may sleep.
+ *
+ * This macro copies a single simple value from kernel space to user
+ * space.  It supports simple types like char and int, but not larger
+ * data types like structures or arrays.
+ *
+ * @ptr must have pointer-to-simple-variable type, and @x must be assignable
+ * to the result of dereferencing @ptr.
+ *
+ * Caller must check the pointer with access_ok() before calling this
+ * function.
+ *
+ * Returns zero on success, or -EFAULT on error.
+ *
+ * Implementation note: The "case 8" logic of casting to the type of
+ * the result of subtracting the value from itself is basically a way
+ * of keeping all integer types the same, but casting any pointers to
+ * ptrdiff_t, i.e. also an integer type.  This way there are no
+ * questionable casts seen by the compiler on an ILP32 platform.
+ */
+#define __put_user(x, ptr)						\
+({									\
+	int __pu_err = 0;						\
+	__typeof__(*(ptr)) __user *__pu_addr = (ptr);			\
+	typeof(*__pu_addr) __pu_val = (x);				\
+	__chk_user_ptr(__pu_addr);					\
+	switch (sizeof(__pu_val)) {					\
+	case 1:								\
+		__pu_err = __put_user_1((long)__pu_val, __pu_addr);	\
+		break;							\
+	case 2:								\
+		__pu_err = __put_user_2((long)__pu_val, __pu_addr);	\
+		break;							\
+	case 4:								\
+		__pu_err = __put_user_4((long)__pu_val, __pu_addr);	\
+		break;							\
+	case 8:								\
+		__pu_err =						\
+		  __put_user_8((__typeof__(__pu_val - __pu_val))__pu_val,\
+			__pu_addr);					\
+		break;							\
+	default:							\
+		__pu_err = __put_user_bad();				\
+		break;							\
+	}								\
+	__pu_err;							\
+})
+
+/*
+ * The versions of get_user and put_user without initial underscores
+ * check the address of their arguments to make sure they are not
+ * in kernel space.
+ */
+#define put_user(x, ptr)						\
+({									\
+	__typeof__(*(ptr)) __user *__Pu_addr = (ptr);			\
+	access_ok(VERIFY_WRITE, (__Pu_addr), sizeof(*(__Pu_addr))) ?	\
+		__put_user((x), (__Pu_addr)) :				\
+		-EFAULT;						\
+})
+
+#define get_user(x, ptr)						\
+({									\
+	__typeof__(*(ptr)) const __user *__Gu_addr = (ptr);		\
+	access_ok(VERIFY_READ, (__Gu_addr), sizeof(*(__Gu_addr))) ?	\
+		__get_user((x), (__Gu_addr)) :				\
+		((x) = 0, -EFAULT);					\
+})
+
+/**
+ * __copy_to_user() - copy data into user space, with less checking.
+ * @to:   Destination address, in user space.
+ * @from: Source address, in kernel space.
+ * @n:    Number of bytes to copy.
+ *
+ * Context: User context only.  This function may sleep.
+ *
+ * Copy data from kernel space to user space.  Caller must check
+ * the specified block with access_ok() before calling this function.
+ *
+ * Returns number of bytes that could not be copied.
+ * On success, this will be zero.
+ *
+ * An alternate version - __copy_to_user_inatomic() - is designed
+ * to be called from atomic context, typically bracketed by calls
+ * to pagefault_disable() and pagefault_enable().
+ */
+extern unsigned long __must_check __copy_to_user_inatomic(
+	void __user *to, const void *from, unsigned long n);
+
+static inline unsigned long __must_check
+__copy_to_user(void __user *to, const void *from, unsigned long n)
+{
+	might_fault();
+	return __copy_to_user_inatomic(to, from, n);
+}
+
+static inline unsigned long __must_check
+copy_to_user(void __user *to, const void *from, unsigned long n)
+{
+	if (access_ok(VERIFY_WRITE, to, n))
+		n = __copy_to_user(to, from, n);
+	return n;
+}
+
+/**
+ * __copy_from_user() - copy data from user space, with less checking.
+ * @to:   Destination address, in kernel space.
+ * @from: Source address, in user space.
+ * @n:    Number of bytes to copy.
+ *
+ * Context: User context only.  This function may sleep.
+ *
+ * Copy data from user space to kernel space.  Caller must check
+ * the specified block with access_ok() before calling this function.
+ *
+ * Returns number of bytes that could not be copied.
+ * On success, this will be zero.
+ *
+ * If some data could not be copied, this function will pad the copied
+ * data to the requested size using zero bytes.
+ *
+ * An alternate version - __copy_from_user_inatomic() - is designed
+ * to be called from atomic context, typically bracketed by calls
+ * to pagefault_disable() and pagefault_enable().  This version
+ * does *NOT* pad with zeros.
+ */
+extern unsigned long __must_check __copy_from_user_inatomic(
+	void *to, const void __user *from, unsigned long n);
+extern unsigned long __must_check __copy_from_user_zeroing(
+	void *to, const void __user *from, unsigned long n);
+
+static inline unsigned long __must_check
+__copy_from_user(void *to, const void __user *from, unsigned long n)
+{
+       might_fault();
+       return __copy_from_user_zeroing(to, from, n);
+}
+
+static inline unsigned long __must_check
+_copy_from_user(void *to, const void __user *from, unsigned long n)
+{
+	if (access_ok(VERIFY_READ, from, n))
+		n = __copy_from_user(to, from, n);
+	else
+		memset(to, 0, n);
+	return n;
+}
+
+#ifdef CONFIG_DEBUG_COPY_FROM_USER
+extern void copy_from_user_overflow(void)
+	__compiletime_warning("copy_from_user() size is not provably correct");
+
+static inline unsigned long __must_check copy_from_user(void *to,
+					  const void __user *from,
+					  unsigned long n)
+{
+	int sz = __compiletime_object_size(to);
+
+	if (likely(sz == -1 || sz >= n))
+		n = _copy_from_user(to, from, n);
+	else
+		copy_from_user_overflow();
+
+	return n;
+}
+#else
+#define copy_from_user _copy_from_user
+#endif
+
+#ifdef __tilegx__
+/**
+ * __copy_in_user() - copy data within user space, with less checking.
+ * @to:   Destination address, in user space.
+ * @from: Source address, in kernel space.
+ * @n:    Number of bytes to copy.
+ *
+ * Context: User context only.  This function may sleep.
+ *
+ * Copy data from user space to user space.  Caller must check
+ * the specified blocks with access_ok() before calling this function.
+ *
+ * Returns number of bytes that could not be copied.
+ * On success, this will be zero.
+ */
+extern unsigned long __copy_in_user_asm(
+	void __user *to, const void __user *from, unsigned long n);
+
+static inline unsigned long __must_check
+__copy_in_user(void __user *to, const void __user *from, unsigned long n)
+{
+	might_sleep();
+	return __copy_in_user_asm(to, from, n);
+}
+
+static inline unsigned long __must_check
+copy_in_user(void __user *to, const void __user *from, unsigned long n)
+{
+	if (access_ok(VERIFY_WRITE, to, n) && access_ok(VERIFY_READ, from, n))
+		n = __copy_in_user(to, from, n);
+	return n;
+}
+#endif
+
+
+/**
+ * strlen_user: - Get the size of a string in user space.
+ * @str: The string to measure.
+ *
+ * Context: User context only.  This function may sleep.
+ *
+ * Get the size of a NUL-terminated string in user space.
+ *
+ * Returns the size of the string INCLUDING the terminating NUL.
+ * On exception, returns 0.
+ *
+ * If there is a limit on the length of a valid string, you may wish to
+ * consider using strnlen_user() instead.
+ */
+extern long strnlen_user_asm(const char __user *str, long n);
+static inline long __must_check strnlen_user(const char __user *str, long n)
+{
+	might_fault();
+	return strnlen_user_asm(str, n);
+}
+#define strlen_user(str) strnlen_user(str, LONG_MAX)
+
+/**
+ * strncpy_from_user: - Copy a NUL terminated string from userspace, with less checking.
+ * @dst:   Destination address, in kernel space.  This buffer must be at
+ *         least @count bytes long.
+ * @src:   Source address, in user space.
+ * @count: Maximum number of bytes to copy, including the trailing NUL.
+ *
+ * Copies a NUL-terminated string from userspace to kernel space.
+ * Caller must check the specified block with access_ok() before calling
+ * this function.
+ *
+ * On success, returns the length of the string (not including the trailing
+ * NUL).
+ *
+ * If access to userspace fails, returns -EFAULT (some data may have been
+ * copied).
+ *
+ * If @count is smaller than the length of the string, copies @count bytes
+ * and returns @count.
+ */
+extern long strncpy_from_user_asm(char *dst, const char __user *src, long);
+static inline long __must_check __strncpy_from_user(
+	char *dst, const char __user *src, long count)
+{
+	might_fault();
+	return strncpy_from_user_asm(dst, src, count);
+}
+static inline long __must_check strncpy_from_user(
+	char *dst, const char __user *src, long count)
+{
+	if (access_ok(VERIFY_READ, src, 1))
+		return __strncpy_from_user(dst, src, count);
+	return -EFAULT;
+}
+
+/**
+ * clear_user: - Zero a block of memory in user space.
+ * @mem:   Destination address, in user space.
+ * @len:   Number of bytes to zero.
+ *
+ * Zero a block of memory in user space.
+ *
+ * Returns number of bytes that could not be cleared.
+ * On success, this will be zero.
+ */
+extern unsigned long clear_user_asm(void __user *mem, unsigned long len);
+static inline unsigned long __must_check __clear_user(
+	void __user *mem, unsigned long len)
+{
+	might_fault();
+	return clear_user_asm(mem, len);
+}
+static inline unsigned long __must_check clear_user(
+	void __user *mem, unsigned long len)
+{
+	if (access_ok(VERIFY_WRITE, mem, len))
+		return __clear_user(mem, len);
+	return len;
+}
+
+/**
+ * flush_user: - Flush a block of memory in user space from cache.
+ * @mem:   Destination address, in user space.
+ * @len:   Number of bytes to flush.
+ *
+ * Returns number of bytes that could not be flushed.
+ * On success, this will be zero.
+ */
+extern unsigned long flush_user_asm(void __user *mem, unsigned long len);
+static inline unsigned long __must_check __flush_user(
+	void __user *mem, unsigned long len)
+{
+	int retval;
+
+	might_fault();
+	retval = flush_user_asm(mem, len);
+	mb_incoherent();
+	return retval;
+}
+
+static inline unsigned long __must_check flush_user(
+	void __user *mem, unsigned long len)
+{
+	if (access_ok(VERIFY_WRITE, mem, len))
+		return __flush_user(mem, len);
+	return len;
+}
+
+/**
+ * inv_user: - Invalidate a block of memory in user space from cache.
+ * @mem:   Destination address, in user space.
+ * @len:   Number of bytes to invalidate.
+ *
+ * Returns number of bytes that could not be invalidated.
+ * On success, this will be zero.
+ *
+ * Note that on Tile64, the "inv" operation is in fact a
+ * "flush and invalidate", so cache write-backs will occur prior
+ * to the cache being marked invalid.
+ */
+extern unsigned long inv_user_asm(void __user *mem, unsigned long len);
+static inline unsigned long __must_check __inv_user(
+	void __user *mem, unsigned long len)
+{
+	int retval;
+
+	might_fault();
+	retval = inv_user_asm(mem, len);
+	mb_incoherent();
+	return retval;
+}
+static inline unsigned long __must_check inv_user(
+	void __user *mem, unsigned long len)
+{
+	if (access_ok(VERIFY_WRITE, mem, len))
+		return __inv_user(mem, len);
+	return len;
+}
+
+/**
+ * finv_user: - Flush-inval a block of memory in user space from cache.
+ * @mem:   Destination address, in user space.
+ * @len:   Number of bytes to invalidate.
+ *
+ * Returns number of bytes that could not be flush-invalidated.
+ * On success, this will be zero.
+ */
+extern unsigned long finv_user_asm(void __user *mem, unsigned long len);
+static inline unsigned long __must_check __finv_user(
+	void __user *mem, unsigned long len)
+{
+	int retval;
+
+	might_fault();
+	retval = finv_user_asm(mem, len);
+	mb_incoherent();
+	return retval;
+}
+static inline unsigned long __must_check finv_user(
+	void __user *mem, unsigned long len)
+{
+	if (access_ok(VERIFY_WRITE, mem, len))
+		return __finv_user(mem, len);
+	return len;
+}
+
+#endif /* _ASM_TILE_UACCESS_H */
diff --git a/arch/tile/include/asm/ucontext.h b/arch/tile/include/asm/ucontext.h
new file mode 100644
index 0000000..9bc07b9
--- /dev/null
+++ b/arch/tile/include/asm/ucontext.h
@@ -0,0 +1 @@
+#include <asm-generic/ucontext.h>
diff --git a/arch/tile/include/asm/unaligned.h b/arch/tile/include/asm/unaligned.h
new file mode 100644
index 0000000..137e2de
--- /dev/null
+++ b/arch/tile/include/asm/unaligned.h
@@ -0,0 +1,24 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_UNALIGNED_H
+#define _ASM_TILE_UNALIGNED_H
+
+#include <linux/unaligned/le_struct.h>
+#include <linux/unaligned/be_byteshift.h>
+#include <linux/unaligned/generic.h>
+#define get_unaligned	__get_unaligned_le
+#define put_unaligned	__put_unaligned_le
+
+#endif /* _ASM_TILE_UNALIGNED_H */
diff --git a/arch/tile/include/asm/unistd.h b/arch/tile/include/asm/unistd.h
new file mode 100644
index 0000000..03b3d5d
--- /dev/null
+++ b/arch/tile/include/asm/unistd.h
@@ -0,0 +1,47 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#if !defined(_ASM_TILE_UNISTD_H) || defined(__SYSCALL)
+#define _ASM_TILE_UNISTD_H
+
+
+#ifndef __LP64__
+/* Use the flavor of this syscall that matches the 32-bit API better. */
+#define __ARCH_WANT_SYNC_FILE_RANGE2
+#endif
+
+/* Use the standard ABI for syscalls. */
+#include <asm-generic/unistd.h>
+
+#ifndef __tilegx__
+/* "Fast" syscalls provide atomic support for 32-bit chips. */
+#define __NR_FAST_cmpxchg	-1
+#define __NR_FAST_atomic_update	-2
+#define __NR_FAST_cmpxchg64	-3
+#define __NR_cmpxchg_badaddr	(__NR_arch_specific_syscall + 0)
+__SYSCALL(__NR_cmpxchg_badaddr, sys_cmpxchg_badaddr)
+#endif
+
+/* Additional Tilera-specific syscalls. */
+#define __NR_flush_cache	(__NR_arch_specific_syscall + 1)
+__SYSCALL(__NR_flush_cache, sys_flush_cache)
+
+#ifdef __KERNEL__
+/* In compat mode, we use sys_llseek() for compat_sys_llseek(). */
+#ifdef CONFIG_COMPAT
+#define __ARCH_WANT_SYS_LLSEEK
+#endif
+#endif
+
+#endif /* _ASM_TILE_UNISTD_H */
diff --git a/arch/tile/include/asm/user.h b/arch/tile/include/asm/user.h
new file mode 100644
index 0000000..cbc8b4d
--- /dev/null
+++ b/arch/tile/include/asm/user.h
@@ -0,0 +1,21 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ *
+ */
+
+#ifndef _ASM_TILE_USER_H
+#define _ASM_TILE_USER_H
+
+/* This header is for a.out file formats, which TILE does not support. */
+
+#endif /* _ASM_TILE_USER_H */
diff --git a/arch/tile/include/asm/xor.h b/arch/tile/include/asm/xor.h
new file mode 100644
index 0000000..c82eb12
--- /dev/null
+++ b/arch/tile/include/asm/xor.h
@@ -0,0 +1 @@
+#include <asm-generic/xor.h>
diff --git a/arch/tile/include/hv/drv_pcie_rc_intf.h b/arch/tile/include/hv/drv_pcie_rc_intf.h
new file mode 100644
index 0000000..9bd2243
--- /dev/null
+++ b/arch/tile/include/hv/drv_pcie_rc_intf.h
@@ -0,0 +1,38 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+/**
+ * @file drv_pcie_rc_intf.h
+ * Interface definitions for the PCIE Root Complex.
+ */
+
+#ifndef _SYS_HV_DRV_PCIE_RC_INTF_H
+#define _SYS_HV_DRV_PCIE_RC_INTF_H
+
+/** File offset for reading the interrupt base number used for PCIE legacy
+    interrupts and PLX Gen 1 requirement flag */
+#define PCIE_RC_CONFIG_MASK_OFF 0
+
+
+/**
+ * Structure used for obtaining PCIe config information, read from the PCIE
+ * subsystem /ctl file at initialization
+ */
+typedef struct pcie_rc_config
+{
+  int intr;                     /**< interrupt number used for downcall */
+  int plx_gen1;                 /**< flag for PLX Gen 1 configuration */
+} pcie_rc_config_t;
+
+#endif  /* _SYS_HV_DRV_PCIE_RC_INTF_H */
diff --git a/arch/tile/include/hv/hypervisor.h b/arch/tile/include/hv/hypervisor.h
new file mode 100644
index 0000000..84b3155
--- /dev/null
+++ b/arch/tile/include/hv/hypervisor.h
@@ -0,0 +1,2366 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+/**
+ * @file hypervisor.h
+ * The hypervisor's public API.
+ */
+
+#ifndef _TILE_HV_H
+#define _TILE_HV_H
+
+#ifdef __tile__
+#include <arch/chip.h>
+#else
+/* HACK: Allow use by "tools/cpack/". */
+#include "install/include/arch/chip.h"
+#endif
+
+/* Linux builds want unsigned long constants, but assembler wants numbers */
+#ifdef __ASSEMBLER__
+/** One, for assembler */
+#define __HV_SIZE_ONE 1
+#elif !defined(__tile__) && CHIP_VA_WIDTH() > 32
+/** One, for 64-bit on host */
+#define __HV_SIZE_ONE 1ULL
+#else
+/** One, for Linux */
+#define __HV_SIZE_ONE 1UL
+#endif
+
+
+/** The log2 of the span of a level-1 page table, in bytes.
+ */
+#define HV_LOG2_L1_SPAN 32
+
+/** The span of a level-1 page table, in bytes.
+ */
+#define HV_L1_SPAN (__HV_SIZE_ONE << HV_LOG2_L1_SPAN)
+
+/** The log2 of the size of small pages, in bytes. This value should
+ * be verified at runtime by calling hv_sysconf(HV_SYSCONF_PAGE_SIZE_SMALL).
+ */
+#define HV_LOG2_PAGE_SIZE_SMALL 16
+
+/** The size of small pages, in bytes. This value should be verified
+ * at runtime by calling hv_sysconf(HV_SYSCONF_PAGE_SIZE_SMALL).
+ */
+#define HV_PAGE_SIZE_SMALL (__HV_SIZE_ONE << HV_LOG2_PAGE_SIZE_SMALL)
+
+/** The log2 of the size of large pages, in bytes. This value should be
+ * verified at runtime by calling hv_sysconf(HV_SYSCONF_PAGE_SIZE_LARGE).
+ */
+#define HV_LOG2_PAGE_SIZE_LARGE 24
+
+/** The size of large pages, in bytes. This value should be verified
+ * at runtime by calling hv_sysconf(HV_SYSCONF_PAGE_SIZE_LARGE).
+ */
+#define HV_PAGE_SIZE_LARGE (__HV_SIZE_ONE << HV_LOG2_PAGE_SIZE_LARGE)
+
+/** The log2 of the granularity at which page tables must be aligned;
+ *  in other words, the CPA for a page table must have this many zero
+ *  bits at the bottom of the address.
+ */
+#define HV_LOG2_PAGE_TABLE_ALIGN 11
+
+/** The granularity at which page tables must be aligned.
+ */
+#define HV_PAGE_TABLE_ALIGN (__HV_SIZE_ONE << HV_LOG2_PAGE_TABLE_ALIGN)
+
+/** Normal start of hypervisor glue in client physical memory. */
+#define HV_GLUE_START_CPA 0x10000
+
+/** This much space is reserved at HV_GLUE_START_CPA
+ * for the hypervisor glue. The client program must start at
+ * some address higher than this, and in particular the address of
+ * its text section should be equal to zero modulo HV_PAGE_SIZE_LARGE
+ * so that relative offsets to the HV glue are correct.
+ */
+#define HV_GLUE_RESERVED_SIZE 0x10000
+
+/** Each entry in the hv dispatch array takes this many bytes. */
+#define HV_DISPATCH_ENTRY_SIZE 32
+
+/** Version of the hypervisor interface defined by this file */
+#define _HV_VERSION 10
+
+/* Index into hypervisor interface dispatch code blocks.
+ *
+ * Hypervisor calls are invoked from user space by calling code
+ * at an address HV_BASE_ADDRESS + (index) * HV_DISPATCH_ENTRY_SIZE,
+ * where index is one of these enum values.
+ *
+ * Normally a supervisor is expected to produce a set of symbols
+ * starting at HV_BASE_ADDRESS that obey this convention, but a user
+ * program could call directly through function pointers if desired.
+ *
+ * These numbers are part of the binary API and will not be changed
+ * without updating HV_VERSION, which should be a rare event.
+ */
+
+/** reserved. */
+#define _HV_DISPATCH_RESERVED                     0
+
+/** hv_init  */
+#define HV_DISPATCH_INIT                          1
+
+/** hv_install_context */
+#define HV_DISPATCH_INSTALL_CONTEXT               2
+
+/** hv_sysconf */
+#define HV_DISPATCH_SYSCONF                       3
+
+/** hv_get_rtc */
+#define HV_DISPATCH_GET_RTC                       4
+
+/** hv_set_rtc */
+#define HV_DISPATCH_SET_RTC                       5
+
+/** hv_flush_asid */
+#define HV_DISPATCH_FLUSH_ASID                    6
+
+/** hv_flush_page */
+#define HV_DISPATCH_FLUSH_PAGE                    7
+
+/** hv_flush_pages */
+#define HV_DISPATCH_FLUSH_PAGES                   8
+
+/** hv_restart */
+#define HV_DISPATCH_RESTART                       9
+
+/** hv_halt */
+#define HV_DISPATCH_HALT                          10
+
+/** hv_power_off */
+#define HV_DISPATCH_POWER_OFF                     11
+
+/** hv_inquire_physical */
+#define HV_DISPATCH_INQUIRE_PHYSICAL              12
+
+/** hv_inquire_memory_controller */
+#define HV_DISPATCH_INQUIRE_MEMORY_CONTROLLER     13
+
+/** hv_inquire_virtual */
+#define HV_DISPATCH_INQUIRE_VIRTUAL               14
+
+/** hv_inquire_asid */
+#define HV_DISPATCH_INQUIRE_ASID                  15
+
+/** hv_nanosleep */
+#define HV_DISPATCH_NANOSLEEP                     16
+
+/** hv_console_read_if_ready */
+#define HV_DISPATCH_CONSOLE_READ_IF_READY         17
+
+/** hv_console_write */
+#define HV_DISPATCH_CONSOLE_WRITE                 18
+
+/** hv_downcall_dispatch */
+#define HV_DISPATCH_DOWNCALL_DISPATCH             19
+
+/** hv_inquire_topology */
+#define HV_DISPATCH_INQUIRE_TOPOLOGY              20
+
+/** hv_fs_findfile */
+#define HV_DISPATCH_FS_FINDFILE                   21
+
+/** hv_fs_fstat */
+#define HV_DISPATCH_FS_FSTAT                      22
+
+/** hv_fs_pread */
+#define HV_DISPATCH_FS_PREAD                      23
+
+/** hv_physaddr_read64 */
+#define HV_DISPATCH_PHYSADDR_READ64               24
+
+/** hv_physaddr_write64 */
+#define HV_DISPATCH_PHYSADDR_WRITE64              25
+
+/** hv_get_command_line */
+#define HV_DISPATCH_GET_COMMAND_LINE              26
+
+/** hv_set_caching */
+#define HV_DISPATCH_SET_CACHING                   27
+
+/** hv_bzero_page */
+#define HV_DISPATCH_BZERO_PAGE                    28
+
+/** hv_register_message_state */
+#define HV_DISPATCH_REGISTER_MESSAGE_STATE        29
+
+/** hv_send_message */
+#define HV_DISPATCH_SEND_MESSAGE                  30
+
+/** hv_receive_message */
+#define HV_DISPATCH_RECEIVE_MESSAGE               31
+
+/** hv_inquire_context */
+#define HV_DISPATCH_INQUIRE_CONTEXT               32
+
+/** hv_start_all_tiles */
+#define HV_DISPATCH_START_ALL_TILES               33
+
+/** hv_dev_open */
+#define HV_DISPATCH_DEV_OPEN                      34
+
+/** hv_dev_close */
+#define HV_DISPATCH_DEV_CLOSE                     35
+
+/** hv_dev_pread */
+#define HV_DISPATCH_DEV_PREAD                     36
+
+/** hv_dev_pwrite */
+#define HV_DISPATCH_DEV_PWRITE                    37
+
+/** hv_dev_poll */
+#define HV_DISPATCH_DEV_POLL                      38
+
+/** hv_dev_poll_cancel */
+#define HV_DISPATCH_DEV_POLL_CANCEL               39
+
+/** hv_dev_preada */
+#define HV_DISPATCH_DEV_PREADA                    40
+
+/** hv_dev_pwritea */
+#define HV_DISPATCH_DEV_PWRITEA                   41
+
+/** hv_flush_remote */
+#define HV_DISPATCH_FLUSH_REMOTE                  42
+
+/** hv_console_putc */
+#define HV_DISPATCH_CONSOLE_PUTC                  43
+
+/** hv_inquire_tiles */
+#define HV_DISPATCH_INQUIRE_TILES                 44
+
+/** hv_confstr */
+#define HV_DISPATCH_CONFSTR                       45
+
+/** hv_reexec */
+#define HV_DISPATCH_REEXEC                        46
+
+/** hv_set_command_line */
+#define HV_DISPATCH_SET_COMMAND_LINE              47
+
+/** hv_dev_register_intr_state */
+#define HV_DISPATCH_DEV_REGISTER_INTR_STATE       48
+
+/** hv_enable_intr */
+#define HV_DISPATCH_ENABLE_INTR                   49
+
+/** hv_disable_intr */
+#define HV_DISPATCH_DISABLE_INTR                  50
+
+/** hv_trigger_ipi */
+#define HV_DISPATCH_TRIGGER_IPI                   51
+
+/** hv_store_mapping */
+#define HV_DISPATCH_STORE_MAPPING                 52
+
+/** hv_inquire_realpa */
+#define HV_DISPATCH_INQUIRE_REALPA                53
+
+/** hv_flush_all */
+#define HV_DISPATCH_FLUSH_ALL                     54
+
+/** One more than the largest dispatch value */
+#define _HV_DISPATCH_END                          55
+
+
+#ifndef __ASSEMBLER__
+
+#ifdef __KERNEL__
+#include <asm/types.h>
+typedef u32 __hv32;        /**< 32-bit value */
+typedef u64 __hv64;        /**< 64-bit value */
+#else
+#include <stdint.h>
+typedef uint32_t __hv32;   /**< 32-bit value */
+typedef uint64_t __hv64;   /**< 64-bit value */
+#endif
+
+
+/** Hypervisor physical address. */
+typedef __hv64 HV_PhysAddr;
+
+#if CHIP_VA_WIDTH() > 32
+/** Hypervisor virtual address. */
+typedef __hv64 HV_VirtAddr;
+#else
+/** Hypervisor virtual address. */
+typedef __hv32 HV_VirtAddr;
+#endif /* CHIP_VA_WIDTH() > 32 */
+
+/** Hypervisor ASID. */
+typedef unsigned int HV_ASID;
+
+/** Hypervisor tile location for a memory access
+ * ("location overridden target").
+ */
+typedef unsigned int HV_LOTAR;
+
+/** Hypervisor size of a page. */
+typedef unsigned long HV_PageSize;
+
+/** A page table entry.
+ */
+typedef struct
+{
+  __hv64 val;                /**< Value of PTE */
+} HV_PTE;
+
+/** Hypervisor error code. */
+typedef int HV_Errno;
+
+#endif /* !__ASSEMBLER__ */
+
+#define HV_OK           0    /**< No error */
+#define HV_EINVAL      -801  /**< Invalid argument */
+#define HV_ENODEV      -802  /**< No such device */
+#define HV_ENOENT      -803  /**< No such file or directory */
+#define HV_EBADF       -804  /**< Bad file number */
+#define HV_EFAULT      -805  /**< Bad address */
+#define HV_ERECIP      -806  /**< Bad recipients */
+#define HV_E2BIG       -807  /**< Message too big */
+#define HV_ENOTSUP     -808  /**< Service not supported */
+#define HV_EBUSY       -809  /**< Device busy */
+#define HV_ENOSYS      -810  /**< Invalid syscall */
+#define HV_EPERM       -811  /**< No permission */
+#define HV_ENOTREADY   -812  /**< Device not ready */
+#define HV_EIO         -813  /**< I/O error */
+#define HV_ENOMEM      -814  /**< Out of memory */
+
+#define HV_ERR_MAX     -801  /**< Largest HV error code */
+#define HV_ERR_MIN     -814  /**< Smallest HV error code */
+
+#ifndef __ASSEMBLER__
+
+/** Pass HV_VERSION to hv_init to request this version of the interface. */
+typedef enum { HV_VERSION = _HV_VERSION } HV_VersionNumber;
+
+/** Initializes the hypervisor.
+ *
+ * @param interface_version_number The version of the hypervisor interface
+ * that this program expects, typically HV_VERSION.
+ * @param chip_num Architecture number of the chip the client was built for.
+ * @param chip_rev_num Revision number of the chip the client was built for.
+ */
+void hv_init(HV_VersionNumber interface_version_number,
+             int chip_num, int chip_rev_num);
+
+
+/** Queries we can make for hv_sysconf().
+ *
+ * These numbers are part of the binary API and guaranteed not to change.
+ */
+typedef enum {
+  /** An invalid value; do not use. */
+  _HV_SYSCONF_RESERVED       = 0,
+
+  /** The length of the glue section containing the hv_ procs, in bytes. */
+  HV_SYSCONF_GLUE_SIZE       = 1,
+
+  /** The size of small pages, in bytes. */
+  HV_SYSCONF_PAGE_SIZE_SMALL = 2,
+
+  /** The size of large pages, in bytes. */
+  HV_SYSCONF_PAGE_SIZE_LARGE = 3,
+
+  /** Processor clock speed, in hertz. */
+  HV_SYSCONF_CPU_SPEED       = 4,
+
+  /** Processor temperature, in degrees Kelvin.  The value
+   *  HV_SYSCONF_TEMP_KTOC may be subtracted from this to get degrees
+   *  Celsius.  If that Celsius value is HV_SYSCONF_OVERTEMP, this indicates
+   *  that the temperature has hit an upper limit and is no longer being
+   *  accurately tracked.
+   */
+  HV_SYSCONF_CPU_TEMP        = 5,
+
+  /** Board temperature, in degrees Kelvin.  The value
+   *  HV_SYSCONF_TEMP_KTOC may be subtracted from this to get degrees
+   *  Celsius.  If that Celsius value is HV_SYSCONF_OVERTEMP, this indicates
+   *  that the temperature has hit an upper limit and is no longer being
+   *  accurately tracked.
+   */
+  HV_SYSCONF_BOARD_TEMP      = 6
+
+} HV_SysconfQuery;
+
+/** Offset to subtract from returned Kelvin temperature to get degrees
+    Celsius. */
+#define HV_SYSCONF_TEMP_KTOC 273
+
+/** Pseudo-temperature value indicating that the temperature has
+ *  pegged at its upper limit and is no longer accurate; note that this is
+ *  the value after subtracting HV_SYSCONF_TEMP_KTOC. */
+#define HV_SYSCONF_OVERTEMP 999
+
+/** Query a configuration value from the hypervisor.
+ * @param query Which value is requested (HV_SYSCONF_xxx).
+ * @return The requested value, or -1 the requested value is illegal or
+ *         unavailable.
+ */
+long hv_sysconf(HV_SysconfQuery query);
+
+
+/** Queries we can make for hv_confstr().
+ *
+ * These numbers are part of the binary API and guaranteed not to change.
+ */
+typedef enum {
+  /** An invalid value; do not use. */
+  _HV_CONFSTR_RESERVED        = 0,
+
+  /** Board part number. */
+  HV_CONFSTR_BOARD_PART_NUM   = 1,
+
+  /** Board serial number. */
+  HV_CONFSTR_BOARD_SERIAL_NUM = 2,
+
+  /** Chip serial number. */
+  HV_CONFSTR_CHIP_SERIAL_NUM  = 3,
+
+  /** Board revision level. */
+  HV_CONFSTR_BOARD_REV        = 4,
+
+  /** Hypervisor software version. */
+  HV_CONFSTR_HV_SW_VER        = 5,
+
+  /** The name for this chip model. */
+  HV_CONFSTR_CHIP_MODEL       = 6,
+
+  /** Human-readable board description. */
+  HV_CONFSTR_BOARD_DESC       = 7,
+
+  /** Human-readable description of the hypervisor configuration. */
+  HV_CONFSTR_HV_CONFIG        = 8,
+
+  /** Human-readable version string for the boot image (for instance,
+   *  who built it and when, what configuration file was used). */
+  HV_CONFSTR_HV_CONFIG_VER    = 9,
+
+  /** Mezzanine part number. */
+  HV_CONFSTR_MEZZ_PART_NUM   = 10,
+
+  /** Mezzanine serial number. */
+  HV_CONFSTR_MEZZ_SERIAL_NUM = 11,
+
+  /** Mezzanine revision level. */
+  HV_CONFSTR_MEZZ_REV        = 12,
+
+  /** Human-readable mezzanine description. */
+  HV_CONFSTR_MEZZ_DESC       = 13,
+
+  /** Control path for the onboard network switch. */
+  HV_CONFSTR_SWITCH_CONTROL  = 14,
+
+  /** Chip revision level. */
+  HV_CONFSTR_CHIP_REV        = 15
+
+} HV_ConfstrQuery;
+
+/** Query a configuration string from the hypervisor.
+ *
+ * @param query Identifier for the specific string to be retrieved
+ *        (HV_CONFSTR_xxx).
+ * @param buf Buffer in which to place the string.
+ * @param len Length of the buffer.
+ * @return If query is valid, then the length of the corresponding string,
+ *        including the trailing null; if this is greater than len, the string
+ *        was truncated.  If query is invalid, HV_EINVAL.  If the specified
+ *        buffer is not writable by the client, HV_EFAULT.
+ */
+int hv_confstr(HV_ConfstrQuery query, HV_VirtAddr buf, int len);
+
+/** State object used to enable and disable one-shot and level-sensitive
+ *  interrupts. */
+typedef struct
+{
+#if CHIP_VA_WIDTH() > 32
+  __hv64 opaque[2]; /**< No user-serviceable parts inside */
+#else
+  __hv32 opaque[2]; /**< No user-serviceable parts inside */
+#endif
+}
+HV_IntrState;
+
+/** A set of interrupts. */
+typedef __hv32 HV_IntrMask;
+
+/** Tile coordinate */
+typedef struct
+{
+  /** X coordinate, relative to supervisor's top-left coordinate */
+  int x;
+
+  /** Y coordinate, relative to supervisor's top-left coordinate */
+  int y;
+} HV_Coord;
+
+/** The low interrupt numbers are reserved for use by the client in
+ *  delivering IPIs.  Any interrupt numbers higher than this value are
+ *  reserved for use by HV device drivers. */
+#define HV_MAX_IPI_INTERRUPT 7
+
+/** Register an interrupt state object.  This object is used to enable and
+ *  disable one-shot and level-sensitive interrupts.  Once the state is
+ *  registered, the client must not read or write the state object; doing
+ *  so will cause undefined results.
+ *
+ * @param intr_state Pointer to interrupt state object.
+ * @return HV_OK on success, or a hypervisor error code.
+ */
+HV_Errno hv_dev_register_intr_state(HV_IntrState* intr_state);
+
+/** Enable a set of one-shot and level-sensitive interrupts.
+ *
+ * @param intr_state Pointer to interrupt state object.
+ * @param enab_mask Bitmap of interrupts to enable.
+ */
+void hv_enable_intr(HV_IntrState* intr_state, HV_IntrMask enab_mask);
+
+/** Disable a set of one-shot and level-sensitive interrupts.
+ *
+ * @param intr_state Pointer to interrupt state object.
+ * @param disab_mask Bitmap of interrupts to disable.
+ */
+void hv_disable_intr(HV_IntrState* intr_state, HV_IntrMask disab_mask);
+
+/** Trigger a one-shot interrupt on some tile
+ *
+ * @param tile Which tile to interrupt.
+ * @param interrupt Interrupt number to trigger; must be between 0 and
+ *        HV_MAX_IPI_INTERRUPT.
+ * @return HV_OK on success, or a hypervisor error code.
+ */
+HV_Errno hv_trigger_ipi(HV_Coord tile, int interrupt);
+
+/** Store memory mapping in debug memory so that external debugger can read it.
+ * A maximum of 16 entries can be stored.
+ *
+ * @param va VA of memory that is mapped.
+ * @param len Length of mapped memory.
+ * @param pa PA of memory that is mapped.
+ * @return 0 on success, -1 if the maximum number of mappings is exceeded.
+ */
+int hv_store_mapping(HV_VirtAddr va, unsigned int len, HV_PhysAddr pa);
+
+/** Given a client PA and a length, return its real (HV) PA.
+ *
+ * @param cpa Client physical address.
+ * @param len Length of mapped memory.
+ * @return physical address, or -1 if cpa or len is not valid.
+ */
+HV_PhysAddr hv_inquire_realpa(HV_PhysAddr cpa, unsigned int len);
+
+/** RTC return flag for no RTC chip present.
+ */
+#define HV_RTC_NO_CHIP     0x1
+
+/** RTC return flag for low-voltage condition, indicating that battery had
+ * died and time read is unreliable.
+ */
+#define HV_RTC_LOW_VOLTAGE 0x2
+
+/** Date/Time of day */
+typedef struct {
+#if CHIP_WORD_SIZE() > 32
+  __hv64 tm_sec;   /**< Seconds, 0-59 */
+  __hv64 tm_min;   /**< Minutes, 0-59 */
+  __hv64 tm_hour;  /**< Hours, 0-23 */
+  __hv64 tm_mday;  /**< Day of month, 0-30 */
+  __hv64 tm_mon;   /**< Month, 0-11 */
+  __hv64 tm_year;  /**< Years since 1900, 0-199 */
+  __hv64 flags;    /**< Return flags, 0 if no error */
+#else
+  __hv32 tm_sec;   /**< Seconds, 0-59 */
+  __hv32 tm_min;   /**< Minutes, 0-59 */
+  __hv32 tm_hour;  /**< Hours, 0-23 */
+  __hv32 tm_mday;  /**< Day of month, 0-30 */
+  __hv32 tm_mon;   /**< Month, 0-11 */
+  __hv32 tm_year;  /**< Years since 1900, 0-199 */
+  __hv32 flags;    /**< Return flags, 0 if no error */
+#endif
+} HV_RTCTime;
+
+/** Read the current time-of-day clock.
+ * @return HV_RTCTime of current time (GMT).
+ */
+HV_RTCTime hv_get_rtc(void);
+
+
+/** Set the current time-of-day clock.
+ * @param time time to reset time-of-day to (GMT).
+ */
+void hv_set_rtc(HV_RTCTime time);
+
+/** Installs a context, comprising a page table and other attributes.
+ *
+ *  Once this service completes, page_table will be used to translate
+ *  subsequent virtual address references to physical memory.
+ *
+ *  Installing a context does not cause an implicit TLB flush.  Before
+ *  reusing an ASID value for a different address space, the client is
+ *  expected to flush old references from the TLB with hv_flush_asid().
+ *  (Alternately, hv_flush_all() may be used to flush many ASIDs at once.)
+ *  After invalidating a page table entry, changing its attributes, or
+ *  changing its target CPA, the client is expected to flush old references
+ *  from the TLB with hv_flush_page() or hv_flush_pages(). Making a
+ *  previously invalid page valid does not require a flush.
+ *
+ *  Specifying an invalid ASID, or an invalid CPA (client physical address)
+ *  (either as page_table_pointer, or within the referenced table),
+ *  or another page table data item documented as above as illegal may
+ *  lead to client termination; since the validation of the table is
+ *  done as needed, this may happen before the service returns, or at
+ *  some later time, or never, depending upon the client's pattern of
+ *  memory references.  Page table entries which supply translations for
+ *  invalid virtual addresses may result in client termination, or may
+ *  be silently ignored.  "Invalid" in this context means a value which
+ *  was not provided to the client via the appropriate hv_inquire_* routine.
+ *
+ *  To support changing the instruction VAs at the same time as
+ *  installing the new page table, this call explicitly supports
+ *  setting the "lr" register to a different address and then jumping
+ *  directly to the hv_install_context() routine.  In this case, the
+ *  new page table does not need to contain any mapping for the
+ *  hv_install_context address itself.
+ *
+ * @param page_table Root of the page table.
+ * @param access PTE providing info on how to read the page table.  This
+ *   value must be consistent between multiple tiles sharing a page table,
+ *   and must also be consistent with any virtual mappings the client
+ *   may be using to access the page table.
+ * @param asid HV_ASID the page table is to be used for.
+ * @param flags Context flags, denoting attributes or privileges of the
+ *   current context (HV_CTX_xxx).
+ * @return Zero on success, or a hypervisor error code on failure.
+ */
+int hv_install_context(HV_PhysAddr page_table, HV_PTE access, HV_ASID asid,
+                       __hv32 flags);
+
+#endif /* !__ASSEMBLER__ */
+
+#define HV_CTX_DIRECTIO     0x1   /**< Direct I/O requests are accepted from
+                                       PL0. */
+
+#ifndef __ASSEMBLER__
+
+/** Value returned from hv_inquire_context(). */
+typedef struct
+{
+  /** Physical address of page table */
+  HV_PhysAddr page_table;
+
+  /** PTE which defines access method for top of page table */
+  HV_PTE access;
+
+  /** ASID associated with this page table */
+  HV_ASID asid;
+
+  /** Context flags */
+  __hv32 flags;
+} HV_Context;
+
+/** Retrieve information about the currently installed context.
+ * @return The data passed to the last successful hv_install_context call.
+ */
+HV_Context hv_inquire_context(void);
+
+
+/** Flushes all translations associated with the named address space
+ *  identifier from the TLB and any other hypervisor data structures.
+ *  Translations installed with the "global" bit are not flushed.
+ *
+ *  Specifying an invalid ASID may lead to client termination.  "Invalid"
+ *  in this context means a value which was not provided to the client
+ *  via <tt>hv_inquire_asid()</tt>.
+ *
+ * @param asid HV_ASID whose entries are to be flushed.
+ * @return Zero on success, or a hypervisor error code on failure.
+*/
+int hv_flush_asid(HV_ASID asid);
+
+
+/** Flushes all translations associated with the named virtual address
+ *  and page size from the TLB and other hypervisor data structures. Only
+ *  pages visible to the current ASID are affected; note that this includes
+ *  global pages in addition to pages specific to the current ASID.
+ *
+ *  The supplied VA need not be aligned; it may be anywhere in the
+ *  subject page.
+ *
+ *  Specifying an invalid virtual address may lead to client termination,
+ *  or may silently succeed.  "Invalid" in this context means a value
+ *  which was not provided to the client via hv_inquire_virtual.
+ *
+ * @param address Address of the page to flush.
+ * @param page_size Size of pages to assume.
+ * @return Zero on success, or a hypervisor error code on failure.
+ */
+int hv_flush_page(HV_VirtAddr address, HV_PageSize page_size);
+
+
+/** Flushes all translations associated with the named virtual address range
+ *  and page size from the TLB and other hypervisor data structures. Only
+ *  pages visible to the current ASID are affected; note that this includes
+ *  global pages in addition to pages specific to the current ASID.
+ *
+ *  The supplied VA need not be aligned; it may be anywhere in the
+ *  subject page.
+ *
+ *  Specifying an invalid virtual address may lead to client termination,
+ *  or may silently succeed.  "Invalid" in this context means a value
+ *  which was not provided to the client via hv_inquire_virtual.
+ *
+ * @param start Address to flush.
+ * @param page_size Size of pages to assume.
+ * @param size The number of bytes to flush. Any page in the range
+ *        [start, start + size) will be flushed from the TLB.
+ * @return Zero on success, or a hypervisor error code on failure.
+ */
+int hv_flush_pages(HV_VirtAddr start, HV_PageSize page_size,
+                   unsigned long size);
+
+
+/** Flushes all non-global translations (if preserve_global is true),
+ *  or absolutely all translations (if preserve_global is false).
+ *
+ * @param preserve_global Non-zero if we want to preserve "global" mappings.
+ * @return Zero on success, or a hypervisor error code on failure.
+*/
+int hv_flush_all(int preserve_global);
+
+
+/** Restart machine with optional restart command and optional args.
+ * @param cmd Const pointer to command to restart with, or NULL
+ * @param args Const pointer to argument string to restart with, or NULL
+ */
+void hv_restart(HV_VirtAddr cmd, HV_VirtAddr args);
+
+
+/** Halt machine. */
+void hv_halt(void);
+
+
+/** Power off machine. */
+void hv_power_off(void);
+
+
+/** Re-enter virtual-is-physical memory translation mode and restart
+ *  execution at a given address.
+ * @param entry Client physical address at which to begin execution.
+ * @return A hypervisor error code on failure; if the operation is
+ *         successful the call does not return.
+ */
+int hv_reexec(HV_PhysAddr entry);
+
+
+/** Chip topology */
+typedef struct
+{
+  /** Relative coordinates of the querying tile */
+  HV_Coord coord;
+
+  /** Width of the querying supervisor's tile rectangle. */
+  int width;
+
+  /** Height of the querying supervisor's tile rectangle. */
+  int height;
+
+} HV_Topology;
+
+/** Returns information about the tile coordinate system.
+ *
+ * Each supervisor is given a rectangle of tiles it potentially controls.
+ * These tiles are labeled using a relative coordinate system with (0,0) as
+ * the upper left tile regardless of their physical location on the chip.
+ *
+ * This call returns both the size of that rectangle and the position
+ * within that rectangle of the querying tile.
+ *
+ * Not all tiles within that rectangle may be available to the supervisor;
+ * to get the precise set of available tiles, you must also call
+ * hv_inquire_tiles(HV_INQ_TILES_AVAIL, ...).
+ **/
+HV_Topology hv_inquire_topology(void);
+
+/** Sets of tiles we can retrieve with hv_inquire_tiles().
+ *
+ * These numbers are part of the binary API and guaranteed not to change.
+ */
+typedef enum {
+  /** An invalid value; do not use. */
+  _HV_INQ_TILES_RESERVED       = 0,
+
+  /** All available tiles within the supervisor's tile rectangle. */
+  HV_INQ_TILES_AVAIL           = 1,
+
+  /** The set of tiles used for hash-for-home caching. */
+  HV_INQ_TILES_HFH_CACHE       = 2,
+
+  /** The set of tiles that can be legally used as a LOTAR for a PTE. */
+  HV_INQ_TILES_LOTAR           = 3
+} HV_InqTileSet;
+
+/** Returns specific information about various sets of tiles within the
+ *  supervisor's tile rectangle.
+ *
+ * @param set Which set of tiles to retrieve.
+ * @param cpumask Pointer to a returned bitmask (in row-major order,
+ *        supervisor-relative) of tiles.  The low bit of the first word
+ *        corresponds to the tile at the upper left-hand corner of the
+ *        supervisor's rectangle.  In order for the supervisor to know the
+ *        buffer length to supply, it should first call hv_inquire_topology.
+ * @param length Number of bytes available for the returned bitmask.
+ **/
+HV_Errno hv_inquire_tiles(HV_InqTileSet set, HV_VirtAddr cpumask, int length);
+
+
+/** An identifier for a memory controller. Multiple memory controllers
+ * may be connected to one chip, and this uniquely identifies each one.
+ */
+typedef int HV_MemoryController;
+
+/** A range of physical memory. */
+typedef struct
+{
+  HV_PhysAddr start;   /**< Starting address. */
+  __hv64 size;         /**< Size in bytes. */
+  HV_MemoryController controller;  /**< Which memory controller owns this. */
+} HV_PhysAddrRange;
+
+/** Returns information about a range of physical memory.
+ *
+ * hv_inquire_physical() returns one of the ranges of client
+ * physical addresses which are available to this client.
+ *
+ * The first range is retrieved by specifying an idx of 0, and
+ * successive ranges are returned with subsequent idx values.  Ranges
+ * are ordered by increasing start address (i.e., as idx increases,
+ * so does start), do not overlap, and do not touch (i.e., the
+ * available memory is described with the fewest possible ranges).
+ *
+ * If an out-of-range idx value is specified, the returned size will be zero.
+ * A client can count the number of ranges by increasing idx until the
+ * returned size is zero. There will always be at least one valid range.
+ *
+ * Some clients might not be prepared to deal with more than one
+ * physical address range; they still ought to call this routine and
+ * issue a warning message if they're given more than one range, on the
+ * theory that whoever configured the hypervisor to provide that memory
+ * should know that it's being wasted.
+ */
+HV_PhysAddrRange hv_inquire_physical(int idx);
+
+
+/** Memory controller information. */
+typedef struct
+{
+  HV_Coord coord;   /**< Relative tile coordinates of the port used by a
+                         specified tile to communicate with this controller. */
+  __hv64 speed;     /**< Speed of this controller in bytes per second. */
+} HV_MemoryControllerInfo;
+
+/** Returns information about a particular memory controller.
+ *
+ *  hv_inquire_memory_controller(coord,idx) returns information about a
+ *  particular controller.  Two pieces of information are returned:
+ *  - The relative coordinates of the port on the controller that the specified
+ *    tile would use to contact it.  The relative coordinates may lie
+ *    outside the supervisor's rectangle, i.e. the controller may not
+ *    be attached to a node managed by the querying node's supervisor.
+ *    In particular note that x or y may be negative.
+ *  - The speed of the memory controller.  (This is a not-to-exceed value
+ *    based on the raw hardware data rate, and may not be achievable in
+ *    practice; it is provided to give clients information on the relative
+ *    performance of the available controllers.)
+ *
+ *  Clients should avoid calling this interface with invalid values.
+ *  A client who does may be terminated.
+ * @param coord Tile for which to calculate the relative port position.
+ * @param controller Index of the controller; identical to value returned
+ *        from other routines like hv_inquire_physical.
+ * @return Information about the controller.
+ */
+HV_MemoryControllerInfo hv_inquire_memory_controller(HV_Coord coord,
+                                                     int controller);
+
+
+/** A range of virtual memory. */
+typedef struct
+{
+  HV_VirtAddr start;   /**< Starting address. */
+  __hv64 size;         /**< Size in bytes. */
+} HV_VirtAddrRange;
+
+/** Returns information about a range of virtual memory.
+ *
+ * hv_inquire_virtual() returns one of the ranges of client
+ * virtual addresses which are available to this client.
+ *
+ * The first range is retrieved by specifying an idx of 0, and
+ * successive ranges are returned with subsequent idx values.  Ranges
+ * are ordered by increasing start address (i.e., as idx increases,
+ * so does start), do not overlap, and do not touch (i.e., the
+ * available memory is described with the fewest possible ranges).
+ *
+ * If an out-of-range idx value is specified, the returned size will be zero.
+ * A client can count the number of ranges by increasing idx until the
+ * returned size is zero. There will always be at least one valid range.
+ *
+ * Some clients may well have various virtual addresses hardwired
+ * into themselves; for instance, their instruction stream may
+ * have been compiled expecting to live at a particular address.
+ * Such clients should use this interface to verify they've been
+ * given the virtual address space they expect, and issue a (potentially
+ * fatal) warning message otherwise.
+ *
+ * Note that the returned size is a __hv64, not a __hv32, so it is
+ * possible to express a single range spanning the entire 32-bit
+ * address space.
+ */
+HV_VirtAddrRange hv_inquire_virtual(int idx);
+
+
+/** A range of ASID values. */
+typedef struct
+{
+  HV_ASID start;        /**< First ASID in the range. */
+  unsigned int size;    /**< Number of ASIDs. Zero for an invalid range. */
+} HV_ASIDRange;
+
+/** Returns information about a range of ASIDs.
+ *
+ * hv_inquire_asid() returns one of the ranges of address
+ * space identifiers which are available to this client.
+ *
+ * The first range is retrieved by specifying an idx of 0, and
+ * successive ranges are returned with subsequent idx values.  Ranges
+ * are ordered by increasing start value (i.e., as idx increases,
+ * so does start), do not overlap, and do not touch (i.e., the
+ * available ASIDs are described with the fewest possible ranges).
+ *
+ * If an out-of-range idx value is specified, the returned size will be zero.
+ * A client can count the number of ranges by increasing idx until the
+ * returned size is zero. There will always be at least one valid range.
+ */
+HV_ASIDRange hv_inquire_asid(int idx);
+
+
+/** Waits for at least the specified number of nanoseconds then returns.
+ *
+ * @param nanosecs The number of nanoseconds to sleep.
+ */
+void hv_nanosleep(int nanosecs);
+
+
+/** Reads a character from the console without blocking.
+ *
+ * @return A value from 0-255 indicates the value successfully read.
+ * A negative value means no value was ready.
+ */
+int hv_console_read_if_ready(void);
+
+
+/** Writes a character to the console, blocking if the console is busy.
+ *
+ *  This call cannot fail. If the console is broken for some reason,
+ *  output will simply vanish.
+ * @param byte Character to write.
+ */
+void hv_console_putc(int byte);
+
+
+/** Writes a string to the console, blocking if the console is busy.
+ * @param bytes Pointer to characters to write.
+ * @param len Number of characters to write.
+ * @return Number of characters written, or HV_EFAULT if the buffer is invalid.
+ */
+int hv_console_write(HV_VirtAddr bytes, int len);
+
+
+/** Dispatch the next interrupt from the client downcall mechanism.
+ *
+ *  The hypervisor uses downcalls to notify the client of asynchronous
+ *  events.  Some of these events are hypervisor-created (like incoming
+ *  messages).  Some are regular interrupts which initially occur in
+ *  the hypervisor, and are normally handled directly by the client;
+ *  when these occur in a client's interrupt critical section, they must
+ *  be delivered through the downcall mechanism.
+ *
+ *  A downcall is initially delivered to the client as an INTCTRL_1
+ *  interrupt.  Upon entry to the INTCTRL_1 vector, the client must
+ *  immediately invoke the hv_downcall_dispatch service.  This service
+ *  will not return; instead it will cause one of the client's actual
+ *  downcall-handling interrupt vectors to be entered.  The EX_CONTEXT
+ *  registers in the client will be set so that when the client irets,
+ *  it will return to the code which was interrupted by the INTCTRL_1
+ *  interrupt.
+ *
+ *  Any saving of registers should be done by the actual handling
+ *  vectors; no registers should be changed by the INTCTRL_1 handler.
+ *  In particular, the client should not use a jal instruction to invoke
+ *  the hv_downcall_dispatch service, as that would overwrite the client's
+ *  lr register.  Note that the hv_downcall_dispatch service may overwrite
+ *  one or more of the client's system save registers.
+ *
+ *  The client must not modify the INTCTRL_1_STATUS SPR.  The hypervisor
+ *  will set this register to cause a downcall to happen, and will clear
+ *  it when no further downcalls are pending.
+ *
+ *  When a downcall vector is entered, the INTCTRL_1 interrupt will be
+ *  masked.  When the client is done processing a downcall, and is ready
+ *  to accept another, it must unmask this interrupt; if more downcalls
+ *  are pending, this will cause the INTCTRL_1 vector to be reentered.
+ *  Currently the following interrupt vectors can be entered through a
+ *  downcall:
+ *
+ *  INT_MESSAGE_RCV_DWNCL   (hypervisor message available)
+ *  INT_DMATLB_MISS_DWNCL   (DMA TLB miss)
+ *  INT_SNITLB_MISS_DWNCL   (SNI TLB miss)
+ *  INT_DMATLB_ACCESS_DWNCL (DMA TLB access violation)
+ */
+void hv_downcall_dispatch(void);
+
+#endif /* !__ASSEMBLER__ */
+
+/** We use actual interrupt vectors which never occur (they're only there
+ *  to allow setting MPLs for related SPRs) for our downcall vectors.
+ */
+/** Message receive downcall interrupt vector */
+#define INT_MESSAGE_RCV_DWNCL    INT_BOOT_ACCESS
+/** DMA TLB miss downcall interrupt vector */
+#define INT_DMATLB_MISS_DWNCL    INT_DMA_ASID
+/** Static nework processor instruction TLB miss interrupt vector */
+#define INT_SNITLB_MISS_DWNCL    INT_SNI_ASID
+/** DMA TLB access violation downcall interrupt vector */
+#define INT_DMATLB_ACCESS_DWNCL  INT_DMA_CPL
+/** Device interrupt downcall interrupt vector */
+#define INT_DEV_INTR_DWNCL       INT_WORLD_ACCESS
+
+#ifndef __ASSEMBLER__
+
+/** Requests the inode for a specific full pathname.
+ *
+ * Performs a lookup in the hypervisor filesystem for a given filename.
+ * Multiple calls with the same filename will always return the same inode.
+ * If there is no such filename, HV_ENOENT is returned.
+ * A bad filename pointer may result in HV_EFAULT instead.
+ *
+ * @param filename Constant pointer to name of requested file
+ * @return Inode of requested file
+ */
+int hv_fs_findfile(HV_VirtAddr filename);
+
+
+/** Data returned from an fstat request.
+ * Note that this structure should be no more than 40 bytes in size so
+ * that it can always be returned completely in registers.
+ */
+typedef struct
+{
+  int size;             /**< Size of file (or HV_Errno on error) */
+  unsigned int flags;   /**< Flags (see HV_FS_FSTAT_FLAGS) */
+} HV_FS_StatInfo;
+
+/** Bitmask flags for fstat request */
+typedef enum
+{
+  HV_FS_ISDIR    = 0x0001   /**< Is the entry a directory? */
+} HV_FS_FSTAT_FLAGS;
+
+/** Get stat information on a given file inode.
+ *
+ * Return information on the file with the given inode.
+ *
+ * IF the HV_FS_ISDIR bit is set, the "file" is a directory.  Reading
+ * it will return NUL-separated filenames (no directory part) relative
+ * to the path to the inode of the directory "file".  These can be
+ * appended to the path to the directory "file" after a forward slash
+ * to create additional filenames.  Note that it is not required
+ * that all valid paths be decomposable into valid parent directories;
+ * a filesystem may validly have just a few files, none of which have
+ * HV_FS_ISDIR set.  However, if clients may wish to enumerate the
+ * files in the filesystem, it is recommended to include all the
+ * appropriate parent directory "files" to give a consistent view.
+ *
+ * An invalid file inode will cause an HV_EBADF error to be returned.
+ *
+ * @param inode The inode number of the query
+ * @return An HV_FS_StatInfo structure
+ */
+HV_FS_StatInfo hv_fs_fstat(int inode);
+
+
+/** Read data from a specific hypervisor file.
+ * On error, may return HV_EBADF for a bad inode or HV_EFAULT for a bad buf.
+ * Reads near the end of the file will return fewer bytes than requested.
+ * Reads at or beyond the end of a file will return zero.
+ *
+ * @param inode the hypervisor file to read
+ * @param buf the buffer to read data into
+ * @param length the number of bytes of data to read
+ * @param offset the offset into the file to read the data from
+ * @return number of bytes successfully read, or an HV_Errno code
+ */
+int hv_fs_pread(int inode, HV_VirtAddr buf, int length, int offset);
+
+
+/** Read a 64-bit word from the specified physical address.
+ * The address must be 8-byte aligned.
+ * Specifying an invalid physical address will lead to client termination.
+ * @param addr The physical address to read
+ * @param access The PTE describing how to read the memory
+ * @return The 64-bit value read from the given address
+ */
+unsigned long long hv_physaddr_read64(HV_PhysAddr addr, HV_PTE access);
+
+
+/** Write a 64-bit word to the specified physical address.
+ * The address must be 8-byte aligned.
+ * Specifying an invalid physical address will lead to client termination.
+ * @param addr The physical address to write
+ * @param access The PTE that says how to write the memory
+ * @param val The 64-bit value to write to the given address
+ */
+void hv_physaddr_write64(HV_PhysAddr addr, HV_PTE access,
+                         unsigned long long val);
+
+
+/** Get the value of the command-line for the supervisor, if any.
+ * This will not include the filename of the booted supervisor, but may
+ * include configured-in boot arguments or the hv_restart() arguments.
+ * If the buffer is not long enough the hypervisor will NUL the first
+ * character of the buffer but not write any other data.
+ * @param buf The virtual address to write the command-line string to.
+ * @param length The length of buf, in characters.
+ * @return The actual length of the command line, including the trailing NUL
+ *         (may be larger than "length").
+ */
+int hv_get_command_line(HV_VirtAddr buf, int length);
+
+
+/** Set a new value for the command-line for the supervisor, which will
+ *  be returned from subsequent invocations of hv_get_command_line() on
+ *  this tile.
+ * @param buf The virtual address to read the command-line string from.
+ * @param length The length of buf, in characters; must be no more than
+ *        HV_COMMAND_LINE_LEN.
+ * @return Zero if successful, or a hypervisor error code.
+ */
+HV_Errno hv_set_command_line(HV_VirtAddr buf, int length);
+
+/** Maximum size of a command line passed to hv_set_command_line(); note
+ *  that a line returned from hv_get_command_line() could be larger than
+ *  this.*/
+#define HV_COMMAND_LINE_LEN  256
+
+/** Tell the hypervisor how to cache non-priority pages
+ * (its own as well as pages explicitly represented in page tables).
+ * Normally these will be represented as red/black pages, but
+ * when the supervisor starts to allocate "priority" pages in the PTE
+ * the hypervisor will need to start marking those pages as (e.g.) "red"
+ * and non-priority pages as either "black" (if they cache-alias
+ * with the existing priority pages) or "red/black" (if they don't).
+ * The bitmask provides information on which parts of the cache
+ * have been used for pinned pages so far on this tile; if (1 << N)
+ * appears in the bitmask, that indicates that a page has been marked
+ * "priority" whose PFN equals N, mod 8.
+ * @param bitmask A bitmap of priority page set values
+ */
+void hv_set_caching(unsigned int bitmask);
+
+
+/** Zero out a specified number of pages.
+ * The va and size must both be multiples of 4096.
+ * Caches are bypassed and memory is directly set to zero.
+ * This API is implemented only in the magic hypervisor and is intended
+ * to provide a performance boost to the minimal supervisor by
+ * giving it a fast way to zero memory pages when allocating them.
+ * @param va Virtual address where the page has been mapped
+ * @param size Number of bytes (must be a page size multiple)
+ */
+void hv_bzero_page(HV_VirtAddr va, unsigned int size);
+
+
+/** State object for the hypervisor messaging subsystem. */
+typedef struct
+{
+#if CHIP_VA_WIDTH() > 32
+  __hv64 opaque[2]; /**< No user-serviceable parts inside */
+#else
+  __hv32 opaque[2]; /**< No user-serviceable parts inside */
+#endif
+}
+HV_MsgState;
+
+/** Register to receive incoming messages.
+ *
+ *  This routine configures the current tile so that it can receive
+ *  incoming messages.  It must be called before the client can receive
+ *  messages with the hv_receive_message routine, and must be called on
+ *  each tile which will receive messages.
+ *
+ *  msgstate is the virtual address of a state object of type HV_MsgState.
+ *  Once the state is registered, the client must not read or write the
+ *  state object; doing so will cause undefined results.
+ *
+ *  If this routine is called with msgstate set to 0, the client's message
+ *  state will be freed and it will no longer be able to receive messages.
+ *  Note that this may cause the loss of any as-yet-undelivered messages
+ *  for the client.
+ *
+ *  If another client attempts to send a message to a client which has
+ *  not yet called hv_register_message_state, or which has freed its
+ *  message state, the message will not be delivered, as if the client
+ *  had insufficient buffering.
+ *
+ *  This routine returns HV_OK if the registration was successful, and
+ *  HV_EINVAL if the supplied state object is unsuitable.  Note that some
+ *  errors may not be detected during this routine, but might be detected
+ *  during a subsequent message delivery.
+ * @param msgstate State object.
+ **/
+HV_Errno hv_register_message_state(HV_MsgState* msgstate);
+
+/** Possible message recipient states. */
+typedef enum
+{
+  HV_TO_BE_SENT,    /**< Not sent (not attempted, or recipient not ready) */
+  HV_SENT,          /**< Successfully sent */
+  HV_BAD_RECIP      /**< Bad recipient coordinates (permanent error) */
+} HV_Recip_State;
+
+/** Message recipient. */
+typedef struct
+{
+  /** X coordinate, relative to supervisor's top-left coordinate */
+  unsigned int x:11;
+
+  /** Y coordinate, relative to supervisor's top-left coordinate */
+  unsigned int y:11;
+
+  /** Status of this recipient */
+  HV_Recip_State state:10;
+} HV_Recipient;
+
+/** Send a message to a set of recipients.
+ *
+ *  This routine sends a message to a set of recipients.
+ *
+ *  recips is an array of HV_Recipient structures.  Each specifies a tile,
+ *  and a message state; initially, it is expected that the state will
+ *  be set to HV_TO_BE_SENT.  nrecip specifies the number of recipients
+ *  in the recips array.
+ *
+ *  For each recipient whose state is HV_TO_BE_SENT, the hypervisor attempts
+ *  to send that tile the specified message.  In order to successfully
+ *  receive the message, the receiver must be a valid tile to which the
+ *  sender has access, must not be the sending tile itself, and must have
+ *  sufficient free buffer space.  (The hypervisor guarantees that each
+ *  tile which has called hv_register_message_state() will be able to
+ *  buffer one message from every other tile which can legally send to it;
+ *  more space may be provided but is not guaranteed.)  If an invalid tile
+ *  is specified, the recipient's state is set to HV_BAD_RECIP; this is a
+ *  permanent delivery error.  If the message is successfully delivered
+ *  to the recipient's buffer, the recipient's state is set to HV_SENT.
+ *  Otherwise, the recipient's state is unchanged.  Message delivery is
+ *  synchronous; all attempts to send messages are completed before this
+ *  routine returns.
+ *
+ *  If no permanent delivery errors were encountered, the routine returns
+ *  the number of messages successfully sent: that is, the number of
+ *  recipients whose states changed from HV_TO_BE_SENT to HV_SENT during
+ *  this operation.  If any permanent delivery errors were encountered,
+ *  the routine returns HV_ERECIP.  In the event of permanent delivery
+ *  errors, it may be the case that delivery was not attempted to all
+ *  recipients; if any messages were succesfully delivered, however,
+ *  recipients' state values will be updated appropriately.
+ *
+ *  It is explicitly legal to specify a recipient structure whose state
+ *  is not HV_TO_BE_SENT; such a recipient is ignored.  One suggested way
+ *  of using hv_send_message to send a message to multiple tiles is to set
+ *  up a list of recipients, and then call the routine repeatedly with the
+ *  same list, each time accumulating the number of messages successfully
+ *  sent, until all messages are sent, a permanent error is encountered,
+ *  or the desired number of attempts have been made.  When used in this
+ *  way, the routine will deliver each message no more than once to each
+ *  recipient.
+ *
+ *  Note that a message being successfully delivered to the recipient's
+ *  buffer space does not guarantee that it is received by the recipient,
+ *  either immediately or at any time in the future; the recipient might
+ *  never call hv_receive_message, or could register a different state
+ *  buffer, losing the message.
+ *
+ *  Specifiying the same recipient more than once in the recipient list
+ *  is an error, which will not result in an error return but which may
+ *  or may not result in more than one message being delivered to the
+ *  recipient tile.
+ *
+ *  buf and buflen specify the message to be sent.  buf is a virtual address
+ *  which must be currently mapped in the client's page table; if not, the
+ *  routine returns HV_EFAULT.  buflen must be greater than zero and less
+ *  than or equal to HV_MAX_MESSAGE_SIZE, and nrecip must be less than the
+ *  number of tiles to which the sender has access; if not, the routine
+ *  returns HV_EINVAL.
+ * @param recips List of recipients.
+ * @param nrecip Number of recipients.
+ * @param buf Address of message data.
+ * @param buflen Length of message data.
+ **/
+int hv_send_message(HV_Recipient *recips, int nrecip,
+                    HV_VirtAddr buf, int buflen);
+
+/** Maximum hypervisor message size, in bytes */
+#define HV_MAX_MESSAGE_SIZE 28
+
+
+/** Return value from hv_receive_message() */
+typedef struct
+{
+  int msglen;     /**< Message length in bytes, or an error code */
+  __hv32 source;  /**< Code identifying message sender (HV_MSG_xxx) */
+} HV_RcvMsgInfo;
+
+#define HV_MSG_TILE 0x0         /**< Message source is another tile */
+#define HV_MSG_INTR 0x1         /**< Message source is a driver interrupt */
+
+/** Receive a message.
+ *
+ * This routine retrieves a message from the client's incoming message
+ * buffer.
+ *
+ * Multiple messages sent from a particular sending tile to a particular
+ * receiving tile are received in the order that they were sent; however,
+ * no ordering is guaranteed between messages sent by different tiles.
+ *
+ * Whenever the a client's message buffer is empty, the first message
+ * subsequently received will cause the client's MESSAGE_RCV_DWNCL
+ * interrupt vector to be invoked through the interrupt downcall mechanism
+ * (see the description of the hv_downcall_dispatch() routine for details
+ * on downcalls).
+ *
+ * Another message-available downcall will not occur until a call to
+ * this routine is made when the message buffer is empty, and a message
+ * subsequently arrives.  Note that such a downcall could occur while
+ * this routine is executing.  If the calling code does not wish this
+ * to happen, it is recommended that this routine be called with the
+ * INTCTRL_1 interrupt masked, or inside an interrupt critical section.
+ *
+ * msgstate is the value previously passed to hv_register_message_state().
+ * buf is the virtual address of the buffer into which the message will
+ * be written; buflen is the length of the buffer.
+ *
+ * This routine returns an HV_RcvMsgInfo structure.  The msglen member
+ * of that structure is the length of the message received, zero if no
+ * message is available, or HV_E2BIG if the message is too large for the
+ * specified buffer.  If the message is too large, it is not consumed,
+ * and may be retrieved by a subsequent call to this routine specifying
+ * a sufficiently large buffer.  A buffer which is HV_MAX_MESSAGE_SIZE
+ * bytes long is guaranteed to be able to receive any possible message.
+ *
+ * The source member of the HV_RcvMsgInfo structure describes the sender
+ * of the message.  For messages sent by another client tile via an
+ * hv_send_message() call, this value is HV_MSG_TILE; for messages sent
+ * as a result of a device interrupt, this value is HV_MSG_INTR.
+ */
+
+HV_RcvMsgInfo hv_receive_message(HV_MsgState msgstate, HV_VirtAddr buf,
+                                 int buflen);
+
+
+/** Start remaining tiles owned by this supervisor.  Initially, only one tile
+ *  executes the client program; after it calls this service, the other tiles
+ *  are started.  This allows the initial tile to do one-time configuration
+ *  of shared data structures without having to lock them against simultaneous
+ *  access.
+ */
+void hv_start_all_tiles(void);
+
+
+/** Open a hypervisor device.
+ *
+ *  This service initializes an I/O device and its hypervisor driver software,
+ *  and makes it available for use.  The open operation is per-device per-chip;
+ *  once it has been performed, the device handle returned may be used in other
+ *  device services calls made by any tile.
+ *
+ * @param name Name of the device.  A base device name is just a text string
+ *        (say, "pcie").  If there is more than one instance of a device, the
+ *        base name is followed by a slash and a device number (say, "pcie/0").
+ *        Some devices may support further structure beneath those components;
+ *        most notably, devices which require control operations do so by
+ *        supporting reads and/or writes to a control device whose name
+ *        includes a trailing "/ctl" (say, "pcie/0/ctl").
+ * @param flags Flags (HV_DEV_xxx).
+ * @return A positive integer device handle, or a negative error code.
+ */
+int hv_dev_open(HV_VirtAddr name, __hv32 flags);
+
+
+/** Close a hypervisor device.
+ *
+ *  This service uninitializes an I/O device and its hypervisor driver
+ *  software, and makes it unavailable for use.  The close operation is
+ *  per-device per-chip; once it has been performed, the device is no longer
+ *  available.  Normally there is no need to ever call the close service.
+ *
+ * @param devhdl Device handle of the device to be closed.
+ * @return Zero if the close is successful, otherwise, a negative error code.
+ */
+int hv_dev_close(int devhdl);
+
+
+/** Read data from a hypervisor device synchronously.
+ *
+ *  This service transfers data from a hypervisor device to a memory buffer.
+ *  When the service returns, the data has been written from the memory buffer,
+ *  and the buffer will not be further modified by the driver.
+ *
+ *  No ordering is guaranteed between requests issued from different tiles.
+ *
+ *  Devices may choose to support both the synchronous and asynchronous read
+ *  operations, only one of them, or neither of them.
+ *
+ * @param devhdl Device handle of the device to be read from.
+ * @param flags Flags (HV_DEV_xxx).
+ * @param va Virtual address of the target data buffer.  This buffer must
+ *        be mapped in the currently installed page table; if not, HV_EFAULT
+ *        may be returned.
+ * @param len Number of bytes to be transferred.
+ * @param offset Driver-dependent offset.  For a random-access device, this is
+ *        often a byte offset from the beginning of the device; in other cases,
+ *        like on a control device, it may have a different meaning.
+ * @return A non-negative value if the read was at least partially successful;
+ *         otherwise, a negative error code.  The precise interpretation of
+ *         the return value is driver-dependent, but many drivers will return
+ *         the number of bytes successfully transferred.
+ */
+int hv_dev_pread(int devhdl, __hv32 flags, HV_VirtAddr va, __hv32 len,
+                 __hv64 offset);
+
+#define HV_DEV_NB_EMPTY     0x1   /**< Don't block when no bytes of data can
+                                       be transferred. */
+#define HV_DEV_NB_PARTIAL   0x2   /**< Don't block when some bytes, but not all
+                                       of the requested bytes, can be
+                                       transferred. */
+#define HV_DEV_NOCACHE      0x4   /**< The caller warrants that none of the
+                                       cache lines which might contain data
+                                       from the requested buffer are valid.
+                                       Useful with asynchronous operations
+                                       only. */
+
+#define HV_DEV_ALLFLAGS     (HV_DEV_NB_EMPTY | HV_DEV_NB_PARTIAL | \
+                             HV_DEV_NOCACHE)   /**< All HV_DEV_xxx flags */
+
+/** Write data to a hypervisor device synchronously.
+ *
+ *  This service transfers data from a memory buffer to a hypervisor device.
+ *  When the service returns, the data has been read from the memory buffer,
+ *  and the buffer may be overwritten by the client; the data may not
+ *  necessarily have been conveyed to the actual hardware I/O interface.
+ *
+ *  No ordering is guaranteed between requests issued from different tiles.
+ *
+ *  Devices may choose to support both the synchronous and asynchronous write
+ *  operations, only one of them, or neither of them.
+ *
+ * @param devhdl Device handle of the device to be written to.
+ * @param flags Flags (HV_DEV_xxx).
+ * @param va Virtual address of the source data buffer.  This buffer must
+ *        be mapped in the currently installed page table; if not, HV_EFAULT
+ *        may be returned.
+ * @param len Number of bytes to be transferred.
+ * @param offset Driver-dependent offset.  For a random-access device, this is
+ *        often a byte offset from the beginning of the device; in other cases,
+ *        like on a control device, it may have a different meaning.
+ * @return A non-negative value if the write was at least partially successful;
+ *         otherwise, a negative error code.  The precise interpretation of
+ *         the return value is driver-dependent, but many drivers will return
+ *         the number of bytes successfully transferred.
+ */
+int hv_dev_pwrite(int devhdl, __hv32 flags, HV_VirtAddr va, __hv32 len,
+                  __hv64 offset);
+
+
+/** Interrupt arguments, used in the asynchronous I/O interfaces. */
+#if CHIP_VA_WIDTH() > 32
+typedef __hv64 HV_IntArg;
+#else
+typedef __hv32 HV_IntArg;
+#endif
+
+/** Interrupt messages are delivered via the mechanism as normal messages,
+ *  but have a message source of HV_DEV_INTR.  The message is formatted
+ *  as an HV_IntrMsg structure.
+ */
+
+typedef struct
+{
+  HV_IntArg intarg;  /**< Interrupt argument, passed to the poll/preada/pwritea
+                          services */
+  HV_IntArg intdata; /**< Interrupt-specific interrupt data */
+} HV_IntrMsg;
+
+/** Request an interrupt message when a device condition is satisfied.
+ *
+ *  This service requests that an interrupt message be delivered to the
+ *  requesting tile when a device becomes readable or writable, or when any
+ *  data queued to the device via previous write operations from this tile
+ *  has been actually sent out on the hardware I/O interface.  Devices may
+ *  choose to support any, all, or none of the available conditions.
+ *
+ *  If multiple conditions are specified, only one message will be
+ *  delivered.  If the event mask delivered to that interrupt handler
+ *  indicates that some of the conditions have not yet occurred, the
+ *  client must issue another poll() call if it wishes to wait for those
+ *  conditions.
+ *
+ *  Only one poll may be outstanding per device handle per tile.  If more than
+ *  one tile is polling on the same device and condition, they will all be
+ *  notified when it happens.  Because of this, clients may not assume that
+ *  the condition signaled is necessarily still true when they request a
+ *  subsequent service; for instance, the readable data which caused the
+ *  poll call to interrupt may have been read by another tile in the interim.
+ *
+ *  The notification interrupt message could come directly, or via the
+ *  downcall (intctrl1) method, depending on what the tile is doing
+ *  when the condition is satisfied.  Note that it is possible for the
+ *  requested interrupt to be delivered after this service is called but
+ *  before it returns.
+ *
+ * @param devhdl Device handle of the device to be polled.
+ * @param events Flags denoting the events which will cause the interrupt to
+ *        be delivered (HV_DEVPOLL_xxx).
+ * @param intarg Value which will be delivered as the intarg member of the
+ *        eventual interrupt message; the intdata member will be set to a
+ *        mask of HV_DEVPOLL_xxx values indicating which conditions have been
+ *        satisifed.
+ * @return Zero if the interrupt was successfully scheduled; otherwise, a
+ *         negative error code.
+ */
+int hv_dev_poll(int devhdl, __hv32 events, HV_IntArg intarg);
+
+#define HV_DEVPOLL_READ     0x1   /**< Test device for readability */
+#define HV_DEVPOLL_WRITE    0x2   /**< Test device for writability */
+#define HV_DEVPOLL_FLUSH    0x4   /**< Test device for output drained */
+
+
+/** Cancel a request for an interrupt when a device event occurs.
+ *
+ *  This service requests that no interrupt be delivered when the events
+ *  noted in the last-issued poll() call happen.  Once this service returns,
+ *  the interrupt has been canceled; however, it is possible for the interrupt
+ *  to be delivered after this service is called but before it returns.
+ *
+ * @param devhdl Device handle of the device on which to cancel polling.
+ * @return Zero if the poll was successfully canceled; otherwise, a negative
+ *         error code.
+ */
+int hv_dev_poll_cancel(int devhdl);
+
+
+/** Scatter-gather list for preada/pwritea calls. */
+typedef struct
+#if CHIP_VA_WIDTH() <= 32
+__attribute__ ((packed, aligned(4)))
+#endif
+{
+  HV_PhysAddr pa;  /**< Client physical address of the buffer segment. */
+  HV_PTE pte;      /**< Page table entry describing the caching and location
+                        override characteristics of the buffer segment.  Some
+                        drivers ignore this element and will require that
+                        the NOCACHE flag be set on their requests. */
+  __hv32 len;      /**< Length of the buffer segment. */
+} HV_SGL;
+
+#define HV_SGL_MAXLEN 16  /**< Maximum number of entries in a scatter-gather
+                               list */
+
+/** Read data from a hypervisor device asynchronously.
+ *
+ *  This service transfers data from a hypervisor device to a memory buffer.
+ *  When the service returns, the read has been scheduled.  When the read
+ *  completes, an interrupt message will be delivered, and the buffer will
+ *  not be further modified by the driver.
+ *
+ *  The number of possible outstanding asynchronous requests is defined by
+ *  each driver, but it is recommended that it be at least two requests
+ *  per tile per device.
+ *
+ *  No ordering is guaranteed between synchronous and asynchronous requests,
+ *  even those issued on the same tile.
+ *
+ *  The completion interrupt message could come directly, or via the downcall
+ *  (intctrl1) method, depending on what the tile is doing when the read
+ *  completes.  Interrupts do not coalesce; one is delivered for each
+ *  asynchronous I/O request.  Note that it is possible for the requested
+ *  interrupt to be delivered after this service is called but before it
+ *  returns.
+ *
+ *  Devices may choose to support both the synchronous and asynchronous read
+ *  operations, only one of them, or neither of them.
+ *
+ * @param devhdl Device handle of the device to be read from.
+ * @param flags Flags (HV_DEV_xxx).
+ * @param sgl_len Number of elements in the scatter-gather list.
+ * @param sgl Scatter-gather list describing the memory to which data will be
+ *        written.
+ * @param offset Driver-dependent offset.  For a random-access device, this is
+ *        often a byte offset from the beginning of the device; in other cases,
+ *        like on a control device, it may have a different meaning.
+ * @param intarg Value which will be delivered as the intarg member of the
+ *        eventual interrupt message; the intdata member will be set to the
+ *        normal return value from the read request.
+ * @return Zero if the read was successfully scheduled; otherwise, a negative
+ *         error code.  Note that some drivers may choose to pre-validate
+ *         their arguments, and may thus detect certain device error
+ *         conditions at this time rather than when the completion notification
+ *         occurs, but this is not required.
+ */
+int hv_dev_preada(int devhdl, __hv32 flags, __hv32 sgl_len,
+                  HV_SGL sgl[/* sgl_len */], __hv64 offset, HV_IntArg intarg);
+
+
+/** Write data to a hypervisor device asynchronously.
+ *
+ *  This service transfers data from a memory buffer to a hypervisor
+ *  device.  When the service returns, the write has been scheduled.
+ *  When the write completes, an interrupt message will be delivered,
+ *  and the buffer may be overwritten by the client; the data may not
+ *  necessarily have been conveyed to the actual hardware I/O interface.
+ *
+ *  The number of possible outstanding asynchronous requests is defined by
+ *  each driver, but it is recommended that it be at least two requests
+ *  per tile per device.
+ *
+ *  No ordering is guaranteed between synchronous and asynchronous requests,
+ *  even those issued on the same tile.
+ *
+ *  The completion interrupt message could come directly, or via the downcall
+ *  (intctrl1) method, depending on what the tile is doing when the read
+ *  completes.  Interrupts do not coalesce; one is delivered for each
+ *  asynchronous I/O request.  Note that it is possible for the requested
+ *  interrupt to be delivered after this service is called but before it
+ *  returns.
+ *
+ *  Devices may choose to support both the synchronous and asynchronous write
+ *  operations, only one of them, or neither of them.
+ *
+ * @param devhdl Device handle of the device to be read from.
+ * @param flags Flags (HV_DEV_xxx).
+ * @param sgl_len Number of elements in the scatter-gather list.
+ * @param sgl Scatter-gather list describing the memory from which data will be
+ *        read.
+ * @param offset Driver-dependent offset.  For a random-access device, this is
+ *        often a byte offset from the beginning of the device; in other cases,
+ *        like on a control device, it may have a different meaning.
+ * @param intarg Value which will be delivered as the intarg member of the
+ *        eventual interrupt message; the intdata member will be set to the
+ *        normal return value from the write request.
+ * @return Zero if the write was successfully scheduled; otherwise, a negative
+ *         error code.  Note that some drivers may choose to pre-validate
+ *         their arguments, and may thus detect certain device error
+ *         conditions at this time rather than when the completion notification
+ *         occurs, but this is not required.
+ */
+int hv_dev_pwritea(int devhdl, __hv32 flags, __hv32 sgl_len,
+                   HV_SGL sgl[/* sgl_len */], __hv64 offset, HV_IntArg intarg);
+
+
+/** Define a pair of tile and ASID to identify a user process context. */
+typedef struct
+{
+  /** X coordinate, relative to supervisor's top-left coordinate */
+  unsigned int x:11;
+
+  /** Y coordinate, relative to supervisor's top-left coordinate */
+  unsigned int y:11;
+
+  /** ASID of the process on this x,y tile */
+  HV_ASID asid:10;
+} HV_Remote_ASID;
+
+/** Flush cache and/or TLB state on remote tiles.
+ *
+ * @param cache_pa Client physical address to flush from cache (ignored if
+ *        the length encoded in cache_control is zero, or if
+ *        HV_FLUSH_EVICT_L2 is set, or if cache_cpumask is NULL).
+ * @param cache_control This argument allows you to specify a length of
+ *        physical address space to flush (maximum HV_FLUSH_MAX_CACHE_LEN).
+ *        You can "or" in HV_FLUSH_EVICT_L2 to flush the whole L2 cache.
+ *        You can "or" in HV_FLUSH_EVICT_LI1 to flush the whole LII cache.
+ *        HV_FLUSH_ALL flushes all caches.
+ * @param cache_cpumask Bitmask (in row-major order, supervisor-relative) of
+ *        tile indices to perform cache flush on.  The low bit of the first
+ *        word corresponds to the tile at the upper left-hand corner of the
+ *        supervisor's rectangle.  If passed as a NULL pointer, equivalent
+ *        to an empty bitmask.  On chips which support hash-for-home caching,
+ *        if passed as -1, equivalent to a mask containing tiles which could
+ *        be doing hash-for-home caching.
+ * @param tlb_va Virtual address to flush from TLB (ignored if
+ *        tlb_length is zero or tlb_cpumask is NULL).
+ * @param tlb_length Number of bytes of data to flush from the TLB.
+ * @param tlb_pgsize Page size to use for TLB flushes.
+ *        tlb_va and tlb_length need not be aligned to this size.
+ * @param tlb_cpumask Bitmask for tlb flush, like cache_cpumask.
+ *        If passed as a NULL pointer, equivalent to an empty bitmask.
+ * @param asids Pointer to an HV_Remote_ASID array of tile/ASID pairs to flush.
+ * @param asidcount Number of HV_Remote_ASID entries in asids[].
+ * @return Zero for success, or else HV_EINVAL or HV_EFAULT for errors that
+ *        are detected while parsing the arguments.
+ */
+int hv_flush_remote(HV_PhysAddr cache_pa, unsigned long cache_control,
+                    unsigned long* cache_cpumask,
+                    HV_VirtAddr tlb_va, unsigned long tlb_length,
+                    unsigned long tlb_pgsize, unsigned long* tlb_cpumask,
+                    HV_Remote_ASID* asids, int asidcount);
+
+/** Include in cache_control to ensure a flush of the entire L2. */
+#define HV_FLUSH_EVICT_L2 (1UL << 31)
+
+/** Include in cache_control to ensure a flush of the entire L1I. */
+#define HV_FLUSH_EVICT_L1I (1UL << 30)
+
+/** Maximum legal size to use for the "length" component of cache_control. */
+#define HV_FLUSH_MAX_CACHE_LEN ((1UL << 30) - 1)
+
+/** Use for cache_control to ensure a flush of all caches. */
+#define HV_FLUSH_ALL -1UL
+
+#else   /* __ASSEMBLER__ */
+
+/** Include in cache_control to ensure a flush of the entire L2. */
+#define HV_FLUSH_EVICT_L2 (1 << 31)
+
+/** Include in cache_control to ensure a flush of the entire L1I. */
+#define HV_FLUSH_EVICT_L1I (1 << 30)
+
+/** Maximum legal size to use for the "length" component of cache_control. */
+#define HV_FLUSH_MAX_CACHE_LEN ((1 << 30) - 1)
+
+/** Use for cache_control to ensure a flush of all caches. */
+#define HV_FLUSH_ALL -1
+
+#endif  /* __ASSEMBLER__ */
+
+#ifndef __ASSEMBLER__
+
+/** Return a 64-bit value corresponding to the PTE if needed */
+#define hv_pte_val(pte) ((pte).val)
+
+/** Cast a 64-bit value to an HV_PTE */
+#define hv_pte(val) ((HV_PTE) { val })
+
+#endif  /* !__ASSEMBLER__ */
+
+
+/** Bits in the size of an HV_PTE */
+#define HV_LOG2_PTE_SIZE 3
+
+/** Size of an HV_PTE */
+#define HV_PTE_SIZE (1 << HV_LOG2_PTE_SIZE)
+
+
+/* Bits in HV_PTE's low word. */
+#define HV_PTE_INDEX_PRESENT          0  /**< PTE is valid */
+#define HV_PTE_INDEX_MIGRATING        1  /**< Page is migrating */
+#define HV_PTE_INDEX_CLIENT0          2  /**< Page client state 0 */
+#define HV_PTE_INDEX_CLIENT1          3  /**< Page client state 1 */
+#define HV_PTE_INDEX_NC               4  /**< L1$/L2$ incoherent with L3$ */
+#define HV_PTE_INDEX_NO_ALLOC_L1      5  /**< Page is uncached in local L1$ */
+#define HV_PTE_INDEX_NO_ALLOC_L2      6  /**< Page is uncached in local L2$ */
+#define HV_PTE_INDEX_CACHED_PRIORITY  7  /**< Page is priority cached */
+#define HV_PTE_INDEX_PAGE             8  /**< PTE describes a page */
+#define HV_PTE_INDEX_GLOBAL           9  /**< Page is global */
+#define HV_PTE_INDEX_USER            10  /**< Page is user-accessible */
+#define HV_PTE_INDEX_ACCESSED        11  /**< Page has been accessed */
+#define HV_PTE_INDEX_DIRTY           12  /**< Page has been written */
+                                         /*   Bits 13-15 are reserved for
+                                              future use. */
+#define HV_PTE_INDEX_MODE            16  /**< Page mode; see HV_PTE_MODE_xxx */
+#define HV_PTE_MODE_BITS              3  /**< Number of bits in mode */
+                                         /*   Bit 19 is reserved for
+                                              future use. */
+#define HV_PTE_INDEX_LOTAR           20  /**< Page's LOTAR; must be high bits
+                                              of word */
+#define HV_PTE_LOTAR_BITS            12  /**< Number of bits in a LOTAR */
+
+/* Bits in HV_PTE's high word. */
+#define HV_PTE_INDEX_READABLE        32  /**< Page is readable */
+#define HV_PTE_INDEX_WRITABLE        33  /**< Page is writable */
+#define HV_PTE_INDEX_EXECUTABLE      34  /**< Page is executable */
+#define HV_PTE_INDEX_PTFN            35  /**< Page's PTFN; must be high bits
+                                              of word */
+#define HV_PTE_PTFN_BITS             29  /**< Number of bits in a PTFN */
+
+/** Position of the PFN field within the PTE (subset of the PTFN). */
+#define HV_PTE_INDEX_PFN (HV_PTE_INDEX_PTFN + (HV_LOG2_PAGE_SIZE_SMALL - \
+                                               HV_LOG2_PAGE_TABLE_ALIGN))
+
+/** Length of the PFN field within the PTE (subset of the PTFN). */
+#define HV_PTE_INDEX_PFN_BITS (HV_PTE_INDEX_PTFN_BITS - \
+                               (HV_LOG2_PAGE_SIZE_SMALL - \
+                                HV_LOG2_PAGE_TABLE_ALIGN))
+
+/*
+ * Legal values for the PTE's mode field
+ */
+/** Data is not resident in any caches; loads and stores access memory
+ *  directly.
+ */
+#define HV_PTE_MODE_UNCACHED          1
+
+/** Data is resident in the tile's local L1 and/or L2 caches; if a load
+ *  or store misses there, it goes to memory.
+ *
+ *  The copy in the local L1$/L2$ is not invalidated when the copy in
+ *  memory is changed.
+ */
+#define HV_PTE_MODE_CACHE_NO_L3       2
+
+/** Data is resident in the tile's local L1 and/or L2 caches.  If a load
+ *  or store misses there, it goes to an L3 cache in a designated tile;
+ *  if it misses there, it goes to memory.
+ *
+ *  If the NC bit is not set, the copy in the local L1$/L2$ is invalidated
+ *  when the copy in the remote L3$ is changed.  Otherwise, such
+ *  invalidation will not occur.
+ *
+ *  Chips for which CHIP_HAS_COHERENT_LOCAL_CACHE() is 0 do not support
+ *  invalidation from an L3$ to another tile's L1$/L2$.  If the NC bit is
+ *  clear on such a chip, no copy is kept in the local L1$/L2$ in this mode.
+ */
+#define HV_PTE_MODE_CACHE_TILE_L3     3
+
+/** Data is resident in the tile's local L1 and/or L2 caches.  If a load
+ *  or store misses there, it goes to an L3 cache in one of a set of
+ *  designated tiles; if it misses there, it goes to memory.  Which tile
+ *  is chosen from the set depends upon a hash function applied to the
+ *  physical address.  This mode is not supported on chips for which
+ *  CHIP_HAS_CBOX_HOME_MAP() is 0.
+ *
+ *  If the NC bit is not set, the copy in the local L1$/L2$ is invalidated
+ *  when the copy in the remote L3$ is changed.  Otherwise, such
+ *  invalidation will not occur.
+ *
+ *  Chips for which CHIP_HAS_COHERENT_LOCAL_CACHE() is 0 do not support
+ *  invalidation from an L3$ to another tile's L1$/L2$.  If the NC bit is
+ *  clear on such a chip, no copy is kept in the local L1$/L2$ in this mode.
+ */
+#define HV_PTE_MODE_CACHE_HASH_L3     4
+
+/** Data is not resident in memory; accesses are instead made to an I/O
+ *  device, whose tile coordinates are given by the PTE's LOTAR field.
+ *  This mode is only supported on chips for which CHIP_HAS_MMIO() is 1.
+ *  The EXECUTABLE bit may not be set in an MMIO PTE.
+ */
+#define HV_PTE_MODE_MMIO              5
+
+
+/* C wants 1ULL so it is typed as __hv64, but the assembler needs just numbers.
+ * The assembler can't handle shifts greater than 31, but treats them
+ * as shifts mod 32, so assembler code must be aware of which word
+ * the bit belongs in when using these macros.
+ */
+#ifdef __ASSEMBLER__
+#define __HV_PTE_ONE 1        /**< One, for assembler */
+#else
+#define __HV_PTE_ONE 1ULL     /**< One, for C */
+#endif
+
+/** Is this PTE present?
+ *
+ * If this bit is set, this PTE represents a valid translation or level-2
+ * page table pointer.  Otherwise, the page table does not contain a
+ * translation for the subject virtual pages.
+ *
+ * If this bit is not set, the other bits in the PTE are not
+ * interpreted by the hypervisor, and may contain any value.
+ */
+#define HV_PTE_PRESENT               (__HV_PTE_ONE << HV_PTE_INDEX_PRESENT)
+
+/** Does this PTE map a page?
+ *
+ * If this bit is set in the level-1 page table, the entry should be
+ * interpreted as a level-2 page table entry mapping a large page.
+ *
+ * This bit should not be modified by the client while PRESENT is set, as
+ * doing so may race with the hypervisor's update of ACCESSED and DIRTY bits.
+ *
+ * In a level-2 page table, this bit is ignored and must be zero.
+ */
+#define HV_PTE_PAGE                  (__HV_PTE_ONE << HV_PTE_INDEX_PAGE)
+
+/** Is this a global (non-ASID) mapping?
+ *
+ * If this bit is set, the translations established by this PTE will
+ * not be flushed from the TLB by the hv_flush_asid() service; they
+ * will be flushed by the hv_flush_page() or hv_flush_pages() services.
+ *
+ * Setting this bit for translations which are identical in all page
+ * tables (for instance, code and data belonging to a client OS) can
+ * be very beneficial, as it will reduce the number of TLB misses.
+ * Note that, while it is not an error which will be detected by the
+ * hypervisor, it is an extremely bad idea to set this bit for
+ * translations which are _not_ identical in all page tables.
+ *
+ * This bit should not be modified by the client while PRESENT is set, as
+ * doing so may race with the hypervisor's update of ACCESSED and DIRTY bits.
+ *
+ * This bit is ignored in level-1 PTEs unless the Page bit is set.
+ */
+#define HV_PTE_GLOBAL                (__HV_PTE_ONE << HV_PTE_INDEX_GLOBAL)
+
+/** Is this mapping accessible to users?
+ *
+ * If this bit is set, code running at any PL will be permitted to
+ * access the virtual addresses mapped by this PTE.  Otherwise, only
+ * code running at PL 1 or above will be allowed to do so.
+ *
+ * This bit should not be modified by the client while PRESENT is set, as
+ * doing so may race with the hypervisor's update of ACCESSED and DIRTY bits.
+ *
+ * This bit is ignored in level-1 PTEs unless the Page bit is set.
+ */
+#define HV_PTE_USER                  (__HV_PTE_ONE << HV_PTE_INDEX_USER)
+
+/** Has this mapping been accessed?
+ *
+ * This bit is set by the hypervisor when the memory described by the
+ * translation is accessed for the first time.  It is never cleared by
+ * the hypervisor, but may be cleared by the client.  After the bit
+ * has been cleared, subsequent references are not guaranteed to set
+ * it again until the translation has been flushed from the TLB.
+ *
+ * This bit is ignored in level-1 PTEs unless the Page bit is set.
+ */
+#define HV_PTE_ACCESSED              (__HV_PTE_ONE << HV_PTE_INDEX_ACCESSED)
+
+/** Is this mapping dirty?
+ *
+ * This bit is set by the hypervisor when the memory described by the
+ * translation is written for the first time.  It is never cleared by
+ * the hypervisor, but may be cleared by the client.  After the bit
+ * has been cleared, subsequent references are not guaranteed to set
+ * it again until the translation has been flushed from the TLB.
+ *
+ * This bit is ignored in level-1 PTEs unless the Page bit is set.
+ */
+#define HV_PTE_DIRTY                 (__HV_PTE_ONE << HV_PTE_INDEX_DIRTY)
+
+/** Migrating bit in PTE.
+ *
+ * This bit is guaranteed not to be inspected or modified by the
+ * hypervisor.  The name is indicative of the suggested use by the client
+ * to tag pages whose L3 cache is being migrated from one cpu to another.
+ */
+#define HV_PTE_MIGRATING             (__HV_PTE_ONE << HV_PTE_INDEX_MIGRATING)
+
+/** Client-private bit in PTE.
+ *
+ * This bit is guaranteed not to be inspected or modified by the
+ * hypervisor.
+ */
+#define HV_PTE_CLIENT0               (__HV_PTE_ONE << HV_PTE_INDEX_CLIENT0)
+
+/** Client-private bit in PTE.
+ *
+ * This bit is guaranteed not to be inspected or modified by the
+ * hypervisor.
+ */
+#define HV_PTE_CLIENT1               (__HV_PTE_ONE << HV_PTE_INDEX_CLIENT1)
+
+/** Non-coherent (NC) bit in PTE.
+ *
+ * If this bit is set, the mapping that is set up will be non-coherent
+ * (also known as non-inclusive).  This means that changes to the L3
+ * cache will not cause a local copy to be invalidated.  It is generally
+ * recommended only for read-only mappings.
+ *
+ * In level-1 PTEs, if the Page bit is clear, this bit determines how the
+ * level-2 page table is accessed.
+ */
+#define HV_PTE_NC                    (__HV_PTE_ONE << HV_PTE_INDEX_NC)
+
+/** Is this page prevented from filling the L1$?
+ *
+ * If this bit is set, the page described by the PTE will not be cached
+ * the local cpu's L1 cache.
+ *
+ * If CHIP_HAS_NC_AND_NOALLOC_BITS() is not true in <chip.h> for this chip,
+ * it is illegal to use this attribute, and may cause client termination.
+ *
+ * In level-1 PTEs, if the Page bit is clear, this bit
+ * determines how the level-2 page table is accessed.
+ */
+#define HV_PTE_NO_ALLOC_L1           (__HV_PTE_ONE << HV_PTE_INDEX_NO_ALLOC_L1)
+
+/** Is this page prevented from filling the L2$?
+ *
+ * If this bit is set, the page described by the PTE will not be cached
+ * the local cpu's L2 cache.
+ *
+ * If CHIP_HAS_NC_AND_NOALLOC_BITS() is not true in <chip.h> for this chip,
+ * it is illegal to use this attribute, and may cause client termination.
+ *
+ * In level-1 PTEs, if the Page bit is clear, this bit determines how the
+ * level-2 page table is accessed.
+ */
+#define HV_PTE_NO_ALLOC_L2           (__HV_PTE_ONE << HV_PTE_INDEX_NO_ALLOC_L2)
+
+/** Is this a priority page?
+ *
+ * If this bit is set, the page described by the PTE will be given
+ * priority in the cache.  Normally this translates into allowing the
+ * page to use only the "red" half of the cache.  The client may wish to
+ * then use the hv_set_caching service to specify that other pages which
+ * alias this page will use only the "black" half of the cache.
+ *
+ * If the Cached Priority bit is clear, the hypervisor uses the
+ * current hv_set_caching() value to choose how to cache the page.
+ *
+ * It is illegal to set the Cached Priority bit if the Non-Cached bit
+ * is set and the Cached Remotely bit is clear, i.e. if requests to
+ * the page map directly to memory.
+ *
+ * This bit is ignored in level-1 PTEs unless the Page bit is set.
+ */
+#define HV_PTE_CACHED_PRIORITY       (__HV_PTE_ONE << \
+                                      HV_PTE_INDEX_CACHED_PRIORITY)
+
+/** Is this a readable mapping?
+ *
+ * If this bit is set, code will be permitted to read from (e.g.,
+ * issue load instructions against) the virtual addresses mapped by
+ * this PTE.
+ *
+ * It is illegal for this bit to be clear if the Writable bit is set.
+ *
+ * This bit is ignored in level-1 PTEs unless the Page bit is set.
+ */
+#define HV_PTE_READABLE              (__HV_PTE_ONE << HV_PTE_INDEX_READABLE)
+
+/** Is this a writable mapping?
+ *
+ * If this bit is set, code will be permitted to write to (e.g., issue
+ * store instructions against) the virtual addresses mapped by this
+ * PTE.
+ *
+ * This bit is ignored in level-1 PTEs unless the Page bit is set.
+ */
+#define HV_PTE_WRITABLE              (__HV_PTE_ONE << HV_PTE_INDEX_WRITABLE)
+
+/** Is this an executable mapping?
+ *
+ * If this bit is set, code will be permitted to execute from
+ * (e.g., jump to) the virtual addresses mapped by this PTE.
+ *
+ * This bit applies to any processor on the tile, if there are more
+ * than one.
+ *
+ * This bit is ignored in level-1 PTEs unless the Page bit is set.
+ */
+#define HV_PTE_EXECUTABLE            (__HV_PTE_ONE << HV_PTE_INDEX_EXECUTABLE)
+
+/** The width of a LOTAR's x or y bitfield. */
+#define HV_LOTAR_WIDTH 11
+
+/** Converts an x,y pair to a LOTAR value. */
+#define HV_XY_TO_LOTAR(x, y) ((HV_LOTAR)(((x) << HV_LOTAR_WIDTH) | (y)))
+
+/** Extracts the X component of a lotar. */
+#define HV_LOTAR_X(lotar) ((lotar) >> HV_LOTAR_WIDTH)
+
+/** Extracts the Y component of a lotar. */
+#define HV_LOTAR_Y(lotar) ((lotar) & ((1 << HV_LOTAR_WIDTH) - 1))
+
+#ifndef __ASSEMBLER__
+
+/** Define accessor functions for a PTE bit. */
+#define _HV_BIT(name, bit)                                      \
+static __inline int                                             \
+hv_pte_get_##name(HV_PTE pte)                                   \
+{                                                               \
+  return (pte.val >> HV_PTE_INDEX_##bit) & 1;                   \
+}                                                               \
+                                                                \
+static __inline HV_PTE                                          \
+hv_pte_set_##name(HV_PTE pte)                                   \
+{                                                               \
+  pte.val |= 1ULL << HV_PTE_INDEX_##bit;                        \
+  return pte;                                                   \
+}                                                               \
+                                                                \
+static __inline HV_PTE                                          \
+hv_pte_clear_##name(HV_PTE pte)                                 \
+{                                                               \
+  pte.val &= ~(1ULL << HV_PTE_INDEX_##bit);                     \
+  return pte;                                                   \
+}
+
+/* Generate accessors to get, set, and clear various PTE flags.
+ */
+_HV_BIT(present,         PRESENT)
+_HV_BIT(page,            PAGE)
+_HV_BIT(client0,         CLIENT0)
+_HV_BIT(client1,         CLIENT1)
+_HV_BIT(migrating,       MIGRATING)
+_HV_BIT(nc,              NC)
+_HV_BIT(readable,        READABLE)
+_HV_BIT(writable,        WRITABLE)
+_HV_BIT(executable,      EXECUTABLE)
+_HV_BIT(accessed,        ACCESSED)
+_HV_BIT(dirty,           DIRTY)
+_HV_BIT(no_alloc_l1,     NO_ALLOC_L1)
+_HV_BIT(no_alloc_l2,     NO_ALLOC_L2)
+_HV_BIT(cached_priority, CACHED_PRIORITY)
+_HV_BIT(global,          GLOBAL)
+_HV_BIT(user,            USER)
+
+#undef _HV_BIT
+
+/** Get the page mode from the PTE.
+ *
+ * This field generally determines whether and how accesses to the page
+ * are cached; the HV_PTE_MODE_xxx symbols define the legal values for the
+ * page mode.  The NC, NO_ALLOC_L1, and NO_ALLOC_L2 bits modify this
+ * general policy.
+ */
+static __inline unsigned int
+hv_pte_get_mode(const HV_PTE pte)
+{
+  return (((__hv32) pte.val) >> HV_PTE_INDEX_MODE) &
+         ((1 << HV_PTE_MODE_BITS) - 1);
+}
+
+/** Set the page mode into a PTE.  See hv_pte_get_mode. */
+static __inline HV_PTE
+hv_pte_set_mode(HV_PTE pte, unsigned int val)
+{
+  pte.val &= ~(((1ULL << HV_PTE_MODE_BITS) - 1) << HV_PTE_INDEX_MODE);
+  pte.val |= val << HV_PTE_INDEX_MODE;
+  return pte;
+}
+
+/** Get the page frame number from the PTE.
+ *
+ * This field contains the upper bits of the CPA (client physical
+ * address) of the target page; the complete CPA is this field with
+ * HV_LOG2_PAGE_SIZE_SMALL zero bits appended to it.
+ *
+ * For PTEs in a level-1 page table where the Page bit is set, the
+ * CPA must be aligned modulo the large page size.
+ */
+static __inline unsigned int
+hv_pte_get_pfn(const HV_PTE pte)
+{
+  return pte.val >> HV_PTE_INDEX_PFN;
+}
+
+
+/** Set the page frame number into a PTE.  See hv_pte_get_pfn. */
+static __inline HV_PTE
+hv_pte_set_pfn(HV_PTE pte, unsigned int val)
+{
+  /*
+   * Note that the use of "PTFN" in the next line is intentional; we
+   * don't want any garbage lower bits left in that field.
+   */
+  pte.val &= ~(((1ULL << HV_PTE_PTFN_BITS) - 1) << HV_PTE_INDEX_PTFN);
+  pte.val |= (__hv64) val << HV_PTE_INDEX_PFN;
+  return pte;
+}
+
+/** Get the page table frame number from the PTE.
+ *
+ * This field contains the upper bits of the CPA (client physical
+ * address) of the target page table; the complete CPA is this field with
+ * with HV_PAGE_TABLE_ALIGN zero bits appended to it.
+ *
+ * For PTEs in a level-1 page table when the Page bit is not set, the
+ * CPA must be aligned modulo the sticter of HV_PAGE_TABLE_ALIGN and
+ * the level-2 page table size.
+ */
+static __inline unsigned long
+hv_pte_get_ptfn(const HV_PTE pte)
+{
+  return pte.val >> HV_PTE_INDEX_PTFN;
+}
+
+
+/** Set the page table frame number into a PTE.  See hv_pte_get_ptfn. */
+static __inline HV_PTE
+hv_pte_set_ptfn(HV_PTE pte, unsigned long val)
+{
+  pte.val &= ~(((1ULL << HV_PTE_PTFN_BITS)-1) << HV_PTE_INDEX_PTFN);
+  pte.val |= (__hv64) val << HV_PTE_INDEX_PTFN;
+  return pte;
+}
+
+
+/** Get the remote tile caching this page.
+ *
+ * Specifies the remote tile which is providing the L3 cache for this page.
+ *
+ * This field is ignored unless the page mode is HV_PTE_MODE_CACHE_TILE_L3.
+ *
+ * In level-1 PTEs, if the Page bit is clear, this field determines how the
+ * level-2 page table is accessed.
+ */
+static __inline unsigned int
+hv_pte_get_lotar(const HV_PTE pte)
+{
+  unsigned int lotar = ((__hv32) pte.val) >> HV_PTE_INDEX_LOTAR;
+
+  return HV_XY_TO_LOTAR( (lotar >> (HV_PTE_LOTAR_BITS / 2)),
+                         (lotar & ((1 << (HV_PTE_LOTAR_BITS / 2)) - 1)) );
+}
+
+
+/** Set the remote tile caching a page into a PTE.  See hv_pte_get_lotar. */
+static __inline HV_PTE
+hv_pte_set_lotar(HV_PTE pte, unsigned int val)
+{
+  unsigned int x = HV_LOTAR_X(val);
+  unsigned int y = HV_LOTAR_Y(val);
+
+  pte.val &= ~(((1ULL << HV_PTE_LOTAR_BITS)-1) << HV_PTE_INDEX_LOTAR);
+  pte.val |= (x << (HV_PTE_INDEX_LOTAR + HV_PTE_LOTAR_BITS / 2)) |
+             (y << HV_PTE_INDEX_LOTAR);
+  return pte;
+}
+
+#endif  /* !__ASSEMBLER__ */
+
+/** Converts a client physical address to a pfn. */
+#define HV_CPA_TO_PFN(p) ((p) >> HV_LOG2_PAGE_SIZE_SMALL)
+
+/** Converts a pfn to a client physical address. */
+#define HV_PFN_TO_CPA(p) (((HV_PhysAddr)(p)) << HV_LOG2_PAGE_SIZE_SMALL)
+
+/** Converts a client physical address to a ptfn. */
+#define HV_CPA_TO_PTFN(p) ((p) >> HV_LOG2_PAGE_TABLE_ALIGN)
+
+/** Converts a ptfn to a client physical address. */
+#define HV_PTFN_TO_CPA(p) (((HV_PhysAddr)(p)) << HV_LOG2_PAGE_TABLE_ALIGN)
+
+/** Converts a ptfn to a pfn. */
+#define HV_PTFN_TO_PFN(p) \
+  ((p) >> (HV_LOG2_PAGE_SIZE_SMALL - HV_LOG2_PAGE_TABLE_ALIGN))
+
+/** Converts a pfn to a ptfn. */
+#define HV_PFN_TO_PTFN(p) \
+  ((p) << (HV_LOG2_PAGE_SIZE_SMALL - HV_LOG2_PAGE_TABLE_ALIGN))
+
+#if CHIP_VA_WIDTH() > 32
+
+/** Log number of HV_PTE entries in L0 page table */
+#define HV_LOG2_L0_ENTRIES (CHIP_VA_WIDTH() - HV_LOG2_L1_SPAN)
+
+/** Number of HV_PTE entries in L0 page table */
+#define HV_L0_ENTRIES (1 << HV_LOG2_L0_ENTRIES)
+
+/** Log size of L0 page table in bytes */
+#define HV_LOG2_L0_SIZE (HV_LOG2_PTE_SIZE + HV_LOG2_L0_ENTRIES)
+
+/** Size of L0 page table in bytes */
+#define HV_L0_SIZE (1 << HV_LOG2_L0_SIZE)
+
+#ifdef __ASSEMBLER__
+
+/** Index in L0 for a specific VA */
+#define HV_L0_INDEX(va) \
+  (((va) >> HV_LOG2_L1_SPAN) & (HV_L0_ENTRIES - 1))
+
+#else
+
+/** Index in L1 for a specific VA */
+#define HV_L0_INDEX(va) \
+  (((HV_VirtAddr)(va) >> HV_LOG2_L1_SPAN) & (HV_L0_ENTRIES - 1))
+
+#endif
+
+#endif /* CHIP_VA_WIDTH() > 32 */
+
+/** Log number of HV_PTE entries in L1 page table */
+#define HV_LOG2_L1_ENTRIES (HV_LOG2_L1_SPAN - HV_LOG2_PAGE_SIZE_LARGE)
+
+/** Number of HV_PTE entries in L1 page table */
+#define HV_L1_ENTRIES (1 << HV_LOG2_L1_ENTRIES)
+
+/** Log size of L1 page table in bytes */
+#define HV_LOG2_L1_SIZE (HV_LOG2_PTE_SIZE + HV_LOG2_L1_ENTRIES)
+
+/** Size of L1 page table in bytes */
+#define HV_L1_SIZE (1 << HV_LOG2_L1_SIZE)
+
+/** Log number of HV_PTE entries in level-2 page table */
+#define HV_LOG2_L2_ENTRIES (HV_LOG2_PAGE_SIZE_LARGE - HV_LOG2_PAGE_SIZE_SMALL)
+
+/** Number of HV_PTE entries in level-2 page table */
+#define HV_L2_ENTRIES (1 << HV_LOG2_L2_ENTRIES)
+
+/** Log size of level-2 page table in bytes */
+#define HV_LOG2_L2_SIZE (HV_LOG2_PTE_SIZE + HV_LOG2_L2_ENTRIES)
+
+/** Size of level-2 page table in bytes */
+#define HV_L2_SIZE (1 << HV_LOG2_L2_SIZE)
+
+#ifdef __ASSEMBLER__
+
+#if CHIP_VA_WIDTH() > 32
+
+/** Index in L1 for a specific VA */
+#define HV_L1_INDEX(va) \
+  (((va) >> HV_LOG2_PAGE_SIZE_LARGE) & (HV_L1_ENTRIES - 1))
+
+#else /* CHIP_VA_WIDTH() > 32 */
+
+/** Index in L1 for a specific VA */
+#define HV_L1_INDEX(va) \
+  (((va) >> HV_LOG2_PAGE_SIZE_LARGE))
+
+#endif /* CHIP_VA_WIDTH() > 32 */
+
+/** Index in level-2 page table for a specific VA */
+#define HV_L2_INDEX(va) \
+  (((va) >> HV_LOG2_PAGE_SIZE_SMALL) & (HV_L2_ENTRIES - 1))
+
+#else /* __ASSEMBLER __ */
+
+#if CHIP_VA_WIDTH() > 32
+
+/** Index in L1 for a specific VA */
+#define HV_L1_INDEX(va) \
+  (((HV_VirtAddr)(va) >> HV_LOG2_PAGE_SIZE_LARGE) & (HV_L1_ENTRIES - 1))
+
+#else /* CHIP_VA_WIDTH() > 32 */
+
+/** Index in L1 for a specific VA */
+#define HV_L1_INDEX(va) \
+  (((HV_VirtAddr)(va) >> HV_LOG2_PAGE_SIZE_LARGE))
+
+#endif /* CHIP_VA_WIDTH() > 32 */
+
+/** Index in level-2 page table for a specific VA */
+#define HV_L2_INDEX(va) \
+  (((HV_VirtAddr)(va) >> HV_LOG2_PAGE_SIZE_SMALL) & (HV_L2_ENTRIES - 1))
+
+#endif /* __ASSEMBLER __ */
+
+#endif /* _TILE_HV_H */
diff --git a/arch/tile/include/hv/syscall_public.h b/arch/tile/include/hv/syscall_public.h
new file mode 100644
index 0000000..9cc0837
--- /dev/null
+++ b/arch/tile/include/hv/syscall_public.h
@@ -0,0 +1,42 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+/**
+ * @file syscall.h
+ * Indices for the hypervisor system calls that are intended to be called
+ * directly, rather than only through hypervisor-generated "glue" code.
+ */
+
+#ifndef _SYS_HV_INCLUDE_SYSCALL_PUBLIC_H
+#define _SYS_HV_INCLUDE_SYSCALL_PUBLIC_H
+
+/** Fast syscall flag bit location.  When this bit is set, the hypervisor
+ *  handles the syscall specially.
+ */
+#define HV_SYS_FAST_SHIFT                 14
+
+/** Fast syscall flag bit mask. */
+#define HV_SYS_FAST_MASK                  (1 << HV_SYS_FAST_SHIFT)
+
+/** Bit location for flagging fast syscalls that can be called from PL0. */
+#define HV_SYS_FAST_PLO_SHIFT             13
+
+/** Fast syscall allowing PL0 bit mask. */
+#define HV_SYS_FAST_PL0_MASK              (1 << HV_SYS_FAST_PLO_SHIFT)
+
+/** Perform an MF that waits for all victims to reach DRAM. */
+#define HV_SYS_fence_incoherent         (51 | HV_SYS_FAST_MASK \
+                                       | HV_SYS_FAST_PL0_MASK)
+
+#endif /* !_SYS_HV_INCLUDE_SYSCALL_PUBLIC_H */
-- 
1.6.5.2

