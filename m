Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab1G1WAG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 18:00:06 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:50234 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774Ab1G1WAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 18:00:02 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: torvalds@linux-foundation.org, Shawn Guo <shawn.guo@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [GIT PULL] arm-soc device tree conversions for 3.1
Date: Thu, 28 Jul 2011 23:59:47 +0200
Message-ID: <3977629.dnCLBL23Gv@wuerfel>
User-Agent: KMail/4.6.0 (Linux/3.0.0-rc1nosema+; KDE/4.6.90; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:OW4OvRUK8DKYjZek2xLBO3eNCjYMArVvzWLNwE9J0YB
 gP+snihlC9fhMaFcf1pm7KHeTxSRopudo42weY6kDBbImQOmmV
 EW0fS+EK8tMBQGmqegFv+cgJrtS8XbxfzsILTLJzgXmuSGHofz
 bdAx563n5XiS14Kz1MkzbTNaYH1Ejn4K80+CJ/Xd87wjedkYiu
 qGicklvCLj16/OgwMQ22g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is a much-awaited set of conversions of three existing platforms
to understand device tree format. I've already mentioned that this
might still be coming, but it wasn't clear if all the necesary Acks
would arrive in time for the short merge window, and if we could
resolve the conflicts with the other changes.

Thanks to a lot of hard work from Shawn, Grant and a lot of testers,
this all looks very good now. Please pull.

	Arnd

The following changes since commit 95b6886526bb510b8370b625a49bc0ab3b8ff10f:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6 (2011-07-27 19:26:38 -0700)

are available in the git repository at:

  git+ssh://master.kernel.org/pub/scm/linux/kernel/git/arm/linux-arm-soc.git/ next/dt

Arnd Bergmann (1):
      Merge branch 'imx/dt' into next/dt

Grant Likely (6):
      arm/dt: Add dt machine definition
      arm/dt: Add skeleton dtsi file
      irq: add irq_domain translation infrastructure
      dt/irq: add irq_domain_generate_simple() helper
      arm/versatile: Add device tree support
      arm/dt: tegra devicetree support

Rob Herring (1):
      arm/dt: Add dtb make rule

Shawn Guo (14):
      serial/imx: get rid of the uses of cpu_is_mx1()
      serial/imx: add device tree probe support
      net/fec: gasket needs to be enabled for some i.mx
      dt/net: add helper function of_get_phy_mode
      net: ibm_newemac: convert it to use of_get_phy_mode
      net/fec: add device tree probe support
      mmc: sdhci-esdhc-imx: extend card_detect and write_protect support for mx5
      mmc: sdhci-esdhc-imx: do not reference platform data after probe
      mmc: sdhci-esdhc-imx: get rid of the uses of cpu_is_mx()
      mmc: sdhci-pltfm: dt device does not pass parent to sdhci_alloc_host
      mmc: sdhci-esdhc-imx: add device tree probe support
      dmaengine: imx-sdma: use platform_device_id to identify sdma version
      dmaengine: imx-sdma: sdma_get_firmware does not need to copy fw_name
      dmaengine: imx-sdma: add device tree probe support

 Documentation/devicetree/bindings/arm/arm-boards   |   20 ++
 .../devicetree/bindings/dma/fsl-imx-sdma.txt       |   17 ++
 .../devicetree/bindings/i2c/arm-versatile.txt      |   10 +
 .../devicetree/bindings/mmc/fsl-imx-esdhc.txt      |   34 +++
 .../devicetree/bindings/mtd/arm-versatile.txt      |    8 +
 Documentation/devicetree/bindings/net/fsl-fec.txt  |   24 ++
 .../devicetree/bindings/net/smsc-lan91c111.txt     |   10 +
 .../bindings/tty/serial/fsl-imx-uart.txt           |   19 ++
 arch/arm/Kconfig                                   |    1 +
 arch/arm/Makefile                                  |    7 +
 arch/arm/boot/Makefile                             |    6 +
 arch/arm/boot/dts/skeleton.dtsi                    |   13 +
 arch/arm/boot/dts/tegra-harmony.dts                |   70 ++++++
 arch/arm/boot/dts/tegra-seaboard.dts               |   28 ++
 arch/arm/boot/dts/tegra20.dtsi                     |  139 +++++++++++
 arch/arm/boot/dts/versatile-ab.dts                 |  192 ++++++++++++++
 arch/arm/boot/dts/versatile-pb.dts                 |   48 ++++
 arch/arm/include/asm/mach/arch.h                   |    7 +
 arch/arm/include/asm/prom.h                        |    5 -
 arch/arm/kernel/devtree.c                          |   14 -
 arch/arm/mach-imx/clock-imx1.c                     |    6 +-
 arch/arm/mach-imx/clock-imx21.c                    |    8 +-
 arch/arm/mach-imx/clock-imx25.c                    |   20 +-
 arch/arm/mach-imx/clock-imx27.c                    |   15 +-
 arch/arm/mach-imx/clock-imx31.c                    |   13 +-
 arch/arm/mach-imx/clock-imx35.c                    |   18 +-
 arch/arm/mach-imx/eukrea_mbimxsd25-baseboard.c     |    3 +-
 arch/arm/mach-imx/eukrea_mbimxsd35-baseboard.c     |    3 +-
 arch/arm/mach-imx/mach-mx25_3ds.c                  |    2 +
 arch/arm/mach-imx/mach-pcm043.c                    |    2 +
 arch/arm/mach-imx/mm-imx25.c                       |    4 +-
 arch/arm/mach-imx/mm-imx31.c                       |    3 +-
 arch/arm/mach-imx/mm-imx35.c                       |    3 +-
 arch/arm/mach-mx5/board-mx51_babbage.c             |   14 +-
 arch/arm/mach-mx5/board-mx53_loco.c                |    4 +
 arch/arm/mach-mx5/clock-mx51-mx53.c                |   46 ++--
 arch/arm/mach-mx5/mm.c                             |    8 +-
 arch/arm/mach-mx5/mx51_efika.c                     |    4 +-
 arch/arm/mach-tegra/Kconfig                        |    6 +
 arch/arm/mach-tegra/Makefile                       |    3 +
 arch/arm/mach-tegra/Makefile.boot                  |    3 +
 arch/arm/mach-tegra/board-dt.c                     |  119 +++++++++
 arch/arm/mach-versatile/Kconfig                    |    8 +
 arch/arm/mach-versatile/Makefile                   |    1 +
 arch/arm/mach-versatile/core.c                     |   62 +++++
 arch/arm/mach-versatile/core.h                     |    4 +
 arch/arm/mach-versatile/versatile_dt.c             |   51 ++++
 arch/arm/plat-mxc/devices/platform-fec.c           |   21 +-
 arch/arm/plat-mxc/devices/platform-imx-dma.c       |    4 +-
 arch/arm/plat-mxc/devices/platform-imx-uart.c      |    7 +-
 .../plat-mxc/devices/platform-sdhci-esdhc-imx.c    |   29 ++-
 arch/arm/plat-mxc/include/mach/devices-common.h    |    4 +-
 arch/arm/plat-mxc/include/mach/dma.h               |    3 +-
 arch/arm/plat-mxc/include/mach/esdhc.h             |   25 ++-
 arch/arm/plat-mxc/include/mach/sdma.h              |    2 -
 drivers/dma/imx-sdma.c                             |   94 ++++++--
 drivers/mmc/host/sdhci-esdhc-imx.c                 |  261 +++++++++++++++-----
 drivers/mmc/host/sdhci-pltfm.c                     |    3 +-
 drivers/net/fec.c                                  |  125 +++++++++-
 drivers/net/ibm_newemac/core.c                     |   33 +---
 drivers/net/ibm_newemac/emac.h                     |   19 +-
 drivers/net/ibm_newemac/phy.c                      |    7 +-
 drivers/of/of_net.c                                |   45 ++++
 drivers/tty/serial/imx.c                           |  166 +++++++++++--
 include/linux/irq.h                                |    6 +
 include/linux/irqdomain.h                          |   91 +++++++
 include/linux/of_irq.h                             |    4 +
 include/linux/of_net.h                             |    1 +
 include/linux/phy.h                                |    4 +-
 kernel/irq/Kconfig                                 |    4 +
 kernel/irq/Makefile                                |    1 +
 kernel/irq/irqdomain.c                             |  180 ++++++++++++++
 72 files changed, 1963 insertions(+), 281 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/arm-boards
 create mode 100644 Documentation/devicetree/bindings/dma/fsl-imx-sdma.txt
 create mode 100644 Documentation/devicetree/bindings/i2c/arm-versatile.txt
 create mode 100644 Documentation/devicetree/bindings/mmc/fsl-imx-esdhc.txt
 create mode 100644 Documentation/devicetree/bindings/mtd/arm-versatile.txt
 create mode 100644 Documentation/devicetree/bindings/net/fsl-fec.txt
 create mode 100644 Documentation/devicetree/bindings/net/smsc-lan91c111.txt
 create mode 100644 Documentation/devicetree/bindings/tty/serial/fsl-imx-uart.txt
 create mode 100644 arch/arm/boot/dts/skeleton.dtsi
 create mode 100644 arch/arm/boot/dts/tegra-harmony.dts
 create mode 100644 arch/arm/boot/dts/tegra-seaboard.dts
 create mode 100644 arch/arm/boot/dts/tegra20.dtsi
 create mode 100644 arch/arm/boot/dts/versatile-ab.dts
 create mode 100644 arch/arm/boot/dts/versatile-pb.dts
 create mode 100644 arch/arm/mach-tegra/board-dt.c
 create mode 100644 arch/arm/mach-versatile/versatile_dt.c
 create mode 100644 include/linux/irqdomain.h
 create mode 100644 kernel/irq/irqdomain.c
