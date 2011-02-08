Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab1BHSLj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 13:11:39 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:51980 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019Ab1BHSLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 13:11:38 -0500
Date: Tue, 8 Feb 2011 23:40:26 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Ranjit Manomohan <ranjitm@google.com>
Cc: linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Nikhil Rao <ncrao@google.com>, Salman Qazi <sqazi@google.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Venkatesh Pallipadi <venki@google.com>, Paul Turner <pjt@google.com>
Subject: Re: [ANNOUNCE] Linsched for 2.6.35 released
Message-ID: <20110208181026.GB8278@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <AANLkTinQAwEMGADYXX=2Rt3RUoMozDReNdpo9NtV1OO7@mail.gmail.com>
 <20101019045256.GA20232@dirshya.in.ibm.com>
 <AANLkTinz49WDn8yUFE_=dxUvneoZKAJYw4if9D7m7xaO@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <AANLkTinz49WDn8yUFE_=dxUvneoZKAJYw4if9D7m7xaO@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ranjit Manomohan <ranjitm@google.com> [2010-11-15 17:52:05]:

> On Mon, Oct 18, 2010 at 9:52 PM, Vaidyanathan Srinivasan
> <svaidy@linux.vnet.ibm.com> wrote:
> > * Ranjit Manomohan <ranjitm@google.com> [2010-10-12 10:29:54]:
> >

[snip]

> > Can you help me figure out how to get to kstat_cpu() or per-cpu
> > kernel_stat accounting/utilisation metrics within the simulation?
> 
> we don't use the kstat_cpu accounting in the simulation since it does
> not really make sense in this environment.
> 
> We have a timer driven loop that advances time globally and kicks of
> events scheduled to run at specified times on each CPU. The periodic
> timer tick is one among these events. Since there is really no notion
> of system vs user time in this scenario, the current code disables the
> update_process_times routine. I am not sure how these times relate to
> the task placement logic you are trying to verify. If you could let me
> know how you plan to use these then I can try to accommodate that in
> the simulation.

The current setup lets us find how much time each task was run.
I would like to use the kernel_stat information to understand 'which
cpu' ran the task.  Basically we could place nr_tasks < nr_cpus and
see them settle to the right CPUs within the sched domain topology.
This can be verified by checking the CPU's utilisation or run time at
the end of the simulation.  Like two tasks on the same socket of
a dual-socket dual-core system should settle to one task per socket.
The load balancer should be able to spread the tasks around slowly.

The ability to create diverse topology within linsched is very
useful to test these load balancer functions and corner cases.

> Sorry for the delay in response. My mail filters messed this up.

I got your reply earlier. No problem with the delay.
Do you have a new version to share?  Any new feature that you are planning?

--Vaidy

