Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932812Ab0FBTEv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 15:04:51 -0400
Received: from smtp-out-182.synserver.de ([212.40.180.182]:1064 "HELO
	smtp-out-182.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757718Ab0FBTEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 15:04:47 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 28645
From: Lars-Peter Clausen <lars@metafoo.de>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Lars-Peter Clausen <lars@metafoo.de>
Subject: [RFC][PATCH 00/26] *** SUBJECT HERE ***
Date: Wed,  2 Jun 2010 21:02:51 +0200
Message-Id: <1275505397-16758-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch series adds support for the Ingenic JZ4740 System-on-a-Chip.

The JZ4740 has a mostly MIPS32 4K compatible core (no on cpu timers) and many on
chip peripherals like RTC, NAND, MMC, OHCI, UDC, ADC, I2C, SPI, AC97, I2S, I2S
Codec, UART and LCD controller.

The JZ4740 is mostly used in eBooks, PMPs and hand-held consoles.
This series contains patches for the Qi Ben NanoNote clamshell device as the
inital supported device.

- Lars

--

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
  hwmon: Add JZ4740 ADC driver
  power: Add JZ4740 battery driver.
  MIPS: JZ4740: Add qi_lb60 board support
  MIPS: Add defconfig for the qi_lb60 board
  alsa: ASoC: JZ4740: Add qi_lb60 board driver

 arch/mips/Kconfig                            |   13 +
 arch/mips/Makefile                           |    6 +
 arch/mips/configs/qi_lb60_defconfig          | 1456 ++++++++++++++++++++++++++
 arch/mips/include/asm/bootinfo.h             |    6 +
 arch/mips/include/asm/cpu.h                  |    9 +-
 arch/mips/include/asm/mach-jz4740/base.h     |   28 +
 arch/mips/include/asm/mach-jz4740/clock.h    |   28 +
 arch/mips/include/asm/mach-jz4740/dma.h      |   90 ++
 arch/mips/include/asm/mach-jz4740/gpio.h     |  398 +++++++
 arch/mips/include/asm/mach-jz4740/irq.h      |   55 +
 arch/mips/include/asm/mach-jz4740/platform.h |   36 +
 arch/mips/include/asm/mach-jz4740/timer.h    |   22 +
 arch/mips/include/asm/mach-jz4740/war.h      |   25 +
 arch/mips/jz4740/Kconfig                     |   12 +
 arch/mips/jz4740/Makefile                    |   20 +
 arch/mips/jz4740/board-qi_lb60.c             |  483 +++++++++
 arch/mips/jz4740/clock-debugfs.c             |  109 ++
 arch/mips/jz4740/clock.c                     |  920 ++++++++++++++++
 arch/mips/jz4740/clock.h                     |   76 ++
 arch/mips/jz4740/dma.c                       |  289 +++++
 arch/mips/jz4740/gpio.c                      |  605 +++++++++++
 arch/mips/jz4740/irq.c                       |  170 +++
 arch/mips/jz4740/irq.h                       |   21 +
 arch/mips/jz4740/platform.c                  |  288 +++++
 arch/mips/jz4740/pm.c                        |   56 +
 arch/mips/jz4740/prom.c                      |   69 ++
 arch/mips/jz4740/pwm.c                       |  172 +++
 arch/mips/jz4740/reset.c                     |   81 ++
 arch/mips/jz4740/reset.h                     |    7 +
 arch/mips/jz4740/serial.c                    |   33 +
 arch/mips/jz4740/serial.h                    |   21 +
 arch/mips/jz4740/setup.c                     |   33 +
 arch/mips/jz4740/time.c                      |  144 +++
 arch/mips/jz4740/timer.c                     |   48 +
 arch/mips/jz4740/timer.h                     |  136 +++
 arch/mips/kernel/cpu-probe.c                 |   20 +
 arch/mips/mm/tlbex.c                         |    5 +
 drivers/hwmon/Kconfig                        |   11 +
 drivers/hwmon/Makefile                       |    1 +
 drivers/hwmon/jz4740-adc.c                   |  423 ++++++++
 drivers/mmc/host/Kconfig                     |    8 +
 drivers/mmc/host/Makefile                    |    1 +
 drivers/mmc/host/jz4740_mmc.c                | 1000 ++++++++++++++++++
 drivers/mtd/nand/Kconfig                     |    6 +
 drivers/mtd/nand/Makefile                    |    1 +
 drivers/mtd/nand/jz4740_nand.c               |  442 ++++++++
 drivers/power/Kconfig                        |   11 +
 drivers/power/Makefile                       |    1 +
 drivers/power/jz4740-battery.c               |  359 +++++++
 drivers/rtc/Kconfig                          |   11 +
 drivers/rtc/Makefile                         |    1 +
 drivers/rtc/rtc-jz4740.c                     |  344 ++++++
 drivers/usb/Kconfig                          |    1 +
 drivers/usb/host/ohci-hcd.c                  |    5 +
 drivers/usb/host/ohci-jz4740.c               |  264 +++++
 drivers/video/Kconfig                        |    9 +
 drivers/video/Makefile                       |    1 +
 drivers/video/jz4740_fb.c                    |  818 +++++++++++++++
 include/linux/jz4740-adc.h                   |   25 +
 include/linux/jz4740_fb.h                    |   58 +
 include/linux/mmc/jz4740_mmc.h               |   15 +
 include/linux/mtd/jz4740_nand.h              |   34 +
 include/linux/power/jz4740-battery.h         |   24 +
 sound/soc/Kconfig                            |    1 +
 sound/soc/Makefile                           |    1 +
 sound/soc/codecs/Kconfig                     |    4 +
 sound/soc/codecs/Makefile                    |    2 +
 sound/soc/codecs/jz4740-codec.c              |  502 +++++++++
 sound/soc/codecs/jz4740-codec.h              |   20 +
 sound/soc/jz4740/Kconfig                     |   21 +
 sound/soc/jz4740/Makefile                    |   13 +
 sound/soc/jz4740/jz4740-i2s.c                |  568 ++++++++++
 sound/soc/jz4740/jz4740-i2s.h                |   18 +
 sound/soc/jz4740/jz4740-pcm.c                |  350 ++++++
 sound/soc/jz4740/jz4740-pcm.h                |   22 +
 sound/soc/jz4740/qi_lb60.c                   |  175 +++
 76 files changed, 11560 insertions(+), 1 deletions(-)
 create mode 100644 arch/mips/configs/qi_lb60_defconfig
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
 create mode 100644 drivers/hwmon/jz4740-adc.c
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

