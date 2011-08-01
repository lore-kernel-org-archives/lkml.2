Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656Ab1HAItT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 04:49:19 -0400
Received: from linux-sh.org ([111.68.239.195]:55756 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697Ab1HAItO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 04:49:14 -0400
Date: Mon, 1 Aug 2011 17:49:08 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 3.1-rc1
Message-ID: <20110801084908.GA32513@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-3.x.git sh-latest

Which contains:

Jesper Juhl (1):
      SH: static should be at beginning of declaration

Kuninori Morimoto (21):
      dmaengine: shdma: add to_sh_dev define
      dmaengine: shdma: tidyup spin_unlock_bh on sh_chan_xfer_ld_queue
      dmaengine: shdma: fixup parameter definition on dmae_set_dmars
      dmaengine: shdma: add chcr_write/read function
      dmaengine: shdma: add chcr_ie_bit
      dmaengine: shdma: add dmaor_is_32bit flag
      dmaengine: shdma: add .needs_tend_set / .no_dmars flags
      sh: clock-sh7724: modify I2C clock settings
      sh: clock-sh7722: modify I2C clock settings
      sh: clock-sh7723: modify I2C clock settings
      sh: clock-sh7343: modify I2C clock settings
      sh: clock-sh7366: modify I2C clock settings
      sh: clock-sh7724: add CLKDEV_ICK_ID for cleanup
      sh: clock-sh7722: add CLKDEV_ICK_ID for cleanup
      sh: clock-sh7343: add CLKDEV_ICK_ID for cleanup
      sh: clock-sh7366: add CLKDEV_ICK_ID for cleanup
      sh: clock-sh7757: add CLKDEV_ICK_ID for cleanup
      sh: clock-sh7785: add CLKDEV_ICK_ID for cleanup
      sh: clock-sh7786: add CLKDEV_ICK_ID for cleanup
      sh: clock-shx3: add CLKDEV_ICK_ID for cleanup
      sh: move CLKDEV_xxx_ID macro to sh_clk.h

Magnus Damm (1):
      drivers: sh: late disabling of clocks V2

Paul Mundt (16):
      serial: sh-sci: Kill off bitrotted H8/300 support.
      serial: sh-sci: Tidy up ioread/write wrappers, kill off unused SCI helper.
      serial: sh-sci: Kill off some more unused definitions.
      serial: sh-sci: Generalize overrun handling.
      serial: sh-sci: Consolidate RXD pin handling.
      serial: sh-sci: More unused define purging.
      serial: sh-sci: Abstract register maps.
      serial: sh-sci: FIFO sizing helper consolidation.
      serial: sh-sci: Support generic SCLSR overrun detection.
      sh: Fix up build fallout from serial merge.
      sh: clkfwk: Convert to IS_ERR_OR_NULL.
      sh: Tidy up pre-clkdev clk_get() error handling.
      serial: sh-sci: Regtype probing doesn't need to be fatal.
      serial: sh-sci: Add missing module description/author bits.
      serial: sh-sci: Kill off per-port enable/disable callbacks.
      serial: sh-sci: Fix up pretty name printing for port IRQs.

Yoshihiro Shimoda (5):
      sh: fix compile error using sh7757lcr_defconfig
      sh: add platform_device of EHCI/OHCI to setup-sh7757
      sh: add to select the new configuration for USB EHCI/OHCI
      sh: fix the INTC vector for IRQ and IRL in setup-sh7757
      sh: fix the value of sh_dmae_slave_config in setup-sh7757

 arch/arm/mach-shmobile/clock-sh7367.c   |    3 -
 arch/arm/mach-shmobile/clock-sh7372.c   |    4 -
 arch/arm/mach-shmobile/clock-sh7377.c   |    3 -
 arch/arm/mach-shmobile/clock-sh73a0.c   |    4 -
 arch/sh/Kconfig                         |    5 +
 arch/sh/Makefile                        |    1 +
 arch/sh/boards/board-apsh4a3a.c         |    2 +-
 arch/sh/boards/board-apsh4ad0a.c        |    2 +-
 arch/sh/boards/board-sh7785lcr.c        |    2 +-
 arch/sh/boards/board-urquell.c          |    2 +-
 arch/sh/boards/mach-ap325rxa/setup.c    |    2 +-
 arch/sh/boards/mach-ecovec24/setup.c    |    4 +-
 arch/sh/boards/mach-highlander/setup.c  |    2 -
 arch/sh/boards/mach-kfr2r09/setup.c     |    2 +-
 arch/sh/boards/mach-migor/setup.c       |    2 +-
 arch/sh/boards/mach-sdk7786/setup.c     |    2 +-
 arch/sh/boards/mach-se/7724/setup.c     |    4 +-
 arch/sh/configs/sh7757lcr_defconfig     |    8 +-
 arch/sh/include/cpu-sh3/cpu/serial.h    |   10 +
 arch/sh/include/cpu-sh4a/cpu/serial.h   |    7 +
 arch/sh/kernel/cpu/clock-cpg.c          |    2 -
 arch/sh/kernel/cpu/sh3/Makefile         |   18 +-
 arch/sh/kernel/cpu/sh3/serial-sh770x.c  |   33 ++
 arch/sh/kernel/cpu/sh3/serial-sh7710.c  |   20 +
 arch/sh/kernel/cpu/sh3/serial-sh7720.c  |   37 ++
 arch/sh/kernel/cpu/sh3/setup-sh7705.c   |    5 +
 arch/sh/kernel/cpu/sh3/setup-sh770x.c   |    9 +
 arch/sh/kernel/cpu/sh3/setup-sh7720.c   |    5 +
 arch/sh/kernel/cpu/sh4/clock-sh4-202.c  |    2 -
 arch/sh/kernel/cpu/sh4/setup-sh7750.c   |    4 +-
 arch/sh/kernel/cpu/sh4/setup-sh7760.c   |    4 +
 arch/sh/kernel/cpu/sh4a/Makefile        |    2 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7343.c  |   33 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7366.c  |   25 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7722.c  |   46 +--
 arch/sh/kernel/cpu/sh4a/clock-sh7723.c  |    4 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7724.c  |   84 +---
 arch/sh/kernel/cpu/sh4a/clock-sh7757.c  |   36 +--
 arch/sh/kernel/cpu/sh4a/clock-sh7763.c  |    2 -
 arch/sh/kernel/cpu/sh4a/clock-sh7780.c  |    2 -
 arch/sh/kernel/cpu/sh4a/clock-sh7785.c  |   79 +---
 arch/sh/kernel/cpu/sh4a/clock-sh7786.c  |  115 +----
 arch/sh/kernel/cpu/sh4a/clock-shx3.c    |   67 +---
 arch/sh/kernel/cpu/sh4a/serial-sh7722.c |   23 +
 arch/sh/kernel/cpu/sh4a/setup-sh7366.c  |    1 +
 arch/sh/kernel/cpu/sh4a/setup-sh7722.c  |    7 +
 arch/sh/kernel/cpu/sh4a/setup-sh7723.c  |    9 +
 arch/sh/kernel/cpu/sh4a/setup-sh7724.c  |    9 +
 arch/sh/kernel/cpu/sh4a/setup-sh7757.c  |  106 ++++--
 arch/sh/kernel/cpu/sh4a/setup-sh7763.c  |    3 +
 arch/sh/kernel/cpu/sh4a/setup-sh7780.c  |    3 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7785.c  |    8 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7786.c  |    8 +-
 drivers/dma/shdma.c                     |   88 +++-
 drivers/dma/shdma.h                     |    4 +
 drivers/sh/clk/core.c                   |   29 ++-
 drivers/tty/serial/Kconfig              |    2 +-
 drivers/tty/serial/sh-sci.c             |  757 +++++++++++++++++++------------
 drivers/tty/serial/sh-sci.h             |  434 +------------------
 include/linux/serial_sci.h              |   75 +++
 include/linux/sh_clk.h                  |    4 +
 include/linux/sh_dma.h                  |    8 +
 62 files changed, 1055 insertions(+), 1228 deletions(-)
 create mode 100644 arch/sh/include/cpu-sh3/cpu/serial.h
 create mode 100644 arch/sh/include/cpu-sh4a/cpu/serial.h
 create mode 100644 arch/sh/kernel/cpu/sh3/serial-sh770x.c
 create mode 100644 arch/sh/kernel/cpu/sh3/serial-sh7710.c
 create mode 100644 arch/sh/kernel/cpu/sh3/serial-sh7720.c
 create mode 100644 arch/sh/kernel/cpu/sh4a/serial-sh7722.c
