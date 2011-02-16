Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145Ab1BPGfj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 01:35:39 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:58671 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027Ab1BPGfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 01:35:01 -0500
From: John Stultz <johnstul@us.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3/6] alpha: convert to clocksource_register_hz
Date: Tue, 15 Feb 2011 22:34:49 -0800
Message-Id: <1297838092-22989-4-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1297838092-22989-1-git-send-email-johnstul@us.ibm.com>
References: <1297838092-22989-1-git-send-email-johnstul@us.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Converts alpha to use clocksource_register_hz.

Patch is untested, so help from maintainers would be appreciated.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
CC: Richard Henderson <rth@twiddle.net>
CC: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
CC: Matt Turner <mattst88@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>
---
 arch/alpha/kernel/time.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/alpha/kernel/time.c b/arch/alpha/kernel/time.c
index c1f3e7c..33b8110 100644
--- a/arch/alpha/kernel/time.c
+++ b/arch/alpha/kernel/time.c
@@ -378,8 +378,7 @@ static struct clocksource clocksource_rpcc = {
 
 static inline void register_rpcc_clocksource(long cycle_freq)
 {
-	clocksource_calc_mult_shift(&clocksource_rpcc, cycle_freq, 4);
-	clocksource_register(&clocksource_rpcc);
+	clocksource_register_hz(&clocksource_rpcc, cycle_freq);
 }
 #else /* !CONFIG_SMP */
 static inline void register_rpcc_clocksource(long cycle_freq)
-- 
1.7.3.2.146.gca209

