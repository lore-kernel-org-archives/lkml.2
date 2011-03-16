Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167Ab1CPWkD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 18:40:03 -0400
Received: from sncsmrelay2.nai.com ([67.97.80.206]:13892 "EHLO
	sncsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab1CPWj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 18:39:58 -0400
Date: Thu, 17 Mar 2011 08:36:17 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-ID: <201103162236.p2GMaH7N000376@goober.internal.moreton.com.au>
CC: <gerg@uclinux.org>, <linux-kernel@vger.kernel.org>,
        <linux-m68k@vger.kernel.org>
Subject: [git pull] m68knommu arch fixes
To: <torvalds@linux-foundation.org>
X-Mailer: mail (GNU Mailutils 2.1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Can you please pull the m68knommu git tree, for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-linus

There is quite a few changes in here, but major themes are:

. interrupt irq_chip converted to new functions
. cleanup, extension and optimization of irq handling functions
. clean up compiler warnings in ColdFire GPIO initializers
. rationalize use of various ColdFire internal peripheral base registers
. simplify ColdFire bus clock divider setting

Thanks
Greg



The following changes since commit 521cb40b0c44418a4fd36dc633f575813d59a43d:
  Linus Torvalds (1):
        Linux 2.6.38

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-linus

Alexander Kurz (1):
      m68knommu: fixing compiler warnings

Greg Ungerer (30):
      m68knommu: move ColdFire 5249 MBAR2 definition
      m68knommu: remove kludge seting of MCF_IPSBAR for ColdFire 54xx
      m68knommu: remove bogus definition of MBAR for ColdFire 532x family
      m68knommu: move ColdFire PIT timer base addresses
      m68knommu: remove MBAR and IPSBAR hacks for the ColdFire 520x CPUs
      m68knommu: remove use of MBAR value for ColdFire 523x peripheral addressing
      m68knommu: remove use of MBAR value for ColdFire 527x peripheral addressing
      m68knommu: remove use of MBAR value for ColdFire 528x peripheral addressing
      m68knommu: move ColdFire DMA register addresses to per-cpu headers
      m68knommu: remove use of MBAR in old-style ColdFire timer
      m68knommu: clean up use of MBAR for DRAM registers on ColdFire start
      m68knommu: clean up definitions of ColdFire peripheral base registers
      m68knommu: make ColdFire internal peripheral region configurable
      m68knommu: add basic support for the ColdFire based FireBee board
      m68knommu: limit interrupts supported by ColdFire intc-2 driver
      m68knommu: move some init code out of unmask routine for ColdFire intc-2
      m68knommu: limit interrupts supported by ColdFire intc-simr driver
      m68knommu: fix gpio warnings for ColdFire 5206 targets
      m68knommu: fix gpio warnings for ColdFire 5206e targets
      m68knommu: fix gpio warnings for ColdFire 520x targets
      m68knommu: fix gpio warnings for ColdFire 523x targets
      m68knommu: fix gpio warnings for ColdFire 5249 targets
      m68knommu: fix gpio warnings for ColdFire 5272 targets
      m68knommu: fix gpio warnings for ColdFire 527x targets
      m68knommu: fix gpio warnings for ColdFire 5307 targets
      m68knommu: fix gpio warnings for ColdFire 532x targets
      m68knommu: fix gpio warnings for ColdFire 5407 targets
      m68knommu: remove ColdFire CLOCK_DIV config option
      m68knommu: external interrupt support to ColdFire intc-2 controller
      m68knommu: external interrupt support to ColdFire intc-simr controller

Thomas Gleixner (10):
      m68knommu: 5772: Replace private irq flow handler
      m68knommu: Convert coldfire intc irq_chip to new
      m68knommu: Convert coldfire intc-2 irq_chip to new
      m68knommu: Convert coldfire intc-simr irq_chip to new
      m68knommu: Convert 68328 ints irq_chip to new functions
      m68knommu: Convert 68360 ints irq_chip to new functions
      m68knommu: Convert 5272 intc irq_chip to new functions
      m68knommu: Convert 5249 intc irq_chip to new functions
      m68knommu: Use proper irq_desc accessors in
      m68knommu: Select GENERIC_HARDIRQS_NO_DEPRECATED

 arch/m68k/include/asm/coldfire.h             |   42 ++--
 arch/m68k/include/asm/m5206sim.h             |   23 ++-
 arch/m68k/include/asm/m520xsim.h             |   50 +++--
 arch/m68k/include/asm/m523xsim.h             |   52 ++++-
 arch/m68k/include/asm/m5249sim.h             |   30 ++-
 arch/m68k/include/asm/m5272sim.h             |    8 +
 arch/m68k/include/asm/m527xsim.h             |   68 ++++--
 arch/m68k/include/asm/m528xsim.h             |   44 +++-
 arch/m68k/include/asm/m5307sim.h             |   25 ++-
 arch/m68k/include/asm/m532xsim.h             |    9 +
 arch/m68k/include/asm/m5407sim.h             |   25 ++-
 arch/m68k/include/asm/m54xxsim.h             |   14 +-
 arch/m68k/include/asm/mcfdma.h               |   23 --
 arch/m68k/include/asm/mcfpit.h               |   16 +--
 arch/m68k/include/asm/mcftimer.h             |   23 --
 arch/m68knommu/Kconfig                       |   58 ++++-
 arch/m68knommu/kernel/irq.c                  |    6 +-
 arch/m68knommu/platform/5206/gpio.c          |    6 +-
 arch/m68knommu/platform/5206e/gpio.c         |    6 +-
 arch/m68knommu/platform/520x/config.c        |   36 ++--
 arch/m68knommu/platform/520x/gpio.c          |   96 ++++----
 arch/m68knommu/platform/523x/config.c        |   10 +-
 arch/m68knommu/platform/523x/gpio.c          |  136 ++++++------
 arch/m68knommu/platform/5249/gpio.c          |   12 +-
 arch/m68knommu/platform/5249/intc2.c         |   20 +-
 arch/m68knommu/platform/5272/gpio.c          |   18 +-
 arch/m68knommu/platform/5272/intc.c          |   33 ++--
 arch/m68knommu/platform/527x/config.c        |   14 +-
 arch/m68knommu/platform/527x/gpio.c          |  312 +++++++++++++-------------
 arch/m68knommu/platform/528x/config.c        |   14 +-
 arch/m68knommu/platform/528x/gpio.c          |  210 +++++++++---------
 arch/m68knommu/platform/5307/gpio.c          |    6 +-
 arch/m68knommu/platform/532x/gpio.c          |  166 +++++++-------
 arch/m68knommu/platform/5407/gpio.c          |    6 +-
 arch/m68knommu/platform/54xx/Makefile        |    1 +
 arch/m68knommu/platform/54xx/firebee.c       |   86 +++++++
 arch/m68knommu/platform/68328/ints.c         |   12 +-
 arch/m68knommu/platform/68360/ints.c         |   18 +-
 arch/m68knommu/platform/coldfire/dma.c       |    8 +-
 arch/m68knommu/platform/coldfire/head.S      |   10 +-
 arch/m68knommu/platform/coldfire/intc-2.c    |  176 +++++++++++----
 arch/m68knommu/platform/coldfire/intc-simr.c |  165 ++++++++++++---
 arch/m68knommu/platform/coldfire/intc.c      |   20 +-
 arch/m68knommu/platform/coldfire/pit.c       |    2 +-
 arch/m68knommu/platform/coldfire/timers.c    |    4 +-
 45 files changed, 1284 insertions(+), 835 deletions(-)
 create mode 100644 arch/m68knommu/platform/54xx/firebee.c
