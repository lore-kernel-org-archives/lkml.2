Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab1LTPfZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 10:35:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19872 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414Ab1LTPfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 10:35:22 -0500
Date: Tue, 20 Dec 2011 16:35:06 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: fweisbec@gmail.com, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, aarapov@redhat.com,
        Christoph Lameter <christoph@lameter.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHv2 03/10] ftrace: Add enable/disable ftrace_ops control
 interface
Message-ID: <20111220153506.GC4393@m.brq.redhat.com>
References: <1322417074-5834-1-git-send-email-jolsa@redhat.com>
 <1323105776-26961-1-git-send-email-jolsa@redhat.com>
 <1323105776-26961-4-git-send-email-jolsa@redhat.com>
 <1324323335.5916.46.camel@gandalf.stny.rr.com>
 <20111220145727.GB4393@m.brq.redhat.com>
 <1324394753.5916.53.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324394753.5916.53.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 10:25:53AM -0500, Steven Rostedt wrote:
> On Tue, 2011-12-20 at 15:57 +0100, Jiri Olsa wrote:
> 
> > > 
> > > If the above is called with preemption enabled, it will not do what is
> > > expected. We could disable function tracing on one CPU and then
> > > re-enable it for another CPU even though it is already enabled.
> > 
> > It is only called inside perf reg callback within the
> > schedule function where the preemption is disabled.
> > 
> > The ftrace_function_enable is called when task is scheduled in
> > on respective cpu. Likewise the ftrace_function_disable is called 
> > when task is scheduled out on respective cpu.
> 
> Yes I know how you use it, but this is an open API. It may be currently
> only used by perf today, but that doesn't mean that it wont be used by
> others. There's no documentation on how to use it. I don't look at this
> and say, "oh this is used by perf, we only need to worry about how perf
> uses it". That doesn't scale. It needs to be documented on how to use
> it, and if it requires preemption disabled when calling it, it should
> definitely be stated that fact and it may need a
> WARN_ON(preempt_count()) or something.

I've already added

        if (WARN_ON_ONCE(!(ops->flags & FTRACE_OPS_FL_CONTROL)))
                return;

will add similar for preemption and make comments for both functions

thanks,
jirka

> 
> -- Steve
> 
> 
