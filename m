Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875Ab2GJWoG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 18:44:06 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:43458 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754609Ab2GJWn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 18:43:57 -0400
From: John Stultz <johnstul@us.ibm.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Subject: [PATCH 0/6] Fix for leapsecond caused hrtimer/futex issue (updated)
Date: Tue, 10 Jul 2012 18:43:18 -0400
Message-Id: <1341960205-56738-1-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.7.9.5
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071022-4242-0000-0000-000002474F59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Over the weekend, Thomas got a chance to review the leap second fix
in more detail and had a few additional changes he wanted to make
to improve performance as well as style.

So this iteration includes his modifications.

Once merged, I'll be working to get the backports finished as quickly
as I can and sent to -stable.

thanks
-john

CC: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Prarit Bhargava <prarit@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: stable@vger.kernel.org


John Stultz (3):
  hrtimer: Provide clock_was_set_delayed()
  timekeeping: Fix leapsecond triggered load spike issue
  hrtimer: Update hrtimer base offsets each hrtimer_interrupt

Thomas Gleixner (3):
  timekeeping: Maintain ktime_t based offsets for hrtimers
  hrtimer: Move lock held region in hrtimer_interrupt()
  timekeeping: Provide hrtimer update function

 include/linux/hrtimer.h   |    6 ++++-
 kernel/hrtimer.c          |   53 ++++++++++++++++++++++++++------------
 kernel/time/timekeeping.c |   63 +++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 103 insertions(+), 19 deletions(-)

-- 
1.7.9.5

