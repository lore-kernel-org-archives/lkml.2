Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab2EVNS4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 09:18:56 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39952 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376Ab2EVNSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 09:18:54 -0400
Date: Tue, 22 May 2012 06:18:51 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] driver core patches for 3.5-rc1
Message-ID: <20120522131851.GA1365@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 69964ea4c7b68c9399f7977aa5b9aa6539a6a98a:

  Linux 3.4-rc5 (2012-04-29 15:19:10 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git/ tags/driver-core-3.5-rc1

for you to fetch changes up to 69964ea4c7b68c9399f7977aa5b9aa6539a6a98a:

  Linux 3.4-rc5 (2012-04-29 15:19:10 -0700)

----------------------------------------------------------------
Driver core pull for 3.5-rc1

Here's the driver core, and other driver subsystems, pull request for
the 3.5-rc1 merge window.

Outside of a few minor driver core changes, we ended up with the
following different subsystem and core changes as well, due to
interdependancies on the driver core:
 - hyperv driver updates
 - drivers/memory being created and some drivers moved into it
 - extcon driver subsystem created out of the old Android staging switch
   driver code
 - dynamic debug updates
 - printk rework, and /dev/kmsg changes

All of this has been tested in the linux-next releases for a few weeks
with no reported problems.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------

 Documentation/ABI/testing/dev-kmsg                 |   90 ++
 Documentation/ABI/testing/sysfs-class-extcon       |   97 ++
 Documentation/HOWTO                                |   32 +-
 Documentation/devices.txt                          |    3 +-
 .../bindings/arm/tegra/nvidia,tegra20-mc.txt       |   16 +
 .../bindings/arm/tegra/nvidia,tegra30-mc.txt       |   18 +
 Documentation/dynamic-debug-howto.txt              |  184 ++-
 Documentation/extcon/porting-android-switch-class  |  124 ++
 Documentation/feature-removal-schedule.txt         |    9 +-
 Documentation/kernel-parameters.txt                |    7 +-
 Documentation/memory-devices/ti-emif.txt           |   57 +
 Documentation/zh_CN/magic-number.txt               |    2 +-
 arch/powerpc/mm/hugetlbpage.c                      |    3 +-
 drivers/Kconfig                                    |    4 +
 drivers/Makefile                                   |    2 +
 drivers/acpi/pci_link.c                            |   12 +-
 drivers/acpi/sleep.c                               |    8 +-
 drivers/base/bus.c                                 |    3 +-
 drivers/base/core.c                                |   58 +-
 drivers/base/devres.c                              |   35 +
 drivers/base/devtmpfs.c                            |    6 +-
 drivers/base/dma-buf.c                             |   12 +-
 drivers/base/driver.c                              |    2 +-
 drivers/char/mem.c                                 |   42 +-
 drivers/extcon/Kconfig                             |   32 +
 drivers/extcon/Makefile                            |    7 +
 .../max8997-muic.c => extcon/extcon-max8997.c}     |  200 ++-
 drivers/extcon/extcon_class.c                      |  832 ++++++++++
 drivers/extcon/extcon_gpio.c                       |  169 ++
 drivers/gpio/devres.c                              |    3 +-
 drivers/hv/channel_mgmt.c                          |   73 +-
 drivers/hv/hv.c                                    |    2 +-
 drivers/hv/hv_kvp.c                                |    3 +-
 drivers/hv/hv_util.c                               |    9 +-
 drivers/hv/hyperv_vmbus.h                          |    2 +-
 drivers/memory/Kconfig                             |   43 +
 drivers/memory/Makefile                            |    7 +
 drivers/memory/emif.c                              | 1670 ++++++++++++++++++++
 drivers/memory/emif.h                              |  589 +++++++
 drivers/memory/tegra20-mc.c                        |  257 +++
 drivers/memory/tegra30-mc.c                        |  382 +++++
 drivers/misc/Kconfig                               |    8 -
 drivers/misc/Makefile                              |    1 -
 drivers/parport/parport_pc.c                       |   16 +-
 drivers/staging/android/Kconfig                    |    3 -
 drivers/staging/android/Makefile                   |    1 -
 drivers/staging/android/switch/Kconfig             |   11 -
 drivers/staging/android/switch/Makefile            |    4 -
 drivers/staging/android/switch/switch.h            |   53 -
 drivers/staging/android/switch/switch_class.c      |  174 --
 drivers/staging/android/switch/switch_gpio.c       |  172 --
 drivers/uio/uio_pdrv_genirq.c                      |    8 +
 drivers/usb/core/sysfs.c                           |    6 +-
 drivers/w1/slaves/w1_ds2408.c                      |    2 -
 drivers/w1/w1.c                                    |    2 +-
 drivers/w1/w1_io.c                                 |   22 +-
 fs/sysfs/dir.c                                     |   37 +-
 include/linux/device.h                             |   34 +-
 include/linux/dynamic_debug.h                      |   22 +-
 include/linux/extcon.h                             |  324 ++++
 include/linux/extcon/extcon_gpio.h                 |   52 +
 include/linux/hyperv.h                             |    4 +-
 include/linux/mfd/max8997.h                        |   23 -
 include/linux/moduleparam.h                        |    3 +-
 include/linux/platform_data/emif_plat.h            |  128 ++
 include/linux/printk.h                             |   13 +
 include/linux/sysfs.h                              |   12 +
 include/memory/jedec_ddr.h                         |  175 ++
 init/main.c                                        |   33 +-
 kernel/module.c                                    |    2 +-
 kernel/params.c                                    |   62 +-
 kernel/printk.c                                    | 1390 +++++++++++-----
 lib/Kconfig                                        |    8 +
 lib/Kconfig.debug                                  |   33 +-
 lib/Makefile                                       |    2 +
 lib/dynamic_debug.c                                |  190 ++-
 lib/jedec_ddr_data.c                               |  135 ++
 lib/kobject.c                                      |   14 +-
 mm/page_alloc.c                                    |    6 +-
 79 files changed, 6981 insertions(+), 1310 deletions(-)
 create mode 100644 Documentation/ABI/testing/dev-kmsg
 create mode 100644 Documentation/ABI/testing/sysfs-class-extcon
 create mode 100644 Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-mc.txt
 create mode 100644 Documentation/devicetree/bindings/arm/tegra/nvidia,tegra30-mc.txt
 create mode 100644 Documentation/extcon/porting-android-switch-class
 create mode 100644 Documentation/memory-devices/ti-emif.txt
 create mode 100644 drivers/extcon/Kconfig
 create mode 100644 drivers/extcon/Makefile
 rename drivers/{misc/max8997-muic.c => extcon/extcon-max8997.c} (75%)
 create mode 100644 drivers/extcon/extcon_class.c
 create mode 100644 drivers/extcon/extcon_gpio.c
 create mode 100644 drivers/memory/Kconfig
 create mode 100644 drivers/memory/Makefile
 create mode 100644 drivers/memory/emif.c
 create mode 100644 drivers/memory/emif.h
 create mode 100644 drivers/memory/tegra20-mc.c
 create mode 100644 drivers/memory/tegra30-mc.c
 delete mode 100644 drivers/staging/android/switch/Kconfig
 delete mode 100644 drivers/staging/android/switch/Makefile
 delete mode 100644 drivers/staging/android/switch/switch.h
 delete mode 100644 drivers/staging/android/switch/switch_class.c
 delete mode 100644 drivers/staging/android/switch/switch_gpio.c
 create mode 100644 include/linux/extcon.h
 create mode 100644 include/linux/extcon/extcon_gpio.h
 create mode 100644 include/linux/platform_data/emif_plat.h
 create mode 100644 include/memory/jedec_ddr.h
 create mode 100644 lib/jedec_ddr_data.c

---------------

Alan Stern (1):
      sysfs: get rid of some lockdep false positives

Aneesh V (7):
      ddr: add LPDDR2 data from JESD209-2
      memory: emif: add register definitions for EMIF
      memory: emif: add basic infrastructure for EMIF driver
      memory: emif: handle frequency and voltage change events
      memory: emif: add interrupt and temperature handling
      memory: emif: add one-time settings
      memory: emif: add debugfs entries for emif

Benedikt Spranger (1):
      uio_pdrv_genirq: get irq through platform resource if not set otherwise

Chanwoo Choi (3):
      Extcon: Notify changed state for only one cable to notifee
      Extcon: add MAX8997 extcon driver
      misc: MAX8997: Remove max8997-muic driver

Dan Carpenter (3):
      hv: fix return type of hv_post_message()
      w1: w1_ds28e04: unlock on error path in w1_f1C_write_pio()
      Extcon: check for allocation failure

Dmitry Artamonow (1):
      w1: fix slave driver registration error message

Donggeun Kim (1):
      Extcon: support notification based on the state changes.

Greg Kroah-Hartman (3):
      Revert "driver core: check start node in klist_iter_init_node"
      Revert "w1: Add 1-wire slave device driver for DS28E04-100"
      Revert "dynamic_debug: remove unneeded includes"

H Hartley Sweeten (3):
      drivers/base/bus.c: local variables should not be exposed globally
      Extcon: fix section mismatch in extcon_gpio.c
      w1: w1_ds2408.c: quite sparse noise about using plaing integer as NULL pointer

Hannes Reinecke (1):
      driver core: check start node in klist_iter_init_node

Hiroshi DOYU (10):
      ARM: tegra20: Add Tegra Memory Controller(MC) driver
      ARM: tegra30: Add Tegra Memory Controller(MC) driver
      ARM: tegra20: MC: Remove unnecessary BUG*()
      ARM: tegra30: MC: Remove unnecessary BUG*()
      ARM: tegra20: Make MC optional in Kconfig
      ARM: tegra30: Make MC optional in Kconfig
      Driver Core: don't oops with unregistered driver in driver_find_device()
      driver core: Add dev_*_ratelimited() family
      memory: tegra{20,30}-mc: Use dev_err_ratelimited()
      memory: tegra{20,30}-mc: Remove empty *_remove()

Jim Cromie (15):
      dynamic_debug: replace if (verbose) pr_info with macro vpr_info
      dynamic_debug: fix leading spaces in dynamic_debug.h
      params: add 3rd arg to option handler callback signature
      dynamic_debug: make dynamic-debug work for module initialization
      dynamic_debug: deprecate ddebug_query, suggest dyndbg instead
      dynamic_debug: combine parse_args callbacks together
      dynamic_debug: simplify dynamic_debug_init error exit
      dynamic_debug: print ram usage by ddebug tables if verbose
      dynamic_debug: add modname arg to exec_query callchain
      dynamic_debug: update Documentation/*, Kconfig.debug
      dynamic_debug: init with early_initcall, not arch_initcall
      dynamic_debug: use printk(KERN_WARNING..) in stub function
      params.c: fix Smack complaint about parse_args
      dynamic_debug: remove unneeded includes
      params: replace printk(KERN_<LVL>...) with pr_<lvl>(...)

K. Y. Srinivasan (2):
      Drivers: hv: Get rid of an unnecessary check in vmbus_prep_negotiate_resp()
      Drivers: hv: util: Properly handle version negotiations.

Kay Sievers (13):
      printk: convert byte-buffer to variable-length record buffer
      kmsg: export printk records to the /dev/kmsg interface
      driver-core: extend dev_printk() to pass structured data
      kmsg: use do_div() to divide 64bit integer
      parport: use KERN_CONT in printk() continuation lines
      acpi: use KERN_CONT in printk() continuation lines
      mm: use KERN_CONT in printk() continuation lines
      kmsg - add Documentation/ABI/testing/dev-kmsg
      printk - fix compilation for CONFIG_PRINTK=n
      printk() - do not merge continuation lines of different threads
      printk() - restore timestamp printing at console output
      printk() - restore prefix/timestamp printing for multi-newline strings
      printk() - isolate KERN_CONT users from ordinary complete lines

Kees Cook (1):
      docs: update HOWTO for 2.6.x -> 3.x versioning

Mark Brown (4):
      extcon: Add EXTCON_MECHANICAL cable type for physical presence
      devres: Clarify documentation for devres_destroy()
      devres: Add devres_release()
      gpiolib: Convert to devres_release()

Markus Franke (2):
      w1: Add 1-wire slave device driver for DS28E04-100
      w1: Disable irqs during 1-wire bus operations, extend 1-wire reset pulse

Michael Davidson (1):
      driver-core: fix DEVICE_INT_ATTR to use correct show/store functions

MyungJoo Ham (6):
      Extcon (external connector): import Android's switch class and modify.
      Extcon: support generic GPIO extcon driver
      Extcon: support multiple states at a device.
      Extcon: support mutually exclusive relation between cables.
      Documentation/extcon: porting guide for Android kernel switch driver.
      Remove "switch" class in drivers/staging/android/switch

Paul Gortmaker (1):
      powerpc: fix compile fail in hugetlb cmdline parsing

Peter Korsgaard (2):
      devtmpfs: fix 'the the' typo
      core.c: fix 'the the' typo

Randy Dunlap (2):
      driver core: fix dma-buf.c kernel-doc warnings
      printk: add stub for prepend_timestamp()

Santosh Shilimkar (1):
      memory: emif: Add Kconfig dependency for TI EMIF controller

Sasikantha babu (1):
      sysfs: Removed dup_name entirely in sysfs_rename

Stephen Warren (1):
      printk: correctly align __log_buf

Zhi Yong Wu (1):
      kobject: fix the uncorrect comment

harryxiyou (1):
      Fix a mistake sentence in the file 'Documentation/zh_CN/magic-number.txt'

yan (2):
      drivers/base/core.c: Fix a typo in comment
      lib/kobject.c : Remove redundant check in create_dir

