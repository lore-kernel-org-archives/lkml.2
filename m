Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528Ab1HENLd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 09:11:33 -0400
Received: from relay1.sgi.com ([192.48.179.29]:37476 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644Ab1HENLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 09:11:32 -0400
Date: Fri, 5 Aug 2011 08:13:41 -0500
From: Jack Steiner <steiner@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: tglx@linutronix.de, davej@redhat.com, yinghan@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] x86: Reduce clock calibration time during slave cpu
	startup
Message-ID: <20110805131341.GA27672@sgi.com>
References: <20110727135730.GA17717@sgi.com> <20110727140523.GA24206@redhat.com> <20110727141527.GA8453@sgi.com> <20110727155200.GA25381@redhat.com> <20110801184542.GA3939@sgi.com> <20110805104635.GB13055@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110805104635.GB13055@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 05, 2011 at 12:46:35PM +0200, Ingo Molnar wrote:
> 
> * Jack Steiner <steiner@sgi.com> wrote:
> 
> > +/*
> > + * Check if another cpu is in the same socket and has already been calibrated.
> > + * If found, use the previous value. This assumes all cores in the same physical
> > + * socket have the same core frequency.
> > +
> > +unsigned long __cpuinit calibrate_delay_is_known(void)
> > +{
> > +	int i, cpu = smp_processor_id();
> > +
> > +	if (!tsc_disabled && !cpu_has(&cpu_data(cpu), X86_FEATURE_CONSTANT_TSC))
> > +		return 0;
> > +
> > +	for_each_online_cpu(i)
> > +		if (cpu_data(i).phys_proc_id == cpu_data(cpu).phys_proc_id)
> > +			return cpu_data(i).loops_per_jiffy;
> 
> Hm, why do we have to make such an assumption? Cannot we query the 
> core frequency?

See V2 of the patch. The above assumption was removed & replaced by a check for
X86_FEATURE_CONSTANT_TSC & using the TSC for __delay(). If all cores see a
constant TSC frequency, then core frequency should not matter.

Does this make sense....


--- jack
