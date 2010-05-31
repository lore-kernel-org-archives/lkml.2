Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289Ab0EaB7B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 21:59:01 -0400
Received: from gate.crashing.org ([63.228.1.57]:60980 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929Ab0EaB67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 21:58:59 -0400
Subject: [git pull] Please pull powerpc.git next branch (or not...)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 May 2010 11:58:48 +1000
Message-ID: <1275271128.1931.545.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

So some of these you might decide are too late, in which case I'll just
make this branch my -next for the next cycle and cherry pick a few bug
fixes.

It's some embedded changes, not all fixes, that are late mostly because
I forgot to pull from Josh (the stuff was submitted and reviewed ages
ago and is pretty low risk), and in the case of Kumar, because his a
manager now which sucks :-)

I think they are ok in that they only have a potential to break their
respective embedded platforms, but I'll let you judge.

Cheers,
Ben.

The following changes since commit 67a3e12b05e055c0415c556a315a3d3eb637e29e:
  Linus Torvalds (1):
        Linux 2.6.35-rc1

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git next

Anatolij Gustschin (1):
      powerpc/44x: icon: select SM502 and frame buffer console support

Andy Fleming (1):
      powerpc/85xx: Enable support for ports 3 and 4 on 8548 CDS

Anton Vorontsov (1):
      powerpc/fsl-booke: Add hibernation support for FSL BookE processors

Benjamin Herrenschmidt (4):
      powerpc/44x: Fix UART clocks on 440SPe
      Merge commit 'jwb/next' into next
      Merge commit 'kumar/next' into next
      powerpc: Don't export cvt_fd & _df when CONFIG_PPC_FPU is not set

Haiying Wang (1):
      powerpc/85xx: Add P1021MDS board support

Lan Chunhe-B25806 (1):
      powerpc/fsl_msi: Add multiple MSI bank support

Li Yang (5):
      powerpc/fsl_msi: fix the conflict of virt_msir's chip_data
      powerpc/fsl_msi: enable msi allocation in all banks
      powerpc/fsl_msi: enable msi sharing through AMP OSes
      powerpc/fsl_msi: add removal path and probe failing path
      powerpc/85xx: Change MPC8572DS camp dtses for MSI sharing

Scott Wood (1):
      powerpc/e500mc: Implement machine check handler.

Sebastian Andrzej Siewior (3):
      powerpc/fsl-booke: fix the case where we are not in the first page
      powerpc/fsl-booke: Move the entry setup code into a seperate file
      powerpc/kexec: Add support for FSL-BookE

Stefan Roese (2):
      powerpc/44x: Add reset-type to katmai.dts
      powerpc/44x: Add basic ICON PPC440SPe board support

Tirumala Marri (1):
      powerpc/44x: Adding PCI-E support for PowerPC 460SX based SOC.

 arch/powerpc/Kconfig                           |    2 +-
 arch/powerpc/boot/4xx.c                        |   12 +-
 arch/powerpc/boot/dts/icon.dts                 |  447 ++++++++
 arch/powerpc/boot/dts/katmai.dts               |    1 +
 arch/powerpc/boot/dts/mpc8548cds.dts           |    4 -
 arch/powerpc/boot/dts/mpc8572ds_camp_core0.dts |   15 +-
 arch/powerpc/boot/dts/mpc8572ds_camp_core1.dts |    7 +-
 arch/powerpc/boot/dts/p1021mds.dts             |  698 ++++++++++++
 arch/powerpc/boot/dts/redwood.dts              |  122 ++
 arch/powerpc/configs/44x/icon_defconfig        | 1451 ++++++++++++++++++++++++
 arch/powerpc/include/asm/cputable.h            |    1 +
 arch/powerpc/include/asm/kexec.h               |   13 +
 arch/powerpc/include/asm/reg_booke.h           |   33 +-
 arch/powerpc/kernel/Makefile                   |    8 +-
 arch/powerpc/kernel/cputable.c                 |    2 +-
 arch/powerpc/kernel/crash.c                    |    4 +
 arch/powerpc/kernel/fsl_booke_entry_mapping.S  |  237 ++++
 arch/powerpc/kernel/head_fsl_booke.S           |  200 +----
 arch/powerpc/kernel/misc_32.S                  |   17 +
 arch/powerpc/kernel/ppc_ksyms.c                |    2 +-
 arch/powerpc/kernel/swsusp_booke.S             |  193 ++++
 arch/powerpc/kernel/traps.c                    |   88 ++-
 arch/powerpc/platforms/44x/Kconfig             |   11 +
 arch/powerpc/platforms/44x/ppc44x_simple.c     |    3 +-
 arch/powerpc/platforms/85xx/mpc85xx_mds.c      |  102 ++-
 arch/powerpc/sysdev/fsl_msi.c                  |  117 ++-
 arch/powerpc/sysdev/fsl_msi.h                  |    3 +
 arch/powerpc/sysdev/ppc4xx_pci.c               |  119 ++
 arch/powerpc/sysdev/ppc4xx_pci.h               |   58 +
 29 files changed, 3712 insertions(+), 258 deletions(-)
 create mode 100644 arch/powerpc/boot/dts/icon.dts
 create mode 100644 arch/powerpc/boot/dts/p1021mds.dts
 create mode 100644 arch/powerpc/configs/44x/icon_defconfig
 create mode 100644 arch/powerpc/kernel/fsl_booke_entry_mapping.S
 create mode 100644 arch/powerpc/kernel/swsusp_booke.S


