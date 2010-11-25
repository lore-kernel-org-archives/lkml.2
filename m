Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751158Ab0KYG0a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 01:26:30 -0500
Received: from mga09.intel.com ([134.134.136.24]:17133 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879Ab0KYG03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 01:26:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,253,1288594800"; 
   d="scan'208";a="680904318"
Subject: Re: [RFC PATCH 2/3 v2] perf: Implement Nehalem uncore pmu
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>, Andi Kleen <andi@firstfloor.org>,
        Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <1290665350.2072.521.camel@laptop>
References: <1290340877.2245.124.camel@localhost>
	 <8e9ff9280b0c4a059bc82b5c4a629897.squirrel@www.firstfloor.org>
	 <1290348259.2245.172.camel@localhost>	<1290361473.2153.39.camel@laptop>
	 <AANLkTik2_VLiKfZNC3BJeFnqS8kp7bMOg6qhJ1yPGmej@mail.gmail.com>
	 <1290644675.2405.90.camel@minggr.sh.intel.com>
	 <1290665350.2072.521.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Nov 2010 14:27:53 +0800
Message-ID: <1290666473.2405.108.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-25 at 14:09 +0800, Peter Zijlstra wrote:
> On Thu, 2010-11-25 at 08:24 +0800, Lin Ming wrote:
> > On Tue, 2010-11-23 at 18:00 +0800, Stephane Eranian wrote:
> > > On Sun, Nov 21, 2010 at 6:44 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > > > On Sun, 2010-11-21 at 22:04 +0800, Lin Ming wrote:
> > > >> On Sun, 2010-11-21 at 20:46 +0800, Andi Kleen wrote:
> > > >> > >
> > > >> > > 2. Uncore pmu NMI handling
> > > >> > >
> > > >> > > All the 4 cores are programmed to receive uncore counter overflow
> > > >> > > interrupt. The NMI handler(running on 1 of the 4 cores) handle all
> > > >> > > counters enabled by all 4 cores.
> > > >> >
> > > >> > Really for uncore monitoring there is no need to use an NMI handler.
> > > >> > You can't profile a core anyways, so you can just delay the reporting
> > > >> > a little bit. It may simplify the code to not use one here
> > > >> > and just use an ordinary handler.
> > > >>
> > > >> OK, I can use on ordinary interrupt handler here.
> > > >
> > > > Does the hardware actually allow using a different interrupt source?
> > > >
> > > It does not. It's using whatever you've programmed into the APIC
> > > LVT vector, AFAIK. Uncore interrupt mode is enabled via
> > > IA32_DEBUGCTL. Regarless of sampling or not, you need the interrupt
> > > to virtualize the counters to 64 bits.
> > 
> > If only counting(perf stat) makes sense for uncore events, do we still
> > need an interrupt handler?
> 
> Yep, I see no reason to dis-allow sampling. Sure its hard to make sense
> of it, but since there are people who offline all but one cpu of a
> package, I bet there are people who will run just one task on a package
> as well.
> 
> Just because it doesn't make sense in general doesn't mean there isn't
> anybody who'd want to do it and actually knows wth he's doing.
> 
> > 48 bits counter is not that easy to overflow in practice.
> 
> Still..

OK, will do more tests, then send out a new version.

Thanks.


