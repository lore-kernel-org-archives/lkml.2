Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832Ab1KOEEY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 23:04:24 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:33516 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755697Ab1KOEEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 23:04:22 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH 00/16] Timekeeping cleanups and locking changes
Date: Mon, 14 Nov 2011 20:03:50 -0800
Message-Id: <1321329846-14755-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
x-cbid: 11111504-8974-0000-0000-000002145755
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas,

THIS IS PATCHWAR!

After your 7 patch patchbomb reworking much of the timekeeping locking
from this morning, I decided such aggression will not stand.

So here's 16 patches, some are your patches, just lobbed back, targeting
strategic locations of your inbox.

Its all pretty rough, and the whole set likely needs some refactoring, but
I wanted to let you see my take on your approach. Much of this are changes
I've intended to get to, but have just been too busy of late.

I also included a similar shadow-update trick to reduce the lock 
hold times, but as noted in the patch, I'm still worried about the
likely race there, and we need to do some further vetting to ensure
it really can't cause trouble (as well as warnings to anyone trying 
to later understand the rational there).

I also still need to refactor the update_vsyscall implementations to
utilize the xsec_nsec, so we can avoid truncation issues without 
mucking with the ntp_error code.

Anyway, let me know what you think.

-john

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Richard Cochran <richardcochran@gmail.com>


Patches are also available here:
(Fair warning, I may rebase the following branch)

 git://git.linaro.org/people/jstultz/linux.git dev/xtime-breakup


John Stultz (14):
  time: Move total_sleep_time into the timekeeper structure
  time: Move wall_to_monotonic into the timekeeper structure
  time: Move xtime into timekeeeper structure
  time: Move raw_time into timekeeper structure
  time: Cleanup global variables and move them to the top
  time: Add timekeeper lock
  ntp: Cleanup timex.h
  ntp: Access tick_length variable via ntp_tick_length()
  ntp: Add ntp_lock to replace xtime_locking
  time: Remove most of xtime_lock usage in timekeeping.c
  time: Condense timekeeper.xtime into xtime_sec
  time: Rework timekeeping functions to take timekeeper ptr as argument
  time: Update tiemkeeper structure using a local shadow
  time: Rework update_vsyscall to pass timekeeper

Thomas Gleixner (2):
  time: Reorder so the hot data is together
  time: Move common updates to a function

 arch/ia64/kernel/time.c       |   28 ++--
 arch/powerpc/kernel/time.c    |   25 +-
 arch/s390/kernel/time.c       |   18 +-
 arch/x86/kernel/vsyscall_64.c |   21 +-
 include/linux/clocksource.h   |    9 -
 include/linux/timekeeper.h    |   75 +++++++
 include/linux/timex.h         |   17 +--
 kernel/time/ntp.c             |   83 ++++++--
 kernel/time/timekeeping.c     |  494 +++++++++++++++++++++--------------------
 9 files changed, 442 insertions(+), 328 deletions(-)
 create mode 100644 include/linux/timekeeper.h

-- 
1.7.3.2.146.gca209

