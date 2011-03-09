Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab1CIA3Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 19:29:25 -0500
Received: from mail.openrapids.net ([64.15.138.104]:59895 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754739Ab1CIA3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 19:29:24 -0500
Date: Tue, 8 Mar 2011 19:29:21 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        chris <chris@chris-wilson.co.uk>
Subject: Re: [PATCH][RFC] tracing: Enable tracepoints via module parameters
Message-ID: <20110309002921.GA744@Krystal>
References: <1299622684.20306.77.camel@gandalf.stny.rr.com> <20110308232258.GA25987@Krystal> <1299627175.20306.96.camel@gandalf.stny.rr.com> <20110309000753.GA27729@Krystal> <1299629657.20306.105.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299629657.20306.105.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 19:19:30 up 105 days,  5:22,  2 users,  load average: 0.14, 0.10,
	0.09
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Tue, 2011-03-08 at 19:07 -0500, Mathieu Desnoyers wrote:
> 
> > So what you are saying here is that modifying /etc/modprobe.d/ is the actual
> > interface you propose presenting to the end-users to control their tracepoints ?
> 
> If you want to have them enabled on boot, sure.

No, I'm not talking about enabling tracepoints on boot here. Let's think about a
basic use-case: a distro packages a tracer, and provides a "default" set of
tracepoints that can be enabled when tracing is needed. Therefore, these
tracepoints are not enabled at boot -- they are rather enabled when tracing
starts. Some of these tracepoints are in dynamically loaded modules. Some of
these modules are automatically loaded by the distro (e.g. when a USB device is
plugged in).

The specific module tracepoints should therefore only be enabled when both of
the following conditions are true:

A - the end-user want to trace
B - the module is loaded

But it looks like hooking on modinfo will only let you unconditionally enable
the module tracepoints during normal system operations (even when tracing is
off), or not at all unless you previously load the module (which does not fit
with the reality of distributions automagically loading modules on demand while
tracing runs).

> 
> > Maybe I am missing something, but this interface seems to lack the layer of
> > finish we might want to put into a user-visible API. I don't really see how
> > distributions can hope to automate any of this for their end-user without making
> > a mess of the /etc/modprobe.d/ they ship with.
> 
> What distros enable tracepoints by default?

Do you mean enable as having a probe connected, or just CONFIG_TRACEPOINTS=y ?

> 
> If you want to enable a tracepoint on module load simply do:
> 
>  modprobe mymod trace_my_tracepoint=1
> 
> Otherwise modify your modprobe.d directory. This is the way users have
> been doing module parameters for years.
> 
> That's pretty simple to me.

Everything is always so much easier when your end-user target is yourself.
What are users for anyway ? :-P

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
