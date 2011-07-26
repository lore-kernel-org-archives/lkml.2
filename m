Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab1GZWhu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 18:37:50 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61651 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075Ab1GZWhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 18:37:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <rmk@arm.linux.org.uk>
Subject: [GIT PULL] arm-soc cross-platform cleanups for 3.1
Date: Wed, 27 Jul 2011 00:36:45 +0200
Message-ID: <2178768.MnKF3D4aeP@wuerfel>
User-Agent: KMail/4.6.0 (Linux/3.0.0-rc1nosema+; KDE/4.6.90; x86_64; ; )
In-Reply-To: <1687325.AEKSI6RCv5@wuerfel>
References: <3057645.NjCAYUXHGt@wuerfel> <1687325.AEKSI6RCv5@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:YeAi+KRYaXwcnU3yAzL85ym0R+SnjJwqqzali0Gf7Uh
 w/8IsDnBPVm0sA/5ExHDf7isOb1bfoy6osMg9yd+1E3vwCDpUf
 BLBkCsqpdQ5RGfJTOAPJXPZZNma/Qk5ZePV2E83QFkcXDa5j3a
 RejsI+OtCdIhsJw048j+qU3YMso38nArdTTBJtD9q9PvA1tfNL
 6Zpv3EP/MTdnvx/6m2G1Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

These are cleanups that unify code across platforms in the arm architecture,
as opposed to the earlier cleanups I sent that clean up code within
each platform. There is a small merge conflict in the
arch/microblaze/include/asm/pci-bridge.h file that should be resolved
by simply removing the enum that was changed in another branch.

	Arnd

The following changes since commit ba5b56cb3e3d2cab73d4fee9a022bb69462a8cd9:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client (2011-07-26 13:38:50 -0700)

are available in the git repository at:

  git+ssh://master.kernel.org/pub/scm/linux/kernel/git/arm/linux-arm-soc.git/ next/cross-platform

Arnd Bergmann (1):
      Merge branch 'cross-platform/clkdev' into next/cross-platform

Kyungmin Park (1):
      ARM: Consolidate the clkdev header files

Rob Herring (6):
      powerpc: rename ppc_pci_*_flags to pci_*_flags
      pci: move microblaze and powerpc pci flag functions into asm-generic
      ARM: remove unnecessary mach/hardware.h includes
      ARM: pci: make pcibios_assign_all_busses use pci_has_flag
      ARM: convert PCI defines to variables
      ARM: set vga memory base at run-time

 arch/arm/Kconfig                                 |    6 ++
 arch/arm/include/asm/clkdev.h                    |    5 ++
 arch/arm/include/asm/pci.h                       |   12 ++++-
 arch/arm/include/asm/vga.h                       |    5 +-
 arch/arm/lib/ecard.S                             |    1 -
 arch/arm/lib/io-readsw-armv3.S                   |    1 -
 arch/arm/lib/io-writesw-armv3.S                  |    1 -
 arch/arm/mach-at91/include/mach/clkdev.h         |    7 --
 arch/arm/mach-bcmring/include/mach/clkdev.h      |    7 --
 arch/arm/mach-bcmring/include/mach/hardware.h    |    2 -
 arch/arm/mach-cns3xxx/cns3420vb.c                |    1 -
 arch/arm/mach-cns3xxx/include/mach/hardware.h    |   22 -------
 arch/arm/mach-cns3xxx/pcie.c                     |    3 +
 arch/arm/mach-davinci/include/mach/clkdev.h      |   15 -----
 arch/arm/mach-dove/include/mach/hardware.h       |    7 --
 arch/arm/mach-dove/pcie.c                        |    3 +
 arch/arm/mach-ep93xx/include/mach/clkdev.h       |   11 ----
 arch/arm/mach-ep93xx/include/mach/hardware.h     |    2 -
 arch/arm/mach-footbridge/dc21285.c               |    3 +
 arch/arm/mach-footbridge/include/mach/hardware.h |    5 --
 arch/arm/mach-integrator/include/mach/hardware.h |    7 --
 arch/arm/mach-integrator/pci_v3.c                |    5 ++
 arch/arm/mach-iop13xx/include/mach/hardware.h    |    7 --
 arch/arm/mach-iop13xx/pci.c                      |    5 +-
 arch/arm/mach-iop32x/include/mach/hardware.h     |    3 -
 arch/arm/mach-iop33x/include/mach/hardware.h     |    3 -
 arch/arm/mach-ixp2000/include/mach/hardware.h    |    8 ---
 arch/arm/mach-ixp2000/pci.c                      |    5 ++
 arch/arm/mach-ixp23xx/include/mach/hardware.h    |    4 -
 arch/arm/mach-ixp23xx/pci.c                      |    5 ++
 arch/arm/mach-ixp4xx/common-pci.c                |    5 ++
 arch/arm/mach-ixp4xx/include/mach/hardware.h     |    5 --
 arch/arm/mach-kirkwood/include/mach/hardware.h   |    7 --
 arch/arm/mach-kirkwood/pcie.c                    |    3 +
 arch/arm/mach-ks8695/include/mach/hardware.h     |    9 ---
 arch/arm/mach-ks8695/pci.c                       |    3 +
 arch/arm/mach-lpc32xx/include/mach/clkdev.h      |   25 --------
 arch/arm/mach-mmp/include/mach/clkdev.h          |    7 --
 arch/arm/mach-msm/include/mach/clkdev.h          |   19 ------
 arch/arm/mach-mv78xx0/include/mach/hardware.h    |    7 --
 arch/arm/mach-mv78xx0/pcie.c                     |    3 +
 arch/arm/mach-mxs/include/mach/clkdev.h          |    7 --
 arch/arm/mach-nomadik/include/mach/clkdev.h      |    7 --
 arch/arm/mach-nuc93x/include/mach/clkdev.h       |    7 --
 arch/arm/mach-omap1/include/mach/clkdev.h        |    5 --
 arch/arm/mach-omap2/include/mach/clkdev.h        |    5 --
 arch/arm/mach-orion5x/include/mach/hardware.h    |    7 --
 arch/arm/mach-orion5x/pci.c                      |    2 +
 arch/arm/mach-pnx4008/include/mach/clkdev.h      |    7 --
 arch/arm/mach-pxa/cm-x2xx-pci.c                  |    3 +
 arch/arm/mach-pxa/include/mach/clkdev.h          |    7 --
 arch/arm/mach-pxa/include/mach/hardware.h        |    3 -
 arch/arm/mach-sa1100/include/mach/hardware.h     |    8 ---
 arch/arm/mach-sa1100/pci-nanoengine.c            |    3 +
 arch/arm/mach-shark/include/mach/hardware.h      |    6 --
 arch/arm/mach-shark/pci.c                        |   12 +++-
 arch/arm/mach-spear3xx/include/mach/clkdev.h     |   19 ------
 arch/arm/mach-spear6xx/include/mach/clkdev.h     |   19 ------
 arch/arm/mach-tegra/include/mach/clkdev.h        |   34 -----------
 arch/arm/mach-tegra/include/mach/hardware.h      |   28 ---------
 arch/arm/mach-tegra/include/mach/system.h        |    1 -
 arch/arm/mach-tegra/io.c                         |    1 -
 arch/arm/mach-tegra/pcie.c                       |    2 +
 arch/arm/mach-tegra/platsmp.c                    |    1 -
 arch/arm/mach-ux500/include/mach/clkdev.h        |    7 --
 arch/arm/mach-versatile/include/mach/hardware.h  |    6 --
 arch/arm/mach-versatile/pci.c                    |    3 +
 arch/arm/mach-w90x900/include/mach/clkdev.h      |    7 --
 arch/arm/mm/iomap.c                              |   12 ++++
 arch/arm/mm/proc-xsc3.S                          |    1 -
 arch/arm/plat-iop/pci.c                          |    3 +
 arch/arm/plat-mxc/include/mach/clkdev.h          |    7 --
 arch/arm/plat-omap/include/plat/clkdev.h         |   13 ----
 arch/arm/plat-spear/include/plat/clkdev.h        |   20 -------
 arch/arm/plat-tcc/include/mach/clkdev.h          |    7 --
 arch/microblaze/include/asm/pci-bridge.h         |   67 +++------------------
 arch/powerpc/include/asm/pci-bridge.h            |   50 +----------------
 arch/powerpc/include/asm/pci.h                   |    2 +-
 arch/powerpc/kernel/pci-common.c                 |   22 ++++----
 arch/powerpc/kernel/pci_32.c                     |    2 +-
 arch/powerpc/kernel/pci_64.c                     |    4 +-
 arch/powerpc/kernel/rtas_pci.c                   |    2 +-
 arch/powerpc/platforms/40x/ep405.c               |    2 +-
 arch/powerpc/platforms/40x/ppc40x_simple.c       |    2 +-
 arch/powerpc/platforms/40x/walnut.c              |    2 +-
 arch/powerpc/platforms/44x/canyonlands.c         |    2 +-
 arch/powerpc/platforms/44x/ebony.c               |    2 +-
 arch/powerpc/platforms/44x/ppc44x_simple.c       |    2 +-
 arch/powerpc/platforms/44x/sam440ep.c            |    2 +-
 arch/powerpc/platforms/52xx/mpc52xx_pci.c        |    2 +-
 arch/powerpc/platforms/82xx/pq2.c                |    2 +-
 arch/powerpc/platforms/chrp/pci.c                |    2 +-
 arch/powerpc/platforms/powermac/pci.c            |    6 +-
 arch/powerpc/sysdev/fsl_pci.c                    |    4 +-
 arch/powerpc/sysdev/grackle.c                    |    2 +-
 arch/powerpc/sysdev/ppc4xx_pci.c                 |    2 +-
 drivers/clk/Kconfig                              |    3 +
 include/asm-generic/pci-bridge.h                 |   62 ++++++++++++++++++++
 98 files changed, 212 insertions(+), 580 deletions(-)
 delete mode 100644 arch/arm/mach-at91/include/mach/clkdev.h
 delete mode 100644 arch/arm/mach-bcmring/include/mach/clkdev.h
 delete mode 100644 arch/arm/mach-cns3xxx/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-davinci/include/mach/clkdev.h
 delete mode 100644 arch/arm/mach-ep93xx/include/mach/clkdev.h
 delete mode 100644 arch/arm/mach-lpc32xx/include/mach/clkdev.h
 delete mode 100644 arch/arm/mach-mmp/include/mach/clkdev.h
 delete mode 100644 arch/arm/mach-msm/include/mach/clkdev.h
 delete mode 100644 arch/arm/mach-mxs/include/mach/clkdev.h
 delete mode 100644 arch/arm/mach-nomadik/include/mach/clkdev.h
 delete mode 100644 arch/arm/mach-nuc93x/include/mach/clkdev.h
 delete mode 100644 arch/arm/mach-omap1/include/mach/clkdev.h
 delete mode 100644 arch/arm/mach-omap2/include/mach/clkdev.h
 delete mode 100644 arch/arm/mach-pnx4008/include/mach/clkdev.h
 delete mode 100644 arch/arm/mach-pxa/include/mach/clkdev.h
 delete mode 100644 arch/arm/mach-spear3xx/include/mach/clkdev.h
 delete mode 100644 arch/arm/mach-spear6xx/include/mach/clkdev.h
 delete mode 100644 arch/arm/mach-tegra/include/mach/clkdev.h
 delete mode 100644 arch/arm/mach-tegra/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-ux500/include/mach/clkdev.h
 delete mode 100644 arch/arm/mach-w90x900/include/mach/clkdev.h
 delete mode 100644 arch/arm/plat-mxc/include/mach/clkdev.h
 delete mode 100644 arch/arm/plat-omap/include/plat/clkdev.h
 delete mode 100644 arch/arm/plat-spear/include/plat/clkdev.h
 delete mode 100644 arch/arm/plat-tcc/include/mach/clkdev.h
 create mode 100644 include/asm-generic/pci-bridge.h
