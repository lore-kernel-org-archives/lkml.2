Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105Ab0KJX7x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 18:59:53 -0500
Received: from www.tglx.de ([62.245.132.106]:40491 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757116Ab0KJX7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 18:59:52 -0500
Date: Thu, 11 Nov 2010 00:58:50 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
cc: "Luck, Tony" <tony.luck@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, "bp@alien8.de" <bp@alien8.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mchehab@redhat.com" <mchehab@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: Tracing Requirements (was: [RFC/Requirements/Design] h/w error
 reporting)
In-Reply-To: <20101110232829.GC9299@Krystal>
Message-ID: <alpine.LFD.2.00.1011110046370.2900@localhost6.localdomain6>
References: <20101110174852.GB4001@elte.hu> <1289412329.12418.177.camel@gandalf.stny.rr.com> <1289413460.2084.27.camel@laptop> <20101110184105.GH22410@elte.hu> <1289415645.12418.180.camel@gandalf.stny.rr.com> <20101110191127.GA6190@nowhere>
 <20101110202316.GA32396@Krystal> <987664A83D2D224EAE907B061CE93D5301649A71DC@orsmsx505.amr.corp.intel.com> <20101110225115.GB9299@Krystal> <alpine.LFD.2.00.1011110004520.2900@localhost6.localdomain6> <20101110232829.GC9299@Krystal>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Nov 2010, Mathieu Desnoyers wrote:
> * Thomas Gleixner (tglx@linutronix.de) wrote:
> > > The reason why "concurrent read/write" is required is for server-class machines
> > > which needs to continuously be able to gather trace data to report/find/locate
> > > problematic scenarios happening. This means we're not only interested in one
> > > single failure, but rather by a whole set of erroneous/warning conditions that
> > > need to be reported. Stopping tracing every time data is gathered is
> > > inappropriate, because it would hide errors/warnings that would be happening
> > > during data collection.
> > 
> > Aargh! Just because it can be done all in one with an insane amount of
> > complexity does not mean that it's an absolute requirement and a good
> > solution.
> > 
> > So if you want to have both the flight recorder crash documentation
> > and the ongoing monitoring then use two separate sessions with
> > separate modes and be done with it.
> > 
> > Cramming both into the same session is just insane.
> > 
> 
> I'm afraid this is not what I proposed above. I'm open to use different tracing
> sessions for different things. However, the server-class case needs to
> continuously gather data so that "trace-shots" can be gathered when problems
> occur. But if you hit two problems back to back, you don't want to lose the
> trace leading to the second issue. Hence the motivation for supporting
> concurrent reading while writing.

Realistically, you are interested in the first one, simply because in
99.9% of the cases the second problem is caused by the first one. Do we
really need to care about the 0.1% which fall into the other category?

Not at all. Simply because the likeliness of those back to back events
_AND_ giving us the 0.1% case is approaching zero.

Of course you can argue with your academic hat on that I'm ignoring
that we might catch this rare "easter and xmas fall on the same day"
event, but I couldn't care less.

> I'd like to start with an implementation that skips some of these requirements
> initially, but what I really think we need to figure out is how we organize our
> ABIs to finally support these requirements.

I did not say, that you should not think about this, but the progress
so far in more than TWO YEARS is exaclty ZERO. And that's what I'm
concerned about.

Thanks,

	tglx
