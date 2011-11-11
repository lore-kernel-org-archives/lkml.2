Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244Ab1KKExX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 23:53:23 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:55964 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753448Ab1KKExV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 23:53:21 -0500
Message-ID: <1320987192.15791.13.camel@js-netbook>
Subject: [GIT PULL] TSC sched_clock overflow workaround
From: John Stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Cc: lkml <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
Date: Thu, 10 Nov 2011 20:53:12 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 11111104-6078-0000-0000-00000441A2A9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas, Ingo,
	I thought Peter had sent this on, but apparently its not landed yet, so
I wanted to make sure you got it.

After ~208 days, the sched_clock multiplication overflows and causes
some false positives in the softlockup watchdog. I don't think there are
any actual panics going on, as an earlier related div by zero issue was
already fixed. However, the false positives do continue to worry folks.

We still need a proper fix, which will probably be in part making
sched_clock do periodic accumulation, as well as possibly changing users
of sched_clock (like the softlockup watchdog) use timekeeping timestamps
rather then sched_clock.

thanks
-john


Peter's workaround is available in the git repository at:
  git://git.linaro.org/people/jstultz/linux.git fortglx/3.2/tip/sched/clock

Peter Zijlstra (1):
      x86, intel: Don't mark sched_clock() as stable

 arch/x86/kernel/cpu/intel.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)



