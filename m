Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493Ab2LMB4p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 20:56:45 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42293 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724Ab2LMB4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 20:56:40 -0500
Date: Wed, 12 Dec 2012 17:56:38 -0800
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org
Subject: [GIT PULL 1/5] ARM: arm-soc: device tree conversions and enablement
Message-ID: <20121213015638.GA28281@quad.lixom.net>
References: <20121213015543.GA18953@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121213015543.GA18953@quad.lixom.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Continued device tree conversion and enablement across a number of
platforms; Kirkwood, tegra, i.MX, Exynos, zynq and a couple of other
smaller series as well.

ux500 has seen continued conversion for platforms. Several platforms have
seen pinctrl-via-devicetree conversions for simpler multiplatform. Tegra
is adding data for new devices/drivers, and Exynos has a bunch of new
bindings and devices added as well.

So, pretty much the same progression in the right direction as the last
few releases.


Conflicts seen with this merge:

arch/arm/Kconfig:
Add/add. Keep both.

arch/arm/boot/dts/Makefile:
For the exynos entries, add 4412-smdk and 5250-snow to the HEAD version.
For highbank, keep the new version with two entries.

arch/arm/boot/dts/at91sam9263.dtsi:
arch/arm/boot/dts/at91sam9g45.dtsi:
arch/arm/boot/dts/dbx5x0.dtsi:
arch/arm/boot/dts/imx51.dtsi:
Add/add. Keep both and terminate properly

arch/arm/boot/dts/imx6q.dtsi:
Keep the name with the prefix from the branch, but the new properties
from HEAD.

arch/arm/boot/dts/snowball.dts:
arch/arm/mach-exynos/mach-exynos4-dt.c:
Add/add. Keep both

arch/arm/mach-kirkwood/board-lsxl.c
Take out linux/gpio.h include.

arch/arm/mach-ux500/cpu-db8500.c:
Keep linux/random.h from HEAD version, take out plat/gpio-nomadik.h from the
branch version but keep the rest from there.

Remove the cpufreq platform device registration.

drivers/clk/Makefile:
Add/add. Keep both.

drivers/usb/host/ehci-orion.c:
__dev* removal conflict. Keep branch version, remove annotation.

----------------------------------------------------------------

The following changes since commit cf4af01221579a4e895f43dbfc47598fbfc5a731:

  Merge tag 'boards' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/dt

for you to fetch changes up to 64507dd7028e3e0145077e73b8374bd75aea117c:

  Merge branch 'ste-dt-for-next' of git://git.linaro.org/people/ljones/linux-3.0-ux500 into next/dt

----------------------------------------------------------------

Alban Bedel (1):
      ARM: LPC32xx: Add the motor PWM to base dts file

Amit Daniel Kachhap (2):
      ARM: EXYNOS: Add devicetree node for TMU driver for exynos4
      ARM: EXYNOS: Add devicetree node for TMU driver for exynos5

Andrew Lunn (21):
      ARM: Kirkwood: ehci-orion: Add device tree binding
      ARM: Kirkwood: Convert all DT boards to EHCI via DT.
      ARM: Kirkwood: Convert DNSKW to use gpio-poweroff.
      ARM: Kirkwood: Convert IB62x0 to use gpio-poweroff.
      ARM: Kirkwood: Enable regulator and fixed regulators.
      ARM: Kirkwood: Convert DNSKW to use regulators
      ARM: Kirkwood: Convert Dockstar to use regulators
      ARM: Kirkwood: Convert GoFlexNet to use regulators
      ARM: Kirkwood: Convert LSXL to use regulators
      GPIO: mvebu: Allow all plat-orion platforms.
      ARM: Kirkwood: Make use of mvebu pincltl and gpio drivers
      ARM: Kirkwood: Add DTSI files for pinctrl
      ARM: Kirkwood: Convert TS219 to pinctrl.
      ARM: Kirkwood: Convert iConnect to pinctrl.
      ARM: Kirkwood: Convert dnskw to pinctrl
      ARM: Kirkwood: Convert dockstar to pinctrl.
      ARM: Kirkwood: Convert dreamplug to pinctrl.
      ARM: Kirkwood: Convert GoFlex Net to pinctrl.
      ARM: Kirkwood: Convert ib62x0 to pinctrl.
      ARM: Kirkwood: Convert lsxl boards to pinctrl.
      ARM: Kirkwood: Convert IX2-200 to pinctrl.

Arnd Bergmann (8):
      Merge branch 'omap/headers4' into next/dt
      Merge tag 'omap-for-v3.8/dt-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/dt     From Tony Lindgren <tony@atomide.com>:
      Merge branch 'omap/cleanup-prcm-part2' into next/dt
      Merge tag 'imx-dt' of git://git.pengutronix.de/git/imx/linux-2.6 into next/dt
      Merge branch 'arm-next' of git://git.xilinx.com/linux-xlnx into next/dt
      Merge tag 'mxs-dt-3.8' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/dt
      Merge tag 'imx-dt-3.8' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/dt
      Merge branch 'ste-dt-for-next' of git://git.linaro.org/people/ljones/linux-3.0-ux500 into next/dt

Arun Kumar K (1):
      ARM: EXYNOS: Add MFC device tree support

Axel Lin (1):
      pinctrl: mvebu: Fix dove_audio1_ctrl_set function

Doug Anderson (3):
      ARM: dts: Move the dwmmc aliases from smdk5250 dts to exynos
      ARM: dts: Add board dts file for Snow board (ARM Chromebook)
      ARM: dts: Add aliases for i2c controller for exynos4

Fabio Baltieri (1):
      ARM: dts: add missing ux500 device trees

Fabio Estevam (7):
      ARM: dts: imx28-evk: Use pinctrl for gpio-led
      ARM: dts: imx23-olinuxino: Remove unneeded "default-on"
      ARM: dts: imx23-olinuxino: Use pinctrl for gpio-led
      ARM: dts: imx53-qsb: Use pinctrl for gpio-led
      ARM: dts: imx53-qsb: Make DA9053 regulator functional
      ARM: dts: imx6q-sabreauto: Add basic support
      ARM: mxs_defconfig: Improve USB related support

Fabio Porcedda (4):
      ARM: at91: dt: evk-pro3: enable uart0 and uart2
      watchdog: at91sam9_wdt: add device tree support
      ARM: at91/dts: add at91sam9_wdt driver to at91sam926x, at91sam9g45
      ARM: at91/dts: evk-pro3: enable watchdog

Fadil Berisha (1):
      ARM: imx23-olinuxino: Add spi support

Gwenhael Goavec-Merou (5):
      ARM: mxs: Add support for the Armadeus Systems APF28Dev docking board
      ARM: dts: mxs: Add 16 bits LCD screen muxing options for I.MX28
      ARM: mxs: apf28dev: Add pinctrl and gpios
      ARM: mxs: apf28dev: Add LCD and backlight support
      ARM: mxs: apf28dev: Add I2C and SPI support

Jamie Lentin (2):
      ARM: kirkwood: Increase NAND chip-delay for DNS-32[05]
      power: Add simple poweroff-gpio driver

Jason Cooper (2):
      Merge commit '06763c7' into orion/dt2
      ARM: Kirkwood: remove kirkwood_ehci_init() from new boards

Josh Cartwright (6):
      ARM: zynq: move arm-specific sys_timer out of ttc
      ARM: zynq: dts: add description of the second uart
      ARM: zynq: dts: split up device tree
      clk: Add support for fundamental zynq clks
      ARM: zynq: use zynq clk bindings
      ARM: zynq: add clk binding support to the ttc

Julien Boibessot (2):
      ARM: mxs: Add support for the Armadeus Systems APF28 module
      ARM: dts: mxs: Add PWM3 muxing options for i.MX28

Kukjin Kim (2):
      Merge branch 'next/pinctrl-samsung' into next/dt-exynos4x12
      Merge branch 'next/dt-exynos4x12' into next/dt-samsung

Laxman Dewangan (3):
      ARM: tegra: dts: add slink controller dt entry
      ARM: tegra: dts: cardhu: enable SLINK4
      ARM: tegra: dts: add sflash controller dt entry

Lee Jones (42):
      ARM: ux500: Move regulator-name properties out to board DTS files
      ARM: ux500: Fix initialisation order for UIBs
      ARM: ux500: Elaborate on SDI device node names in Device Tree
      ARM: ux500: Add SDI (MMC) support to the HREF Device Tree
      ARM: ux500: Correct Snowball's external SD/MMC slot's bus width
      ARM: ux500: Create a DTS hierarchy for ST-Ericsson's HREF boards
      ARM: ux500: Create a Device Tree for early HREFs
      ARM: ux500: Add support for gpio-keys and Proximity Sensor for HREF
      ARM: ux500: Remove platform specific device registration when DT is enabled
      ARM: ux500: Move all Device Tree booting into cpu-db8500
      ARM: ux500: Strip out duplicate touch screen platform information
      Documentation: Detail permitted DT properties for the BU21013 Touch Screen
      ARM: ux500: Create a new Device Tree include file for boards supporting STUIBs
      ARM: ux500: Stop calling the UIB init function when using Device Tree
      ARM: ux500: Add all bu21013 touch screen components to supported Device Trees
      ARM: ux500: Stop informing the regulator subsystem that we have full constraints
      ARM: ux500: Apply a Device Tree node for the STMPE MFD
      ARM: ux500: Supply the STMPE keypad Device Tree node to the STUIB DT
      ARM: ux500: Remove unused board compatible string
      ARM: ux500: Add skeleton DTS file for the u9540
      ARM: ux500: Add support for ST-Ericsson's u9540 SoC
      ARM: ux500: Add UART support to the u9540 Device Tree
      ARM: ux500: Enable SDI4 port on the u9540 when booting with Device Tree
      ARM: ux500: Enable all MMC devices on the u9540 when booting with DT
      ARM: ux500: Rename references to the ccu9540 dev board accordingly
      ARM: ux500: Remove duplicate DT_MACHINE_START - make u8500 for generic
      ARM: ux500: List DT compatibility using platform names rather than by board
      ARM: ux500: Add node for the MMC GPIO regulator
      ARM: ux500: Change the type of interrupt to something compatible
      ARM: ux500: CONFIG: Enable GPIO Regulators
      ARM: ux500: Convert DT_MACHINE_START to use SMP operations
      ARM: ux500: Move regulator-name properties out to board DTS files
      ARM: ux500: Add SDI (MMC) support to the HREF Device Tree
      ARM: ux500: Add skeleton DTS file for the u9540
      ARM: ux500: Add UART support to the u9540 Device Tree
      ARM: ux500: Enable SDI4 port on the u9540 when booting with Device Tree
      ARM: ux500: Enable all MMC devices on the u9540 when booting with DT
      ARM: ux500: Describe UART platform registering issues more accurately
      ARM: ux500: Disable the MMCI gpio-regulator by default
      ARM: ux500: Move board specific GPIO info out to subordinate DTS files
      ARM: ux500: Stop registering the PCM driver from platform code
      ARM: ux500: Rename dbx500 cpufreq code to be more generic

Liu Ying (1):
      ARM: dts: imx6q-sabresd: add volume up/down gpio keys

Marek Vasut (2):
      ARM: mx28: Skip OCOTP FEC MAC setup if in DT
      ARM: mxs: Add SchulerControl SPS1 DTS file

Mark Zhang (1):
      ARM: dt: tegra: ventana: define pinmux for ddc

Maxime Ripard (5):
      ARM: dts: cfa10049: Add FEC to the CFA-10049 expansion board
      ARM: dts: cfa10049: Add the DH2228FV DAC to the DTS
      ARM: dts: cfa10036: Use pinctrl for power led
      ARM: dts: mxs: Add hog pins to Crystalfontz boards
      ARM: dts: mxs: add oled support for the cfa-10036

Nick Bowler (1):
      ARM: zynq: Allow UART1 to be used as DEBUG_LL console.

Nobuhiro Iwamatsu (5):
      ARM: kirkwood: Add support DT of second I2C bus
      ARM: kirkwood: Add support second I2C bus and RTC on OpenBlocks A6
      ARM: kirkwood: Add NAND partiton map for OpenBlocks A6
      ARM: Kirkwood: Convert to EHCI via DT for OpenBlocks A6
      ARM: Kirkwood: Add support LED of OpenBlocks A6

Olof Johansson (15):
      Merge branch 'ste-dt-for-next' of git://git.linaro.org/people/ljones/linux-3.0-ux500 into next/dt
      Merge tag 'davinci-for-v3.8/dt' of git://gitorious.org/linux-davinci/linux-davinci into next/dt
      ARM: davinci: move dtb targets to common location
      Merge tag 'at91-for-next-dt' of git://github.com/at91linux/linux-at91 into next/dt
      Merge tag 'tegra-for-3.8-dt' of git://git.kernel.org/.../swarren/linux-tegra into next/dt
      Merge tag 'lpc32xx-dts-for-3.7' of git://git.antcom.de/linux-2.6 into next/dt
      Merge branch 'ste-dt-for-next' of git://git.linaro.org/people/ljones/linux-3.0-ux500 into next/dt
      ARM: EXYNOS: add all i2c busses to auxdata for DT
      Merge branch 'next/hdmi-samsung' of git://git.kernel.org/.../kgene/linux-samsung into next/dt
      Merge branch 'next/dt-samsung' of git://git.kernel.org/.../kgene/linux-samsung into next/dt
      Merge tag 'mxs-dt-3.8-2' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/dt
      Merge branch 'next/dt-samsung-2' of git://git.kernel.org/.../kgene/linux-samsung into next/dt
      Merge tag 'orion_dt_for_3.8' of git://git.infradead.org/users/jcooper/linux into next/dt
      Merge branch 'orion/cleanup' into orion/dt
      Merge branch 'orion/dt' into next/dt

Philippe Reynes (1):
      Add device tree file for the armadeus apf27

Rahul Sharma (6):
      ARM: dts: add device tree support for exynos5 hdmi
      ARM: dts: add device tree support for exynos5 mixer
      ARM: dts: add device tree support for exynos5 hdmiphy
      ARM: dts: add device tree support for exynos5 hdmiddc
      ARM: EXYNOS: add clocks for exynos5 hdmi
      ARM: EXYNOS: removing exynos-drm device registration from non-dt platforms

Roland Stigge (1):
      ARM: dts: imx53: pinctl update

Sascha Hauer (7):
      Merge remote-tracking branch 'arm-soc/imx/multiplatform' into imx25-dt
      ARM i.MX25: Add missing clock gates
      ARM i.MX25: Add devicetree support
      ARM i.MX25: Add devicetree
      ARM i.MX: Add Ka-Ro TX25 devicetree
      ARM i.MX dtsi: Add default bus-width property for esdhc controller
      ARM i.MX dts: Consistently add labels to devicenodes

Sebastian Hesselbarth (3):
      pinctrl: mvebu: fix iomem pointer for dove pinctrl
      ARM: Dove: Convert to DT GPIO and pinctrl
      ARM: Dove: Add CuBox pinhog for led

Shawn Guo (5):
      ARM: imx6q: let users input debug uart port number
      ARM: dts: imx6q: enable snvs lp rtc
      ARM: imx: enable cpufreq for imx6q
      ARM: imx6q: print silicon version on boot
      ARM: imx6q: select ARM and PL310 errata

Stanislav Meduna (1):
      ARM: mxs: Setup scheduler clock

Stefan Peter (1):
      ARM: kirkwood: Convert mplcec4 board to pinctrl

Stephen Warren (3):
      ARM: tegra: trimslice: enable SPI flash
      ARM: tegra: harmony: enable HDMI port
      ARM: tegra: whistler: enable HDMI port

Thierry Reding (11):
      ARM: tegra: tamonten: Add DDC/PTA pinmux
      ARM: tegra: tec: Remove redundant DT properties
      ARM: tegra: harmony: Add ADT7641 temperature sensor
      ARM: tegra: tamonten: Add NCT1008 temperature sensor
      ARM: tegra: ventana: Add NCT1008 temperature sensor
      ARM: tegra: Add Tegra20 host1x support
      ARM: tegra: Add Tegra30 host1x support
      ARM: tegra: trimslice: enable HDMI port
      ARM: tegra: tamonten: Add host1x support
      ARM: tegra: plutux: Enable HDMI output
      ARM: tegra: tec: Enable HDMI output

Thomas Abraham (1):
      ARM: dts: add board dts file for EXYNOS4412 based SMDK board

Tomasz Figa (20):
      ARM: dts: Enable serial controllers on Origen and SMDKV310
      ARM: dts: Add support for EXYNOS4X12 SoCs
      ARM: EXYNOS: Skip wakeup-int setup if pinctrl driver is used on EXYNOS4X12
      gpio: samsung: Skip registration if pinctrl driver is present on EXYNOS4X12
      ARM: dts: Add nodes for pin controllers for exynos4x12
      ARM: dts: Update for pinctrl-samsung driver for exynos4210-trats
      ARM: dts: Add nodes for GPIO keys available on Trats
      ARM: dts: Add node for i2c3 bus for exynos4210-trats
      ARM: dts: Add node for touchscreen voltage regulator for exynos4210-trats
      ARM: dts: Add node for touchscreen for exynos4210-trats
      ARM: dts: Remove broken-voltage property from sdhci node for exynos4210-trats
      ARM: dts: Split memory sections for exynos4210-origen
      ARM: dts: Update for pinctrl-samsung driver for exynos4210-origen
      ARM: dts: Update sdhci nodes for current bindings for exynos4210-origen
      ARM: dts: Add vmmc fixed voltage regulator for exynos4210-origen
      ARM: EXYNOS: Detect power domain state on registration from DT
      ARM: EXYNOS: Fix power domain name initialization
      ARM: EXYNOS: Bind devices to power domains using DT
      ARM: dts: Set up power domains for exynos4
      ARM: dts: Use drive strength 3 for SD pins for exynos4

Valentin Longchamp (2):
      ARM: Kirkwood: support 98DX412x kirkwoods with pinctrl
      ARM: Kirkwood: Convert km_kirkwood to pinctrl

Vasanth Ananthan (1):
      ARM: EXYNOS: DT Support for SATA and SATA PHY

Wei Ni (3):
      ARM: dt: t20 seaboard: turn on the power for wlan
      ARM: dt: t20 ventana: set pinmux and power for wlan
      ARM: dt: t30 cardhu: set pinmux and power for wlan


 .../bindings/arm/exynos/power_domain.txt        |  15 +-
 Documentation/devicetree/bindings/arm/fsl.txt   |   4 +
 .../devicetree/bindings/ata/exynos-sata-phy.txt |  14 +
 .../devicetree/bindings/ata/exynos-sata.txt     |  17 +
 .../devicetree/bindings/clock/imx25-clock.txt   | 162 ++++
 .../devicetree/bindings/clock/zynq-7000.txt     |  55 ++
 .../devicetree/bindings/drm/exynos/hdmi.txt     |  22 +
 .../devicetree/bindings/drm/exynos/hdmiddc.txt  |  12 +
 .../devicetree/bindings/drm/exynos/hdmiphy.txt  |  12 +
 .../devicetree/bindings/drm/exynos/mixer.txt    |  15 +
 .../devicetree/bindings/gpio/gpio-poweroff.txt  |  22 +
 .../bindings/input/touchscreen/bu21013.txt      |  28 +
 .../devicetree/bindings/media/s5p-mfc.txt       |  23 +
 .../pinctrl/marvell,kirkwood-pinctrl.txt        |  39 +
 .../devicetree/bindings/usb/ehci-orion.txt      |  15 +
 .../devicetree/bindings/vendor-prefixes.txt     |   1 +
 .../devicetree/bindings/watchdog/atmel-wdt.txt  |  15 +
 arch/arm/Kconfig                                |   6 +
 arch/arm/Kconfig.debug                          |  43 +-
 arch/arm/boot/dts/Makefile                      |  14 +-
 arch/arm/boot/dts/at91sam9260.dtsi              |   6 +
 arch/arm/boot/dts/at91sam9263.dtsi              |   5 +
 arch/arm/boot/dts/at91sam9g45.dtsi              |   5 +
 arch/arm/boot/dts/ccu9540.dts                   |  72 ++
 arch/arm/boot/dts/cros5250-common.dtsi          | 184 ++++
 arch/arm/boot/dts/dbx5x0.dtsi                   |  56 +-
 arch/arm/boot/dts/dove-cubox.dts                |  10 +
 arch/arm/boot/dts/dove.dtsi                     |  19 +-
 arch/arm/boot/dts/evk-pro3.dts                  |  12 +
 arch/arm/boot/dts/exynos4.dtsi                  |  54 +-
 arch/arm/boot/dts/exynos4210-origen.dts         |  70 +-
 arch/arm/boot/dts/exynos4210-pinctrl.dtsi       |  56 +-
 arch/arm/boot/dts/exynos4210-smdkv310.dts       |  16 +
 arch/arm/boot/dts/exynos4210-trats.dts          |  87 +-
 arch/arm/boot/dts/exynos4210.dtsi               |  12 +
 arch/arm/boot/dts/exynos4212.dtsi               |  28 +
 arch/arm/boot/dts/exynos4412-smdk4412.dts       |  45 +
 arch/arm/boot/dts/exynos4412.dtsi               |  28 +
 arch/arm/boot/dts/exynos4x12-pinctrl.dtsi       | 965 +++++++++++++++++++
 arch/arm/boot/dts/exynos4x12.dtsi               |  69 ++
 arch/arm/boot/dts/exynos5250-smdk5250.dts       |  56 +-
 arch/arm/boot/dts/exynos5250-snow.dts           |  43 +
 arch/arm/boot/dts/exynos5250.dtsi               |  62 +-
 arch/arm/boot/dts/href.dtsi                     | 273 ++++++
 arch/arm/boot/dts/hrefprev60.dts                |  48 +
 arch/arm/boot/dts/hrefv60plus.dts               | 217 ++++-
 arch/arm/boot/dts/imx23-olinuxino.dts           |  23 +-
 arch/arm/boot/dts/imx23.dtsi                    |  13 +
 arch/arm/boot/dts/imx25-karo-tx25.dts           |  44 +
 arch/arm/boot/dts/imx25.dtsi                    | 515 ++++++++++
 arch/arm/boot/dts/imx27-apf27.dts               |  89 ++
 arch/arm/boot/dts/imx27.dtsi                    |   5 +-
 arch/arm/boot/dts/imx28-apf28.dts               |  85 ++
 arch/arm/boot/dts/imx28-apf28dev.dts            | 154 +++
 arch/arm/boot/dts/imx28-cfa10036.dts            |  46 +
 arch/arm/boot/dts/imx28-cfa10049.dts            |  33 +
 arch/arm/boot/dts/imx28-evk.dts                 |  13 +-
 arch/arm/boot/dts/imx28-sps1.dts                | 169 ++++
 arch/arm/boot/dts/imx28.dtsi                    |  35 +
 arch/arm/boot/dts/imx51.dtsi                    |  43 +-
 arch/arm/boot/dts/imx53-qsb.dts                 |  62 +-
 arch/arm/boot/dts/imx53.dtsi                    |  92 +-
 arch/arm/boot/dts/imx6q-sabreauto.dts           |  64 ++
 arch/arm/boot/dts/imx6q-sabresd.dts             |  18 +
 arch/arm/boot/dts/imx6q.dtsi                    | 114 ++-
 arch/arm/boot/dts/kirkwood-6281.dtsi            |  44 +
 arch/arm/boot/dts/kirkwood-6282.dtsi            |  45 +
 arch/arm/boot/dts/kirkwood-98dx4122.dtsi        |  31 +
 arch/arm/boot/dts/kirkwood-dnskw.dtsi           | 140 +++
 arch/arm/boot/dts/kirkwood-dockstar.dts         |  37 +
 arch/arm/boot/dts/kirkwood-dreamplug.dts        |  21 +
 arch/arm/boot/dts/kirkwood-goflexnet.dts        |  73 ++
 arch/arm/boot/dts/kirkwood-ib62x0.dts           |  40 +
 arch/arm/boot/dts/kirkwood-iconnect.dts         |  51 +
 arch/arm/boot/dts/kirkwood-iomega_ix2_200.dts   |  89 ++
 arch/arm/boot/dts/kirkwood-km_kirkwood.dts      |  17 +
 arch/arm/boot/dts/kirkwood-lsxl.dtsi            |  95 ++
 arch/arm/boot/dts/kirkwood-mplcec4.dts          |  59 ++
 arch/arm/boot/dts/kirkwood-openblocks_a6.dts    |  59 ++
 arch/arm/boot/dts/kirkwood-ts219-6281.dts       |  31 +
 arch/arm/boot/dts/kirkwood-ts219-6282.dts       |  31 +
 arch/arm/boot/dts/kirkwood.dtsi                 |  17 +-
 arch/arm/boot/dts/lpc32xx.dtsi                  |   7 +
 arch/arm/boot/dts/snowball.dts                  | 140 ++-
 arch/arm/boot/dts/stuib.dtsi                    |  78 ++
 arch/arm/boot/dts/tegra20-harmony.dts           |  25 +-
 arch/arm/boot/dts/tegra20-plutux.dts            |   6 +
 arch/arm/boot/dts/tegra20-seaboard.dts          |   6 +
 arch/arm/boot/dts/tegra20-tamonten.dtsi         |  88 +-
 arch/arm/boot/dts/tegra20-tec.dts               |   9 +-
 arch/arm/boot/dts/tegra20-trimslice.dts         |  54 +-
 arch/arm/boot/dts/tegra20-ventana.dts           |  90 +-
 arch/arm/boot/dts/tegra20-whistler.dts          |  21 +-
 arch/arm/boot/dts/tegra20.dtsi                  | 137 +++
 arch/arm/boot/dts/tegra30-cardhu-a02.dts        |   6 +
 arch/arm/boot/dts/tegra30-cardhu-a04.dts        |   6 +
 arch/arm/boot/dts/tegra30-cardhu.dtsi           |  37 +
 arch/arm/boot/dts/tegra30.dtsi                  | 147 +++
 arch/arm/boot/dts/u9540.dts                     |  72 ++
 arch/arm/boot/dts/zynq-7000.dtsi                | 166 ++++
 arch/arm/boot/dts/zynq-ep107.dts                |  63 --
 arch/arm/boot/dts/zynq-zc702.dts                |  44 +
 arch/arm/configs/mxs_defconfig                  |   6 +
 arch/arm/configs/u8500_defconfig                |   1 +
 arch/arm/include/debug/imx.S                    |  20 +-
 arch/arm/mach-davinci/Makefile.boot             |   2 -
 arch/arm/mach-exynos/Kconfig                    |   1 +
 arch/arm/mach-exynos/Makefile                   |   1 -
 arch/arm/mach-exynos/clock-exynos4.c            |   4 +
 arch/arm/mach-exynos/clock-exynos5.c            |  21 +-
 arch/arm/mach-exynos/common.c                   |   7 +-
 arch/arm/mach-exynos/dev-drm.c                  |  29 -
 arch/arm/mach-exynos/include/mach/irqs.h        |   3 +
 arch/arm/mach-exynos/include/mach/map.h         |   2 +
 arch/arm/mach-exynos/mach-exynos4-dt.c          |   4 +
 arch/arm/mach-exynos/mach-exynos5-dt.c          |  42 +
 arch/arm/mach-exynos/mach-nuri.c                |   3 -
 arch/arm/mach-exynos/mach-origen.c              |   3 -
 arch/arm/mach-exynos/mach-smdk4x12.c            |   3 -
 arch/arm/mach-exynos/mach-smdkv310.c            |   3 -
 arch/arm/mach-exynos/mach-universal_c210.c      |   3 -
 arch/arm/mach-exynos/pm_domains.c               |  93 +-
 arch/arm/mach-imx/Kconfig                       |  18 +
 arch/arm/mach-imx/Makefile                      |   1 +
 arch/arm/mach-imx/clk-imx25.c                   | 119 ++-
 arch/arm/mach-imx/clk-imx6q.c                   |   1 +
 arch/arm/mach-imx/common.h                      |   1 +
 arch/arm/mach-imx/imx25-dt.c                    |  48 +
 arch/arm/mach-imx/lluart.c                      |  28 +-
 arch/arm/mach-imx/mach-imx6q.c                  |  35 +
 arch/arm/mach-imx/mx6q.h                        |   4 -
 arch/arm/mach-kirkwood/Kconfig                  |   5 +
 arch/arm/mach-kirkwood/board-dnskw.c            |  54 --
 arch/arm/mach-kirkwood/board-dockstar.c         |  16 -
 arch/arm/mach-kirkwood/board-dreamplug.c        |  15 -
 arch/arm/mach-kirkwood/board-goflexnet.c        |  24 -
 arch/arm/mach-kirkwood/board-ib62x0.c           |  35 -
 arch/arm/mach-kirkwood/board-iconnect.c         |  18 -
 arch/arm/mach-kirkwood/board-iomega_ix2_200.c   |  26 -
 arch/arm/mach-kirkwood/board-km_kirkwood.c      |  13 -
 arch/arm/mach-kirkwood/board-lsxl.c             |  28 -
 arch/arm/mach-kirkwood/board-mplcec4.c          |  36 -
 arch/arm/mach-kirkwood/board-ns2.c              |   1 -
 arch/arm/mach-kirkwood/board-nsa310.c           |   4 -
 arch/arm/mach-kirkwood/board-openblocks_a6.c    |   5 +-
 arch/arm/mach-kirkwood/board-ts219.c            |  26 -
 arch/arm/mach-kirkwood/board-usi_topkick.c      |   1 -
 arch/arm/mach-mxs/mach-mxs.c                    |  56 ++
 arch/arm/mach-mxs/timer.c                       |  10 +-
 arch/arm/mach-ux500/board-mop500-audio.c        |  16 -
 arch/arm/mach-ux500/board-mop500-stuib.c        |  22 +-
 arch/arm/mach-ux500/board-mop500.c              | 146 +--
 arch/arm/mach-ux500/board-mop500.h              |  10 +-
 arch/arm/mach-ux500/cpu-db8500.c                | 110 ++-
 arch/arm/mach-ux500/cpu.c                       |   3 +
 arch/arm/mach-zynq/common.c                     |  33 +-
 arch/arm/mach-zynq/common.h                     |   4 +-
 arch/arm/mach-zynq/include/mach/zynq_soc.h      |  16 +-
 arch/arm/mach-zynq/timer.c                      | 297 +++---
 arch/arm/plat-orion/irq.c                       |   6 +-
 arch/arm/plat-samsung/devs.c                    |   1 +
 arch/arm/plat-samsung/include/plat/devs.h       |   2 -
 arch/arm/plat-samsung/include/plat/mfc.h        |  11 +
 arch/arm/plat-samsung/s5p-dev-mfc.c             |  34 +
 drivers/clk/Makefile                            |   1 +
 drivers/clk/clk-zynq.c                          | 383 ++++++++
 drivers/gpio/Kconfig                            |   2 +-
 drivers/gpio/gpio-samsung.c                     |  43 +-
 drivers/pinctrl/mvebu/pinctrl-dove.c            |  22 +-
 drivers/pinctrl/mvebu/pinctrl-kirkwood.c        | 568 +++++------
 drivers/power/Kconfig                           |   3 +
 drivers/power/Makefile                          |   1 +
 drivers/power/reset/Kconfig                     |  15 +
 drivers/power/reset/Makefile                    |   1 +
 drivers/power/reset/gpio-poweroff.c             | 129 +++
 drivers/usb/host/ehci-orion.c                   |  38 +-
 drivers/watchdog/at91sam9_wdt.c                 |  11 +
 include/linux/clk/zynq.h                        |  24 +
 178 files changed, 8119 insertions(+), 1443 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ata/exynos-sata-phy.txt
 create mode 100644 Documentation/devicetree/bindings/ata/exynos-sata.txt
 create mode 100644 Documentation/devicetree/bindings/clock/imx25-clock.txt
 create mode 100644 Documentation/devicetree/bindings/clock/zynq-7000.txt
 create mode 100644 Documentation/devicetree/bindings/drm/exynos/hdmi.txt
 create mode 100644 Documentation/devicetree/bindings/drm/exynos/hdmiddc.txt
 create mode 100644 Documentation/devicetree/bindings/drm/exynos/hdmiphy.txt
 create mode 100644 Documentation/devicetree/bindings/drm/exynos/mixer.txt
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-poweroff.txt
 create mode 100644 Documentation/devicetree/bindings/input/touchscreen/bu21013.txt
 create mode 100644 Documentation/devicetree/bindings/media/s5p-mfc.txt
 create mode 100644 Documentation/devicetree/bindings/usb/ehci-orion.txt
 create mode 100644 Documentation/devicetree/bindings/watchdog/atmel-wdt.txt
 create mode 100644 arch/arm/boot/dts/ccu9540.dts
 create mode 100644 arch/arm/boot/dts/cros5250-common.dtsi
 create mode 100644 arch/arm/boot/dts/exynos4212.dtsi
 create mode 100644 arch/arm/boot/dts/exynos4412-smdk4412.dts
 create mode 100644 arch/arm/boot/dts/exynos4412.dtsi
 create mode 100644 arch/arm/boot/dts/exynos4x12-pinctrl.dtsi
 create mode 100644 arch/arm/boot/dts/exynos4x12.dtsi
 create mode 100644 arch/arm/boot/dts/exynos5250-snow.dts
 create mode 100644 arch/arm/boot/dts/href.dtsi
 create mode 100644 arch/arm/boot/dts/hrefprev60.dts
 create mode 100644 arch/arm/boot/dts/imx25-karo-tx25.dts
 create mode 100644 arch/arm/boot/dts/imx25.dtsi
 create mode 100644 arch/arm/boot/dts/imx27-apf27.dts
 create mode 100644 arch/arm/boot/dts/imx28-apf28.dts
 create mode 100644 arch/arm/boot/dts/imx28-apf28dev.dts
 create mode 100644 arch/arm/boot/dts/imx28-sps1.dts
 create mode 100644 arch/arm/boot/dts/imx6q-sabreauto.dts
 create mode 100644 arch/arm/boot/dts/kirkwood-6281.dtsi
 create mode 100644 arch/arm/boot/dts/kirkwood-6282.dtsi
 create mode 100644 arch/arm/boot/dts/kirkwood-98dx4122.dtsi
 create mode 100644 arch/arm/boot/dts/stuib.dtsi
 create mode 100644 arch/arm/boot/dts/u9540.dts
 create mode 100644 arch/arm/boot/dts/zynq-7000.dtsi
 delete mode 100644 arch/arm/boot/dts/zynq-ep107.dts
 create mode 100644 arch/arm/boot/dts/zynq-zc702.dts
 delete mode 100644 arch/arm/mach-exynos/dev-drm.c
 create mode 100644 arch/arm/mach-imx/imx25-dt.c
 create mode 100644 drivers/clk/clk-zynq.c
 create mode 100644 drivers/power/reset/Kconfig
 create mode 100644 drivers/power/reset/Makefile
 create mode 100644 drivers/power/reset/gpio-poweroff.c
 create mode 100644 include/linux/clk/zynq.h
