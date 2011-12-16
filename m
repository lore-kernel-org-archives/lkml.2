Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032Ab1LPLjq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 06:39:46 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58033 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab1LPLjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 06:39:41 -0500
From: Kelvin Cheung <keguang.zhang@gmail.com>
To: ralf@linux-mips.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Cc: zhzhl555@gmail.com, peppe.cavallaro@st.com, wuzhangjin@gmail.com,
        r0bertz@gentoo.org, Kelvin Cheung <keguang.zhang@gmail.com>
Subject: [PATCH V5 0/4] MIPS: Add support for Loongson1B
Date: Fri, 16 Dec 2011 19:39:00 +0800
Message-Id: <1324035544-2373-1-git-send-email-keguang.zhang@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches add support for Loongson1B.

Changelog:

V5: Add IS_ENABLED() macro for platform devices.

V4: Split the RTC patch, and merge the arch/mips parts into patch 2/4.
    Use 'KSEG1ADDR' instead of 'ioremap()' in registers definitions.

V3: Add RTC device for Loongson1B.

V2: Add Ethernet device for Loongson1B.

V1: Add basic support for Loongson1B.
----------------

Kelvin Cheung (4):
  MIPS: Add CPU support for Loongson1B
  MIPS: Add board support for Loongson1B
  MIPS: Add Makefile and Kconfig for Loongson1B
  MIPS: Add defconfig for Loongson1B

 arch/mips/Kbuild.platforms                       |    1 +
 arch/mips/Kconfig                                |   31 ++++
 arch/mips/configs/ls1b_defconfig                 |   90 ++++++++++++
 arch/mips/include/asm/cpu.h                      |    3 +-
 arch/mips/include/asm/mach-loongson1/irq.h       |   68 +++++++++
 arch/mips/include/asm/mach-loongson1/loongson1.h |   44 ++++++
 arch/mips/include/asm/mach-loongson1/platform.h  |   22 +++
 arch/mips/include/asm/mach-loongson1/prom.h      |   24 +++
 arch/mips/include/asm/mach-loongson1/regs-clk.h  |   33 +++++
 arch/mips/include/asm/mach-loongson1/regs-wdt.h  |   22 +++
 arch/mips/include/asm/mach-loongson1/war.h       |   25 ++++
 arch/mips/include/asm/module.h                   |    2 +
 arch/mips/kernel/cpu-probe.c                     |   15 ++
 arch/mips/kernel/perf_event_mipsxx.c             |    6 +
 arch/mips/kernel/traps.c                         |    1 +
 arch/mips/loongson1/Kconfig                      |   21 +++
 arch/mips/loongson1/Makefile                     |   11 ++
 arch/mips/loongson1/Platform                     |    7 +
 arch/mips/loongson1/common/Makefile              |    5 +
 arch/mips/loongson1/common/clock.c               |  165 ++++++++++++++++++++++
 arch/mips/loongson1/common/irq.c                 |  146 +++++++++++++++++++
 arch/mips/loongson1/common/platform.c            |  102 +++++++++++++
 arch/mips/loongson1/common/prom.c                |   87 ++++++++++++
 arch/mips/loongson1/common/reset.c               |   45 ++++++
 arch/mips/loongson1/common/setup.c               |   29 ++++
 arch/mips/loongson1/ls1b/Makefile                |    5 +
 arch/mips/loongson1/ls1b/board.c                 |   36 +++++
 arch/mips/oprofile/common.c                      |    1 +
 arch/mips/oprofile/op_model_mipsxx.c             |    4 +
 29 files changed, 1050 insertions(+), 1 deletions(-)
 create mode 100644 arch/mips/configs/ls1b_defconfig
 create mode 100644 arch/mips/include/asm/mach-loongson1/irq.h
 create mode 100644 arch/mips/include/asm/mach-loongson1/loongson1.h
 create mode 100644 arch/mips/include/asm/mach-loongson1/platform.h
 create mode 100644 arch/mips/include/asm/mach-loongson1/prom.h
 create mode 100644 arch/mips/include/asm/mach-loongson1/regs-clk.h
 create mode 100644 arch/mips/include/asm/mach-loongson1/regs-wdt.h
 create mode 100644 arch/mips/include/asm/mach-loongson1/war.h
 create mode 100644 arch/mips/loongson1/Kconfig
 create mode 100644 arch/mips/loongson1/Makefile
 create mode 100644 arch/mips/loongson1/Platform
 create mode 100644 arch/mips/loongson1/common/Makefile
 create mode 100644 arch/mips/loongson1/common/clock.c
 create mode 100644 arch/mips/loongson1/common/irq.c
 create mode 100644 arch/mips/loongson1/common/platform.c
 create mode 100644 arch/mips/loongson1/common/prom.c
 create mode 100644 arch/mips/loongson1/common/reset.c
 create mode 100644 arch/mips/loongson1/common/setup.c
 create mode 100644 arch/mips/loongson1/ls1b/Makefile
 create mode 100644 arch/mips/loongson1/ls1b/board.c

