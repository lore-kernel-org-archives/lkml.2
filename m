Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab1JYSMK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 14:12:10 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:49202 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752975Ab1JYSMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 14:12:08 -0400
From: y@kernel.beaverton.ibm.com
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5/8] clocksource: cris: Convert to clocksource_register_khz
Date: Tue, 25 Oct 2011 11:08:13 -0700
Message-Id: <1319566096-3222-5-git-send-email-y>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1319566096-3222-1-git-send-email-y>
References: <1319566096-3222-1-git-send-email-y>
x-cbid: 11102518-5930-0000-0000-000000912DC0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Stultz <johnstul@us.ibm.com>

This converts the cris architecture to use clocksource_register_khz

This is untested, so any help from maintainers would be appreciated.

CC: Mikael Starvik <starvik@axis.com>
CC: Jesper Nilsson <jesper.nilsson@axis.com>
CC: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 arch/cris/arch-v32/kernel/time.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/cris/arch-v32/kernel/time.c b/arch/cris/arch-v32/kernel/time.c
index bb978ed..6773fc8 100644
--- a/arch/cris/arch-v32/kernel/time.c
+++ b/arch/cris/arch-v32/kernel/time.c
@@ -47,14 +47,12 @@ static struct clocksource cont_rotime = {
 	.rating = 300,
 	.read   = read_cont_rotime,
 	.mask   = CLOCKSOURCE_MASK(32),
-	.shift  = 10,
 	.flags  = CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
 static int __init etrax_init_cont_rotime(void)
 {
-	cont_rotime.mult = clocksource_khz2mult(100000, cont_rotime.shift);
-	clocksource_register(&cont_rotime);
+	clocksource_register_khz(&cont_rotime, 100000);
 	return 0;
 }
 arch_initcall(etrax_init_cont_rotime);
-- 
1.7.3.2.146.gca209

