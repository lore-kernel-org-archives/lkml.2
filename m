Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758182Ab1EaIbB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 04:31:01 -0400
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:43379 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752383Ab1EaIa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 04:30:57 -0400
From: Mattias Wallin <mattias.wallin@stericsson.com>
To: Thomas Gleixner <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Mattias Wallin <mattias.wallin@stericsson.com>
Subject: [PATCH 0/3] clocksource: add db8500 PRCMU timer
Date: Tue, 31 May 2011 10:29:45 +0200
Message-ID: <1306830585-9457-1-git-send-email-mattias.wallin@stericsson.com>
X-Mailer: git-send-email 1.7.5.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches makes it possible to use the PRCMU timer as clocksource
for the db8500 chip. Previously the Multi Timer Unit (MTU) was used alone
but the MTU block loose power during sleep states so an alternate
clocksource is needed.
These patches also adds a configuration option to use either the MTU or the PRCMU
as the sched_clk.

Mattias Wallin (3):
  plat-nomadik: MTU sched_clock as an option
  clocksource: add DB8500 PRCMU Timer support
  mach-ux500: add support for clocksource DB8500 PRCMU

 arch/arm/mach-ux500/cpu.c                 |    2 +
 arch/arm/plat-nomadik/Kconfig             |    8 ++-
 arch/arm/plat-nomadik/timer.c             |    4 +
 drivers/clocksource/Kconfig               |   15 +++++
 drivers/clocksource/Makefile              |    1 +
 drivers/clocksource/clksrc-db8500-prcmu.c |   89 +++++++++++++++++++++++++++++
 include/linux/clksrc-db8500-prcmu.h       |   17 ++++++
 7 files changed, 135 insertions(+), 1 deletions(-)
 create mode 100644 drivers/clocksource/clksrc-db8500-prcmu.c
 create mode 100644 include/linux/clksrc-db8500-prcmu.h

-- 
1.7.4.3

