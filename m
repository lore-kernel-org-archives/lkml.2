Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab1CQTqr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 15:46:47 -0400
Received: from 206.83.70.75.ptr.us.xo.net ([206.83.70.75]:31799 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955Ab1CQTqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 15:46:45 -0400
X-Greylist: delayed 329 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Mar 2011 15:46:45 EDT
Message-ID: <4D8263DB.1010500@tilera.com>
Date: Thu, 17 Mar 2011 15:41:15 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.15) Gecko/20110303 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [GIT PULL] arch/tile updates for v2.6.39
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull for 2.6.39 from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git master

These changes catch up mostly with internal work being done at
Tilera, but also reflect various changes made by other folks that
I've taken into our tree.  All the changes have been seen on the
relevant mailing lists.

Chris Metcalf (23):
      arch/tile: Fix atomic_read() definition to use ACCESS_ONCE
      arch/tile: catch up with section naming convention in 2.6.35
      arch/tile: bug fix: exec'ed task thought it was still single-stepping
      arch/tile: fix __ndelay etc to work better
      arch/tile: stop disabling INTCTRL_1 interrupts during hypervisor downcalls
      arch/tile: warn and retry if an IPI is not accepted by the target cpu
      arch/tile: export <asm/hardwall.h> to userspace
      arch/tile: avoid a simulator warning during bootup
      arch/tile: fix reversed test of strict_strtol() return value
      arch/tile: sync up with <arch/sim.h> and <arch/sim_def.h> changes
      arch/tile: use a cleaner technique to enable interrupt for cpu_idle()
      arch/tile: use extended assembly to inline __mb_incoherent()
      arch/tile: fix two bugs in the backtracer code
      arch/tile: enhance existing finv_buffer_remote() routine
      arch/tile: export some additional module symbols
      arch/tile: fix some comments and whitespace
      arch/tile: add some more VMSPLIT options and use consistent naming
      arch/tile: support 4KB page size as well as 64KB
      arch/tile: fix deadlock bugs in rwlock implementation
      arch/tile: support newer binutils assembler shift semantics
      tile on-chip network driver: sync up with latest fixes
      drivers/edac: provide support for tile architecture

Peter Zijlstra (1):
      tile: Fix __pte_free_tlb

Thomas Gleixner (3):
      tile: Convert irq_chip to new functions
      tile: Use proper accessor functions in show_interrupt()
      tile: Select GENERIC_HARDIRQS_NO_DEPRECATED

Tracey Dent (1):
      Readme: Add architecture

 MAINTAINERS                            |    1 +
 README                                 |    2 +-
 arch/tile/Kconfig                      |   39 +-
 arch/tile/include/arch/interrupts_32.h |    9 +-
 arch/tile/include/arch/sim.h           |   48 ++-
 arch/tile/include/arch/sim_def.h       |    3 +
 arch/tile/include/asm/Kbuild           |    1 +
 arch/tile/include/asm/atomic.h         |    2 +-
 arch/tile/include/asm/bitops_32.h      |    2 +-
 arch/tile/include/asm/cache.h          |    2 +-
 arch/tile/include/asm/cacheflush.h     |   55 +--
 arch/tile/include/asm/edac.h           |   29 +
 arch/tile/include/asm/hugetlb.h        |    2 +-
 arch/tile/include/asm/irqflags.h       |   18 +-
 arch/tile/include/asm/page.h           |   34 +-
 arch/tile/include/asm/pgalloc.h        |    7 +-
 arch/tile/include/asm/pgtable.h        |   31 +-
 arch/tile/include/asm/pgtable_32.h     |    8 +-
 arch/tile/include/asm/processor.h      |    1 -
 arch/tile/include/asm/ptrace.h         |    3 +
 arch/tile/include/asm/spinlock_32.h    |   83 +---
 arch/tile/include/asm/stack.h          |    3 +-
 arch/tile/include/asm/system.h         |   19 +-
 arch/tile/include/asm/thread_info.h    |    1 +
 arch/tile/include/asm/timex.h          |    3 +
 arch/tile/include/hv/drv_mshim_intf.h  |   50 ++
 arch/tile/include/hv/hypervisor.h      |   46 ++-
 arch/tile/kernel/entry.S               |   22 +-
 arch/tile/kernel/head_32.S             |   15 +-
 arch/tile/kernel/intvec_32.S           |   74 +--
 arch/tile/kernel/irq.c                 |   38 +-
 arch/tile/kernel/machine_kexec.c       |    7 +-
 arch/tile/kernel/pci-dma.c             |   38 +-
 arch/tile/kernel/process.c             |    6 +-
 arch/tile/kernel/setup.c               |   20 +-
 arch/tile/kernel/single_step.c         |   21 +-
 arch/tile/kernel/smp.c                 |   33 +-
 arch/tile/kernel/stack.c               |   28 +-
 arch/tile/kernel/time.c                |   10 +
 arch/tile/kernel/vmlinux.lds.S         |    5 +-
 arch/tile/lib/Makefile                 |    5 +-
 arch/tile/lib/atomic_32.c              |    5 +-
 arch/tile/lib/atomic_asm_32.S          |    2 +-
 arch/tile/lib/cacheflush.c             |  102 ++++
 arch/tile/lib/delay.c                  |   21 +-
 arch/tile/lib/exports.c                |   10 +-
 arch/tile/lib/mb_incoherent.S          |   34 --
 arch/tile/lib/memcpy_tile64.c          |    4 +-
 arch/tile/lib/spinlock_32.c            |  161 ++++---
 arch/tile/mm/fault.c                   |    8 -
 arch/tile/mm/homecache.c               |   38 +-
 arch/tile/mm/init.c                    |   34 +-
 arch/tile/mm/migrate_32.S              |    1 +
 arch/tile/mm/pgtable.c                 |  181 +++++--
 drivers/edac/Kconfig                   |   10 +-
 drivers/edac/Makefile                  |    1 +
 drivers/edac/tile_edac.c               |  254 +++++++++
 drivers/net/tile/tilepro.c             |  965 +++++++++++++++++---------------
 58 files changed, 1648 insertions(+), 1007 deletions(-)
 create mode 100644 arch/tile/include/asm/edac.h
 create mode 100644 arch/tile/include/hv/drv_mshim_intf.h
 delete mode 100644 arch/tile/lib/mb_incoherent.S
 create mode 100644 drivers/edac/tile_edac.c


-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

