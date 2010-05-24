Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833Ab0EXWeg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 18:34:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38961 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751593Ab0EXWef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 18:34:35 -0400
Message-ID: <4BFAFE17.8060105@zytor.com>
Date: Mon, 24 May 2010 15:30:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: john stultz <johnstul@us.ibm.com>, Brian Bloniarz <bmb@athenacr.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venki@google.com>, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Export tsc related information in sysfs
References: <4BF58B59.7080901@athenacr.com> <AANLkTinJ36UBMsVvTEoPnmAVS6np9Ja6heEtKA93r7tp@mail.gmail.com> <ce764b91-11b0-44a5-9cf9-96977652bbd5@default> <1274727116.2954.5.camel@localhost.localdomain> <4BFADF9D.9050209@zytor.com 1274733566.2954.73.camel@localhost.localdomain> <3ec7f284-1507-47fb-b5a2-eea29f68c627@default>
In-Reply-To: <3ec7f284-1507-47fb-b5a2-eea29f68c627@default>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2010 03:04 PM, Dan Magenheimer wrote:
>>> Is that still the case?  I thought newer versions of NTP could deal
>> with
>>> large values.  Inaccuracies of way more than 500 ppm are everyday.
>>
>> That's scary.
>>
>> Yea, in the kernel the ntp freq correction tops out at 500ppm. Almost
>> all the systems I see tend to fall in the +/- 200ppm range (if there's
>> not something terribly wrong with the hardware).
>>
>> So maybe things aren't so bad out there? Or is that wishful thinking?
> 
> Since Brian's concern is at boot-time at which point there is no
> network or ntp, and assuming that it would be unwise to vary tsc_khz
> dynamically on a clocksource==tsc machine (is it?), would optionally
> lengthening the TSC<->PIT calibration beyond 25ms result in a more
> consistent tsc_khz between boots?  Or is the relative instability
> an unavoidable result of skew between the PIT and the fixed constant
> PIT_TICK_RATE combined with algorithmic/arithmetic error?  Or is
> the jitter of the (spread-spectrum) TSC too extreme?  Or ???
> 
> If better more consistent calibration is possible, offering
> that as an optional kernel parameter seems better than specifying
> a fixed tsc_khz (stamped or user-specified) which may or may
> not be ignored due to "too different from measured tsc_khz".
> Even an (*optional*) extra second or two of boot time might
> be perfectly OK if it resulted in an additional five or six
> bits of tsc_khz precision.
> 
> Thoughts, Brian?

Making the calibration time longer should give a more precise result,
but of course at the expense of longer boot time.

A longer sample would make sense if the goal is to freeze it into a
kernel command line variable, but the real question is how many people
would actually do that (and how many people would then suffer problems
because they upgraded their CPU/mobo and got massive failures on post-boot.)

	-hpa
