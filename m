Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430Ab1LSQ6w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 11:58:52 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40522 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146Ab1LSQ6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 11:58:43 -0500
Date: Mon, 19 Dec 2011 08:58:38 -0800
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        sfr@canb.auug.org.auviakernel.org, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL core/memblock] memblock: kill early_node_map
Message-ID: <20111219165838.GD24519@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo.

The kill early_node_map patchset[1] has now been in linux-next for
some time now and other than merge conflicts w/ -mm, there hasn't been
any major problem, which is not to say there aren't broken archs but
at least build should be okay on most archs and I don't think we'll be
able to find out obscure arch breakage without pushing into upstream
anyway.

Can you please pull from the following branch into core/memblock to
receive memblock updates to kill early_node_map?  Merging into tip
doesn't produce any conflict.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git memblock-kill-early_node_map

Tejun Heo (23):
      memblock: Fix include breakages caused by 24aa07882b
      memblock: Make memblock_{add|remove|free|reserve}() return int and update prototypes
      memblock: Use memblock_reserve() in memblock internal functions
      memblock: Add __memblock_dump_all()
      memblock: Kill sentinel entries at the end of static region arrays
      memblock: Kill memblock_init()
      memblock: Separate out memblock_isolate_range() from memblock_set_node()
      memblock: Reimplement __memblock_remove() using memblock_isolate_range()
      memblock: Make memblock functions handle overflowing range @size
      memblock: Reimplement memblock_enforce_memory_limit() using __memblock_remove()
      powerpc: Cleanup memblock usage
      memblock: Track total size of regions automatically
      memblock: s/memblock_analyze()/memblock_allow_resize()/ and update users
      memblock: Implement memblock_add_node()
      powerpc: Use HAVE_MEMBLOCK_NODE_MAP
      sparc: Use HAVE_MEMBLOCK_NODE_MAP
      SuperH: Use HAVE_MEMBLOCK_NODE_MAP
      ia64: Use HAVE_MEMBLOCK_NODE_MAP
      mips: Use HAVE_MEMBLOCK_NODE_MAP
      s390: Use HAVE_MEMBLOCK_NODE_MAP
      score: Use HAVE_MEMBLOCK_NODE_MAP
      memblock: Kill early_node_map[]
      memblock: Reimplement memblock allocation using reverse free area iterator

 arch/arm/kernel/setup.c                  |    1 +
 arch/arm/mm/init.c                       |    4 +-
 arch/ia64/Kconfig                        |    6 +-
 arch/ia64/mm/contig.c                    |    3 +-
 arch/ia64/mm/init.c                      |    4 +-
 arch/microblaze/include/asm/memblock.h   |   14 -
 arch/microblaze/kernel/prom.c            |    3 +-
 arch/mips/Kconfig                        |    6 +-
 arch/mips/kernel/setup.c                 |    3 +-
 arch/mips/sgi-ip27/ip27-memory.c         |    5 +-
 arch/openrisc/include/asm/memblock.h     |   24 --
 arch/openrisc/kernel/prom.c              |    3 +-
 arch/powerpc/Kconfig                     |    4 +-
 arch/powerpc/include/asm/memblock.h      |    8 -
 arch/powerpc/kernel/machine_kexec.c      |    3 -
 arch/powerpc/kernel/prom.c               |   20 +-
 arch/powerpc/mm/init_32.c                |    4 +-
 arch/powerpc/mm/mem.c                    |    2 +-
 arch/powerpc/mm/numa.c                   |   10 +-
 arch/powerpc/mm/tlb_nohash.c             |    1 -
 arch/powerpc/platforms/embedded6xx/wii.c |   23 +-
 arch/powerpc/platforms/ps3/mm.c          |    1 -
 arch/s390/Kconfig                        |    6 +-
 arch/s390/kernel/setup.c                 |    4 +-
 arch/score/Kconfig                       |    6 +-
 arch/score/kernel/setup.c                |    4 +-
 arch/sh/Kconfig                          |    1 +
 arch/sh/include/asm/memblock.h           |    4 -
 arch/sh/kernel/machine_kexec.c           |    3 -
 arch/sh/kernel/setup.c                   |    3 +-
 arch/sh/mm/Kconfig                       |    3 -
 arch/sh/mm/init.c                        |    3 +-
 arch/sparc/Kconfig                       |    4 +-
 arch/sparc/include/asm/memblock.h        |    8 -
 arch/sparc/mm/init_64.c                  |   28 +--
 arch/unicore32/kernel/setup.c            |    1 +
 arch/unicore32/mm/init.c                 |    4 +-
 arch/unicore32/mm/mmu.c                  |    1 +
 arch/x86/Kconfig                         |    3 -
 arch/x86/kernel/e820.c                   |    3 +-
 arch/x86/kernel/head32.c                 |    2 -
 arch/x86/kernel/head64.c                 |    2 -
 arch/x86/xen/enlighten.c                 |    2 -
 drivers/iommu/intel-iommu.c              |    1 +
 include/linux/memblock.h                 |  116 ++++--
 include/linux/mm.h                       |   50 +--
 include/linux/mmzone.h                   |    8 +-
 include/linux/poison.h                   |    6 -
 mm/memblock.c                            |  603 ++++++++++++++----------------
 mm/page_alloc.c                          |  259 +------------
 50 files changed, 452 insertions(+), 838 deletions(-)
 delete mode 100644 arch/microblaze/include/asm/memblock.h
 delete mode 100644 arch/openrisc/include/asm/memblock.h
 delete mode 100644 arch/powerpc/include/asm/memblock.h
 delete mode 100644 arch/sh/include/asm/memblock.h
 delete mode 100644 arch/sparc/include/asm/memblock.h

Thanks.

-- 
tejun

[1] http://thread.gmane.org/gmane.linux.kernel.cross-arch/11566
