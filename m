Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712Ab0K3OAN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 09:00:13 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54040 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991Ab0K3OAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 09:00:10 -0500
Date: Tue, 30 Nov 2010 14:59:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>, Paul Turner <pjt@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] sched: automated per session task groups
Message-ID: <20101130135959.GA20703@elte.hu>
References: <1291031593.32004.19.camel@laptop>
 <AANLkTimQ2Kp2=um9ip7J2=-joskmz4P-0b_SrexFbTh0@mail.gmail.com>
 <1291052268.32004.171.camel@laptop>
 <1291057565.20709.2.camel@marge.simson.net>
 <20101129192033.GA18372@elte.hu>
 <AANLkTi=jra_M+F9OKj31uS6EMu+ZkPT++GSrNd_bgXSy@mail.gmail.com>
 <1291090455.7550.7.camel@marge.simson.net>
 <AANLkTi=YDHyRcP5NSdVDRMW0_oj1L85aLzGV9hFGw1FN@mail.gmail.com>
 <1291123083.28239.18.camel@marge.simson.net>
 <1291124887.32004.791.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291124887.32004.791.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.3 required=5.9 tests=BAYES_00,FUZZY_VPILL autolearn=no SpamAssassin version=3.2.5
	0.7 FUZZY_VPILL            BODY: Attempt to obfuscate words in spam
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Tue, 2010-11-30 at 14:18 +0100, Mike Galbraith wrote:
> > 
> > From: Mike Galbraith <efault@gmx.de>
> > Date: Tue Nov 30 14:07:12 CET 2010
> > Subject: [PATCH] sched: Improve desktop interactivity: Implement automated per session task groups
> > 
> > A recurring complaint from CFS users is that parallel kbuild has a negative
> > impact on desktop interactivity.  This patch implements an idea from Linus,
> > to automatically create task groups.  Currently, only per session autogroups
> > are implemented, but the patch leaves the way open for enhancement.
> > 
> > Implementation: each task's signal struct contains an inherited pointer to
> > a refcounted autogroup struct containing a task group pointer, the default
> > for all tasks pointing to the init_task_group.  When a task calls setsid(),
> > a new task group is created, the process is moved into the new task group,
> > and a reference to the preveious task group is dropped.  Child processes
> > inherit this task group thereafter, and increase it's refcount.  When the
> > last thread of a process exits, the process's reference is dropped, such
> > that when the last process referencing an autogroup exits, the autogroup
> > is destroyed.
> > 
> > At runqueue selection time, IFF a task has no cgroup assignment, its current
> > autogroup is used.
> > 
> > Autogroup bandwidth is controllable via setting it's nice level through the
> > proc filesystem.  cat /proc/<pid>/autogroup displays the task's group and the
> > group's nice level.  echo <nice level> > /proc/<pid>/autogroup Sets the task
> > group's shares to the weight of nice <level> task.  Setting nice level is rate
> > limited for !admin users due to the abuse risk of task group locking.
> > 
> > The feature is enabled from boot by default if CONFIG_SCHED_AUTOGROUP=y is
> > selected, but can be disabled via the boot option noautogroup, and can also
> > be turned on/off on the fly via..
> >         echo [01] > /proc/sys/kernel/sched_autogroup_enabled.
> > ..which will automatically move tasks to/from the root task group.
> > 
> > Signed-off-by: Mike Galbraith <efault@gmx.de>
> > Cc: Oleg Nesterov <oleg@redhat.com>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > Cc: Markus Trippelsdorf <markus@trippelsdorf.de>
> > Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > LKML-Reference: <1290281700.28711.9.camel@maggy.simson.net>
> > Signed-off-by: Ingo Molnar <mingo@elte.hu> 
> 
> Looks good to me, Thanks Mike!
> 
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Ok, great!

I've queued it up in tip:sched/core and started testing it - will push it out if it 
passes basic tests. Added Linus's Acked-by - i presume that's still valid for v4 as 
well, right?

Thanks,

	Ingo
