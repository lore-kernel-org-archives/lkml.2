Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145Ab1GGMYz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 08:24:55 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:35246 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863Ab1GGMYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 08:24:53 -0400
From: Vitaly Kuzmichev <vkuzmichev@mvista.com>
To: linux-arm-kernel@lists.infradead.org, linux-watchdog@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Wim Van Sebroeck <wim@iguana.be>, Marc Zyngier <marc.zyngier@arm.com>,
        Colin Cross <ccross@android.com>
Cc: linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
        Nicolas Pitre <nico@fluxnic.net>, Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuzmichev <vkuzmichev@mvista.com>
Subject: [PATCH V3 0/4] ARM: smp_twd: mpcore_wdt: Fix MPCORE watchdog setup
Date: Thu,  7 Jul 2011 16:22:19 +0400
Message-Id: <1310041339-2348-1-git-send-email-vkuzmichev@mvista.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1286185540-19569-1-git-send-email-vkuzmichev@mvista.com>
References: <1286185540-19569-1-git-send-email-vkuzmichev@mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The series of patches fixes various bugs in ARM MPCORE watchdog setup.
They also introduce some changes in common SMP_TWD timer setup code.
The PATCH V3 2/4 adds an exported function to obtain twd timer rate in
mpcore_wdt. It was decided that this solution is the best at this time,
and later it will be removed while conversion smp_twd driver into
the clocksource/arm_smp_twd as well as calibration loop will be replaced
by smp_twd clock. The mpcore_wdt will also use clk interface instead.

In comparing with V2 series this (V3) is based on linux-2.6/master branch.
Also the patches PATCH V2 5/6 and PATCH V2 6/6 were thrown out since they
are useless with current swp_twd driver.
Also it was decided to keep PATCH V2 3/6 as is due to upcoming restructuring
of watchdog drivers, but added parentheses inside 'if' condition.

Vitaly Kuzmichev (4):
  ARM: smp_twd: Fix typo in 'twd_timer_rate' printing
  ARM: smp_twd: mpcore_wdt: Fix watchdog counter loading
  ARM: mpcore_wdt: Fix WDIOC_SETOPTIONS handling
  ARM: mpcore_wdt: Fix timer mode setup

 arch/arm/include/asm/smp_twd.h |    7 +++++++
 arch/arm/kernel/smp_twd.c      |    9 ++++++++-
 drivers/watchdog/mpcore_wdt.c  |   22 ++++++++++++++--------
 3 files changed, 29 insertions(+), 9 deletions(-)

-- 
1.7.3.4

