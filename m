Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813Ab0GNHXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 03:23:19 -0400
Received: from gate.crashing.org ([63.228.1.57]:57813 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427Ab0GNHW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 03:22:58 -0400
Subject: [git pull] Please pull powerpc.git lmb-to-memblock branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Jul 2010 17:22:36 +1000
Message-ID: <1279092156.28659.463.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

As discussed, here's the lmb rename to memblock.

CCing Russell since I know he has some patches in -next for using lmb on ARM which
might need to be reworked on top of that.

BTW. There's another request coming your way for ppc stuff, it's not a
duplicate email :-)

Cheers,
Ben.

The following changes since commit 1c5474a65bf15a4cb162dfff86d6d0b5a08a740c:
  Linus Torvalds (1):
        Linux 2.6.35-rc5

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git lmb-to-memblock

Yinghai Lu (1):
      lmb: rename to memblock

 Documentation/kernel-parameters.txt               |    2 +-
 arch/microblaze/Kconfig                           |    2 +-
 arch/microblaze/include/asm/{lmb.h => memblock.h} |   10 +-
 arch/microblaze/kernel/prom.c                     |   14 +-
 arch/microblaze/mm/init.c                         |   40 +-
 arch/powerpc/Kconfig                              |    2 +-
 arch/powerpc/include/asm/abs_addr.h               |    2 +-
 arch/powerpc/include/asm/lmb.h                    |   15 -
 arch/powerpc/include/asm/memblock.h               |   15 +
 arch/powerpc/kernel/btext.c                       |    2 +-
 arch/powerpc/kernel/crash.c                       |    2 +-
 arch/powerpc/kernel/crash_dump.c                  |    4 +-
 arch/powerpc/kernel/dma-swiotlb.c                 |    2 +-
 arch/powerpc/kernel/dma.c                         |    4 +-
 arch/powerpc/kernel/machine_kexec.c               |   12 +-
 arch/powerpc/kernel/paca.c                        |    8 +-
 arch/powerpc/kernel/prom.c                        |   62 ++--
 arch/powerpc/kernel/rtas.c                        |    6 +-
 arch/powerpc/kernel/setup-common.c                |    2 +-
 arch/powerpc/kernel/setup_32.c                    |   16 +-
 arch/powerpc/kernel/setup_64.c                    |   20 +-
 arch/powerpc/kernel/vdso.c                        |    4 +-
 arch/powerpc/mm/40x_mmu.c                         |    2 +-
 arch/powerpc/mm/hash_utils_64.c                   |   26 +-
 arch/powerpc/mm/init_32.c                         |   16 +-
 arch/powerpc/mm/init_64.c                         |    2 +-
 arch/powerpc/mm/mem.c                             |   78 ++--
 arch/powerpc/mm/numa.c                            |   84 ++--
 arch/powerpc/mm/pgtable_32.c                      |    6 +-
 arch/powerpc/mm/pgtable_64.c                      |    4 +-
 arch/powerpc/mm/ppc_mmu_32.c                      |    4 +-
 arch/powerpc/mm/stab.c                            |    4 +-
 arch/powerpc/mm/tlb_nohash.c                      |    4 +-
 arch/powerpc/platforms/85xx/corenet_ds.c          |    4 +-
 arch/powerpc/platforms/85xx/mpc8536_ds.c          |    4 +-
 arch/powerpc/platforms/85xx/mpc85xx_ds.c          |    4 +-
 arch/powerpc/platforms/85xx/mpc85xx_mds.c         |    4 +-
 arch/powerpc/platforms/86xx/mpc86xx_hpcn.c        |    4 +-
 arch/powerpc/platforms/cell/iommu.c               |   10 +-
 arch/powerpc/platforms/embedded6xx/wii.c          |   12 +-
 arch/powerpc/platforms/maple/setup.c              |    2 +-
 arch/powerpc/platforms/pasemi/iommu.c             |    4 +-
 arch/powerpc/platforms/powermac/setup.c           |    4 +-
 arch/powerpc/platforms/ps3/htab.c                 |    2 +-
 arch/powerpc/platforms/ps3/mm.c                   |    6 +-
 arch/powerpc/platforms/ps3/os-area.c              |    4 +-
 arch/powerpc/platforms/pseries/hotplug-memory.c   |   38 +-
 arch/powerpc/platforms/pseries/iommu.c            |    2 +-
 arch/powerpc/platforms/pseries/phyp_dump.c        |    4 +-
 arch/powerpc/sysdev/dart_iommu.c                  |    8 +-
 arch/powerpc/sysdev/fsl_pci.c                     |    4 +-
 arch/sh/Kconfig                                   |    2 +-
 arch/sh/include/asm/lmb.h                         |    6 -
 arch/sh/include/asm/memblock.h                    |    6 +
 arch/sh/kernel/machine_kexec.c                    |   18 +-
 arch/sh/kernel/setup.c                            |    8 +-
 arch/sh/mm/init.c                                 |   40 +-
 arch/sh/mm/numa.c                                 |    8 +-
 arch/sparc/Kconfig                                |    2 +-
 arch/sparc/include/asm/lmb.h                      |   10 -
 arch/sparc/include/asm/memblock.h                 |   10 +
 arch/sparc/kernel/mdesc.c                         |   16 +-
 arch/sparc/kernel/prom_64.c                       |    4 +-
 arch/sparc/mm/init_64.c                           |   54 +-
 include/linux/lmb.h                               |   89 ----
 include/linux/memblock.h                          |   89 ++++
 lib/Kconfig                                       |    3 -
 lib/Makefile                                      |    2 -
 lib/lmb.c                                         |  541 ---------------------
 mm/Kconfig                                        |    3 +
 mm/Makefile                                       |    2 +
 mm/memblock.c                                     |  541 +++++++++++++++++++++
 72 files changed, 1025 insertions(+), 1025 deletions(-)
 rename arch/microblaze/include/asm/{lmb.h => memblock.h} (57%)
 delete mode 100644 arch/powerpc/include/asm/lmb.h
 create mode 100644 arch/powerpc/include/asm/memblock.h
 delete mode 100644 arch/sh/include/asm/lmb.h
 create mode 100644 arch/sh/include/asm/memblock.h
 delete mode 100644 arch/sparc/include/asm/lmb.h
 create mode 100644 arch/sparc/include/asm/memblock.h
 delete mode 100644 include/linux/lmb.h
 create mode 100644 include/linux/memblock.h
 delete mode 100644 lib/lmb.c
 create mode 100644 mm/memblock.c


