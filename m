Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758494Ab0JYXse (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 19:48:34 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65316 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab0JYXsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 19:48:33 -0400
Message-ID: <4CC61746.7030506@monstr.eu>
Date: Tue, 26 Oct 2010 09:48:22 +1000
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        David Miller <davem@davemloft.net>
Subject: [GIT PULL] arch/microblaze changes for 2.6.37
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the following changes. The main part is adding Microblaze little endian
support for AXI bus.

There are two out-of-tree patches which have ACKs from
respective maintainers (David S. Miller - emaclite , Grant Likely - xilinxfb).
Both of them proposed to merge it via Microblaze tree.

Thanks,
Michal


The following changes since commit f6f94e2ab1b33f0082ac22d71f66385a60d8157f:
  Linus Torvalds (1):
        Linux 2.6.36

are available in the git repository at:

  git://git.monstr.eu/linux-2.6-microblaze.git next

Christian Dietrich (1):
      microblaze: Removing dead CONTIGUOUS_PAGE_ALLOC config option

FUJITA Tomonori (1):
      microblaze: use asm-generic/pci-dma-compat.h

Joe Perches (2):
      microblaze: Remove pr_<level> uses of KERN_<level>
      microblaze: Use static const char * const where possible

Michal Simek (36):
      microblaze: Fix generic DTS to ensure OF requirements
      microblaze: kgdb: Remove unused variable and fix return value
      microblaze: Fix pmd_populate macro
      microblaze: trivial: thread_info cleanup
      microblaze: Remove old user debugging gdb stub
      microblaze: Add seccomp support
      microblaze: remove unused TIF_KERNEL_TRACE
      microblaze: Fix sys_rt_sigreturn_wrapper
      microblaze: Clear return value in pt_regs
      microblaze: Report if only one timer is used
      microblaze: Fix r16 and r17 reg saving
      microblaze: remove OUTPUT_FORMAT from linker script
      microblaze: Add new microblaze versions
      microblaze: Add PVR for BTC
      microblaze: wire up prlimit64 and fanotify* syscalls
      microblaze: Define empty mmiowb
      microblaze: support gpio_to_irq()
      microblaze: Add libgcc function directly to kernel
      microblaze: Export missing symbols for modules
      microblaze: Define VMALLOC_START/END
      microblaze: Remove hardcoded asm instraction for PVR loading
      microblaze: Remove additional compatible properties
      microblaze: remove early printk uarlite console dependency from header
      microblaze: Rename all uartlite early printk functions
      microblaze: Setup early console dynamically
      microblaze: Do not compile early console support for uartlite if is disabled
      microblaze: Support early console on uart16550
      microblaze: trivial: Add comment for AXI pvr
      net: emaclite: Add support for little-endian platforms
      microblaze: Add PVR for endians plus detection
      microblaze: KGDB little endian support
      microblaze: Add support for little-endian Microblaze
      microblaze: Support timer on AXI lite
      microblaze: Separate library optimized functions
      microblaze: Support C optimized lib functions for little-endian
      fbdev/xilinxfb: Microblaze driver support

Nishanth Aravamudan (1):
      microblaze: pci-common cleanup

Thomas Backlund (1):
      microblaze: Fix build with make 3.82

 arch/microblaze/Kconfig                       |   17 ++++
 arch/microblaze/Kconfig.debug                 |    2 +-
 arch/microblaze/Makefile                      |   11 ++-
 arch/microblaze/include/asm/byteorder.h       |    4 +
 arch/microblaze/include/asm/checksum.h        |    9 ++-
 arch/microblaze/include/asm/cpuinfo.h         |    5 +-
 arch/microblaze/include/asm/elf.h             |    2 +-
 arch/microblaze/include/asm/gpio.h            |    5 +-
 arch/microblaze/include/asm/io.h              |    2 +
 arch/microblaze/include/asm/page.h            |    3 -
 arch/microblaze/include/asm/pci.h             |    2 +
 arch/microblaze/include/asm/pgalloc.h         |    3 +-
 arch/microblaze/include/asm/pgtable.h         |    7 ++
 arch/microblaze/include/asm/prom.h            |    1 +
 arch/microblaze/include/asm/pvr.h             |   14 ++-
 arch/microblaze/include/asm/seccomp.h         |   16 ++++
 arch/microblaze/include/asm/setup.h           |    6 ++
 arch/microblaze/include/asm/thread_info.h     |   20 ++---
 arch/microblaze/include/asm/unaligned.h       |   12 ++-
 arch/microblaze/include/asm/unistd.h          |    5 +-
 arch/microblaze/kernel/cpu/cpuinfo-pvr-full.c |    1 +
 arch/microblaze/kernel/cpu/cpuinfo-static.c   |    1 +
 arch/microblaze/kernel/cpu/cpuinfo.c          |    2 +
 arch/microblaze/kernel/cpu/mb.c               |    3 +-
 arch/microblaze/kernel/cpu/pvr.c              |    2 +-
 arch/microblaze/kernel/early_printk.c         |   87 ++++++++++++++++--
 arch/microblaze/kernel/entry.S                |   21 ++---
 arch/microblaze/kernel/exceptions.c           |   25 ++----
 arch/microblaze/kernel/heartbeat.c            |   11 +--
 arch/microblaze/kernel/intc.c                 |   14 ++--
 arch/microblaze/kernel/kgdb.c                 |    7 +-
 arch/microblaze/kernel/microblaze_ksyms.c     |   32 ++-----
 arch/microblaze/kernel/prom.c                 |   39 ++++++++-
 arch/microblaze/kernel/setup.c                |    6 --
 arch/microblaze/kernel/syscall_table.S        |    3 +
 arch/microblaze/kernel/timer.c                |   41 +++++----
 arch/microblaze/kernel/vmlinux.lds.S          |    5 +-
 arch/microblaze/lib/Makefile                  |   10 ++
 arch/microblaze/lib/ashldi3.c                 |   29 ++++++
 arch/microblaze/lib/ashrdi3.c                 |   31 +++++++
 arch/microblaze/lib/divsi3.S                  |   73 +++++++++++++++
 arch/microblaze/lib/libgcc.h                  |   25 +++++
 arch/microblaze/lib/lshrdi3.c                 |   29 ++++++
 arch/microblaze/lib/memcpy.c                  |   46 ++++++++--
 arch/microblaze/lib/memmove.c                 |   59 ++++++++++---
 arch/microblaze/lib/memset.c                  |   22 ++++-
 arch/microblaze/lib/modsi3.S                  |   73 +++++++++++++++
 arch/microblaze/lib/muldi3.S                  |  121 +++++++++++++++++++++++++
 arch/microblaze/lib/mulsi3.S                  |   46 ++++++++++
 arch/microblaze/lib/udivsi3.S                 |   84 +++++++++++++++++
 arch/microblaze/lib/umodsi3.S                 |   86 ++++++++++++++++++
 arch/microblaze/pci/pci-common.c              |   21 +----
 arch/microblaze/platform/generic/system.dts   |    3 +
 arch/microblaze/platform/platform.c           |    3 -
 drivers/net/xilinx_emaclite.c                 |    8 +-
 drivers/video/xilinxfb.c                      |   24 ++++--
 56 files changed, 1038 insertions(+), 201 deletions(-)
 create mode 100644 arch/microblaze/include/asm/seccomp.h
 create mode 100644 arch/microblaze/lib/ashldi3.c
 create mode 100644 arch/microblaze/lib/ashrdi3.c
 create mode 100644 arch/microblaze/lib/divsi3.S
 create mode 100644 arch/microblaze/lib/libgcc.h
 create mode 100644 arch/microblaze/lib/lshrdi3.c
 create mode 100644 arch/microblaze/lib/modsi3.S
 create mode 100644 arch/microblaze/lib/muldi3.S
 create mode 100644 arch/microblaze/lib/mulsi3.S
 create mode 100644 arch/microblaze/lib/udivsi3.S
 create mode 100644 arch/microblaze/lib/umodsi3.S


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
