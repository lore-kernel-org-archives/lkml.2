Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab2DPWBW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 18:01:22 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:56227 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754824Ab2DPWBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 18:01:20 -0400
Message-ID: <4F8CC0E4.5030706@xenotime.net>
Date: Mon, 16 Apr 2012 18:01:24 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Greg KH <greg@kroah.com>, Brian Swetland <swetland@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, devel@driverdev.osuosl.org
Subject: [PATCH -next] staging: fix android alarm.c printk format warnings
References: <20120416161121.261ba4e7e38989173accfb16@canb.auug.org.au>
In-Reply-To: <20120416161121.261ba4e7e38989173accfb16@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix printk format warnings by using 't' modifier for ptrdiff_t.

drivers/staging/android/alarm.c:344:2: warning: format '%ld' expects type 'long int', but argument 2 has type 'int'
drivers/staging/android/alarm.c:367:3: warning: format '%ld' expects type 'long int', but argument 2 has type 'int'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Greg KH <greg@kroah.com>
Cc: Brian Swetland <swetland@google.com>
---
 drivers/staging/android/alarm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20120416.orig/drivers/staging/android/alarm.c
+++ linux-next-20120416/drivers/staging/android/alarm.c
@@ -341,7 +341,7 @@ static enum hrtimer_restart alarm_timer_
 	now = base->stopped ? base->stopped_time : hrtimer_cb_get_time(timer);
 	now = ktime_sub(now, base->delta);
 
-	pr_alarm(INT, "alarm_timer_triggered type %ld at %lld\n",
+	pr_alarm(INT, "alarm_timer_triggered type %td at %lld\n",
 		base - alarms, ktime_to_ns(now));
 
 	while (base->first) {
@@ -364,7 +364,7 @@ static enum hrtimer_restart alarm_timer_
 		spin_lock_irqsave(&alarm_slock, flags);
 	}
 	if (!base->first)
-		pr_alarm(FLOW, "no more alarms of type %ld\n", base - alarms);
+		pr_alarm(FLOW, "no more alarms of type %td\n", base - alarms);
 	update_timer_locked(base, true);
 	spin_unlock_irqrestore(&alarm_slock, flags);
 	return HRTIMER_NORESTART;
