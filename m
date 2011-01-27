Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab1A0O7e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 09:59:34 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:45634 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752395Ab1A0O7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 09:59:31 -0500
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX18C/lNBJAUCdgDZmHoPhbeMfkPzNQEm77Cy6CcxjJ
	ZAOaEnakyQENhE
Subject: [PATCH v2 07/20] arm/mach-clps711x: switch do_timer() to
	xtime_update()
To: LKML <linux-kernel@vger.kernel.org>
From: Torben Hohn <torbenh@gmx.de>
Cc: Russell King <linux@arm.linux.org.uk>,
        Peter Zijlstra <peterz@infradead.org>, johnstul@us.ibm.com,
        hch@infradead.org, yong.zhang0@gmail.com,
        Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 27 Jan 2011 15:59:26 +0100
Message-ID: <20110127145926.23248.56369.stgit@localhost>
In-Reply-To: <20110127145741.23248.68098.stgit@localhost>
References: <20110127145741.23248.68098.stgit@localhost>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_timer() requires holding the xtime_lock, which this
code did not do.
use the safe version xtime_update()

Cc: Russell King <linux@arm.linux.org.uk>
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

