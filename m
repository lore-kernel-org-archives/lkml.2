Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110Ab2GQV7o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 17:59:44 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:38075 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757097Ab2GQV7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 17:59:34 -0400
Subject: Patch "timekeeping: Add missing update call in timekeeping_resume()" has been added to the 3.4-stable tree
To: johnstul@us.ibm.com, a.p.zijlstra@chello.nl, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Martin@lichtvoll.de, mingo@kernel.org, prarit@redhat.com, rjw@sisk.pl,
        schwab@linux-m68k.org, tglx@linutronix.de,
        torvalds@linux-foundation.org
Cc: <stable@vger.kernel.org>, <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Tue, 17 Jul 2012 14:59:22 -0700
In-Reply-To: <1342507196-54327-8-git-send-email-johnstul@us.ibm.com>
Message-ID: <13425623623837@kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    timekeeping: Add missing update call in timekeeping_resume()

to the 3.4-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     timekeeping-add-missing-update-call-in-timekeeping_resume.patch
and it can be found in the queue-3.4 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


>From johnstul@us.ibm.com  Tue Jul 17 14:27:38 2012
From: John Stultz <johnstul@us.ibm.com>
Date: Tue, 17 Jul 2012 02:39:56 -0400
Subject: timekeeping: Add missing update call in timekeeping_resume()
To: stable@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>, Linux PM list <linux-pm@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Prarit Bhargava <prarit@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <1342507196-54327-8-git-send-email-johnstul@us.ibm.com>


From: Thomas Gleixner <tglx@linutronix.de>

This is a backport of 3e997130bd2e8c6f5aaa49d6e3161d4d29b43ab0

The leap second rework unearthed another issue of inconsistent data.

On timekeeping_resume() the timekeeper data is updated, but nothing
calls timekeeping_update(), so now the update code in the timer
interrupt sees stale values.

This has been the case before those changes, but then the timer
interrupt was using stale data as well so this went unnoticed for quite
some time.

Add the missing update call, so all the data is consistent everywhere.

Reported-by: Andreas Schwab <schwab@linux-m68k.org>
Reported-and-tested-by: "Rafael J. Wysocki" <rjw@sisk.pl>
Reported-and-tested-by: Martin Steigerwald <Martin@lichtvoll.de>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
Cc: Prarit Bhargava <prarit@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/timekeeping.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -719,6 +719,7 @@ static void timekeeping_resume(void)
 	timekeeper.clock->cycle_last = timekeeper.clock->read(timekeeper.clock);
 	timekeeper.ntp_error = 0;
 	timekeeping_suspended = 0;
+	timekeeping_update(false);
 	write_sequnlock_irqrestore(&timekeeper.lock, flags);
 
 	touch_softlockup_watchdog();


Patches currently in stable-queue which might be from johnstul@us.ibm.com are

queue-3.4/timekeeping-fix-leapsecond-triggered-load-spike-issue.patch
queue-3.4/hrtimer-update-hrtimer-base-offsets-each-hrtimer_interrupt.patch
queue-3.4/timekeeping-add-missing-update-call-in-timekeeping_resume.patch
queue-3.4/hrtimers-move-lock-held-region-in-hrtimer_interrupt.patch
queue-3.4/hrtimer-provide-clock_was_set_delayed.patch
queue-3.4/timekeeping-provide-hrtimer-update-function.patch
queue-3.4/timekeeping-maintain-ktime_t-based-offsets-for-hrtimers.patch
