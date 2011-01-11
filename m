Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab1AKD5k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 22:57:40 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:43675 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755346Ab1AKD5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 22:57:22 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=vY-4H3rt1rYA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=-Tk-NQHjFe3eN9BmnQ4A:9 a=xfyCQ-Kn9sEn5gv79SQA:7 a=piuMqmVJ4XrL_8YHTgljpcsOzOAA:4 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110111035355.643480133@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 10 Jan 2011 22:53:55 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 0/5][RT] [GIT PULL] rt: Port of Lai Jiangshan's rt patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

I finally got Lai's patch to a point that I'm happy with it.
The first 4 patches are clean ups to help in applying Lai's patch
at the end.

I've tested this patch series by running dbench 100 in a loop
and it crashes as much as mainline 2.6.33 does ;-) so I'm pretty
happy with it.

The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-rt.git

    branch: rt/tip/rt/devel


Lai Jiangshan (1):
      rtmutex: Ensure only the top waiter or higher priority task can take the lock

Steven Rostedt (4):
      rtmutex: Only save lock depth once in spin_slowlock
      rtmutex: Try to take lock early in rt_spin_lock_slowlock()
      rtmutex: Revert Optimize rt lock wakeup
      rtmutex: Fix comment about why new_owner can be NULL in wake_futex_pi()

----
 kernel/futex.c          |   20 +-
 kernel/rt.c             |   10 +-
 kernel/rtmutex-debug.c  |    1 -
 kernel/rtmutex.c        |  478 ++++++++++++++++++-----------------------------
 kernel/rtmutex_common.h |   18 +--
 5 files changed, 204 insertions(+), 323 deletions(-)

