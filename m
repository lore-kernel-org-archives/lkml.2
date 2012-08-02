Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab2HBGpH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 02:45:07 -0400
Received: from linux-sh.org ([111.68.239.195]:42669 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368Ab2HBGpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 02:45:05 -0400
Date: Thu, 2 Aug 2012 15:45:00 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 3.6-rc1, round 2.
Message-ID: <20120802064500.GC9596@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 2d534926205db9ffce4bbbde67cb9b2cee4b835c:

  Merge tag 'irqdomain-for-linus' of git://git.secretlab.ca/git/linux-2.6 (2012-07-31 20:44:03 -0700)

are available in the git repository at:


  git://github.com/pmundt/linux-sh tags/sh-for-linus

for you to fetch changes up to 08298f0612e5e369d1da89b92cac5d2c71ddb9af:

  sh: explicitly include sh_dma.h in setup-sh7722.c (2012-08-02 15:37:26 +0900)

----------------------------------------------------------------
SuperH fixes for 3.6-rc1 merge window

----------------------------------------------------------------
Guennadi Liakhovetski (17):
      sh: add fixed voltage regulators to apsh4a3a
      sh: add fixed voltage regulators to apsh4ad0a
      sh: add fixed voltage regulators to magicpanelr2
      sh: add fixed voltage regulators to polaris
      sh: add fixed voltage regulators to sh2007
      sh: add fixed voltage regulators to sh7757lcr
      sh: add fixed voltage regulators to ap325rxa
      sh: add fixed voltage regulators to kfr2r09
      sh: add fixed voltage regulators to migor
      sh: add fixed voltage regulators to rsk
      sh: add fixed voltage regulators to sdk7786
      sh: add fixed voltage regulators to se7724
      sh: ecovec: switch MMC power control to regulators
      sh: select the fixed regulator driver on several boards
      dmaengine: shdma: restore partial transfer calculation
      serial: sh-sci: fix compilation breakage, when DMA is enabled
      sh: explicitly include sh_dma.h in setup-sh7722.c

Kuninori Morimoto (2):
      sh: sh7724: fixup renesas_usbhs clock settings
      sh: ecovec: care CN5 VBUS if USB host mode

Paul Mundt (8):
      sh: pfc: Build fix for pinctrl_remove_gpio_range() changes.
      sh: Fix up recursive fault in oops with unset TTB.
      Merge branches 'sh/urgent' and 'sh/regulator' into sh-latest
      Merge branch 'sh/dmaengine' into sh-latest
      sh: pfc: Fix up init ordering mess.
      Merge branch 'common/pinctrl' into sh-latest
      sh: intc: initial irqdomain support.
      Merge branch 'common/irqdomain' into sh-latest

Shimoda, Yoshihiro (1):
      sh: modify the sh_dmae_slave_config for RSPI in setup-sh7757

 arch/sh/boards/Kconfig                 |  13 ++++
 arch/sh/boards/board-apsh4a3a.c        |  10 +++
 arch/sh/boards/board-apsh4ad0a.c       |  10 +++
 arch/sh/boards/board-magicpanelr2.c    |  10 +++
 arch/sh/boards/board-polaris.c         |  10 +++
 arch/sh/boards/board-sh2007.c          |  12 ++++
 arch/sh/boards/board-sh7757lcr.c       |  14 ++++
 arch/sh/boards/mach-ap325rxa/setup.c   |  21 ++++++
 arch/sh/boards/mach-ecovec24/setup.c   | 125 ++++++++++++++++++++++++++++-----
 arch/sh/boards/mach-kfr2r09/setup.c    |  12 ++++
 arch/sh/boards/mach-migor/setup.c      |  13 ++++
 arch/sh/boards/mach-rsk/setup.c        |  10 +++
 arch/sh/boards/mach-sdk7786/setup.c    |  10 +++
 arch/sh/boards/mach-se/7724/setup.c    |  15 ++++
 arch/sh/include/cpu-sh4/cpu/sh7757.h   |   2 +
 arch/sh/kernel/cpu/sh4a/clock-sh7724.c |   4 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7722.c |   1 +
 arch/sh/kernel/cpu/sh4a/setup-sh7757.c |  14 ++++
 arch/sh/mm/fault.c                     |   8 ++-
 drivers/dma/sh/shdma-base.c            |   9 +++
 drivers/dma/sh/shdma.c                 |  12 ++++
 drivers/sh/intc/Kconfig                |   4 ++
 drivers/sh/intc/Makefile               |   2 +-
 drivers/sh/intc/core.c                 |  11 +--
 drivers/sh/intc/internals.h            |   5 ++
 drivers/sh/intc/irqdomain.c            |  68 ++++++++++++++++++
 drivers/sh/pfc/pinctrl.c               |  34 ++++-----
 drivers/tty/serial/sh-sci.c            |   5 +-
 include/linux/shdma-base.h             |   2 +
 29 files changed, 419 insertions(+), 47 deletions(-)
 create mode 100644 drivers/sh/intc/irqdomain.c
