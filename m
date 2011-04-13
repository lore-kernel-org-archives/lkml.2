Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933018Ab1DMVFz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 17:05:55 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:48120 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932979Ab1DMVFw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 17:05:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BEpKmZ0p8fYL8uulaozlBd8em7iWC/O7ZHc4z4Tkyf13xf7/KszMB4LEdy39Tg3ekH
         N8AHsIV0JNfw7QTRuYk05c8Li5gumCshQHgF7DIfsDXE+lH/8VnV/vsSFA5ozYj0GQD6
         WyX5Pz0dWiWHvU+spTcqpl0fg3TLiUCR1lJjw=
MIME-Version: 1.0
In-Reply-To: <1302726187.7911.11.camel@dev.znau.edu.ua>
References: <1302566227-23788-1-git-send-email-zajec5@gmail.com>
	<20110412133633.GR15130@legolas.emea.dhcp.ti.com>
	<1302634039.14216.10.camel@dev.znau.edu.ua>
	<BANLkTi=0sM2+nPYyd09G=Uy9rcEvaFErnA@mail.gmail.com>
	<1302635550.14216.21.camel@dev.znau.edu.ua>
	<BANLkTi=8mB9ZDTjF4yds6mkx+PmM+B_6Cg@mail.gmail.com>
	<4DA4AC4B.90409@hauke-m.de>
	<BANLkTiknRYWaDM1ThAxgXcdGqK8jeFaBPA@mail.gmail.com>
	<BANLkTikqKtJuDS17mfFvxzMoXuBtJvCgTA@mail.gmail.com>
	<1302640546.14216.65.camel@dev.znau.edu.ua>
	<BANLkTim8dmTL-BVK3fcWHNBU9Eyz1k_T+Q@mail.gmail.com>
	<op.vtvalzu33ri7v4@arend-laptop>
	<BANLkTik6JZ-n3sVjCFK_x1yNRH3_o3_6rg@mail.gmail.com>
	<1302726187.7911.11.camel@dev.znau.edu.ua>
Date: Wed, 13 Apr 2011 23:05:51 +0200
Message-ID: <BANLkTi=8HEysFXhcv5yn=ErWZkzzqPoSug@mail.gmail.com>
Subject: Re: [RFC][PATCH] axi: add AXI bus driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: George Kashperko <george@znau.edu.ua>
Cc: Arend van Spriel <arend@broadcom.com>, "balbi@ti.com" <balbi@ti.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
        =?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <rmk@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Andy Botting <andy@andybotting.com>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/13 George Kashperko <george@znau.edu.ua>:
>
>> 2011/4/13 Arend van Spriel <arend@broadcom.com>:
>> > On Tue, 12 Apr 2011 22:44:01 +0200, Rafał Miłecki <zajec5@gmail.com> wrote:
>> >
>> >> 2011/4/12 George Kashperko <george@znau.edu.ua>:
>> >>>>
>> >>>> 2011/4/12 Rafał Miłecki <zajec5@gmail.com>:
>> >>>> That way I see really low (or not at all) relation between out
>> >>>> (not)Broadcom bus and present AMBA bus.
>> >>>>
>> >>> Agree.
>> >>
>> >> Ehh, sounds like one more renaming to functions, defines, prefixes.
>> >>
>> >> Let's wait for Arend comments, he was the one voting for not-bcm-specific
>> >> name.
>> >>
>> >
>> > Hi Rafał,
>> >
>> > Still think its better to stick with a generic name even if currently you
>> > only come across this in Broadcom chips right now. I do agree that the term
>> > 'axi' is implying something else than what this bus driver is providing. The
>> > name 'axi-dmp' I gave earlier may be more to the point.
>> >
>> > I also looked at the amba driver after receiving comments on the brcmaxi
>> > library module (this is what Hauke Mehrtens referred to) and came to similar
>> > conclusion as you did. It does however support PM properly so you may want
>> > to get inspiration in that area. I also noticed a reference to AMBA term APB
>> > which is a different bus in the AMBA family. AXI was introduced later as
>> > higher performance bus (in AMBA rev3 if I remember correctly).
>>
>> I don't focus on PM yet, do not consider it a problem, it just needs some time.
>>
>> Note for not involved: AMBA is family with few buses/interfaces
>> possible: AXI, AHB, ASB, APB, ATB [1].
>>
>> So what are you saying is that drivers/amba/ is for AMBA APB? OK, I
>> can accept such a explanation and it makes me even more sure we need
>> another AMBA driver (this time: AMBA AXI).
> AMBA is AMBA. axi/apb/ahb etc are all subsets of AMBA and as of current
> all fit to what already is in drivers/amba.
>
>>
>> The left question is: how much of the implemented code is AMBA AXI
>> specific and how much is Broadcom specific?
>
> Answers to 1. and 2. are there in drivers/amba/bus.c
> Look _probe and _register fn for more details.

Not able to. There is some call to amba_get_enable_vcore in probe. It
calls regulator_enable. Which calls some
rdev->desc->ops->enable(rdev). I managed to track enable is part of
struct regulator_ops but I'm not brave enough to track where does it
come from, etc. There are many documented regulator ops, but not
general description. I would have to spend some time on it but I'm not
sure if it's worth that. Not to mention there is some additional
amba_get_enable_pclk which calls some more functions I didn't date to
check.


>> 1) Does AMBA AXI identify cores by manuf, id, rev and class? Is this
>> really AMBA AXI specific and a evolution from simple "id" in AMBA APB?
> During amba device registration amba bus code read component/peripheral
> id registers from known locations, exactly where
> peripherialid/componentid registers of master port (agent) core are.
> Look brcm80211/inclue/aidmp.h for those.

I guess you mean:
pid |= (readl(tmp + size - 0x20 + 4 * i) & 255) << (i * 8);
cid |= (readl(tmp + size - 0x10 + 4 * i) & 255) << (i * 8);
Well, OK, it proves Broadcom uses AMBA somehow, but not more than that
(at least for me).


>> 2) Is this standard for AMBA AXI to keep list of available cores in
>> some specific memory (is this always EPROM like in case of Bcm?)?
>> 3) Does every AMBA AXI device need enabling/disabling/resetting
>> routine we implemented? Is that really Bcm independent?
> Enable/disable abstracted by clocks interface.

Will comment on that later.

-- 
Rafał
