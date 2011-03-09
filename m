Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980Ab1CIAwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 19:52:19 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:34312 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756851Ab1CIAwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 19:52:08 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=KpzchuzAFZgA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=cTItTlOMXMcZnjVUOMQA:9 a=cDn6emo-kAhs8TS_ZWIA:7 a=jBYetIISKwOiVurpkL5lDeanv6EA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
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
In-Reply-To: <20110309002921.GA744@Krystal>
References: <1299622684.20306.77.camel@gandalf.stny.rr.com>
	 <20110308232258.GA25987@Krystal>
	 <1299627175.20306.96.camel@gandalf.stny.rr.com>
	 <20110309000753.GA27729@Krystal>
	 <1299629657.20306.105.camel@gandalf.stny.rr.com>
	 <20110309002921.GA744@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 08 Mar 2011 19:52:04 -0500
Message-ID: <1299631924.20306.122.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-08 at 19:29 -0500, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > On Tue, 2011-03-08 at 19:07 -0500, Mathieu Desnoyers wrote:
> > 
> > > So what you are saying here is that modifying /etc/modprobe.d/ is the actual
> > > interface you propose presenting to the end-users to control their tracepoints ?
> > 
> > If you want to have them enabled on boot, sure.
> 
> No, I'm not talking about enabling tracepoints on boot here. Let's think about a
> basic use-case: a distro packages a tracer, and provides a "default" set of
> tracepoints that can be enabled when tracing is needed. Therefore, these
> tracepoints are not enabled at boot -- they are rather enabled when tracing
> starts. Some of these tracepoints are in dynamically loaded modules. Some of
> these modules are automatically loaded by the distro (e.g. when a USB device is
> plugged in).

What distro are we talking about? What distro provides a "default" set
of tracepoints?


> 
> The specific module tracepoints should therefore only be enabled when both of
> the following conditions are true:
> 
> A - the end-user want to trace
> B - the module is loaded
> 
> But it looks like hooking on modinfo will only let you unconditionally enable
> the module tracepoints during normal system operations (even when tracing is
> off), or not at all unless you previously load the module (which does not fit
> with the reality of distributions automagically loading modules on demand while
> tracing runs).

Lets keep it simple please. Right now my proposal does more than what we
currently have. Perhaps we could change the enabling to only enable if
"tracing is on", or some /proc/sys/kernel/X flag is set.


> > 
> > > Maybe I am missing something, but this interface seems to lack the layer of
> > > finish we might want to put into a user-visible API. I don't really see how
> > > distributions can hope to automate any of this for their end-user without making
> > > a mess of the /etc/modprobe.d/ they ship with.
> > 
> > What distros enable tracepoints by default?
> 
> Do you mean enable as having a probe connected, or just CONFIG_TRACEPOINTS=y ?

I mean having the probe connected as distros already have
CONFIG_TRACEPOINTS on. What was your meaning when you said "distro
specifying a basic set of tracepoints to enable"?


> 
> > 
> > If you want to enable a tracepoint on module load simply do:
> > 
> >  modprobe mymod trace_my_tracepoint=1
> > 
> > Otherwise modify your modprobe.d directory. This is the way users have
> > been doing module parameters for years.
> > 
> > That's pretty simple to me.
> 
> Everything is always so much easier when your end-user target is yourself.
> What are users for anyway ? :-P

Users are for testing code ;)

But that's a good question. As I wrote this because I'm purging my inbox
and came across Yuanhan Liu's patch set. I'm curios to what Yuanhan's
motivation for this change was.

-- Steve


