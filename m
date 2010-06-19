Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118Ab0FSFJJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 01:09:09 -0400
Received: from smtp-out-037.synserver.de ([212.40.180.37]:1049 "HELO
	smtp-out-036.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1752706Ab0FSFJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 01:09:07 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 13414
From: Lars-Peter Clausen <lars@metafoo.de>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Lars-Peter Clausen <lars@metafoo.de>,
       Alessandro Zummo <a.zummo@towertech.it>,
       Andrew Morton <akpm@linux-foundation.org>,
       Anton Vorontsov <cbouatmailru@gmail.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       David Woodhouse <dwmw2@infradead.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Paul Gortmaker <p_gortmaker@yahoo.com>,
       Samuel Ortiz <sameo@linux.intel.com>, alsa-devel@alsa-project.org,
       linux-fbdev@vger.kernel.org, linux-mmc@vger.kernel.org,
       linux-mtd@lists.infradead.org, linux-usb@vger.kernel.org,
       lm-sensors@lm-sensors.org, rtc-linux@googlegroups.com
Subject: [PATCH v2 00/26] Add support for the Ingenic JZ4740 System-on-a-Chip
Date: Sat, 19 Jun 2010 07:08:05 +0200
Message-Id: <1276924111-11158-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Foreword:
Ralf suggested that it might be a good idea in order to allow for reasonable
testing and to avoid build failures due to two-way dependencies in different
parts of the kernel, that he applies all the patches once they have been acked
by their respective maintainers, feeds them into -next and eventually sends the
whole series to Linus. One exception will be the ASoC patches which will, due to
major changes in the ASoC subsystem, go through the ASoC tree.
So if you are a maintainer for one of the subsystem touched by this series and
would rather see the patch going through your tree (given the patch is ok)
please tell.


This patch series adds support for the Ingenic JZ4740 System-on-a-Chip.

The JZ4740 has a mostly MIPS32 compatible core (no on cpu timers) and many on
chip peripherals like RTC, NAND, MMC, OHCI, UDC, ADC, I2C, SPI, AC97, I2S, I2S
Codec, UART and LCD controller.

The JZ4740 is mostly used in eBooks, PMPs and hand-held consoles.
This series contains patches for the Qi Ben NanoNote clamshell device as the
inital supported device.

Changes since v1:
There have been some minor changes since v1, mostly code cleanup and some
functional changes. One bigger change is that there is now a MFD driver for
the ADC core which does IRQ demultiplexing for the ADC unit and synchronizes
access to shared registers between the different users of the ADC core.
The patch adding a defconfig for the Qi LB60 has been dropped.
A detailed list of changes is present in each patch.

- Lars

Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: alsa-devel@alsa-project.org
Cc: linux-fbdev@vger.kernel.org
Cc: linux-mmc@vger.kernel.org
Cc: linux-mtd@lists.infradead.org
Cc: linux-usb@vger.kernel.org
Cc: lm-sensors@lm-sensors.org
Cc: rtc-linux@googlegroups.com

Lars-Peter Clausen (26):
  MIPS: Add base support for Ingenic JZ4740 System-on-a-Chip
  MIPS: jz4740: Add IRQ handler code
  MIPS: JZ4740: Add clock API support.
  MIPS: JZ4740: Add timer support
  MIPS: JZ4740: Add clocksource/clockevent support.
  MIPS: JZ4740: Add power-management and system reset support
  MIPS: JZ4740: Add setup code
  MIPS: JZ4740: Add gpio support
  MIPS: JZ4740: Add DMA support.
  MIPS: JZ4740: Add PWM support
  MIPS: JZ4740: Add serial support
  MIPS: JZ4740: Add prom support
  MIPS: JZ4740: Add platform devices
  MIPS: JZ4740: Add Kbuild files
  RTC: Add JZ4740 RTC driver
  fbdev: Add JZ4740 framebuffer driver
  MTD: Nand: Add JZ4740 NAND driver
  MMC: Add JZ4740 mmc driver
  USB: Add JZ4740 ohci support
  alsa: ASoC: Add JZ4740 codec driver
  alsa: ASoC: Add JZ4740 ASoC support
  MFD: Add JZ4740 ADC driver
  hwmon: Add JZ4740 ADC driver
  power: Add JZ4740 battery driver.
  MIPS: JZ4740: Add qi_lb60 board support
  alsa: ASoC: JZ4740: Add qi_lb60 board driver

 arch/mips/Kbuild.platforms                   |    1 +
 arch/mips/Kconfig                            |   13 +
 arch/mips/include/asm/bootinfo.h             |    6 +
 arch/mips/include/asm/cpu.h                  |    9 +-
 arch/mips/include/asm/mach-jz4740/base.h     |   26 +
 arch/mips/include/asm/mach-jz4740/clock.h    |   28 +
 arch/mips/include/asm/mach-jz4740/dma.h      |   90 +++
 arch/mips/include/asm/mach-jz4740/gpio.h     |  398 +++++++++++
 arch/mips/include/asm/mach-jz4740/irq.h      |   57 ++
 arch/mips/include/asm/mach-jz4740/platform.h |   36 +
 arch/mips/include/asm/mach-jz4740/timer.h    |   22 +
 arch/mips/include/asm/mach-jz4740/war.h      |   25 +
 arch/mips/jz4740/Kconfig                     |   12 +
 arch/mips/jz4740/Makefile                    |   20 +
 arch/mips/jz4740/Platform                    |    5 +
 arch/mips/jz4740/board-qi_lb60.c             |  483 +++++++++++++
 arch/mips/jz4740/clock-debugfs.c             |  109 +++
 arch/mips/jz4740/clock.c                     |  920 ++++++++++++++++++++++++
 arch/mips/jz4740/clock.h                     |   76 ++
 arch/mips/jz4740/dma.c                       |  289 ++++++++
 arch/mips/jz4740/gpio.c                      |  601 ++++++++++++++++
 arch/mips/jz4740/irq.c                       |  169 +++++
 arch/mips/jz4740/irq.h                       |   21 +
 arch/mips/jz4740/platform.c                  |  284 ++++++++
 arch/mips/jz4740/pm.c                        |   56 ++
 arch/mips/jz4740/prom.c                      |   68 ++
 arch/mips/jz4740/pwm.c                       |  169 +++++
 arch/mips/jz4740/reset.c                     |   79 ++
 arch/mips/jz4740/reset.h                     |    7 +
 arch/mips/jz4740/serial.c                    |   33 +
 arch/mips/jz4740/serial.h                    |   21 +
 arch/mips/jz4740/setup.c                     |   29 +
 arch/mips/jz4740/time.c                      |  144 ++++
 arch/mips/jz4740/timer.c                     |   48 ++
 arch/mips/jz4740/timer.h                     |  136 ++++
 arch/mips/kernel/cpu-probe.c                 |   20 +
 arch/mips/mm/tlbex.c                         |    5 +
 drivers/hwmon/Kconfig                        |   11 +
 drivers/hwmon/Makefile                       |    1 +
 drivers/hwmon/jz4740-hwmon.c                 |  206 ++++++
 drivers/mfd/Kconfig                          |    8 +
 drivers/mfd/Makefile                         |    1 +
 drivers/mfd/jz4740-adc.c                     |  392 ++++++++++
 drivers/mmc/host/Kconfig                     |    8 +
 drivers/mmc/host/Makefile                    |    1 +
 drivers/mmc/host/jz4740_mmc.c                |  993 ++++++++++++++++++++++++++
 drivers/mtd/nand/Kconfig                     |    6 +
 drivers/mtd/nand/Makefile                    |    1 +
 drivers/mtd/nand/jz4740_nand.c               |  474 ++++++++++++
 drivers/power/Kconfig                        |   11 +
 drivers/power/Makefile                       |    1 +
 drivers/power/jz4740-battery.c               |  445 ++++++++++++
 drivers/rtc/Kconfig                          |   11 +
 drivers/rtc/Makefile                         |    1 +
 drivers/rtc/rtc-jz4740.c                     |  341 +++++++++
 drivers/usb/Kconfig                          |    1 +
 drivers/usb/host/ohci-hcd.c                  |    5 +
 drivers/usb/host/ohci-jz4740.c               |  276 +++++++
 drivers/video/Kconfig                        |    9 +
 drivers/video/Makefile                       |    1 +
 drivers/video/jz4740_fb.c                    |  817 +++++++++++++++++++++
 include/linux/jz4740-adc.h                   |   32 +
 include/linux/jz4740_fb.h                    |   58 ++
 include/linux/mmc/jz4740_mmc.h               |   15 +
 include/linux/mtd/jz4740_nand.h              |   34 +
 include/linux/power/jz4740-battery.h         |   24 +
 sound/soc/Kconfig                            |    1 +
 sound/soc/Makefile                           |    1 +
 sound/soc/codecs/Kconfig                     |    4 +
 sound/soc/codecs/Makefile                    |    2 +
 sound/soc/codecs/jz4740-codec.c              |  514 +++++++++++++
 sound/soc/codecs/jz4740-codec.h              |   20 +
 sound/soc/jz4740/Kconfig                     |   23 +
 sound/soc/jz4740/Makefile                    |   13 +
 sound/soc/jz4740/jz4740-i2s.c                |  540 ++++++++++++++
 sound/soc/jz4740/jz4740-i2s.h                |   18 +
 sound/soc/jz4740/jz4740-pcm.c                |  373 ++++++++++
 sound/soc/jz4740/jz4740-pcm.h                |   22 +
 sound/soc/jz4740/qi_lb60.c                   |  167 +++++
 79 files changed, 10396 insertions(+), 1 deletions(-)
 create mode 100644 arch/mips/include/asm/mach-jz4740/base.h
 create mode 100644 arch/mips/include/asm/mach-jz4740/clock.h
 create mode 100644 arch/mips/include/asm/mach-jz4740/dma.h
 create mode 100644 arch/mips/include/asm/mach-jz4740/gpio.h
 create mode 100644 arch/mips/include/asm/mach-jz4740/irq.h
 create mode 100644 arch/mips/include/asm/mach-jz4740/platform.h
 create mode 100644 arch/mips/include/asm/mach-jz4740/timer.h
 create mode 100644 arch/mips/include/asm/mach-jz4740/war.h
 create mode 100644 arch/mips/jz4740/Kconfig
 create mode 100644 arch/mips/jz4740/Makefile
 create mode 100644 arch/mips/jz4740/Platform
 create mode 100644 arch/mips/jz4740/board-qi_lb60.c
 create mode 100644 arch/mips/jz4740/clock-debugfs.c
 create mode 100644 arch/mips/jz4740/clock.c
 create mode 100644 arch/mips/jz4740/clock.h
 create mode 100644 arch/mips/jz4740/dma.c
 create mode 100644 arch/mips/jz4740/gpio.c
 create mode 100644 arch/mips/jz4740/irq.c
 create mode 100644 arch/mips/jz4740/irq.h
 create mode 100644 arch/mips/jz4740/platform.c
 create mode 100644 arch/mips/jz4740/pm.c
 create mode 100644 arch/mips/jz4740/prom.c
 create mode 100644 arch/mips/jz4740/pwm.c
 create mode 100644 arch/mips/jz4740/reset.c
 create mode 100644 arch/mips/jz4740/reset.h
 create mode 100644 arch/mips/jz4740/serial.c
 create mode 100644 arch/mips/jz4740/serial.h
 create mode 100644 arch/mips/jz4740/setup.c
 create mode 100644 arch/mips/jz4740/time.c
 create mode 100644 arch/mips/jz4740/timer.c
 create mode 100644 arch/mips/jz4740/timer.h
 create mode 100644 drivers/hwmon/jz4740-hwmon.c
 create mode 100644 drivers/mfd/jz4740-adc.c
 create mode 100644 drivers/mmc/host/jz4740_mmc.c
 create mode 100644 drivers/mtd/nand/jz4740_nand.c
 create mode 100644 drivers/power/jz4740-battery.c
 create mode 100644 drivers/rtc/rtc-jz4740.c
 create mode 100644 drivers/usb/host/ohci-jz4740.c
 create mode 100644 drivers/video/jz4740_fb.c
 create mode 100644 include/linux/jz4740-adc.h
 create mode 100644 include/linux/jz4740_fb.h
 create mode 100644 include/linux/mmc/jz4740_mmc.h
 create mode 100644 include/linux/mtd/jz4740_nand.h
 create mode 100644 include/linux/power/jz4740-battery.h
 create mode 100644 sound/soc/codecs/jz4740-codec.c
 create mode 100644 sound/soc/codecs/jz4740-codec.h
 create mode 100644 sound/soc/jz4740/Kconfig
 create mode 100644 sound/soc/jz4740/Makefile
 create mode 100644 sound/soc/jz4740/jz4740-i2s.c
 create mode 100644 sound/soc/jz4740/jz4740-i2s.h
 create mode 100644 sound/soc/jz4740/jz4740-pcm.c
 create mode 100644 sound/soc/jz4740/jz4740-pcm.h
 create mode 100644 sound/soc/jz4740/qi_lb60.c

