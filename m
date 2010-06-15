Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab0FOGaN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 02:30:13 -0400
Received: from gate.crashing.org ([63.228.1.57]:43020 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752303Ab0FOGaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 02:30:11 -0400
Subject: [git pull] Please pull powerpc.git next branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Jun 2010 16:29:58 +1000
Message-ID: <1276583398.2552.89.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here's a few powerpc fixes for 2.6.35. The diffstat is sadly bloated by
a small defconfig change, I hate that too :-) We'll switch to some
better mechanism as soon as the dust as settled on what that mechanism
should be, hopefully real soon.

Cheers,
Ben.

The following changes since commit 7e27d6e778cd87b6f2415515d7127eba53fe5d02:
  Linus Torvalds (1):
        Linux 2.6.35-rc3

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Alastair Bridgewater (1):
      powerpc: Fix mpic_resume on early G5 macs

Anton Blanchard (1):
      powerpc: Move kdump default base address to 64MB on 64bit

Benjamin Herrenschmidt (1):
      Merge commit 'kumar/merge' into merge

Christoph Egger (1):
      powerpc: Remove dead CONFIG_HIGHPTE

Christoph Hellwig (1):
      powerpc: Unconditionally enabled irq stacks

Grant Likely (1):
      powerpc: Disable CONFIG_SYSFS_DEPRECATED

Kumar Gala (1):
      powerpc/fsl-booke: Move loadcam_entry back to asm code to fix SMP ftrace

Li Yang (1):
      powerpc/fsl-booke: Fix InstructionTLBError execute permission check

Matt Evans (1):
      powerpc/kexec: Wait for online/possible CPUs only.

Milton Miller (1):
      powerpc: rtas_flash needs to use rtas_data_buf

Paul Mackerras (1):
      powerpc/boot: Remove addRamdisk.c since it is now unused

 arch/powerpc/Kconfig.debug                       |    7 -
 arch/powerpc/boot/Makefile                       |    2 +-
 arch/powerpc/boot/addRamDisk.c                   |  311 ----------------------
 arch/powerpc/configs/40x/acadia_defconfig        |    3 +-
 arch/powerpc/configs/40x/ep405_defconfig         |    3 +-
 arch/powerpc/configs/40x/hcu4_defconfig          |    3 +-
 arch/powerpc/configs/40x/kilauea_defconfig       |    3 +-
 arch/powerpc/configs/40x/makalu_defconfig        |    3 +-
 arch/powerpc/configs/40x/virtex_defconfig        |    3 +-
 arch/powerpc/configs/40x/walnut_defconfig        |    3 +-
 arch/powerpc/configs/44x/arches_defconfig        |    3 +-
 arch/powerpc/configs/44x/bamboo_defconfig        |    3 +-
 arch/powerpc/configs/44x/canyonlands_defconfig   |    3 +-
 arch/powerpc/configs/44x/ebony_defconfig         |    3 +-
 arch/powerpc/configs/44x/eiger_defconfig         |    3 +-
 arch/powerpc/configs/44x/katmai_defconfig        |    3 +-
 arch/powerpc/configs/44x/rainier_defconfig       |    3 +-
 arch/powerpc/configs/44x/redwood_defconfig       |    3 +-
 arch/powerpc/configs/44x/sam440ep_defconfig      |    3 +-
 arch/powerpc/configs/44x/sequoia_defconfig       |    3 +-
 arch/powerpc/configs/44x/taishan_defconfig       |    3 +-
 arch/powerpc/configs/44x/virtex5_defconfig       |    3 +-
 arch/powerpc/configs/52xx/cm5200_defconfig       |    3 +-
 arch/powerpc/configs/52xx/lite5200b_defconfig    |    3 +-
 arch/powerpc/configs/52xx/motionpro_defconfig    |    3 +-
 arch/powerpc/configs/52xx/pcm030_defconfig       |    3 +-
 arch/powerpc/configs/52xx/tqm5200_defconfig      |    3 +-
 arch/powerpc/configs/86xx/gef_ppc9a_defconfig    |    3 +-
 arch/powerpc/configs/86xx/gef_sbc310_defconfig   |    3 +-
 arch/powerpc/configs/86xx/gef_sbc610_defconfig   |    3 +-
 arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig |    3 +-
 arch/powerpc/configs/86xx/mpc8641_hpcn_defconfig |    3 +-
 arch/powerpc/configs/86xx/sbc8641d_defconfig     |    3 +-
 arch/powerpc/configs/adder875_defconfig          |    3 +-
 arch/powerpc/configs/amigaone_defconfig          |    3 +-
 arch/powerpc/configs/c2k_defconfig               |    3 +-
 arch/powerpc/configs/cell_defconfig              |    3 +-
 arch/powerpc/configs/celleb_defconfig            |    3 +-
 arch/powerpc/configs/chrp32_defconfig            |    3 +-
 arch/powerpc/configs/ep8248e_defconfig           |    3 +-
 arch/powerpc/configs/ep88xc_defconfig            |    3 +-
 arch/powerpc/configs/g5_defconfig                |    3 +-
 arch/powerpc/configs/gamecube_defconfig          |    3 +-
 arch/powerpc/configs/holly_defconfig             |    1 -
 arch/powerpc/configs/iseries_defconfig           |    3 +-
 arch/powerpc/configs/linkstation_defconfig       |    3 +-
 arch/powerpc/configs/maple_defconfig             |    3 +-
 arch/powerpc/configs/mgcoge_defconfig            |    3 +-
 arch/powerpc/configs/mgsuvd_defconfig            |    3 +-
 arch/powerpc/configs/mpc512x_defconfig           |    3 +-
 arch/powerpc/configs/mpc5200_defconfig           |    3 +-
 arch/powerpc/configs/mpc7448_hpc2_defconfig      |    3 +-
 arch/powerpc/configs/pasemi_defconfig            |    3 +-
 arch/powerpc/configs/pmac32_defconfig            |    3 +-
 arch/powerpc/configs/ppc40x_defconfig            |    3 +-
 arch/powerpc/configs/ppc44x_defconfig            |    3 +-
 arch/powerpc/configs/ppc64_defconfig             |    3 +-
 arch/powerpc/configs/ppc64e_defconfig            |    3 +-
 arch/powerpc/configs/pq2fads_defconfig           |    3 +-
 arch/powerpc/configs/prpmc2800_defconfig         |    3 +-
 arch/powerpc/configs/pseries_defconfig           |    3 +-
 arch/powerpc/configs/storcenter_defconfig        |    3 +-
 arch/powerpc/configs/wii_defconfig               |    3 +-
 arch/powerpc/include/asm/irq.h                   |    6 -
 arch/powerpc/include/asm/kdump.h                 |   11 +-
 arch/powerpc/kernel/irq.c                        |   12 -
 arch/powerpc/kernel/machine_kexec_64.c           |   18 +--
 arch/powerpc/kernel/misc_32.S                    |    2 -
 arch/powerpc/kernel/misc_64.S                    |    2 -
 arch/powerpc/kernel/process.c                    |    5 -
 arch/powerpc/kernel/rtas_flash.c                 |   39 ++--
 arch/powerpc/kernel/setup_32.c                   |    4 -
 arch/powerpc/kernel/setup_64.c                   |    4 -
 arch/powerpc/mm/pgtable_32.c                     |    4 -
 arch/powerpc/sysdev/mpic.c                       |    2 +-
 75 files changed, 93 insertions(+), 514 deletions(-)
 delete mode 100644 arch/powerpc/boot/addRamDisk.c
 

