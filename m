Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761336Ab2C3U5F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 16:57:05 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:37262 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760006Ab2C3U5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 16:57:02 -0400
Message-ID: <4F761E1C.80808@tilera.com>
Date: Fri, 30 Mar 2012 16:57:00 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        cmetcalf <cmetcalf@tilera.com>
Subject: [PATCH summary] arch/tile changes for 3.4
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series is a catch-up of internal development work done
at Tilera, and only affects the "arch/tile" tree.  (Some patches I've
recently emailed out separately also touch other parts of the tree,
but these patches are purely contained in the tile arch subtree.)

I'd appreciate review, but in the expectation that there will probably
be a pretty short list of folks interested in doing the review, I'm
grouping the patches together as follow-ups to this email so they can
all be more easily ignored. :-)  I'd certainly appreciate interested
parties at least skimming the subject lines and looking at patches that
seem to touch on areas they are interested in.

 arch/tile/Kconfig                                  |   41 +-
 arch/tile/Makefile                                 |    5 +-
 arch/tile/include/arch/spr_def.h                   |    4 +-
 arch/tile/include/arch/spr_def_32.h                |   56 ++
 arch/tile/include/arch/spr_def_64.h                |   43 ++
 arch/tile/include/asm/Kbuild                       |    2 +-
 arch/tile/include/asm/atomic_32.h                  |   12 +-
 arch/tile/include/asm/bitops_64.h                  |    8 +-
 arch/tile/include/asm/byteorder.h                  |   20 +
 arch/tile/include/asm/cachectl.h                   |   42 ++
 arch/tile/include/asm/compat.h                     |    3 -
 arch/tile/include/asm/elf.h                        |    5 +
 arch/tile/include/asm/futex.h                      |  143 +++--
 arch/tile/include/asm/hardwall.h                   |   18 +-
 arch/tile/include/asm/hugetlb.h                    |   21 +
 arch/tile/include/asm/irq.h                        |    2 +-
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
 arch/tile/include/asm/spinlock_64.h                |    2 +-
 arch/tile/include/asm/stack.h                      |    1 -
 arch/tile/include/asm/syscalls.h                   |    3 +-
 arch/tile/include/asm/system.h                     |   10 +-
 arch/tile/include/asm/tlbflush.h                   |   17 +-
 arch/tile/include/asm/traps.h                      |    6 +-
 arch/tile/include/asm/uaccess.h                    |  222 ++++---
 arch/tile/include/asm/unistd.h                     |    4 +-
 arch/tile/include/hv/drv_xgbe_intf.h               |    2 +-
 arch/tile/include/hv/hypervisor.h                  |  309 ++++++---
 arch/tile/kernel/Makefile                          |    3 +-
 arch/tile/kernel/entry.S                           |    5 +-
 arch/tile/kernel/hardwall.c                        |  754 +++++++++++++-------
 arch/tile/kernel/head_32.S                         |    8 +-
 arch/tile/kernel/head_64.S                         |   22 +-
 arch/tile/kernel/hvglue.lds                        |    3 +-
 arch/tile/kernel/intvec_32.S                       |   24 +-
 arch/tile/kernel/intvec_64.S                       |  132 +++--
 arch/tile/kernel/machine_kexec.c                   |   42 +-
 arch/tile/kernel/module.c                          |   14 +-
 arch/tile/kernel/proc.c                            |    1 +
 arch/tile/kernel/process.c                         |   18 +-
 .../{relocate_kernel.S => relocate_kernel_32.S}    |    0
 .../{relocate_kernel.S => relocate_kernel_64.S}    |  150 ++---
 arch/tile/kernel/setup.c                           |  196 ++++--
 arch/tile/kernel/single_step.c                     |   47 +-
 arch/tile/kernel/smp.c                             |   10 +-
 arch/tile/kernel/stack.c                           |  231 +++---
 arch/tile/kernel/sys.c                             |   10 +-
 arch/tile/kernel/sysfs.c                           |    8 +
 arch/tile/kernel/tlb.c                             |   11 +-
 arch/tile/kernel/traps.c                           |   45 +-
 arch/tile/lib/Makefile                             |    1 +
 arch/tile/lib/atomic_32.c                          |   47 +--
 arch/tile/lib/cacheflush.c                         |   30 +-
 arch/tile/lib/exports.c                            |    8 -
 arch/tile/lib/memchr_64.c                          |    8 +-
 arch/tile/lib/memcpy_64.c                          |   23 +-
 arch/tile/lib/memcpy_tile64.c                      |    8 +-
 arch/tile/lib/memcpy_user_64.c                     |    8 +-
 arch/tile/lib/spinlock_common.h                    |    2 +-
 arch/tile/lib/strchr_64.c                          |   15 +-
 arch/tile/lib/string-endian.h                      |   33 +
 arch/tile/lib/strlen_64.c                          |   11 +-
 arch/tile/lib/usercopy_32.S                        |   76 --
 arch/tile/lib/usercopy_64.S                        |   49 --
 arch/tile/mm/fault.c                               |   24 +-
 arch/tile/mm/homecache.c                           |    2 +
 arch/tile/mm/hugetlbpage.c                         |  241 +++++--
 arch/tile/mm/init.c                                |   45 +-
 arch/tile/mm/migrate.h                             |    6 +
 arch/tile/mm/migrate_32.S                          |   36 +-
 arch/tile/mm/migrate_64.S                          |   34 +-
 arch/tile/mm/pgtable.c                             |   78 +--
 81 files changed, 2522 insertions(+), 1449 deletions(-)

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

