Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124Ab1I1Wju (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:39:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53716 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932112Ab1I1Wjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:39:47 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:31 2011
Message-Id: <20110928220131.350809093@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:00:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Subject: [058/244] alarmtimers: Memset itimerspec passed into alarm_timer_get
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: John Stultz <john.stultz@linaro.org>

commit ea7802f630d356acaf66b3c0b28c00a945fc35dc upstream.

Following common_timer_get, zero out the itimerspec passed in.

CC: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/time/alarmtimer.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -441,6 +441,8 @@ static int alarm_timer_create(struct k_i
 static void alarm_timer_get(struct k_itimer *timr,
 				struct itimerspec *cur_setting)
 {
+	memset(cur_setting, 0, sizeof(struct itimerspec));
+
 	cur_setting->it_interval =
 			ktime_to_timespec(timr->it.alarmtimer.period);
 	cur_setting->it_value =


