Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934743Ab0KQMZ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 07:25:56 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:63690 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934606Ab0KQMZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 07:25:55 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=VINkOuZDQI4A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=6yBUgjC6AATK4R6N9QAA:9 a=GmBH4ST9CoG2WIqBrNEA:7 a=Q_WuZfK7BwJ66rHf-tXqsswcwBYA:4 a=PUjeQqilurYA:10 a=0kPLrQdw3YYA:10 a=jEp0ucaQiEUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 1/5] [PATCH 1/5] events: Add EVENT_FS the event
 filesystem
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20101117103914.GA21976@elte.hu>
References: <20101117005357.024472450@goodmis.org>
	 <20101117005939.600541101@goodmis.org> <20101117033242.GB31335@suse.de>
	 <20101117103914.GA21976@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 17 Nov 2010 07:25:53 -0500
Message-ID: <1289996753.30543.35.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 11:39 +0100, Ingo Molnar wrote:
> * Greg KH <gregkh@suse.de> wrote:
> 
> > On Tue, Nov 16, 2010 at 07:53:58PM -0500, Steven Rostedt wrote:
> > > From: Steven Rostedt <srostedt@redhat.com>
> > > 
> > > Copied mostly from debugfs, the eventfs is the filesystem that will include 
> > > stable tracepoints. Currently nothing enables this filesystem as of this patch.
> > 
> > What?  Wait, I wrote tracefs a long time ago just for this, why not take that code 
> > and use it instead?
> 
> Yeah, and i know that i suggested 'eventfs' to Steve and others in a prior thread a 
> few months ago - and i suspect Steve was following up on that suggestion with this 
> patch? So i guess it's partly my fault ;-)

And we brought this up at Kernel Summit.

> 
> [ Also, i think our _real_ problems with tracing lie entirely elsewhere, but i've
>   explained that numerous times. Maintaining instrumentation bits is the ultimate
>   cat herding experience ;-) ]
> 
> I also explained it in that eventfs suggestion thread that eventfs (or, indeed 
> tracefs) is IMO only a second tier approach compared to the real thing: proper 
> enumeration of events in sysfs.
> 
> [ Beyond the obvious compatibility detail that we are _NOT_ getting rid of 
>   /debug/tracing/events/, as existing tooling depends on it. So unless eventfs or 
>   sysfs integration brings some real tangible benefits over what we have already we 
>   dont want to force tooling to migrate to yet another API. ]

One benefit is that we have a way to distinguish between
in-field-debugging tracepoints and tracepoints that are only for
analysis tools.

> 
> Lin Ming and PeterZ are working on sysfs integration and they have posted several 
> iterations of that work which extends event details to sysfs. That work is not 
> complete yet and they need help. (I've Cc:-ed them.)

Actually, I suck at adding anything to the sysfs/kobject code. I always
screw it up. I only got the /sys/kernel/events working because I copied
it directly from Greg. I doubt I'd be much help.


> 
> The sysfs approach has numerous upsides:
> 
>  - Design: sysfs is a mature, multi-year project with tons of meaningful hardware 
>    and software hieararchies already well established. Attaching events to these
>    existing nodes optionally is an obvious advantage and avoids duplication and
>    forces people to think about structure.
> 
>  - Concentration of structure: subsystem and driver authors/maintainers already care 
>    about their sysfs layout - and when they define new tracepoints for subsystem or 
>    driver instrumentation it would be very natural for those events to go somewhere 
>    nearby, in the existing sysfs hieararchy.
> 
>  - Practicalities: sysfs is already mounted on all distros so tooling could rely on 
>    it universally. It's the ultimate 'describe system structure' store.
> 
>  - Long term maintenance: we want to be strict with events, i.e. keep the 
>    descriptors read only and single-line structured. You sysfs folks are enforcing 
>    that pretty well - with eventfs we'd always have the nasty lure to apply API 
>    hacks to eventfs components when we really shouldnt ...


Are these events now going to be labeled as stable?  Is every tracepoint
we have, much have the same data?  Linus specifically said at Kernel
Summit that he wants absolutely NO modules to have a stable tracepoint.

Also, if we just blindly label a tracepoint as "stable" then we must
keep all its contents. For example, the sched_switch will contain the
priority. As Peter has stated several times, that may go away. We also
do not want to lose getting that information, as a lot of us use it.

> 
> Eventfs has a couple of downsides:
> 
>  - Design: it's slapping events into a separate, partly duplicated, partly unique, 
>    partly inconsistent set of hierarchies. We can deal with it, but it's not 
>    particularly intelligent and i'd like us to try harder.
> 
>  - Practicalities: eventfs has to be mounted on every distro. It's an uphill climb
>    in general and the appeal of an approach has to be _strong_ for this to be 
>    feasible.

Some distros already mount debugfs by default. It's a oneliner in fstab.

> 
> So putting it into sysfs looks like a pretty intelligent solution all around and i'd 
> prefer it.

Another downside is that you need to scan hundreds of directories to
find tracepoints. And again, are they all now stable?


> 
> Steve, would you be interested in helping out Lin Ming and PeterZ with the sysfs 
> work - or at least help them come to the conclusion that we want eventfs?

I don't think I would be much help with the former, and I'm thinking I'm
losing the later.

Hmm, seems that every decision that we came to agreement with at Kernel
Summit has been declined in practice. Makes me think that Kernel Summit
is pointless, and was a waste of my time. :-(

-- Steve

> 
> Thanks,
> 
> 	Ingo


