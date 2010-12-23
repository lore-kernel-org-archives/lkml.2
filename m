Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253Ab0LWWvT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 17:51:19 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:65201 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608Ab0LWWvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 17:51:17 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=Ar2y4WLajYgA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=WkNP1CVgQmBOtLH6c5cA:9 a=w0o3Ozu8mCxCVFLuxmkA:7 a=L1ezqvitGTH2P92ScqGq2UvVz1IA:4 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101223224755.078983538@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 23 Dec 2010 17:47:55 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [RFC][RT][PATCH 0/4] rtmutex: Simplify PI code
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is still a little buggy. I've been hitting a hang when running
dbench 100 in a loop. But I also hit that hang with vanilla -rt.

But I'm sure this still has some things that need to be straighten out.
Anyway, you can either apply the following patches or pull the code
from the listed git repo.

This still needs to be worked out, but since I'm taking off for the
rest of the year, I might as well show you where I ended up at.

The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-rt.git

    branch: rt/tip/rt/devel


Lai Jiangshan (1):
      rtmutex: Ensure only the top waiter or higher priority task can take the lock

Steven Rostedt (3):
      rtmutex: Only save lock depth once in spin_slowlock
      rtmutex: Try to take lock early in rt_spin_lock_slowlock()
      rtmutex: Revert Optimize rt lock wakeup

----
 kernel/futex.c          |   22 +--
 kernel/rt.c             |   10 +-
 kernel/rtmutex-debug.c  |    1 -
 kernel/rtmutex.c        |  458 ++++++++++++++++++-----------------------------
 kernel/rtmutex_common.h |   18 +--
 5 files changed, 188 insertions(+), 321 deletions(-)
