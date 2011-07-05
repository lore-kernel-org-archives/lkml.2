Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619Ab1GETDQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 15:03:16 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:43824 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab1GETDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 15:03:15 -0400
From: Vitaly Kuzmichev <vkuzmichev@mvista.com>
To: linux-arm-kernel@lists.infradead.org, linux-watchdog@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Marc Zyngier <marc.zyngier@arm.com>, Wim Van Sebroeck <wim@iguana.be>
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, John Stultz <johnstul@us.ibm.com>,
        Nicolas Pitre <nico@fluxnic.net>, Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuzmichev <vkuzmichev@mvista.com>
Subject: [PATCH V2 1/6] arm_smp_twd: Fix typo in 'twd_timer_rate' printing
Date: Tue,  5 Jul 2011 23:00:35 +0400
Message-Id: <1309892440-3260-2-git-send-email-vkuzmichev@mvista.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1286185540-19569-1-git-send-email-vkuzmichev@mvista.com>
References: <1286185540-19569-1-git-send-email-vkuzmichev@mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To get hundredths of MHz the rate needs to be divided by 10'000.
Here is an example:
 twd_timer_rate = 123456789
 Before:
    twd_timer_rate / 1000000 = 123
    (twd_timer_rate / 1000000) % 100 = 23
    Result: 123.23MHz.
 Now:
    twd_timer_rate / 1000000 = 123
    (twd_timer_rate / 10000) % 100 = 45
    Result: 123.45MHz.

Signed-off-by: Vitaly Kuzmichev <vkuzmichev@mvista.com>
---
 drivers/clocksource/arm_smp_twd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/clocksource/arm_smp_twd.c b/drivers/clocksource/arm_smp_twd.c
index 60c8022..6acbdac 100644
--- a/drivers/clocksource/arm_smp_twd.c
+++ b/drivers/clocksource/arm_smp_twd.c
@@ -176,7 +176,7 @@ static void __cpuinit twd_calibrate_rate(void)
 		twd_timer_rate = (0xFFFFFFFFU - count) * (HZ / 5);
 
 		printk("%lu.%02luMHz.\n", twd_timer_rate / 1000000,
-			(twd_timer_rate / 1000000) % 100);
+			(twd_timer_rate / 10000) % 100);
 	}
 }
 
-- 
1.7.3.4

