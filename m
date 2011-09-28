Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110Ab1I1Wjq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:39:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53712 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755753Ab1I1Wjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:39:44 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:31 2011
Message-Id: <20110928220131.253506838@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:00:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Subject: [057/244] alarmtimers: Avoid possible null pointer traversal
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: John Stultz <john.stultz@linaro.org>

commit 971c90bfa2f0b4fe52d6d9002178d547706f1343 upstream.

We don't check if old_setting is non null before assigning it, so
correct this.

CC: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/time/alarmtimer.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -479,11 +479,8 @@ static int alarm_timer_set(struct k_itim
 	if (!rtcdev)
 		return -ENOTSUPP;
 
-	/* Save old values */
-	old_setting->it_interval =
-			ktime_to_timespec(timr->it.alarmtimer.period);
-	old_setting->it_value =
-			ktime_to_timespec(timr->it.alarmtimer.node.expires);
+	if (old_setting)
+		alarm_timer_get(timr, old_setting);
 
 	/* If the timer was already set, cancel it */
 	alarm_cancel(&timr->it.alarmtimer);


