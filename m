Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751267Ab0DMFop (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 01:44:45 -0400
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:50528 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750772Ab0DMFoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 01:44:44 -0400
Message-ID: <4BC404C3.2090102@st.com>
Date: Tue, 13 Apr 2010 07:44:35 +0200
From: Giuseppe CAVALLARO <peppe.cavallaro@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10pre) Gecko/20100410 Shredder/3.0.5pre
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: re-adding clocksource_get_next ?
References: <4BBECED7.4010004@st.com>	 <x2p1f1b08da1004091358z1d185aacya6c0fa2f55322fc7@mail.gmail.com>	 <4BC2B770.3020501@st.com> <1271098218.3724.2.camel@localhost.localdomain>
In-Reply-To: <1271098218.3724.2.camel@localhost.localdomain>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 04/12/2010 08:50 PM, john stultz wrote:
> On Mon, 2010-04-12 at 08:02 +0200, Giuseppe CAVALLARO wrote:
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
>>
>> Hello John,
>>
>> john stultz wrote:
>>> On Thu, Apr 8, 2010 at 11:53 PM, Giuseppe CAVALLARO
>>> <peppe.cavallaro@st.com> wrote:
>>>> Hello!
>>>> this function was removed in the past but I've not clear all the details.
>>>> While testing LLTng, I wrote the patch, in attachment, that re-adds it
>>>> again.
>>>> The clocksource_get_next returns the first clock source available
>>>> (without looking at the rating).
>>>> In my environment, a clock source is a TMU channel (e.g. TMU1) and,
>>>> indeed, clocksource_get_next works fine.
>>>
>>> Could you provide some more details as to why you need raw access to
>>> the clocksource, instead of using something like ktime_get(),
>>> getrawmonotonic() or sched_clock()?
>>
>> I wanted to directly read the value of the TCNT register of a TMU
>> channel registered as clocksource in an SH platform.
>> My idea was to get the first clocksource available and than use the read
>> hook to get its raw value.
>> Indeed, on SH4, the clocksource_get_next returns the TMU channel 1
>> (usually registered as clocksource); the clk->reads points to
>> sh_tmu_clocksource_read (drivers/clocksource/sh_tmu.c). This returns the
>> value of the timer count register (TCNT).
> 
> If you specifically want the function sh_tmu_clocksource_read(), why not
> call it directly instead of indirecting through the clocksource
> infrastructure?
> 
> Additionally, since the clocksource code is dynamic, you might get a
> different clocksource then you expect (such as jiffies) depending on
> user config or user actions.
> 
> So I'd advise against using the clocksource code here.

This means I should export the sh_tmu_clocksource_read (currently
static) and don't pass for the clocksource code at all.

Thanks for your prompt feedback.

Best Regards,
Giuseppe

> thanks
> -john
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJLxATDAAoJEAm9vY9TshdvKI8H/1kuVTOCVEJvwjroRiy8X3eK
aW891639hsCcQYjmf+XGEuP9YUUP+n6sIMFqAB0tcNLNurJndmIumjQgsgyvniB/
5sI7B+nltyR+A5Z7jHjufXcmOr93DKv+3uudbbFDs0CREFuawR3LhSikkAdooPVR
ff0o7JYqknatsoZARRSrH/uQDDe0bWQLV0mT8sOIDmmMaOn2AE69IzA7CraKLchj
U0IW29OB6g6S+TwnXRA4+P6L8udNsR3ymEwL2jicj8TDoDUMBtoqO5cUivHalHWX
xokdi3vsgvZ3/3sGpnXYyOtueo8bQ2+XUbzbUdIhte9DdJliYSVuC2vAppU1z2A=
=8sFm
-----END PGP SIGNATURE-----
