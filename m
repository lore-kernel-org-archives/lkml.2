Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750Ab1LBKoy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 05:44:54 -0500
Received: from marge.uochb.cas.cz ([147.231.129.3]:39150 "EHLO
	marge.uochb.cas.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311Ab1LBKox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 05:44:53 -0500
Message-ID: <4ED8AC1A.3050400@atlas.cz>
Date: Fri, 02 Dec 2011 11:44:42 +0100
From: Clarinet <clarinet@atlas.cz>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: Clarinet <clarinet@atlas.cz>, 647095@bugs.debian.org,
        Jonathan Nieder <jrnieder@gmail.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: Re: CPU hyperthreading turned on after soft power-cycle
References: <20111030110543.5872.61279.reportbug@supermicro.uochb.cas.cz>	 <1319988329.6759.88.camel@deadeye> <4EAE9D3A.7000108@atlas.cz>	 <4EB92181.5030500@seznam.cz> <20111110015212.GB2399@elie.gateway.2wire.net>	 <4EBD2825.6050806@atlas.cz> <4EC43DF7.4010902@atlas.cz>	 <1321561946.25715.16.camel@work-vm> <4EC59BCE.6050902@atlas.cz>	 <1321574019.25715.52.camel@work-vm> <4ECA51B9.3010707@seznam.cz>	 <1321905728.6445.2.camel@work-vm> <4ECAC340.8090908@atlas.cz>	 <1322533915.24090.69.camel@work-vm> <4ED4CF7C.8020808@atlas.cz> <1322609653.21423.46.camel@work-vm>
In-Reply-To: <1322609653.21423.46.camel@work-vm>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Ok, this also confirms that the board had issues *before* any changes
> were made to the RTC core. I'd push the board vendor to update the BIOS
> to avoid this issue.
>
> Even so, I'm curious as to what exactly trips it up. Maybe we can
> provide a module option for the rtc-cmos driver to disable the alarm
> functionality, so you can at least avoid the issue until the board
> vendor fixes the problem (if ever).
>
> Assuming its the alarm being set, could you try the following on a
> current kernel and let me know if it still shows the problem? hwclock
> might throw some odd messages with this test patch, but those can be
> ignored.

John,

I apllied the patch to 2.6.38 and tested the patched kernel - it is 
"bad", i.e. it exhibits the strange behavior the same way as unpatched 
2.6.38.

I understand that BIOS is bad, but I am also very curious what exactly 
in the kernel reveals the problem. Please let's go on with testing.

By the way, why do you think the problem appeared only when "halt" was 
called after running rtctest, and did not appear when "reboot" was 
called after running rtctest?

Best regards,

Jiri

>
> thanks
> -john
>
> diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
> index 05beb6c..d9814aa 100644
> --- a/drivers/rtc/rtc-cmos.c
> +++ b/drivers/rtc/rtc-cmos.c
> @@ -305,8 +305,8 @@ static void cmos_irq_enable(struct cmos_rtc *cmos, unsigned char mask)
>   	cmos_checkintr(cmos, rtc_control);
>
>   	rtc_control |= mask;
> -	CMOS_WRITE(rtc_control, RTC_CONTROL);
> -	hpet_set_rtc_irq_bit(mask);
> +//	CMOS_WRITE(rtc_control, RTC_CONTROL);
> +//	hpet_set_rtc_irq_bit(mask);
>
>   	cmos_checkintr(cmos, rtc_control);
>   }

