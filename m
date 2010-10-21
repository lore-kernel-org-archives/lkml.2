Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183Ab0JUNv7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 09:51:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34337 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932097Ab0JUNv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 09:51:58 -0400
Date: Thu, 21 Oct 2010 09:50:41 -0400
From: Jason Baron <jbaron@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH][GIT PULL] tracing: Fix compile issue for
	trace_sched_wakeup.c
Message-ID: <20101021135041.GA2920@redhat.com>
References: <1287508282.16971.386.camel@gandalf.stny.rr.com> <20101019184111.GA17266@elte.hu> <20101020154045.GA18353@elte.hu> <20101020164324.GC7348@redhat.com> <4CBFAC70.30602@hitachi.com> <1287645744.3488.57.camel@twins> <1287658862.16971.569.camel@gandalf.stny.rr.com> <1287659008.3488.102.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287659008.3488.102.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 01:03:28PM +0200, Peter Zijlstra wrote:
> On Thu, 2010-10-21 at 07:01 -0400, Steven Rostedt wrote:
> > On Thu, 2010-10-21 at 09:22 +0200, Peter Zijlstra wrote:
> > > On Thu, 2010-10-21 at 11:58 +0900, Masami Hiramatsu wrote:
> > > 
> > > > It seems there can be a bug in stop_machine() routine under
> > > > heavy use. usually that is called just once at a time, but jump
> > > > label and optprobe might call it heavily (thousands times?).
> > > > So some racy situation can be happen easily.
> > > 
> > > There are people doing hotplug stress testing, that too results in heavy
> > > stop_machine usage.
> > 
> > But with hotplug, isn't there a bit more time between stop machine
> > calls? That is, you need to do a bit of work to bring down or up a CPU,
> > and that will slow down the number of stop machine calls together.
> > 
> > Here, we do a simple change and call stop machine() several times.
> > 
> > Although, I agree, I do not think the bug is in stop machine itself, but
> > perhaps the way we are using it might have some niche anomaly that we
> > are hitting.
> 
> Possibly, but wouldn't it make sense to batch up the work and simply
> call stop_machine only once? I mean, if you already know you're going to
> do this...
> 

it would. I know Masami is working on text_poke_smp_batch(), and I was
planning to move to it when it was ready...nonetheless there is still a
bug here...

thanks,

-Jason

