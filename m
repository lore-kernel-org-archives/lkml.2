Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399Ab2IYXKF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 19:10:05 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:50172 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab2IYXKD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 19:10:03 -0400
MIME-Version: 1.0
In-Reply-To: <20120925222417.GA31780@liondog.tnic>
References: <1348433304-28320-1-git-send-email-tero.keski-valkama@neter.fi>
	<CABGkUujMCRazGy1+69SWBsS15B97rNEXWNsR4gG8D+5WyeF2jg@mail.gmail.com>
	<20120925090151.GB1247@liondog.tnic>
	<CABGkUugOvWCSfXvLW33jmntGYAAiPP9fStXbdRAozx3bEoKBOA@mail.gmail.com>
	<20120925222417.GA31780@liondog.tnic>
Date: Wed, 26 Sep 2012 02:10:01 +0300
X-Google-Sender-Auth: Dl7LTqpKtj_K0JvsEhnI0Mh1-E0
Message-ID: <CABGkUuhte-0xUQTpehKid5jD5=pwDKNSG_2Cq7isTJkaBZKGHw@mail.gmail.com>
Subject: Re: [PATCH 1/1] x86: Added support for Acer Aspire 5755G fan control.
From: Tero Keski-Valkama <tero.keski-valkama@neter.fi>
To: Borislav Petkov <bp@alien8.de>,
        Tero Keski-Valkama <tero.keski-valkama@neter.fi>,
        linux-kernel@vger.kernel.org, peter@piie.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/9/26 Borislav Petkov <bp@alien8.de>:
> Adding Peter.
>
> On Tue, Sep 25, 2012 at 12:41:11PM +0300, Tero Keski-Valkama wrote:
>> 2012/9/25 Borislav Petkov <bp@alien8.de>:
>> > On Tue, Sep 25, 2012 at 10:34:13AM +0300, Tero Keski-Valkama wrote:
>> >
>> > But before we go with this any further: you mentioned some issues still
>> > with acerhdf - you don't want to turn off your fan but to turn it to
>> > full?
>> >
>> > I think in this case, you want to simply not load the driver and use the
>> > BIOS settings, no?
>> >
>> > --
>> > Regards/Gruss,
>> >     Boris.
>>
>> Technically I think my original issue is about thermal zones, and BIOS
>> control doesn't solve it as is. However, the patch should be valid,
>> even if it doesn't solve my original issue.
>>
>> The thing is that passive cooling thermal zones throttle all the cores
>> to stone age, to 800 MHz, before the fan even really starts powering
>> up from the low default level.
>
> I don't understand: you want the thermal zones to not throttle your cpu
> to 800 Mhz and/or the fan to start sooner?
>
>> So, my original problem would be solved
>> by:
>> a) Direct control of the fan, to be able to put it on full for example
>> through userspace control,
>
> That's always a bad idea, especially if userspace dies on you.
>
>> b) Changing the active cooling thermal zones, so that the fan speeds
>> up earlier, or
>
> Ok, I see, here's what you want.

Yes. I disabled acpi_cpufreq and cpufreq daemon, so throttling to iron
age didn't happen now, but the fan didn't start increasing cooling
either. So while it seems during testing different values with the EC
registers I achieved at one point automatic fan control by BIOS, but
it's not the default state. The default state is still constant speed,
as it was in the start, and I can't get it to change anymore.

>
> Also, you've added yourself to the copyright - this means that you're
> pretty much going to get all future email about acerhdf. Do you really
> want that?

For now, that is what I want to the foreseeable future, as long as I
own such a laptop. I can perhaps contribute to the development a bit.

>
> --
> Regards/Gruss,
>     Boris.



-- 
Kind Regards / Ystävällisin terveisin,

Tero Keski-Valkama, MSc(Tech)

+358 (0)46 876 0485

tero.keski-valkama@neter.fi
http://www.neter.fi
