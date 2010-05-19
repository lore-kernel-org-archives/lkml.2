Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab0ESTAv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 15:00:51 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53092 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080Ab0ESTAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 15:00:50 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       davinci-linux-open-source@linux.davincidsp.com
Subject: [GIT PULL] davinci platform updates for 2.6.35
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Wed, 19 May 2010 12:00:44 -0700
Message-ID: <87r5l7k97n.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the following davinci platform updates for 2.6.35.

Sorry for the last-minute revert, but realized that one RTC patch had
not recieved the proper signoffs from RTC maintainers, and I figured a
revert would be preferred over a rebase at this point.

Thanks,

Kevin



The following changes since commit 66f41d4c5c8a5deed66fdcc84509376c9a0bf9d8:
  Linus Torvalds (1):
        Linux 2.6.34-rc6

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/khilman/linux-davinci.git davinci-for-linus

Anuj Aggarwal (1):
      davinci: edma: clear interrupt status for interrupt enabled channels only

Cyril Chemparathy (28):
      Davinci: allow SOCs based on other ARM CPUs
      Davinci: enable timer clock before use
      Davinci: cpintc host map configuration
      Davinci: support LPSC SwRstDisable state
      Davinci: promote da8xx_pinmux_setup()
      Davinci: tnetv107x pin list
      Davinci: tnetv107x LPSC modules
      Davinci: tnetv107x IRQ definitions
      Davinci: tnetv107x cpu types
      Davinci: configurable pll divider mask
      Davinci: gpio - minor cleanup
      Davinci: gpio - structs and functions renamed
      Davinci: gpio - register layout invariant inlines
      Davinci: gpio - controller type support
      Davinci: gpio - fine grained locking
      Davinci: eliminate pinmux offset verbosity
      Davinci: watchdog reset separation across socs
      Davinci: serial - remove unnecessary define
      Davinci: serial - use ioremap()
      Davinci: serial - conditional reset via pwremu
      Davinci: gpio - use ioremap()
      Davinci: da8xx: rtc - use ioremap
      Davinci: jtag_id - use ioremap()
      Davinci: timer - use ioremap()
      Davinci: psc - use ioremap()
      Davinci: aintc/cpintc - use ioremap()
      Davinci: pinmux - use ioremap()
      Davinci: iotable based ioremap() interception

Kevin Hilman (3):
      davinci: misc cleanups from sparse
      davinci: sparse: gpio: void casting
      Revert "rtc: omap: let device wakeup capability be configured from chip init logic"

Miguel Aguilar (1):
      RTC: DaVinci RTC driver

Sekhar Nori (5):
      rtc: omap: let device wakeup capability be configured from chip init logic
      davinci: edma: use a more intuitive name for edma_info
      davinci: edma: fix coding style issue related to usage of braces
      davinci: edma: use BIT() wherever possible
      davinci: edma: fix coding style issue related to breaking lines

Sergei Shtylyov (3):
      DaVinci: move AEMIF #define's to the proper headers
      DA830 EVM: use DA8XX_AEMIF_*_BASE #define's
      DaVinci: move IDE platform device to its proper place

Thomas Koeller (5):
      davinci: DM365: Allow use of GPIO64_57
      davinci: mach/common.h: add missing includes
      DM365: Added PINMUX definitions for GPIO30..32
      DM365: Make CLKOUTx available
      DM365: Added more PINMUX configurations for AEMIF

Vipin Bhandari (2):
      davinci: da830/omap-l137 evm: add support for GPIO based MMC/SD card detection
      davinci: da830/omap-l137 evm: use 8-wire MMC/SD card support

 arch/arm/Kconfig                             |    1 -
 arch/arm/mach-davinci/Kconfig                |    2 +
 arch/arm/mach-davinci/board-da830-evm.c      |   52 ++-
 arch/arm/mach-davinci/board-da850-evm.c      |   28 +-
 arch/arm/mach-davinci/board-dm355-evm.c      |   18 +-
 arch/arm/mach-davinci/board-dm355-leopard.c  |   18 +-
 arch/arm/mach-davinci/board-dm365-evm.c      |   12 +-
 arch/arm/mach-davinci/board-dm644x-evm.c     |   60 +--
 arch/arm/mach-davinci/board-dm646x-evm.c     |   22 +-
 arch/arm/mach-davinci/board-neuros-osd2.c    |   54 +--
 arch/arm/mach-davinci/board-sffsdr.c         |   20 +-
 arch/arm/mach-davinci/cdce949.c              |    1 +
 arch/arm/mach-davinci/clock.c                |   32 +-
 arch/arm/mach-davinci/clock.h                |    9 +-
 arch/arm/mach-davinci/common.c               |   57 ++-
 arch/arm/mach-davinci/cp_intc.c              |   22 +-
 arch/arm/mach-davinci/da830.c                |   29 +-
 arch/arm/mach-davinci/da850.c                |   30 +-
 arch/arm/mach-davinci/devices-da8xx.c        |   15 +-
 arch/arm/mach-davinci/devices.c              |   50 ++-
 arch/arm/mach-davinci/dm355.c                |   21 +-
 arch/arm/mach-davinci/dm365.c                |   34 +-
 arch/arm/mach-davinci/dm644x.c               |   21 +-
 arch/arm/mach-davinci/dm646x.c               |   53 +--
 arch/arm/mach-davinci/dma.c                  |  234 +++++-----
 arch/arm/mach-davinci/gpio.c                 |  160 ++++---
 arch/arm/mach-davinci/include/mach/common.h  |   32 +-
 arch/arm/mach-davinci/include/mach/cp_intc.h |    3 +-
 arch/arm/mach-davinci/include/mach/cputype.h |    8 +
 arch/arm/mach-davinci/include/mach/da8xx.h   |   29 +-
 arch/arm/mach-davinci/include/mach/dm355.h   |    3 +
 arch/arm/mach-davinci/include/mach/dm365.h   |    4 +
 arch/arm/mach-davinci/include/mach/dm644x.h  |    6 +
 arch/arm/mach-davinci/include/mach/dm646x.h  |    4 +-
 arch/arm/mach-davinci/include/mach/gpio.h    |   72 ++--
 arch/arm/mach-davinci/include/mach/irqs.h    |   97 ++++
 arch/arm/mach-davinci/include/mach/mux.h     |  290 +++++++++++-
 arch/arm/mach-davinci/include/mach/psc.h     |   55 ++-
 arch/arm/mach-davinci/include/mach/serial.h  |    1 -
 arch/arm/mach-davinci/include/mach/system.h  |    5 +-
 arch/arm/mach-davinci/io.c                   |   20 +-
 arch/arm/mach-davinci/irq.c                  |    7 +-
 arch/arm/mach-davinci/mux.c                  |   19 +-
 arch/arm/mach-davinci/mux.h                  |    2 +-
 arch/arm/mach-davinci/psc.c                  |   10 +-
 arch/arm/mach-davinci/serial.c               |   34 +-
 arch/arm/mach-davinci/time.c                 |   37 +-
 drivers/rtc/Kconfig                          |   10 +
 drivers/rtc/Makefile                         |    1 +
 drivers/rtc/rtc-davinci.c                    |  673 ++++++++++++++++++++++++++
 50 files changed, 1813 insertions(+), 664 deletions(-)
 create mode 100644 drivers/rtc/rtc-davinci.c
