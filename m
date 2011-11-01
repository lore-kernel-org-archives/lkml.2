Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932757Ab1KBCXO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 22:23:14 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:49324 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932623Ab1KBCXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 22:23:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL 4/13] arm-soc timer updates
Date: Tue, 1 Nov 2011 04:24:12 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <201111010348.13214.arnd@arndb.de>
In-Reply-To: <201111010348.13214.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111010424.12300.arnd@arndb.de>
X-Provags-ID: V02:K0:rFhjqW5UJzg6tPZcWi999ZKqhlFRS9daR30InvW3q6Q
 0/966YYieJz8/sWyQKAaBPorl2adfscPr+1g5mutz7fY3g9nMk
 IHsCitcA06tkttCikf0hiJ4K45gtOl3OPhXX3LMJNzx/MvSoWQ
 v6iVAbrUj+6tAZNuQ6ExnWvhchlxxHz1j+zB+t+KvvlmIJvnlW
 qNuUSIOrhtYeWp76ZNfUwUdQSFni36oa8O0yyo5nkczzBcPFxx
 +tn5U3i33zmWs8ru/XYgf8bwpkL915KnjVtO60LqUJPKJc8BQN
 DiCdQRnCY9rY262dHE6nCnSquDZAcD/ATzbG/ouWeN7OBcgZ1L
 CFnn/9+RqIOTw/KNdlbM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a combination of two timer-related series, one for the omap dmtimer,
the other one for the nomadik/ux500 clocksource.

	Arnd

The following changes since commit 272c49c77acee0b6975b7a4164adaf517cf3cd3d:

  Merge branch 'next/driver' into for-next (2011-11-01 00:37:15 +0100)

are available in the git repository at:

  git://git.linaro.org/people/arnd/arm-soc.git next/timer

Arnd Bergmann (3):
      ARM: omap: use __devexit_p in dmtimer driver
      Merge branches 'stericsson/timer' and 'omap/dmtimer' into next/timer
      Merge branch 'stericsson/cleanup' into next/timer

Jonas Aaberg (4):
      ARM: ux500: Move timer code to separate file
      ARM: plat-nomadik: timer: Add support for periodic timers
      ARM: plat-nomadik: timer: Export reset functions
      ARM: ux500: Reprogram timers upon resume

Linus Walleij (1):
      clocksource: fixup ux500 build problems

Mattias Wallin (3):
      ARM: plat-nomadik: MTU sched_clock as an option
      clocksource: add DBX500 PRCMU Timer support
      ARM: ux500: add support for clocksource DBX500 PRCMU

Tarun Kanti DebBarma (8):
      ARM: OMAP2+: dmtimer: add device names to flck nodes
      ARM: OMAP1: dmtimer: conversion to platform devices
      ARM: OMAP2+: dmtimer: convert to platform devices
      ARM: OMAP: dmtimer: platform driver
      ARM: OMAP: dmtimer: switch-over to platform device driver
      ARM: OMAP: dmtimer: pm_runtime support
      ARM: OMAP: dmtimer: low-power mode support
      ARM: OMAP: dmtimer: add error handling to export APIs

Tony Lindgren (2):
      ARM: OMAP: Add support for dmtimer v2 ip
      ARM: OMAP: dmtimer: skip reserved timers

 arch/arm/mach-omap1/Makefile                     |    2 +-
 arch/arm/mach-omap1/timer.c                      |  173 +++++
 arch/arm/mach-omap2/Makefile                     |   81 +--
 arch/arm/mach-omap2/board-2430sdp.c              |    9 +-
 arch/arm/mach-omap2/board-3430sdp.c              |    9 +-
 arch/arm/mach-omap2/board-3630sdp.c              |   11 +-
 arch/arm/mach-omap2/board-4430sdp.c              |    9 +-
 arch/arm/mach-omap2/board-am3517crane.c          |    9 +-
 arch/arm/mach-omap2/board-am3517evm.c            |    8 +-
 arch/arm/mach-omap2/board-apollon.c              |    9 +-
 arch/arm/mach-omap2/board-cm-t35.c               |   13 +-
 arch/arm/mach-omap2/board-cm-t3517.c             |    9 +-
 arch/arm/mach-omap2/board-devkit8000.c           |   12 +-
 arch/arm/mach-omap2/board-generic.c              |    2 +-
 arch/arm/mach-omap2/board-h4.c                   |    9 +-
 arch/arm/mach-omap2/board-igep0020.c             |   13 +-
 arch/arm/mach-omap2/board-ldp.c                  |    9 +-
 arch/arm/mach-omap2/board-n8x0.c                 |   13 +-
 arch/arm/mach-omap2/board-omap3beagle.c          |    4 +-
 arch/arm/mach-omap2/board-omap3evm.c             |    9 +-
 arch/arm/mach-omap2/board-omap3logic.c           |   11 +-
 arch/arm/mach-omap2/board-omap3pandora.c         |   11 +-
 arch/arm/mach-omap2/board-omap3stalker.c         |    9 +-
 arch/arm/mach-omap2/board-omap3touchbook.c       |   11 +-
 arch/arm/mach-omap2/board-omap4panda.c           |    9 +-
 arch/arm/mach-omap2/board-overo.c                |   11 +-
 arch/arm/mach-omap2/board-rm680.c                |   17 +-
 arch/arm/mach-omap2/board-rx51.c                 |   17 +-
 arch/arm/mach-omap2/board-ti8168evm.c            |    9 +-
 arch/arm/mach-omap2/board-zoom.c                 |   23 +-
 arch/arm/mach-omap2/clock2420_data.c             |   48 ++
 arch/arm/mach-omap2/clock2430_data.c             |   48 ++
 arch/arm/mach-omap2/clock3xxx_data.c             |   47 ++-
 arch/arm/mach-omap2/clock44xx_data.c             |   33 +
 arch/arm/mach-omap2/clockdomain.c                |  147 +++--
 arch/arm/mach-omap2/clockdomain.h                |   22 +-
 arch/arm/mach-omap2/clockdomain2xxx_3xxx.c       |    4 -
 arch/arm/mach-omap2/clockdomain44xx.c            |    2 -
 arch/arm/mach-omap2/clockdomains2420_data.c      |  154 +++++
 arch/arm/mach-omap2/clockdomains2430_data.c      |  181 +++++
 arch/arm/mach-omap2/clockdomains2xxx_3xxx_data.c |  803 +---------------------
 arch/arm/mach-omap2/clockdomains3xxx_data.c      |  398 +++++++++++
 arch/arm/mach-omap2/clockdomains44xx_data.c      |  409 +++---------
 arch/arm/mach-omap2/id.c                         |  191 ++----
 arch/arm/mach-omap2/io.c                         |   52 ++-
 arch/arm/mach-omap2/omap_hwmod.c                 |    3 -
 arch/arm/mach-omap2/omap_hwmod_2420_data.c       |   59 +-
 arch/arm/mach-omap2/omap_hwmod_2430_data.c       |   67 +--
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c       |  196 +++---
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c       |  104 +---
 arch/arm/mach-omap2/powerdomain-common.c         |    7 +-
 arch/arm/mach-omap2/powerdomain.c                |   87 ++-
 arch/arm/mach-omap2/powerdomain.h                |    9 +-
 arch/arm/mach-omap2/powerdomains2xxx_3xxx_data.c |   19 +-
 arch/arm/mach-omap2/powerdomains2xxx_data.c      |   44 +-
 arch/arm/mach-omap2/powerdomains3xxx_data.c      |   81 ++-
 arch/arm/mach-omap2/powerdomains44xx_data.c      |   20 +-
 arch/arm/mach-omap2/timer.c                      |  194 +++++-
 arch/arm/mach-ux500/Makefile                     |    3 +-
 arch/arm/mach-ux500/board-mop500-pins.c          |   34 +-
 arch/arm/mach-ux500/board-mop500-sdi.c           |   52 +-
 arch/arm/mach-ux500/board-mop500.c               |   78 ++-
 arch/arm/mach-ux500/board-mop500.h               |    3 +
 arch/arm/mach-ux500/cache-l2x0.c                 |   72 ++
 arch/arm/mach-ux500/cpu.c                        |   98 +---
 arch/arm/mach-ux500/include/mach/db5500-regs.h   |    2 +
 arch/arm/mach-ux500/include/mach/db8500-regs.h   |    3 +
 arch/arm/mach-ux500/include/mach/uncompress.h    |   10 +-
 arch/arm/mach-ux500/pins-db8500.h                |  142 ++--
 arch/arm/mach-ux500/timer.c                      |   68 ++
 arch/arm/plat-nomadik/Kconfig                    |    8 +-
 arch/arm/plat-nomadik/include/plat/mtu.h         |   47 +--
 arch/arm/plat-nomadik/include/plat/pincfg.h      |    5 -
 arch/arm/plat-nomadik/timer.c                    |  138 +++-
 arch/arm/plat-omap/dmtimer.c                     |  713 +++++++++++--------
 arch/arm/plat-omap/include/plat/clock.h          |    2 -
 arch/arm/plat-omap/include/plat/common.h         |    9 +
 arch/arm/plat-omap/include/plat/cpu.h            |  108 +---
 arch/arm/plat-omap/include/plat/dmtimer.h        |  233 +++++--
 arch/arm/plat-omap/include/plat/io.h             |    2 +-
 arch/arm/plat-omap/include/plat/omap_hwmod.h     |    2 -
 drivers/clocksource/Kconfig                      |   15 +
 drivers/clocksource/Makefile                     |    1 +
 drivers/clocksource/clksrc-dbx500-prcmu.c        |  106 +++
 include/linux/clksrc-dbx500-prcmu.h              |   20 +
 85 files changed, 3218 insertions(+), 2726 deletions(-)
 create mode 100644 arch/arm/mach-omap1/timer.c
 create mode 100644 arch/arm/mach-omap2/clockdomains2420_data.c
 create mode 100644 arch/arm/mach-omap2/clockdomains2430_data.c
 create mode 100644 arch/arm/mach-omap2/clockdomains3xxx_data.c
 create mode 100644 arch/arm/mach-ux500/cache-l2x0.c
 create mode 100644 arch/arm/mach-ux500/timer.c
 create mode 100644 drivers/clocksource/clksrc-dbx500-prcmu.c
 create mode 100644 include/linux/clksrc-dbx500-prcmu.h

