Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759436Ab1FXOhw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 10:37:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:56641 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758274Ab1FXOhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 10:37:48 -0400
Date: Fri, 24 Jun 2011 14:35:09 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-51928d12a6e07a1bd7b38d8b151a50cb24175dd3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, hpa@zytor.com,
        mingo@redhat.com, ralf@linux-mips.org, linux@arm.linux.org.uk,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, john.stultz@linaro.org,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        ralf@linux-mips.org, tglx@linutronix.de
In-Reply-To: <20110609130622.348437125@linutronix.de>
References: <20110609130622.348437125@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/cleanup] i8253: Cleanup outb/inb magic
Git-Commit-ID: 51928d12a6e07a1bd7b38d8b151a50cb24175dd3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 24 Jun 2011 14:36:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  51928d12a6e07a1bd7b38d8b151a50cb24175dd3
Gitweb:     http://git.kernel.org/tip/51928d12a6e07a1bd7b38d8b151a50cb24175dd3
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 9 Jun 2011 13:08:30 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 24 Jun 2011 16:22:55 +0200

i8253: Cleanup outb/inb magic

Remove the hysterical outb/inb_pit defines and use outb_p/inb_p in the
code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: John Stultz <john.stultz@linaro.org>
Link: http://lkml.kernel.org/r/20110609130622.348437125@linutronix.de
---
 arch/x86/kernel/apm_32.c |    6 +++---
 include/linux/i8253.h    |    3 ---
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index a30740e..0371c48 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -1220,11 +1220,11 @@ static void reinit_timer(void)
 
 	raw_spin_lock_irqsave(&i8253_lock, flags);
 	/* set the clock to HZ */
-	outb_pit(0x34, PIT_MODE);		/* binary, mode 2, LSB/MSB, ch 0 */
+	outb_p(0x34, PIT_MODE);		/* binary, mode 2, LSB/MSB, ch 0 */
 	udelay(10);
-	outb_pit(LATCH & 0xff, PIT_CH0);	/* LSB */
+	outb_p(LATCH & 0xff, PIT_CH0);	/* LSB */
 	udelay(10);
-	outb_pit(LATCH >> 8, PIT_CH0);	/* MSB */
+	outb_p(LATCH >> 8, PIT_CH0);	/* MSB */
 	udelay(10);
 	raw_spin_unlock_irqrestore(&i8253_lock, flags);
 #endif
diff --git a/include/linux/i8253.h b/include/linux/i8253.h
index 76039c8..0770fc5 100644
--- a/include/linux/i8253.h
+++ b/include/linux/i8253.h
@@ -20,9 +20,6 @@
 
 #define PIT_LATCH	((PIT_TICK_RATE + HZ/2) / HZ)
 
-#define inb_pit         inb_p
-#define outb_pit        outb_p
-
 extern raw_spinlock_t i8253_lock;
 
 extern void setup_pit_timer(void);
