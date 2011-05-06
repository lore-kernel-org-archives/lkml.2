Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab1EFNF1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 09:05:27 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:45894 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753625Ab1EFNFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 09:05:25 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 00/10] Ux500 PRCMU into MFD and update deps
Date: Fri, 6 May 2011 15:04:50 +0200
Message-ID: <1304687090-23401-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This moves the DB8500 PRCMU driver from the arch/arm/mach-ux500/
dir to MFD, updates it, adds the missing DB5500 PRCMU driver,
updates some dependent register files etc, and also updates the
CPUfreq driver that use the PRCMU and moves it to drivers/cpufreq
as discussed recently.

I will attempt to slim this down a bit, mainly the set is a
review point for the MFD maintainer to check out if the PRCMU
driver fits within MFD.

We cannot avoid doing some updates to the mach-ux500/* files in
the process, but I think this turns out on the positive side
anyway, removing some 500+ lines from arch/arm/*.

Bengt Jonsson (1):
  mach-ux500: voltage domain regulators for DB8500

Linus Walleij (8):
  mach-ux500: update the DB8500 register file
  mach-ux500: update the DB5500 register file
  mach-ux500: update ASIC version detection
  mach-ux500: rename PRCMU driver per SoC
  mach-ux500: make PRCMU base address dynamic
  mfd: move DB8500 PRCMU driver to the MFD subsystem
  mfd: add DB5500 PRCMU driver
  mach-ux500: update and move cpufreq driver

Rabin Vincent (1):
  mach-ux500: update SoC and board IRQ handling

 arch/arm/mach-ux500/Kconfig                        |    3 +
 arch/arm/mach-ux500/Makefile                       |    4 +-
 arch/arm/mach-ux500/cpu-db5500.c                   |    2 +
 arch/arm/mach-ux500/cpu-db8500.c                   |    7 +
 arch/arm/mach-ux500/cpu.c                          |    7 +-
 arch/arm/mach-ux500/cpufreq.c                      |  211 --
 arch/arm/mach-ux500/include/mach/db5500-regs.h     |   20 +-
 arch/arm/mach-ux500/include/mach/db8500-regs.h     |   37 +-
 arch/arm/mach-ux500/include/mach/hardware.h        |    1 +
 arch/arm/mach-ux500/include/mach/id.h              |   20 +
 .../mach-ux500/include/mach/irqs-board-mop500.h    |    5 +
 .../arm/mach-ux500/include/mach/irqs-board-u5500.h |   21 +
 arch/arm/mach-ux500/include/mach/irqs-db5500.h     |   27 +
 arch/arm/mach-ux500/include/mach/irqs-db8500.h     |   54 +
 arch/arm/mach-ux500/include/mach/irqs.h            |   46 +-
 arch/arm/mach-ux500/include/mach/prcmu-defs.h      |   30 -
 arch/arm/mach-ux500/include/mach/prcmu.h           |   28 -
 arch/arm/mach-ux500/prcmu.c                        |  394 ----
 drivers/cpufreq/Makefile                           |    1 +
 drivers/cpufreq/db8500-cpufreq.c                   |  169 ++
 drivers/mfd/Kconfig                                |   22 +-
 drivers/mfd/Makefile                               |    5 +-
 drivers/mfd/ab8500-i2c.c                           |    3 +-
 .../mfd/db5500-prcmu-regs.h                        |   27 +-
 drivers/mfd/db5500-prcmu.c                         |  448 +++++
 drivers/mfd/db8500-prcmu-regs.h                    |  162 ++
 drivers/mfd/db8500-prcmu.c                         | 2065 ++++++++++++++++++++
 drivers/regulator/Kconfig                          |    7 +
 drivers/regulator/Makefile                         |    1 +
 drivers/regulator/db8500-prcmu.c                   |  560 ++++++
 include/linux/mfd/db5500-prcmu.h                   |   45 +
 include/linux/mfd/db8500-prcmu.h                   |  978 +++++++++
 include/linux/regulator/db8500-prcmu.h             |   45 +
 33 files changed, 4748 insertions(+), 707 deletions(-)
 delete mode 100644 arch/arm/mach-ux500/cpufreq.c
 create mode 100644 arch/arm/mach-ux500/include/mach/irqs-board-u5500.h
 delete mode 100644 arch/arm/mach-ux500/include/mach/prcmu-defs.h
 delete mode 100644 arch/arm/mach-ux500/include/mach/prcmu.h
 delete mode 100644 arch/arm/mach-ux500/prcmu.c
 create mode 100644 drivers/cpufreq/db8500-cpufreq.c
 rename arch/arm/mach-ux500/include/mach/prcmu-regs.h => drivers/mfd/db5500-prcmu-regs.h (80%)
 create mode 100644 drivers/mfd/db5500-prcmu.c
 create mode 100644 drivers/mfd/db8500-prcmu-regs.h
 create mode 100644 drivers/mfd/db8500-prcmu.c
 create mode 100644 drivers/regulator/db8500-prcmu.c
 create mode 100644 include/linux/mfd/db5500-prcmu.h
 create mode 100644 include/linux/mfd/db8500-prcmu.h
 create mode 100644 include/linux/regulator/db8500-prcmu.h

-- 
1.7.3.2

