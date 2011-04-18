Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995Ab1DRMTp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 08:19:45 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:60830 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab1DRMTj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 08:19:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dXgoIlK2B4nQ82ZpVGy38XX+MUXW/Jx+awXQXo7H7ZAlqVEeMuJdLRwndVnXzuO7bM
         uMAr5k1nXyAE2TaqhQNnDFWYMK73xwiEInALUJne5l8EakcluzlXYPXQo6Lwa0rl6iiL
         iJB4p9bjLP+kLf4UctaRSy5BiYGkY6RQxQRyM=
MIME-Version: 1.0
In-Reply-To: <201104171938.12834.arnd@arndb.de>
References: <BANLkTim7Uj2tsgFngWhUqFK_hk3Leg+sQA@mail.gmail.com>
	<1302892585.30441.12.camel@dev.znau.edu.ua>
	<BANLkTi=16i+D8frz3X2f+JDtp4hbJKLL3A@mail.gmail.com>
	<201104171938.12834.arnd@arndb.de>
Date: Mon, 18 Apr 2011 14:19:38 +0200
Message-ID: <BANLkTim6iCAsViJQS4XrY-XObs8pp-BiQQ@mail.gmail.com>
Subject: Re: Could I (ab)use bus (struct bus_type) for virtual Broadcom bus?
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: George Kashperko <george@znau.edu.ua>, Hauke Mehrtens <hauke@hauke-m.de>,
        Russell King <rmk@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
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

W dniu 17 kwietnia 2011 19:38 użytkownik Arnd Bergmann <arnd@arndb.de> napisał:
> On Friday 15 April 2011, Rafał Miłecki wrote:
>> W dniu 15 kwietnia 2011 20:36 użytkownik George Kashperko
>> <george@znau.edu.ua> napisał:
>> >> >> Arnd: I found you saying:
>> >> >> > I believe the one thing we really want from this driver is the bus
>> >> >> > scan code, which is not present in the amba bus implementation,
>> >> >> I explained how it works, I believe scanning (EPROM in this case) it
>> >> >> Broadcom specific, not really AMBA standard. How do you see it?
>> >>
>> >> Maybe EPROM is not Broadcom specific, but I suspect the content we
>> >> deal with in bcmai/axi is Broadcom specific. I didn't see any notes of
>> >> manuf/id/rev/class we deal with. So I guess everything we (out
>> >> driver) read from EPROM is Bcm specific.
>> >>
>> >
>> > Played around amba registers on bcm4716. For all amba cores present
>> > (under all I mean broadcom ip core agents, oob router core, erom core,
>> > and other I-dont-know-what-for cores present at 0x18100000). All those
>> > feature AMBA_CID (0xb105f00d) as PrimeCell ID, and slightly different
>> > PrimeCell PeripheralIDs:
>> > * vendor 0xBB, part_number 0x368 for broadcom cores' agents;
>> > * vendor 0xBB, part_number 0x367 for OOB router core (don't ask me wth
>> > is this please);
>> > * vendor 0xBB, part_number 0x366 for EROM core;
>> >
>> > ARM vendor id is 0x41. Might 0xBB is Broadcom vendor id but I've found
>> > no evidence for that with google.
>>
>> Yeah, as I suspected, everything except Broadcom specific cores
>> matches AMBA standards quite nicely. Still, I don't see anything in it
>> we could use for driver.
>>
>> Let's wait for Russell and Arnd to comment.
>
> In general, the bus_type directly relates to how a device gets probed.
> If broadcom uses the same basic register layout as regular AMBA devices,
> it should use the amba bus type.

>From Broadcom side we *could* use some registers that are AMBA
specific, they are present... but there is totally no point in doing
that. Everything we use is Broadcom specific.


> I think it would be fine to extend the AMBA bus slightly if there are
> just minor differences.

As I said, Broadcom specific driver use nothing from AMBA common
things. Plus we implement routines that are Broadcom specific and no
other platform will use them.

-- 
Rafał
