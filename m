Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147Ab1CICBl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 21:01:41 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:63120 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755354Ab1CICBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 21:01:20 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=KpzchuzAFZgA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=QA5Tl59zWrz9s0TenW4A:9 a=M89xkfBaLFRhGO3zpm4KcgpWbDcA:4 a=PUjeQqilurYA:10 a=WD8Q4GdeQTkHfRik:21 a=NDvbrhWG2B8y-8I1:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH][RFC] tracing: Enable tracepoints via module parameters
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        chris <chris@chris-wilson.co.uk>
In-Reply-To: <20110309011716.GB3664@Krystal>
References: <1299622684.20306.77.camel@gandalf.stny.rr.com>
	 <20110308232258.GA25987@Krystal>
	 <1299627175.20306.96.camel@gandalf.stny.rr.com>
	 <20110309000753.GA27729@Krystal>
	 <1299629657.20306.105.camel@gandalf.stny.rr.com>
	 <20110309002921.GA744@Krystal>
	 <1299631924.20306.122.camel@gandalf.stny.rr.com>
	 <20110309011716.GB3664@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 08 Mar 2011 21:01:17 -0500
Message-ID: <1299636077.20306.132.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-08 at 20:17 -0500, Mathieu Desnoyers wrote:

> I'm afraid I cannot say, at this point, which distro I am refering to, because
> that would be a little forward of me to push news before official feature
> announcements.

Well, I guess I'm safe at saying it aint Red Hat ;)

> 
> And about the "default" tracepoints, let's mainly think about tracepoints that
> would be specified from a trace control application. E.g. the user wants a type
> of tracing that collects all information required to solve a category of
> problem, and they get enabled automatically.

Well, since tracepoints can change (come and go), this tool had better
be very flexible.


> Well, thinking a little more about it, I won't be using this way of enabling
> tracepoints in my tracer, so please feel free to make it as simple as you like.
> I'm just providing feedback on what the ftrace/perf end user experience will
> look like and, sadly, it does not look good at all by the look of this proposal.

Sadly it matters what the point of this change was for. 1) this does not
affect the way perf enables/disable tracepoints. I'm sure it could
easily add a syscall interface that would keep a nice wall from the
user. 2) it was to enable tracing in ftrace as soon as a module is
loaded. Ideally from a modprobe, not boot time tracing. Although, I
probably could add something to for that too. But that would come later.


> I meant that distros can contain packages that are interested in a specific set
> of tracepoints (views/analysis are tracepoint data consumers), so they can
> specify a set of tracepoints to enable when tracing is activated.

Yep, and this patch is not aimed at that. I am interesting in things
that analyze specific data. But this patch was not something to address
that. And it could easily exist with other means that do.

> > 
> > But that's a good question. As I wrote this because I'm purging my inbox
> > and came across Yuanhan Liu's patch set. I'm curios to what Yuanhan's
> > motivation for this change was.
> 
> Yep.

Yep, I'm looking forward to a response. For myself, I like this patch
because there has been times I needed to enable a tracepoint as soon as
the module was loaded and not a long time afterward (which is what
happens when you do modprobe and echo by hand).

> 
> Hopefully my feedback can be of some use.

For who?

-- Steve


