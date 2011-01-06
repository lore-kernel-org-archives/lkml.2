Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734Ab1AFUmw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 15:42:52 -0500
Received: from mail-fx0-f66.google.com ([209.85.161.66]:35532 "EHLO
	mail-fx0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab1AFUmv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 15:42:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=MIr6HbtGzSMG+b96x8dt3a2YtSk4IiZRImrN7WV8xQIYOW0z+H+/xtyjBrWAueJHY4
         RsqG8w5MMjI3xljtByrZwF5o2l3sPEvf38zAoPvmaSgsM9lC1RqSwsZMarXMrl/hDPK3
         02qUnNLv4e2cYGOkBtCn6DbwE7aUMWq0OVr0g=
MIME-Version: 1.0
In-Reply-To: <4D0A12EA.6040605@snapgear.com>
References: <AANLkTi=9B-8KN0oiXoiU+KqPt6B8Vs=d7yu9cui-7e1r@mail.gmail.com>
	<20101215101027.GA31097@ZenIV.linux.org.uk>
	<4D0A12EA.6040605@snapgear.com>
Date: Thu, 6 Jan 2011 21:42:49 +0100
X-Google-Sender-Auth: w-hol0FCukjXPZDxiJyWG8Ng5As
Message-ID: <AANLkTi=iddsbRr+N5iLuGBizbFFQ2JN9sgBFC_Q3uA2K@mail.gmail.com>
Subject: Re: Signal patchset
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Ungerer <gerg@snapgear.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Andreas Schwab <schwab@linux-m68k.org>,
        Thorsten Glaser <tg@mirbsd.de>, linux-kernel@vger.kernel.org,
        linux-m68k@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 14:23, Greg Ungerer <gerg@snapgear.com> wrote:
> On 15/12/10 20:10, Al Viro wrote:
>> On Sun, Dec 05, 2010 at 12:15:10PM +0100, Geert Uytterhoeven wrote:
>>
>>> Unless someone objects, I'm inclined to apply Al's patchset, as it
>>> improves the
>>> situation anyway.
>>>
>>> OK?
>>
>> FWIW, there's an m68knommu counterpart (ACKed by gerg a while ago).  The
>> entire bunch is on ftp.linux.org.uk/pub/people/viro/m68k-signals - both m68k
>> and m68knommu sets.  I don't know how you guys would prefer it done, since

Thx, good the know the nommu part is there, as I don't seem to have it
in my mailbox.

>> there's a trivial dependency between m68k and m68knommu parts of series -
>> the former has
>> +#ifndef __uClinux__
>> +#define __ARCH_WANT_SYS_RT_SIGSUSPEND
>> +#endif
>> in unistd.h and the latter does
>> -#ifndef __uClinux__
>>  #define __ARCH_WANT_SYS_RT_SIGSUSPEND
>> -#endif
>> Both parts switch to generic sys_rt_sigsuspend(), for mmu and nommu resp.,
>> so they need __ARCH_WANT_SYS_RT_SIGSUSPEND defined as soon as conversion
>> is done.  Other than that they are independent.
>
> I can make sure to send to Linus after Geert. Unless Geert you
> want to take and send both the m68k and m68knommu changes?

I can take the m68knommu changes with your ack, too.
I'll try to take a look at it tomorrow...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
