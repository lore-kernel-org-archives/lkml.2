Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751121Ab2DBEkG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 00:40:06 -0400
Received: from gate.crashing.org ([63.228.1.57]:48692 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752Ab2DBEkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 00:40:04 -0400
Message-ID: <1333341590.30734.47.camel@pasglop>
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Mon, 02 Apr 2012 14:39:50 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

This contains a couple more fixes for the system.h disintegration,
a trivial section mismatch fix, a couple of patches from akpm that I
didn't quite get he expected me to pickup, and a few more trivialities
form Kumar that he appear to have forgotten to send me in the previous
batch.

Cheers,
Ben.

The following changes since commit dd775ae2549217d3ae09363e3edb305d0fa19928:

  Linux 3.4-rc1 (2012-03-31 16:24:09 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

for you to fetch changes up to 9b218f63e50e590fe0c7724a0838d7eaa6dae5ce:

  powerpc/eeh: Fix use of set_current_state() in eeh event handling set_current_state() wart (2012-04-02 14:31:19 +1000)

----------------------------------------------------------------
Andrew Morton (1):
      powerpc/eeh: Fix use of set_current_state() in eeh event handling set_current_state() wart

Benjamin Herrenschmidt (2):
      Merge remote-tracking branch 'kumar/next' into merge
      powerpc/kvm: Fallout from system.h disintegration

Dave Liu (1):
      powerpc/qe: Update the SNUM table for MPC8569 Rev2.0

Diana CRACIUN (1):
      powerpc/dts: Removed fsl,msi property from dts.

Jerry Huang (2):
      powerpc/85xx: add the P1020MBG-PC DTS support
      powerpc/85xx: add the P1020UTM-PC DTS support

Oleg Nesterov (1):
      powerpc/eeh: Remove eeh_event_handler()->daemonize()

Shaveta Leekha (1):
      powerpc/85xx: Enable I2C_CHARDEV and I2C_MPC options in defconfigs

Stephen Rothwell (1):
      powerpc: Fix fallout from system.h split up

Timur Tabi (2):
      powerpc/8xxx: remove 85xx/86xx restrictions from fsl_guts.h
      powerpc/epapr: add "memory" as a clobber to all hypercalls

Uwe Kleine-König (1):
      powerpc: Mark const init data with __initconst instead of __initdata

 arch/powerpc/boot/dts/p1020mbg-pc.dtsi       |  151 ++++++++++++++++++++++++++
 arch/powerpc/boot/dts/p1020mbg-pc_32b.dts    |   89 +++++++++++++++
 arch/powerpc/boot/dts/p1020mbg-pc_36b.dts    |   89 +++++++++++++++
 arch/powerpc/boot/dts/p1020utm-pc.dtsi       |  140 ++++++++++++++++++++++++
 arch/powerpc/boot/dts/p1020utm-pc_32b.dts    |   89 +++++++++++++++
 arch/powerpc/boot/dts/p1020utm-pc_36b.dts    |   89 +++++++++++++++
 arch/powerpc/boot/dts/p2041rdb.dts           |    3 -
 arch/powerpc/boot/dts/p3041ds.dts            |    4 -
 arch/powerpc/boot/dts/p3060qds.dts           |    2 -
 arch/powerpc/boot/dts/p4080ds.dts            |    3 -
 arch/powerpc/boot/dts/p5020ds.dts            |    4 -
 arch/powerpc/configs/corenet32_smp_defconfig |    1 +
 arch/powerpc/configs/corenet64_smp_defconfig |    2 +
 arch/powerpc/configs/mpc85xx_defconfig       |    1 +
 arch/powerpc/configs/mpc85xx_smp_defconfig   |    1 +
 arch/powerpc/include/asm/epapr_hcalls.h      |    7 +-
 arch/powerpc/include/asm/fsl_guts.h          |   26 +----
 arch/powerpc/kernel/fadump.c                 |    2 +
 arch/powerpc/kernel/kgdb.c                   |    1 +
 arch/powerpc/kvm/book3s_emulate.c            |    1 +
 arch/powerpc/kvm/book3s_paired_singles.c     |    1 +
 arch/powerpc/kvm/book3s_pr.c                 |    1 +
 arch/powerpc/platforms/52xx/mpc52xx_pci.c    |    2 +-
 arch/powerpc/platforms/85xx/mpc85xx_mds.c    |    2 +-
 arch/powerpc/platforms/85xx/mpc85xx_rdb.c    |    2 +-
 arch/powerpc/platforms/85xx/p1022_ds.c       |    4 +-
 arch/powerpc/platforms/86xx/mpc8610_hpcd.c   |    2 +-
 arch/powerpc/platforms/cell/qpace_setup.c    |    2 +-
 arch/powerpc/platforms/cell/setup.c          |    2 +-
 arch/powerpc/platforms/pseries/eeh_event.c   |    4 +-
 arch/powerpc/sysdev/qe_lib/qe.c              |   22 +++-
 drivers/net/ethernet/freescale/ucc_geth.c    |    6 +-
 sound/soc/fsl/mpc8610_hpcd.c                 |    8 +-
 sound/soc/fsl/p1022_ds.c                     |   10 +-
 34 files changed, 712 insertions(+), 61 deletions(-)
 create mode 100644 arch/powerpc/boot/dts/p1020mbg-pc.dtsi
 create mode 100644 arch/powerpc/boot/dts/p1020mbg-pc_32b.dts
 create mode 100644 arch/powerpc/boot/dts/p1020mbg-pc_36b.dts
 create mode 100644 arch/powerpc/boot/dts/p1020utm-pc.dtsi
 create mode 100644 arch/powerpc/boot/dts/p1020utm-pc_32b.dts
 create mode 100644 arch/powerpc/boot/dts/p1020utm-pc_36b.dts


