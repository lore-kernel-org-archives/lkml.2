Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808Ab2CBBh2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 20:37:28 -0500
Received: from mga14.intel.com ([143.182.124.37]:52646 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953Ab2CBBh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 20:37:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="72581501"
Subject: Re: [PATCH] Extend mwait idle to optimize away CAL and RES
 interrupts to an idle CPU -v1
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Venki Pallipadi <venki@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Aaron Durbin <adurbin@google.com>,
        Paul Turner <pjt@google.com>, Yong Zhang <yong.zhang0@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 01 Mar 2012 17:37:37 -0800
In-Reply-To: <CABeCy1btewB-oTgyL06qvebLLXTqareYNy-wdNZ3oiHR3KPwEw@mail.gmail.com>
References: <1329957415-15239-1-git-send-email-venki@google.com>
	 <20120223075027.GB15306@elte.hu>
	 <CABeCy1YeGjTAGKRwwaryY9bx9UwMq9nhGAsVV-o2QEjPH=4ErA@mail.gmail.com>
	 <1330651732.30167.63.camel@sbsiddha-desk.sc.intel.com>
	 <CABeCy1btewB-oTgyL06qvebLLXTqareYNy-wdNZ3oiHR3KPwEw@mail.gmail.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1330652258.30167.70.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-01 at 17:35 -0800, Venki Pallipadi wrote:
> On Thu, Mar 1, 2012 at 5:28 PM, Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> > On Thu, 2012-03-01 at 16:33 -0800, Venki Pallipadi wrote:
> >> >
> >> > fork_idle() should also make sure it does not schedule the child
> >> > thread: thus we'd also be able to further simplify smpboot.c and
> >> > get rid of all that extremely ugly 'struct create_idle'
> >> > gymnastics in smpboot.c.
> >>
> >> But not this. I am not sure where fork_idle results in resched of the child.
> >> As I saw it, fork_idle calls init_idle and that sets the affinity of
> >> idle_task to target CPU. So, reschedule should not be a problem. What
> >> am I missing here?
> >
> > I think Ingo is referring to the fact that we can't use kthread_create()
> > here and hence we were relying on fork_idle().
> >
> >> Also, I tried this silly test patch (Cut and paste... Sorry) and it
> >> seemed to work fine both with and without CPU hotplug.
> >>
> >
> > I don't think we can do this today, as we need to make sure we have the
> > correct current context. With dynamic cpu hotplug, current context can
> > be any process and hence we were depending on the schedule_work()
> > context.
> >
> 
> schedule_work() is only done at boot time. In case of dynamic cpu
> hotplug, we skip the whole fork_idle as we already have the task
> struct and just do init_idle().
> 

What happens if we boot with "maxcpus=" and later online the remaining
cpu's? same issue with the physical cpu-online case too right?

thanks,
suresh

