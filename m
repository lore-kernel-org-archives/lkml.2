Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377Ab1B0QBB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 11:01:01 -0500
Received: from hera.kernel.org ([140.211.167.34]:58472 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265Ab1B0QA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 11:00:59 -0500
From: Guan Xuetao <epip@hera.kernel.org>
To: arnd@arndb.de
Cc: Guan Xuetao <epip@hera.kernel.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, greg@kroah.com, gxt@mprc.pku.edu.cn
Subject: [PATCH 00/17] unicore32: resend patches after machine related files
Date: Sun, 27 Feb 2011 15:59:28 +0000
Message-Id: <cover.1298821856.git.epip@hera.kernel.org>
X-Mailer: git-send-email 1.7.4.1
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 27 Feb 2011 16:00:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set will resend patches after machine related files.
I2C bus driver and framebuffer driver are also added in this set.

The whole subsystem code could be fetched from:
  git://git.kernel.org/pub/scm/linux/kernel/git/epip/linux-2.6-unicore32.git
  with branch name: unicore32.

GuanXuetao (17):
  unicore32 machine related files: core files
  unicore32 machine related files: hardware registers
  unicore32 machine related files: pci bus handling
  unicore32 machine related files: ps2 driver
  unicore32: ADD MAINTAINER for unicore32 architecture
  unicore32 time.c: change calculate method for clock_event_device
  unicore32: remove unused lines in arch/unicore32/include/asm/irq.h
  unicore32: modify function names and parameters for irq_chips
  unicore32: rename PKUNITY_IOSPACE_BASE to PKUNITY_MMIO_BASE
  unicore32 i8042: adjust io funcs of i8042-unicore32io.h
  unicore32 upgrade to v2.6.38-rc5: add one more paramter for pte_alloc_map call
  unicore32 i8042 upgrade and bugfix: adjust resource request region type
  unicore32 io: redefine __REG(x) and re-use readl/writel funcs
  unicore32 machine related files: add i2c bus drivers for pkunity-v3 soc
  unicore32 machine related: add frame buffer driver for pkunity-v3 soc
  unicore32: add (void __iomem *) to io_p2v macro
  unicore32: replace unicore32-specific iomap functions with generic
    lib implementation

 MAINTAINERS                               |   16 +
 arch/unicore32/Kconfig                    |   29 +
 arch/unicore32/configs/debug_defconfig    |    7 +-
 arch/unicore32/include/asm/gpio.h         |    9 +-
 arch/unicore32/include/asm/io.h           |    9 +-
 arch/unicore32/include/asm/irq.h          |    2 -
 arch/unicore32/include/asm/pci.h          |   46 ++
 arch/unicore32/include/mach/PKUnity.h     |  104 ++++
 arch/unicore32/include/mach/bitfield.h    |   24 +
 arch/unicore32/include/mach/dma.h         |   11 +-
 arch/unicore32/include/mach/hardware.h    |   36 ++
 arch/unicore32/include/mach/memory.h      |    2 +-
 arch/unicore32/include/mach/regs-ac97.h   |   32 ++
 arch/unicore32/include/mach/regs-dmac.h   |   81 +++
 arch/unicore32/include/mach/regs-gpio.h   |   70 +++
 arch/unicore32/include/mach/regs-i2c.h    |   63 +++
 arch/unicore32/include/mach/regs-intc.h   |   28 +
 arch/unicore32/include/mach/regs-nand.h   |   79 +++
 arch/unicore32/include/mach/regs-ost.h    |   92 ++++
 arch/unicore32/include/mach/regs-pci.h    |   94 ++++
 arch/unicore32/include/mach/regs-pm.h     |  126 +++++
 arch/unicore32/include/mach/regs-ps2.h    |   20 +
 arch/unicore32/include/mach/regs-resetc.h |   34 ++
 arch/unicore32/include/mach/regs-rtc.h    |   37 ++
 arch/unicore32/include/mach/regs-sdc.h    |  156 ++++++
 arch/unicore32/include/mach/regs-spi.h    |   98 ++++
 arch/unicore32/include/mach/regs-uart.h   |    3 +
 arch/unicore32/include/mach/regs-umal.h   |  229 ++++++++
 arch/unicore32/include/mach/regs-unigfx.h |  200 +++++++
 arch/unicore32/kernel/clock.c             |   34 +-
 arch/unicore32/kernel/dma.c               |   15 +-
 arch/unicore32/kernel/gpio.c              |   12 +-
 arch/unicore32/kernel/irq.c               |  148 +++---
 arch/unicore32/kernel/pci.c               |  404 ++++++++++++++
 arch/unicore32/kernel/process.c           |   10 +-
 arch/unicore32/kernel/puv3-core.c         |  285 ++++++++++
 arch/unicore32/kernel/puv3-nb0916.c       |  145 +++++
 arch/unicore32/kernel/rtc.c               |   34 +-
 arch/unicore32/kernel/time.c              |   55 +-
 arch/unicore32/mm/Makefile                |    2 +-
 arch/unicore32/mm/iomap.c                 |   56 --
 arch/unicore32/mm/pgd.c                   |    2 +-
 drivers/i2c/busses/Kconfig                |   11 +
 drivers/i2c/busses/Makefile               |    1 +
 drivers/i2c/busses/i2c-puv3.c             |  306 +++++++++++
 drivers/input/serio/i8042-unicore32io.h   |   73 +++
 drivers/input/serio/i8042.h               |    2 +
 drivers/pci/Makefile                      |    1 +
 drivers/video/Kconfig                     |   11 +
 drivers/video/Makefile                    |    1 +
 drivers/video/fb-puv3.c                   |  846 +++++++++++++++++++++++++++++
 include/linux/fb.h                        |    2 +
 52 files changed, 3968 insertions(+), 225 deletions(-)
 create mode 100644 arch/unicore32/include/asm/pci.h
 create mode 100644 arch/unicore32/include/mach/PKUnity.h
 create mode 100644 arch/unicore32/include/mach/bitfield.h
 create mode 100644 arch/unicore32/include/mach/hardware.h
 create mode 100644 arch/unicore32/include/mach/regs-ac97.h
 create mode 100644 arch/unicore32/include/mach/regs-dmac.h
 create mode 100644 arch/unicore32/include/mach/regs-gpio.h
 create mode 100644 arch/unicore32/include/mach/regs-i2c.h
 create mode 100644 arch/unicore32/include/mach/regs-intc.h
 create mode 100644 arch/unicore32/include/mach/regs-nand.h
 create mode 100644 arch/unicore32/include/mach/regs-ost.h
 create mode 100644 arch/unicore32/include/mach/regs-pci.h
 create mode 100644 arch/unicore32/include/mach/regs-pm.h
 create mode 100644 arch/unicore32/include/mach/regs-ps2.h
 create mode 100644 arch/unicore32/include/mach/regs-resetc.h
 create mode 100644 arch/unicore32/include/mach/regs-rtc.h
 create mode 100644 arch/unicore32/include/mach/regs-sdc.h
 create mode 100644 arch/unicore32/include/mach/regs-spi.h
 create mode 100644 arch/unicore32/include/mach/regs-uart.h
 create mode 100644 arch/unicore32/include/mach/regs-umal.h
 create mode 100644 arch/unicore32/include/mach/regs-unigfx.h
 create mode 100644 arch/unicore32/kernel/pci.c
 create mode 100644 arch/unicore32/kernel/puv3-core.c
 create mode 100644 arch/unicore32/kernel/puv3-nb0916.c
 delete mode 100644 arch/unicore32/mm/iomap.c
 create mode 100644 drivers/i2c/busses/i2c-puv3.c
 create mode 100644 drivers/input/serio/i8042-unicore32io.h
 create mode 100644 drivers/video/fb-puv3.c

-- 
1.7.4.1

