Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758390Ab2IEJ7o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 05:59:44 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:55251 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752399Ab2IEJ7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 05:59:42 -0400
From: Loic Pallardy <loic.pallardy-ext@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.com>
Cc: Lee Jones <lee.jones@linaro.org>, Loic Pallardy <loic.pallardy@gmail.com>,
        LT ST-Ericsson <st-ericsson@lists.linaro.org>,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        Loic Pallardy <loic.pallardy-ext@stericsson.com>
Subject: [PATCH 00/17] Add ST-Ericsson U9540 support
Date: Wed, 5 Sep 2012 11:58:56 +0200
Message-ID: <1346839153-6465-1-git-send-email-loic.pallardy-ext@stericsson.com>
X-Mailer: git-send-email 1.7.11.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following patch series contains board files and prcmu driver modifications
to support ST-Ericsson U9540 chipset and CCU9540 board configuration.
It includes:
 - mfd db8500-prmcu: adaptation to support new chipset
 - mfd dbx540-prmcu: creation for u9540 platform
 - arm ux500: add u9540 chipset definition

Best regards,
Loic

Loic Pallardy (17):
  arm: ux500: add u9540 pin configuration
  arm: ux500: add ccu9540 board support
  arm: ux500: Create board-specific IRQ init callback
  mfd: dbx500-prcmu: Introduce TCDM mapping struct
  mfd: dbx500-prcmu: Handle TCDM mapping
  arm: ux500: Add u9540 PRCMU TCDM configuration
  mfd: prcmu: configurable tcdm base address
  arm: ux500: update DB internal irq nb
  mfd: prcmu: add db9540 support
  mfd: prcmu: dbx500-prmcu creation
  mfd: pcrmu: create common header file for legacy mailbox
  mfd: prcmu: make fw_project_name generic
  mfd: prcmu: make legacy mailbox services configurable
  mfd: db8500-prcmu: use db8500 legacy services
  mfd: dbx540-prcmu creation
  arm: ux500: add dbx540 prcmu platform data
  mfd: db8500-prcmu: activate dbx540-prcmu driver

 arch/arm/mach-ux500/board-mop500-pins.c    |  200 ++
 arch/arm/mach-ux500/board-mop500-sdi.c     |   12 +
 arch/arm/mach-ux500/board-mop500.c         |   67 +-
 arch/arm/mach-ux500/board-mop500.h         |    2 +
 arch/arm/mach-ux500/cpu-db8500.c           |   18 +-
 arch/arm/mach-ux500/cpu.c                  |    4 +-
 arch/arm/mach-ux500/include/mach/devices.h |    6 +
 arch/arm/mach-ux500/include/mach/irqs.h    |    2 +-
 drivers/mfd/Kconfig                        |   21 +
 drivers/mfd/Makefile                       |    2 +
 drivers/mfd/db8500-prcmu.c                 | 1161 ++++++------
 drivers/mfd/dbx500-prcmu-regs.h            |    1 +
 drivers/mfd/dbx500-prcmu.c                 |  815 ++++++++
 drivers/mfd/dbx500-prcmu.h                 |  465 +++++
 drivers/mfd/dbx540-prcmu-regs.h            |  106 ++
 drivers/mfd/dbx540-prcmu.c                 | 2807 ++++++++++++++++++++++++++++
 include/linux/mfd/db8500-prcmu.h           |  274 +--
 include/linux/mfd/dbx500-prcmu.h           |  593 +++---
 include/linux/mfd/dbx540-prcmu.h           |   96 +
 19 files changed, 5455 insertions(+), 1197 deletions(-)
 create mode 100644 drivers/mfd/dbx500-prcmu.c
 create mode 100644 drivers/mfd/dbx500-prcmu.h
 create mode 100644 drivers/mfd/dbx540-prcmu-regs.h
 create mode 100644 drivers/mfd/dbx540-prcmu.c
 create mode 100644 include/linux/mfd/dbx540-prcmu.h

-- 
1.7.11.1

