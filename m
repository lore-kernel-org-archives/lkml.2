Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711Ab1DOTWN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 15:22:13 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:36471 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756554Ab1DOTWL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 15:22:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=syPbhzaxQVSaQO3nmjM/+Cy0gr78uCEhEDyUwDqJIZV1BfcoRT7N7kMjIX50DRLxyS
         ivQZHtXBi7bRV/zSAvQ+A/bfz6QN8u5806Sd0nysmwf0GEhjfzVNmlyytXXm6GezD00x
         Zk+WoQH3DHVDUPk8b8cVPqP9XxrRpSNm7sK2Y=
MIME-Version: 1.0
In-Reply-To: <1302892585.30441.12.camel@dev.znau.edu.ua>
References: <BANLkTim7Uj2tsgFngWhUqFK_hk3Leg+sQA@mail.gmail.com>
	<1302781431.21145.6.camel@dev.znau.edu.ua>
	<BANLkTinvpt5vs+rXd3WN-a2JpGtTV+=Gyg@mail.gmail.com>
	<4DA6E9BD.3090404@hauke-m.de>
	<BANLkTinu+Q367oqQPiUehPcbMs-SBxbwFg@mail.gmail.com>
	<1302786900.21965.52.camel@dev.znau.edu.ua>
	<BANLkTimM8=-pX+Ea8Eyp4XyvP1APbUof9w@mail.gmail.com>
	<1302892585.30441.12.camel@dev.znau.edu.ua>
Date: Fri, 15 Apr 2011 21:21:44 +0200
Message-ID: <BANLkTi=16i+D8frz3X2f+JDtp4hbJKLL3A@mail.gmail.com>
Subject: Re: Could I (ab)use bus (struct bus_type) for virtual Broadcom bus?
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: George Kashperko <george@znau.edu.ua>
Cc: Hauke Mehrtens <hauke@hauke-m.de>, Russell King <rmk@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arend van Spriel <arend@broadcom.com>,
        Jonas Gorski <jonas.gorski@gmail.com>, b43-dev@lists.infradead.org,
        Greg KH <greg@kroah.com>, Andy Botting <andy@andybotting.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 15 kwietnia 2011 20:36 użytkownik George Kashperko
<george@znau.edu.ua> napisał:
>> >> Arnd: I found you saying:
>> >> > I believe the one thing we really want from this driver is the bus
>> >> > scan code, which is not present in the amba bus implementation,
>> >> I explained how it works, I believe scanning (EPROM in this case) it
>> >> Broadcom specific, not really AMBA standard. How do you see it?
>> >>
>> > It might not Broadcom specific as EPROM core seems to be CoreLink one
>> > core and maybe is arm-developed. But it isn't documented publicly and we
>> > don't know yet if it is obligatory for all amba (or at least axi)
>> > interconnects or not.
>>
>> Maybe EPROM is not Broadcom specific, but I suspect the content we
>> deal with in bcmai/axi is Broadcom specific. I didn't see any notes of
>> manuf/id/rev/class we deal with. So I guess everything *we* (out
>> driver) read from EPROM is Bcm specific.
>>
>
> Played around amba registers on bcm4716. For all amba cores present
> (under all I mean broadcom ip core agents, oob router core, erom core,
> and other I-dont-know-what-for cores present at 0x18100000). All those
> feature AMBA_CID (0xb105f00d) as PrimeCell ID, and slightly different
> PrimeCell PeripheralIDs:
> * vendor 0xBB, part_number 0x368 for broadcom cores' agents;
> * vendor 0xBB, part_number 0x367 for OOB router core (don't ask me wth
> is this please);
> * vendor 0xBB, part_number 0x366 for EROM core;
>
> ARM vendor id is 0x41. Might 0xBB is Broadcom vendor id but I've found
> no evidence for that with google.

Yeah, as I suspected, everything except Broadcom specific cores
matches AMBA standards quite nicely. Still, I don't see anything in it
we could use for driver.

Let's wait for Russell and Arnd to comment.

-- 
Rafał
