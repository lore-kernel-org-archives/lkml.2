Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab2LKUKF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 15:10:05 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:56866 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083Ab2LKUKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 15:10:02 -0500
Date: Tue, 11 Dec 2012 12:09:57 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] Driver core patches for 3.8-rc1
Message-ID: <20121211200957.GA19456@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 77b67063bb6bce6d475e910d3b886a606d0d91f7:

  Linux 3.7-rc5 (2012-11-11 13:44:33 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git/ tags/driver-core-3.8-rc1

for you to fetch changes up to 92e9e6d1f9844b73a26215025a922e7d7aeae361:

  modpost.c: Stop checking __dev* section mismatches (2012-11-30 12:08:42 -0800)

----------------------------------------------------------------
Driver core updates for 3.8-rc1

Here's the large driver core updates for 3.8-rc1.

The biggest thing here is the various __dev* marking removals.  This is
going to be a pain for the merge with different subsystem trees, I know,
but all of the patches included here have been ACKed by their various
subsystem maintainers, as they wanted them to go through here.

If this is too much of a pain, I can pull all of them out of this tree
and just send you one with the other fixes/updates and then, after
3.8-rc1 is out, do the rest of the removals to ensure we catch them all,
it's up to you.  The merges should all be trivial, and Stephen has been
doing them all in linux-next for a few weeks now quite easily.

Other than the __dev* marking removals, there's nothing major here, some
firmware loading updates and other minor things in the driver core.

All of these have (much to Stephen's annoyance), been in linux-next for
a while.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Bill Pemberton (75):
      pnpbios: remove CONFIG_HOTPLUG ifdefs
      driver core: remove CONFIG_HOTPLUG ifdefs
      kobject: remove CONFIG_HOTPLUG ifdefs
      sysctl: remove CONFIG_HOTPLUG ifdefs
      kernel/ksysfs.c: remove CONFIG_HOTPLUG ifdefs
      lib: kobject_uevent is no longer dependant on CONFIG_HOTPLUG
      tpm: remove use of __devinit
      tpm_infineon: remove use of __devexit_p
      clk: remove use of __devexit_p
      clk: remove use of __devinit
      clk: remove use of __devexit
      gpio: remove use of __devexit_p
      gpio: remove use of __devinit
      gpio: remove use of __devinitdata
      gpio: remove use of __devinitconst
      gpio: remove use of __devexit
      hwspinlock: remove use of __devexit_p
      hwspinlock: remove use of __devinit
      hwspinlock: remove use of __devexit
      power: remove use of __devexit_p
      power: remove use of __devinit
      power: remove use of __devexit
      hwmon: remove use of __devexit_p
      hwmon: remove use of __devinit
      hwmon: remove use of __devinitdata
      hwmon: remove use of __devexit
      pinctrl: remove use of __devexit_p
      pinctrl: remove use of __devinitdata
      pinctrl: remove use of __devinitconst
      pinctrl: remove use of __devexit
      watchdog: remove use of __devexit_p
      watchdog: remove use of __devinit
      watchdog: remove use of __devinitdata
      watchdog: remove use of __devexit
      backlight: remove use of __devexit_p
      backlight: remove use of __devinit
      backlight: remove use of __devexit
      pcmcia: remove CONFIG_HOTPLUG ifdefs
      pcmcia: remove use of __devexit_p
      pcmcia: remove use of __devinit
      pcmcia: remove use of __devinitdata
      pcmcia: remove use of __devexit
      rapidio: remove use of __devinit
      ptp: remove use of __devinit
      ptp: remove use of __devexit
      mfd: remove use of __devexit_p
      mfd: remove use of __devinit
      mfd: remove use of __devinitdata
      mfd: remove use of __devinitconst
      mfd: remove use of __devexit
      pwm: remove use of __devexit_p
      pwm: remove use of __devinit
      pwm: remove use of __devexit
      mmc: remove use of __devexit_p
      mmc: remove use of __devinit
      mmc: remove use of __devinitdata
      mmc: remove use of __devinitconst
      mmc: remove use of __devexit
      leds: remove use of __devexit_p
      leds: remove use of __devinit
      leds: remove use of __devexit
      firewire: remove use of __devinit
      firewire: remove use of __devinitdata
      dma: remove use of __devexit_p
      dma: remove use of __devinit
      microblaze/PCI: Remove CONFIG_HOTPLUG ifdefs
      mips/PCI: Remove CONFIG_HOTPLUG ifdefs
      powerpc/PCI: Remove CONFIG_HOTPLUG ifdefs
      sh/PCI: Remove CONFIG_HOTPLUG ifdefs
      unicore32/PCI: Remove CONFIG_HOTPLUG ifdefs
      PCI: Remove CONFIG_HOTPLUG ifdefs
      PCI: Move pci_uevent into pci-driver.c
      PCI: Always build setup-bus when PCI is enabled
      PCI: Remove __dev* markings
      acpi: remove use of __devinit

Cesar Eduardo Barros (1):
      firmware: use noinline_for_stack

Chuansheng Liu (2):
      firmware loader: Fix the race FW_STATUS_DONE is followed by class_timeout
      firmware loader: Fix the concurrent request_firmware() race for kref_get/put

Fu Wei (2):
      Documentation: Chinese translation of Documentation/arm/kernel_user_helpers.txt
      Documentation:Update Documentation/zh_CN/arm64/memory.txt

Greg Kroah-Hartman (4):
      Merge 3.7-rc3 into driver-core-next
      Merge 3.7-rc5 into driver-core-next
      init.h: Remove __dev* sections from the kernel
      modpost.c: Stop checking __dev* section mismatches

Joe Perches (1):
      drivers: base: Convert dev_printk(KERN_<LEVEL> to dev_<level>(

Josh Triplett (2):
      drivers/base/core.c: Mark to_root_device static
      sysfs: Mark sysfs_attr_ns static

Kees Cook (1):
      drivers/base: remove CONFIG_EXPERIMENTAL

Ming Lei (2):
      firmware loader: introduce module parameter to customize(v4) fw search path
      firmware loader: document firmware cache mechanism

Sebastian Andrzej Siewior (1):
      drivers/base: fix typo in comment for arch_setup_pdev_archdata()

ShuoX Liu (1):
      driver core: use initcall_debug to control shutdown info

Tekkaman Ninja (1):
      Documentation: Fixes a term's translation in Documentation/zh_CN/arm64/memory.txt

Wolfram Sang (1):
      driver: platform: fix documentation for platform_get_irq_byname

Yan Hong (1):
      fs/debugsfs: remove unnecessary inode->i_private initialization

 Documentation/firmware_class/README             |  12 ++++
 Documentation/zh_CN/arm/kernel_user_helpers.txt | 284 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 Documentation/zh_CN/arm64/memory.txt            |  14 ++---
 arch/microblaze/pci/pci-common.c                |   4 --
 arch/mips/pci/pci.c                             |   2 -
 arch/powerpc/kernel/pci-common.c                |   4 --
 arch/powerpc/kernel/pci_64.c                    |   4 --
 arch/sh/drivers/pci/pci.c                       |   2 -
 arch/unicore32/kernel/pci.c                     |   2 -
 drivers/acpi/apei/ghes.c                        |   2 +-
 drivers/acpi/hed.c                              |   2 +-
 drivers/acpi/pci_root.c                         |   2 +-
 drivers/base/Kconfig                            |   7 +--
 drivers/base/attribute_container.c              |   2 +-
 drivers/base/bus.c                              |  14 -----
 drivers/base/core.c                             |   8 ++-
 drivers/base/devres.c                           |   4 +-
 drivers/base/firmware_class.c                   |  52 ++++++++++++++----
 drivers/base/platform.c                         |   4 +-
 drivers/char/tpm/tpm_i2c_infineon.c             |   4 +-
 drivers/char/tpm/tpm_ibmvtpm.c                  |   2 +-
 drivers/char/tpm/tpm_infineon.c                 |   4 +-
 drivers/char/tpm/tpm_tis.c                      |   2 +-
 drivers/clk/clk-max77686.c                      |   6 +-
 drivers/clk/clk-wm831x.c                        |   6 +-
 drivers/dma/dw_dmac.c                           |   4 +-
 drivers/dma/edma.c                              |   4 +-
 drivers/dma/fsldma.c                            |   4 +-
 drivers/dma/intel_mid_dma.c                     |   4 +-
 drivers/dma/ioat/pci.c                          |   2 +-
 drivers/dma/iop-adma.c                          |  10 ++--
 drivers/dma/mmp_pdma.c                          |   6 +-
 drivers/dma/mmp_tdma.c                          |   6 +-
 drivers/dma/mpc512x_dma.c                       |   4 +-
 drivers/dma/mv_xor.c                            |   8 +--
 drivers/dma/pch_dma.c                           |   4 +-
 drivers/dma/pl330.c                             |   2 +-
 drivers/dma/ppc4xx/adma.c                       |   4 +-
 drivers/dma/sa11x0-dma.c                        |   6 +-
 drivers/dma/sh/shdma.c                          |   6 +-
 drivers/dma/sirf-dma.c                          |   4 +-
 drivers/dma/tegra20-apb-dma.c                   |   4 +-
 drivers/dma/timb_dma.c                          |   2 +-
 drivers/firewire/nosy.c                         |   4 +-
 drivers/firewire/ohci.c                         |   2 +-
 drivers/gpio/gpio-74x164.c                      |   6 +-
 drivers/gpio/gpio-ab8500.c                      |   6 +-
 drivers/gpio/gpio-adnp.c                        |  10 ++--
 drivers/gpio/gpio-adp5520.c                     |   6 +-
 drivers/gpio/gpio-adp5588.c                     |   6 +-
 drivers/gpio/gpio-arizona.c                     |   6 +-
 drivers/gpio/gpio-cs5535.c                      |   6 +-
 drivers/gpio/gpio-da9052.c                      |   8 +--
 drivers/gpio/gpio-em.c                          |   6 +-
 drivers/gpio/gpio-ep93xx.c                      |   2 +-
 drivers/gpio/gpio-generic.c                     |   6 +-
 drivers/gpio/gpio-ich.c                         |  10 ++--
 drivers/gpio/gpio-janz-ttl.c                    |  10 ++--
 drivers/gpio/gpio-langwell.c                    |   8 +--
 drivers/gpio/gpio-lpc32xx.c                     |   4 +-
 drivers/gpio/gpio-max7300.c                     |   6 +-
 drivers/gpio/gpio-max7301.c                     |   6 +-
 drivers/gpio/gpio-max730x.c                     |   4 +-
 drivers/gpio/gpio-max732x.c                     |   8 +--
 drivers/gpio/gpio-mc33880.c                     |   6 +-
 drivers/gpio/gpio-mcp23s08.c                    |   6 +-
 drivers/gpio/gpio-ml-ioh.c                      |   8 +--
 drivers/gpio/gpio-mpc5200.c                     |   4 +-
 drivers/gpio/gpio-msic.c                        |   2 +-
 drivers/gpio/gpio-msm-v2.c                      |   6 +-
 drivers/gpio/gpio-mvebu.c                       |   4 +-
 drivers/gpio/gpio-mxc.c                         |   4 +-
 drivers/gpio/gpio-mxs.c                         |   2 +-
 drivers/gpio/gpio-omap.c                        |   6 +-
 drivers/gpio/gpio-pca953x.c                     |   6 +-
 drivers/gpio/gpio-pch.c                         |   8 +--
 drivers/gpio/gpio-pxa.c                         |   6 +-
 drivers/gpio/gpio-rc5t583.c                     |   6 +-
 drivers/gpio/gpio-rdc321x.c                     |   6 +-
 drivers/gpio/gpio-sch.c                         |   6 +-
 drivers/gpio/gpio-sodaville.c                   |   4 +-
 drivers/gpio/gpio-sta2x11.c                     |   4 +-
 drivers/gpio/gpio-stmpe.c                       |   8 +--
 drivers/gpio/gpio-stp-xway.c                    |   2 +-
 drivers/gpio/gpio-sx150x.c                      |   6 +-
 drivers/gpio/gpio-tc3589x.c                     |   6 +-
 drivers/gpio/gpio-tegra.c                       |   4 +-
 drivers/gpio/gpio-timberdale.c                  |   4 +-
 drivers/gpio/gpio-tps6586x.c                    |   6 +-
 drivers/gpio/gpio-tps65910.c                    |   6 +-
 drivers/gpio/gpio-tps65912.c                    |   6 +-
 drivers/gpio/gpio-twl4030.c                     |   8 +--
 drivers/gpio/gpio-twl6040.c                     |   4 +-
 drivers/gpio/gpio-vr41xx.c                      |   6 +-
 drivers/gpio/gpio-vt8500.c                      |   2 +-
 drivers/gpio/gpio-vx855.c                       |   6 +-
 drivers/gpio/gpio-wm831x.c                      |   6 +-
 drivers/gpio/gpio-wm8350.c                      |   6 +-
 drivers/gpio/gpio-wm8994.c                      |   6 +-
 drivers/gpio/gpio-xilinx.c                      |   4 +-
 drivers/hwmon/abituguru.c                       |  12 ++--
 drivers/hwmon/abituguru3.c                      |   6 +-
 drivers/hwmon/ad7314.c                          |   6 +-
 drivers/hwmon/ad7414.c                          |   4 +-
 drivers/hwmon/adcxx.c                           |   6 +-
 drivers/hwmon/ads7871.c                         |   6 +-
 drivers/hwmon/adt7411.c                         |   6 +-
 drivers/hwmon/coretemp.c                        |   8 +--
 drivers/hwmon/da9052-hwmon.c                    |   6 +-
 drivers/hwmon/dme1737.c                         |   6 +-
 drivers/hwmon/f71805f.c                         |   8 +--
 drivers/hwmon/f71882fg.c                        |   8 +--
 drivers/hwmon/fam15h_power.c                    |  10 ++--
 drivers/hwmon/gpio-fan.c                        |   8 +--
 drivers/hwmon/hih6130.c                         |   6 +-
 drivers/hwmon/i5k_amb.c                         |  18 +++---
 drivers/hwmon/it87.c                            |  12 ++--
 drivers/hwmon/jz4740-hwmon.c                    |   6 +-
 drivers/hwmon/k10temp.c                         |   8 +--
 drivers/hwmon/k8temp.c                          |   8 +--
 drivers/hwmon/lm70.c                            |   6 +-
 drivers/hwmon/lm78.c                            |   6 +-
 drivers/hwmon/max1111.c                         |   8 +--
 drivers/hwmon/max197.c                          |   6 +-
 drivers/hwmon/mc13783-adc.c                     |   4 +-
 drivers/hwmon/ntc_thermistor.c                  |   6 +-
 drivers/hwmon/pc87360.c                         |   8 +--
 drivers/hwmon/pc87427.c                         |  10 ++--
 drivers/hwmon/s3c-hwmon.c                       |   6 +-
 drivers/hwmon/sch5627.c                         |   4 +-
 drivers/hwmon/sch5636.c                         |   2 +-
 drivers/hwmon/sht15.c                           |   6 +-
 drivers/hwmon/sht21.c                           |   6 +-
 drivers/hwmon/sis5595.c                         |  16 +++---
 drivers/hwmon/smsc47b397.c                      |   6 +-
 drivers/hwmon/tmp102.c                          |   6 +-
 drivers/hwmon/twl4030-madc-hwmon.c              |   4 +-
 drivers/hwmon/ultra45_env.c                     |   6 +-
 drivers/hwmon/via-cputemp.c                     |   6 +-
 drivers/hwmon/via686a.c                         |  14 ++---
 drivers/hwmon/vt1211.c                          |   8 +--
 drivers/hwmon/vt8231.c                          |  12 ++--
 drivers/hwmon/w83627ehf.c                       |  12 ++--
 drivers/hwmon/w83627hf.c                        |  14 ++---
 drivers/hwmon/w83781d.c                         |   6 +-
 drivers/hwmon/wm831x-hwmon.c                    |   6 +-
 drivers/hwmon/wm8350-hwmon.c                    |   6 +-
 drivers/hwspinlock/omap_hwspinlock.c            |   6 +-
 drivers/hwspinlock/u8500_hsem.c                 |   6 +-
 drivers/leds/leds-adp5520.c                     |   8 +--
 drivers/leds/leds-asic3.c                       |   6 +-
 drivers/leds/leds-atmel-pwm.c                   |   2 +-
 drivers/leds/leds-bd2802.c                      |   2 +-
 drivers/leds/leds-blinkm.c                      |   6 +-
 drivers/leds/leds-clevo-mail.c                  |   2 +-
 drivers/leds/leds-cobalt-qube.c                 |   6 +-
 drivers/leds/leds-cobalt-raq.c                  |   6 +-
 drivers/leds/leds-da903x.c                      |   6 +-
 drivers/leds/leds-da9052.c                      |   6 +-
 drivers/leds/leds-gpio.c                        |  12 ++--
 drivers/leds/leds-lm3530.c                      |   6 +-
 drivers/leds/leds-lm3533.c                      |   8 +--
 drivers/leds/leds-lm355x.c                      |   8 +--
 drivers/leds/leds-lm3642.c                      |   8 +--
 drivers/leds/leds-lp3944.c                      |   6 +-
 drivers/leds/leds-lp5521.c                      |   8 +--
 drivers/leds/leds-lp5523.c                      |   4 +-
 drivers/leds/leds-lp8788.c                      |   6 +-
 drivers/leds/leds-lt3593.c                      |   8 +--
 drivers/leds/leds-max8997.c                     |   6 +-
 drivers/leds/leds-mc13783.c                     |  10 ++--
 drivers/leds/leds-netxbig.c                     |  10 ++--
 drivers/leds/leds-ns2.c                         |   8 +--
 drivers/leds/leds-ot200.c                       |   6 +-
 drivers/leds/leds-pca955x.c                     |   6 +-
 drivers/leds/leds-pca9633.c                     |   6 +-
 drivers/leds/leds-pwm.c                         |   4 +-
 drivers/leds/leds-rb532.c                       |   6 +-
 drivers/leds/leds-regulator.c                   |   6 +-
 drivers/leds/leds-renesas-tpu.c                 |   6 +-
 drivers/leds/leds-ss4200.c                      |   4 +-
 drivers/leds/leds-sunfire.c                     |  12 ++--
 drivers/leds/leds-tca6507.c                     |   6 +-
 drivers/mfd/88pm800.c                           |  12 ++--
 drivers/mfd/88pm805.c                           |  10 ++--
 drivers/mfd/88pm80x.c                           |   2 +-
 drivers/mfd/88pm860x-core.c                     | 104 +++++++++++++++++------------------
 drivers/mfd/ab3100-core.c                       |  13 ++---
 drivers/mfd/ab8500-core.c                       |  40 +++++++-------
 drivers/mfd/ab8500-debugfs.c                    |   6 +-
 drivers/mfd/ab8500-gpadc.c                      |   6 +-
 drivers/mfd/ab8500-sysctrl.c                    |   6 +-
 drivers/mfd/adp5520.c                           |   6 +-
 drivers/mfd/arizona-core.c                      |   4 +-
 drivers/mfd/arizona-i2c.c                       |   6 +-
 drivers/mfd/arizona-spi.c                       |   6 +-
 drivers/mfd/asic3.c                             |   4 +-
 drivers/mfd/cs5535-mfd.c                        |  12 ++--
 drivers/mfd/da903x.c                            |  10 ++--
 drivers/mfd/da9052-core.c                       |   4 +-
 drivers/mfd/da9052-i2c.c                        |   6 +-
 drivers/mfd/da9052-spi.c                        |   6 +-
 drivers/mfd/da9055-core.c                       |   4 +-
 drivers/mfd/da9055-i2c.c                        |   6 +-
 drivers/mfd/davinci_voicecodec.c                |   4 +-
 drivers/mfd/db8500-prcmu.c                      |   2 +-
 drivers/mfd/ezx-pcap.c                          |   8 +--
 drivers/mfd/htc-i2cpld.c                        |  12 ++--
 drivers/mfd/intel_msic.c                        |  10 ++--
 drivers/mfd/janz-cmodio.c                       |  10 ++--
 drivers/mfd/jz4740-adc.c                        |   6 +-
 drivers/mfd/lm3533-core.c                       |  18 +++---
 drivers/mfd/lp8788.c                            |   4 +-
 drivers/mfd/lpc_ich.c                           |  20 +++----
 drivers/mfd/lpc_sch.c                           |   6 +-
 drivers/mfd/max77686.c                          |   2 +-
 drivers/mfd/max8907.c                           |   4 +-
 drivers/mfd/max8925-core.c                      |  58 +++++++++----------
 drivers/mfd/max8925-i2c.c                       |   6 +-
 drivers/mfd/mc13xxx-i2c.c                       |   4 +-
 drivers/mfd/mc13xxx-spi.c                       |   4 +-
 drivers/mfd/omap-usb-host.c                     |   4 +-
 drivers/mfd/omap-usb-tll.c                      |   6 +-
 drivers/mfd/palmas.c                            |   6 +-
 drivers/mfd/pcf50633-adc.c                      |   6 +-
 drivers/mfd/pcf50633-core.c                     |   6 +-
 drivers/mfd/pm8921-core.c                       |   8 +--
 drivers/mfd/pm8xxx-irq.c                        |   4 +-
 drivers/mfd/rc5t583.c                           |   6 +-
 drivers/mfd/rdc321x-southbridge.c               |   6 +-
 drivers/mfd/sm501.c                             |  16 +++---
 drivers/mfd/sta2x11-mfd.c                       |  20 +++----
 drivers/mfd/stmpe-i2c.c                         |   6 +-
 drivers/mfd/stmpe-spi.c                         |   6 +-
 drivers/mfd/syscon.c                            |   6 +-
 drivers/mfd/tc3589x.c                           |   8 +--
 drivers/mfd/tc6387xb.c                          |   6 +-
 drivers/mfd/tc6393xb.c                          |  12 ++--
 drivers/mfd/ti-ssp.c                            |   6 +-
 drivers/mfd/timberdale.c                        |  64 ++++++++++-----------
 drivers/mfd/tps6105x.c                          |   8 +--
 drivers/mfd/tps65090.c                          |   8 +--
 drivers/mfd/tps65217.c                          |   6 +-
 drivers/mfd/tps6586x.c                          |  10 ++--
 drivers/mfd/tps65910.c                          |  10 ++--
 drivers/mfd/tps65911-comparator.c               |   6 +-
 drivers/mfd/tps65912-spi.c                      |   6 +-
 drivers/mfd/twl-core.c                          |   2 +-
 drivers/mfd/twl4030-audio.c                     |   6 +-
 drivers/mfd/twl4030-madc.c                      |   4 +-
 drivers/mfd/twl4030-power.c                     |  20 +++----
 drivers/mfd/vx855.c                             |   6 +-
 drivers/mfd/wl1273-core.c                       |   4 +-
 drivers/mfd/wm831x-spi.c                        |   6 +-
 drivers/mfd/wm8994-core.c                       |  16 +++---
 drivers/mmc/host/atmel-mci.c                    |   2 +-
 drivers/mmc/host/au1xmmc.c                      |   4 +-
 drivers/mmc/host/bfin_sdh.c                     |   6 +-
 drivers/mmc/host/cb710-mmc.c                    |   6 +-
 drivers/mmc/host/dw_mmc-pci.c                   |   4 +-
 drivers/mmc/host/dw_mmc-pltfm.c                 |   4 +-
 drivers/mmc/host/dw_mmc-pltfm.h                 |   2 +-
 drivers/mmc/host/jz4740_mmc.c                   |  12 ++--
 drivers/mmc/host/mmc_spi.c                      |   6 +-
 drivers/mmc/host/mmci.c                         |  10 ++--
 drivers/mmc/host/omap.c                         |   8 +--
 drivers/mmc/host/omap_hsmmc.c                   |   6 +-
 drivers/mmc/host/pxamci.c                       |   4 +-
 drivers/mmc/host/s3cmci.c                       |   6 +-
 drivers/mmc/host/sdhci-cns3xxx.c                |   6 +-
 drivers/mmc/host/sdhci-dove.c                   |   8 +--
 drivers/mmc/host/sdhci-esdhc-imx.c              |   8 +--
 drivers/mmc/host/sdhci-of-esdhc.c               |   6 +-
 drivers/mmc/host/sdhci-of-hlwd.c                |   6 +-
 drivers/mmc/host/sdhci-pci.c                    |  14 ++---
 drivers/mmc/host/sdhci-pxav2.c                  |   6 +-
 drivers/mmc/host/sdhci-pxav3.c                  |   6 +-
 drivers/mmc/host/sdhci-s3c.c                    |  10 ++--
 drivers/mmc/host/sdhci-spear.c                  |  12 ++--
 drivers/mmc/host/sdhci-tegra.c                  |  10 ++--
 drivers/mmc/host/sh_mmcif.c                     |   4 +-
 drivers/mmc/host/sh_mobile_sdhi.c               |   4 +-
 drivers/mmc/host/tmio_mmc.c                     |   6 +-
 drivers/mmc/host/tmio_mmc_pio.c                 |   2 +-
 drivers/mmc/host/via-sdmmc.c                    |   6 +-
 drivers/mmc/host/wbsd.c                         |  28 +++++-----
 drivers/pci/Makefile                            |   7 +--
 drivers/pci/hotplug.c                           |  37 -------------
 drivers/pci/hotplug/cpcihp_zt5550.c             |   4 +-
 drivers/pci/ioapic.c                            |   6 +-
 drivers/pci/pci-driver.c                        |  42 ++++++++++----
 drivers/pci/pci-sysfs.c                         |   7 ---
 drivers/pci/pci.c                               |   4 +-
 drivers/pci/pci.h                               |   5 --
 drivers/pci/pcie/aer/aerdrv.c                   |   4 +-
 drivers/pci/pcie/portdrv_pci.c                  |   2 +-
 drivers/pci/probe.c                             |  20 +++----
 drivers/pci/quirks.c                            | 132 ++++++++++++++++++++++----------------------
 drivers/pci/xen-pcifront.c                      |  10 ++--
 drivers/pcmcia/bcm63xx_pcmcia.c                 |  12 ++--
 drivers/pcmcia/bfin_cf_pcmcia.c                 |   6 +-
 drivers/pcmcia/db1xxx_ss.c                      |   6 +-
 drivers/pcmcia/ds.c                             |  13 +----
 drivers/pcmcia/electra_cf.c                     |   4 +-
 drivers/pcmcia/i82092.c                         |   6 +-
 drivers/pcmcia/pd6729.c                         |   8 +--
 drivers/pcmcia/pxa2xx_sharpsl.c                 |   2 +-
 drivers/pcmcia/rsrc_nonstatic.c                 |   6 +-
 drivers/pcmcia/sa1100_assabet.c                 |   2 +-
 drivers/pcmcia/sa1100_cerf.c                    |   2 +-
 drivers/pcmcia/sa1100_generic.c                 |   4 +-
 drivers/pcmcia/sa1100_h3600.c                   |   2 +-
 drivers/pcmcia/sa1100_shannon.c                 |   2 +-
 drivers/pcmcia/sa1100_simpad.c                  |   2 +-
 drivers/pcmcia/sa1111_generic.c                 |   4 +-
 drivers/pcmcia/sa1111_jornada720.c              |   2 +-
 drivers/pcmcia/vrc4171_card.c                   |   8 +--
 drivers/pcmcia/vrc4173_cardu.c                  |   8 +--
 drivers/pcmcia/xxs1500_ss.c                     |   6 +-
 drivers/pcmcia/yenta_socket.c                   |   6 +-
 drivers/pinctrl/pinctrl-bcm2835.c               |   8 +--
 drivers/pinctrl/pinctrl-imx.c                   |   2 +-
 drivers/pinctrl/pinctrl-imx23.c                 |   4 +-
 drivers/pinctrl/pinctrl-imx28.c                 |   4 +-
 drivers/pinctrl/pinctrl-imx35.c                 |   4 +-
 drivers/pinctrl/pinctrl-imx51.c                 |   4 +-
 drivers/pinctrl/pinctrl-imx53.c                 |   4 +-
 drivers/pinctrl/pinctrl-imx6q.c                 |   4 +-
 drivers/pinctrl/pinctrl-mmp2.c                  |   4 +-
 drivers/pinctrl/pinctrl-mxs.c                   |   2 +-
 drivers/pinctrl/pinctrl-pxa168.c                |   4 +-
 drivers/pinctrl/pinctrl-pxa910.c                |   4 +-
 drivers/pinctrl/pinctrl-single.c                |   6 +-
 drivers/pinctrl/pinctrl-sirf.c                  |   2 +-
 drivers/pinctrl/pinctrl-tegra.c                 |   2 +-
 drivers/pinctrl/pinctrl-tegra20.c               |   4 +-
 drivers/pinctrl/pinctrl-tegra30.c               |   4 +-
 drivers/pinctrl/pinctrl-u300.c                  |   4 +-
 drivers/pinctrl/spear/pinctrl-spear.c           |   2 +-
 drivers/pinctrl/spear/pinctrl-spear.h           |   2 +-
 drivers/pinctrl/spear/pinctrl-spear1310.c       |   6 +-
 drivers/pinctrl/spear/pinctrl-spear1340.c       |   6 +-
 drivers/pinctrl/spear/pinctrl-spear300.c        |   6 +-
 drivers/pinctrl/spear/pinctrl-spear310.c        |   6 +-
 drivers/pinctrl/spear/pinctrl-spear320.c        |   6 +-
 drivers/pnp/pnpbios/core.c                      |  20 +++----
 drivers/power/88pm860x_battery.c                |   6 +-
 drivers/power/88pm860x_charger.c                |   6 +-
 drivers/power/ab8500_btemp.c                    |   6 +-
 drivers/power/ab8500_charger.c                  |   6 +-
 drivers/power/ab8500_fg.c                       |   6 +-
 drivers/power/abx500_chargalg.c                 |   6 +-
 drivers/power/avs/smartreflex.c                 |   8 +--
 drivers/power/bq27x00_battery.c                 |   6 +-
 drivers/power/charger-manager.c                 |   4 +-
 drivers/power/collie_battery.c                  |   6 +-
 drivers/power/da9052-battery.c                  |   6 +-
 drivers/power/ds2780_battery.c                  |   6 +-
 drivers/power/ds2781_battery.c                  |   6 +-
 drivers/power/generic-adc-battery.c             |   6 +-
 drivers/power/gpio-charger.c                    |   6 +-
 drivers/power/intel_mid_battery.c               |   8 +--
 drivers/power/isp1704_charger.c                 |   6 +-
 drivers/power/jz4740-battery.c                  |   6 +-
 drivers/power/lp8727_charger.c                  |   4 +-
 drivers/power/lp8788-charger.c                  |   6 +-
 drivers/power/max17040_battery.c                |   6 +-
 drivers/power/max17042_battery.c                |   6 +-
 drivers/power/max8903_charger.c                 |   6 +-
 drivers/power/max8925_power.c                   |  10 ++--
 drivers/power/max8997_charger.c                 |   6 +-
 drivers/power/max8998_charger.c                 |   6 +-
 drivers/power/olpc_battery.c                    |   6 +-
 drivers/power/pcf50633-charger.c                |   6 +-
 drivers/power/s3c_adc_battery.c                 |   2 +-
 drivers/power/sbs-battery.c                     |   6 +-
 drivers/power/smb347-charger.c                  |   2 +-
 drivers/power/tosa_battery.c                    |   6 +-
 drivers/power/wm831x_backup.c                   |   6 +-
 drivers/power/wm831x_power.c                    |   6 +-
 drivers/power/wm8350_power.c                    |   6 +-
 drivers/power/wm97xx_battery.c                  |   6 +-
 drivers/power/z2_battery.c                      |   6 +-
 drivers/ptp/ptp_pch.c                           |   4 +-
 drivers/pwm/pwm-ab8500.c                        |   6 +-
 drivers/pwm/pwm-bfin.c                          |   4 +-
 drivers/pwm/pwm-imx.c                           |   6 +-
 drivers/pwm/pwm-jz4740.c                        |   6 +-
 drivers/pwm/pwm-lpc32xx.c                       |   4 +-
 drivers/pwm/pwm-mxs.c                           |   4 +-
 drivers/pwm/pwm-puv3.c                          |   6 +-
 drivers/pwm/pwm-pxa.c                           |   6 +-
 drivers/pwm/pwm-samsung.c                       |   4 +-
 drivers/pwm/pwm-tegra.c                         |   4 +-
 drivers/pwm/pwm-tiecap.c                        |   6 +-
 drivers/pwm/pwm-tiehrpwm.c                      |   6 +-
 drivers/pwm/pwm-twl6030.c                       |   2 +-
 drivers/rapidio/devices/tsi721.c                |   4 +-
 drivers/rapidio/devices/tsi721.h                |   2 +-
 drivers/rapidio/devices/tsi721_dma.c            |   2 +-
 drivers/rapidio/rio-scan.c                      |  14 ++---
 drivers/rapidio/rio.c                           |   6 +-
 drivers/video/backlight/adp5520_bl.c            |   6 +-
 drivers/video/backlight/adp8860_bl.c            |  14 ++---
 drivers/video/backlight/adp8870_bl.c            |  14 ++---
 drivers/video/backlight/ams369fg06.c            |   6 +-
 drivers/video/backlight/apple_bl.c              |   4 +-
 drivers/video/backlight/corgi_lcd.c             |   6 +-
 drivers/video/backlight/ep93xx_bl.c             |   2 +-
 drivers/video/backlight/hp680_bl.c              |   2 +-
 drivers/video/backlight/ili9320.c               |   4 +-
 drivers/video/backlight/l4f00242t03.c           |   6 +-
 drivers/video/backlight/ld9040.c                |   4 +-
 drivers/video/backlight/lm3533_bl.c             |   8 +--
 drivers/video/backlight/lm3630_bl.c             |   8 +--
 drivers/video/backlight/lm3639_bl.c             |   8 +--
 drivers/video/backlight/lms283gf05.c            |   6 +-
 drivers/video/backlight/lp855x_bl.c             |   4 +-
 drivers/video/backlight/ltv350qv.c              |   6 +-
 drivers/video/backlight/max8925_bl.c            |   6 +-
 drivers/video/backlight/pcf50633-backlight.c    |   6 +-
 drivers/video/backlight/platform_lcd.c          |   6 +-
 drivers/video/backlight/s6e63m0.c               |   6 +-
 drivers/video/backlight/tdo24m.c                |   6 +-
 drivers/video/backlight/tosa_bl.c               |   6 +-
 drivers/video/backlight/tosa_lcd.c              |   6 +-
 drivers/video/backlight/vgg2432a4.c             |   6 +-
 drivers/watchdog/acquirewdt.c                   |   6 +-
 drivers/watchdog/advantechwdt.c                 |   6 +-
 drivers/watchdog/ar7_wdt.c                      |   6 +-
 drivers/watchdog/at91rm9200_wdt.c               |   6 +-
 drivers/watchdog/ath79_wdt.c                    |   6 +-
 drivers/watchdog/bcm63xx_wdt.c                  |   6 +-
 drivers/watchdog/bfin_wdt.c                     |   6 +-
 drivers/watchdog/cpu5wdt.c                      |   8 +--
 drivers/watchdog/cpwd.c                         |   6 +-
 drivers/watchdog/da9052_wdt.c                   |   6 +-
 drivers/watchdog/davinci_wdt.c                  |   6 +-
 drivers/watchdog/dw_wdt.c                       |   6 +-
 drivers/watchdog/ep93xx_wdt.c                   |   6 +-
 drivers/watchdog/gef_wdt.c                      |   4 +-
 drivers/watchdog/geodewdt.c                     |   6 +-
 drivers/watchdog/hpwdt.c                        |  30 +++++-----
 drivers/watchdog/i6300esb.c                     |  10 ++--
 drivers/watchdog/iTCO_wdt.c                     |   8 +--
 drivers/watchdog/ib700wdt.c                     |   6 +-
 drivers/watchdog/ie6xx_wdt.c                    |  10 ++--
 drivers/watchdog/jz4740_wdt.c                   |   6 +-
 drivers/watchdog/ks8695_wdt.c                   |   6 +-
 drivers/watchdog/lantiq_wdt.c                   |   6 +-
 drivers/watchdog/max63xx_wdt.c                  |   6 +-
 drivers/watchdog/mixcomwd.c                     |   2 +-
 drivers/watchdog/mpc8xxx_wdt.c                  |   6 +-
 drivers/watchdog/mpcore_wdt.c                   |   6 +-
 drivers/watchdog/mtx-1_wdt.c                    |   6 +-
 drivers/watchdog/mv64x60_wdt.c                  |   6 +-
 drivers/watchdog/nuc900_wdt.c                   |   6 +-
 drivers/watchdog/nv_tco.c                       |  10 ++--
 drivers/watchdog/of_xilinx_wdt.c                |   8 +--
 drivers/watchdog/omap_wdt.c                     |   6 +-
 drivers/watchdog/orion_wdt.c                    |   8 +--
 drivers/watchdog/pcwd.c                         |   8 +--
 drivers/watchdog/pcwd_pci.c                     |   6 +-
 drivers/watchdog/pnx4008_wdt.c                  |   6 +-
 drivers/watchdog/rc32434_wdt.c                  |   6 +-
 drivers/watchdog/rdc321x_wdt.c                  |   6 +-
 drivers/watchdog/riowd.c                        |   6 +-
 drivers/watchdog/s3c2410_wdt.c                  |   6 +-
 drivers/watchdog/sch311x_wdt.c                  |   6 +-
 drivers/watchdog/shwdt.c                        |   6 +-
 drivers/watchdog/sp5100_tco.c                   |  10 ++--
 drivers/watchdog/sp805_wdt.c                    |   6 +-
 drivers/watchdog/stmp3xxx_wdt.c                 |   6 +-
 drivers/watchdog/ts72xx_wdt.c                   |   6 +-
 drivers/watchdog/twl4030_wdt.c                  |   6 +-
 drivers/watchdog/via_wdt.c                      |   6 +-
 drivers/watchdog/wdt_pci.c                      |   6 +-
 drivers/watchdog/wm831x_wdt.c                   |   6 +-
 drivers/watchdog/wm8350_wdt.c                   |   6 +-
 drivers/watchdog/xen_wdt.c                      |   6 +-
 fs/debugfs/inode.c                              |   1 -
 fs/sysfs/file.c                                 |   4 +-
 include/linux/init.h                            |  18 +++---
 include/linux/kobject.h                         |  18 ------
 include/linux/mfd/88pm80x.h                     |   2 +-
 include/linux/mfd/abx500/ab8500.h               |   4 +-
 include/linux/mfd/pm8xxx/irq.h                  |   8 +--
 include/linux/pci.h                             |   8 +--
 kernel/ksysfs.c                                 |   5 +-
 kernel/sysctl.c                                 |   4 +-
 lib/Makefile                                    |   3 +-
 scripts/mod/modpost.c                           |  24 ++++----
 492 files changed, 2042 insertions(+), 1840 deletions(-)
 create mode 100644 Documentation/zh_CN/arm/kernel_user_helpers.txt
 delete mode 100644 drivers/pci/hotplug.c
