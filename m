Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759735Ab2CPB1q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 21:27:46 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:49796 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356Ab2CPB1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 21:27:44 -0400
Message-ID: <4F62970C.20501@us.ibm.com>
Date: Thu, 15 Mar 2012 18:27:40 -0700
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: "Gleixner, Thomas" <tglx@linutronix.de>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Time/RTC/clocksource changes for 3.4
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12031601-6148-0000-0000-0000044A27FC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas,
     Here's my current outstanding time/clocksource/rtc queue for 3.4 
(with the exception of the ntp livelock patch I sent out for RFC)
Let me know if you have any objections.

thanks
-john

The following changes since commit 
a078c6d0e6288fad6d83fb6d5edd91ddb7b6ab33:

   ntp: Fix integer overflow when setting time (2012-03-15 21:41:34 +0100)

are available in the git repository at:

   git://git.linaro.org/people/jstultz/linux.git fortglx/3.4/time

Alok Kataria (1):

       x86, tsc: Skip refined tsc calibration on systems with reliable TSC

John Stultz (3):

       time: x86: Fix race switching from vsyscall to non-vsyscall clock

       time: Fix change_clocksource locking

       rtc: Provide flag for rtc devices that don't support UIE

Thomas Gleixner (4):

       time: Remove bogus comments

       x86: vdso: Remove bogus locking in update_vsyscall_tz()

       x86: vdso: Use seqcount instead of seqlock

       ia64: vsyscall: Use seqcount instead of seqlock

  arch/ia64/kernel/asm-offsets.c        |    4 +-

  arch/ia64/kernel/fsys.S               |    2 +-

  arch/ia64/kernel/fsyscall_gtod_data.h |    2 +-

  arch/ia64/kernel/time.c               |   10 +---

  arch/x86/include/asm/vgtod.h          |    2 +-

  arch/x86/kernel/tsc.c                 |   10 ++++

  arch/x86/kernel/vsyscall_64.c         |   16 +-----

  arch/x86/vdso/vclock_gettime.c        |   88 ++++++++++++++++++++-------------

  drivers/rtc/interface.c               |    5 ++

  drivers/rtc/rtc-mpc5121.c             |    2 +

  include/linux/rtc.h                   |    3 +-

  kernel/time.c                         |    6 --

  kernel/time/timekeeping.c             |    7 +++

  13 files changed, 91 insertions(+), 66 deletions(-)


