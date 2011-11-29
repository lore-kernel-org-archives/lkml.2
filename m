Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab1K2CcG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 21:32:06 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:38846 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291Ab1K2CcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 21:32:03 -0500
Message-ID: <1322533915.24090.69.camel@work-vm>
Subject: Re: CPU hyperthreading turned on after soft power-cycle
From: John Stultz <john.stultz@linaro.org>
To: Jiri Polach <clarinet@atlas.cz>
Cc: 647095@bugs.debian.org, Jonathan Nieder <jrnieder@gmail.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
Date: Mon, 28 Nov 2011 18:31:55 -0800
In-Reply-To: <4ECAC340.8090908@atlas.cz>
References: <20111030110543.5872.61279.reportbug@supermicro.uochb.cas.cz>
	 <1319988329.6759.88.camel@deadeye> <4EAE9D3A.7000108@atlas.cz>
	 <4EB92181.5030500@seznam.cz> <20111110015212.GB2399@elie.gateway.2wire.net>
	 <4EBD2825.6050806@atlas.cz> <4EC43DF7.4010902@atlas.cz>
	 <1321561946.25715.16.camel@work-vm> <4EC59BCE.6050902@atlas.cz>
	 <1321574019.25715.52.camel@work-vm> <4ECA51B9.3010707@seznam.cz>
	 <1321905728.6445.2.camel@work-vm> <4ECAC340.8090908@atlas.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 11112902-3270-0000-0000-00000230F7F9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-21 at 22:31 +0100, Jiri Polach wrote:
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index cb9a104..77b5273 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -640,7 +640,7 @@ config HPET_TIMER
> >   	  Choose N to continue using the legacy 8254 timer.
> >
> >   config HPET_EMULATE_RTC
> > -	def_bool y
> > +	def_bool n
> >   	depends on HPET_TIMER&&  (RTC=y || RTC=m || RTC_DRV_CMOS=m || RTC_DRV_CMOS=y)
> >
> >   config APB_TIMER
> 
> Applying this patch does not change anything, this kernel is "bad".

Using an older "known-good" kernel, could you build and run the test
case at the end of Documentation/rtc.txt a few times and see if it
triggers the same problem?

I'm suspicious that the setting the alarm is whats tripping the BIOS
into enabling the HT bit. Because with older kernels, we used PIE mode
irqs which hwclock usually uses at boot, but with newer kernels, we
emulate PIE via AIE alarm mode. So if the BIOS was broken before, you
wouldn't have noticed unless you tried to use AIE irqs.

If this doesn't work, I'll get some patches to both 2.6.27 and 2.6.28
kernels to debug the exact flow of how we're touching the hardware and
then we can further narrow it down.

thanks
-john



