Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212Ab0HXNhW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 09:37:22 -0400
Received: from www.tglx.de ([62.245.132.106]:56977 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607Ab0HXNhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 09:37:18 -0400
Date: Tue, 24 Aug 2010 15:37:10 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alok Kataria <akataria@vmware.com>
cc: "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, apic: Add apic calibration hook.
In-Reply-To: <1282159660.15158.56.camel@ank32.eng.vmware.com>
Message-ID: <alpine.LFD.2.00.1008241532210.2768@localhost.localdomain>
References: <1282153304.15158.39.camel@ank32.eng.vmware.com> <1282159660.15158.56.camel@ank32.eng.vmware.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Aug 2010, Alok Kataria wrote:
>  
> +static void __init initialize_lapic_clkevt(long delta)
> +{
> +	/* Calculate the scaled math multiplication factor */
> +	lapic_clockevent.mult = div_sc(delta, TICK_NSEC * LAPIC_CAL_LOOPS,
> +				       lapic_clockevent.shift);
> +	lapic_clockevent.max_delta_ns =
> +		clockevent_delta2ns(0x7FFFFF, &lapic_clockevent);
> +	lapic_clockevent.min_delta_ns =
> +		clockevent_delta2ns(0xF, &lapic_clockevent);
> +}
> +
>  static int __init calibrate_APIC_clock(void)
>  {
> +	apic_calibration_res = x86_init.timers.calibrate_apic();
> +	if (apic_calibration_res) {
> +		struct clock_event_device *levt = &__get_cpu_var(lapic_events);
> +		long delta;
> +
> +		if (lapic_clockevent.mult)
> +			return 0;

  Why is this necessary ? calibrate_APIC_clock() is only called once.

Thanks,

	tglx
