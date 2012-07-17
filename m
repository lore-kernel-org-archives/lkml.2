Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab2GQGlU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 02:41:20 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:41219 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab2GQGkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 02:40:17 -0400
From: John Stultz <johnstul@us.ibm.com>
To: stable@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/7] 3.4-stable: Fix for leapsecond caused hrtimer/futex issue
Date: Tue, 17 Jul 2012 02:39:49 -0400
Message-Id: <1342507196-54327-1-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.7.9.5
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071706-7282-0000-0000-00000AFC5284
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is backport of the leapsecond fixes to 3.4-stable. These are very
straight forward, and backported to 3.4.x with no collisions or changes.

This patchset resolve the early hrtimer/futex expiration issue
widely seen after the June 30th leapsecond.

I've booted and tested this patchset on two boxes and run through a number
of leapsecond related stress tests. However, additional testing and review
would be appreciated.

The original commits backported in this set are:

f55a6faa384304c89cfef162768e88374d3312cb    hrtimer: Provide clock_was_set_delayed()
4873fa070ae84a4115f0b3c9dfabc224f1bc7c51    timekeeping: Fix leapsecond triggered load spike issue
5b9fe759a678e05be4937ddf03d50e950207c1c0    timekeeping: Maintain ktime_t based offsets for hrtimers
196951e91262fccda81147d2bcf7fdab08668b40    hrtimers: Move lock held region in hrtimer_interrupt()
f6c06abfb3972ad4914cef57d8348fcb2932bc3b    timekeeping: Provide hrtimer update function
5baefd6d84163443215f4a99f6a20f054ef11236    hrtimer: Update hrtimer base offsets each hrtimer_interrupt
3e997130bd2e8c6f5aaa49d6e3161d4d29b43ab0    timekeeping: Add missing update call in timekeeping_resume()


I've already done backports to all the stable kernels to 2.6.32, 
and will be sending them out shortly.

Please let me know if you have any comments or feedback. 

thanks
-john

Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>


John Stultz (3):
  3.4.x: hrtimer: Provide clock_was_set_delayed()
  3.4.x: timekeeping: Fix leapsecond triggered load spike issue
  3.4.x: hrtimer: Update hrtimer base offsets each hrtimer_interrupt

Thomas Gleixner (4):
  3.4.x: timekeeping: Maintain ktime_t based offsets for hrtimers
  3.4.x: hrtimers: Move lock held region in hrtimer_interrupt()
  3.4.x: timekeeping: Provide hrtimer update function
  3.4.x: timekeeping: Add missing update call in timekeeping_resume()

 include/linux/hrtimer.h   |   10 ++++++-
 kernel/hrtimer.c          |   53 +++++++++++++++++++++++++------------
 kernel/time/timekeeping.c |   64 +++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 108 insertions(+), 19 deletions(-)

-- 
1.7.9.5

