Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714Ab2BWRTq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 12:19:46 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:41256 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589Ab2BWRTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 12:19:45 -0500
Message-ID: <4F4674F2.8090603@atmel.com>
Date: Thu, 23 Feb 2012 18:18:42 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
CC: Rob Herring <robherring2@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ryan Mallon <ryan@bluewatersys.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] at91 first cleanup series for 3.4
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof,

This series removes the at91_sys_read/write() functions that where
used for all System Controller devices. The static offsets that were
used prevented us from compiling several AT91 SoC support in a single
zImage.

The other cleanup is the move of some early console initialization. In
addition, some Makefile.boot modifications have been performed to be
able to make .dtb files.

All this goes on top of current material that is already in arm-soc
git tree (merge of all at91/* branches. You can find it in the same git
tree with at91-3.4-base2 branch name).


The following changes since commit 11a25ea7e4f870a37093258f577e11cec703e37e:

  Merge remote-tracking branch 'armsoc/at91/9x5' into at91-3.4-base2 (2012-02-11 14:33:03 +0100)

are available in the git repository at:


  git://github.com/at91linux/linux-at91.git at91-3.4-base2+cleanup

for you to fetch changes up to d5e5a7f987458f42f24a557a0f4e35f94c43fc09:

  ARM: at91: properly sort dtb files in Makefile.boot (2012-02-23 14:58:00 +0100)

----------------------------------------------------------------
Jean-Christophe PLAGNIOL-VILLARD (18):
      ARM: at91: factorise duplicated at91sam9 idle
      ARM: at91/at91x40: remove use of at91_sys_read/write
      ARM: at91: make matrix register base soc independent
      ARM: at91: make ST (System Timer) soc independent
      ARM: at91/pm_slowclock: rename register to named define
      ARM: at91/pm_slowclock: function slow_clock() accepts parameters
      ARM: at91: move at91rm9200 sdramc defines to at91rm9200_sdramc.h
      ARM: at91: make sdram/ddr register base soc independent
      ARM: at91/pm_slowclock: add runtime detection of memory contoller
      ARM: at91/PMC: make register base soc independent
      ARM: at91/rtc-at91sam9: each SoC can select the RTT device to use
      ARM: at91:rtc/rtc-at91sam9: ioremap register bank
      ARM: at91/rtc-at91sam9: pass the GPBR to use via resources
      ARM: at91: finally drop at91_sys_read/write
      ARM: at91: merge SRAM Memory banks thanks to mirroring
      Atmel: move console default platform_device to serial driver
      ARM: at91/board-dt: drop default console
      ARM: at91: properly sort dtb files in Makefile.boot

Nicolas Ferre (3):
      ARM: at91/ST: remove not needed casts
      ARM: at91/PMC: move assignment out of printf
      ARM: at91: add at91sam9g25ek.dts in Makefile.boot

 arch/arm/mach-at91/Makefile.boot                   |    8 +-
 arch/arm/mach-at91/at91rm9200.c                    |    8 +-
 arch/arm/mach-at91/at91rm9200_devices.c            |   14 +-
 arch/arm/mach-at91/at91rm9200_time.c               |   37 ++-
 arch/arm/mach-at91/at91sam9260.c                   |   23 +-
 arch/arm/mach-at91/at91sam9260_devices.c           |   38 +++-
 arch/arm/mach-at91/at91sam9261.c                   |   10 +-
 arch/arm/mach-at91/at91sam9261_devices.c           |   31 ++-
 arch/arm/mach-at91/at91sam9263.c                   |   11 +-
 arch/arm/mach-at91/at91sam9263_devices.c           |   59 ++++-
 arch/arm/mach-at91/at91sam9_alt_reset.S            |   12 +-
 arch/arm/mach-at91/at91sam9g45.c                   |   11 +-
 arch/arm/mach-at91/at91sam9g45_devices.c           |   31 ++-
 arch/arm/mach-at91/at91sam9g45_reset.S             |   12 +-
 arch/arm/mach-at91/at91sam9rl.c                    |   10 +-
 arch/arm/mach-at91/at91sam9rl_devices.c            |   31 ++-
 arch/arm/mach-at91/at91sam9x5.c                    |    5 +-
 arch/arm/mach-at91/at91x40.c                       |    2 +-
 arch/arm/mach-at91/at91x40_time.c                  |   28 ++-
 arch/arm/mach-at91/board-cpu9krea.c                |    5 +-
 arch/arm/mach-at91/board-cpuat91.c                 |    1 +
 arch/arm/mach-at91/board-dt.c                      |    6 -
 arch/arm/mach-at91/board-eco920.c                  |    5 +-
 arch/arm/mach-at91/board-kb9202.c                  |    1 +
 arch/arm/mach-at91/board-picotux200.c              |    1 +
 arch/arm/mach-at91/board-rm9200dk.c                |    1 +
 arch/arm/mach-at91/board-rm9200ek.c                |    1 +
 arch/arm/mach-at91/board-yl-9200.c                 |    3 +-
 arch/arm/mach-at91/clock.c                         |   88 ++++---
 arch/arm/mach-at91/generic.h                       |   10 +
 arch/arm/mach-at91/include/mach/at91_matrix.h      |   23 ++
 arch/arm/mach-at91/include/mach/at91_pmc.h         |   56 +++--
 arch/arm/mach-at91/include/mach/at91_ramc.h        |   32 +++
 arch/arm/mach-at91/include/mach/at91_st.h          |   32 ++-
 arch/arm/mach-at91/include/mach/at91rm9200.h       |   10 +-
 arch/arm/mach-at91/include/mach/at91rm9200_mc.h    |   58 +----
 .../arm/mach-at91/include/mach/at91rm9200_sdramc.h |   63 +++++
 arch/arm/mach-at91/include/mach/at91sam9260.h      |   14 +-
 .../mach-at91/include/mach/at91sam9260_matrix.h    |   36 ++--
 arch/arm/mach-at91/include/mach/at91sam9261.h      |   10 +-
 .../mach-at91/include/mach/at91sam9261_matrix.h    |   18 +-
 arch/arm/mach-at91/include/mach/at91sam9263.h      |   12 +-
 .../mach-at91/include/mach/at91sam9263_matrix.h    |   74 +++---
 arch/arm/mach-at91/include/mach/at91sam9_ddrsdr.h  |    6 -
 arch/arm/mach-at91/include/mach/at91sam9_sdramc.h  |    6 -
 arch/arm/mach-at91/include/mach/at91sam9g45.h      |   12 +-
 .../mach-at91/include/mach/at91sam9g45_matrix.h    |   84 +++---
 arch/arm/mach-at91/include/mach/at91sam9rl.h       |    7 +-
 .../arm/mach-at91/include/mach/at91sam9rl_matrix.h |   42 ++--
 arch/arm/mach-at91/include/mach/at91sam9x5.h       |    5 +-
 arch/arm/mach-at91/include/mach/at91x40.h          |   18 +-
 arch/arm/mach-at91/include/mach/hardware.h         |    3 +-
 arch/arm/mach-at91/include/mach/io.h               |   18 --
 arch/arm/mach-at91/pm.c                            |   35 ++-
 arch/arm/mach-at91/pm.h                            |   11 +-
 arch/arm/mach-at91/pm_slowclock.S                  |  271 ++++++++++----------
 arch/arm/mach-at91/setup.c                         |    9 +
 arch/avr32/mach-at32ap/at32ap700x.c                |    2 -
 drivers/pcmcia/at91_cf.c                           |    5 +-
 drivers/rtc/rtc-at91sam9.c                         |   98 +++-----
 drivers/tty/serial/atmel_serial.c                  |    2 +
 drivers/usb/gadget/at91_udc.c                      |    9 +-
 drivers/usb/gadget/atmel_usba_udc.c                |    6 +-
 drivers/watchdog/at91rm9200_wdt.c                  |    8 +-
 64 files changed, 920 insertions(+), 678 deletions(-)
 create mode 100644 arch/arm/mach-at91/include/mach/at91_matrix.h
 create mode 100644 arch/arm/mach-at91/include/mach/at91_ramc.h
 create mode 100644 arch/arm/mach-at91/include/mach/at91rm9200_sdramc.h

Thanks, best regards,
-- 
Nicolas Ferre
