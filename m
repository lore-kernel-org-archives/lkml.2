Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab0HXGfI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 02:35:08 -0400
Received: from gate.crashing.org ([63.228.1.57]:32942 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953Ab0HXGfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 02:35:05 -0400
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Aug 2010 16:34:53 +1000
Message-ID: <1282631693.22370.526.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here's a few powerpc bits & fixes for 2.6.36, some of them for some of
the new stuff that went in, along with the powerpc rwsem update to
atomic_long_t (not yet moved to asm-generic) and wiring up of some new
syscalls.

Cheers,
Ben.

The following changes since commit d1b113bb028999e82a8528e1484be8c23fb5a7d9:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/net-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git master

Anatolij Gustschin (1):
      powerpc: Fix typo in uImage target

Andreas Schwab (3):
      powerpc: Wire up fanotify_init, fanotify_mark, prlimit64 syscalls
      via-pmu: Add compat_pmu_ioctl
      powerpc: Fix config dependency problem with MPIC_U3_HT_IRQS

Anton Blanchard (4):
      powerpc/mm: Fix vsid_scrample typo
      powerpc/kdump: Stop all other CPUs before running crash handlers
      powerpc: Inline ppc64_runlatch_off
      powerpc: Fix bogus it_blocksize in VIO iommu code

Benjamin Herrenschmidt (2):
      Merge remote branch 'jwb/merge' into merge
      powerpc: Make rwsem use "long" type

Dave Kleikamp (4):
      powerpc/47x: Make sure mcsr is cleared before enabling machine check interrupts
      powerpc/47x: Remove redundant line from cputable.c
      powerpc/4xx: Index interrupt stacks by physical cpu
      powerpc/47x: Add an isync before the tlbivax instruction

Denis Kirjanov (1):
      powerpc: Use is_32bit_task() helper to test 32 bit binary

Grant Likely (1):
      powerpc/pci: Fix checking for child bridges in PCI code.

Julia Lawall (3):
      powerpc/powermac: Drop unnecessary of_node_put
      powerpc/powermac: Drop unnecessary null test
      powerpc/pci: Drop unnecessary null test

Matt Evans (1):
      powerpc: Initialise paca->kstack before early_setup_secondary

Nathan Fontenot (1):
      powerpc: Correct smt_enabled=X boot option for > 2 threads per core

Rupjyoti Sarmah (1):
      powerpc/4xx: Device tree update for the 460ex DWC SATA

Signed-off-by: Darren Hart (3):
      powerpc: Re-enable preemption before cpu_die()
      powerpc: Silence __cpu_up() under normal operation
      powerpc: Silence xics_migrate_irqs_away() during cpu offline

Sonny Rao (1):
      powerpc: Export memstart_addr and kernstart_addr on ppc64

 arch/powerpc/Makefile                     |    2 +-
 arch/powerpc/boot/dts/canyonlands.dts     |    8 ++++
 arch/powerpc/include/asm/mmu-hash64.h     |    2 +-
 arch/powerpc/include/asm/reg.h            |    9 ++++-
 arch/powerpc/include/asm/rwsem.h          |   64 +++++++++++++++++------------
 arch/powerpc/include/asm/systbl.h         |    3 +
 arch/powerpc/include/asm/unistd.h         |    5 ++-
 arch/powerpc/kernel/cputable.c            |    1 -
 arch/powerpc/kernel/crash.c               |   24 ++++++-----
 arch/powerpc/kernel/head_44x.S            |    4 ++
 arch/powerpc/kernel/head_64.S             |    6 +-
 arch/powerpc/kernel/idle.c                |    2 +-
 arch/powerpc/kernel/irq.c                 |   16 ++++---
 arch/powerpc/kernel/pci_of_scan.c         |    2 +-
 arch/powerpc/kernel/process.c             |   20 ++++-----
 arch/powerpc/kernel/setup_32.c            |    9 ++--
 arch/powerpc/kernel/setup_64.c            |   63 ++++++++++++++++------------
 arch/powerpc/kernel/smp.c                 |    4 +-
 arch/powerpc/kernel/sys_ppc32.c           |    8 ++++
 arch/powerpc/kernel/vio.c                 |    3 +-
 arch/powerpc/mm/init_64.c                 |    2 +
 arch/powerpc/mm/tlb_nohash_low.S          |    1 +
 arch/powerpc/platforms/Kconfig            |    3 +-
 arch/powerpc/platforms/cell/iommu.c       |    2 +-
 arch/powerpc/platforms/iseries/iommu.c    |    2 +-
 arch/powerpc/platforms/powermac/feature.c |    3 +-
 arch/powerpc/platforms/powermac/pci.c     |    2 -
 arch/powerpc/platforms/pseries/iommu.c    |    8 ++--
 arch/powerpc/platforms/pseries/smp.c      |   11 +++--
 arch/powerpc/platforms/pseries/xics.c     |    6 ++-
 drivers/macintosh/via-pmu.c               |   42 +++++++++++++++++++
 31 files changed, 219 insertions(+), 118 deletions(-)


