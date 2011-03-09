Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854Ab1CIAH5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 19:07:57 -0500
Received: from mail.openrapids.net ([64.15.138.104]:60571 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751851Ab1CIAH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 19:07:56 -0500
Date: Tue, 8 Mar 2011 19:07:54 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        chris <chris@chris-wilson.co.uk>
Subject: Re: [PATCH][RFC] tracing: Enable tracepoints via module parameters
Message-ID: <20110309000753.GA27729@Krystal>
References: <1299622684.20306.77.camel@gandalf.stny.rr.com> <20110308232258.GA25987@Krystal> <1299627175.20306.96.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299627175.20306.96.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 19:01:40 up 105 days,  5:04,  2 users,  load average: 0.09, 0.09,
	0.08
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Tue, 2011-03-08 at 18:22 -0500, Mathieu Desnoyers wrote:
> > * Steven Rostedt (rostedt@goodmis.org) wrote:
> > > A few months ago it was suggested to have a way to enable tracepoints in
> > > a module when it is loaded. I tried various methods, but this one seems
> > > to be the least intrusive. In fact, it requires no modification to the
> > > module code.
> > > 
> > > The trace event now adds its own MODULE_INFO() and kernel_param_ops that
> > > and links the information about a tracepoint into the module's __param
> > > section. A module can be loaded with a tracepoint active by adding
> > > trace_<tracepoint>=1 as one of the parameters.
> > 
> > Hi Steven,
> > 
> > Can you walk me through the expected sequence someone wanting to enable a few
> > specific module tracepoints would have to go through ? I'm thinking here about
> > the context of a distro which has on-demand module loading. The scenario I am
> > thinking about is a distro specifying a basic set of tracepoints to enable in a
> > "standard catch-all tracing configuration", which includes some tracepoints in
> > yet-unloaded modules. I'm trying to figure out what the end user experience will
> > look like if we go for the solution you propose here.
> > 
> 
> You would add it like any other module parameter.
> 
> Just update it in your /etc/modprobe.d/ directory.

So what you are saying here is that modifying /etc/modprobe.d/ is the actual
interface you propose presenting to the end-users to control their tracepoints ?

Maybe I am missing something, but this interface seems to lack the layer of
finish we might want to put into a user-visible API. I don't really see how
distributions can hope to automate any of this for their end-user without making
a mess of the /etc/modprobe.d/ they ship with.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
