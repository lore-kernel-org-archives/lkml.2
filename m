Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932580Ab2KZSGK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 13:06:10 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:54183 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932440Ab2KZREm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:04:42 -0500
Date: Mon, 26 Nov 2012 09:03:58 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, pjt@google.com,
        paul.mckenney@linaro.org, tglx@linutronix.de, tj@kernel.org,
        suresh.b.siddha@intel.com, venki@google.com, mingo@redhat.com,
        peterz@infradead.org, Arvind.Chauhan@arm.com,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        pdsw-power-team@arm.com, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org
Subject: Re: [PATCH V2 Resend 0/4] Create sched_select_cpu() and use it for
 workqueues and timers
Message-ID: <20121126170358.GE2474@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <cover.1352196505.git.viresh.kumar@linaro.org>
 <CAKohponTxs983vVQV=6Q8zyesC1W1FhFkzfmpAVeEwU-cQXohA@mail.gmail.com>
 <1353948027.6276.38.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353948027.6276.38.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12112617-5406-0000-0000-00000266BFA7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2012 at 11:40:27AM -0500, Steven Rostedt wrote:
> On Mon, 2012-11-26 at 20:30 +0530, Viresh Kumar wrote:
> > On 6 November 2012 16:08, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> > > This is V2 Resend of my sched_select_cpu() work. Resend because didn't got much
> > > attention on V2. Including more guys now in cc :)
> > >
> > > In order to save power, it would be useful to schedule work onto non-IDLE cpus
> > > instead of waking up an IDLE one.
> > >
> > > To achieve this, we need scheduler to guide kernel frameworks (like: timers &
> > > workqueues) on which is the most preferred CPU that must be used for these
> > > tasks.
> > >
> > > This patchset is about implementing this concept.
> > >
> > > - The first patch adds sched_select_cpu() routine which returns the preferred
> > >   cpu which is non-idle.
> > > - Second patch removes idle_cpu() calls from timer & hrtimer.
> > > - Third patch is about adapting this change in workqueue framework.
> > > - Fourth patch add migration capability in running timer
> > >
> > > Earlier discussions over v1 can be found here:
> > > http://www.mail-archive.com/linaro-dev@lists.linaro.org/msg13342.html
> > >
> > > Earlier discussions over this concept were done at last LPC:
> > > http://summit.linuxplumbersconf.org/lpc-2012/meeting/90/lpc2012-sched-timer-workqueue/
> > >
> > > Module created for testing this behavior is present here:
> > > http://git.linaro.org/gitweb?p=people/vireshk/module.git;a=summary
> > 
> > Ping!!
> 
> This is a really bad time of year to post new patches :-/
> A lot of people are trying to get their own work done by year end and
> then there's holidays and such that are also distractions. Not to
> mention that a new merge window will be opening soon.
> 
> That said...
> 
> As workqueues are set off by the CPU that queued it, what real benefit
> does this give? A CPU was active when it queued the work and the work
> should be done before it gets back to sleep.
> 
> OK, an interrupt happens on an idle CPU and queues some work. That work
> should execute before the CPU gets back to sleep, right? I fail to see
> the benefit of trying to move that work elsewhere. The CPU had to wake
> up to execute the interrupt. It's no longer in a deep sleep (or any
> sleep for that matter).
> 
> To me it seems best to avoid waking up an idle CPU in the first place.
> 
> I'm still working off a turkey overdose, so maybe I'm missing something
> obvious.

If I understand correctly (though also suffering turkey OD), the idea is
to offload work to more energy-efficient CPUs.

							Thanx, Paul

