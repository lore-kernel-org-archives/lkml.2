Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758297Ab0EXWtv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 18:49:51 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:59202 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756844Ab0EXWtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 18:49:50 -0400
Subject: Re: [PATCH] x86: Export tsc related information in sysfs
From: john stultz <johnstul@us.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
       Brian Bloniarz <bmb@athenacr.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venki@google.com>, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <4BFAFE17.8060105@zytor.com>
References: <4BF58B59.7080901@athenacr.com>
	 <AANLkTinJ36UBMsVvTEoPnmAVS6np9Ja6heEtKA93r7tp@mail.gmail.com>
	 <ce764b91-11b0-44a5-9cf9-96977652bbd5@default>
	 <1274727116.2954.5.camel@localhost.localdomain>
	 <4BFADF9D.9050209@zytor.com 1274733566.2954.73.camel@localhost.localdomain>
	 <3ec7f284-1507-47fb-b5a2-eea29f68c627@default> <4BFAFE17.8060105@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 May 2010 15:49:22 -0700
Message-ID: <1274741362.2954.80.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-24 at 15:30 -0700, H. Peter Anvin wrote:
> On 05/24/2010 03:04 PM, Dan Magenheimer wrote:
> >>> Is that still the case?  I thought newer versions of NTP could deal
> >> with
> >>> large values.  Inaccuracies of way more than 500 ppm are everyday.
> >>
> >> That's scary.
> >>
> >> Yea, in the kernel the ntp freq correction tops out at 500ppm. Almost
> >> all the systems I see tend to fall in the +/- 200ppm range (if there's
> >> not something terribly wrong with the hardware).
> >>
> >> So maybe things aren't so bad out there? Or is that wishful thinking?
> > 
> > Since Brian's concern is at boot-time at which point there is no
> > network or ntp, and assuming that it would be unwise to vary tsc_khz
> > dynamically on a clocksource==tsc machine (is it?), would optionally
> > lengthening the TSC<->PIT calibration beyond 25ms result in a more
> > consistent tsc_khz between boots?  Or is the relative instability
> > an unavoidable result of skew between the PIT and the fixed constant
> > PIT_TICK_RATE combined with algorithmic/arithmetic error?  Or is
> > the jitter of the (spread-spectrum) TSC too extreme?  Or ???
> > 
> > If better more consistent calibration is possible, offering
> > that as an optional kernel parameter seems better than specifying
> > a fixed tsc_khz (stamped or user-specified) which may or may
> > not be ignored due to "too different from measured tsc_khz".
> > Even an (*optional*) extra second or two of boot time might
> > be perfectly OK if it resulted in an additional five or six
> > bits of tsc_khz precision.
> > 
> > Thoughts, Brian?
> 
> Making the calibration time longer should give a more precise result,
> but of course at the expense of longer boot time.
> 
> A longer sample would make sense if the goal is to freeze it into a
> kernel command line variable, but the real question is how many people
> would actually do that (and how many people would then suffer problems
> because they upgraded their CPU/mobo and got massive failures on post-boot.)

I'll admit its a feature for a minority of users. Probably why its not
included. 

And the upgraded system issue was something I tried to address by using
the calibrated value if it was off by some unreasonable amount, however
folks protested that, figuring since if its explicitly stated kernel
should not override it (ie: for the use case of where the calibration is
broken and folks want to force the value).

Also, you don't really need extra accuracy, you just need it to be the
same from boot to boot. NTP keeps the correction factor persistent from
boot to boot via the drift file. The boot argument is just trying to
save the time (possibly hours depending on ntp config) after a reboot
for NTP to correct for the new error introduced by calibration.

thanks
-john




