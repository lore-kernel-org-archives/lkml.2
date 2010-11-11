Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539Ab0KKTgk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 14:36:40 -0500
Received: from casper.infradead.org ([85.118.1.10]:38928 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502Ab0KKTgj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 14:36:39 -0500
Subject: Re: [PATCH 1/3] perf-events: Add support for supplementary event
 registers
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@elte.hu,
        acme@redhat.com, eranian@google.com, Andi Kleen <ak@linux.intel.com>
In-Reply-To: <20101111192551.GI18718@basil.fritz.box>
References: <1289492117-18066-1-git-send-email-andi@firstfloor.org>
	 <1289502554.2084.153.camel@laptop> <20101111192551.GI18718@basil.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 11 Nov 2010 20:36:37 +0100
Message-ID: <1289504197.2084.172.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-11 at 20:25 +0100, Andi Kleen wrote:
> On Thu, Nov 11, 2010 at 08:09:14PM +0100, Peter Zijlstra wrote:

> > > +	int 				percore_used;
> > > +	struct intel_percore		*per_core;
> > 
> > Either per_core != NULL implies percore_used or it should be state
> > inside the struct.
> 
> It does not, I'll clarify.

Can we make it so, that is, move that int inside the intel_percore
struct?

> > > +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> > > @@ -1,5 +1,14 @@
> > >  #ifdef CONFIG_CPU_SUP_INTEL
> > >  
> > > +struct intel_percore {
> > > +	raw_spinlock_t lock;
> > > +	int ref;
> > > +	u64 config;
> > > +	unsigned extra_reg;
> > > +	u64 extra_config;
> > > +};
> > > +static DEFINE_PER_CPU(struct intel_percore, intel_percore);
> > 
> > Please dynamically allocate these when needed, just like the AMD
> > north-bridge structure.
> 
> Fully dynamic is difficult because the topology discovery does not 
> really handle that nicely.
> 
> I can allocate at boot, but it will not save a lot of memory
> (just one entry per core)
> 
> To be honest I would prefer not to do that change, are you sure
> you want it?

Hrm,.. but we only need to do this on nhm/wsm init, we already have code
detecting the cpu model. And I'm quite sure you know where to poke to
see if HT is enabled.
