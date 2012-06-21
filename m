Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412Ab2FUA5w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 20:57:52 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:58333 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571Ab2FUA5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 20:57:50 -0400
Message-ID: <4FE27188.3040402@linaro.org>
Date: Wed, 20 Jun 2012 17:57:44 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: lkml <linux-kernel@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [GIT PULL] Timekeeping changes for 3.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062100-4242-0000-0000-0000020E8FCD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas,

     Just wanted to send a pull request for my current timekeeping queue 
for 3.6.

Let me know if you have any concerns or objections.

thanks
-john

You can find it here against current tip/timers/core:
   git://git.linaro.org/people/jstultz/linux.git fortglx/3.6/time

for you to fetch changes up to 406d3845a5b75129277576034a0b260c90495dc9:

   time: Kill xtime_lock, replacing it with jiffies_lock (2012-06-20 
20:26:58 -0400)

----------------------------------------------------------------
John Stultz (8):
       time: Condense timekeeper.xtime into xtime_sec
       time: Rework timekeeping functions to take timekeeper ptr as argument
       time: Refactor accumulation of nsecs to secs
       time: Whitespace cleanups per Ingo's requests
       time: Explicitly use u32 instead of int for shift values
       time: Move TAI managment into timekeeping core from ntp
       time: Add CLOCK_TAI clockid
       time: Kill xtime_lock, replacing it with jiffies_lock

  drivers/clocksource/i8253.c |    2 +-
  include/linux/jiffies.h     |    3 +-
  include/linux/time.h        |    9 +-
  kernel/posix-timers.c       |   10 +
  kernel/time/jiffies.c       |    6 +-
  kernel/time/ntp.c           |   18 +-
  kernel/time/tick-common.c   |    8 +-
  kernel/time/tick-internal.h |    1 -
  kernel/time/tick-sched.c    |   22 +--
  kernel/time/timekeeping.c   |  461 
++++++++++++++++++++++++++-----------------
  10 files changed, 332 insertions(+), 208 deletions(-)

