Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861Ab1AUXID (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 18:08:03 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:58331 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754327Ab1AUXHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 18:07:23 -0500
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX1+P+RhNXMCPBWuTwEeMGwExPJLlx/Rp9iyMa+HF6D
	g93ohF9MjCt3eT
From: Torben Hohn <torbenh@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, johnstul@us.ibm.com, hch@infradead.org,
        yong.zhang0@gmail.com, Torben Hohn <torbenh@gmx.de>
Subject: [PATCH 05/18] arm/mach-clps711x: switch do_timer() to xtime_update()
Date: Sat, 22 Jan 2011 00:06:51 +0100
Message-Id: <1295651224-29823-6-git-send-email-torbenh@gmx.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1295651224-29823-1-git-send-email-torbenh@gmx.de>
References: <1295651224-29823-1-git-send-email-torbenh@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_timer() requires holding the xtime_lock, which this
code did not do.
use the safe version xtime_update()

Signed-off-by: Torben Hohn <torbenh@gmx.de>
---
 arch/arm/mach-clps711x/include/mach/time.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-clps711x/include/mach/time.h b/arch/arm/mach-clps711x/include/mach/time.h
index 8fe283c..61fef91 100644
--- a/arch/arm/mach-clps711x/include/mach/time.h
+++ b/arch/arm/mach-clps711x/include/mach/time.h
@@ -30,7 +30,7 @@ p720t_timer_interrupt(int irq, void *dev_id)
 {
 	struct pt_regs *regs = get_irq_regs();
 	do_leds();
-	do_timer(1);
+	xtime_update(1);
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(regs));
 #endif
-- 
1.7.2.3

