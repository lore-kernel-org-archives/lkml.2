Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167Ab2IZUAS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 16:00:18 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61742 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376Ab2IZUAQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 16:00:16 -0400
MIME-Version: 1.0
In-Reply-To: <CABGkUuhte-0xUQTpehKid5jD5=pwDKNSG_2Cq7isTJkaBZKGHw@mail.gmail.com>
References: <1348433304-28320-1-git-send-email-tero.keski-valkama@neter.fi>
	<CABGkUujMCRazGy1+69SWBsS15B97rNEXWNsR4gG8D+5WyeF2jg@mail.gmail.com>
	<20120925090151.GB1247@liondog.tnic>
	<CABGkUugOvWCSfXvLW33jmntGYAAiPP9fStXbdRAozx3bEoKBOA@mail.gmail.com>
	<20120925222417.GA31780@liondog.tnic>
	<CABGkUuhte-0xUQTpehKid5jD5=pwDKNSG_2Cq7isTJkaBZKGHw@mail.gmail.com>
Date: Wed, 26 Sep 2012 23:00:14 +0300
X-Google-Sender-Auth: 6sLMiISqQcOe8NLgVl0kjg2lSPE
Message-ID: <CABGkUugaB4rmE_tiyEdhTPBaXUnE=a0A4w13U+L+Ux_NGrA4Vw@mail.gmail.com>
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

2012/9/26 Tero Keski-Valkama <tero.keski-valkama@neter.fi>:
> 2012/9/26 Borislav Petkov <bp@alien8.de>:
>> Adding Peter.
>>
>> On Tue, Sep 25, 2012 at 12:41:11PM +0300, Tero Keski-Valkama wrote:
>>> 2012/9/25 Borislav Petkov <bp@alien8.de>:
>>> > On Tue, Sep 25, 2012 at 10:34:13AM +0300, Tero Keski-Valkama wrote:
>>> >
>>> > But before we go with this any further: you mentioned some issues still
>>> > with acerhdf - you don't want to turn off your fan but to turn it to
>>> > full?
>>> >
>>> > I think in this case, you want to simply not load the driver and use the
>>> > BIOS settings, no?
>>> >
>>> > --
>>> > Regards/Gruss,
>>> >     Boris.
>>>
>>> Technically I think my original issue is about thermal zones, and BIOS
>>> control doesn't solve it as is. However, the patch should be valid,
>>> even if it doesn't solve my original issue.
>>>
>>> The thing is that passive cooling thermal zones throttle all the cores
>>> to stone age, to 800 MHz, before the fan even really starts powering
>>> up from the low default level.
>>
>> I don't understand: you want the thermal zones to not throttle your cpu
>> to 800 Mhz and/or the fan to start sooner?
>>
>>> So, my original problem would be solved
>>> by:
>>> a) Direct control of the fan, to be able to put it on full for example
>>> through userspace control,
>>
>> That's always a bad idea, especially if userspace dies on you.
>>
>>> b) Changing the active cooling thermal zones, so that the fan speeds
>>> up earlier, or
>>
>> Ok, I see, here's what you want.
>
> Yes. I disabled acpi_cpufreq and cpufreq daemon, so throttling to iron
> age didn't happen now, but the fan didn't start increasing cooling
> either. So while it seems during testing different values with the EC
> registers I achieved at one point automatic fan control by BIOS, but
> it's not the default state. The default state is still constant speed,
> as it was in the start, and I can't get it to change anymore.
>
>>
>> Also, you've added yourself to the copyright - this means that you're
>> pretty much going to get all future email about acerhdf. Do you really
>> want that?
>
> For now, that is what I want to the foreseeable future, as long as I
> own such a laptop. I can perhaps contribute to the development a bit.
>
>>
>> --
>> Regards/Gruss,
>>     Boris.
>
>
>
> --
> Kind Regards / Ystävällisin terveisin,
>
> Tero Keski-Valkama, MSc(Tech)
>
> +358 (0)46 876 0485
>
> tero.keski-valkama@neter.fi
> http://www.neter.fi

Now I have confirmed that:
a) In default state fan does not speed up even in temperatures above
90 degrees, and
b) Now, fan provably sped up, two times, at temperature of about 77 degrees.

The configuration now:
# ./acer_ec.pl regs

  	00	01	02	03	04	05	06	07	|	08	09	0A	0B	0C	0D	0E	0F
  	__	__	__	__	__	__	__	__	|	__	__	__	__	__	__	__	__
00 |	2	0	0	0	2	2	0	1	|	0	9	0	0	0	0	0	0	
10 |	0	0	0	0	0	0	0	0	|	0	0	0	0	0	0	0	0	
20 |	0	0	0	0	0	0	0	0	|	0	0	0	0	0	0	0	0	
30 |	0	0	0	0	0	0	0	0	|	0	0	0	0	0	0	0	0	
40 |	0	0	0	0	0	0	0	0	|	0	0	0	0	0	0	0	0	
50 |	0	0	0	0	0	34	0	0	|	0	0	0	0	0	0	0	0	
60 |	0	0	0	0	0	0	0	0	|	0	0	0	0	0	0	0	0	
70 |	0	0	0	0	0	0	0	0	|	0	0	0	0	0	0	0	0	
80 |	0	0	0	0	0	0	0	0	|	0	0	0	0	0	0	0	0	
90 |	83	65	78	89	79	0	0	0	|	0	65	83	49	48	68	51	49	
A0 |	0	0	0	128	193	0	0	95	|	255	0	0	14	100	31	0	0	
B0 |	0	0	0	80	78	0	0	0	|	0	9	0	4	0	2	17	17	
C0 |	19	0	201	15	63	171	155	48	|	48	42	48	17	201	15	100	31	
D0 |	0	0	0	0	25	124	156	35	|	0	0	2	19	0	0	224	64	
E0 |	0	0	0	59	16	50	16	47	|	16	0	0	0	0	0	0	0	
F0 |	75	16	0	0	3	63	0	0	|	68	0	0	0	0	0	0	0	

Somehow the fan speedup has always coincided with "acer_ec.pl regs"
command, which might be caused by:
a) Processor warms up in that command, or
b) Reading EC has some consequences.

The above register dump differs from the default boot-up state by
obviously registers to read, with volatile values, and:
- Register 0xAB from original value 0x08 to 0x0E.
- Register 0xAD from original value 0x17 to 0x1F.
This means that some of these register changes seem to enable
automatic BIOS fan control:
- FAN2 0 -> 1
- FANT 0 -> 1
- FANU 0x7 -> 0xF

I have been trying to do some web searches for these register names to
determine their meaning, but while many people have found them, they
have only made invalid or no documented guesses about their purpose.

-- 
Kind Regards / Ystävällisin terveisin,

Tero Keski-Valkama, MSc(Tech)

+358 (0)46 876 0485

tero.keski-valkama@neter.fi
http://www.neter.fi
