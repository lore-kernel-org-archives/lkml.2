Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab2LKRoh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 12:44:37 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:41012 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508Ab2LKRof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 12:44:35 -0500
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 11 Dec 2012 17:44:14 +0000
X-Google-Sender-Auth: iYs4k4VYL3ELw7eL4KEvDSxjiQ0
Message-ID: <CACxGe6uuB9bfpDNpXhp2wFUHot7UDJxu=sRqqaV8S3K0wq-+5A@mail.gmail.com>
Subject: [GIT PULL] Devicetree changes for v3.8
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rob Herring <rob.herring@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are the DT changes I've got queued up for v3.8. As described
below, there are a lot of bug fixes here and documentation updates but
nothing major. Biggest change is the creation of a common build rule
for .dtb files.

The following changes since commit 77b67063bb6bce6d475e910d3b886a606d0d91f7:

  Linux 3.7-rc5 (2012-11-11 13:44:33 +0100)

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 tags/devicetree-for-linus

for you to fetch changes up to 58fea354d887fddddd342a8d14b02069161ca904:

  arm64: Fix the dtbs target building (2012-12-10 20:24:57 -0600)

----------------------------------------------------------------
Device tree changes for v3.8

Bug fixes, little cleanups, and documentation changes. The most invasive
thing here touches a bunch of the arch directories to use a common build
rule for .dtb files. There are no major changes to functionality here
other than a ew new helper functions.

----------------------------------------------------------------
Alexander Sverdlin (3):
      of_i2c: Honour "status=disabled" property of device
      of_mdio: Honour "status=disabled" property of device
      of/spi: Honour "status=disabled" property of device

Benjamin Herrenschmidt (1):
      of/fdt: Don't copy garbage after "/" in root node path

Catalin Marinas (2):
      of/fdt: NULL-terminate the root node path
      arm64: Fix the dtbs target building

Chaiken, Alison (1):
      Documentation: correct of_platform_populate() argument list

Fabio Estevam (1):
      of: fdt: Constify 'pathp'

Grant Likely (6):
      Merge tag 'v3.7-rc5' into devicetree/next
      drivers/of: Constify device_node->name and ->path_component_name
      powerpc: Fix fallout from device_node->name constification
      ARM: dt: change .dtb build rules to build in dts directory
      Merge remote-tracking branch 'robherring/for-next' into devicetree/next
      devicetree/bindings: Move gpio-leds binding into leds directory

Gregory CLEMENT (1):
      rtc: rtc-mv: Add the device tree binding documentation

James Hogan (1):
      of/vendor-prefixes: add Imagination Technologies

Josh Cartwright (1):
      arm: l2cc: doc: fix device tree example typo

Kumar, Anil (1):
      mtd: nand: davinci: fix the binding documentation

Magnus Damm (1):
      script: dtc: clean generated files

Marek Belisko (1):
      Documentation: Move common leds properties description to separate file.

Pantelis Antoniou (1):
      arm-dt: Enable DT proc updates.

Randy Dunlap (1):
      Fix build when CONFIG_W1_MASTER_GPIO=m b exporting "allnodes"

Rob Herring (2):
      Merge remote-tracking branch 'grant/devicetree/next' into for-next
      arm64: Add dtbs target for building all the enabled dtb files

Srinivas Kandagatla (1):
      of: Add vendor prefix for Synopsys Inc.

Steffen Trumtrar (1):
      of: add 'const' for of_parse_phandle parameter *np

Stephen Warren (8):
      of: Add vendor prefix for Asahi Kasei Corp.
      ARM: tegra: seaboard: add missing DT vendor prefixes
      of: introduce for_each_matching_node_and_match()
      kbuild: centralize .dts->.dtb rule
      arm64: use new common dtc rule
      openrisc: use new common dtc rule
      c6x: use new common dtc rule
      microblaze: use new common dtc rule

Thierry Reding (1):
      of: Add vendor prefix for ON Semiconductor Corp.

Viresh Kumar (1):
      dt: add helper function to read u8 & u16 variables & arrays

Wolfram Sang (1):
      bindings: i2c: use consistent naming for i2c binding descriptions

 .../devicetree/bindings/arm/davinci/nand.txt       |   37 ++----
 Documentation/devicetree/bindings/arm/l2cc.txt     |    2 +-
 .../bindings/i2c/{atmel-i2c.txt => i2c-at91.txt}   |    0
 .../bindings/i2c/{davinci.txt => i2c-davinci.txt}  |    0
 .../bindings/i2c/{gpio-i2c.txt => i2c-gpio.txt}    |    0
 .../bindings/i2c/{fsl-imx-i2c.txt => i2c-imx.txt}  |    0
 .../bindings/i2c/{fsl-i2c.txt => i2c-mpc.txt}      |    0
 .../bindings/i2c/{mux.txt => i2c-mux.txt}          |    0
 .../devicetree/bindings/i2c/i2c-mv64xxx.txt        |   18 +++
 .../bindings/i2c/{nomadik.txt => i2c-nomadik.txt}  |    0
 .../i2c/{cavium-i2c.txt => i2c-octeon.txt}         |    0
 .../bindings/i2c/{omap-i2c.txt => i2c-omap.txt}    |    0
 .../bindings/i2c/{pnx.txt => i2c-pnx.txt}          |    0
 .../i2c/{ce4100-i2c.txt => i2c-pxa-pci-ce4100.txt} |    0
 .../bindings/i2c/{mrvl-i2c.txt => i2c-pxa.txt}     |   18 ---
 .../i2c/{samsung-i2c.txt => i2c-s3c2410.txt}       |    0
 .../bindings/i2c/{sirf-i2c.txt => i2c-sirf.txt}    |    0
 .../i2c/{arm-versatile.txt => i2c-versatile.txt}   |    0
 .../bindings/i2c/{xiic.txt => i2c-xiic.txt}        |    0
 Documentation/devicetree/bindings/leds/common.txt  |   23 ++++
 .../bindings/{gpio/led.txt => leds/leds-gpio.txt}  |   14 +--
 .../devicetree/bindings/rtc/orion-rtc.txt          |   18 +++
 .../devicetree/bindings/vendor-prefixes.txt        |    6 +-
 Documentation/devicetree/usage-model.txt           |    2 +-
 Documentation/kbuild/makefiles.txt                 |   15 +--
 arch/arm/Makefile                                  |    4 +-
 arch/arm/boot/Makefile                             |   12 --
 arch/arm/boot/dts/Makefile                         |    8 ++
 arch/arm/boot/dts/tegra20-seaboard.dts             |    4 +-
 arch/arm/include/asm/prom.h                        |    2 +
 arch/arm/mach-vexpress/v2m.c                       |    2 +-
 arch/arm64/Makefile                                |   17 ++-
 arch/arm64/boot/Makefile                           |    5 -
 arch/arm64/boot/dts/.gitignore                     |    1 +
 arch/arm64/boot/dts/Makefile                       |    5 +
 arch/c6x/Makefile                                  |    2 +-
 arch/c6x/boot/Makefile                             |   20 ---
 arch/c6x/boot/dts/Makefile                         |   20 +++
 arch/c6x/boot/dts/linked_dtb.S                     |    2 +
 arch/c6x/boot/linked_dtb.S                         |    2 -
 arch/microblaze/Makefile                           |    2 +-
 arch/microblaze/boot/Makefile                      |   19 +--
 arch/microblaze/boot/dts/Makefile                  |   22 ++++
 arch/microblaze/boot/dts/linked_dtb.S              |    2 +
 arch/microblaze/boot/linked_dtb.S                  |    3 -
 arch/mips/cavium-octeon/Makefile                   |    3 -
 arch/mips/lantiq/dts/Makefile                      |    3 -
 arch/mips/netlogic/dts/Makefile                    |    3 -
 arch/openrisc/Makefile                             |    2 +-
 arch/openrisc/boot/{ => dts}/Makefile              |    5 -
 arch/powerpc/platforms/powermac/pfunc_core.c       |    2 +-
 arch/powerpc/platforms/pseries/reconfig.c          |    3 +-
 arch/powerpc/sysdev/fsl_pci.c                      |    2 +-
 arch/powerpc/sysdev/scom.c                         |    2 +-
 arch/sparc/kernel/pci_impl.h                       |    2 +-
 drivers/i2c/busses/i2c-ocores.c                    |    4 -
 drivers/of/base.c                                  |  128 ++++++++++++++++----
 drivers/of/fdt.c                                   |   18 +--
 drivers/of/of_i2c.c                                |    2 +-
 drivers/of/of_mdio.c                               |    2 +-
 drivers/of/pdt.c                                   |   12 +-
 drivers/spi/spi.c                                  |    2 +-
 include/linux/of.h                                 |   57 +++++++--
 scripts/Makefile.lib                               |    3 +
 scripts/dtc/Makefile                               |    2 +
 65 files changed, 357 insertions(+), 207 deletions(-)
 rename Documentation/devicetree/bindings/i2c/{atmel-i2c.txt =>
i2c-at91.txt} (100%)
 rename Documentation/devicetree/bindings/i2c/{davinci.txt =>
i2c-davinci.txt} (100%)
 rename Documentation/devicetree/bindings/i2c/{gpio-i2c.txt =>
i2c-gpio.txt} (100%)
 rename Documentation/devicetree/bindings/i2c/{fsl-imx-i2c.txt =>
i2c-imx.txt} (100%)
 rename Documentation/devicetree/bindings/i2c/{fsl-i2c.txt =>
i2c-mpc.txt} (100%)
 rename Documentation/devicetree/bindings/i2c/{mux.txt => i2c-mux.txt} (100%)
 create mode 100644 Documentation/devicetree/bindings/i2c/i2c-mv64xxx.txt
 rename Documentation/devicetree/bindings/i2c/{nomadik.txt =>
i2c-nomadik.txt} (100%)
 rename Documentation/devicetree/bindings/i2c/{cavium-i2c.txt =>
i2c-octeon.txt} (100%)
 rename Documentation/devicetree/bindings/i2c/{omap-i2c.txt =>
i2c-omap.txt} (100%)
 rename Documentation/devicetree/bindings/i2c/{pnx.txt => i2c-pnx.txt} (100%)
 rename Documentation/devicetree/bindings/i2c/{ce4100-i2c.txt =>
i2c-pxa-pci-ce4100.txt} (100%)
 rename Documentation/devicetree/bindings/i2c/{mrvl-i2c.txt =>
i2c-pxa.txt} (70%)
 rename Documentation/devicetree/bindings/i2c/{samsung-i2c.txt =>
i2c-s3c2410.txt} (100%)
 rename Documentation/devicetree/bindings/i2c/{sirf-i2c.txt =>
i2c-sirf.txt} (100%)
 rename Documentation/devicetree/bindings/i2c/{arm-versatile.txt =>
i2c-versatile.txt} (100%)
 rename Documentation/devicetree/bindings/i2c/{xiic.txt => i2c-xiic.txt} (100%)
 create mode 100644 Documentation/devicetree/bindings/leds/common.txt
 rename Documentation/devicetree/bindings/{gpio/led.txt =>
leds/leds-gpio.txt} (68%)
 create mode 100644 Documentation/devicetree/bindings/rtc/orion-rtc.txt
 create mode 100644 arch/arm64/boot/dts/.gitignore
 create mode 100644 arch/arm64/boot/dts/Makefile
 create mode 100644 arch/c6x/boot/dts/Makefile
 create mode 100644 arch/c6x/boot/dts/linked_dtb.S
 delete mode 100644 arch/c6x/boot/linked_dtb.S
 create mode 100644 arch/microblaze/boot/dts/Makefile
 create mode 100644 arch/microblaze/boot/dts/linked_dtb.S
 delete mode 100644 arch/microblaze/boot/linked_dtb.S
 rename arch/openrisc/boot/{ => dts}/Makefile (75%)


--
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
