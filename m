Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993Ab2GMFWZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 01:22:25 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:51468 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453Ab2GMFWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 01:22:24 -0400
From: John Stultz <john.stultz@linaro.org>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 0/8] Time fixes and cleanups for 3.6
Date: Fri, 13 Jul 2012 01:21:49 -0400
Message-Id: <1342156917-25092-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071305-7282-0000-0000-00000AE1D551
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas,
	Since you're offline next week, I wanted to send you my updated
queue for the 3.6 merge window.

These are mostly the same changes I sent you with my earlier 3.6 pull
request mid-last month, but reordered and trimmed down to focus on
cleanups (no new features).

There is one NTP bug fix, from a change in 3.4, but given its non critical
and we're late in the 3.5-rc cycle, I wanted to hold it off for 3.6 and
backport it once merged.

Since these expect the leapsecond hrtimer/time changes currently in
tip/timers/urgent, it is based off of that branch, rather then
tip/timers/core. Although  tip/timers/core merges fairly cleanly (there's
only a minor collision with already upstream 3.5 changes).

Let me know if these look ok. With the exception of the NTP fix, the rest
can wait till 3.7 if you'd prefer, so they're nothing urgent.

thanks
-john

CC: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Richard Cochran <richardcochran@gmail.com>
CC: Prarit Bhargava <prarit@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>

If you want to git pull:
The following changes since commit 5baefd6d84163443215f4a99f6a20f054ef11236:

  hrtimer: Update hrtimer base offsets each hrtimer_interrupt (2012-07-11 23:34:39 +0200)

are available in the git repository at:

  git://git.linaro.org/people/jstultz/linux.git fortglx/3.6/time

for you to fetch changes up to 96dbf98929ac690a7d0d0ad54cf24631763da16c:

  time: Rework timekeeping functions to take timekeeper ptr as argument (2012-07-13 01:15:46 -0400)

----------------------------------------------------------------
John Stultz (8):
      ntp: Fix STA_INS/DEL clearing bug
      time: Whitespace cleanups per Ingo's requests
      time: Explicitly use u32 instead of int for shift values
      time: Condense timekeeper.xtime into xtime_sec
      time: Refactor accumulation of nsecs to secs
      time: Move arch_gettimeoffset() usage into timekeeping_get_ns()
      time: Move xtime_nsec adjustment underflow handling timekeeping_adjust
      time: Rework timekeeping functions to take timekeeper ptr as argument

 kernel/time/ntp.c         |    8 +-
 kernel/time/timekeeping.c |  492 ++++++++++++++++++++++++---------------------
 2 files changed, 273 insertions(+), 227 deletions(-)

