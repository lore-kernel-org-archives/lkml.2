Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760808Ab0HFIx4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 04:53:56 -0400
Received: from miranda.se.axis.com ([193.13.178.8]:49230 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317Ab0HFIxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 04:53:50 -0400
Date: Fri, 6 Aug 2010 10:53:37 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-cris-kernel <linux-cris-kernel@axis.com>
Subject: [GIT PULL] arch/cris changes for 2.6.36
Message-ID: <20100806085337.GA17485@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the below git tree for CRIS changes for 2.6.36.
Most of the changes are minor fixes from our internal CVS.

Thanks,

/^Jesper

The following changes since commit 26bfeea38a4a5daf52c8f01c986ca8680bf1f6a1:
  Latchesar Ionkov (1):
        9p: Pass the correct end of buffer to p9stat_read

are available in the git repository at:

  git://www.jni.nu/cris.git for-linus

Jesper Nilsson (49):
      CRIS: GENERIC_TIME fixes
      CRIS: invoke oom-killer from page fault
      cris: Pushdown the bkl from ioctl
      cris: autoconvert trivial BKL users to private mutex
      CRIS: gpio: don't call copy_to_user()/copy_from_user() while holding spinlocks
      CRIS: v10: remove all BKL usage
      CRIS: Remove CVS tag.
      CRIS: Better link to rs485 in help
      CRIS: Fasttimer: Remove obsolete ifdef
      CRIS: Correct address of the romfs in boot image
      CRIS: Add debug for assembler functions
      CRIS: Simple insn reschedule to avoid interlocks.
      CRIS: Faster syscall entry for CRISv32.
      CRIS: Additional mmu settings for ARTPEC-3
      CRIS: v32: Correct address for romfs in the image
      CRIS: v32: Better irq mapping code
      CRIS: v32: Correct path for intr_vect.h
      CRIS: kgdb: Fix compilation errors
      CRIS: Remove obsolete pinmux.c, now machine dependent.
      CRIS: More ARTPEC-3 support and i2c-boardinfo.
      CRIS: v32: Correct auto-restart of syscalls
      CRIS: Minor formatting fix in traps.c
      CRIS: Add debug symbols for assembler code
      CRIS: Add debug info for assembler code
      CRIS: Add debug info for assembler code
      CRIS: Add more delays in DDR setup
      CRIS: Update for ARTPEC-3
      CRIS: Add debug for assembler macros
      CRIS: Avoid compilation warning for puts
      CRIS: Discard .note.gnu.build-id section
      CRIS: Define __read_mostly for CRISv32
      CRIS: Machine dependent dma.h
      CRIS: Check if pointer is set before using it
      CRIS: Machine dependent memmap.h
      CRIS: Pagetable for ARTPEC-3
      CRIS: __do_strncpy_from_user: Don't read the byte beyond the nil
      CRIS: New DMA defines for ARTPEC-3
      CRIS: Better handling of pinmux settings
      CRIS: Add include guard
      CRIS: Better ARTPEC-3 support for gpio
      CRIS: Add ARTPEC-3 and timestamps for sync-serial
      CRIS: Return something from profile write
      CRIS: Add cache aligned and read mostly data sections
      CRIS: Discard exit.text and .data at runtime
      CRIS: Fixup lookup for delay slot faults
      CRIS: Don't take faults while in_atomic
      CRIS: Add config for pausing a seg-faulting process
      CRIS: Always dump registers for segfaulting process.
      CRIS: Fix alignment problem for older ld

Joe Perches (1):
      arch/cris: Remove unnecessary casts of private_data

 arch/cris/Kconfig                                  |    5 +-
 arch/cris/Kconfig.debug                            |    6 +
 arch/cris/arch-v10/drivers/Kconfig                 |    2 +-
 arch/cris/arch-v10/drivers/eeprom.c                |    2 -
 arch/cris/arch-v10/drivers/gpio.c                  |   82 +++++---
 arch/cris/arch-v10/drivers/i2c.c                   |   39 ++--
 arch/cris/arch-v10/drivers/i2c.h                   |    3 +-
 arch/cris/arch-v10/drivers/sync_serial.c           |   30 ++-
 arch/cris/arch-v10/kernel/fasttimer.c              |    6 +-
 arch/cris/arch-v10/kernel/head.S                   |    2 +-
 arch/cris/arch-v10/kernel/time.c                   |   54 +-----
 arch/cris/arch-v32/drivers/cryptocop.c             |   28 ++-
 arch/cris/arch-v32/drivers/i2c.c                   |   12 +-
 arch/cris/arch-v32/drivers/mach-a3/gpio.c          |   28 ++-
 arch/cris/arch-v32/drivers/mach-fs/gpio.c          |   42 +++--
 arch/cris/arch-v32/drivers/sync_serial.c           |   30 ++-
 arch/cris/arch-v32/kernel/cacheflush.S             |    5 +
 arch/cris/arch-v32/kernel/entry.S                  |   80 +++++---
 arch/cris/arch-v32/kernel/head.S                   |   44 ++++-
 arch/cris/arch-v32/kernel/irq.c                    |   47 ++---
 arch/cris/arch-v32/kernel/kgdb.c                   |   16 +-
 arch/cris/arch-v32/kernel/kgdb_asm.S               |    2 +-
 arch/cris/arch-v32/kernel/pinmux.c                 |  229 --------------------
 arch/cris/arch-v32/kernel/setup.c                  |   74 ++++++-
 arch/cris/arch-v32/kernel/signal.c                 |    2 +-
 arch/cris/arch-v32/kernel/time.c                   |   85 +++-----
 arch/cris/arch-v32/kernel/traps.c                  |    6 +-
 arch/cris/arch-v32/lib/checksum.S                  |    3 +
 arch/cris/arch-v32/lib/checksumcopy.S              |    3 +
 arch/cris/arch-v32/lib/spinlock.S                  |    7 +
 arch/cris/arch-v32/mach-a3/Kconfig                 |    4 +
 arch/cris/arch-v32/mach-a3/dram_init.S             |   16 ++-
 arch/cris/arch-v32/mach-a3/hw_settings.S           |    2 +
 arch/cris/arch-v32/mm/init.c                       |   23 ++-
 arch/cris/arch-v32/mm/mmu.S                        |    4 +
 arch/cris/boot/Makefile                            |    2 +-
 arch/cris/boot/compressed/misc.c                   |   65 +++----
 arch/cris/include/arch-v32/arch/cache.h            |    2 +
 arch/cris/include/arch-v32/arch/dma.h              |   80 +-------
 arch/cris/include/arch-v32/arch/io.h               |   20 +-
 arch/cris/include/arch-v32/arch/memmap.h           |   25 +--
 arch/cris/include/arch-v32/arch/pgtable.h          |    8 +
 arch/cris/include/arch-v32/arch/uaccess.h          |    7 +-
 arch/cris/include/arch-v32/mach-a3/mach/dma.h      |   27 +++
 .../cris/include/arch-v32/mach-a3/mach/startup.inc |   28 +++-
 arch/cris/include/arch-v32/mach-fs/mach/dma.h      |   79 +++++++
 arch/cris/include/arch-v32/mach-fs/mach/memmap.h   |   24 ++
 .../cris/include/arch-v32/mach-fs/mach/startup.inc |    5 +
 arch/cris/include/asm/etraxgpio.h                  |   96 +++++++--
 arch/cris/include/asm/sync_serial.h                |   27 +++-
 arch/cris/kernel/profile.c                         |   15 +-
 arch/cris/kernel/time.c                            |    7 +-
 arch/cris/kernel/vmlinux.lds.S                     |   14 ++-
 arch/cris/mm/fault.c                               |   45 +++--
 54 files changed, 857 insertions(+), 742 deletions(-)
 delete mode 100644 arch/cris/arch-v32/kernel/pinmux.c
 create mode 100644 arch/cris/include/arch-v32/mach-fs/mach/dma.h
 create mode 100644 arch/cris/include/arch-v32/mach-fs/mach/memmap.h

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
