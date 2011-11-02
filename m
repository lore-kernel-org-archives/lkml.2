Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932846Ab1KBCXo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 22:23:44 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:56188 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756250Ab1KBCXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 22:23:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL 10/13] arm-soc cleanups, part 2.
Date: Wed, 2 Nov 2011 02:57:00 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <201111010348.13214.arnd@arndb.de>
In-Reply-To: <201111010348.13214.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111020257.00965.arnd@arndb.de>
X-Provags-ID: V02:K0:+z8tWf8YgvHqMtiIuNgy5WfwvTw1/NkaKnWXJp7rafx
 lCbiN9/A/6HW6T57ulIOCTmc1R8Z/KqMGhwtg2ENX9Ck4fQ/b9
 WS+CbOA9FKryrFu2o4SzT5CDD0dPcjstugN25zsotlTZOSxs4A
 4vfpGfpRfxwASGFLLC2+KAEuvJdhejYBYB3bhNh/M2xdLHJ1NO
 zLgFQGxd1+Swho2CLpBO1e5rCQyRS1NDgFrk8kZGdQfeA0x+E5
 NHYrqcR3aTC9AUAEhFlq3FYTd4DXRru9Gdyx9x7pP66KpHNF9q
 p4bEehFQTz7AkodUS7oiyyeWvcu8dm+QWfZDeAq5w26KCPVLXK
 OaIQkTxGJJ4Aewj5EQ7U=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are further omap cleanups. I originally had lumped them together with samsung
specific cleanups, but had to split them up again when I noticed that not all the
dependencies of those are merged yet. I hope that I will still manage to send them
during this merge window.

There were a lot of conflicts against the mach/memory.h removal, which I resolved
by merging that branch.

	Arnd

The following changes since commit 3bb324d4d0cb589a79319be45255d75aa100f74e:

  Merge branch 'next/cross-platform' into for-next (2011-11-01 00:39:24 +0100)

are available in the git repository at:

  git://git.linaro.org/people/arnd/arm-soc.git next/cleanup2

Arnd Bergmann (1):
      Merge branch 'depends/rmk/memory_h' into next/cleanup2

Benoit Cousson (18):
      ARM: OMAP3: beagle-board: Use the omap_hwmod_name_get_dev API
      ARM: OMAP2+: pm: Use hwmod name instead of dev pointer
      ARM: OMAP2+: pm: Remove static devices variable for mpu, dsp, iva and l3 PM
      ARM: OMAP: omap_device: Create a default omap_device_pm_latency
      ARM: OMAP2+: devices: Remove all omap_device_pm_latency structures
      of: Add helpers to get one string in multiple strings property
      ARM: OMAP: omap_device: Add omap_device_[alloc|delete] for DT integration
      ARM: OMAP: omap_device: Add a method to build an omap_device from a DT node
      arm/dts: Add initial device tree support for OMAP4 SoC
      arm/dts: Add support for OMAP4 PandaBoard
      arm/dts: Add support for OMAP4 SDP board
      arm/dts: Add initial device tree support for OMAP3 SoC
      arm/dts: Add support for OMAP3 Beagle board
      ARM: OMAP2+: board-generic: Add DT support to generic board
      ARM: OMAP2+: board-generic: Add i2c static init
      ARM: OMAP2+: l3-noc: Add support for device-tree
      arm/dts: OMAP4: Add a main ocp entry bound to l3-noc driver
      arm/dts: OMAP3+: Add mpu, dsp and iva nodes

Nishanth Menon (1):
      ARM: OMAP: omap_device: Add omap_device_get_by_hwmod_name

Santosh Shilimkar (1):
      OMAP4: Fix the emif and dmm virtual mapping

Todd Poynor (2):
      OMAP: Improve register access in L3 Error handler.
      OMAP: Fix a BUG in l3 error handler.

Tony Lindgren (10):
      Merge branch 'for_3.2/voltage-cleanup' of git://gitorious.org/khilman/linux-omap-pm into voltage
      Merge branch 'for_3_2/omap_misc' of git://gitorious.org/omap-sw-develoment/linux-omap-dev into l3
      Merge branches 'cleanup-part3', 'voltage', 'dmtimer' and 'l3' into dt-base
      Merge branch 'for_3.2/3_omap_devicetree' of git://gitorious.org/omap-pm/linux into dt
      ARM: OMAP1: Use generic map_io, init_early and init_irq
      ARM: OMAP: Avoid cpu_is_omapxxxx usage until map_io is done
      ARM: OMAP: Remove calls to SRAM allocations for framebuffer
      ARM: OMAP: Map SRAM later on with ioremap_exec()
      ARM: OMAP: Move set_globals initialization to happen in init_early
      ARM: OMAP: Warn if omap_ioremap is called before SoC detection

sricharan (3):
      OMAP: Fix indentation issues in l3 error handler.
      OMAP: Fix sparse warnings in l3 error handler.
      OMAP: Print Initiator name for l3 custom error.

 Documentation/devicetree/bindings/arm/omap/dsp.txt |   14 +
 Documentation/devicetree/bindings/arm/omap/iva.txt |   19 ++
 .../devicetree/bindings/arm/omap/l3-noc.txt        |   19 ++
 Documentation/devicetree/bindings/arm/omap/mpu.txt |   27 ++
 .../devicetree/bindings/arm/omap/omap.txt          |   43 +++
 arch/arm/boot/dts/omap3-beagle.dts                 |   29 ++
 arch/arm/boot/dts/omap3.dtsi                       |   63 ++++
 arch/arm/boot/dts/omap4-panda.dts                  |   29 ++
 arch/arm/boot/dts/omap4-sdp.dts                    |   29 ++
 arch/arm/boot/dts/omap4.dtsi                       |  103 +++++++
 arch/arm/mach-omap1/board-ams-delta.c              |   16 +-
 arch/arm/mach-omap1/board-fsample.c                |   76 +++---
 arch/arm/mach-omap1/board-generic.c                |   16 +-
 arch/arm/mach-omap1/board-h2.c                     |   16 +-
 arch/arm/mach-omap1/board-h3.c                     |   16 +-
 arch/arm/mach-omap1/board-htcherald.c              |   12 +-
 arch/arm/mach-omap1/board-innovator.c              |   36 +--
 arch/arm/mach-omap1/board-nokia770.c               |   34 +--
 arch/arm/mach-omap1/board-osk.c                    |   16 +-
 arch/arm/mach-omap1/board-palmte.c                 |   16 +-
 arch/arm/mach-omap1/board-palmtt.c                 |   16 +-
 arch/arm/mach-omap1/board-palmz71.c                |   18 +-
 arch/arm/mach-omap1/board-perseus2.c               |   75 +++---
 arch/arm/mach-omap1/board-sx1.c                    |   17 +-
 arch/arm/mach-omap1/board-voiceblue.c              |   16 +-
 arch/arm/mach-omap1/devices.c                      |    3 +
 arch/arm/mach-omap1/io.c                           |   59 ++--
 arch/arm/mach-omap2/Kconfig                        |    8 +-
 arch/arm/mach-omap2/board-generic.c                |  151 ++++++++---
 arch/arm/mach-omap2/board-omap3beagle.c            |   11 +-
 arch/arm/mach-omap2/board-ti8168evm.c              |    1 -
 arch/arm/mach-omap2/common.c                       |   50 ++--
 arch/arm/mach-omap2/control.c                      |   16 +-
 arch/arm/mach-omap2/devices.c                      |   51 +---
 arch/arm/mach-omap2/display.c                      |   11 +-
 arch/arm/mach-omap2/dma.c                          |   11 +-
 arch/arm/mach-omap2/gpio.c                         |   12 +-
 arch/arm/mach-omap2/hsmmc.c                        |   18 +-
 arch/arm/mach-omap2/hwspinlock.c                   |   12 +-
 arch/arm/mach-omap2/io.c                           |  129 ++++----
 arch/arm/mach-omap2/io.h                           |    7 -
 arch/arm/mach-omap2/mcbsp.c                        |   11 +-
 arch/arm/mach-omap2/omap-smp.c                     |    7 +-
 arch/arm/mach-omap2/omap_l3_noc.c                  |  147 +++++----
 arch/arm/mach-omap2/omap_l3_noc.h                  |  224 ++++++++------
 arch/arm/mach-omap2/omap_l3_smx.c                  |   91 +++---
 arch/arm/mach-omap2/omap_l3_smx.h                  |  164 +++++-----
 arch/arm/mach-omap2/pm.c                           |   72 ++---
 arch/arm/mach-omap2/prcm.c                         |   19 +-
 arch/arm/mach-omap2/sdrc.c                         |   13 +-
 arch/arm/mach-omap2/serial.c                       |   25 +--
 arch/arm/mach-omap2/sr_device.c                    |   11 +-
 arch/arm/mach-omap2/timer.c                        |    6 +-
 arch/arm/mach-omap2/usb-musb.c                     |   26 +--
 arch/arm/plat-omap/i2c.c                           |   10 +-
 arch/arm/plat-omap/include/plat/common.h           |   17 +-
 arch/arm/plat-omap/include/plat/io.h               |   33 ++-
 arch/arm/plat-omap/include/plat/omap_device.h      |    1 +
 arch/arm/plat-omap/io.c                            |   10 +
 arch/arm/plat-omap/omap_device.c                   |  313 +++++++++++++++++---
 arch/arm/plat-omap/sram.c                          |   85 ++----
 drivers/of/base.c                                  |   84 ++++++
 include/linux/of.h                                 |   18 ++
 63 files changed, 1593 insertions(+), 1115 deletions(-)

