Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730Ab2LKUK1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 15:10:27 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:56866 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083Ab2LKUKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 15:10:25 -0500
Date: Tue, 11 Dec 2012 12:10:21 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] char/misc changes for 3.8-rc1
Message-ID: <20121211201021.GA19488@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit f4a75d2eb7b1e2206094b901be09adb31ba63681:

  Linux 3.7-rc6 (2012-11-16 17:42:40 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git/ tags/char-misc-3.8-rc1

for you to fetch changes up to 70e78c40ed6c25bb34d642848e485d79ffc55c26:

  MAINTAINERS: remove drivers/staging/hv/ (2012-11-26 16:19:01 -0800)

----------------------------------------------------------------
Char/Misc driver merge for 3.8-rc1

Here is the "big" char/misc driver patches for 3.8-rc1.  I'm starting to
put random driver subsystems that I had previously sent you through the
driver-core tree in this tree, as it makes more sense to do so.

Nothing major here, the various __dev* removals, some mei driver
updates, and other random driver-specific things from the different
maintainers and developers.

Note, some MFD drivers got added through this tree, and they are also
coming in through the "real" MFD tree as well, due to some major
mis-communication between me and the different developers.  If you have
any merge conflicts, take the ones from the MFD tree, not these ones,
sorry about that.

All of this has been in linux-next for a while.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Axel Lin (1):
      misc: apds9802als: Fix the logic checking timeout in als_wait_for_data_ready()

Bill Pemberton (22):
      w1: remove use of __devexit_p
      w1: remove use of __devinit
      w1: remove use of __devexit
      w1: remove CONFIG_HOTPLUG ifdefs
      mei: remove use of __devexit_p
      drivers/misc: remove use of __devexit_p
      misc: remove use of __devinit
      misc: remove use of __devinitdata
      misc: remove use of __devinitconst
      misc: remove use of __devexit
      char: remove use of __devexit_p
      char: remove use of __devinit
      char: remove use of __devinitdata
      char: remove use of __devinitconst
      char: remove use of __devexit
      uio: remove use of __devexit_p
      uio: remove use of __devinit
      uio: remove use of __devinitdata
      uio: remove use of __devexit
      extcon: remove use of __devexit
      extcon: remove use of __devinit
      extcon: remove use of __devexit_p

Cesar Eduardo Barros (1):
      MAINTAINERS: remove drivers/staging/hv/

Chen Gang (1):
      drivers/char: for hpet, add count checking, and ~0UL instead of -1

Cyril Chemparathy (1):
      /dev/mem: use phys_addr_t for physical addresses

Damian Hobson-Garcia (6):
      Add new uio device for dynamic memory allocation
      Add uio_dmem_genirq description to UIO documentation
      drivers: uio_dmem_genirq: Don't mix address spaces for dynamic region vaddr
      drivers: uio_dmem_genirq: Don't use DMA_ERROR_CODE to indicate unmapped regions
      drivers: uio_dmem_genirq: Allow partial success when opening device
      drivers: uio: Only allocate new private data when probing device tree node

Fabio Estevam (3):
      w1: mxc_w1: Adapt the clock name to the new clock framework
      w1: mxc_w1: Convert to platform driver
      w1: mxc_w1: Fix comment

Greg Kroah-Hartman (4):
      Merge 3.7-rc3 into char-misc-next
      drivers: mfd: fix dependencies for MFD_RTSX_PCI
      Merge 3.7-rc6 into char-misc-next
      hv: hv_balloon: mark a function static

K. Y. Srinivasan (5):
      Drivers: hv: Get rid of unnecessary forward declarations
      tools: hv: Return the full kernel version
      Tools: hv: Don't return loopback addresses
      mm: export a function to get vm committed memory
      Drivers: hv: Add Hyper-V balloon driver

Kees Cook (2):
      drivers/w1/masters: remove CONFIG_EXPERIMENTAL
      drivers/parport: remove depends on CONFIG_EXPERIMENTAL

Manuel Traut (1):
      uio_pdrv: set memory mapping name

Mark Rusk (1):
      misc: hpilo: ignore auxiliary HP iLO BMC's

Matthias Kaehlcke (1):
      misc/st_kim: Free resources in the error path of probe()

Pantelis Antoniou (2):
      w1-gpio: Pinctrl-fy
      w1-gpio: Simplify & get rid of defines

Samuel Ortiz (1):
      mei: Simplify the ME client enumeration code

Tomas Hozza (2):
      tools: hv: Netlink source address validation allows DoS
      tools/hv: Fix string types

Tomas Winkler (25):
      mei: rename mei_cl_cb.information to mei_cl_cb.buf_idx
      mei: add allocation and initialization wrappers for io callback
      mei: mei_write: revamp error path handling
      mei: kill usless struct mei_io_list
      mei: rename mei_free_cb_private to mei_io_cb_free
      mei: use mei_io_cb_ warppers also for control flows
      mei: mei_write: revamp function flow
      mei: normalize timeouts definitions
      mei: extract AMTHI functions into the amthif.c file
      mei: mei_clear_list: kill file_temp
      mei: use internal watchdog device registration tracking
      mei: move amthif specific code from mei_write to mei_amthif_write
      mei: amthif: prefix cb list with amthif
      mei: use type struct mei_cl *cl instead of void in struct mei_cb
      mei: rename enum mei_cb_major_types to enum mei_cb_file_ops
      mei: move amthif specific release code to amithif
      mei: extract amthif specific code from mei_poll to mei_amthif_poll
      mei: use link and unlink terms for connecting ME and HOST client
      mei: use the same bus msg for connect and disconnect request
      mei: compact code for mei bus message creation
      mei: use structured buffer for extra write buffer
      mei: streamline write complete flow function
      mei: streamline amthif write complete function
      mei: don't mix read and write slots
      mei: simplify write complete loop in irq handler

Wei WANG (3):
      drivers/mfd: Add realtek pcie card reader driver
      drivers/mmc: Add realtek pcie sdmmc host driver
      drivers/memstick: Add realtek pcie memstick host driver

Wei Yongjun (4):
      Drivers: hv: remove unused variable from channel_mgmt.c
      pc8736x_gpio: use platform_device_unregister in pc8736x_gpio_cleanup()
      drivers:misc: ti-st: fix potential NULL pointer dereference in st_register()
      w1/ds2482: use module_i2c_driver to simplify the code

 Documentation/DocBook/uio-howto.tmpl          |   56 ++++
 MAINTAINERS                                   |    1 -
 arch/arm/include/asm/io.h                     |    2 +-
 arch/arm/mm/mmap.c                            |    2 +-
 arch/ia64/include/asm/io.h                    |    2 +-
 arch/ia64/kernel/efi.c                        |    2 +-
 arch/sh/include/asm/io.h                      |    2 +-
 arch/sh/mm/mmap.c                             |    2 +-
 drivers/char/agp/ali-agp.c                    |    4 +-
 drivers/char/agp/amd-k7-agp.c                 |    4 +-
 drivers/char/agp/amd64-agp.c                  |    2 +-
 drivers/char/agp/ati-agp.c                    |    4 +-
 drivers/char/agp/efficeon-agp.c               |    2 +-
 drivers/char/agp/i460-agp.c                   |    2 +-
 drivers/char/agp/intel-agp.c                  |    2 +-
 drivers/char/agp/nvidia-agp.c                 |    2 +-
 drivers/char/agp/sgi-agp.c                    |    2 +-
 drivers/char/agp/sis-agp.c                    |    8 +-
 drivers/char/agp/sworks-agp.c                 |    2 +-
 drivers/char/agp/uninorth-agp.c               |    4 +-
 drivers/char/agp/via-agp.c                    |    4 +-
 drivers/char/hpet.c                           |    5 +-
 drivers/char/hw_random/atmel-rng.c            |    2 +-
 drivers/char/hw_random/bcm63xx-rng.c          |    2 +-
 drivers/char/hw_random/exynos-rng.c           |    2 +-
 drivers/char/hw_random/n2-drv.c               |    4 +-
 drivers/char/hw_random/pasemi-rng.c           |    2 +-
 drivers/char/hw_random/picoxcell-rng.c        |    2 +-
 drivers/char/hw_random/ppc4xx-rng.c           |    2 +-
 drivers/char/hw_random/timeriomem-rng.c       |    2 +-
 drivers/char/hw_random/virtio-rng.c           |    2 +-
 drivers/char/ipmi/ipmi_si_intf.c              |   32 +--
 drivers/char/mbcs.c                           |    2 +-
 drivers/char/mem.c                            |   10 +-
 drivers/char/pc8736x_gpio.c                   |    3 +-
 drivers/char/ps3flash.c                       |    2 +-
 drivers/char/sonypi.c                         |   14 +-
 drivers/char/tb0219.c                         |    6 +-
 drivers/char/tpm/tpm_i2c_infineon.c           |    2 +-
 drivers/char/tpm/tpm_ibmvtpm.c                |    4 +-
 drivers/char/tpm/tpm_infineon.c               |    2 +-
 drivers/char/tpm/tpm_tis.c                    |    4 +-
 drivers/char/virtio_console.c                 |    2 +-
 drivers/char/xilinx_hwicap/xilinx_hwicap.c    |   14 +-
 drivers/extcon/extcon-adc-jack.c              |    6 +-
 drivers/extcon/extcon-arizona.c               |    6 +-
 drivers/extcon/extcon-gpio.c                  |    6 +-
 drivers/extcon/extcon-max77693.c              |    6 +-
 drivers/extcon/extcon-max8997.c               |    6 +-
 drivers/hv/Kconfig                            |    6 +
 drivers/hv/Makefile                           |    1 +
 drivers/hv/channel.c                          |    8 -
 drivers/hv/channel_mgmt.c                     |    8 -
 drivers/hv/hv_balloon.c                       | 1041 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/memstick/host/Kconfig                 |   10 +
 drivers/memstick/host/Makefile                |    1 +
 drivers/memstick/host/rtsx_pci_ms.c           |  641 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/mfd/Kconfig                           |   10 +
 drivers/mfd/Makefile                          |    3 +
 drivers/mfd/rtl8411.c                         |  251 ++++++++++++++++++
 drivers/mfd/rts5209.c                         |  223 ++++++++++++++++
 drivers/mfd/rts5229.c                         |  205 +++++++++++++++
 drivers/mfd/rtsx_pcr.c                        | 1251 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/mfd/rtsx_pcr.h                        |   32 +++
 drivers/misc/ad525x_dpot-i2c.c                |    6 +-
 drivers/misc/ad525x_dpot-spi.c                |    6 +-
 drivers/misc/ad525x_dpot.c                    |    4 +-
 drivers/misc/apds9802als.c                    |    6 +-
 drivers/misc/apds990x.c                       |    6 +-
 drivers/misc/atmel-ssc.c                      |    4 +-
 drivers/misc/bh1770glc.c                      |    6 +-
 drivers/misc/bh1780gli.c                      |    6 +-
 drivers/misc/bmp085-i2c.c                     |    4 +-
 drivers/misc/bmp085-spi.c                     |    4 +-
 drivers/misc/bmp085.c                         |    2 +-
 drivers/misc/cb710/core.c                     |   10 +-
 drivers/misc/cs5535-mfgpt.c                   |    6 +-
 drivers/misc/eeprom/at24.c                    |    4 +-
 drivers/misc/eeprom/at25.c                    |    4 +-
 drivers/misc/eeprom/eeprom_93xx46.c           |    6 +-
 drivers/misc/fsa9480.c                        |    6 +-
 drivers/misc/hpilo.c                          |   21 +-
 drivers/misc/ibmasm/module.c                  |    6 +-
 drivers/misc/ioc4.c                           |   10 +-
 drivers/misc/isl29003.c                       |    6 +-
 drivers/misc/lis3lv02d/lis3lv02d_i2c.c        |    6 +-
 drivers/misc/lis3lv02d/lis3lv02d_spi.c        |    6 +-
 drivers/misc/mei/Makefile                     |    1 +
 drivers/misc/mei/amthif.c                     |  722 +++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/misc/mei/hw.h                         |   36 ++-
 drivers/misc/mei/init.c                       |  368 +++++++++++---------------
 drivers/misc/mei/interface.c                  |   91 +++----
 drivers/misc/mei/interrupt.c                  |  760 ++++++++++++++++-------------------------------------
 drivers/misc/mei/iorw.c                       |  455 +++++++++-----------------------
 drivers/misc/mei/main.c                       |  462 +++++++++++----------------------
 drivers/misc/mei/mei_dev.h                    |  155 ++++++++---
 drivers/misc/mei/wd.c                         |   15 +-
 drivers/misc/pch_phub.c                       |    6 +-
 drivers/misc/phantom.c                        |   10 +-
 drivers/misc/pti.c                            |    8 +-
 drivers/misc/spear13xx_pcie_gadget.c          |    4 +-
 drivers/misc/ti-st/st_core.c                  |    1 -
 drivers/misc/ti-st/st_kim.c                   |   30 ++-
 drivers/misc/ti_dac7512.c                     |    6 +-
 drivers/misc/tsl2550.c                        |    6 +-
 drivers/mmc/host/Kconfig                      |    7 +
 drivers/mmc/host/Makefile                     |    2 +
 drivers/mmc/host/rtsx_pci_sdmmc.c             | 1348 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/parport/Kconfig                       |   16 +-
 drivers/uio/Kconfig                           |   16 ++
 drivers/uio/Makefile                          |    1 +
 drivers/uio/uio_aec.c                         |    2 +-
 drivers/uio/uio_cif.c                         |    4 +-
 drivers/uio/uio_dmem_genirq.c                 |  359 ++++++++++++++++++++++++++
 drivers/uio/uio_netx.c                        |    2 +-
 drivers/uio/uio_pci_generic.c                 |    2 +-
 drivers/uio/uio_pdrv.c                        |    1 +
 drivers/uio/uio_pdrv_genirq.c                 |    3 +-
 drivers/uio/uio_pruss.c                       |    6 +-
 drivers/uio/uio_sercos3.c                     |    4 +-
 drivers/w1/masters/Kconfig                    |    2 +-
 drivers/w1/masters/ds2482.c                   |   13 +-
 drivers/w1/masters/matrox_w1.c                |   10 +-
 drivers/w1/masters/mxc_w1.c                   |   28 +-
 drivers/w1/masters/omap_hdq.c                 |   10 +-
 drivers/w1/masters/w1-gpio.c                  |   65 ++---
 drivers/w1/w1.c                               |    7 -
 drivers/xen/xen-selfballoon.c                 |    2 +-
 include/linux/mfd/rtsx_common.h               |   48 ++++
 include/linux/mfd/rtsx_pci.h                  |  794 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mman.h                          |    2 +
 include/linux/platform_data/uio_dmem_genirq.h |   26 ++
 mm/mmap.c                                     |   14 +
 mm/nommu.c                                    |   15 ++
 tools/hv/hv_kvp_daemon.c                      |   40 ++-
 135 files changed, 8217 insertions(+), 1867 deletions(-)
 create mode 100644 drivers/hv/hv_balloon.c
 create mode 100644 drivers/memstick/host/rtsx_pci_ms.c
 create mode 100644 drivers/mfd/rtl8411.c
 create mode 100644 drivers/mfd/rts5209.c
 create mode 100644 drivers/mfd/rts5229.c
 create mode 100644 drivers/mfd/rtsx_pcr.c
 create mode 100644 drivers/mfd/rtsx_pcr.h
 create mode 100644 drivers/misc/mei/amthif.c
 create mode 100644 drivers/mmc/host/rtsx_pci_sdmmc.c
 create mode 100644 drivers/uio/uio_dmem_genirq.c
 create mode 100644 include/linux/mfd/rtsx_common.h
 create mode 100644 include/linux/mfd/rtsx_pci.h
 create mode 100644 include/linux/platform_data/uio_dmem_genirq.h
