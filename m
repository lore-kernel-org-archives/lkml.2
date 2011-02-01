Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646Ab1BAJV4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 04:21:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:45532 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754505Ab1BAJVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 04:21:53 -0500
Date: Tue, 1 Feb 2011 09:21:33 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torbenh@gmx.de, peterz@infradead.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torbenh@gmx.de, peterz@infradead.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110127145905.23248.30458.stgit@localhost>
References: <20110127145905.23248.30458.stgit@localhost>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] time: Fix legacy arch fallout
Message-ID: <tip-7cf37e87dd2cfa17a64f28ea7f31eed4525f79e4@git.kernel.org>
Git-Commit-ID: 7cf37e87dd2cfa17a64f28ea7f31eed4525f79e4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 01 Feb 2011 09:21:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7cf37e87dd2cfa17a64f28ea7f31eed4525f79e4
Gitweb:     http://git.kernel.org/tip/7cf37e87dd2cfa17a64f28ea7f31eed4525f79e4
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 1 Feb 2011 09:34:58 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 1 Feb 2011 09:46:47 +0100

time: Fix legacy arch fallout

The xtime/dotimer cleanup broke architectures which do not implement
clockevents. Time to send out another __do_IRQ threat.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reported-by: Ingo Molnar <mingo@elte.hu>
Cc: Torben Hohn <torbenh@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: johnstul@us.ibm.com
Cc: yong.zhang0@gmail.com
Cc: hch@infradead.org
LKML-Reference: <20110127145905.23248.30458.stgit@localhost>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/time/tick-internal.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
index 28c5785..f77b93d 100644
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -4,6 +4,8 @@
 #include <linux/hrtimer.h>
 #include <linux/tick.h>
 
+#ifdef CONFIG_GENERIC_CLOCKEVENTS_BUILD
+
 #define TICK_DO_TIMER_NONE	-1
 #define TICK_DO_TIMER_BOOT	-2
 
@@ -135,5 +137,7 @@ static inline int tick_device_is_functional(struct clock_event_device *dev)
 	return !(dev->features & CLOCK_EVT_FEAT_DUMMY);
 }
 
+#endif
+
 extern void do_timer(unsigned long ticks);
 extern seqlock_t xtime_lock;
