Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab1AaOJz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 09:09:55 -0500
Received: from hera.kernel.org ([140.211.167.34]:42612 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528Ab1AaOJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 09:09:53 -0500
Date: Mon, 31 Jan 2011 14:09:25 GMT
From: tip-bot for Torben Hohn <torbenh@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torbenh@gmx.de, peterz@infradead.org, takata@linux-m32r.org,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torbenh@gmx.de, peterz@infradead.org, tglx@linutronix.de,
        takata@linux-m32r.org
In-Reply-To: <20110127150001.23248.68620.stgit@localhost>
References: <20110127150001.23248.68620.stgit@localhost>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] m32r: Switch from do_timer() to xtime_update()
Message-ID: <tip-7bde2ab7cb51f14c6f6574f0f5a78445f2caed3e@git.kernel.org>
Git-Commit-ID: 7bde2ab7cb51f14c6f6574f0f5a78445f2caed3e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 31 Jan 2011 14:09:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7bde2ab7cb51f14c6f6574f0f5a78445f2caed3e
Gitweb:     http://git.kernel.org/tip/7bde2ab7cb51f14c6f6574f0f5a78445f2caed3e
Author:     Torben Hohn <torbenh@gmx.de>
AuthorDate: Thu, 27 Jan 2011 16:00:01 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 31 Jan 2011 14:55:45 +0100

m32r: Switch from do_timer() to xtime_update()

xtime_update() does proper locking.

Signed-off-by: Torben Hohn <torbenh@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: johnstul@us.ibm.com
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: hch@infradead.org
Cc: yong.zhang0@gmail.com
LKML-Reference: <20110127150001.23248.68620.stgit@localhost>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/m32r/kernel/time.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/m32r/kernel/time.c b/arch/m32r/kernel/time.c
index bda8682..84dd040 100644
--- a/arch/m32r/kernel/time.c
+++ b/arch/m32r/kernel/time.c
@@ -107,15 +107,14 @@ u32 arch_gettimeoffset(void)
 
 /*
  * timer_interrupt() needs to keep up the real-time clock,
- * as well as call the "do_timer()" routine every clocktick
+ * as well as call the "xtime_update()" routine every clocktick
  */
 static irqreturn_t timer_interrupt(int irq, void *dev_id)
 {
 #ifndef CONFIG_SMP
 	profile_tick(CPU_PROFILING);
 #endif
-	/* XXX FIXME. Uh, the xtime_lock should be held here, no? */
-	do_timer(1);
+	xtime_update(1);
 
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(get_irq_regs()));
