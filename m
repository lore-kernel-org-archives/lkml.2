Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab1HDAJo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 20:09:44 -0400
Received: from plexity.net ([206.123.115.38]:43701 "EHLO plexity.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755928Ab1HDAJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 20:09:38 -0400
Date: Wed, 3 Aug 2011 17:09:38 -0700
From: Deepak Saxena <dsaxena@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] Remove CLOCK_TICK_RATE from tsc code
Message-ID: <20110804000938.GE23503@plexity.net>
Reply-To: dsaxena@plexity.net
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The tsc code uses CLOCK_TICK_RATE which on x86
is defined to just be the same as PIT_TICK_RATE.
This patch updates the code use the later
as we want to depecrate and remove the global
CLOCK_TICK_RATE symbol.

Signed-off-by: Deepak Saxena <dsaxena@linaro.org>
---
 arch/x86/kernel/tsc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index db48336..1e88c8e 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -178,11 +178,11 @@ static unsigned long calc_pmtimer_ref(u64 deltatsc, u64 pm1, u64 pm2)
 }
 
 #define CAL_MS		10
-#define CAL_LATCH	(CLOCK_TICK_RATE / (1000 / CAL_MS))
+#define CAL_LATCH	(PIT_TICK_RATE / (1000 / CAL_MS))
 #define CAL_PIT_LOOPS	1000
 
 #define CAL2_MS		50
-#define CAL2_LATCH	(CLOCK_TICK_RATE / (1000 / CAL2_MS))
+#define CAL2_LATCH	(PIT_TICK_RATE / (1000 / CAL2_MS))
 #define CAL2_PIT_LOOPS	5000
 
 
-- 
1.7.4.1

