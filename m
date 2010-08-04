Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782Ab0HDRvV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 13:51:21 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45126 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab0HDRvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 13:51:18 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 4 Aug 2010 11:50:56 -0600
X-Google-Sender-Auth: 5ZQ7EGE0VfaKaCsET_GaWGRf1Gs
Message-ID: <AANLkTi=9h0faeUF4u4n5cP0w5RRhUK4geObcTw0y1giP@mail.gmail.com>
Subject: [git pull] device tree changes for 2.6.36
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>
Cc: Anatolij Gustschin <agust@denx.de>, Andres Salomon <dilinger@queued.net>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Jonas Bonn <jonas@southpole.se>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Robert Herring <R.Herring@freescale.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Stuart Yoder <stuyoder@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus

Here are the bulk of the device tree support generalizations and bug
fixes for the 2.6.36 merge window.  Please pull.

I have one more device tree patch that I want to push for this merge
window which is a bulk rename of struct of_device to struct
of_platform_device (very mechanical change).  I haven't included it in
this pull request because there are a number of merge conflicts.  I'm
going to hold it back for a week to wait for the bulk of .36 changes
to go in so that I can fix up the conflicts myself before I ask you to
pull it in.

Cheers,
g.


The following changes since commit 9fe6206f400646a2322096b56c59891d530e8d51:
  Linus Torvalds (1):
        Linux 2.6.35

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 next-devicetree

Anatolij Gustschin (1):
      of/spi: call of_register_spi_devices() from spi core code

Andres Salomon (2):
      proc: unify PROC_DEVICETREE config
      of/sparc: move is_root_node() to of.h

Anton Vorontsov (3):
      gpiolib: cosmetic improvements for error handling in gpiochip_add()
      of/gpio: Kill of_gpio_chip and add members directly to gpio_chip
      of/gpio: add default of_xlate function if device has a node pointer

Grant Likely (48):
      sparc/of: Move of_device fields into struct pdev_archdata
      of: kill struct of_device
      of/irq: Move irq_of_parse_and_map() to common code
      of/microblaze: strip out of_irq_workarounds code
      of/powerpc: Move Powermac irq quirk code into powermac pic driver code
      of/irq: merge irq mapping code
      of/address: merge of_iomap()
      of/address: merge of_address_to_resource()
      of/address: Merge all of the bus translation code
      of/address: little-endian fixes
      of/address: restrict 'no-ranges' kludge to powerpc
      of: Use full node name in resource structures
      of/device: merge of_device_uevent
      of: Modify of_device_get_modalias to be passed struct device
      of/device: Merge of_platform_bus_probe()
      of: Merge of_device_alloc() and of_device_make_bus_id()
      of/device: populate platform_device (of_device) resource table
on allocation
      of/gpio: stop using device_node data pointer to find gpio_chip
      of/gpio: fix of_gpio includes
      of/device: Add OF style matching helper function
      of/device: Move struct of_device define outside of CONFIG_OF_DEVICE test
      of/i2c: Generalize OF support
      i2c: Add OF-style registration and binding
      of: refactor of_modalias_node() and remove explicit match table.
      of: Fix missing include
      of: Put all CONFIG_OF dependencies into a Kconfig menu block
      drivers/of: fix build error when CONFIG_PPC_DCR is set
      of/flattree: Use common ALIGN() macro instead of arch specific _ALIGN
      of/flattree: Fix crash when device tree absent
      of: Remove unused of_find_device_by_phandle()
      of/device: Fix build errors for non-ppc and non-microblaze
      Merge commit 'v2.6.35-rc6' into devicetree/next
      drivercore/of: Add OF style matching to platform bus
      of: Merge of_platform_bus_type with platform_bus_type
      of/platform: remove all of_bus_type and of_platform_bus_type references
      of: remove asm/of_platform.h
      of: remove asm/of_device.h
      of/device: Protect against binding of_platform_drivers to non-OF devices
      of/device: Replace of_device with platform_device in includes
and core code
      powerpc: remove references to of_device and to_of_device
      sparc: remove references to of_device and to_of_device
      microblaze: remove references to of_device and to_of_device
      of: Fix phandle endian issues
      of/irq: Fix endian issues in parsing interrupt specifiers
      of/device: Make of_device_make_bus_id() usable by other code.
      of: Provide default of_node_to_nid() implementation.
      of/address: Clean up function declarations
      of/platform: Register of_platform_drivers with an "of:" prefix

Jonas Bonn (2):
      of: make of_find_device_by_node generic
      of: remove of_default_bus_ids

Randy Dunlap (1):
      niu: always include of_device.h

Rob Herring (1):
      of/irq: little endian fixes

Stephen Rothwell (5):
      microblaze: turn CONFIG_OF into a select
      powerpc: turn CONFIG_OF into a select
      sparc: turn CONFIG_OF into a select
      of: define CONFIG_OF globally so architectures can select it
      of: remove architecture CONFIG_OF definitions

Stuart Yoder (1):
      of/flattree: fix of_flat_dt_is_compatible() to match the full
compatible string

 arch/microblaze/Kconfig                        |   17 +-
 arch/microblaze/include/asm/irq.h              |   24 -
 arch/microblaze/include/asm/of_device.h        |   44 --
 arch/microblaze/include/asm/of_platform.h      |   54 --
 arch/microblaze/include/asm/page.h             |    7 -
 arch/microblaze/include/asm/pci-bridge.h       |    5 -
 arch/microblaze/include/asm/prom.h             |  115 +---
 arch/microblaze/include/asm/topology.h         |   10 -
 arch/microblaze/kernel/Makefile                |    4 +-
 arch/microblaze/kernel/irq.c                   |   14 +-
 arch/microblaze/kernel/of_device.c             |  112 ---
 arch/microblaze/kernel/of_platform.c           |  200 -----
 arch/microblaze/kernel/prom_parse.c            |  877 +----------------------
 arch/microblaze/kernel/reset.c                 |   12 +-
 arch/microblaze/kernel/setup.c                 |    6 -
 arch/powerpc/Kconfig                           |   18 +-
 arch/powerpc/include/asm/irq.h                 |   28 -
 arch/powerpc/include/asm/macio.h               |    2 +-
 arch/powerpc/include/asm/of_device.h           |   27 -
 arch/powerpc/include/asm/of_platform.h         |   29 -
 arch/powerpc/include/asm/pci-bridge.h          |    5 -
 arch/powerpc/include/asm/prom.h                |  133 +---
 arch/powerpc/include/asm/smu.h                 |    4 +-
 arch/powerpc/include/asm/topology.h            |    7 -
 arch/powerpc/kernel/Makefile                   |    2 +-
 arch/powerpc/kernel/dma-swiotlb.c              |    8 -
 arch/powerpc/kernel/ibmebus.c                  |    8 +-
 arch/powerpc/kernel/irq.c                      |   14 +-
 arch/powerpc/kernel/legacy_serial.c            |    1 +
 arch/powerpc/kernel/of_device.c                |  133 ----
 arch/powerpc/kernel/of_platform.c              |  203 +------
 arch/powerpc/kernel/pci-common.c               |    1 +
 arch/powerpc/kernel/prom_parse.c               |  924 +-----------------------
 arch/powerpc/kernel/setup-common.c             |    7 -
 arch/powerpc/platforms/512x/clock.c            |    2 +-
 arch/powerpc/platforms/52xx/lite5200.c         |    1 +
 arch/powerpc/platforms/52xx/mpc52xx_gpio.c     |   36 +-
 arch/powerpc/platforms/52xx/mpc52xx_gpt.c      |   33 +-
 arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c  |    6 +-
 arch/powerpc/platforms/82xx/ep8248e.c          |    4 +-
 arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c |   40 +-
 arch/powerpc/platforms/83xx/suspend.c          |    6 +-
 arch/powerpc/platforms/86xx/gef_gpio.c         |   24 +-
 arch/powerpc/platforms/amigaone/setup.c        |    3 +-
 arch/powerpc/platforms/cell/axon_msi.c         |    4 +-
 arch/powerpc/platforms/cell/beat_iommu.c       |    2 +-
 arch/powerpc/platforms/cell/iommu.c            |    2 +-
 arch/powerpc/platforms/cell/qpace_setup.c      |   14 +-
 arch/powerpc/platforms/cell/setup.c            |   14 +-
 arch/powerpc/platforms/iseries/mf.c            |    1 +
 arch/powerpc/platforms/pasemi/gpio_mdio.c      |    4 +-
 arch/powerpc/platforms/powermac/feature.c      |    2 +
 arch/powerpc/platforms/powermac/pic.c          |   72 ++-
 arch/powerpc/sysdev/axonram.c                  |   12 +-
 arch/powerpc/sysdev/bestcomm/bestcomm.c        |    7 +-
 arch/powerpc/sysdev/bestcomm/sram.c            |    1 +
 arch/powerpc/sysdev/cpm1.c                     |   10 +-
 arch/powerpc/sysdev/cpm_common.c               |    5 +-
 arch/powerpc/sysdev/fsl_gtm.c                  |    1 +
 arch/powerpc/sysdev/fsl_msi.c                  |    4 +-
 arch/powerpc/sysdev/fsl_pmc.c                  |    3 +-
 arch/powerpc/sysdev/fsl_rio.c                  |    4 +-
 arch/powerpc/sysdev/mpc8xxx_gpio.c             |    5 +-
 arch/powerpc/sysdev/mv64x60_dev.c              |    7 +-
 arch/powerpc/sysdev/pmi.c                      |    6 +-
 arch/powerpc/sysdev/ppc4xx_gpio.c              |    5 +-
 arch/powerpc/sysdev/qe_lib/gpio.c              |   31 +-
 arch/powerpc/sysdev/qe_lib/qe.c                |    5 +-
 arch/powerpc/sysdev/simple_gpio.c              |    5 +-
 arch/sparc/Kconfig                             |    4 +-
 arch/sparc/include/asm/device.h                |   11 +-
 arch/sparc/include/asm/floppy_64.h             |   10 +-
 arch/sparc/include/asm/of_device.h             |   38 -
 arch/sparc/include/asm/of_platform.h           |   18 -
 arch/sparc/include/asm/parport.h               |   12 +-
 arch/sparc/include/asm/prom.h                  |   10 +-
 arch/sparc/kernel/apc.c                        |    6 +-
 arch/sparc/kernel/auxio_64.c                   |    5 +-
 arch/sparc/kernel/central.c                    |    8 +-
 arch/sparc/kernel/chmc.c                       |   16 +-
 arch/sparc/kernel/ioport.c                     |    2 +-
 arch/sparc/kernel/of_device_32.c               |   63 +-
 arch/sparc/kernel/of_device_64.c               |   61 +-
 arch/sparc/kernel/of_device_common.c           |   35 +-
 arch/sparc/kernel/pci.c                        |    6 +-
 arch/sparc/kernel/pci_fire.c                   |    6 +-
 arch/sparc/kernel/pci_impl.h                   |    2 +-
 arch/sparc/kernel/pci_psycho.c                 |   16 +-
 arch/sparc/kernel/pci_sabre.c                  |   16 +-
 arch/sparc/kernel/pci_schizo.c                 |   32 +-
 arch/sparc/kernel/pci_sun4v.c                  |    6 +-
 arch/sparc/kernel/pmc.c                        |    4 +-
 arch/sparc/kernel/power.c                      |    6 +-
 arch/sparc/kernel/prom.h                       |    8 -
 arch/sparc/kernel/prom_64.c                    |    6 +-
 arch/sparc/kernel/prom_common.c                |    2 +-
 arch/sparc/kernel/prom_irqtrans.c              |    2 +-
 arch/sparc/kernel/psycho_common.c              |    2 +-
 arch/sparc/kernel/psycho_common.h              |    2 +-
 arch/sparc/kernel/sbus.c                       |   16 +-
 arch/sparc/kernel/time_32.c                    |    4 +-
 arch/sparc/kernel/time_64.c                    |   12 +-
 arch/sparc/mm/io-unit.c                        |    4 +-
 arch/sparc/mm/iommu.c                          |    4 +-
 drivers/atm/fore200e.c                         |    8 +-
 drivers/base/platform.c                        |   13 +-
 drivers/char/bsr.c                             |    1 +
 drivers/char/hw_random/n2-drv.c                |    4 +-
 drivers/crypto/n2_core.c                       |   10 +-
 drivers/gpio/gpiolib.c                         |   55 ++-
 drivers/gpio/xilinx_gpio.c                     |   15 +-
 drivers/hwmon/ultra45_env.c                    |    4 +-
 drivers/i2c/busses/i2c-cpm.c                   |    6 +-
 drivers/i2c/busses/i2c-ibm_iic.c               |    4 +-
 drivers/i2c/busses/i2c-mpc.c                   |    2 +-
 drivers/i2c/i2c-core.c                         |    9 +
 drivers/input/misc/sparcspkr.c                 |   12 +-
 drivers/input/serio/i8042-sparcio.h            |   13 +-
 drivers/macintosh/macio_sysfs.c                |    5 +-
 drivers/mmc/host/mmc_spi.c                     |    8 +
 drivers/mtd/maps/sun_uflash.c                  |    4 +-
 drivers/net/fsl_pq_mdio.c                      |    1 +
 drivers/net/ibm_newemac/core.c                 |    4 +-
 drivers/net/myri_sbus.c                        |    6 +-
 drivers/net/niu.c                              |   15 +-
 drivers/net/niu.h                              |    4 +-
 drivers/net/sunbmac.c                          |    6 +-
 drivers/net/sunhme.c                           |   10 +-
 drivers/net/sunlance.c                         |    6 +-
 drivers/net/sunqe.c                            |   10 +-
 drivers/net/xilinx_emaclite.c                  |    2 +-
 drivers/of/Kconfig                             |   40 +-
 drivers/of/Makefile                            |    2 +
 drivers/of/address.c                           |  595 +++++++++++++++
 drivers/of/base.c                              |   76 +--
 drivers/of/device.c                            |   91 ++-
 drivers/of/fdt.c                               |   26 +-
 drivers/of/gpio.c                              |   93 ++-
 drivers/of/irq.c                               |  349 +++++++++
 drivers/of/of_i2c.c                            |   50 +-
 drivers/of/of_mdio.c                           |    1 +
 drivers/of/of_spi.c                            |   11 +-
 drivers/of/platform.c                          |  384 ++++++++++-
 drivers/parport/parport_sunbpp.c               |    6 +-
 drivers/sbus/char/bbc_i2c.c                    |   10 +-
 drivers/sbus/char/display7seg.c                |    4 +-
 drivers/sbus/char/envctrl.c                    |    4 +-
 drivers/sbus/char/flash.c                      |    4 +-
 drivers/sbus/char/uctrl.c                      |    6 +-
 drivers/scsi/qlogicpti.c                       |    8 +-
 drivers/scsi/sun_esp.c                         |    6 +-
 drivers/serial/sunhv.c                         |    8 +-
 drivers/serial/sunsab.c                        |    6 +-
 drivers/serial/sunsu.c                         |    4 +-
 drivers/serial/sunzilog.c                      |   16 +-
 drivers/serial/uartlite.c                      |    1 +
 drivers/spi/mpc512x_psc_spi.c                  |    2 +
 drivers/spi/mpc52xx_psc_spi.c                  |   11 +-
 drivers/spi/mpc52xx_spi.c                      |    3 +-
 drivers/spi/spi.c                              |    4 +
 drivers/spi/spi_mpc8xxx.c                      |    4 +-
 drivers/spi/spi_ppc4xx.c                       |    2 +-
 drivers/spi/xilinx_spi.c                       |    3 +
 drivers/spi/xilinx_spi_of.c                    |    4 +-
 drivers/usb/gadget/fsl_qe_udc.c                |    1 +
 drivers/video/bw2.c                            |    4 +-
 drivers/video/cg14.c                           |    4 +-
 drivers/video/cg3.c                            |    4 +-
 drivers/video/cg6.c                            |    4 +-
 drivers/video/controlfb.c                      |    2 +
 drivers/video/ffb.c                            |    4 +-
 drivers/video/leo.c                            |    4 +-
 drivers/video/offb.c                           |    3 +-
 drivers/video/p9100.c                          |    4 +-
 drivers/video/sunxvr1000.c                     |    4 +-
 drivers/video/tcx.c                            |    4 +-
 drivers/watchdog/cpwd.c                        |    6 +-
 drivers/watchdog/riowd.c                       |    4 +-
 include/asm-generic/gpio.h                     |   15 +
 include/linux/of.h                             |   10 +
 include/linux/of_address.h                     |   44 ++
 include/linux/of_device.h                      |   61 ++-
 include/linux/of_gpio.h                        |   35 +-
 include/linux/of_i2c.h                         |   13 +-
 include/linux/of_irq.h                         |   70 ++
 include/linux/of_platform.h                    |   53 +-
 include/linux/of_spi.h                         |   11 +-
 sound/sparc/amd7930.c                          |    6 +-
 sound/sparc/cs4231.c                           |   18 +-
 sound/sparc/dbri.c                             |    6 +-
 190 files changed, 2492 insertions(+), 3864 deletions(-)
 delete mode 100644 arch/microblaze/include/asm/of_device.h
 delete mode 100644 arch/microblaze/include/asm/of_platform.h
 delete mode 100644 arch/microblaze/kernel/of_device.c
 delete mode 100644 arch/microblaze/kernel/of_platform.c
 delete mode 100644 arch/powerpc/include/asm/of_device.h
 delete mode 100644 arch/powerpc/include/asm/of_platform.h
 delete mode 100644 arch/powerpc/kernel/of_device.c
 delete mode 100644 arch/sparc/include/asm/of_device.h
 delete mode 100644 arch/sparc/include/asm/of_platform.h
 create mode 100644 drivers/of/address.c
 create mode 100644 drivers/of/irq.c
 create mode 100644 include/linux/of_address.h
 create mode 100644 include/linux/of_irq.h
