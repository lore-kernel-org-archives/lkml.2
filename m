Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111Ab2ARHZ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 02:25:28 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43505 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756048Ab2ARHZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 02:25:26 -0500
From: Olof Johansson <olof@lixom.net>
To: torvalds@linuxfoundation.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, arm@kernel.org
Subject: [GIT PULL 2/2] arm-soc: i.MX platform consolidation
Date: Tue, 17 Jan 2012 23:24:58 -0800
Message-Id: <1326871498-22485-3-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.9.rc1.3.gb6310
In-Reply-To: <1326871498-22485-1-git-send-email-olof@lixom.net>
References: <1326871498-22485-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the last merge request for arm-soc for the 3.3 merge window,
and it's a move to consolidate one of the Freescale platforms into a
larger combined one.

There are some context merge conflicts due to concurrent cleanups in the
code that was already merged, should be easy to resolve:

* In the first Kconfig conflict, the MACH_MX3* options are not to be added
* In the Makefile conflict, keep the IMX6 statements that are in HEAD
* Last Kconfig change is just context difference due to the added
  MIGHT_HAVE_CACHE_L2X0 option


Thanks!

-Olof

The following changes since commit 1ea6b8f48918282bdca0b32a34095504ee65bab5:

  Linux 3.2-rc1 (2011-11-07 16:16:02 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git arm-soc-imx-move

for you to fetch changes up to 3f07f355704bc2ae26399f17c6d5d46c9a3d78d1:

  ARM i.MX: Update defconfig (2011-11-16 08:37:53 +0100)

----------------------------------------------------------------
Consolidate i.MX 5 platforms to be under the new shared i.MX 3/5/6 tree.

----------------------------------------------------------------
Sascha Hauer (3):
      ARM i.MX5: remove unnecessary includes from board files
      ARM i.MX: Merge i.MX5 support into mach-imx
      ARM i.MX: Update defconfig

 arch/arm/Makefile                                  |    1 -
 .../configs/{mx5_defconfig => imx_v6_v7_defconfig} |   61 +++--
 arch/arm/configs/mx3_defconfig                     |  144 ------------
 arch/arm/mach-imx/Kconfig                          |  239 +++++++++++++++++++
 arch/arm/mach-imx/Makefile                         |   21 ++
 arch/arm/mach-imx/Makefile.boot                    |   12 +
 arch/arm/{mach-mx5 => mach-imx}/clock-mx51-mx53.c  |    2 +-
 arch/arm/{mach-mx5/cpu.c => mach-imx/cpu-imx5.c}   |    0
 arch/arm/{mach-mx5 => mach-imx}/cpu_op-mx51.c      |    0
 arch/arm/{mach-mx5 => mach-imx}/cpu_op-mx51.h      |    0
 .../crm_regs.h => mach-imx/crm-regs-imx5.h}        |    0
 arch/arm/{mach-mx5 => mach-imx}/devices-imx50.h    |    0
 arch/arm/{mach-mx5 => mach-imx}/devices-imx51.h    |    0
 arch/arm/{mach-mx5 => mach-imx}/devices-imx53.h    |    0
 arch/arm/{mach-mx5 => mach-imx}/efika.h            |    0
 arch/arm/{mach-mx5/ehci.c => mach-imx/ehci-imx5.c} |    0
 .../eukrea_mbimx51-baseboard.c                     |    0
 .../eukrea_mbimxsd-baseboard.c                     |    0
 arch/arm/{mach-mx5 => mach-imx}/imx51-dt.c         |    0
 arch/arm/{mach-mx5 => mach-imx}/imx53-dt.c         |    0
 .../board-cpuimx51.c => mach-imx/mach-cpuimx51.c}  |    0
 .../mach-cpuimx51sd.c}                             |    0
 .../board-mx50_rdp.c => mach-imx/mach-mx50_rdp.c}  |    0
 .../board-mx51_3ds.c => mach-imx/mach-mx51_3ds.c}  |    0
 .../mach-mx51_babbage.c}                           |    0
 .../mach-mx51_efikamx.c}                           |    0
 .../mach-mx51_efikasb.c}                           |    0
 .../board-mx53_ard.c => mach-imx/mach-mx53_ard.c}  |    1 -
 .../board-mx53_evk.c => mach-imx/mach-mx53_evk.c}  |    1 -
 .../mach-mx53_loco.c}                              |    1 -
 .../board-mx53_smd.c => mach-imx/mach-mx53_smd.c}  |    1 -
 arch/arm/{mach-mx5/mm.c => mach-imx/mm-imx5.c}     |    0
 arch/arm/{mach-mx5 => mach-imx}/mx51_efika.c       |    0
 arch/arm/{mach-mx5/system.c => mach-imx/pm-imx5.c} |   89 +++++++-
 arch/arm/mach-mx5/Kconfig                          |  244 --------------------
 arch/arm/mach-mx5/Makefile                         |   26 --
 arch/arm/mach-mx5/Makefile.boot                    |    9 -
 arch/arm/mach-mx5/pm-imx5.c                        |   83 -------
 arch/arm/plat-mxc/Kconfig                          |   15 +-
 39 files changed, 391 insertions(+), 559 deletions(-)
 rename arch/arm/configs/{mx5_defconfig => imx_v6_v7_defconfig} (80%)
 delete mode 100644 arch/arm/configs/mx3_defconfig
 rename arch/arm/{mach-mx5 => mach-imx}/clock-mx51-mx53.c (99%)
 rename arch/arm/{mach-mx5/cpu.c => mach-imx/cpu-imx5.c} (100%)
 rename arch/arm/{mach-mx5 => mach-imx}/cpu_op-mx51.c (100%)
 rename arch/arm/{mach-mx5 => mach-imx}/cpu_op-mx51.h (100%)
 rename arch/arm/{mach-mx5/crm_regs.h => mach-imx/crm-regs-imx5.h} (100%)
 rename arch/arm/{mach-mx5 => mach-imx}/devices-imx50.h (100%)
 rename arch/arm/{mach-mx5 => mach-imx}/devices-imx51.h (100%)
 rename arch/arm/{mach-mx5 => mach-imx}/devices-imx53.h (100%)
 rename arch/arm/{mach-mx5 => mach-imx}/efika.h (100%)
 rename arch/arm/{mach-mx5/ehci.c => mach-imx/ehci-imx5.c} (100%)
 rename arch/arm/{mach-mx5 => mach-imx}/eukrea_mbimx51-baseboard.c (100%)
 rename arch/arm/{mach-mx5 => mach-imx}/eukrea_mbimxsd-baseboard.c (100%)
 rename arch/arm/{mach-mx5 => mach-imx}/imx51-dt.c (100%)
 rename arch/arm/{mach-mx5 => mach-imx}/imx53-dt.c (100%)
 rename arch/arm/{mach-mx5/board-cpuimx51.c => mach-imx/mach-cpuimx51.c} (100%)
 rename arch/arm/{mach-mx5/board-cpuimx51sd.c => mach-imx/mach-cpuimx51sd.c} (100%)
 rename arch/arm/{mach-mx5/board-mx50_rdp.c => mach-imx/mach-mx50_rdp.c} (100%)
 rename arch/arm/{mach-mx5/board-mx51_3ds.c => mach-imx/mach-mx51_3ds.c} (100%)
 rename arch/arm/{mach-mx5/board-mx51_babbage.c => mach-imx/mach-mx51_babbage.c} (100%)
 rename arch/arm/{mach-mx5/board-mx51_efikamx.c => mach-imx/mach-mx51_efikamx.c} (100%)
 rename arch/arm/{mach-mx5/board-mx51_efikasb.c => mach-imx/mach-mx51_efikasb.c} (100%)
 rename arch/arm/{mach-mx5/board-mx53_ard.c => mach-imx/mach-mx53_ard.c} (99%)
 rename arch/arm/{mach-mx5/board-mx53_evk.c => mach-imx/mach-mx53_evk.c} (99%)
 rename arch/arm/{mach-mx5/board-mx53_loco.c => mach-imx/mach-mx53_loco.c} (99%)
 rename arch/arm/{mach-mx5/board-mx53_smd.c => mach-imx/mach-mx53_smd.c} (99%)
 rename arch/arm/{mach-mx5/mm.c => mach-imx/mm-imx5.c} (100%)
 rename arch/arm/{mach-mx5 => mach-imx}/mx51_efika.c (100%)
 rename arch/arm/{mach-mx5/system.c => mach-imx/pm-imx5.c} (58%)
 delete mode 100644 arch/arm/mach-mx5/Kconfig
 delete mode 100644 arch/arm/mach-mx5/Makefile
 delete mode 100644 arch/arm/mach-mx5/Makefile.boot
 delete mode 100644 arch/arm/mach-mx5/pm-imx5.c
