Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932630Ab2HVOaX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 10:30:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:57712 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756761Ab2HVOaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 10:30:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Will Deacon <will.deacon@arm.com>
Subject: [PATCH 1/4] ARM: export read_current_timer
Date: Wed, 22 Aug 2012 16:29:37 +0200
Message-Id: <1345645780-2749-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1345645780-2749-1-git-send-email-arnd@arndb.de>
References: <1345645780-2749-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:jsG2V2QtdXovjnhR6YlCzr3oo+O9JmsKDiiypcy0iF7
 5ym9l6QKO4b86yRfb+oaXSb9OItRPEI9cd9NRIGzE7YuIntK4S
 NI0JJfwkgjXG7r3LkbSQjNHN5Le1CaUVUUZq4/BVFGteP7bXLx
 SvTVZDJ3KxAGxEBpkU/ictkYv1jhhZgUa2Qsj8uuFbwYARjck6
 /KZT3yWBci5aBXCCH38g0ywbKv0nx9VwPKXa6QnuoqAg50AS7o
 21xQmju8xI9cRqkP1URJpd1BuDEJmUZcLDqq8yiwb2L2ok1d2y
 srhyx8a+WRfD4Y3frBaAMRsSnon14nwNjsI1Uz5E0XmROGCLjb
 mgkHynk+OuS28Z4VkSjMJ1/QRRmo5kUhLEdR2HArnYF8Vr9xrP
 xs/sPPQSMWNcg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

read_current_timer is used in the get_cycles() function when
ARM_ARCH_TIMER is set, and that function can be inlined into
driver modules, so we should export the function to avoid
errors like

ERROR: "read_current_timer" [drivers/video/udlfb.ko] undefined!
ERROR: "read_current_timer" [crypto/tcrypt.ko] undefined!

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
---
 arch/arm/kernel/arch_timer.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/kernel/arch_timer.c b/arch/arm/kernel/arch_timer.c
index cf25880..6327d1f 100644
--- a/arch/arm/kernel/arch_timer.c
+++ b/arch/arm/kernel/arch_timer.c
@@ -14,6 +14,7 @@
 #include <linux/device.h>
 #include <linux/smp.h>
 #include <linux/cpu.h>
+#include <linux/export.h>
 #include <linux/jiffies.h>
 #include <linux/clockchips.h>
 #include <linux/interrupt.h>
@@ -232,6 +233,7 @@ int read_current_timer(unsigned long *timer_val)
 	*timer_val = arch_counter_get_cntpct();
 	return 0;
 }
+EXPORT_SYMBOL_GPL(read_current_timer);
 
 static struct clocksource clocksource_counter = {
 	.name	= "arch_sys_counter",
-- 
1.7.10

