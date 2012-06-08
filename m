Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762016Ab2FHITu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 04:19:50 -0400
Received: from www.linutronix.de ([62.245.132.108]:57588 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761558Ab2FHITo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 04:19:44 -0400
Date: Fri, 8 Jun 2012 10:19:42 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] timer fixes for 3.5
Message-ID: <alpine.LFD.2.02.1206081018260.3086@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest timers-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-urgent-for-linus

Thanks,

	tglx

------------------>
John Stultz (1):
      timekeeping: Fix CLOCK_MONOTONIC inconsistency during leapsecond


 kernel/time/timekeeping.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 6e46cac..6f46a00 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -962,6 +962,7 @@ static cycle_t logarithmic_accumulation(cycle_t offset, int shift)
 		timekeeper.xtime.tv_sec++;
 		leap = second_overflow(timekeeper.xtime.tv_sec);
 		timekeeper.xtime.tv_sec += leap;
+		timekeeper.wall_to_monotonic.tv_sec -= leap;
 	}
 
 	/* Accumulate raw time */
@@ -1077,6 +1078,7 @@ static void update_wall_time(void)
 		timekeeper.xtime.tv_sec++;
 		leap = second_overflow(timekeeper.xtime.tv_sec);
 		timekeeper.xtime.tv_sec += leap;
+		timekeeper.wall_to_monotonic.tv_sec -= leap;
 	}
 
 	timekeeping_update(false);
