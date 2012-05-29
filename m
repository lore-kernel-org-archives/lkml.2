Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab2E2J7A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 05:59:00 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59719 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485Ab2E2J6t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 05:58:49 -0400
Message-ID: <1338285486.26856.16.camel@twins>
Subject: Re: [PATCH 13/15] sched: add bandwidth management for sched_dl.
From: Peter Zijlstra <peterz@infradead.org>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: tglx@linutronix.de, mingo@redhat.com, rostedt@goodmis.org, oleg@redhat.com,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, linux-kernel@vger.kernel.org,
        claudio@evidence.eu.com, michael@amarulasolutions.com,
        fchecconi@gmail.com, tommaso.cucinotta@sssup.it,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@ericsson.com, liming.wang@windriver.com,
        jkacur@redhat.com, harald.gustafsson@ericsson.com
Date: Tue, 29 May 2012 11:58:06 +0200
In-Reply-To: <4FC0B95C.5060207@gmail.com>
References: <1337809375-24295-1-git-send-email-juri.lelli@gmail.com>
	  <1337809375-24295-14-git-send-email-juri.lelli@gmail.com>
	 <1337942292.9783.178.camel@laptop> <4FC0B95C.5060207@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-05-26 at 13:07 +0200, Juri Lelli wrote:
> Hi,
> 
> On 05/25/2012 12:38 PM, Peter Zijlstra wrote:
> > On Wed, 2012-05-23 at 23:42 +0200, Juri Lelli wrote:
> >> +/*
> >> + * Coupling of -dl and -rt bandwidth.
> >> + *
> >> + * Here we check, while setting the system wide bandwidth available
> >> + * for -dl tasks and groups, if the new values are consistent with
> >> + * the system settings for the bandwidth available to -rt entities.
> >> + *
> >> + * IOW, we want to enforce that
> >> + *
> >> + *   rt_bandwidth + dl_bandwidth<= 100%
> >> + *
> >> + * is always true.
> >> + */
> >
> > I was thinking we could do it the other way around, have have
> > dl_bandwidth included in rt_bandwidth.
> >
> 
> If I understand correctly, you are proposing to treat -dl tasks as a
> special case of "real-time" tasks. Then we could reserve some bw to
> "real-time" (rt_bandwidth cap) activities and give a piece of this
> bw to -dl tasks (what remains is for -rt tasks). This is in principle
> nice and useful, but I'm not quite sure that this is the right point
> to achieve this logical behavior.
> I mean, -dl and -rt tasks are separately treated, so it is probably
> cleaner to manage their knobs separately. They have to coexist rather
> than be considered one a sub-case of the other. A better way to go
> for a common cap for them is probably the (long-term) hierarchical
> scheduling mechanism.
> 
> So, I would prefer to keep the interface as is for now, but I can also
> completely misunderstood your thoughts :-P.

The thing is, keeping it separate makes for an impossible configuration
scenario. Esp. once we enable !root usage. The proposed 5% is very
limiting and regular users won't have sufficient privilege to change it.

Also lowering FIFO/RR by default isn't a real option since people expect
that to get all time already (however silly that expectation is).





