Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181Ab0KAUNV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 16:13:21 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:51168 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753397Ab0KAUNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 16:13:17 -0400
From: John Stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 03/10] cris: convert to clocksource_register_khz
Date: Mon,  1 Nov 2010 13:12:23 -0700
Message-Id: <1288642350-1599-4-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1288642350-1599-1-git-send-email-johnstul@us.ibm.com>
References: <1288642350-1599-1-git-send-email-johnstul@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
index a545211..64a1233 100644
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

