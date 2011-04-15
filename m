Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406Ab1DOSj7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 14:39:59 -0400
Received: from mail.academy.zt.ua ([82.207.120.245]:8746 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab1DOSj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 14:39:57 -0400
X-MDAV-Processed: mail.academy.zt.ua, Fri, 15 Apr 2011 21:39:58 +0300
X-Spam-Processed: mail.academy.zt.ua, Fri, 15 Apr 2011 21:39:58 +0300
	(not processed: message from trusted or authenticated source)
X-Authenticated-Sender: george@academy.zt.ua
X-Return-Path: george@znau.edu.ua
X-Envelope-From: george@znau.edu.ua
Subject: Re: Could I (ab)use bus (struct bus_type) for virtual Broadcom bus?
From: George Kashperko <george@znau.edu.ua>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>, Russell King <rmk@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arend van Spriel <arend@broadcom.com>,
        Jonas Gorski <jonas.gorski@gmail.com>, b43-dev@lists.infradead.org,
        Greg KH <greg@kroah.com>, Andy Botting <andy@andybotting.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <BANLkTimM8=-pX+Ea8Eyp4XyvP1APbUof9w@mail.gmail.com>
References: <BANLkTim7Uj2tsgFngWhUqFK_hk3Leg+sQA@mail.gmail.com>
	 <1302781431.21145.6.camel@dev.znau.edu.ua>
	 <BANLkTinvpt5vs+rXd3WN-a2JpGtTV+=Gyg@mail.gmail.com>
	 <4DA6E9BD.3090404@hauke-m.de>
	 <BANLkTinu+Q367oqQPiUehPcbMs-SBxbwFg@mail.gmail.com>
	 <1302786900.21965.52.camel@dev.znau.edu.ua>
	 <BANLkTimM8=-pX+Ea8Eyp4XyvP1APbUof9w@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 15 Apr 2011 21:36:25 +0300
Message-Id: <1302892585.30441.12.camel@dev.znau.edu.ua>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-19.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> Arnd: I found you saying:
> >> > I believe the one thing we really want from this driver is the bus
> >> > scan code, which is not present in the amba bus implementation,
> >> I explained how it works, I believe scanning (EPROM in this case) it
> >> Broadcom specific, not really AMBA standard. How do you see it?
> >>
> > It might not Broadcom specific as EPROM core seems to be CoreLink one
> > core and maybe is arm-developed. But it isn't documented publicly and we
> > don't know yet if it is obligatory for all amba (or at least axi)
> > interconnects or not.
> 
> Maybe EPROM is not Broadcom specific, but I suspect the content we
> deal with in bcmai/axi is Broadcom specific. I didn't see any notes of
> manuf/id/rev/class we deal with. So I guess everything *we* (out
> driver) read from EPROM is Bcm specific.
> 

Played around amba registers on bcm4716. For all amba cores present
(under all I mean broadcom ip core agents, oob router core, erom core,
and other I-dont-know-what-for cores present at 0x18100000). All those
feature AMBA_CID (0xb105f00d) as PrimeCell ID, and slightly different
PrimeCell PeripheralIDs:
* vendor 0xBB, part_number 0x368 for broadcom cores' agents;
* vendor 0xBB, part_number 0x367 for OOB router core (don't ask me wth
is this please);
* vendor 0xBB, part_number 0x366 for EROM core;

ARM vendor id is 0x41. Might 0xBB is Broadcom vendor id but I've found
no evidence for that with google.

Have nice day,
George


