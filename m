Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392Ab1GFRK0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 13:10:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51902 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751203Ab1GFRKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 13:10:25 -0400
Date: Wed, 6 Jul 2011 19:10:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH] perf: Attaching an event to a specific PMU
Message-ID: <20110706171015.GA13869@elte.hu>
References: <20110703150430.GV4590@erda.amd.com>
 <1309716271.3282.6.camel@twins>
 <20110704175927.GZ4590@erda.amd.com>
 <1309855905.3282.42.camel@twins>
 <20110705091252.GA5725@elte.hu>
 <20110706165357.GG4590@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110706165357.GG4590@erda.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robert Richter <robert.richter@amd.com> wrote:

> On 05.07.11 05:12:52, Ingo Molnar wrote:
> > 
> > * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > 
> > > > Overall, my approach improves the perf design. It adds a better 
> > > > and more intuitve access to perf from user space with clear and 
> > > > common methods and interfaces. Please let me know the concerns 
> > > > you have.
> > > 
> > > Its redundant, this interface ship has sailed, its not going to 
> > > happen.
> > 
> > Even if we had the choice, i don't see how a /dev based enumeration 
> > of PMUs is in any way better than a topologically attached set of 
> > PMUs in /sys.
> > 
> > This kind of structure is nice in principle:
> > 
> >  # ls -l /dev/pmu/
> >  total 0
> >  crw-rw---- 1 root root 254, 5 Jul  8  2011 breakpoint
> >  crw-rw---- 1 root root 254, 4 Jul  8  2011 cpu
> >  crw-rw---- 1 root root 254, 6 Jul  8  2011 proto
> >  crw-rw---- 1 root root 254, 1 Jul  8  2011 software
> >  crw-rw---- 1 root root 254, 2 Jul  8  2011 tracepoint
> > 
> > But it should be done in /sys/.
> 
> I have to learn yet why /dev is bad and /sys is good...

Because /sys is already there and already carries rather rich 
classification of various hardware components, devices and kernel 
subsystems.

/dev/ is mostly a flat registry of classical, unstructured devices.

> The system topology is always in /sys, also for device nodes. But 
> we can't get a device file descriptor from /sys. I doubt /sys is 
> capable to handle a device use count (need to be checked). We 
> actually must grab the pmu while attaching events to it. And, user 
> space implementation is must easier with /dev (see code in my 
> previous mail).

I think Peter suggested it that an open() done in /sys should give us 
a handle to a given event?

> My patch also includes code that creates a device class. It is also 
> visible in /sys/class/pmu/*.

But PMU is a very limited term: what we want is a higher level 
organization of 'event sources' and 'events'. Some may come from 
PMUs, many wont.

Thanks,

	Ingo
