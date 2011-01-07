Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156Ab1AGNRS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 08:17:18 -0500
Received: from mail-fx0-f66.google.com ([209.85.161.66]:42730 "EHLO
	mail-fx0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096Ab1AGNRQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 08:17:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=pwGtM51FL3AMWnFA3mxdCMo7QYKbNUsrVoH/gFi2jJygEMYv0a5pmkDt5H+Dnjtn1/
         vyf/flbyFLa/gCz7Ngk3ojJz9v9SQ1UUXI+lFUYj8pRmOsN1B5E1n6V/XOMcjfu/0qks
         t4YWcsqh+YGm+NQ/QGEdgP6BClFdWFCRAf3Xo=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=iddsbRr+N5iLuGBizbFFQ2JN9sgBFC_Q3uA2K@mail.gmail.com>
References: <AANLkTi=9B-8KN0oiXoiU+KqPt6B8Vs=d7yu9cui-7e1r@mail.gmail.com>
	<20101215101027.GA31097@ZenIV.linux.org.uk>
	<4D0A12EA.6040605@snapgear.com>
	<AANLkTi=iddsbRr+N5iLuGBizbFFQ2JN9sgBFC_Q3uA2K@mail.gmail.com>
Date: Fri, 7 Jan 2011 14:17:13 +0100
X-Google-Sender-Auth: fHvbNN7Fc2RBdm8J2Jb7EGgTepo
Message-ID: <AANLkTik-9r_ZPkzVGowW2xT8h+QtVJ57q3mE6iKsuuVa@mail.gmail.com>
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

On Thu, Jan 6, 2011 at 21:42, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Thu, Dec 16, 2010 at 14:23, Greg Ungerer <gerg@snapgear.com> wrote:
>> On 15/12/10 20:10, Al Viro wrote:
>>> On Sun, Dec 05, 2010 at 12:15:10PM +0100, Geert Uytterhoeven wrote:
>>>
>>>> Unless someone objects, I'm inclined to apply Al's patchset, as it
>>>> improves the
>>>> situation anyway.
>>>>
>>>> OK?
>>>
>>> FWIW, there's an m68knommu counterpart (ACKed by gerg a while ago).  The
>>> entire bunch is on ftp.linux.org.uk/pub/people/viro/m68k-signals - both m68k
>>> and m68knommu sets.  I don't know how you guys would prefer it done, since
>
> Thx, good the know the nommu part is there, as I don't seem to have it
> in my mailbox.
>
>>> there's a trivial dependency between m68k and m68knommu parts of series -
>>> the former has
>>> +#ifndef __uClinux__
>>> +#define __ARCH_WANT_SYS_RT_SIGSUSPEND
>>> +#endif
>>> in unistd.h and the latter does
>>> -#ifndef __uClinux__
>>>  #define __ARCH_WANT_SYS_RT_SIGSUSPEND
>>> -#endif
>>> Both parts switch to generic sys_rt_sigsuspend(), for mmu and nommu resp.,
>>> so they need __ARCH_WANT_SYS_RT_SIGSUSPEND defined as soon as conversion
>>> is done.  Other than that they are independent.
>>
>> I can make sure to send to Linus after Geert. Unless Geert you
>> want to take and send both the m68k and m68knommu changes?
>
> I can take the m68knommu changes with your ack, too.
> I'll try to take a look at it tomorrow...

I applied the m68k part to master and for-2.6.38/for-linus.
In addition, I applied the m68knommu part with Greg's acks added to for-next.

Greg, please let me know if this is OK, so I can send a pull request to Linus
after it's been cooking one night in linux-next.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
