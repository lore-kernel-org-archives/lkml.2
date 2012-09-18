Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932698Ab2IRDNN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 23:13:13 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:48170 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932371Ab2IRDNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 23:13:10 -0400
From: John Stultz <john.stultz@linaro.org>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@google.com>,
        Colin Cross <ccross@google.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 0/3][RFC] Alarmtimer fixes (hopefully 3.7 material)
Date: Mon, 17 Sep 2012 23:12:52 -0400
Message-Id: <1347937975-34169-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
x-cbid: 12091803-5112-0000-0000-00000C7DFD2D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arve Hjønnevåg reported numerous crashes from the
"BUG_ON(timer->state != HRTIMER_STATE_CALLBACK)" check
in __run_hrtimer after it called alarmtimer_fired.

Looking at the code, I realized much of the logic duplicated
the hrtimer code, and that by multiplexing numerous alarmtimers
onto a single hrtimer didn't really gain us anything over just
using an hrtimer per alarmtimer. Especially given the various
ways hrtimer actions can fail.

So this patchset tries to simplify some of the alarmtimer code
by utilizing the hrtimer logic in a more direct manner.
Followed then by a few cleanup patches.

I've done some brief testing with some simpler test cases,
but I'd appreciate any additional testing or review.

I'm hoping to resubmit this so it can go in for 3.7.

thanks
-john

Cc: Arve Hjønnevåg <arve@google.com>
Cc: Colin Cross <ccross@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>

John Stultz (3):
  alarmtimer: Use hrtimer per-alarm instead of per-base
  alarmtimer: Remove unused helpers & defines
  alarmtimer: Rename alarmtimer_remove to alarmtimer_dequeue

 include/linux/alarmtimer.h |   31 +-------------
 kernel/time/alarmtimer.c   |   99 +++++++++++++-------------------------------
 2 files changed, 31 insertions(+), 99 deletions(-)

-- 
1.7.9.5

