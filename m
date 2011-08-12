Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061Ab1HLI1z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 04:27:55 -0400
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:50193 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750992Ab1HLI1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 04:27:52 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Vijaya Kumar Kilari <vijay.kilari@stericsson.com>,
        Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>,
        Philippe Langlais <philippe.langlais@stericsson.com>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Jonas Aberg <jonas.aberg@stericsson.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Pawel Szyszuk <pawel.szyszuk@stericsson.com>,
        Jimmy Rubin <jimmy.rubin@stericsson.com>,
        Mattias Nilsson <mattias.i.nilsson@stericsson.com>
Subject: [PATCH 00/23] mfd: DBx500 PRCMU updates
Date: Fri, 12 Aug 2011 10:26:59 +0200
Message-ID: <1313137619-30580-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

The following patchset refactors and updates the MFD PRCMU
(Power Reset Control Management Unit) drivers for DBx500.

Mainly there is a bulk of refactoring work from Mattias
Nilsson unifying the APIs, so the implementations can
share a common API despite their individual differences.

The rest is mainly updates, added accessor functions for
various things the PRCMU can handle. Notice that all of
these are accessors, mediators, so clearly in the MFD
domain. The consumers of the interfaces are in the
platform and e.g. the CPUfreq and voltage domain drivers
as can be seen in the refactorings.

Then we include some refactorings of the PRCMU
voltage domain regulator driver and a new DB5500 power
domain regulator driver as part of this patchset as well.
I'm harvesting ACKs from the regulator people for these,
hoping to merge the entire shebang through Sam's MFD
tree.

Thanks,
Linus Walleij

Bengt Jonsson (3):
  mfd/db8500-prcmu: hwacc power state accessor
  mfd/db8500-prcmu: voltage domain consumers
  regulator/dbx500-prcmu: factor out common code

Jonas Aberg (1):
  mfd/db8500-prcmu: add watchdog accessor functions

Linus Walleij (2):
  mfd/db5500-prcmu: fix defines
  mfd/db5500-prcmu: convert to platform device

Mattias Nilsson (7):
  mfd/db8500-prcmu: refactor DB8500 PRCMU reg access
  mfd/db8500-prcmu: extend DB8500 PRCMU mailbox defs
  mfd/db8500-prcmu: initialize DB8500 PRCMU regs
  mfd/dbx500-prcmu: create a common interface
  mfd/dbx500-prcmu: move to the new API
  mfd/db8500-prcmu: add accessors for PLL and SGA clock
  mfd/db8500-prcmu: tweak for modem wakeup

Pawel Szyszuk (1):
  mfd/db5500-prcmu: implement reset and cause

Philippe Langlais (2):
  mfd/db5500-prcmu: spawn MFD cell for regulator
  regulator/db5500-prcmu: add driver

Rabin Vincent (1):
  mfd/db5500-prcmu: implement clock handling

Sebastian Rasmussen (1):
  mfd/db8500-prcmu: reset code retrieval

Shreshtha Kumar Sahu (2):
  mfd/db5500-prcmu: update mailbox handling
  mfd/db5500-prcmu: implement OPP handling

Vijaya Kumar Kilari (3):
  mfd/db5500-prcmu: implement event handling
  mfd/db5500-prcmu: sleep handling
  mfd/db5500-prcmu: implement EPOD handling

 arch/arm/mach-ux500/Kconfig                    |    1 +
 arch/arm/mach-ux500/cpu-db5500.c               |    5 +
 arch/arm/mach-ux500/cpu.c                      |    2 +-
 arch/arm/mach-ux500/include/mach/irqs-db5500.h |   29 +
 drivers/cpufreq/db8500-cpufreq.c               |    2 +-
 drivers/mfd/db5500-prcmu-regs.h                |  115 ---
 drivers/mfd/db5500-prcmu.c                     | 1090 +++++++++++++++++++++++-
 drivers/mfd/db8500-prcmu-regs.h                |  166 ----
 drivers/mfd/db8500-prcmu.c                     |  616 +++++++++++---
 drivers/mfd/dbx500-prcmu-regs.h                |  204 +++++
 drivers/regulator/Kconfig                      |   12 +
 drivers/regulator/Makefile                     |    2 +
 drivers/regulator/db5500-prcmu.c               |  351 ++++++++
 drivers/regulator/db8500-prcmu.c               |   45 +-
 drivers/regulator/dbx500-prcmu.c               |   62 ++
 drivers/regulator/dbx500-prcmu.h               |   18 +
 include/linux/mfd/db5500-prcmu.h               |  102 ++-
 include/linux/mfd/db8500-prcmu.h               |  368 ++-------
 include/linux/mfd/dbx500-prcmu.h               |  549 ++++++++++++
 include/linux/regulator/db5500-prcmu.h         |   25 +
 20 files changed, 2997 insertions(+), 767 deletions(-)
 delete mode 100644 drivers/mfd/db5500-prcmu-regs.h
 delete mode 100644 drivers/mfd/db8500-prcmu-regs.h
 create mode 100644 drivers/mfd/dbx500-prcmu-regs.h
 create mode 100644 drivers/regulator/db5500-prcmu.c
 create mode 100644 drivers/regulator/dbx500-prcmu.c
 create mode 100644 drivers/regulator/dbx500-prcmu.h
 create mode 100644 include/linux/mfd/dbx500-prcmu.h
 create mode 100644 include/linux/regulator/db5500-prcmu.h

-- 
1.7.3.2

