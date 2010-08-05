Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759834Ab0HEHAx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 03:00:53 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61787 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759736Ab0HEHAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 03:00:50 -0400
Message-ID: <4C5A619D.5050407@monstr.eu>
Date: Thu, 05 Aug 2010 09:00:45 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/microblaze fixes for 2.6.36-rc1
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the following patches to your tree.
There is support for KGDB, several cleanups/fixups and I also heavily 
rewrite entry.S.

Thanks,
Michal


The following changes since commit 9fe6206f400646a2322096b56c59891d530e8d51:
   Linus Torvalds (1):
         Linux 2.6.35

are available in the git repository at:

   git://git.monstr.eu/linux-2.6-microblaze.git for-linus

FUJITA Tomonori (1):
       microblaze: remove unused HAVE_ARCH_PCI_SET_DMA_MASK

Michal Simek (46):
       microblaze: Fix __copy_to/from_user_inatomic macros
       microblaze: Fix comment for TLB
       microblaze: Implement flush_dcache_page macro
       microblaze: Remove unused label
       microblaze: Sync noMMU and MMU setup_memory
       microblaze: Fix copy_to_user_page macro
       microblaze: Disable FRAME_POINTER selection
       microblaze: Fix sys_clone syscall
       microblaze: Trace hardirqs
       microblaze: Improve ftrace time measuring
       microblaze: Do not trace cpu_relax function
       microblaze: Enable early printk only for uartlite
       microblaze: Decrease time shifting values
       microblaze: Fix number of pvr regs
       microblaze: Cleanup boot/Makefile
       microblaze: Do not use _start in vmlinux
       microblaze: Fix VM_ON and VM_OFF macros
       microblaze: Save and restore r3/r4 in SAVE/RESTORE_REGS macros
       microblaze: Optimize clear_vms_ums macro
       microblaze: Remove PER_CPU(KM) variable
       microblaze: Move BIP setup to the end of ret_from_trap/ret_from_exc
       microblaze: Move stack backup to SAVE_STATE macro
       microblaze: remove enable_irq from SAVE_STATE macro
       microblaze: trivial: Use la insted of addik
       microblaze: Optimize SAVE_STATE macro
       microblaze: Simplify _debug_exception function
       microblaze: Do not setup BIP in _debug_exception
       microblaze: Completely remove working with R11 register
       microblaze: Remove additional loading
       microblaze: Optimize SAVE_STATE macro
       microblaze: Remove additional setup for kernel_mode
       microblaze: Implement clear_ums macro and fix SAVE_STATE macro
       microblaze: Optimize hw exception rutine
       microblaze: entry.S: Macro optimization
       microblaze: Move SAVE_STATE upward
       microblaze: Do not mix register saving and mode setting
       microblaze: Save kernel mode in delay slot
       microblaze: Use delay slot in syscall macros
       microblaze: Put together addik instructions
       microblaze: Fix _user_exception function
       microblaze: Fix _interrupt function
       microblaze: Move PT_MODE saving to delay slot
       microblaze: Simplify syscall rutine
       microblaze: Remove nop after MSRCLR/SET, MTS, MFS instructions
       microblaze: Support brki rX, 0x18 for user application debugging
       microblaze: Add KGDB support

Steven J. Magnani (2):
       microblaze: Allow PAGE_SIZE configuration
       microblaze: Add stack unwinder

  arch/microblaze/Kconfig                       |   31 ++
  arch/microblaze/Kconfig.debug                 |    1 +
  arch/microblaze/boot/Makefile                 |   11 +-
  arch/microblaze/include/asm/cacheflush.h      |   18 +-
  arch/microblaze/include/asm/dma-mapping.h     |    6 -
  arch/microblaze/include/asm/elf.h             |    2 +-
  arch/microblaze/include/asm/exceptions.h      |   21 +-
  arch/microblaze/include/asm/kgdb.h            |   28 ++
  arch/microblaze/include/asm/page.h            |   12 +-
  arch/microblaze/include/asm/pvr.h             |    2 +-
  arch/microblaze/include/asm/setup.h           |    2 -
  arch/microblaze/include/asm/system.h          |    1 -
  arch/microblaze/include/asm/uaccess.h         |    4 +-
  arch/microblaze/include/asm/unwind.h          |   29 ++
  arch/microblaze/kernel/Makefile               |    3 +-
  arch/microblaze/kernel/cpu/mb.c               |    1 +
  arch/microblaze/kernel/entry-nommu.S          |   28 ++
  arch/microblaze/kernel/entry.S                |  607 
++++++++++---------------
  arch/microblaze/kernel/exceptions.c           |    9 +-
  arch/microblaze/kernel/head.S                 |    4 +-
  arch/microblaze/kernel/hw_exception_handler.S |    4 +-
  arch/microblaze/kernel/irq.c                  |    2 +
  arch/microblaze/kernel/kgdb.c                 |  147 ++++++
  arch/microblaze/kernel/misc.S                 |    2 +-
  arch/microblaze/kernel/process.c              |    7 +-
  arch/microblaze/kernel/ptrace.c               |   17 +-
  arch/microblaze/kernel/stacktrace.c           |   44 +--
  arch/microblaze/kernel/timer.c                |   24 +-
  arch/microblaze/kernel/traps.c                |   91 ++--
  arch/microblaze/kernel/unwind.c               |  318 +++++++++++++
  arch/microblaze/kernel/vmlinux.lds.S          |   16 +-
  arch/microblaze/mm/fault.c                    |   16 -
  arch/microblaze/mm/init.c                     |    7 +-
  lib/Kconfig.debug                             |    6 +-
  34 files changed, 977 insertions(+), 544 deletions(-)
  create mode 100644 arch/microblaze/include/asm/kgdb.h
  create mode 100644 arch/microblaze/include/asm/unwind.h
  create mode 100644 arch/microblaze/kernel/kgdb.c
  create mode 100644 arch/microblaze/kernel/unwind.c

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
