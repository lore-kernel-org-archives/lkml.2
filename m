Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953Ab1AKAR0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 19:17:26 -0500
Received: from sncsmrelay2.nai.com ([67.97.80.206]:37441 "EHLO
	sncsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136Ab1AKARY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 19:17:24 -0500
Message-ID: <4D2BA0C3.7090908@snapgear.com>
Date: Tue, 11 Jan 2011 10:13:55 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Al Viro <viro@zeniv.linux.org.uk>, Andreas Schwab <schwab@linux-m68k.org>,
        Thorsten Glaser <tg@mirbsd.de>, <linux-kernel@vger.kernel.org>,
        <linux-m68k@vger.kernel.org>
Subject: Re: Signal patchset
References: <AANLkTi=9B-8KN0oiXoiU+KqPt6B8Vs=d7yu9cui-7e1r@mail.gmail.com>	<20101215101027.GA31097@ZenIV.linux.org.uk>	<4D0A12EA.6040605@snapgear.com>	<AANLkTi=iddsbRr+N5iLuGBizbFFQ2JN9sgBFC_Q3uA2K@mail.gmail.com> <AANLkTik-9r_ZPkzVGowW2xT8h+QtVJ57q3mE6iKsuuVa@mail.gmail.com>
In-Reply-To: <AANLkTik-9r_ZPkzVGowW2xT8h+QtVJ57q3mE6iKsuuVa@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/11 23:17, Geert Uytterhoeven wrote:
> On Thu, Jan 6, 2011 at 21:42, Geert Uytterhoeven<geert@linux-m68k.org>  wrote:
>> On Thu, Dec 16, 2010 at 14:23, Greg Ungerer<gerg@snapgear.com>  wrote:
>>> On 15/12/10 20:10, Al Viro wrote:
>>>> On Sun, Dec 05, 2010 at 12:15:10PM +0100, Geert Uytterhoeven wrote:
>>>>
>>>>> Unless someone objects, I'm inclined to apply Al's patchset, as it
>>>>> improves the
>>>>> situation anyway.
>>>>>
>>>>> OK?
>>>>
>>>> FWIW, there's an m68knommu counterpart (ACKed by gerg a while ago).  The
>>>> entire bunch is on ftp.linux.org.uk/pub/people/viro/m68k-signals - both m68k
>>>> and m68knommu sets.  I don't know how you guys would prefer it done, since
>>
>> Thx, good the know the nommu part is there, as I don't seem to have it
>> in my mailbox.
>>
>>>> there's a trivial dependency between m68k and m68knommu parts of series -
>>>> the former has
>>>> +#ifndef __uClinux__
>>>> +#define __ARCH_WANT_SYS_RT_SIGSUSPEND
>>>> +#endif
>>>> in unistd.h and the latter does
>>>> -#ifndef __uClinux__
>>>>   #define __ARCH_WANT_SYS_RT_SIGSUSPEND
>>>> -#endif
>>>> Both parts switch to generic sys_rt_sigsuspend(), for mmu and nommu resp.,
>>>> so they need __ARCH_WANT_SYS_RT_SIGSUSPEND defined as soon as conversion
>>>> is done.  Other than that they are independent.
>>>
>>> I can make sure to send to Linus after Geert. Unless Geert you
>>> want to take and send both the m68k and m68knommu changes?
>>
>> I can take the m68knommu changes with your ack, too.
>> I'll try to take a look at it tomorrow...
>
> I applied the m68k part to master and for-2.6.38/for-linus.
> In addition, I applied the m68knommu part with Greg's acks added to for-next.
>
> Greg, please let me know if this is OK, so I can send a pull request to Linus
> after it's been cooking one night in linux-next.

Oh, yes, that is ok. (I see the pull request now :-)
I have a bunch of things in linux-next for m68knommu, and we
hit nothing there so I think it is all good.

Regards
Greg


>
>                          Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                  -- Linus Torvalds
>


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
