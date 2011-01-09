Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751253Ab1AIHNv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 02:13:51 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41698 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab1AIHNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 02:13:50 -0500
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sun, 9 Jan 2011 00:13:28 -0700
X-Google-Sender-Auth: xGt2dIi_n7ZLwwtFfUEf0arhn64
Message-ID: <AANLkTi=qh90+i6HW3d=TJynAU57VreMrKOTsnqT5yUND@mail.gmail.com>
Subject: [git pull] device tree changes for 2.6.38
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>
Cc: Andres Salomon <dilinger@queued.net>,
        David Daney <ddaney@caviumnetworks.com>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        John Bonesio <bones@secretlab.ca>, Rob Herring <robherring2@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        David Miller <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michal Simek <monstr@monstr.eu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are the queued up device tree support changes.  Please pull.

There will be one merge conflict in the sparc code where this tree
modifies a function that has been removed from the sparc tree.  Simply
removing the function is the right resolution.  It should be pretty
obvious.

Thanks,
g.

The following changes since commit 0c21e3aaf6ae85bee804a325aa29c325209180fd:

  Merge branch 'for-next' of
git://git.kernel.org/pub/scm/linux/kernel/git/hch/hfsplus (2011-01-07
17:16:27 -0800)

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 next-devicetree

Andres Salomon (1):
      sparc: explicitly cast negative phandle checks to s32

David Daney (2):
      of/net: Move of_get_mac_address() to a common source file.
      of/mdio: Fix some endianness problems.

Dirk Brandewie (3):
      of: Add support for linking device tree blobs into vmlinux
      of/powerpc: Use generic rule to build dtb's
      microblaze/of: Use generic rule to build dtb's

Grant Likely (6):
      Merge commit 'v2.6.37-rc7' into devicetree/next
      of/flattree: Add of_flat_dt_match() helper function
      powerpc/dts: fix syntax bugs in bluestone.dts
      of/device: Don't register disabled devices
      powerpc/405: Fix missing #{address,size}-cells in i2c node
      of/flattree: forward declare struct device_node in of_fdt.h

John Bonesio (5):
      of/flattree: Update dtc to current mainline.
      powerpc/5200: dts: rename nodes to prepare for refactoring dts files
      powerpc/5200: dts: remove unused properties
      powerpc/5200: dts: Change combatible strings on localbus
      powerpc/5200: dts: refactor dts files

Rob Herring (4):
      of_serial: explicitly include of_irq.h
      of: make drivers depend on CONFIG_OF instead of CONFIG_PPC_OF
      of: Fixes for OF probing on little endian systems
      ipmi: explicitly include of_address.h and of_irq.h

Sebastian Andrzej Siewior (1):
      of/address: use proper endianess in get_flags

Stephen Neuendorffer (5):
      of/flattree: Add Kconfig for EARLY_FLATTREE
      of/flattree: Add non-boottime device tree functions
      of/flattree: Refactor unflatten_dt_node
      of/flattree: Reorder unflatten_dt_node
      of/flattree: Refactor unflatten_device_tree and add fdt_unflatten_tree

Wolfram Sang (3):
      misc/at24: parse device tree data
      misc/at24: add more sanity checks for parameters
      powerpc/pcm{030,032}: add pagesize to dts

 Documentation/kbuild/makefiles.txt            |   15 +
 Documentation/powerpc/dts-bindings/eeprom.txt |   28 +
 arch/microblaze/Kconfig                       |    2 +-
 arch/microblaze/boot/Makefile                 |   12 +-
 arch/microblaze/include/asm/prom.h            |    3 -
 arch/microblaze/kernel/prom_parse.c           |   38 -
 arch/mips/Kconfig                             |    2 +-
 arch/powerpc/Kconfig                          |    2 +-
 arch/powerpc/boot/Makefile                    |    8 +-
 arch/powerpc/boot/dts/bluestone.dts           |    8 +-
 arch/powerpc/boot/dts/cm5200.dts              |  194 +-----
 arch/powerpc/boot/dts/digsy_mtc.dts           |  177 +-----
 arch/powerpc/boot/dts/hotfoot.dts             |    2 +
 arch/powerpc/boot/dts/lite5200b.dts           |  220 +------
 arch/powerpc/boot/dts/media5200.dts           |  214 +------
 arch/powerpc/boot/dts/motionpro.dts           |  194 +-----
 arch/powerpc/boot/dts/mpc5200b.dtsi           |  275 ++++++++
 arch/powerpc/boot/dts/mucmc52.dts             |  174 ++----
 arch/powerpc/boot/dts/pcm030.dts              |  196 +-----
 arch/powerpc/boot/dts/pcm032.dts              |  242 +------
 arch/powerpc/boot/dts/uc101.dts               |  160 +----
 arch/powerpc/include/asm/prom.h               |    5 +-
 arch/powerpc/kernel/prom_parse.c              |   38 -
 arch/powerpc/platforms/40x/ppc40x_simple.c    |   13 +-
 arch/powerpc/platforms/512x/mpc5121_generic.c |   13 +-
 arch/powerpc/platforms/52xx/lite5200.c        |   16 +-
 arch/powerpc/platforms/52xx/media5200.c       |   13 +-
 arch/powerpc/platforms/52xx/mpc5200_simple.c  |   13 +-
 arch/powerpc/platforms/83xx/mpc830x_rdb.c     |   13 +-
 arch/powerpc/platforms/83xx/mpc831x_rdb.c     |   11 +-
 arch/powerpc/platforms/83xx/mpc837x_rdb.c     |   15 +-
 arch/powerpc/platforms/85xx/tqm85xx.c         |   20 +-
 arch/powerpc/sysdev/mv64x60_dev.c             |    1 +
 arch/powerpc/sysdev/tsi108_dev.c              |    1 +
 arch/sparc/kernel/auxio_32.c                  |    2 +-
 arch/sparc/kernel/starfire.c                  |    2 +-
 arch/sparc/prom/init_32.c                     |    2 +-
 arch/sparc/prom/init_64.c                     |    4 +-
 arch/sparc/prom/tree_32.c                     |   19 +-
 arch/sparc/prom/tree_64.c                     |   18 +-
 drivers/char/ipmi/ipmi_si_intf.c              |   10 +-
 drivers/misc/eeprom/at24.c                    |   43 +-
 drivers/mmc/host/Kconfig                      |    4 +-
 drivers/mmc/host/sdhci-of-core.c              |    4 +-
 drivers/mtd/Kconfig                           |    2 +-
 drivers/mtd/maps/Kconfig                      |    2 +-
 drivers/net/fs_enet/fs_enet-main.c            |    1 +
 drivers/net/gianfar.c                         |    1 +
 drivers/net/ucc_geth.c                        |    1 +
 drivers/net/xilinx_emaclite.c                 |    1 +
 drivers/of/Kconfig                            |    8 +
 drivers/of/Makefile                           |    1 +
 drivers/of/address.c                          |   54 +-
 drivers/of/fdt.c                              |  430 ++++++++-----
 drivers/of/of_mdio.c                          |   26 +-
 drivers/of/of_net.c                           |   48 ++
 drivers/of/platform.c                         |   22 +-
 drivers/sbus/char/jsflash.c                   |    2 +-
 drivers/serial/Kconfig                        |    2 +-
 drivers/serial/of_serial.c                    |    1 +
 include/asm-generic/vmlinux.lds.h             |   13 +-
 include/linux/of_address.h                    |    6 +-
 include/linux/of_fdt.h                        |   18 +
 include/linux/of_net.h                        |   15 +
 scripts/Makefile.lib                          |   23 +
 scripts/dtc/Makefile                          |    3 +-
 scripts/dtc/checks.c                          |  105 +++-
 scripts/dtc/dtc-lexer.l                       |  175 +-----
 scripts/dtc/dtc-lexer.lex.c_shipped           |  551 +++++-----------
 scripts/dtc/dtc-parser.tab.c_shipped          |  892 ++++++++++++-------------
 scripts/dtc/dtc-parser.tab.h_shipped          |   82 +--
 scripts/dtc/dtc-parser.y                      |  160 ++---
 scripts/dtc/dtc.c                             |   57 +-
 scripts/dtc/dtc.h                             |   77 +--
 scripts/dtc/flattree.c                        |  192 +++---
 scripts/dtc/fstree.c                          |   12 +-
 scripts/dtc/livetree.c                        |  345 +++++++++-
 scripts/dtc/srcpos.c                          |  258 ++++++--
 scripts/dtc/srcpos.h                          |   99 ++--
 scripts/dtc/treesource.c                      |   48 +-
 scripts/dtc/util.c                            |   59 ++
 scripts/dtc/util.h                            |   56 ++
 scripts/dtc/version_gen.h                     |    2 +-
 83 files changed, 2891 insertions(+), 3405 deletions(-)
 create mode 100644 Documentation/powerpc/dts-bindings/eeprom.txt
 create mode 100644 arch/powerpc/boot/dts/mpc5200b.dtsi
 create mode 100644 drivers/of/of_net.c
 create mode 100644 include/linux/of_net.h
 create mode 100644 scripts/dtc/util.c
 create mode 100644 scripts/dtc/util.h


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
