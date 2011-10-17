Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329Ab1JQS6s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 14:58:48 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39938 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667Ab1JQS6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 14:58:47 -0400
From: Dan McGee <dpmcgee@gmail.com>
To: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] timekeeping: fix bogus comment in timekeeping_get_ns_raw
Date: Mon, 17 Oct 2011 13:58:43 -0500
Message-Id: <1318877923-17792-1-git-send-email-dpmcgee@gmail.com>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The whole point of this function is to return a value not touched by
NTP; unfortunately the comment got copied wholesale without adjustment
from the timekeeping_get_ns function above.

Signed-off-by: Dan McGee <dpmcgee@gmail.com>
---
 kernel/time/timekeeping.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 2b021b0e..a5846a8 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -131,7 +131,7 @@ static inline s64 timekeeping_get_ns_raw(void)
 	/* calculate the delta since the last update_wall_time: */
 	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
 
-	/* return delta convert to nanoseconds using ntp adjusted mult. */
+	/* return delta convert to nanoseconds. */
 	return clocksource_cyc2ns(cycle_delta, clock->mult, clock->shift);
 }
 
-- 
1.7.7

