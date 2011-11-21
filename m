Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab1KUN12 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 08:27:28 -0500
Received: from marge.uochb.cas.cz ([147.231.129.3]:52882 "EHLO
	marge.uochb.cas.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851Ab1KUN11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 08:27:27 -0500
Message-ID: <4ECA51B9.3010707@seznam.cz>
Date: Mon, 21 Nov 2011 14:27:21 +0100
From: Jiri Polach <jiri.polach@seznam.cz>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: Jiri Polach <clarinet@atlas.cz>, 647095@bugs.debian.org,
        Jonathan Nieder <jrnieder@gmail.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: Re: CPU hyperthreading turned on after soft power-cycle
References: <20111030110543.5872.61279.reportbug@supermicro.uochb.cas.cz>	 <1319988329.6759.88.camel@deadeye> <4EAE9D3A.7000108@atlas.cz>	 <4EB92181.5030500@seznam.cz> <20111110015212.GB2399@elie.gateway.2wire.net>	 <4EBD2825.6050806@atlas.cz> <4EC43DF7.4010902@atlas.cz>	 <1321561946.25715.16.camel@work-vm> <4EC59BCE.6050902@atlas.cz> <1321574019.25715.52.camel@work-vm>
In-Reply-To: <1321574019.25715.52.camel@work-vm>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>>> Finally! After another 50+ compilations a have it! It took some time as
>>>> first I had to find a reason why some revisions did not boot (almost 2/3
>>>> were unbootable and the first bad commit was among them). Having this
>>>> solved I have been able to bisect without "skipping". The result is
>>>> surprising (at least for me) - believe it or not, the first bad commit
>>>> is 6610e089 "RTC: Rework RTC code to use timerqueue for events" from
>>>> John Stultz (I am sending him a copy of this message).
>>>>
>>>> I would never expect this would be a problem, but my understanding of
>>>> this commit is very limited, so I am certainly missing the point.
>>>> However, I have tried to compile 2.6.38 (which was "bad") with "Real
>>>> Time Clock" configuration option turned off and it behaves "normally"
>>>> then (= is "good").
>>>
>>> Huh. That's *very* odd.  Is your system doing anything in-particular
>>> with the RTC?  I don't have a clue right off, so probably the next step
>>
>> Yes, it is very odd. The system does not do anything special with RTC.
>> It is a diskless computational workstation.
>>
>>> is doing a bit of instrumentation to try to figure out where exactly we
>>> trigger the behavior. Could you checkout commit 6610e089 and apply the
>>> patch below to see if we can't narrow it down?
>>
>> With the patch applied the system does not show the strange behavior (=
>> is "good").
>>
>>> Could you also send your .config to me?
>>
>> Sure. It is attached. I have found that if I turn CONFIG_RTC_DRV_CMOS
>> off, the system behaves normally (= is "good") too.
>
> Yea. My rough guess is that the BIOS is somehow sensitive to how the
> CMOS RTC is touched.
>
> Does disabling CONFIG_HPET_EMULATE_RTC change the behavior?

But how do I do it? :-)

I have not found a way to disable it in "menuconfig". If I comment it 
out manually in .config, it is automatically set back to "y" as soon as 
compilation starts ...

Thanks,

Jiri


