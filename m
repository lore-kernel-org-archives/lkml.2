Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966Ab1EGSdB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 14:33:01 -0400
Received: from mail.academy.zt.ua ([82.207.120.245]:42522 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755418Ab1EGSc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 14:32:58 -0400
X-Spam-Processed: mail.academy.zt.ua, Sat, 07 May 2011 21:32:45 +0300
	(not processed: message from trusted or authenticated source)
X-Authenticated-Sender: george@academy.zt.ua
X-HashCash: 1:20:110507:md50000002743::JzRIKVZAtQENsbR3:00008eII
X-Return-Path: prvs=110837b279=george@znau.edu.ua
X-Envelope-From: george@znau.edu.ua
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH][WAS:bcmai,axi] bcma: add Broadcom specific AMBA bus
	driver
From: George Kashperko <george@znau.edu.ua>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        b43-dev@lists.infradead.org, Greg KH <greg@kroah.com>,
        Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Arend van Spriel <arend@broadcom.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <rmk@arm.linux.org.uk>,
        Andy Botting <andy@andybotting.com>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <BANLkTikLFff_86Fvg+jSty9vGLENiELF2Q@mail.gmail.com>
References: <1304632783-8781-1-git-send-email-zajec5@gmail.com>
	 <201105061605.31625.arnd@arndb.de>
	 <BANLkTikjr0ZTNOu69F+iKhwufE9KKMg4Tg@mail.gmail.com>
	 <BANLkTimGBNT4FkS4mO9ToLWft0bCEYcEgg@mail.gmail.com>
	 <1304790665.13983.10.camel@dev.znau.edu.ua>
	 <BANLkTikLFff_86Fvg+jSty9vGLENiELF2Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Sat, 07 May 2011 21:26:35 +0300
Message-Id: <1304792795.13983.28.camel@dev.znau.edu.ua>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-19.el5) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 2011/5/7 George Kashperko <george@znau.edu.ua>:
> >
> >> 2011/5/6 Rafał Miłecki <zajec5@gmail.com>:
> >> > 2011/5/6 Arnd Bergmann <arnd@arndb.de>:
> >> >>> +const char *bcma_device_name(u16 coreid)
> >> >>> +{
> >> >>> +     switch (coreid) {
> >> >>> +     case BCMA_CORE_OOB_ROUTER:
> >> >>> +             return "OOB Router";
> >> >>> +     case BCMA_CORE_INVALID:
> >> >>> +             return "Invalid";
> >> >>> +     case BCMA_CORE_CHIPCOMMON:
> >> >>> +             return "ChipCommon";
> >> >>> +     case BCMA_CORE_ILINE20:
> >> >>> +             return "ILine 20";
> >> >>
> >> >> It's better to make that a data structure than a switch() statement,
> >> >> both from readability and efficiency aspects.
> >> >
> >> > Well, maybe. We call it only once, at init time. In any case we're
> >> > still waiting for Broadcom to clarify which cores are really used for
> >> > BCMA.
> >>
> >> Arnd: did you have a look at defines at all?
> >>
> >> Most of the defines have values in range 0x800 → 0x837. Converting
> >> this to array means loosing 0x800 u16 entries. We can not use 0x800
> >> offset, because there are also some defined between 0x000 and 0x800:
> >> #define BCMA_CORE_OOB_ROUTER           0x367   /* Out of band */
> >> #define BCMA_CORE_INVALID              0x700
> >>
> >> Oh and there is still:
> >> #define BCMA_CORE_DEFAULT              0xFFF
> >> we could want to include. Then we would loose additional (0xFFF -
> >> 0x837) u16 entries in array.
> > What is the purpose for bcma_device_name in bus driver code ? Why not
> > define const char *name in struct bcma_driver and let driver writers
> > supply kernel with knowledge on new cores' names rather than hard type
> > those into the bus code ?
> 
> The purpose is ridiculously trivial. Print user-friendly names on
> scanning. Why not do that?
Output like
Core 0: ChipCommon (id 0x800, rev 18, vendor 0x14e4)
and
Core 0: id 0x800, rev 18, vendor 0x14e4
both give to 99% of linux systems' end-users exactly the same consistent
information. Its more than enough for diagnostic purposes (I guess
scanning code does outputs this for diagnostic purposes by those less
than 1% of people who are aware wth is actually that ChipCommon is, not
to be just user friendly?).

For user firendly output you still can keep the name of the core in
dedicated driver.

> 
> Let's allow user understand what his bus contains without looking info
> defines in .h.
> 
> 
> > Also this will close the question Arend asked
> > you regarding same core ids with different manufacturer ids.
> 
> I don't know what was Arend's question. I asked but it was few minutes
> ago. I guess he just wanted to point there can be other manufacturer's
> cores.
> 
I guess core id 0x800 by 0x04BF vendor and 0x800 by 0x043B vendor will
both be reported as ChipCommon which most likely is wrong for second
one. Btw, ChipCommon is 0x500 for 4706 and there will be more new core
codes for new Broadcom devices. Don't think its right to build core
names database into kernel while there will be at most few of them used
on particular end system.

Have nice day,
George


