Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810Ab0HXRGI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 13:06:08 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:50019 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755155Ab0HXRGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 13:06:05 -0400
Subject: Re: [PATCH] x86, apic: Add apic calibration hook.
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.1008241532210.2768@localhost.localdomain>
References: <1282153304.15158.39.camel@ank32.eng.vmware.com>
	 <1282159660.15158.56.camel@ank32.eng.vmware.com>
	 <alpine.LFD.2.00.1008241532210.2768@localhost.localdomain>
Content-Type: text/plain
Organization: VMware INC.
Date: Tue, 24 Aug 2010 10:06:04 -0700
Message-Id: <1282669564.24498.2.camel@ank32.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

Thanks for taking a look.

On Tue, 2010-08-24 at 06:37 -0700, Thomas Gleixner wrote:
> On Wed, 18 Aug 2010, Alok Kataria wrote:
> >  
> > +static void __init initialize_lapic_clkevt(long delta)
> > +{
> > +	/* Calculate the scaled math multiplication factor */
> > +	lapic_clockevent.mult = div_sc(delta, TICK_NSEC * LAPIC_CAL_LOOPS,
> > +				       lapic_clockevent.shift);
> > +	lapic_clockevent.max_delta_ns =
> > +		clockevent_delta2ns(0x7FFFFF, &lapic_clockevent);
> > +	lapic_clockevent.min_delta_ns =
> > +		clockevent_delta2ns(0xF, &lapic_clockevent);
> > +}
> > +
> >  static int __init calibrate_APIC_clock(void)
> >  {
> > +	apic_calibration_res = x86_init.timers.calibrate_apic();
> > +	if (apic_calibration_res) {
> > +		struct clock_event_device *levt = &__get_cpu_var(lapic_events);
> > +		long delta;
> > +
> > +		if (lapic_clockevent.mult)
> > +			return 0;
> 
>   Why is this necessary ? calibrate_APIC_clock() is only called once.
> 

Yes, though timer.calibrate_apci() could behave differently on different
platforms. For eg. the vmware_calibrate_apic doesn't initialize any of
the lapic_clockevent state and we need this to set it up in that case.

Thanks,
Alok

