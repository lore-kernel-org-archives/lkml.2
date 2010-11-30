Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352Ab0K3NtA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 08:49:00 -0500
Received: from canuck.infradead.org ([134.117.69.58]:42016 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657Ab0K3Ns7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 08:48:59 -0500
Subject: Re: [PATCH v4] sched: automated per session task groups
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mike Galbraith <efault@gmx.de>
Cc: Paul Turner <pjt@google.com>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1291123083.28239.18.camel@marge.simson.net>
References: <20101121133744.GA10765@elte.hu>
	 <1290700829.4759.16.camel@maggy.simson.net>
	 <1290954299.30515.15.camel@marge.simson.net>
	 <AANLkTin5Z_WdAPDfcS3V3DCcN40HLDfpzK-o0XeSMiQh@mail.gmail.com>
	 <20101128201851.GA20555@elte.hu> <1291031593.32004.19.camel@laptop>
	 <AANLkTimQ2Kp2=um9ip7J2=-joskmz4P-0b_SrexFbTh0@mail.gmail.com>
	 <1291052268.32004.171.camel@laptop>
	 <1291057565.20709.2.camel@marge.simson.net>
	 <20101129192033.GA18372@elte.hu>
	 <AANLkTi=jra_M+F9OKj31uS6EMu+ZkPT++GSrNd_bgXSy@mail.gmail.com>
	 <1291090455.7550.7.camel@marge.simson.net>
	 <AANLkTi=YDHyRcP5NSdVDRMW0_oj1L85aLzGV9hFGw1FN@mail.gmail.com>
	 <1291123083.28239.18.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 30 Nov 2010 14:48:07 +0100
Message-ID: <1291124887.32004.791.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-30 at 14:18 +0100, Mike Galbraith wrote:
> 
> From: Mike Galbraith <efault@gmx.de>
> Date: Tue Nov 30 14:07:12 CET 2010
> Subject: [PATCH] sched: Improve desktop interactivity: Implement automated per session task groups
> 
> A recurring complaint from CFS users is that parallel kbuild has a negative
> impact on desktop interactivity.  This patch implements an idea from Linus,
> to automatically create task groups.  Currently, only per session autogroups
> are implemented, but the patch leaves the way open for enhancement.
> 
> Implementation: each task's signal struct contains an inherited pointer to
> a refcounted autogroup struct containing a task group pointer, the default
> for all tasks pointing to the init_task_group.  When a task calls setsid(),
> a new task group is created, the process is moved into the new task group,
> and a reference to the preveious task group is dropped.  Child processes
> inherit this task group thereafter, and increase it's refcount.  When the
> last thread of a process exits, the process's reference is dropped, such
> that when the last process referencing an autogroup exits, the autogroup
> is destroyed.
> 
> At runqueue selection time, IFF a task has no cgroup assignment, its current
> autogroup is used.
> 
> Autogroup bandwidth is controllable via setting it's nice level through the
> proc filesystem.  cat /proc/<pid>/autogroup displays the task's group and the
> group's nice level.  echo <nice level> > /proc/<pid>/autogroup Sets the task
> group's shares to the weight of nice <level> task.  Setting nice level is rate
> limited for !admin users due to the abuse risk of task group locking.
> 
> The feature is enabled from boot by default if CONFIG_SCHED_AUTOGROUP=y is
> selected, but can be disabled via the boot option noautogroup, and can also
> be turned on/off on the fly via..
>         echo [01] > /proc/sys/kernel/sched_autogroup_enabled.
> ..which will automatically move tasks to/from the root task group.
> 
> Signed-off-by: Mike Galbraith <efault@gmx.de>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Markus Trippelsdorf <markus@trippelsdorf.de>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> LKML-Reference: <1290281700.28711.9.camel@maggy.simson.net>
> Signed-off-by: Ingo Molnar <mingo@elte.hu> 

Looks good to me, Thanks Mike!

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
