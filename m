Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556Ab2DBGvv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 02:51:51 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:47662 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab2DBGvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 02:51:49 -0400
Date: Mon, 2 Apr 2012 08:51:18 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, srivatsa.bhat@linux.vnet.ibm.com, mhocko@suse.cz,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/core] proc: stats: Use arch_idle_time for idle and
 iowait times if available
Message-ID: <20120402085118.4da62dfe@de.ibm.com>
In-Reply-To: <20120330155455.786e8963.akpm@linux-foundation.org>
References: <20120330122308.18720283@de.ibm.com>
	<tip-cb85a6ed67e979c59a29b7b4e8217e755b951cf4@git.kernel.org>
	<20120330155455.786e8963.akpm@linux-foundation.org>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12040206-0542-0000-0000-0000016EB283
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2012 15:54:55 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 30 Mar 2012 06:58:25 -0700
> tip-bot for Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:
> 
> > Commit-ID:  cb85a6ed67e979c59a29b7b4e8217e755b951cf4
> > Gitweb:     http://git.kernel.org/tip/cb85a6ed67e979c59a29b7b4e8217e755b951cf4
> > Author:     Martin Schwidefsky <schwidefsky@de.ibm.com>
> > AuthorDate: Fri, 30 Mar 2012 12:23:08 +0200
> > Committer:  Thomas Gleixner <tglx@linutronix.de>
> > CommitDate: Fri, 30 Mar 2012 15:43:33 +0200
> > 
> > proc: stats: Use arch_idle_time for idle and iowait times if available
> > 
> > Git commit a25cac5198d4ff28 "proc: Consider NO_HZ when printing idle and
> > iowait times" changes the code for /proc/stat to use get_cpu_idle_time_us
> > and get_cpu_iowait_time_us if the system is running with nohz enabled.
> > For architectures which define arch_idle_time (currently s390 only)
> > this is a change for the worse. The result of arch_idle_time is supposed
> > to be the exact sleep time of the target cpu and should be used instead
> > of the value kept by the scheduler.
> 
> So it appears that this patch is a superset of "nohz: fix idle ticks in
> cpu summary line of /proc/stat" (below), yes?

"proc:stats: Use arch_idle_time.." goes on top of "nohz: fix idle ticks..".
If the second patch is applied, s390 does not need the first one anymore.
So for s390 the second one is a superset of the first, on x86 the first
patch is the important one.
 
> > Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> > Reviewed-by: Michal Hocko <mhocko@suse.cz>
> > Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> > Link: http://lkml.kernel.org/r/20120330122308.18720283@de.ibm.com
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> No cc:stable?  Both 09a1d34f8535ecf9 and a25cac5198d date from
> September '11 and 09a1d34f8535ecf9 (at least) was a regression.
 
The regression is fixed by "proc:stats: User arch_idle_time..", the
second patch gets us back the improved values for s390, you could argue
if this is a regression or not.
Anyway I would not complain if both patches are included the stable
releases. 

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

