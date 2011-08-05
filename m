Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765Ab1HEVjp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 17:39:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47681 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756070Ab1HEVjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 17:39:31 -0400
Date: Fri, 5 Aug 2011 23:38:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jack Steiner <steiner@sgi.com>
Cc: tglx@linutronix.de, davej@redhat.com, yinghan@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] x86: Reduce clock calibration time during slave cpu
 startup
Message-ID: <20110805213836.GB21114@elte.hu>
References: <20110727135730.GA17717@sgi.com>
 <20110727140523.GA24206@redhat.com>
 <20110727141527.GA8453@sgi.com>
 <20110727155200.GA25381@redhat.com>
 <20110801184542.GA3939@sgi.com>
 <20110805104635.GB13055@elte.hu>
 <20110805131638.GA27779@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110805131638.GA27779@sgi.com>
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


* Jack Steiner <steiner@sgi.com> wrote:

> On Fri, Aug 05, 2011 at 12:46:35PM +0200, Ingo Molnar wrote:
> > 
> > * Jack Steiner <steiner@sgi.com> wrote:
> > 
> > > +/*
> > > + * Check if another cpu is in the same socket and has already been calibrated.
> > > + * If found, use the previous value. This assumes all cores in the same physical
> > > + * socket have the same core frequency.
> > > +
> > > +unsigned long __cpuinit calibrate_delay_is_known(void)
> > > +{
> > > +	int i, cpu = smp_processor_id();
> > > +
> > > +	if (!tsc_disabled && !cpu_has(&cpu_data(cpu), X86_FEATURE_CONSTANT_TSC))
> > > +		return 0;
> > > +
> > > +	for_each_online_cpu(i)
> > > +		if (cpu_data(i).phys_proc_id == cpu_data(cpu).phys_proc_id)
> > > +			return cpu_data(i).loops_per_jiffy;
> > 
> > Hm, why do we have to make such an assumption? Cannot we query the 
> > core frequency?
> 
> >> See V2 of the patch. The above assumption was removed & replaced by a check for
> >> X86_FEATURE_CONSTANT_TSC & using the TSC for __delay(). If all cores see a
> >> constant TSC frequency, then core frequency should not matter.
> >> 
> >> Does this make sense....
> 
> 
> Ahhh..  I see what you mean. I failed to update the comment in the code.
> Aside from the bogus comment (I'll send a V3 with a fixed comment), does the patch
> look ok.

Well, it still uses heuristics: it assumes frequency is the same when 
the cpuid data tells us that two CPUs are on the same socket, right?

Cannot we directly see the frequency(ies) of the CPU, and decide 
based on that whether the calibration result can be cached?

Thanks,

	Ingo
