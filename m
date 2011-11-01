Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab1KAVdW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 17:33:22 -0400
Received: from plexity.net ([206.123.115.38]:42171 "EHLO plexity.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754914Ab1KAVdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 17:33:16 -0400
Date: Tue, 1 Nov 2011 14:25:16 -0700
From: Deepak Saxena <dsaxena@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] Remove CLOCK_TICK_RATE from mach_timer.h
Message-ID: <20111101212516.GC31143@plexity.net>
Reply-To: dsaxena@plexity.net
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


CLOCK_TICK_RATE is defined as PIT_TICK_RATE on x86 so we
update mach_timers.h to just use the later as we want
to depecrate CLOCK_TICK_RATE.

Signed-off-by: Deepak Saxena <dsaxena@linaro.org>
---
 arch/x86/include/asm/mach_timer.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/mach_timer.h b/arch/x86/include/asm/mach_timer.h
index 8537285..88d0c3c 100644
--- a/arch/x86/include/asm/mach_timer.h
+++ b/arch/x86/include/asm/mach_timer.h
@@ -15,7 +15,7 @@
 
 #define CALIBRATE_TIME_MSEC 30 /* 30 msecs */
 #define CALIBRATE_LATCH	\
-	((CLOCK_TICK_RATE * CALIBRATE_TIME_MSEC + 1000/2)/1000)
+	((PIT_TICK_RATE * CALIBRATE_TIME_MSEC + 1000/2)/1000)
 
 static inline void mach_prepare_counter(void)
 {
-- 
1.7.4.1

