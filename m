Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944Ab1KUVbs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 16:31:48 -0500
Received: from marge.uochb.cas.cz ([147.231.129.3]:37291 "EHLO
	marge.uochb.cas.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628Ab1KUVbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 16:31:46 -0500
Message-ID: <4ECAC340.8090908@atlas.cz>
Date: Mon, 21 Nov 2011 22:31:44 +0100
From: Jiri Polach <clarinet@atlas.cz>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: Jiri Polach <clarinet@atlas.cz>, 647095@bugs.debian.org,
        Jonathan Nieder <jrnieder@gmail.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: Re: CPU hyperthreading turned on after soft power-cycle
References: <20111030110543.5872.61279.reportbug@supermicro.uochb.cas.cz>	 <1319988329.6759.88.camel@deadeye> <4EAE9D3A.7000108@atlas.cz>	 <4EB92181.5030500@seznam.cz> <20111110015212.GB2399@elie.gateway.2wire.net>	 <4EBD2825.6050806@atlas.cz> <4EC43DF7.4010902@atlas.cz>	 <1321561946.25715.16.camel@work-vm> <4EC59BCE.6050902@atlas.cz>	 <1321574019.25715.52.camel@work-vm> <4ECA51B9.3010707@seznam.cz> <1321905728.6445.2.camel@work-vm>
In-Reply-To: <1321905728.6445.2.camel@work-vm>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>> Yea. My rough guess is that the BIOS is somehow sensitive to how the
>>> CMOS RTC is touched.
>>>
>>> Does disabling CONFIG_HPET_EMULATE_RTC change the behavior?
>>
>> But how do I do it? :-)
>>
>> I have not found a way to disable it in "menuconfig". If I comment it
>> out manually in .config, it is automatically set back to "y" as soon as
>> compilation starts ...
>
> Good point. I forgot on x86_64 you can't disable HPET_TIMER.
>
> Could you then use the following patch (and run make oldconfig before
> building).
>
> thanks
> -john
>
>
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index cb9a104..77b5273 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -640,7 +640,7 @@ config HPET_TIMER
>   	  Choose N to continue using the legacy 8254 timer.
>
>   config HPET_EMULATE_RTC
> -	def_bool y
> +	def_bool n
>   	depends on HPET_TIMER&&  (RTC=y || RTC=m || RTC_DRV_CMOS=m || RTC_DRV_CMOS=y)
>
>   config APB_TIMER

Applying this patch does not change anything, this kernel is "bad".

Jiri Polach

