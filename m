Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999Ab1EGSsO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 14:48:14 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:45528 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901Ab1EGSsL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 14:48:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=emh+vQsA8xhSTE+dik0AHqbrKAm7VIz9T0uRBHe5Mb64y2ml2PjpdhJyZQChQtMpCO
         k+aY3s0/vCLswbru1xG/n05+x3C2jlNiqjEgbCHFqGRoRdr0YhDogsUQqqUhqZoB5pVX
         P038EjM4F8hRcccXKxrHfsYC0yiyZAy8JVazU=
MIME-Version: 1.0
In-Reply-To: <1304792795.13983.28.camel@dev.znau.edu.ua>
References: <1304632783-8781-1-git-send-email-zajec5@gmail.com>
	<201105061605.31625.arnd@arndb.de>
	<BANLkTikjr0ZTNOu69F+iKhwufE9KKMg4Tg@mail.gmail.com>
	<BANLkTimGBNT4FkS4mO9ToLWft0bCEYcEgg@mail.gmail.com>
	<1304790665.13983.10.camel@dev.znau.edu.ua>
	<BANLkTikLFff_86Fvg+jSty9vGLENiELF2Q@mail.gmail.com>
	<1304792795.13983.28.camel@dev.znau.edu.ua>
Date: Sat, 7 May 2011 20:48:10 +0200
Message-ID: <BANLkTi=6BFD4OmtU1WPxjbFJQe36=mZKEA@mail.gmail.com>
Subject: Re: [PATCH][WAS:bcmai,axi] bcma: add Broadcom specific AMBA bus driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: George Kashperko <george@znau.edu.ua>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        b43-dev@lists.infradead.org, Greg KH <greg@kroah.com>,
        =?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Arend van Spriel <arend@broadcom.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <rmk@arm.linux.org.uk>,
        Andy Botting <andy@andybotting.com>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/7 George Kashperko <george@znau.edu.ua>:
>
>> 2011/5/7 George Kashperko <george@znau.edu.ua>:
>> >
>> >> 2011/5/6 Rafał Miłecki <zajec5@gmail.com>:
>> >> > 2011/5/6 Arnd Bergmann <arnd@arndb.de>:
>> >> >>> +const char *bcma_device_name(u16 coreid)
>> >> >>> +{
>> >> >>> +     switch (coreid) {
>> >> >>> +     case BCMA_CORE_OOB_ROUTER:
>> >> >>> +             return "OOB Router";
>> >> >>> +     case BCMA_CORE_INVALID:
>> >> >>> +             return "Invalid";
>> >> >>> +     case BCMA_CORE_CHIPCOMMON:
>> >> >>> +             return "ChipCommon";
>> >> >>> +     case BCMA_CORE_ILINE20:
>> >> >>> +             return "ILine 20";
>> >> >>
>> >> >> It's better to make that a data structure than a switch() statement,
>> >> >> both from readability and efficiency aspects.
>> >> >
>> >> > Well, maybe. We call it only once, at init time. In any case we're
>> >> > still waiting for Broadcom to clarify which cores are really used for
>> >> > BCMA.
>> >>
>> >> Arnd: did you have a look at defines at all?
>> >>
>> >> Most of the defines have values in range 0x800 → 0x837. Converting
>> >> this to array means loosing 0x800 u16 entries. We can not use 0x800
>> >> offset, because there are also some defined between 0x000 and 0x800:
>> >> #define BCMA_CORE_OOB_ROUTER           0x367   /* Out of band */
>> >> #define BCMA_CORE_INVALID              0x700
>> >>
>> >> Oh and there is still:
>> >> #define BCMA_CORE_DEFAULT              0xFFF
>> >> we could want to include. Then we would loose additional (0xFFF -
>> >> 0x837) u16 entries in array.
>> > What is the purpose for bcma_device_name in bus driver code ? Why not
>> > define const char *name in struct bcma_driver and let driver writers
>> > supply kernel with knowledge on new cores' names rather than hard type
>> > those into the bus code ?
>>
>> The purpose is ridiculously trivial. Print user-friendly names on
>> scanning. Why not do that?
> Output like
> Core 0: ChipCommon (id 0x800, rev 18, vendor 0x14e4)
> and
> Core 0: id 0x800, rev 18, vendor 0x14e4
> both give to 99% of linux systems' end-users exactly the same consistent
> information. Its more than enough for diagnostic purposes (I guess
> scanning code does outputs this for diagnostic purposes by those less
> than 1% of people who are aware wth is actually that ChipCommon is, not
> to be just user friendly?).

Really, what's wrong with that? Does it kill anyone's pet we print
this? We also do:
pr_err("Scanning failed because of wrong CID\n");
return -1;
While we could drop pr_err. Why to do this? Advanced used can always
check what -1 means.

I just like this. I find situations when it's useful, while I don't
see real negatives. I want to keep this. Can we leave this that way?
Unless someone finds some really bad effects of this?


> For user firendly output you still can keep the name of the core in
> dedicated driver.

It won't work in case of core with no driver (not supported), driver
not compiled (someone didn't know it's needed for his system) and it
won't print nicely all bus devices in one place.


>> Let's allow user understand what his bus contains without looking info
>> defines in .h.
>>
>>
>> > Also this will close the question Arend asked
>> > you regarding same core ids with different manufacturer ids.
>>
>> I don't know what was Arend's question. I asked but it was few minutes
>> ago. I guess he just wanted to point there can be other manufacturer's
>> cores.
>>
> I guess core id 0x800 by 0x04BF vendor and 0x800 by 0x043B vendor will
> both be reported as ChipCommon which most likely is wrong for second
> one. Btw, ChipCommon is 0x500 for 4706 and there will be more new core
> codes for new Broadcom devices. Don't think its right to build core
> names database into kernel while there will be at most few of them used
> on particular end system.

This is constructive, I'll fix this, thanks.

-- 
Rafał
