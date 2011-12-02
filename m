Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab1LAOWR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 09:22:17 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34749 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706Ab1LAOWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 09:22:16 -0500
From: "Yang Honggang (Joseph)" <eagle.rtlinux@gmail.com>
To: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        ganggexiongqi@126.com,
        "Yang Honggang (Joseph)" <eagle.rtlinux@gmail.com>
Subject: [PATCH 1/1] clocksource: In order to leave a margin of 12.5% we should >> 3 not >> 5.
Date: Thu,  1 Dec 2011 22:22:41 -0500
Message-Id: <1322796161-28188-1-git-send-email-eagle.rtlinux@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Yang Honggang (Joseph) <eagle.rtlinux@gmail.com>
---
 kernel/time/clocksource.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index cf52fda..b9bf9d0 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -529,7 +529,7 @@ static u64 clocksource_max_deferment(struct clocksource *cs)
 	 * note a margin of 12.5% is used because this can be computed with
 	 * a shift, versus say 10% which would require division.
 	 */
-	return max_nsecs - (max_nsecs >> 5);
+	return max_nsecs - (max_nsecs >> 3);
 }
 
 #ifndef CONFIG_ARCH_USES_GETTIMEOFFSET
@@ -651,7 +651,7 @@ void __clocksource_updatefreq_scale(struct clocksource *cs, u32 scale, u32 freq)
 	 * ~ 0.06ppm granularity for NTP. We apply the same 12.5%
 	 * margin as we do in clocksource_max_deferment()
 	 */
-	sec = (cs->mask - (cs->mask >> 5));
+	sec = (cs->mask - (cs->mask >> 3));
 	do_div(sec, freq);
 	do_div(sec, scale);
 	if (!sec)
-- 
1.7.2.5

