Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758492Ab1FQB7Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 21:59:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:56323 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757895Ab1FQB7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 21:59:20 -0400
X-Authority-Analysis: v=1.1 cv=5asQ6euaRPJxDdFxwvXsn6JDb7fmFbz8qWDLMfa45gU= c=1 sm=0 a=vhdKIqpQuCYA:10 a=Eo1pUzdm5e8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=TUrpwACGw0ilVJMnW58A:9 a=m60aVbO9PrPVKwYqEWUA:7 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110617015516.301117218@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 16 Jun 2011 21:55:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [RFC][PATCH 0/7] sched: various updates to the scheduler
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Peter,

Can you review these patches and give your Acked-by, or explain what
might be wrong with them. No hurry, I haven't pushed them through my
full testing yet (starting that now). But I want to push them out for
3.1.

Thanks,

-- Steve


This patch set can be found in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-rt.git
tip/sched/core

Head SHA1: cac554411989613131d899cfb51b622ce96d5136


Hillf Danton (5):
      sched: Fix need_resched() when checking peempt
      sched: Remove noop in next_prio()
      sched: Remove noop in lowest_flag_domain()
      sched, rt: Fix rq->rt.pushable_tasks bug in push_rt_task()
      sched: Remove resetting exec_start in put_prev_task_rt()

Steven Rostedt (2):
      sched: Balance RT tasks when forked as well
      sched: Use pushable_tasks to determine next highest prio

----
 kernel/sched_fair.c |    2 +-
 kernel/sched_rt.c   |   88 +++++++++++++++++++--------------------------------
 2 files changed, 34 insertions(+), 56 deletions(-)
