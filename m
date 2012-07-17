Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405Ab2GQWuZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 18:50:25 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40560 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757385Ab2GQWuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 18:50:18 -0400
Subject: Patch "timekeeping: Fix CLOCK_MONOTONIC inconsistency during leapsecond" has been added to the 3.0-stable tree
To: johnstul@us.ibm.com, gregkh@linuxfoundation.org, john.stultz@linaro.org,
        linux-kernel@vger.kernel.org, prarit@redhat.com,
        richardcochran@gmail.com, tglx@linutronix.de
Cc: <stable@vger.kernel.org>, <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Tue, 17 Jul 2012 15:49:58 -0700
In-Reply-To: <1342546438-17534-4-git-send-email-johnstul@us.ibm.com>
Message-ID: <1342565398110@kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    timekeeping: Fix CLOCK_MONOTONIC inconsistency during leapsecond

to the 3.0-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     timekeeping-fix-clock_monotonic-inconsistency-during-leapsecond.patch
and it can be found in the queue-3.0 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


>From johnstul@us.ibm.com  Tue Jul 17 15:24:29 2012
From: John Stultz <johnstul@us.ibm.com>
Date: Tue, 17 Jul 2012 13:33:50 -0400
Subject: timekeeping: Fix CLOCK_MONOTONIC inconsistency during leapsecond
To: stable@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Prarit Bhargava <prarit@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>
Message-ID: <1342546438-17534-4-git-send-email-johnstul@us.ibm.com>


From: John Stultz <john.stultz@linaro.org>

This is a backport of fad0c66c4bb836d57a5f125ecd38bed653ca863a
which resolves a bug the previous commit.

Commit 6b43ae8a61 (ntp: Fix leap-second hrtimer livelock) broke the
leapsecond update of CLOCK_MONOTONIC. The missing leapsecond update to
wall_to_monotonic causes discontinuities in CLOCK_MONOTONIC.

Adjust wall_to_monotonic when NTP inserted a leapsecond.

Reported-by: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Tested-by: Richard Cochran <richardcochran@gmail.com>
Link: http://lkml.kernel.org/r/1338400497-12420-1-git-send-email-john.stultz@linaro.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/timekeeping.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -824,6 +824,7 @@ static cycle_t logarithmic_accumulation(
 		xtime.tv_sec++;
 		leap = second_overflow(xtime.tv_sec);
 		xtime.tv_sec += leap;
+		wall_to_monotonic.tv_sec -= leap;
 	}
 
 	/* Accumulate raw time */
@@ -934,7 +935,7 @@ static void update_wall_time(void)
 		xtime.tv_sec++;
 		leap = second_overflow(xtime.tv_sec);
 		xtime.tv_sec += leap;
-
+		wall_to_monotonic.tv_sec -= leap;
 	}
 
 	/* check to see if there is a new clocksource to use */


Patches currently in stable-queue which might be from johnstul@us.ibm.com are

queue-3.0/timekeeping-fix-leapsecond-triggered-load-spike-issue.patch
queue-3.0/time-move-common-updates-to-a-function.patch
queue-3.0/timekeeping-fix-clock_monotonic-inconsistency-during-leapsecond.patch
queue-3.0/hrtimer-update-hrtimer-base-offsets-each-hrtimer_interrupt.patch
queue-3.0/timekeeping-add-missing-update-call-in-timekeeping_resume.patch
queue-3.0/hrtimers-move-lock-held-region-in-hrtimer_interrupt.patch
queue-3.0/hrtimer-provide-clock_was_set_delayed.patch
queue-3.0/ntp-fix-leap-second-hrtimer-livelock.patch
queue-3.0/timekeeping-provide-hrtimer-update-function.patch
queue-3.0/timekeeping-maintain-ktime_t-based-offsets-for-hrtimers.patch
queue-3.0/ntp-correct-tai-offset-during-leap-second.patch
