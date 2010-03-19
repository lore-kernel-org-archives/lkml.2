Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486Ab0CSK2K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 06:28:10 -0400
Received: from adelie.canonical.com ([91.189.90.139]:58716 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844Ab0CSK2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 06:28:08 -0400
Subject: Re: [PATCH] softlockup: stop spurious softlockup messages due to
 overflow
From: Colin Ian King <colin.king@canonical.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <1268945110.2894.162.camel@edumazet-laptop>
References: <1268661673-21638-1-git-send-email-colin.king@canonical.com>
	 <1268663388.3154.30.camel@edumazet-laptop> <20100316101251.GM7961@elte.hu>
	 <1268918537.1894.143.camel@lenovo>  <20100318152535.GB12564@elte.hu>
	 <1268945110.2894.162.camel@edumazet-laptop>
Content-Type: multipart/mixed; boundary="=-1//oDxJmM6O9VWgbzA9D"
Date: Fri, 19 Mar 2010 10:28:02 +0000
Message-ID: <1268994482.1798.6.camel@lenovo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-1//oDxJmM6O9VWgbzA9D
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Re-submitted, thanks for you feedback.

--=-1//oDxJmM6O9VWgbzA9D
Content-Disposition: attachment; filename*0=0001-PATCH-softlockup-stop-spurious-softlockup-messages-d.pat; filename*1=ch
Content-Type: text/x-patch; name="0001-PATCH-softlockup-stop-spurious-softlockup-messages-d.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From d640e08bfba1abdd1a82f0f11cbde62f29b3f423 Mon Sep 17 00:00:00 2001
From: Colin Ian King <colin.king@canonical.com>
Date: Fri, 19 Mar 2010 10:17:03 +0000
Subject: [PATCH] softlockup: stop spurious softlockup messages due to overflow

Ensure additions on touch_ts do not overflow.  This can occur when
the top 32 bits of the TSC reach 0xffffffff causing additions to
touch_ts to overflow and this in turn generates spurious softlockup
warnings.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Cc: stable@kernel.org
---
 kernel/softlockup.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/softlockup.c b/kernel/softlockup.c
index 0d4c789..4b493f6 100644
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -155,11 +155,11 @@ void softlockup_tick(void)
 	 * Wake up the high-prio watchdog task twice per
 	 * threshold timespan.
 	 */
-	if (now > touch_ts + softlockup_thresh/2)
+	if (time_after(now - softlockup_thresh/2, touch_ts))
 		wake_up_process(per_cpu(softlockup_watchdog, this_cpu));
 
 	/* Warn about unreasonable delays: */
-	if (now <= (touch_ts + softlockup_thresh))
+	if (time_before_eq(now - softlockup_thresh, touch_ts))
 		return;
 
 	per_cpu(softlockup_print_ts, this_cpu) = touch_ts;
-- 
1.6.3.3


--=-1//oDxJmM6O9VWgbzA9D--

