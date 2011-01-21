Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088Ab1AVAOx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 19:14:53 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:38697 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755070Ab1AVAOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 19:14:52 -0500
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX19FLvBkIWtFSu4KBoE4MRSdpiuWkDU3IFNV2d+qpx
	MWP4ThYD87pM4X
From: Torben Hohn <torbenh@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, johnstul@us.ibm.com, hch@infradead.org,
        yong.zhang0@gmail.com, Torben Hohn <torbenh@gmx.de>
Subject: [PATCH 17/18] xtensa: switch do_timer() to xtime_update()
Date: Sat, 22 Jan 2011 00:07:03 +0100
Message-Id: <1295651224-29823-18-git-send-email-torbenh@gmx.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1295651224-29823-1-git-send-email-torbenh@gmx.de>
References: <1295651224-29823-1-git-send-email-torbenh@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xtime_update() takes the xtime_lock itself.

i dont believe that set_linux_timer() needs to be protected by a lock.

Signed-off-by: Torben Hohn <torbenh@gmx.de>
---
 arch/xtensa/kernel/time.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/arch/xtensa/kernel/time.c b/arch/xtensa/kernel/time.c
index 19df764..f3e5eb4 100644
--- a/arch/xtensa/kernel/time.c
+++ b/arch/xtensa/kernel/time.c
@@ -96,16 +96,12 @@ again:
 		update_process_times(user_mode(get_irq_regs()));
 #endif
 
-		write_seqlock(&xtime_lock);
-
-		do_timer(1); /* Linux handler in kernel/timer.c */
+		xtime_update(1); /* Linux handler in kernel/time/timekeeping */
 
 		/* Note that writing CCOMPARE clears the interrupt. */
 
 		next += CCOUNT_PER_JIFFY;
 		set_linux_timer(next);
-
-		write_sequnlock(&xtime_lock);
 	}
 
 	/* Allow platform to do something useful (Wdog). */
-- 
1.7.2.3

