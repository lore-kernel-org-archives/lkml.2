Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792Ab2LNWGb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 17:06:31 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:54113 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756139Ab2LNWG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 17:06:29 -0500
Date: Fri, 14 Dec 2012 14:06:28 -0800
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL 3/3] ARM: arm-soc: Updates for Marvell mvebu/kirkwood
Message-ID: <20121214220628.GD11363@quad.lixom.net>
References: <20121214220441.GA11363@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121214220441.GA11363@quad.lixom.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is a branch with updates for Marvell's mvebu/kirkwood platforms. They
came in late-ish, and were heavily interdependent such that it didn't
make sense to split them up across the cross-platform topic branches. So
here they are (for the second release in a row) in a branch on their own.

Conflicts seen with this merge:

arch/arm/mach-kirkwood/Kconfig:
Add/add. Keep both.

arch/arm/mach-kirkwood/board-dt.c:
Remove auxdata table.
Keep both sides of the second conflict, but keep the
of_platform_populate() from branch.
(I've asked them to clean up this code and do a lookup table instead of
open-coded if cases like this, should be done for 3.9.)

drivers/dma/mv_xor.c:
This branch has a bunch of conflicts between local development and
the __dev* removal. Easiest way to deal with this is to keep all the
contents from the branch, and just remove any __dev* references.

----------------------------------------------------------------

The following changes since commit 4a40967b3edd9ac3da755ce7d9969fe81064f8a1:

  Merge branch 'next/dt2' into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/mvebu

for you to fetch changes up to 5e5d8999a316d596f2012fe1cf4c59e0de693dab:

  Merge tag 'mvebu_cache_l2x0_for_3.8' of git://git.infradead.org/users/jcooper/linux into late/mvebu

----------------------------------------------------------------

Andrew Lunn (3):
      ARM: Kirkwood: switch to DT clock providers
      dma: mv_xor: Add a device_control function
      arm: kirkwood: Convert XOR instantiation to DT.

Gregory CLEMENT (20):
      arm: mvebu: support for the Globalscale Mirabox board
      clk: mvebu: add armada-370-xp CPU specific clocks
      clk: mvebu: armada 370/XP add clock gating control provider for DT
      clk: armada-370-xp: add support for clock framework
      clocksource: convert time-armada-370-xp to clk framework
      arm: mvebu: increase atomic coherent pool size for armada 370/XP
      arm: mvebu: SATA support: SoC-level DT data for Armada 370/XP
      arm: mvebu: SATA support: mvebu_defconfig update
      arm: mvebu: SATA support: board-level DT data for Armada 370/XP boards
      arm: mvebu: Add support for coherency fabric in mach-mvebu
      arm: mvebu: Add initial support for power managmement service unit
      arm: mvebu: Add IPI support via doorbells
      arm: mm: Add support for PJ4B cpu and init routines
      arm: mvebu: Add SMP support for Armada XP
      arm: dma mapping: Export a dma ops function arm_dma_set_mask
      arm: plat-orion: Add coherency attribute when setup mbus target
      arm: mvebu: Add hardware I/O Coherency support
      arm: mvebu: add L2 cache support
      arm: mvebu: add Aurora L2 Cache Controller to the DT
      arm: l2x0: add aurora related properties to OF binding

Jason Cooper (14):
      Merge tag 'marvell-mvebu-clk-3.8' of git://github.com/MISL-EBU-System-SW/mainline-public into mvebu/everything
      Merge tag 'marvell-sata-3.8' of git://github.com/MISL-EBU-System-SW/mainline-public into mvebu/everything
      Merge tag 'marvell-neta-for-3.8' of git://github.com/MISL-EBU-System-SW/mainline-public into mvebu/everything
      Merge tag 'marvell-boards-net-for-3.8' of git://github.com/MISL-EBU-System-SW/mainline-public into mvebu/everything
      Merge tag 'marvell-net-mdio-checkpatch-fixes-3.8' of git://github.com/MISL-EBU-System-SW/mainline-public into mvebu/everything
      Merge tag 'marvell-mvneta-fix-and-clk-support-3.8' of git://github.com/MISL-EBU-System-SW/mainline-public into mvebu/everything
      Merge tag 'marvell-neta-dt-clk-updates-3.8' of git://github.com/MISL-EBU-System-SW/mainline-public into mvebu/everything
      Merge tag 'marvell-xor-cleanup-dt-binding-3.8' of git://github.com/MISL-EBU-System-SW/mainline-public into mvebu/everything
      Merge tag 'marvell-xor-board-dt-changes-3.8-v2' of git://github.com/MISL-EBU-System-SW/mainline-public into mvebu/everything
      Merge tag 'marvell-net-xor-defconfig-for-3.8' of git://github.com/MISL-EBU-System-SW/mainline-public into mvebu/everything
      Merge tag 'marvell-armadaxp-smp-for-3.8' of git://github.com/MISL-EBU-System-SW/mainline-public into mvebu/everything
      Merge tag 'marvell-hwiocc-for-3.8' of git://github.com/MISL-EBU-System-SW/mainline-public into mvebu/everything
      Merge tag 'marvell-openblocks-i2c-sata-for-3.8' of git://github.com/MISL-EBU-System-SW/mainline-public into mvebu/everything
      Merge branch 'mvebu-misc-fixes' of git://github.com/MISL-EBU-System-SW/mainline-public into mvebu/everything

Nobuhiro Iwamatsu (3):
      ARM: mvebu: Add support for I2C controllers in Armada 370/XP
      ARM: mvebu: Add support for I2C on OpenBlocks AX3-4
      ARM: mvebu: Add support for the RTC in OpenBlocks AX3-4

Olof Johansson (2):
      Merge tag 'mvebu_everything_for_3.8' of git://git.infradead.org/users/jcooper/linux into late/mvebu
      Merge tag 'mvebu_cache_l2x0_for_3.8' of git://git.infradead.org/users/jcooper/linux into late/mvebu

Sebastian Hesselbarth (4):
      clk: mvebu: add mvebu core clocks.
      clk: mvebu: add clock gating control provider for DT
      ARM: dove: switch to DT clock providers
      arm: dove: Convert Dove to DT XOR DMA engine

Thomas Petazzoni (74):
      arm: mvebu: support for the PlatHome OpenBlocks AX3-4 board
      arm: mvebu: fix compatible string in armada-370-xp.dtsi
      arm: mvebu: don't list all boards in dt compat field for Armada 370/XP
      arm: mvebu: fix typo in machine name for Armada 370/XP
      arm: mvebu: add Ethernet controllers using mvneta driver for Armada 370/XP
      arm: mvebu: enable Ethernet controllers on Armada 370/XP eval boards
      arm: mvebu: enable Ethernet controllers on OpenBlocks AX3-4 platform
      arm: mvebu: enable Ethernet controllers on Mirabox platform
      net: mvmdio: new Marvell MDIO driver
      net: mvneta: driver for Marvell Armada 370/XP network unit
      net: mvneta: update MAINTAINERS file for the mvneta maintainers
      dma: mv_xor: use dev_(err|info|notice) instead of dev_printk
      dma: mv_xor: do not use pool_size from platform_data within the driver
      dma: mv_xor: split initialization/cleanup of XOR channels
      dma: mv_xor: allow channels to be registered directly from the main device
      arm: plat-orion: convert the registration of the xor0 engine to the single driver
      arm: plat-orion: convert the registration of the xor1 engine to the single driver
      arm: plat-orion: remove unused orion_xor_init_channels()
      dma: mv_xor: remove sub-driver 'mv_xor'
      dma: mv_xor: remove 'shared' from mv_xor_platform_data
      dma: mv_xor: rename mv_xor_platform_data to mv_xor_channel_data
      dma: mv_xor: rename mv_xor_shared_platform_data to mv_xor_platform_data
      dma: mv_xor: change the driver name to 'mv_xor'
      dma: mv_xor: rename many symbols to remove the 'shared' word
      dma: mv_xor: remove unused id field in mv_xor_device structure
      dma: mv_xor: remove unused to_mv_xor_device() macro
      dma: mv_xor: simplify dma_sync_single_for_cpu() calls
      dma: mv_xor: introduce a mv_chan_to_devp() helper
      dma: mv_xor: get rid of the pdev pointer in mv_xor_device
      dma: mv_xor: in mv_xor_chan, rename 'common' to 'dmachan'
      dma: mv_xor: in mv_xor_device, rename 'common' to 'dmadev'
      dma: mv_xor: use mv_xor_chan pointers as arguments to self-test functions
      dma: mv_xor: merge mv_xor_device and mv_xor_chan
      dma: mv_xor: rename mv_xor_private to mv_xor_device
      dma: mv_xor: remove useless backpointer from mv_xor_chan to mv_xor_device
      dma: mv_xor: remove hw_id field from platform_data
      dma: mv_xor: remove the pool_size from platform_data
      dma: mv_xor: add missing free_irq() call
      dma: mv_xor: add Device Tree binding
      dma: mv_xor: add missing __devinit and __devexit qualifiers on probe and remove
      arm: mvebu: add XOR engines to Armada 370 .dtsi
      arm: mvebu: add XOR engines to Armada XP .dtsi
      Merge tag 'marvell-mvebu-clk-3.8' of github.com:MISL-EBU-System-SW/mainline-public into test-the-merge
      Merge tag 'marvell-sata-3.8' of github.com:MISL-EBU-System-SW/mainline-public into test-the-merge
      Merge tag 'marvell-neta-for-3.8' of github.com:MISL-EBU-System-SW/mainline-public into test-the-merge
      Merge tag 'marvell-boards-net-for-3.8' of github.com:MISL-EBU-System-SW/mainline-public into test-the-merge
      net: mvmdio: use <linux/delay.h> instead of <asm/delay.h>
      net: mvmdio: adjust multiline comment to net/ style
      net: mvneta: adjust multiline comments to net/ style
      net: mvneta: add clk support
      net: mvneta: fix section mismatch warning caused by mvneta_deinit()
      arm: mvebu: add 'clocks' property to Ethernet nodes for Armada 370/XP SoCs
      arm: mvebu: remove 'clock-frequency' properties from Armada 370/XP Ethernet nodes
      arm: mvebu: update defconfig to include network driver
      arm: mvebu: update defconfig to include XOR driver
      Merge tag 'marvell-mvebu-clk-3.8' of github.com:MISL-EBU-System-SW/mainline-public into test-the-merge
      Merge tag 'marvell-sata-3.8' of github.com:MISL-EBU-System-SW/mainline-public into test-the-merge
      Merge tag 'marvell-neta-for-3.8' of github.com:MISL-EBU-System-SW/mainline-public into test-the-merge
      Merge tag 'marvell-boards-net-for-3.8' of github.com:MISL-EBU-System-SW/mainline-public into test-the-merge
      Merge tag 'marvell-net-mdio-checkpatch-fixes-3.8' of github.com:MISL-EBU-System-SW/mainline-public into test-the-merge
      Merge tag 'marvell-mvneta-fix-and-clk-support-3.8' of github.com:MISL-EBU-System-SW/mainline-public into test-the-merge
      Merge tag 'marvell-neta-dt-clk-updates-3.8' of github.com:MISL-EBU-System-SW/mainline-public into test-the-merge
      Merge tag 'marvell-xor-cleanup-dt-binding-3.8' of github.com:MISL-EBU-System-SW/mainline-public into test-the-merge
      Merge tag 'marvell-xor-board-dt-changes-3.8-v2' of github.com:MISL-EBU-System-SW/mainline-public into test-the-merge
      Merge tag 'marvell-net-xor-defconfig-for-3.8' of github.com:MISL-EBU-System-SW/mainline-public into test-the-merge
      ARM: mvebu: Add SATA support for OpenBlocks AX3-4
      ARM: mvebu: update defconfig with I2C and RTC support
      Merge branch 'for-jason-1/cleanup' into mevbu-dt-additions
      Merge tag 'marvell-armadaxp-smp-for-3.8' of github.com:MISL-EBU-System-SW/mainline-public into mevbu-dt-additions
      arm: mvebu: fix address decoding armada_cfg_base() function
      dma: mv_xor: clear the window override control registers
      dma: mv_xor: use request_irq() instead of devm_request_irq()
      dma: mv_xor: fix error checking of irq_of_parse_and_map()
      dma: mv_xor: fix error handling path


 .../bindings/arm/armada-370-xp-mpic.txt         |   12 +-
 .../bindings/arm/armada-370-xp-pmsu.txt         |   20 +
 .../bindings/arm/armada-370-xp-timer.txt        |    1 +
 .../bindings/arm/coherency-fabric.txt           |   21 +
 Documentation/devicetree/bindings/arm/l2cc.txt  |    9 +
 .../bindings/clock/mvebu-core-clock.txt         |   47 +
 .../bindings/clock/mvebu-cpu-clock.txt          |   21 +
 .../bindings/clock/mvebu-gated-clock.txt        |  119 +
 .../devicetree/bindings/dma/mv-xor.txt          |   40 +
 .../bindings/net/marvell-armada-370-neta.txt    |   23 +
 .../bindings/net/marvell-orion-mdio.txt         |   35 +
 MAINTAINERS                                     |    6 +
 arch/arm/Kconfig                                |    1 +
 arch/arm/boot/dts/Makefile                      |    4 +-
 arch/arm/boot/dts/armada-370-db.dts             |   25 +-
 arch/arm/boot/dts/armada-370-mirabox.dts        |   56 +
 arch/arm/boot/dts/armada-370-xp.dtsi            |   63 +-
 arch/arm/boot/dts/armada-370.dtsi               |   57 +
 arch/arm/boot/dts/armada-xp-db.dts              |   44 +
 arch/arm/boot/dts/armada-xp-mv78230.dtsi        |   12 +
 arch/arm/boot/dts/armada-xp-mv78260.dtsi        |   19 +
 arch/arm/boot/dts/armada-xp-mv78460.dtsi        |   34 +
 .../arm/boot/dts/armada-xp-openblocks-ax3-4.dts |  125 +
 arch/arm/boot/dts/armada-xp.dtsi                |   91 +-
 arch/arm/boot/dts/dove.dtsi                     |   62 +
 arch/arm/boot/dts/kirkwood.dtsi                 |   62 +
 arch/arm/configs/multi_v7_defconfig             |    2 +
 arch/arm/configs/mvebu_defconfig                |   17 +
 arch/arm/include/asm/dma-mapping.h              |    2 +
 arch/arm/mach-dove/Kconfig                      |    2 +
 arch/arm/mach-dove/common.c                     |   62 +-
 arch/arm/mach-kirkwood/Kconfig                  |    2 +
 arch/arm/mach-kirkwood/board-dt.c               |   69 +-
 arch/arm/mach-kirkwood/common.c                 |    4 +-
 arch/arm/mach-mvebu/Kconfig                     |    8 +-
 arch/arm/mach-mvebu/Makefile                    |    4 +-
 arch/arm/mach-mvebu/addr-map.c                  |    5 +-
 arch/arm/mach-mvebu/armada-370-xp.c             |   33 +-
 arch/arm/mach-mvebu/armada-370-xp.h             |    7 +
 arch/arm/mach-mvebu/coherency.c                 |  155 +
 arch/arm/mach-mvebu/coherency.h                 |   24 +
 arch/arm/mach-mvebu/coherency_ll.S              |   49 +
 arch/arm/mach-mvebu/common.h                    |    5 +
 arch/arm/mach-mvebu/headsmp.S                   |   49 +
 arch/arm/mach-mvebu/hotplug.c                   |   30 +
 arch/arm/mach-mvebu/irq-armada-370-xp.c         |   96 +-
 arch/arm/mach-mvebu/platsmp.c                   |  122 +
 arch/arm/mach-mvebu/pmsu.c                      |   75 +
 arch/arm/mach-mvebu/pmsu.h                      |   16 +
 arch/arm/mm/Kconfig                             |    4 +
 arch/arm/mm/dma-mapping.c                       |    4 +-
 arch/arm/mm/proc-v7.S                           |   67 +
 arch/arm/plat-orion/addr-map.c                  |    4 +
 arch/arm/plat-orion/common.c                    |  192 +-
 arch/arm/plat-orion/include/plat/addr-map.h     |    1 +
 arch/arm/plat-orion/include/plat/common.h       |    1 +
 drivers/clk/Kconfig                             |    2 +
 drivers/clk/Makefile                            |    1 +
 drivers/clk/mvebu/Kconfig                       |    8 +
 drivers/clk/mvebu/Makefile                      |    3 +
 drivers/clk/mvebu/clk-core.c                    |  675 +++++
 drivers/clk/mvebu/clk-core.h                    |   18 +
 drivers/clk/mvebu/clk-cpu.c                     |  186 ++
 drivers/clk/mvebu/clk-cpu.h                     |   22 +
 drivers/clk/mvebu/clk-gating-ctrl.c             |  249 ++
 drivers/clk/mvebu/clk-gating-ctrl.h             |   22 +
 drivers/clk/mvebu/clk.c                         |   27 +
 drivers/clocksource/time-armada-370-xp.c        |   11 +-
 drivers/dma/mv_xor.c                            |  431 +--
 drivers/dma/mv_xor.h                            |   36 +-
 drivers/net/ethernet/marvell/Kconfig            |   24 +
 drivers/net/ethernet/marvell/Makefile           |    2 +
 drivers/net/ethernet/marvell/mvmdio.c           |  228 ++
 drivers/net/ethernet/marvell/mvneta.c           | 2848 ++++++++++++++++++
 include/linux/clk/mvebu.h                       |   22 +
 include/linux/platform_data/dma-mv_xor.h        |   11 +-
 76 files changed, 6531 insertions(+), 415 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/armada-370-xp-pmsu.txt
 create mode 100644 Documentation/devicetree/bindings/arm/coherency-fabric.txt
 create mode 100644 Documentation/devicetree/bindings/clock/mvebu-core-clock.txt
 create mode 100644 Documentation/devicetree/bindings/clock/mvebu-cpu-clock.txt
 create mode 100644 Documentation/devicetree/bindings/clock/mvebu-gated-clock.txt
 create mode 100644 Documentation/devicetree/bindings/dma/mv-xor.txt
 create mode 100644 Documentation/devicetree/bindings/net/marvell-armada-370-neta.txt
 create mode 100644 Documentation/devicetree/bindings/net/marvell-orion-mdio.txt
 create mode 100644 arch/arm/boot/dts/armada-370-mirabox.dts
 create mode 100644 arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts
 create mode 100644 arch/arm/mach-mvebu/coherency.c
 create mode 100644 arch/arm/mach-mvebu/coherency.h
 create mode 100644 arch/arm/mach-mvebu/coherency_ll.S
 create mode 100644 arch/arm/mach-mvebu/headsmp.S
 create mode 100644 arch/arm/mach-mvebu/hotplug.c
 create mode 100644 arch/arm/mach-mvebu/platsmp.c
 create mode 100644 arch/arm/mach-mvebu/pmsu.c
 create mode 100644 arch/arm/mach-mvebu/pmsu.h
 create mode 100644 drivers/clk/mvebu/Kconfig
 create mode 100644 drivers/clk/mvebu/Makefile
 create mode 100644 drivers/clk/mvebu/clk-core.c
 create mode 100644 drivers/clk/mvebu/clk-core.h
 create mode 100644 drivers/clk/mvebu/clk-cpu.c
 create mode 100644 drivers/clk/mvebu/clk-cpu.h
 create mode 100644 drivers/clk/mvebu/clk-gating-ctrl.c
 create mode 100644 drivers/clk/mvebu/clk-gating-ctrl.h
 create mode 100644 drivers/clk/mvebu/clk.c
 create mode 100644 drivers/net/ethernet/marvell/mvmdio.c
 create mode 100644 drivers/net/ethernet/marvell/mvneta.c
 create mode 100644 include/linux/clk/mvebu.h
