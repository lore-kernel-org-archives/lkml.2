Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221Ab1BWEdl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 23:33:41 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49850 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913Ab1BWEdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 23:33:40 -0500
Subject: [RFC PATCH 00/15] Remove last remains of of_platform_bus_type
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        devicetree-discuss@lists.ozlabs.org, sfr@canb.auug.org.au,
        linux-kernel@vger.kernel.org, davem@davemloft.net
From: Grant Likely <grant.likely@secretlab.ca>
Cc: sparclinux@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Date: Tue, 22 Feb 2011 21:33:34 -0700
Message-ID: <20110223043015.20795.37090.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series finally removes all the remaining users of the
of_platform_{,un}register_driver() functions that used to be sued with
the of_platform_bus_type.  All the cool kids are using the platform
bus now.  At the end of this series the ugly stop-gap shim code is finally
removed.

g.

---

Grant Likely (15):
      dt/powerpc: move of_bus_type infrastructure to ibmebus
      dt: add a match table pointer to struct device
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


 arch/powerpc/kernel/ibmebus.c                 |  404 ++++++++++++++++++++++
 arch/powerpc/kernel/of_platform.c             |    7 
 arch/powerpc/platforms/52xx/mpc52xx_gpio.c    |   14 -
 arch/powerpc/platforms/52xx/mpc52xx_gpt.c     |   10 -
 arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c |   11 -
 arch/powerpc/platforms/82xx/ep8248e.c         |    7 
 arch/powerpc/platforms/83xx/suspend.c         |   14 -
 arch/powerpc/platforms/cell/axon_msi.c        |   11 -
 arch/powerpc/platforms/pasemi/gpio_mdio.c     |    9 
 arch/powerpc/sysdev/axonram.c                 |   11 -
 arch/powerpc/sysdev/bestcomm/bestcomm.c       |    9 
 arch/powerpc/sysdev/fsl_85xx_l2ctlr.c         |    9 
 arch/powerpc/sysdev/fsl_msi.c                 |   13 -
 arch/powerpc/sysdev/fsl_pmc.c                 |    7 
 arch/powerpc/sysdev/fsl_rio.c                 |    7 
 arch/powerpc/sysdev/pmi.c                     |    9 
 arch/powerpc/sysdev/qe_lib/qe.c               |    7 
 arch/sparc/include/asm/parport.h              |    6 
 arch/sparc/kernel/apc.c                       |    7 
 arch/sparc/kernel/auxio_64.c                  |    7 
 arch/sparc/kernel/central.c                   |   14 -
 arch/sparc/kernel/chmc.c                      |   19 -
 arch/sparc/kernel/pci_fire.c                  |    7 
 arch/sparc/kernel/pci_psycho.c                |    7 
 arch/sparc/kernel/pci_sabre.c                 |    9 
 arch/sparc/kernel/pci_schizo.c                |   11 -
 arch/sparc/kernel/pci_sun4v.c                 |    7 
 arch/sparc/kernel/pmc.c                       |    7 
 arch/sparc/kernel/power.c                     |    6 
 arch/sparc/kernel/time_32.c                   |    6 
 arch/sparc/kernel/time_64.c                   |   18 -
 drivers/ata/pata_mpc52xx.c                    |    8 
 drivers/ata/pata_of_platform.c                |    9 
 drivers/ata/sata_dwc_460ex.c                  |    9 
 drivers/ata/sata_fsl.c                        |    9 
 drivers/atm/fore200e.c                        |   17 +
 drivers/block/xsysace.c                       |   11 -
 drivers/char/hw_random/n2-drv.c               |   16 -
 drivers/char/hw_random/pasemi-rng.c           |    9 
 drivers/char/ipmi/ipmi_si_intf.c              |   18 +
 drivers/char/xilinx_hwicap/xilinx_hwicap.c    |  129 +++----
 drivers/crypto/amcc/crypto4xx_core.c          |    9 
 drivers/crypto/n2_core.c                      |   20 -
 drivers/crypto/talitos.c                      |    9 
 drivers/dma/fsldma.c                          |   14 -
 drivers/dma/mpc512x_dma.c                     |    9 
 drivers/dma/ppc4xx/adma.c                     |   11 -
 drivers/edac/mpc85xx_edac.c                   |   27 +
 drivers/edac/ppc4xx_edac.c                    |   23 -
 drivers/hwmon/ultra45_env.c                   |    9 
 drivers/i2c/busses/i2c-cpm.c                  |    9 
 drivers/i2c/busses/i2c-ibm_iic.c              |    9 
 drivers/i2c/busses/i2c-mpc.c                  |   22 -
 drivers/input/misc/sparcspkr.c                |   22 +
 drivers/input/serio/i8042-sparcio.h           |    8 
 drivers/input/serio/xilinx_ps2.c              |    9 
 drivers/leds/leds-gpio.c                      |  206 +++++------
 drivers/macintosh/smu.c                       |    7 
 drivers/macintosh/therm_pm72.c                |    8 
 drivers/macintosh/therm_windtunnel.c          |    9 
 drivers/media/video/fsl-viu.c                 |    9 
 drivers/mmc/host/sdhci-of-core.c              |   12 -
 drivers/mtd/maps/physmap_of.c                 |   15 -
 drivers/mtd/maps/sun_uflash.c                 |    8 
 drivers/mtd/nand/fsl_upm.c                    |    9 
 drivers/mtd/nand/mpc5121_nfc.c                |    9 
 drivers/mtd/nand/ndfc.c                       |    9 
 drivers/mtd/nand/pasemi_nand.c                |    9 
 drivers/mtd/nand/socrates_nand.c              |    9 
 drivers/net/can/mscan/mpc5xxx_can.c           |   15 -
 drivers/net/can/sja1000/sja1000_of_platform.c |    9 
 drivers/net/fec_mpc52xx.c                     |   13 -
 drivers/net/fec_mpc52xx.h                     |    2 
 drivers/net/fec_mpc52xx_phy.c                 |    5 
 drivers/net/fs_enet/fs_enet-main.c            |   16 -
 drivers/net/fs_enet/mii-bitbang.c             |    9 
 drivers/net/fs_enet/mii-fec.c                 |   15 -
 drivers/net/fsl_pq_mdio.c                     |    9 
 drivers/net/gianfar.c                         |   12 -
 drivers/net/greth.c                           |    8 
 drivers/net/ibm_newemac/core.c                |    9 
 drivers/net/ibm_newemac/mal.c                 |    9 
 drivers/net/ibm_newemac/rgmii.c               |    9 
 drivers/net/ibm_newemac/tah.c                 |    9 
 drivers/net/ibm_newemac/zmii.c                |    9 
 drivers/net/ll_temac_main.c                   |    9 
 drivers/net/myri_sbus.c                       |    8 
 drivers/net/niu.c                             |   11 -
 drivers/net/phy/mdio-gpio.c                   |    9 
 drivers/net/sunbmac.c                         |    9 
 drivers/net/sunhme.c                          |   14 -
 drivers/net/sunlance.c                        |    8 
 drivers/net/sunqe.c                           |    8 
 drivers/net/ucc_geth.c                        |    8 
 drivers/net/xilinx_emaclite.c                 |    9 
 drivers/of/device.c                           |   34 --
 drivers/of/platform.c                         |  461 -------------------------
 drivers/parport/parport_sunbpp.c              |    8 
 drivers/pcmcia/electra_cf.c                   |    9 
 drivers/pcmcia/m8xx_pcmcia.c                  |    9 
 drivers/rtc/rtc-mpc5121.c                     |    9 
 drivers/sbus/char/bbc_i2c.c                   |    9 
 drivers/sbus/char/display7seg.c               |    9 
 drivers/sbus/char/envctrl.c                   |    9 
 drivers/sbus/char/flash.c                     |    9 
 drivers/sbus/char/uctrl.c                     |    9 
 drivers/scsi/qlogicpti.c                      |   14 -
 drivers/scsi/sun_esp.c                        |    8 
 drivers/spi/mpc512x_psc_spi.c                 |    9 
 drivers/spi/mpc52xx_psc_spi.c                 |    9 
 drivers/spi/mpc52xx_spi.c                     |    9 
 drivers/spi/spi_fsl_espi.c                    |   11 -
 drivers/spi/spi_fsl_lib.c                     |    3 
 drivers/spi/spi_fsl_lib.h                     |    3 
 drivers/spi/spi_fsl_spi.c                     |   11 -
 drivers/spi/spi_ppc4xx.c                      |    9 
 drivers/tty/serial/apbuart.c                  |   11 -
 drivers/tty/serial/cpm_uart/cpm_uart_core.c   |    9 
 drivers/tty/serial/mpc52xx_uart.c             |   13 -
 drivers/tty/serial/of_serial.c                |   14 -
 drivers/tty/serial/sunhv.c                    |    8 
 drivers/tty/serial/sunsab.c                   |    8 
 drivers/tty/serial/sunsu.c                    |    6 
 drivers/tty/serial/sunzilog.c                 |   10 -
 drivers/tty/serial/uartlite.c                 |  103 +-----
 drivers/tty/serial/ucc_uart.c                 |    9 
 drivers/usb/gadget/fsl_qe_udc.c               |   14 -
 drivers/usb/host/ehci-hcd.c                   |   12 -
 drivers/usb/host/ehci-ppc-of.c                |    9 
 drivers/usb/host/ehci-xilinx-of.c             |    6 
 drivers/usb/host/fhci-hcd.c                   |    9 
 drivers/usb/host/isp1760-if.c                 |    9 
 drivers/usb/host/ohci-hcd.c                   |    6 
 drivers/usb/host/ohci-ppc-of.c                |    9 
 drivers/video/bw2.c                           |    8 
 drivers/video/cg14.c                          |    8 
 drivers/video/cg3.c                           |    9 
 drivers/video/cg6.c                           |    9 
 drivers/video/ffb.c                           |    9 
 drivers/video/fsl-diu-fb.c                    |    9 
 drivers/video/leo.c                           |    9 
 drivers/video/mb862xx/mb862xxfb.c             |    9 
 drivers/video/p9100.c                         |    8 
 drivers/video/platinumfb.c                    |    9 
 drivers/video/sunxvr1000.c                    |    9 
 drivers/video/tcx.c                           |    9 
 drivers/video/xilinxfb.c                      |   11 -
 drivers/watchdog/cpwd.c                       |    9 
 drivers/watchdog/gef_wdt.c                    |    9 
 drivers/watchdog/mpc8xxx_wdt.c                |   15 -
 drivers/watchdog/riowd.c                      |    9 
 include/linux/device.h                        |    1 
 include/linux/of_device.h                     |    5 
 include/linux/of_platform.h                   |   18 -
 sound/soc/fsl/fsl_dma.c                       |    9 
 sound/soc/fsl/fsl_ssi.c                       |    9 
 sound/soc/fsl/mpc5200_dma.c                   |   24 +
 sound/soc/fsl/mpc5200_psc_ac97.c              |    9 
 sound/soc/fsl/mpc5200_psc_i2s.c               |    9 
 sound/sparc/amd7930.c                         |    8 
 sound/sparc/cs4231.c                          |   16 -
 sound/sparc/dbri.c                            |    8 
 162 files changed, 1278 insertions(+), 1627 deletions(-)

-- 
Signature
