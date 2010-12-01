Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490Ab0LAD0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 22:26:18 -0500
Received: from mga02.intel.com ([134.134.136.20]:10398 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753968Ab0LAD0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 22:26:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,282,1288594800"; 
   d="scan'208";a="682617298"
Subject: Re: [RFC PATCH 2/3 v2] perf: Implement Nehalem uncore pmu
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <1290771419.2145.137.camel@laptop>
References: <1290340877.2245.124.camel@localhost>
	 <AANLkTikt8AkZjNahrzTStJ5qM0D4Z+H_7snZBgsABm24@mail.gmail.com>
	 <AANLkTimzEDXzF=hMzmNCvsPok1kqxd0vjNKuYur_+J5L@mail.gmail.com>
	 <AANLkTimN6_v6VibsNU70kV_QUnF4Fj0=M=Akp8aASE-3@mail.gmail.com>
	 <1290770652.2145.128.camel@laptop>
	 <AANLkTika3r2=gCh4nX-raRU3BoFpWMUEapn3w2bgyGAd@mail.gmail.com>
	 <1290771419.2145.137.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Dec 2010 11:28:43 +0800
Message-ID: <1291174123.2405.228.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-26 at 19:36 +0800, Peter Zijlstra wrote:
> On Fri, 2010-11-26 at 12:25 +0100, Stephane Eranian wrote:
> > On Fri, Nov 26, 2010 at 12:24 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > > On Fri, 2010-11-26 at 09:18 +0100, Stephane Eranian wrote:
> > >
> > >> In the perf_event model, given that any one of the 4 cores can be used
> > >> to program uncore events, you have no choice but to broadcast to all
> > >> 4 cores. Each has to demultiplex and figure out which of its counters
> > >> have overflowed.
> > >
> > > Not really, you can redirect all these events to the first online cpu of
> > > the node.
> > >
> > > You can re-write event->cpu in pmu::event_init(), and register cpu
> > > hotplug notifiers to migrate the state around.
> > >
> > I am sure you could. But then the user thinks the event is controlled
> > from CPUx when it's actually from CPUz. I am sure it can work but
> > that's confusing, especially interrupt-wise.
> 
> Well, its either that or keeping a node wide state like we do for AMD
> and serialize everything from there.
> 
> And I'm not sure what's most expensive, steering the interrupt to one
> core only, or broadcasting every interrupt, I'd favour the first
> approach.
> 
> The whole thing is a node-wide resource, so the user needs to think in
> nodes anyway, we already do a cpu->node mapping for identifying the
> thing.

How about a new sub-command for node-wide events statistics?

perf node -n <node> -e <event>?


