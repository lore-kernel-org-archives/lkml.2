Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924Ab2GKOeF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 10:34:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:60979 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755347Ab2GKOeD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 10:34:03 -0400
Message-ID: <1342017221.3462.159.camel@twins>
Subject: Re: [PATCH] trace: add ability to set a target task for events (v2)
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arun Sharma <asharma@fb.com>
Date: Wed, 11 Jul 2012 16:33:41 +0200
In-Reply-To: <20120711143121.GA17991@somewhere>
References: <1342016098-213063-1-git-send-email-avagin@openvz.org>
	 <20120711143121.GA17991@somewhere>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-11 at 16:31 +0200, Frederic Weisbecker wrote:
> On Wed, Jul 11, 2012 at 06:14:58PM +0400, Andrew Vagin wrote:
> > A few events are interesting not only for a current task.
> > For example, sched_stat_* are interesting for a task, which
> > wake up. For this reason, it will be good, if such events will
> > be delivered to a target task too.
> > 
> > Now a target task can be set by using __perf_task().
> > 
> > The original idea and a draft patch belongs to Peter Zijlstra.
> > 
> > I need this events for profiling sleep times.  sched_switch is used for
> > getting callchains and sched_stat_* is used for getting time periods.
> > This events are combined in user space, then it can be analized by
> > perf tools.
> 
> We've talked about that numerous times. But I still don't really
> understand why you're not using sched switch events and compute
> the difference between schedule in and schedule out.
> 
> I think you said that's because you got too much events with sched
> switch. Are you loosing events? Otherwise I don't see why it's
> a problem.
> 
> Also the sched_stat_sleep event produce an event which period equals the
> time slept. Internally, perf split this into as many events as that period
> because the requested period for trace events is 1 by default. We probably
> should allow to send events with a higher number than the one requested. This
> this produce sometimes a huge pile of events, and that even often result in
> tons of lost events. We definetly need to fix that.
> 
> In the meantime you'll certainly get saner results by just recording
> sched switch events.

Not really, there's an arbitrary large delay between wakeup and getting
scheduled back in, which is unrelated to the cause that you went to
sleep.

The wants the time between going to sleep and getting woken up,
sched_switch simply doesn't give you that.
