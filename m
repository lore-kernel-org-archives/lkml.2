Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551Ab0KOPxK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 10:53:10 -0500
Received: from mtagate6.uk.ibm.com ([194.196.100.166]:32952 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755828Ab0KOPxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 10:53:08 -0500
Subject: Re: [RFC][PATCH v2 1/7] taskstats: Add new taskstats command
 TASKSTATS_CMD_ATTR_PIDS
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Oleg Nesterov <oleg@redhat.com>, John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
In-Reply-To: <1289676005.2109.148.camel@laptop>
References: <20101111170352.732381138@linux.vnet.ibm.com>
	 <20101111170813.527389224@linux.vnet.ibm.com>
	 <1289676005.2109.148.camel@laptop>
Content-Type: text/plain; charset="us-ascii"
Organization: IBM
Date: Mon, 15 Nov 2010 16:53:00 +0100
Message-ID: <1289836380.1916.41.camel@holzheu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Peter,

On Sat, 2010-11-13 at 20:20 +0100, Peter Zijlstra wrote:
> On Thu, 2010-11-11 at 18:03 +0100, Michael Holzheu wrote:
> > As clock for 'now' and 'time' the sched_clock() function is used and the patch
> 
> > +       preempt_disable();
> > +       stats->time_ns = sched_clock();
> > +       preempt_enable();
> 
> > +       task_snap_time = sched_clock();
> 
> That's just plain broken...

What exactly do you mean? Do you mean that we should not use
sched_clock() in general or that it is called twice?

> 
> 
> > +       t->sched_info.last_depart = task_rq(t)->clock;
> 
> Are you sure you don't mean task_rq(t)->clock_task ?

Maybe... I want to save in "last_depart" a sched_clock() timestamp that
is as precise as possible.

We use "last_depart" for the TASKSTATS_CMD_ATTR_PIDS command to find out
which tasks have been running on a CPU since the last taskstats
snapshot. We return all tasks where last_depart > MIN(stats->time_ns for
all tasks of last snapshot).

Michael



