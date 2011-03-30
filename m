Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507Ab1C3CI5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 22:08:57 -0400
Received: from gate.crashing.org ([63.228.1.57]:37902 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754148Ab1C3CI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 22:08:56 -0400
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Mar 2011 13:08:42 +1100
Message-ID: <1301450922.2402.729.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here are a few post -rc1 fixes for powerpc.

Mostly some more fallout from the irq core rework, new syscalls wireup,
defconfig fixes and minor bits. The only feature-esque thing in there
would be me adding dma_mmap_coherent(), it fixes various audio devices
on our older non cache-coherent embedded platforms.

Freescale folks: I've manually added two patches to fix some FSL 8xx and
QE irq build problems caused by the upstream irq rework to the branch.
Please verify that it's all correct and if not send followup patches.

Linus: I didn't wait for hera to sync to the mirrors before sending this
email (I usually do but I have to run and it's very slow today).

The following changes since commit 0ce790e7d736cedc563e1fb4e998babf5a4dbc3d:

  Linux 2.6.39-rc1 (2011-03-29 12:09:47 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git ..BRANCH.NOT.VERIFIED..

Anton Blanchard (2):
      powerpc: Fix accounting of softirq time when idle
      powerpc/pseries: Enable Chelsio network and iWARP drivers

Benjamin Herrenschmidt (4):
      powerpc: Implement dma_mmap_coherent()
      powerpc/mm: Move the STAB0 location to 0x8000 to make room in low memory
      powerpc/8xx: Fix another breakage from the irq_data conversion
      powerpc/qe_ic: Fix another breakage from the irq_data conversion

Jim Keniston (1):
      powerpc/nvram: Don't overwrite oops/panic report on normal shutdown

Milton Miller (3):
      powerpc/xics: Fix numberspace mismatch from irq_desc conversion
      powerpc/xics: Use hwirq for xics domain irq number
      powerpc/pseries/smp: query-cpu-stopped-state support won't change

Scott Wood (1):
      powerpc: ARCH_PFN_OFFSET should be unsigned long

Stephen Rothwell (2):
      powerpc: Restore some misc devices to our configs
      powerpc: Wire up new syscalls

Thomas Gleixner (1):
      powerpc/cell: Use handle_edge_eoi_irq for real

Varun Sethi (1):
      powerpc/booke: Correct the SPRN_MAS5 definition.

 arch/powerpc/configs/44x/warp_defconfig          |    1 +
 arch/powerpc/configs/52xx/motionpro_defconfig    |    1 +
 arch/powerpc/configs/86xx/gef_ppc9a_defconfig    |    1 +
 arch/powerpc/configs/86xx/gef_sbc310_defconfig   |    1 +
 arch/powerpc/configs/86xx/gef_sbc610_defconfig   |    1 +
 arch/powerpc/configs/86xx/mpc8641_hpcn_defconfig |    1 +
 arch/powerpc/configs/e55xx_smp_defconfig         |    1 +
 arch/powerpc/configs/linkstation_defconfig       |    1 +
 arch/powerpc/configs/mpc512x_defconfig           |    1 +
 arch/powerpc/configs/mpc5200_defconfig           |    1 +
 arch/powerpc/configs/mpc85xx_defconfig           |    1 +
 arch/powerpc/configs/mpc85xx_smp_defconfig       |    1 +
 arch/powerpc/configs/mpc86xx_defconfig           |    1 +
 arch/powerpc/configs/pasemi_defconfig            |    1 +
 arch/powerpc/configs/ppc6xx_defconfig            |    1 +
 arch/powerpc/configs/pseries_defconfig           |    3 +
 arch/powerpc/include/asm/dma-mapping.h           |    6 ++
 arch/powerpc/include/asm/mmu-hash64.h            |    2 +-
 arch/powerpc/include/asm/page.h                  |    2 +-
 arch/powerpc/include/asm/qe_ic.h                 |   16 +++---
 arch/powerpc/include/asm/reg_booke.h             |    2 +-
 arch/powerpc/include/asm/systbl.h                |    4 +
 arch/powerpc/include/asm/unistd.h                |    6 ++-
 arch/powerpc/kernel/dma.c                        |   18 ++++++
 arch/powerpc/kernel/exceptions-64s.S             |   28 ++++----
 arch/powerpc/kernel/time.c                       |    2 +-
 arch/powerpc/mm/dma-noncoherent.c                |   20 ++++++
 arch/powerpc/platforms/cell/interrupt.c          |    2 +-
 arch/powerpc/platforms/pseries/nvram.c           |   24 +++++++
 arch/powerpc/platforms/pseries/smp.c             |    4 +-
 arch/powerpc/platforms/pseries/xics.c            |   71 +++++++++++-----------
 arch/powerpc/sysdev/mpc8xx_pic.c                 |    2 +-
 32 files changed, 161 insertions(+), 66 deletions(-)

Cheers,
Ben.


 

