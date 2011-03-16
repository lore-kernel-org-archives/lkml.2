Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465Ab1CPQgv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 12:36:51 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37086 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115Ab1CPQgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 12:36:45 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 16 Mar 2011 10:36:24 -0600
X-Google-Sender-Auth: 2Y-s6_WJ_m2mIhXe52eER4Khbbs
Message-ID: <AANLkTi=nCSyqh3z5DrfnOYmDKH+GseFpn8hz5tG1EN7P@mail.gmail.com>
Subject: [git pull] device tree for 2.6.39
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>
Cc: Lennert Buytenhek <buytenh@wantstofly.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Tobias Klauser <tklauser@distanz.ch>,
        Walter Goossens <waltergoossens@home.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Big clean up here removing the last vestiges of of_platform_bus_type.
along with other minor fixes and cleanups.  Also generalizes some of
the powerpc dt code to be usable by other platforms.

g.

The following changes since commit 521cb40b0c44418a4fd36dc633f575813d59a43d:

  Linux 2.6.38 (2011-03-14 18:20:32 -0700)

are available in the git repository at:
  git://git.secretlab.ca/git/linux-2.6 devicetree/next

Grant Likely (19):
      driver-core: remove conditionals around devicetree pointers
      Merge commit 'v2.6.38-rc3' into devicetree/next
      powerpc/pci: Make both ppc32 and ppc64 use sysdata for pci_controller
      Merge commit 'v2.6.38-rc6' into devicetree/next
      drivercore/dt: add a match table pointer to struct device
      dt/powerpc: move of_bus_type infrastructure to ibmebus
      dt/powerpc: Eliminate users of of_platform_{,un}register_driver
      dt/sparc: Eliminate users of of_platform_{,un}register_driver
      leds/leds-gpio: merge platform_driver with of_platform_driver
      dt: xilinx_hwicap: merge platform and of_platform driver bindings
      dt: uartlite: merge platform and of_platform driver bindings
      dt/spi: Eliminate users of of_platform_{,un}register_driver
      dt/sound: Eliminate users of of_platform_{,un}register_driver
      dt/net: Eliminate users of of_platform_{,un}register_driver
      dt/video: Eliminate users of of_platform_{,un}register_driver
      dt/usb: Eliminate users of of_platform_{,un}register_driver
      dt/serial: Eliminate users of of_platform_{,un}register_driver
      dt: Eliminate of_platform_{,un}register_driver
      dt: eliminate of_platform_driver shim code

Lennert Buytenhek (1):
      dt: Typo fix.

Rob Herring (1):
      ipmi: convert OF driver to platform driver

Sebastian Andrzej Siewior (1):
      of/pci: move of_irq_map_pci() into generic code

Tobias Klauser (2):
      tty: serial: altera_uart: Add devicetree support
      tty: serial: altera_jtaguart: Add device tree support

Walter Goossens (1):
      altera_ps2: Add devicetree support

 .../devicetree/bindings/serial/altera_jtaguart.txt |    4 +
 .../devicetree/bindings/serial/altera_uart.txt     |    7 +
 .../devicetree/bindings/serio/altera_ps2.txt       |    4 +
 arch/microblaze/include/asm/pci-bridge.h           |   12 +
 arch/microblaze/include/asm/prom.h                 |   15 -
 arch/microblaze/kernel/prom_parse.c                |   77 ----
 arch/microblaze/pci/pci-common.c                   |    1 +
 arch/microblaze/pci/pci_32.c                       |    1 +
 arch/powerpc/include/asm/pci-bridge.h              |   37 +-
 arch/powerpc/include/asm/pci.h                     |    2 +-
 arch/powerpc/include/asm/prom.h                    |   15 -
 arch/powerpc/kernel/ibmebus.c                      |  404 +++++++++++++++++-
 arch/powerpc/kernel/of_platform.c                  |    9 +-
 arch/powerpc/kernel/pci-common.c                   |   12 +-
 arch/powerpc/kernel/pci_32.c                       |    2 +-
 arch/powerpc/kernel/pci_64.c                       |    6 +-
 arch/powerpc/kernel/pci_dn.c                       |    9 +-
 arch/powerpc/kernel/pci_of_scan.c                  |    4 +-
 arch/powerpc/kernel/prom_parse.c                   |   84 ----
 arch/powerpc/platforms/52xx/mpc52xx_gpio.c         |   14 +-
 arch/powerpc/platforms/52xx/mpc52xx_gpt.c          |   10 +-
 arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c      |   11 +-
 arch/powerpc/platforms/82xx/ep8248e.c              |    7 +-
 arch/powerpc/platforms/83xx/suspend.c              |   14 +-
 arch/powerpc/platforms/cell/axon_msi.c             |   11 +-
 arch/powerpc/platforms/pasemi/gpio_mdio.c          |    9 +-
 arch/powerpc/platforms/pseries/pci_dlpar.c         |    2 +-
 arch/powerpc/sysdev/axonram.c                      |   11 +-
 arch/powerpc/sysdev/bestcomm/bestcomm.c            |    9 +-
 arch/powerpc/sysdev/fsl_85xx_l2ctlr.c              |    9 +-
 arch/powerpc/sysdev/fsl_msi.c                      |   13 +-
 arch/powerpc/sysdev/fsl_pmc.c                      |    7 +-
 arch/powerpc/sysdev/fsl_rio.c                      |    7 +-
 arch/powerpc/sysdev/pmi.c                          |    9 +-
 arch/powerpc/sysdev/qe_lib/qe.c                    |    7 +-
 arch/sparc/include/asm/parport.h                   |    6 +-
 arch/sparc/kernel/apc.c                            |    7 +-
 arch/sparc/kernel/auxio_64.c                       |    7 +-
 arch/sparc/kernel/central.c                        |   14 +-
 arch/sparc/kernel/chmc.c                           |   19 +-
 arch/sparc/kernel/pci_fire.c                       |    7 +-
 arch/sparc/kernel/pci_psycho.c                     |    7 +-
 arch/sparc/kernel/pci_sabre.c                      |    9 +-
 arch/sparc/kernel/pci_schizo.c                     |   11 +-
 arch/sparc/kernel/pci_sun4v.c                      |    7 +-
 arch/sparc/kernel/pmc.c                            |    7 +-
 arch/sparc/kernel/power.c                          |    6 +-
 arch/sparc/kernel/time_32.c                        |    6 +-
 arch/sparc/kernel/time_64.c                        |   18 +-
 drivers/ata/pata_mpc52xx.c                         |    8 +-
 drivers/ata/pata_of_platform.c                     |    9 +-
 drivers/ata/sata_dwc_460ex.c                       |    9 +-
 drivers/ata/sata_fsl.c                             |    9 +-
 drivers/atm/fore200e.c                             |   17 +-
 drivers/block/xsysace.c                            |   11 +-
 drivers/char/hw_random/n2-drv.c                    |   16 +-
 drivers/char/hw_random/pasemi-rng.c                |    9 +-
 drivers/char/ipmi/ipmi_si_intf.c                   |   70 +--
 drivers/char/xilinx_hwicap/xilinx_hwicap.c         |  129 ++----
 drivers/crypto/amcc/crypto4xx_core.c               |    9 +-
 drivers/crypto/n2_core.c                           |   20 +-
 drivers/crypto/talitos.c                           |    9 +-
 drivers/dma/fsldma.c                               |   14 +-
 drivers/dma/mpc512x_dma.c                          |    9 +-
 drivers/dma/ppc4xx/adma.c                          |   11 +-
 drivers/edac/mpc85xx_edac.c                        |   27 +-
 drivers/edac/ppc4xx_edac.c                         |   23 +-
 drivers/hwmon/ultra45_env.c                        |    9 +-
 drivers/i2c/busses/i2c-cpm.c                       |    9 +-
 drivers/i2c/busses/i2c-ibm_iic.c                   |    9 +-
 drivers/i2c/busses/i2c-mpc.c                       |   22 +-
 drivers/i2c/busses/i2c-ocores.c                    |   14 +-
 drivers/i2c/i2c-core.c                             |    2 -
 drivers/input/misc/sparcspkr.c                     |   22 +-
 drivers/input/serio/altera_ps2.c                   |   15 +-
 drivers/input/serio/i8042-sparcio.h                |    8 +-
 drivers/input/serio/xilinx_ps2.c                   |    9 +-
 drivers/leds/leds-gpio.c                           |  214 ++++------
 drivers/macintosh/smu.c                            |    7 +-
 drivers/macintosh/therm_pm72.c                     |    8 +-
 drivers/macintosh/therm_windtunnel.c               |    9 +-
 drivers/media/video/fsl-viu.c                      |    9 +-
 drivers/mmc/host/mmc_spi.c                         |    4 -
 drivers/mmc/host/sdhci-of-core.c                   |   15 +-
 drivers/mtd/maps/physmap_of.c                      |   15 +-
 drivers/mtd/maps/sun_uflash.c                      |    8 +-
 drivers/mtd/nand/fsl_upm.c                         |    9 +-
 drivers/mtd/nand/mpc5121_nfc.c                     |    9 +-
 drivers/mtd/nand/ndfc.c                            |    9 +-
 drivers/mtd/nand/pasemi_nand.c                     |    9 +-
 drivers/mtd/nand/socrates_nand.c                   |    9 +-
 drivers/net/can/mscan/mpc5xxx_can.c                |   15 +-
 drivers/net/can/sja1000/sja1000_of_platform.c      |    9 +-
 drivers/net/ethoc.c                                |    8 +-
 drivers/net/fec_mpc52xx.c                          |   13 +-
 drivers/net/fec_mpc52xx.h                          |    2 +-
 drivers/net/fec_mpc52xx_phy.c                      |    5 +-
 drivers/net/fs_enet/fs_enet-main.c                 |   16 +-
 drivers/net/fs_enet/mii-bitbang.c                  |    9 +-
 drivers/net/fs_enet/mii-fec.c                      |   15 +-
 drivers/net/fsl_pq_mdio.c                          |    9 +-
 drivers/net/gianfar.c                              |   12 +-
 drivers/net/greth.c                                |    8 +-
 drivers/net/ibm_newemac/core.c                     |    9 +-
 drivers/net/ibm_newemac/mal.c                      |    9 +-
 drivers/net/ibm_newemac/rgmii.c                    |    9 +-
 drivers/net/ibm_newemac/tah.c                      |    9 +-
 drivers/net/ibm_newemac/zmii.c                     |    9 +-
 drivers/net/ll_temac_main.c                        |    9 +-
 drivers/net/myri_sbus.c                            |    8 +-
 drivers/net/niu.c                                  |   11 +-
 drivers/net/phy/mdio-gpio.c                        |    9 +-
 drivers/net/sunbmac.c                              |    9 +-
 drivers/net/sunhme.c                               |   14 +-
 drivers/net/sunlance.c                             |    8 +-
 drivers/net/sunqe.c                                |    8 +-
 drivers/net/ucc_geth.c                             |    8 +-
 drivers/net/xilinx_emaclite.c                      |    9 +-
 drivers/of/Kconfig                                 |    6 +
 drivers/of/Makefile                                |    1 +
 drivers/of/device.c                                |   34 --
 drivers/of/of_pci.c                                |   91 ++++
 drivers/of/platform.c                              |  461 --------------------
 drivers/parport/parport_sunbpp.c                   |    8 +-
 drivers/pcmcia/electra_cf.c                        |    9 +-
 drivers/pcmcia/m8xx_pcmcia.c                       |    9 +-
 drivers/rtc/rtc-mpc5121.c                          |    9 +-
 drivers/sbus/char/bbc_i2c.c                        |    9 +-
 drivers/sbus/char/display7seg.c                    |    9 +-
 drivers/sbus/char/envctrl.c                        |    9 +-
 drivers/sbus/char/flash.c                          |    9 +-
 drivers/sbus/char/uctrl.c                          |    9 +-
 drivers/scsi/qlogicpti.c                           |   14 +-
 drivers/scsi/sun_esp.c                             |    8 +-
 drivers/spi/mpc512x_psc_spi.c                      |    9 +-
 drivers/spi/mpc52xx_psc_spi.c                      |    9 +-
 drivers/spi/mpc52xx_spi.c                          |    9 +-
 drivers/spi/pxa2xx_spi.c                           |    2 -
 drivers/spi/pxa2xx_spi_pci.c                       |    2 -
 drivers/spi/spi_fsl_espi.c                         |   11 +-
 drivers/spi/spi_fsl_lib.c                          |    3 +-
 drivers/spi/spi_fsl_lib.h                          |    3 +-
 drivers/spi/spi_fsl_spi.c                          |   11 +-
 drivers/spi/spi_ppc4xx.c                           |    9 +-
 drivers/spi/xilinx_spi.c                           |    6 -
 drivers/tty/serial/altera_jtaguart.c               |   15 +-
 drivers/tty/serial/altera_uart.c                   |   51 ++-
 drivers/tty/serial/apbuart.c                       |   11 +-
 drivers/tty/serial/cpm_uart/cpm_uart_core.c        |    9 +-
 drivers/tty/serial/mpc52xx_uart.c                  |   13 +-
 drivers/tty/serial/of_serial.c                     |   14 +-
 drivers/tty/serial/sunhv.c                         |    8 +-
 drivers/tty/serial/sunsab.c                        |    8 +-
 drivers/tty/serial/sunsu.c                         |    6 +-
 drivers/tty/serial/sunzilog.c                      |   10 +-
 drivers/tty/serial/uartlite.c                      |  103 +----
 drivers/tty/serial/ucc_uart.c                      |    9 +-
 drivers/usb/gadget/fsl_qe_udc.c                    |   14 +-
 drivers/usb/host/ehci-hcd.c                        |   12 +-
 drivers/usb/host/ehci-ppc-of.c                     |    9 +-
 drivers/usb/host/ehci-xilinx-of.c                  |    6 +-
 drivers/usb/host/fhci-hcd.c                        |    9 +-
 drivers/usb/host/isp1760-if.c                      |    9 +-
 drivers/usb/host/ohci-hcd.c                        |    6 +-
 drivers/usb/host/ohci-ppc-of.c                     |    9 +-
 drivers/video/bw2.c                                |    8 +-
 drivers/video/cg14.c                               |    8 +-
 drivers/video/cg3.c                                |    9 +-
 drivers/video/cg6.c                                |    9 +-
 drivers/video/ffb.c                                |    9 +-
 drivers/video/fsl-diu-fb.c                         |    9 +-
 drivers/video/leo.c                                |    9 +-
 drivers/video/mb862xx/mb862xxfb.c                  |    9 +-
 drivers/video/p9100.c                              |    8 +-
 drivers/video/platinumfb.c                         |    9 +-
 drivers/video/sunxvr1000.c                         |    9 +-
 drivers/video/tcx.c                                |    9 +-
 drivers/video/xilinxfb.c                           |   11 +-
 drivers/watchdog/cpwd.c                            |    9 +-
 drivers/watchdog/gef_wdt.c                         |    9 +-
 drivers/watchdog/mpc8xxx_wdt.c                     |   15 +-
 drivers/watchdog/riowd.c                           |    9 +-
 include/linux/device.h                             |    8 +-
 include/linux/i2c.h                                |    2 -
 include/linux/of.h                                 |    6 +-
 include/linux/of_device.h                          |    5 +-
 include/linux/of_pci.h                             |    9 +
 include/linux/of_platform.h                        |   18 +-
 sound/soc/fsl/fsl_dma.c                            |    9 +-
 sound/soc/fsl/fsl_ssi.c                            |    9 +-
 sound/soc/fsl/mpc5200_dma.c                        |   24 +-
 sound/soc/fsl/mpc5200_psc_ac97.c                   |    9 +-
 sound/soc/fsl/mpc5200_psc_i2s.c                    |    9 +-
 sound/sparc/amd7930.c                              |    8 +-
 sound/sparc/cs4231.c                               |   16 +-
 sound/sparc/dbri.c                                 |    8 +-
 196 files changed, 1546 insertions(+), 1959 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/serial/altera_jtaguart.txt
 create mode 100644 Documentation/devicetree/bindings/serial/altera_uart.txt
 create mode 100644 Documentation/devicetree/bindings/serio/altera_ps2.txt
 create mode 100644 drivers/of/of_pci.c
 create mode 100644 include/linux/of_pci.h

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
