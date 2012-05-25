Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933380Ab2EYTgG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 15:36:06 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:16614 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932290Ab2EYTgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 15:36:02 -0400
Message-ID: <4FBFDF20.8060408@tilera.com>
Date: Fri, 25 May 2012 15:36:00 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/tile update for 3.5
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the following changes for 3.5 from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git master

These changes cover a range of new arch/tile features and optimizations.
They've been through LKML review and on linux-next for a month or so.
There's also one bug-fix that just missed 3.4, which I've marked for stable.

Chris Metcalf (15):
      arch/tile: use interrupt critical sections less
      arch/tile: allow building Linux with transparent huge pages enabled
      arch/tile: support building big-endian kernel
      arch/tile: optimize get_user/put_user and friends
      arch/tile: Allow tilegx to build with either 16K or 64K page size
      arch/tile: support <asm/cachectl.h> header for cacheflush() syscall
      arch/tile: support kexec() for tilegx
      mm: add new arch_make_huge_pte() method for tile support
      arch/tile: support multiple huge page sizes dynamically
      arch/tile: fix hardwall for tilegx and generalize for idn and ipi
      arch/tile: allow querying cpu module information from the hypervisor
      arch/tile: add descriptive text if the kernel reports a bad trap
      arch/tile: mark TILEGX as not EXPERIMENTAL
      tile: fix bug where fls(0) was not returning 0
      tile: default to tilegx_defconfig for ARCH=tile

Kautuk Consul (1):
      tile/mm/fault.c: Port OOM changes to handle_page_fault

 arch/tile/Kconfig                                  |   43 +-
 arch/tile/Makefile                                 |    7 +-
 arch/tile/include/arch/spr_def_32.h                |   56 ++
 arch/tile/include/arch/spr_def_64.h                |   43 ++
 arch/tile/include/asm/Kbuild                       |    2 +-
 arch/tile/include/asm/atomic_32.h                  |   10 +
 arch/tile/include/asm/bitops.h                     |   12 +-
 arch/tile/include/asm/byteorder.h                  |   20 +
 arch/tile/include/asm/cachectl.h                   |   42 ++
 arch/tile/include/asm/compat.h                     |    3 -
 arch/tile/include/asm/elf.h                        |    5 +
 arch/tile/include/asm/futex.h                      |  143 +++--
 arch/tile/include/asm/hardwall.h                   |   18 +-
 arch/tile/include/asm/hugetlb.h                    |   21 +
 arch/tile/include/asm/irqflags.h                   |   34 +-
 arch/tile/include/asm/kexec.h                      |   12 +
 arch/tile/include/asm/mmu.h                        |    2 +-
 arch/tile/include/asm/mmu_context.h                |    8 +-
 arch/tile/include/asm/module.h                     |   40 +
 arch/tile/include/asm/page.h                       |   18 +-
 arch/tile/include/asm/pgalloc.h                    |   92 ++-
 arch/tile/include/asm/pgtable.h                    |  111 +++-
 arch/tile/include/asm/pgtable_32.h                 |   40 +-
 arch/tile/include/asm/pgtable_64.h                 |   57 +-
 arch/tile/include/asm/processor.h                  |   17 +-
 arch/tile/include/asm/setup.h                      |   10 +-
 arch/tile/include/asm/syscalls.h                   |    3 +-
 arch/tile/include/asm/tlbflush.h                   |   17 +-
 arch/tile/include/asm/uaccess.h                    |  222 ++++---
 arch/tile/include/asm/unistd.h                     |    4 +-
 arch/tile/include/hv/drv_xgbe_intf.h               |    2 +-
 arch/tile/include/hv/hypervisor.h                  |  325 ++++++---
 arch/tile/kernel/Makefile                          |    3 +-
 arch/tile/kernel/entry.S                           |    3 +-
 arch/tile/kernel/hardwall.c                        |  754 +++++++++++++-------
 arch/tile/kernel/head_32.S                         |    8 +-
 arch/tile/kernel/head_64.S                         |   22 +-
 arch/tile/kernel/hvglue.lds                        |    3 +-
 arch/tile/kernel/intvec_64.S                       |   80 ++-
 arch/tile/kernel/machine_kexec.c                   |   42 +-
 arch/tile/kernel/module.c                          |   12 +-
 arch/tile/kernel/proc.c                            |    1 +
 arch/tile/kernel/process.c                         |   16 +-
 .../{relocate_kernel.S => relocate_kernel_32.S}    |    0
 .../{relocate_kernel.S => relocate_kernel_64.S}    |  150 ++---
 arch/tile/kernel/setup.c                           |  169 +++--
 arch/tile/kernel/single_step.c                     |   16 +-
 arch/tile/kernel/smp.c                             |    2 +-
 arch/tile/kernel/sys.c                             |   10 +-
 arch/tile/kernel/sysfs.c                           |    8 +
 arch/tile/kernel/tlb.c                             |   11 +-
 arch/tile/kernel/traps.c                           |   30 +-
 arch/tile/lib/atomic_32.c                          |   47 +--
 arch/tile/lib/exports.c                            |    8 -
 arch/tile/lib/memchr_64.c                          |    8 +-
 arch/tile/lib/memcpy_64.c                          |   23 +-
 arch/tile/lib/memcpy_tile64.c                      |    8 +-
 arch/tile/lib/strchr_64.c                          |   15 +-
 arch/tile/lib/string-endian.h                      |   33 +
 arch/tile/lib/strlen_64.c                          |   11 +-
 arch/tile/lib/usercopy_32.S                        |   76 --
 arch/tile/lib/usercopy_64.S                        |   49 --
 arch/tile/mm/fault.c                               |   34 +-
 arch/tile/mm/homecache.c                           |    1 +
 arch/tile/mm/hugetlbpage.c                         |  285 ++++++--
 arch/tile/mm/init.c                                |   19 +-
 arch/tile/mm/migrate.h                             |    6 +
 arch/tile/mm/migrate_32.S                          |   36 +-
 arch/tile/mm/migrate_64.S                          |   34 +-
 arch/tile/mm/pgtable.c                             |   40 +-
 include/asm-generic/pgtable.h                      |    5 +-
 include/linux/hugetlb.h                            |    8 +
 mm/hugetlb.c                                       |    1 +
 mm/pgtable-generic.c                               |    4 +-
 74 files changed, 2276 insertions(+), 1254 deletions(-)
 create mode 100644 arch/tile/include/asm/cachectl.h
 create mode 100644 arch/tile/include/asm/module.h
 copy arch/tile/kernel/{relocate_kernel.S => relocate_kernel_32.S} (100%)
 rename arch/tile/kernel/{relocate_kernel.S => relocate_kernel_64.S} (54%)
 create mode 100644 arch/tile/lib/string-endian.h

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

