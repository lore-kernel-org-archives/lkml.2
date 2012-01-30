Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab2A3KLd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 05:11:33 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58327 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576Ab2A3KLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 05:11:31 -0500
Date: Mon, 30 Jan 2012 11:11:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Andrew Steets <asteets@rgmadvisors.com>, linux-perf-users@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: perf: prctl(PR_TASK_PERF_EVENTS_DISABLE) has no effect
Message-ID: <20120130101121.GB8924@elte.hu>
References: <4F22D8D9.3010108@rgmadvisors.com>
 <20120128120151.GA10390@elte.hu>
 <4F248938.5030507@rgmadvisors.com>
 <20120129163235.GB23408@elte.hu>
 <1327917156.2446.191.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327917156.2446.191.camel@twins>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Sun, 2012-01-29 at 17:32 +0100, Ingo Molnar wrote:
> > * Andrew Steets <asteets@rgmadvisors.com> wrote:
> > 
> > > On 1/28/12 6:01 AM, Ingo Molnar wrote:
> > > 
> > > >> prctl(PR_TASK_PERF_EVENTS_DISABLE) doesn't appear to 
> > > >> disable perf event counters.  Here is a demonstration 
> > > >> program:
> > > >
> > > > btw., what's your usecase?
> > > 
> > > I'm trying to profile a small section of a long-running 
> > > program.  I ran into trouble using call-graph recording 
> > > and I thought this might be an alternative way of getting 
> > > what I was after.
> > 
> > That usecase indeed makes sense. Peter, could we allow this 
> > for privileged tasks, depending on the perf_paranoia 
> > settings or such?
> 
> I really dislike it. The sane way around this would be to 
> allow easy self-profiling instead of doing things arse about 
> face like that.

So, what workflow are you suggesting to Andrew?

I guess we are also hurting from the lack of dwarf stack 
backtrace decoding - that would allow the filtering by parent 
function without modifying the code. I think Frederic had a 
prototype working for 32-bit - any update on that?

Andrew could work that problem around right now by adding:

   -fno-omit-frame-pointer

to the build of the utility - that should activate -g and 
perf-report's --parent filter should also work fine.

Thanks,

	Ingo
