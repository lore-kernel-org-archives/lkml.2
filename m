Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098Ab0ICU2u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 16:28:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35933 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752829Ab0ICU2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 16:28:49 -0400
Date: Fri, 3 Sep 2010 22:28:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Renninger <trenn@suse.de>
Cc: Jean Pihet <jean.pihet@newoldbits.com>,
        Peter Zijlstra <peterz@infradead.org>, Len Brown <len.brown@intel.com>,
        Arjan Van De Ven <arjan@linux.intel.com>, arjan@infradead.org,
        Kevin Hilman <khilman@deeprootsystems.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing, perf: add more power related events
Message-ID: <20100903202839.GA8679@elte.hu>
References: <AANLkTikvbn3+JPc7pnGZk-H4B71MHTu+-vjuzfJw_7PC@mail.gmail.com>
 <201009032005.08268.trenn@suse.de>
 <20100903195555.GA1663@elte.hu>
 <201009032210.08524.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009032210.08524.trenn@suse.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -0.9
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.9 required=5.9 tests=BAYES_00,URIBL_RHS_DOB autolearn=no SpamAssassin version=3.2.5
	1.1 URIBL_RHS_DOB          Contains an URI of a new domain (Day Old Bread)
	[URIs: marc.info]
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Renninger <trenn@suse.de> wrote:

> On Friday 03 September 2010 21:55:55 Ingo Molnar wrote:
> > 
> > * Thomas Renninger <trenn@suse.de> wrote:
> > 
> > > Hi Jean,
> > > 
> > > Summary at the beginning if people stop reading on the details
> > > below...:
> > > Nice work!
> > > You have my vote to get this merged.
> > > I think it's up to Ingo to push it.
> > 
> > Well, the patch that got posted:
> > 
> >   [PATCH] tracing, perf: add more power related events
> > 
> > Only adds tracepoints to power.h, but doesnt actually use them anywhere 
> > ...
> > 
> > Is there a companion patch i missed?
> Yep.
> Jean has nicely made up a tiny website he refered to in his mail:
> http://www.omappedia.com/wiki/Power_Management_Debug_and_Profiling

Ah, that wasnt in the first patch. (Please re-start discussion threads 
when something is re-submitted)

Nice website. Looks like these new tracepoints are really useful.

> There he shows the whole big patch and states:

Generally it's nice to post patches to lkml too, so that people have 
something to discuss.

> Since the patch touches generic files (in include/trace/events/power.h), it is split in parts:
>     * generic code: submitted to the LKML, cf. http://marc.info/?l=linux-kernel&m=128195697205096&w=4 ,
>     * ARM/OMAP specific code for the already existing events: to be submitted to l-o, cf. http://www.spinics.net/lists/linux-omap/msg35357.html,
>     * ARM/OMAP specific code for the new events, to be submitted once the generic code is accepted. 
> 
> > Also, it would be nice to add it to x86 and to OMAP at once, and 
> > synchronize up all the power events
>
> I can add sleep state events to x86 acpi parts, but even these are, as 
> said, not that interesting as they might be on ARM ultra mobile use 
> cases.

Yeah - but as long as they are at least attempted to be cross-platform, 
that would be fine. The ACPI folks are Cc:-ed so they can object if they 
dont like something.

> > - and check how existing tools like 
> > powertop make use of such events - and sync it all up.
>
> Does powertop use these events?

It certainly does quite a few things wrt. power usage analysis. Arjan is 
on the Cc:, maybe he has an opinion about these tracepoints.

> > We dont want to have inconsistent, architecture-dependent events in 
> > the end, for obvious reasons.
>
> Jean also shows screenshots at the link above
> how perf timechart or the the corresponding
> gui app PyTimechart still works together with these.
> I can't see how the new events should break an existing app, they should
> just ignore events they are not aware of.

Yeah, extensions rarely break anything. What i mentioned was 
'inconsistent, architecture-dependent events', which is not a fact but a 
possible danger: as these new events are only for OMAP right now. They 
might be OK, they might be not OK - i dont know, that's why i suggested 
to make them cross-platform in practice too.

So it would be nice to get some feedback from the ACPI folks - but if 
you guys can also do an ACPI patch that would be even better!

Thanks,

	Ingo
