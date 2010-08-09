Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750890Ab0HIEMO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 00:12:14 -0400
Received: from gate.crashing.org ([63.228.1.57]:57298 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724Ab0HIEMM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 00:12:12 -0400
Subject: [git pull] Please pull powerpc.git next branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Aug 2010 14:11:27 +1000
Message-ID: <1281327087.2168.67.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here's a few misc things for .36. The big bit is that I trimmed all the
defconfigs using make savedefconfig.

Then there's a revert for a change to the appletouch driver that went
in .34 but broke quite a few powerbooks around. Since the original
problem this was trying to address is fairly minor and the "fix" 
completely breaks a number of devices, I decided to send you a revert
for now until we sort it out.

Finally, a couple of 52xx embedded bits from Grant that he forgot
last time around and a build fix.

Cheers,
Ben.

The following changes since commit 45d7f32c7a43cbb9592886d38190e379e2eb2226:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../cmetcalf/linux-tile

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Benjamin Herrenschmidt (4):
      powerpc: Trim defconfigs
      memblock: Fix memblock_is_region_reserved() to return a boolean
      Merge remote branch 'gcl/next' into next
      Revert "Input: appletouch - fix integer overflow issue"

Eric Millbrandt (2):
      powerpc/5200: add mpc5200_psc_ac97_gpio_reset
      sound/soc: mpc5200_psc_ac97: Use gpio pins for cold reset

Grant Likely (1):
      powerpc: fix i8042 module build error

 arch/powerpc/configs/40x/acadia_defconfig         | 1003 +----------
 arch/powerpc/configs/40x/ep405_defconfig          | 1212 +------------
 arch/powerpc/configs/40x/hcu4_defconfig           | 1065 +----------
 arch/powerpc/configs/40x/kilauea_defconfig        | 1198 +-----------
 arch/powerpc/configs/40x/makalu_defconfig         | 1006 +----------
 arch/powerpc/configs/40x/virtex_defconfig         | 1107 +-----------
 arch/powerpc/configs/40x/walnut_defconfig         | 1090 +----------
 arch/powerpc/configs/44x/arches_defconfig         | 1060 +----------
 arch/powerpc/configs/44x/bamboo_defconfig         | 1021 +----------
 arch/powerpc/configs/44x/canyonlands_defconfig    | 1264 +------------
 arch/powerpc/configs/44x/ebony_defconfig          | 1104 +-----------
 arch/powerpc/configs/44x/eiger_defconfig          | 1176 +-----------
 arch/powerpc/configs/44x/icon_defconfig           | 1334 +-------------
 arch/powerpc/configs/44x/iss476-smp_defconfig     |  938 +---------
 arch/powerpc/configs/44x/katmai_defconfig         | 1089 +----------
 arch/powerpc/configs/44x/rainier_defconfig        | 1091 +----------
 arch/powerpc/configs/44x/redwood_defconfig        | 1167 +-----------
 arch/powerpc/configs/44x/sam440ep_defconfig       | 1320 +-------------
 arch/powerpc/configs/44x/sequoia_defconfig        | 1112 +-----------
 arch/powerpc/configs/44x/taishan_defconfig        | 1098 +-----------
 arch/powerpc/configs/44x/virtex5_defconfig        | 1113 +-----------
 arch/powerpc/configs/44x/warp_defconfig           | 1389 +-------------
 arch/powerpc/configs/52xx/cm5200_defconfig        | 1232 +------------
 arch/powerpc/configs/52xx/lite5200b_defconfig     | 1257 +------------
 arch/powerpc/configs/52xx/motionpro_defconfig     | 1265 +------------
 arch/powerpc/configs/52xx/pcm030_defconfig        | 1220 +------------
 arch/powerpc/configs/52xx/tqm5200_defconfig       | 1367 +-------------
 arch/powerpc/configs/83xx/asp8347_defconfig       | 1433 +--------------
 arch/powerpc/configs/83xx/kmeter1_defconfig       |  929 +---------
 arch/powerpc/configs/83xx/mpc8313_rdb_defconfig   | 1729 +----------------
 arch/powerpc/configs/83xx/mpc8315_rdb_defconfig   | 1798 +-----------------
 arch/powerpc/configs/83xx/mpc832x_mds_defconfig   | 1329 +-------------
 arch/powerpc/configs/83xx/mpc832x_rdb_defconfig   | 1476 +--------------
 arch/powerpc/configs/83xx/mpc834x_itx_defconfig   | 1568 +---------------
 arch/powerpc/configs/83xx/mpc834x_itxgp_defconfig | 1454 +--------------
 arch/powerpc/configs/83xx/mpc834x_mds_defconfig   | 1263 +------------
 arch/powerpc/configs/83xx/mpc836x_mds_defconfig   | 1404 +-------------
 arch/powerpc/configs/83xx/mpc836x_rdk_defconfig   | 1305 +------------
 arch/powerpc/configs/83xx/mpc837x_mds_defconfig   | 1334 +-------------
 arch/powerpc/configs/83xx/mpc837x_rdb_defconfig   | 1472 +--------------
 arch/powerpc/configs/83xx/sbc834x_defconfig       | 1398 +-------------
 arch/powerpc/configs/85xx/ksi8560_defconfig       | 1117 -----------
 arch/powerpc/configs/85xx/mpc8540_ads_defconfig   |  992 +----------
 arch/powerpc/configs/85xx/mpc8560_ads_defconfig   | 1137 -----------
 arch/powerpc/configs/85xx/mpc85xx_cds_defconfig   | 1155 +-----------
 arch/powerpc/configs/85xx/sbc8548_defconfig       | 1003 +----------
 arch/powerpc/configs/85xx/sbc8560_defconfig       | 1029 +----------
 arch/powerpc/configs/85xx/socrates_defconfig      | 1643 ----------------
 arch/powerpc/configs/85xx/stx_gp3_defconfig       | 1528 +--------------
 arch/powerpc/configs/85xx/tqm8540_defconfig       | 1317 -------------
 arch/powerpc/configs/85xx/tqm8541_defconfig       | 1363 -------------
 arch/powerpc/configs/85xx/tqm8548_defconfig       | 1355 +-------------
 arch/powerpc/configs/85xx/tqm8555_defconfig       | 1363 -------------
 arch/powerpc/configs/85xx/tqm8560_defconfig       | 1363 -------------
 arch/powerpc/configs/85xx/xes_mpc85xx_defconfig   | 1784 +-----------------
 arch/powerpc/configs/86xx/gef_ppc9a_defconfig     | 1733 ----------------
 arch/powerpc/configs/86xx/gef_sbc310_defconfig    | 1622 ---------------
 arch/powerpc/configs/86xx/gef_sbc610_defconfig    | 1815 -----------------
 arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig  | 1632 +---------------
 arch/powerpc/configs/86xx/mpc8641_hpcn_defconfig  | 1639 +---------------
 arch/powerpc/configs/86xx/sbc8641d_defconfig      | 1428 --------------
 arch/powerpc/configs/adder875_defconfig           |  912 ---------
 arch/powerpc/configs/amigaone_defconfig           | 1492 +--------------
 arch/powerpc/configs/c2k_defconfig                | 1622 ---------------
 arch/powerpc/configs/cell_defconfig               | 1317 +------------
 arch/powerpc/configs/celleb_defconfig             | 1197 +-----------
 arch/powerpc/configs/chrp32_defconfig             | 1471 +--------------
 arch/powerpc/configs/ep8248e_defconfig            | 1120 +-----------
 arch/powerpc/configs/ep88xc_defconfig             |  859 +--------
 arch/powerpc/configs/g5_defconfig                 | 1551 +---------------
 arch/powerpc/configs/gamecube_defconfig           |  948 +---------
 arch/powerpc/configs/holly_defconfig              |  881 +---------
 arch/powerpc/configs/iseries_defconfig            | 1058 +----------
 arch/powerpc/configs/linkstation_defconfig        | 1782 +-----------------
 arch/powerpc/configs/maple_defconfig              | 1373 +-------------
 arch/powerpc/configs/mgcoge_defconfig             | 1160 +-----------
 arch/powerpc/configs/mgsuvd_defconfig             |  936 ---------
 arch/powerpc/configs/mpc512x_defconfig            | 1559 +---------------
 arch/powerpc/configs/mpc5200_defconfig            | 1849 +-----------------
 arch/powerpc/configs/mpc7448_hpc2_defconfig       | 1195 +-----------
 arch/powerpc/configs/mpc8272_ads_defconfig        | 1185 +-----------
 arch/powerpc/configs/mpc83xx_defconfig            | 1663 +----------------
 arch/powerpc/configs/mpc85xx_defconfig            | 1689 +----------------
 arch/powerpc/configs/mpc85xx_smp_defconfig        | 1693 +----------------
 arch/powerpc/configs/mpc866_ads_defconfig         |  949 ---------
 arch/powerpc/configs/mpc86xx_defconfig            | 1679 +----------------
 arch/powerpc/configs/mpc885_ads_defconfig         |  864 +--------
 arch/powerpc/configs/pasemi_defconfig             | 1931 +------------------
 arch/powerpc/configs/pmac32_defconfig             | 1886 +------------------
 arch/powerpc/configs/ppc40x_defconfig             | 1332 +-------------
 arch/powerpc/configs/ppc44x_defconfig             | 1471 +--------------
 arch/powerpc/configs/ppc64_defconfig              | 1726 +----------------
 arch/powerpc/configs/ppc64e_defconfig             | 1803 +-----------------
 arch/powerpc/configs/ppc6xx_defconfig             | 2189 +--------------------
 arch/powerpc/configs/pq2fads_defconfig            | 1304 +------------
 arch/powerpc/configs/prpmc2800_defconfig          | 1675 +----------------
 arch/powerpc/configs/ps3_defconfig                | 1334 +-------------
 arch/powerpc/configs/pseries_defconfig            | 1456 +--------------
 arch/powerpc/configs/storcenter_defconfig         | 1305 +------------
 arch/powerpc/configs/tqm8xx_defconfig             |  850 +--------
 arch/powerpc/configs/wii_defconfig                | 1265 +------------
 arch/powerpc/include/asm/mpc52xx.h                |    1 +
 arch/powerpc/include/asm/mpc52xx_psc.h            |    1 +
 arch/powerpc/kernel/setup-common.c                |    2 +
 arch/powerpc/platforms/52xx/mpc52xx_common.c      |  106 +
 drivers/input/mouse/appletouch.c                  |    6 +-
 mm/memblock.c                                     |    2 +-
 sound/soc/fsl/mpc5200_psc_ac97.c                  |   22 +-
 108 files changed, 270 insertions(+), 134609 deletions(-)


