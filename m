Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109Ab3ACDZV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 22:25:21 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:61431 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963Ab3ACDZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 22:25:19 -0500
From: Tony Prisk <linux@prisktech.co.nz>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        Tony Prisk <linux@prisktech.co.nz>, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 0/2] Move some mach-vt8500 functions to new directories
Date: Thu,  3 Jan 2013 16:25:08 +1300
Message-Id: <1357183510-8476-1-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two patches move the irq and clocksource code out of mach-vt8500
and into drivers/irqchip and drivers/clocksource respectively.

Because they affect the same files in mach-vt8500 I thought it may be
easier if it goes through arm-soc, but I note Thomas is the maintainer for
both irqchip and clocksource so maybe he wants to take both.

CC: John Stultz <johnstul@us.ibm.com>
CC: Thomas Gleixner <tglx@linutronix.de>

Tony Prisk (2):
  timer: vt8500: Move system timer to clocksource
  irqchip: vt8500: Move irq code to drivers/irqchip

 arch/arm/mach-vt8500/Kconfig       |    1 +
 arch/arm/mach-vt8500/Makefile      |    2 +-
 arch/arm/mach-vt8500/common.h      |   12 +-
 arch/arm/mach-vt8500/irq.c         |  253 ------------------------------------
 arch/arm/mach-vt8500/timer.c       |  184 --------------------------
 arch/arm/mach-vt8500/vt8500.c      |    4 -
 drivers/clocksource/Kconfig        |    3 +
 drivers/clocksource/Makefile       |    1 +
 drivers/clocksource/vt8500_timer.c |  187 ++++++++++++++++++++++++++
 drivers/irqchip/Makefile           |    1 +
 drivers/irqchip/irq-vt8500.c       |  253 ++++++++++++++++++++++++++++++++++++
 11 files changed, 454 insertions(+), 447 deletions(-)
 delete mode 100644 arch/arm/mach-vt8500/irq.c
 delete mode 100644 arch/arm/mach-vt8500/timer.c
 create mode 100644 drivers/clocksource/vt8500_timer.c
 create mode 100644 drivers/irqchip/irq-vt8500.c

-- 
1.7.9.5

