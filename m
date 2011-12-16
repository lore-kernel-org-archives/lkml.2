Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932705Ab1LPTtn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 14:49:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44943 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932601Ab1LPTtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 14:49:24 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Dec 16 11:45:54 2011
Message-Id: <20111216194554.606846120@clark.kroah.org>
User-Agent: quilt/0.50-24.1
Date: Fri, 16 Dec 2011 11:45:01 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Subject: [04/53] alarmtimers: Fix time comparison
In-Reply-To: <20111216194613.GA18395@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit c9c024b3f3e07d087974db4c0dc46217fff3a6c0 upstream.

The expiry function compares the timer against current time and does
not expire the timer when the expiry time is >= now. That's wrong. If
the timer is set for now, then it must expire.

Make the condition expiry > now for breaking out the loop.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/time/alarmtimer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -181,7 +181,7 @@ static enum hrtimer_restart alarmtimer_f
 		struct alarm *alarm;
 		ktime_t expired = next->expires;
 
-		if (expired.tv64 >= now.tv64)
+		if (expired.tv64 > now.tv64)
 			break;
 
 		alarm = container_of(next, struct alarm, node);


