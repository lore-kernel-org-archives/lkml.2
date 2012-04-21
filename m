Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab2DUJLj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 05:11:39 -0400
Received: from smtp4.mail.ru ([94.100.176.44]:48089 "EHLO smtp4.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753204Ab2DUJK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 05:10:28 -0400
From: Alexander Shiyan <shc_work@mail.ru>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH 13/17] ARM clps711x: Removed unused header mach/time.h
Date: Sat, 21 Apr 2012 13:11:26 +0400
Message-Id: <1334999490-27177-14-git-send-email-shc_work@mail.ru>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1334999490-27177-1-git-send-email-shc_work@mail.ru>
References: <1334999490-27177-1-git-send-email-shc_work@mail.ru>
X-Spam: Not detected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All functions from this header already provided by common.c

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 arch/arm/mach-clps711x/include/mach/time.h |   49 ----------------------------
 1 files changed, 0 insertions(+), 49 deletions(-)
 delete mode 100644 arch/arm/mach-clps711x/include/mach/time.h

diff --git a/arch/arm/mach-clps711x/include/mach/time.h b/arch/arm/mach-clps711x/include/mach/time.h
deleted file mode 100644
index 5f65865..0000000
--- a/arch/arm/mach-clps711x/include/mach/time.h
+++ /dev/null
@@ -1,49 +0,0 @@
-/*
- *  arch/arm/mach-clps711x/include/mach/time.h
- *
- *  Copyright (C) 2000 Deep Blue Solutions Ltd.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- */
-#include <asm/leds.h>
-#include <mach/hardware.h>
-
-extern void clps711x_setup_timer(void);
-
-/*
- * IRQ handler for the timer
- */
-static irqreturn_t
-p720t_timer_interrupt(int irq, void *dev_id)
-{
-	struct pt_regs *regs = get_irq_regs();
-	do_leds();
-	xtime_update(1);
-#ifndef CONFIG_SMP
-	update_process_times(user_mode(regs));
-#endif
-	do_profile(regs);
-	return IRQ_HANDLED;
-}
-
-/*
- * Set up timer interrupt, and return the current time in seconds.
- */
-void __init time_init(void)
-{
-	clps711x_setup_timer();
-	timer_irq.handler = p720t_timer_interrupt;
-	setup_irq(IRQ_TC2OI, &timer_irq);
-}
-- 
1.7.3.4

