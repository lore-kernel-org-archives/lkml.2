Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751163Ab2JEDzu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 23:55:50 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:40878 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729Ab2JEDzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 23:55:48 -0400
Date: Thu, 4 Oct 2012 20:56:02 -0700
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: olof@lixom.net, arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] ARM: soc: late platform updates
Message-ID: <20121005035602.GB19927@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This branch contains late updates to OMAP and Marvell platforms (kirkwood,
dove, mvebu) that came in after we had done the big multiplatform merges,
so they were kept separate from the rest, and not separated into the
traditional topics of cleanup/driver/platform features. They have been
included in linux-next: kirkwood since -rc7, OMAP since right when the
merge window opened.

There will be trivial add/add merge conflicts in drivers/pinctrl/Makefile
and Kconfig.



For OMAP, the updates are:
- Runtime PM conversions for the GPMC and RNG IP blocks
- Preparation patches for the OMAP common clock framework conversion
- clkdev alias additions required by other drivers
- Performance Monitoring Unit (PMU) support for OMAP2, 3, and non-4430 OMAP4
- OMAP hwmod code and data improvements
- Preparation patches for the IOMMU runtime PM conversion
- Preparation patches for OMAP4 full-chip retention support

For Kirkwood/Dove/mvebu:
- New driver for "address decoder controller" for mvebu, which
  is a piece of hardware that configures addressable devices and
  peripherals. First user is the boot rom aperture on armada XP since
  it is needed for SMP support.
- New device tree bindings for peripherals such as gpio-fan, iconnect
  nand, mv_cesa and the above address decoder controller.
- Some defconfig updates, mostly to enable new DT boards and a few drivers.
- New drivers using the pincontrol subsystem for dove, kirkwood and mvebu
- New clean gpio driver for mvebu

----------------------------------------------------------------

The following changes since commit 8b2d65066100b8df10c6e7805e61751b966045d7:

  Merge branch 'next/defconfig' into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/soc-late

for you to fetch changes up to 54d69df5849ec2e660aa12ac75562618c10fb499:

  Merge branch 'late/kirkwood' into late/soc

----------------------------------------------------------------

Afzal Mohammed (3):
      ARM: OMAP2/3: hwmod data: add gpmc
      ARM: OMAP2+: gpmc: Adapt to HWMOD
      ARM: OMAP2+: gpmc: minimal driver support

Alan M Butler (1):
      ARM: Kirkwood: Iomega ix2-200 DT support

Andrew Lunn (1):
      Crypto: CESA: Add support for DT based instantiation.

AnilKumar Ch (1):
      ARM: OMAP2+: AM33XX: clock data: Add clkdev alias for cpu0

Arnaud Patard (2):
      ARM: Kirkwood: Describe iconnect keys in DT.
      ARM: Kirkwood: Describe iconnect nand in DT.

Benoit Cousson (1):
      ARM: OMAP4: hwmod data: Fix ocp2scp_usb_phy and usb_host_hs entries

Igor Grinberg (1):
      ARM: OMAP: hwmod code: remove unused hwmod function prototypes

Jamie Lentin (3):
      hwmon: Add devicetree bindings to gpio-fan
      ARM: kirkwood: Use devicetree to define DNS-32[05] fan
      ARM: kirkwood: Trim excess #includes in board-dnskw.c

Jason Cooper (2):
      ARM: Kirkwood: update defconfig
      ARM: Kirkwood: add DT boards to defconfig

Jon Hunter (7):
      ARM: OMAP2420: Cosmetic fix for timer clock aliases
      ARM: OMAP4: Add timer clock aliases for device-tree
      ARM: OMAP: Add a timer attribute for timers that can interrupt the DSP
      ARM: OMAP3: hwmod data: Add debugss HWMOD data
      ARM: OMAP2+: PMU: Convert OMAP2/3 devices to use HWMOD
      ARM: OMAP2+: PMU: Add runtime PM support
      ARM: OMAP4460/4470: PMU: Enable PMU for OMAP4460/70

Kishon Vijay Abraham I (1):
      ARM: OMAP4: hwmod data: make *phy_48m* as the main_clk of ocp2scp

Michael Jones (1):
      ARM: OMAP3: clock data: remove obsolete comment

Mike Turquette (1):
      ARM: OMAP4: cm: add bitfield width values

Ming Lei (1):
      ARM: OMAP4430: PMU: prepare to create PMU device via HWMOD

Olof Johansson (12):
      Merge branch 'next/cleanup' into late/kirkwood
      Merge branch 'next/multiplatform' into late/kirkwood
      Merge branch 'kirkwood/boards' of git://git.infradead.org/users/jcooper/linux into late/kirkwood
      Merge branch 'kirkwood/defconfig' of git://git.infradead.org/users/jcooper/linux into late/kirkwood
      Merge branch 'kirkwood/dt' of git://git.infradead.org/users/jcooper/linux into late/kirkwood
      Merge branch 'kirkwood/cleanup' of git://git.infradead.org/users/jcooper/linux into late/kirkwood
      Merge branch 'kirkwood/addr_decode' of git://git.infradead.org/users/jcooper/linux into late/kirkwood
      Merge branch 'kirkwood/drivers' of git://git.infradead.org/users/jcooper/linux into late/kirkwood
      ARM: kirkwood: move new dtbs to common Makefile
      ARM: kirkwood: dockstar: fix header include
      Merge tag 'omap-devel-late-for-v3.7' of git://git.kernel.org/.../tmlind/linux-omap into late/soc
      Merge branch 'late/kirkwood' into late/soc

Omar Ramirez Luna (5):
      ARM: OMAP2+: omap_device: expose hwmod assert/deassert to omap devices
      ARM: OMAP: hwmod: partially un-reset hwmods might not be properly enabled
      ARM: OMAP: hwmod: revise deassert sequence
      ARM: OMAP: iommu: fix including iommu.h without IOMMU_API selected
      ARM: OMAP4: hwmod data: add mmu hwmod for ipu and dsp

Paul Walmsley (19):
      Merge tag 'cleanup-fixes-for-v3.7' into test_v3.6-rc6_cff3.7_odaf3.7
      Merge tag 'omap-devel-am33xx-for-v3.7' into test_v3.6-rc6_cff3.7_odaf3.7
      ARM: OMAP3: clock data: Add the USB TLL clocks device name
      ARM: OMAP2+: clock data: add some aliases for use by CPUFreq only
      SPI: OMAP: remove unnecessary includes of plat/clock.h
      Merge tag 'omap-cleanup-b-for-3.7' into test_v3.6-rc6_ocb3.7_cff3.7_odaf3.7
      Merge tag 'cleanup-fixes-for-v3.7' into test_v3.6-rc6_ocb3.7_cff3.7_odaf3.7
      Merge tag 'omap-devel-am33xx-for-v3.7' into test_v3.6-rc6_ocb3.7_cff3.7_odaf3.7
      Merge branch 'clock_devel_3.7' into hwmod_prcm_clock_a_3.7
      ARM: OMAP4+: hwmod code: remove clkdm requirement in _omap4_wait_target_*()
      ARM: OMAP2+: hwmod code: convert missing clockdomain warnings to debug messages
      ARM: OMAP4: hwmod data: add missing HWMOD_NO_IDLEST flags to some PRCM IP blocks
      ARM: OMAP3: hwmod data: add mmu data for iva and isp
      ARM: OMAP2xxx: hwmod/CM: add RNG integration data
      hwrng: OMAP: store per-device data in per-device variables, not file statics
      hwrng: OMAP: convert to use runtime PM
      ARM: OMAP: split OMAP1, OMAP2+ RNG device registration
      hwrng: OMAP: remove SoC restrictions from driver registration
      ARM: OMAP2+: clockdomain/hwmod: add workaround for EMU clockdomain idle problems

Rajendra Nayak (3):
      ARM: omap: clk: add clk_prepare and clk_unprepare
      ARM: OMAP2+: hwmod: get rid of all omap_clk_get_by_name usage
      ARM: OMAP2+: clock: Remove all direct dereferencing of struct clk

Rob Herring (1):
      ARM: mvebu: fix build breaks from multi-platform conversion

Russell King (1):
      ARM: Dove: allow PCI to be disabled

Sebastian Hesselbarth (11):
      ARM: kirkwood: DT board setup for Seagate FreeAgent Dockstar
      ARM: kirkwood: DT descriptor for Seagate FreeAgent Dockstar
      ARM: dove: unify clock setup
      ARM: dove: add clock gating control
      ARM: dove: add crypto engine
      ARM: dove: add device tree based machine descriptor
      ARM: dove: add device tree descriptors
      ARM: dove: SolidRun CuBox DT
      pinctrl: mvebu: pinctrl driver core
      pinctrl: mvebu: dove pinctrl driver
      pinctrl: mvebu: kirkwood pinctrl driver

Tero Kristo (4):
      ARM: OMAP4: powerdomain: add support for reading prev logic and mem states
      ARM: OMAP4: hwmod data: add support for lostcontext_mask
      ARM: OMAP4: hwmod: flag hwmods/modules not supporting module level context status
      ARM: OMAP3: hwmod data: add sad2d hwmod

Thomas Petazzoni (30):
      arm: add documentation describing Marvell families of SoC
      arm: mach-dove: use plus instead of or for address definitions
      arm: mach-kirkwood: use plus instead of or for address definitions
      arm: mach-mv78xx0: use plus instead of or for address definitions
      arm: mach-orion5x: use plus instead of or for address definitions
      arm: mach-dove: use IOMEM() for base address definitions
      arm: mach-kirkwood: use IOMEM() for base address definitions
      arm: mach-mv78xx0: use IOMEM() for base address definitions
      arm: mach-orion5x: use IOMEM() for base address definitions
      arm: mach-mvebu: use IOMEM() for base address definitions
      arm: plat-orion: use void __iomem pointers for UART registration functions
      arm: plat-orion: use void __iomem pointers for MPP functions
      arm: plat-orion: use void __iomem pointers for time functions
      arm: plat-orion: use void __iomem pointers for addr-map functions
      arm: plat-orion: introduce PLAT_ORION_LEGACY hidden config option
      arm: plat-orion: make bridge_virt_base non-const to support DT use case
      arm: mvebu: add basic address decoding support to Armada 370/XP
      arm: mvebu: add address decoding controller to the DT
      pinctrl: mvebu: add pinctrl driver for Armada 370
      pinctrl: mvebu: add pinctrl driver for Armada XP
      ARM: mvebu: Add pinctrl support to Armada XP SoCs
      ARM: mvebu: Add pinctrl support to Armada 370 SoC
      ARM: mvebu: adjust Armada XP evaluation board DTS
      arm: mvebu: split Kconfig options for Armada 370 and XP
      arm: mvebu: select the pinctrl drivers for Armada 370 and Armada XP platforms
      gpio: introduce gpio-mvebu driver for Marvell SoCs
      Documentation: add description of DT binding for the gpio-mvebu driver
      arm: mvebu: use GPIO support now that a driver is available
      arm: mvebu: add DT information for GPIO banks on Armada 370 and XP
      arm: mvebu: add gpio support in defconfig

Tony Lindgren (1):
      Merge tag 'omap-devel-b-c-2-for-3.7' of git://git.kernel.org/.../pjw/omap-pending into devel-late

Vaibhav Hiremath (1):
      ARM: AM33XX: cm: Add bit-field width values

Valentin Longchamp (1):
      ARM: initial DTS support for km_kirkwood


 .../devicetree/bindings/crypto/mv_cesa.txt      |  20 +
 .../devicetree/bindings/gpio/gpio-fan.txt       |  25 +
 .../devicetree/bindings/gpio/gpio-mvebu.txt     |  53 ++
 .../pinctrl/marvell,armada-370-pinctrl.txt      |  95 +++
 .../pinctrl/marvell,armada-xp-pinctrl.txt       | 100 +++
 .../bindings/pinctrl/marvell,dove-pinctrl.txt   |  72 ++
 .../pinctrl/marvell,kirkwood-pinctrl.txt        | 279 +++++++
 .../bindings/pinctrl/marvell,mvebu-pinctrl.txt  |  46 ++
 arch/arm/Kconfig                                |  15 +-
 arch/arm/boot/dts/Makefile                      |   6 +
 arch/arm/boot/dts/armada-370-xp.dtsi            |   5 +
 arch/arm/boot/dts/armada-370.dtsi               |  44 ++
 arch/arm/boot/dts/armada-xp-db.dts              |   4 +-
 arch/arm/boot/dts/armada-xp-mv78230.dtsi        |  57 ++
 arch/arm/boot/dts/armada-xp-mv78260.dtsi        |  70 ++
 arch/arm/boot/dts/armada-xp-mv78460.dtsi        |  70 ++
 arch/arm/boot/dts/dove-cm-a510.dts              |  38 +
 arch/arm/boot/dts/dove-cubox.dts                |  42 ++
 arch/arm/boot/dts/dove-dove-db.dts              |  38 +
 arch/arm/boot/dts/dove.dtsi                     | 143 ++++
 arch/arm/boot/dts/kirkwood-dnskw.dtsi           |  10 +
 arch/arm/boot/dts/kirkwood-dockstar.dts         |  57 ++
 arch/arm/boot/dts/kirkwood-iconnect.dts         |  50 +-
 arch/arm/boot/dts/kirkwood-iomega_ix2_200.dts   | 105 +++
 arch/arm/boot/dts/kirkwood-km_kirkwood.dts      |  29 +
 arch/arm/boot/dts/kirkwood.dtsi                 |  12 +-
 arch/arm/configs/kirkwood_defconfig             |  38 +-
 arch/arm/configs/mvebu_defconfig                |   2 +
 arch/arm/mach-dove/Kconfig                      |   7 +
 arch/arm/mach-dove/Makefile                     |   4 +-
 arch/arm/mach-dove/common.c                     | 157 +++-
 arch/arm/mach-dove/common.h                     |   4 +
 arch/arm/mach-dove/include/mach/bridge-regs.h   |  16 +-
 arch/arm/mach-dove/include/mach/dove.h          | 126 ++--
 arch/arm/mach-dove/include/mach/pm.h            |  54 +-
 arch/arm/mach-dove/irq.c                        |  10 +-
 arch/arm/mach-dove/pcie.c                       |   6 +-
 arch/arm/mach-kirkwood/Kconfig                  |  21 +
 arch/arm/mach-kirkwood/Makefile                 |   3 +
 arch/arm/mach-kirkwood/addr-map.c               |   3 +-
 arch/arm/mach-kirkwood/board-dnskw.c            |  35 -
 arch/arm/mach-kirkwood/board-dockstar.c         |  61 ++
 arch/arm/mach-kirkwood/board-dt.c               |  14 +-
 arch/arm/mach-kirkwood/board-iconnect.c         |  48 --
 arch/arm/mach-kirkwood/board-iomega_ix2_200.c   |  57 ++
 arch/arm/mach-kirkwood/board-km_kirkwood.c      |  57 ++
 arch/arm/mach-kirkwood/common.c                 |   8 +-
 arch/arm/mach-kirkwood/common.h                 |  18 +
 .../mach-kirkwood/include/mach/bridge-regs.h    |  20 +-
 arch/arm/mach-kirkwood/include/mach/kirkwood.h  | 112 +--
 arch/arm/mach-kirkwood/irq.c                    |   9 +-
 arch/arm/mach-kirkwood/pcie.c                   |  12 +-
 arch/arm/mach-kirkwood/ts41x-setup.c            |   3 +-
 arch/arm/mach-mv78xx0/addr-map.c                |   6 +-
 arch/arm/mach-mv78xx0/common.c                  |   4 +-
 .../arm/mach-mv78xx0/include/mach/bridge-regs.h |  12 +-
 arch/arm/mach-mv78xx0/include/mach/mv78xx0.h    |  86 +--
 arch/arm/mach-mv78xx0/irq.c                     |   9 +-
 arch/arm/mach-mv78xx0/pcie.c                    |  12 +-
 arch/arm/mach-mvebu/Kconfig                     |  20 +-
 arch/arm/mach-mvebu/Makefile                    |   5 +-
 arch/arm/mach-mvebu/addr-map.c                  | 134 ++++
 arch/arm/mach-mvebu/armada-370-xp.c             |   2 +-
 arch/arm/mach-mvebu/armada-370-xp.h             |   2 +-
 arch/arm/mach-mvebu/include/mach/gpio.h         |   1 +
 arch/arm/mach-omap1/devices.c                   |  28 +
 arch/arm/mach-omap1/timer.c                     |   2 +-
 arch/arm/mach-omap2/Makefile                    |   1 +
 arch/arm/mach-omap2/board-apollon.c             |   4 +-
 arch/arm/mach-omap2/board-h4.c                  |   6 +-
 arch/arm/mach-omap2/board-omap4panda.c          |   2 +-
 arch/arm/mach-omap2/clkt2xxx_apll.c             |   2 +-
 arch/arm/mach-omap2/clkt2xxx_virt_prcm_set.c    |  10 +-
 arch/arm/mach-omap2/clkt34xx_dpll3m2.c          |  20 +-
 arch/arm/mach-omap2/clkt_clksel.c               |  86 ++-
 arch/arm/mach-omap2/clkt_dpll.c                 |  26 +-
 arch/arm/mach-omap2/clock.c                     |   9 +-
 arch/arm/mach-omap2/clock2420_data.c            |  24 +-
 arch/arm/mach-omap2/clock2430_data.c            |  23 +
 arch/arm/mach-omap2/clock33xx_data.c            |   1 +
 arch/arm/mach-omap2/clock3xxx.c                 |   8 +-
 arch/arm/mach-omap2/clock3xxx_data.c            |  37 +-
 arch/arm/mach-omap2/clock44xx_data.c            |  21 +
 arch/arm/mach-omap2/clockdomain.c               |  17 +
 arch/arm/mach-omap2/clockdomain.h               |  20 +-
 arch/arm/mach-omap2/clockdomain2xxx_3xxx.c      |  49 +-
 arch/arm/mach-omap2/clockdomain44xx.c           |  11 +
 arch/arm/mach-omap2/clockdomains3xxx_data.c     |   7 +-
 arch/arm/mach-omap2/clockdomains44xx_data.c     |   3 +-
 arch/arm/mach-omap2/cm-regbits-33xx.h           | 158 +++-
 arch/arm/mach-omap2/cm-regbits-34xx.h           |   2 +
 arch/arm/mach-omap2/cm-regbits-44xx.h           | 411 ++++++++--
 arch/arm/mach-omap2/cm2xxx_3xxx.c               |   2 +-
 arch/arm/mach-omap2/cm2xxx_3xxx.h               |   1 +
 arch/arm/mach-omap2/control.h                   |   1 +
 arch/arm/mach-omap2/devices.c                   |  39 +-
 arch/arm/mach-omap2/display.c                   |   4 +-
 arch/arm/mach-omap2/dpll3xxx.c                  |  48 +-
 arch/arm/mach-omap2/gpmc.c                      | 194 +++--
 arch/arm/mach-omap2/omap_hwmod.c                | 138 +++-
 arch/arm/mach-omap2/omap_hwmod_2420_data.c      |  19 +
 arch/arm/mach-omap2/omap_hwmod_2430_data.c      |  19 +
 .../omap_hwmod_2xxx_interconnect_data.c         |  17 +
 .../mach-omap2/omap_hwmod_2xxx_ipblock_data.c   | 110 ++-
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c      | 280 ++++++-
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c      | 243 +++++-
 arch/arm/mach-omap2/omap_hwmod_common_data.h    |   6 +-
 arch/arm/mach-omap2/pm.c                        |   5 +-
 arch/arm/mach-omap2/pmu.c                       |  95 +++
 arch/arm/mach-omap2/powerdomain44xx.c           |  61 +-
 arch/arm/mach-omap2/prcm-common.h               |   2 +
 arch/arm/mach-orion5x/addr-map.c                |   3 +-
 arch/arm/mach-orion5x/common.c                  |   4 +-
 arch/arm/mach-orion5x/dns323-setup.c            |   2 +-
 .../arm/mach-orion5x/include/mach/bridge-regs.h |  20 +-
 arch/arm/mach-orion5x/include/mach/orion5x.h    |  56 +-
 arch/arm/mach-orion5x/irq.c                     |   5 +-
 arch/arm/mach-orion5x/pci.c                     |   6 +-
 arch/arm/plat-omap/clock.c                      |  27 -
 arch/arm/plat-omap/include/plat/clock.h         |   5 +
 arch/arm/plat-omap/include/plat/dmtimer.h       |   1 +
 arch/arm/plat-omap/include/plat/iommu.h         |  15 +
 arch/arm/plat-omap/include/plat/omap_device.h   |   4 +
 arch/arm/plat-omap/include/plat/omap_hwmod.h    |  26 +-
 arch/arm/plat-omap/omap_device.c                |  59 +-
 arch/arm/plat-orion/Makefile                    |  10 +-
 arch/arm/plat-orion/addr-map.c                  |  11 +-
 arch/arm/plat-orion/common.c                    |  12 +-
 arch/arm/plat-orion/include/plat/addr-map.h     |   4 +-
 arch/arm/plat-orion/include/plat/common.h       |   8 +-
 arch/arm/plat-orion/include/plat/mpp.h          |   2 +-
 arch/arm/plat-orion/include/plat/time.h         |   4 +-
 arch/arm/plat-orion/mpp.c                       |   6 +-
 arch/arm/plat-orion/time.c                      |   8 +-
 drivers/char/hw_random/omap-rng.c               | 121 +--
 drivers/crypto/mv_cesa.c                        |  17 +-
 drivers/gpio/Kconfig                            |   6 +
 drivers/gpio/Makefile                           |   1 +
 drivers/gpio/gpio-mvebu.c                       | 679 +++++++++++++++++
 drivers/hwmon/gpio-fan.c                        | 120 +++
 drivers/pinctrl/Kconfig                         |  22 +
 drivers/pinctrl/Makefile                        |   5 +
 drivers/pinctrl/pinctrl-armada-370.c            | 421 +++++++++++
 drivers/pinctrl/pinctrl-armada-xp.c             | 468 ++++++++++++
 drivers/pinctrl/pinctrl-dove.c                  | 620 +++++++++++++++
 drivers/pinctrl/pinctrl-kirkwood.c              | 472 ++++++++++++
 drivers/pinctrl/pinctrl-mvebu.c                 | 754 +++++++++++++++++++
 drivers/pinctrl/pinctrl-mvebu.h                 | 192 +++++
 drivers/spi/spi-omap-100k.c                     |   2 -
 drivers/spi/spi-omap2-mcspi.c                   |   1 -
 150 files changed, 8269 insertions(+), 885 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/mv_cesa.txt
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-fan.txt
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-mvebu.txt
 create mode 100644 Documentation/devicetree/bindings/pinctrl/marvell,armada-370-pinctrl.txt
 create mode 100644 Documentation/devicetree/bindings/pinctrl/marvell,armada-xp-pinctrl.txt
 create mode 100644 Documentation/devicetree/bindings/pinctrl/marvell,dove-pinctrl.txt
 create mode 100644 Documentation/devicetree/bindings/pinctrl/marvell,kirkwood-pinctrl.txt
 create mode 100644 Documentation/devicetree/bindings/pinctrl/marvell,mvebu-pinctrl.txt
 create mode 100644 arch/arm/boot/dts/armada-xp-mv78230.dtsi
 create mode 100644 arch/arm/boot/dts/armada-xp-mv78260.dtsi
 create mode 100644 arch/arm/boot/dts/armada-xp-mv78460.dtsi
 create mode 100644 arch/arm/boot/dts/dove-cm-a510.dts
 create mode 100644 arch/arm/boot/dts/dove-cubox.dts
 create mode 100644 arch/arm/boot/dts/dove-dove-db.dts
 create mode 100644 arch/arm/boot/dts/dove.dtsi
 create mode 100644 arch/arm/boot/dts/kirkwood-dockstar.dts
 create mode 100644 arch/arm/boot/dts/kirkwood-iomega_ix2_200.dts
 create mode 100644 arch/arm/boot/dts/kirkwood-km_kirkwood.dts
 create mode 100644 arch/arm/mach-kirkwood/board-dockstar.c
 create mode 100644 arch/arm/mach-kirkwood/board-iomega_ix2_200.c
 create mode 100644 arch/arm/mach-kirkwood/board-km_kirkwood.c
 create mode 100644 arch/arm/mach-mvebu/addr-map.c
 create mode 100644 arch/arm/mach-mvebu/include/mach/gpio.h
 create mode 100644 arch/arm/mach-omap2/pmu.c
 create mode 100644 drivers/gpio/gpio-mvebu.c
 create mode 100644 drivers/pinctrl/pinctrl-armada-370.c
 create mode 100644 drivers/pinctrl/pinctrl-armada-xp.c
 create mode 100644 drivers/pinctrl/pinctrl-dove.c
 create mode 100644 drivers/pinctrl/pinctrl-kirkwood.c
 create mode 100644 drivers/pinctrl/pinctrl-mvebu.c
 create mode 100644 drivers/pinctrl/pinctrl-mvebu.h
