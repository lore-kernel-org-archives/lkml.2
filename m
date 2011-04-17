Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591Ab1DQRiq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 13:38:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:58959 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567Ab1DQRii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 13:38:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: Re: Could I (ab)use bus (struct bus_type) for virtual Broadcom bus?
Date: Sun, 17 Apr 2011 19:38:12 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: George Kashperko <george@znau.edu.ua>, Hauke Mehrtens <hauke@hauke-m.de>,
        Russell King <rmk@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arend van Spriel <arend@broadcom.com>,
        Jonas Gorski <jonas.gorski@gmail.com>, b43-dev@lists.infradead.org,
        Greg KH <greg@kroah.com>, Andy Botting <andy@andybotting.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
References: <BANLkTim7Uj2tsgFngWhUqFK_hk3Leg+sQA@mail.gmail.com> <1302892585.30441.12.camel@dev.znau.edu.ua> <BANLkTi=16i+D8frz3X2f+JDtp4hbJKLL3A@mail.gmail.com>
In-Reply-To: <BANLkTi=16i+D8frz3X2f+JDtp4hbJKLL3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201104171938.12834.arnd@arndb.de>
X-Provags-ID: V02:K0:XV8UxJcaeJYTytl3njh+vmfPQANC+llL+W2+tBTIAmq
 aHX4ELdFTmHvTwZMqEUyKgkk4iIzlLy0tg5+BisyCMfozjiY16
 RPhA1aBgiMZ0LzgQhjysK48VrWFJvqy0ZWWnXftgOyW9A3Duxc
 Sxyg4fYd2Xuf7U+amYdv/sAsYoX17sECQ6eQHKZrgpdlvMwvkv
 7+BSXYyHyf5D0kUAP5oxw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 April 2011, Rafał Miłecki wrote:
> W dniu 15 kwietnia 2011 20:36 użytkownik George Kashperko
> <george@znau.edu.ua> napisał:
> >> >> Arnd: I found you saying:
> >> >> > I believe the one thing we really want from this driver is the bus
> >> >> > scan code, which is not present in the amba bus implementation,
> >> >> I explained how it works, I believe scanning (EPROM in this case) it
> >> >> Broadcom specific, not really AMBA standard. How do you see it?
> >>
> >> Maybe EPROM is not Broadcom specific, but I suspect the content we
> >> deal with in bcmai/axi is Broadcom specific. I didn't see any notes of
> >> manuf/id/rev/class we deal with. So I guess everything we (out
> >> driver) read from EPROM is Bcm specific.
> >>
> >
> > Played around amba registers on bcm4716. For all amba cores present
> > (under all I mean broadcom ip core agents, oob router core, erom core,
> > and other I-dont-know-what-for cores present at 0x18100000). All those
> > feature AMBA_CID (0xb105f00d) as PrimeCell ID, and slightly different
> > PrimeCell PeripheralIDs:
> > * vendor 0xBB, part_number 0x368 for broadcom cores' agents;
> > * vendor 0xBB, part_number 0x367 for OOB router core (don't ask me wth
> > is this please);
> > * vendor 0xBB, part_number 0x366 for EROM core;
> >
> > ARM vendor id is 0x41. Might 0xBB is Broadcom vendor id but I've found
> > no evidence for that with google.
> 
> Yeah, as I suspected, everything except Broadcom specific cores
> matches AMBA standards quite nicely. Still, I don't see anything in it
> we could use for driver.
> 
> Let's wait for Russell and Arnd to comment.

In general, the bus_type directly relates to how a device gets probed.
If broadcom uses the same basic register layout as regular AMBA devices,
it should use the amba bus type.

Compare this to the PCI bus type, which essentially deals with devices
that have a PCI configuration space that contains generic (irq, memory,
vendor/device ID, ...) registers along with device specific registers.

I think it would be fine to extend the AMBA bus slightly if there are
just minor differences.

A new bus_type really only makes sense if you expect a lot of devices
to use this and you want to have the probing in the bus. If you only
want to have a way to enumerate devices that get created by the
parent driver, you can also use platform devices.

	Arnd
