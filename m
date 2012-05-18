Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966829Ab2ERI4o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 04:56:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46032 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965235Ab2ERI4m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 04:56:42 -0400
Message-ID: <1337331395.573.3.camel@twins>
Subject: Re: [PATCH] sched/rt: fix SCHED_RR across cgroups
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Colin Cross <ccross@android.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Hillf Danton <dhillf@gmail.com>
Date: Fri, 18 May 2012 10:56:35 +0200
In-Reply-To: <1337229266-15798-1-git-send-email-ccross@android.com>
References: <1337229266-15798-1-git-send-email-ccross@android.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-16 at 21:34 -0700, Colin Cross wrote:
> task_tick_rt has an optimization to only reschedule SCHED_RR tasks
> if they were the only element on their rq.  However, with cgroups
> a SCHED_RR task could be the only element on its per-cgroup rq but
> still be competing with other SCHED_RR tasks in its parent's
> cgroup.  In this case, the SCHED_RR task in the child cgroup would
> never yield at the end of its timeslice.  If the child cgroup
> rt_runtime_us was the same as the parent cgroup rt_runtime_us,
> the task in the parent cgroup would starve completely.
> 
> Modify task_tick_rt to check that the task is the only task on its
> rq, and that the each of the scheduling entities of its ancestors
> is also the only entity on its rq.
> 
> Signed-off-by: Colin Cross <ccross@android.com>

OK, fair enough.. one does wonder though, WTH is android doing with
SCHED_RR?
