Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868Ab1DLTqL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 15:46:11 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:53195 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756589Ab1DLTqH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 15:46:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iuhBLmoblph9K1VnMHlamK7s6JDq32Xh8Q+Td+zEGEqJcXD8FGW5S1lLb96GkBN4xw
         Mx4SqGYD44cEdWo+jcPq6LbkYvzKughHg5NT6wQkTA47wLfF3TQbjHbGMWMsAGuzriJv
         WEz8ypIPoLtPVyfSuzG4AWpZ8RwR5Nc2c6mZc=
MIME-Version: 1.0
In-Reply-To: <1302636861.14216.28.camel@dev.znau.edu.ua>
References: <1302566227-23788-1-git-send-email-zajec5@gmail.com>
	<20110412133633.GR15130@legolas.emea.dhcp.ti.com>
	<1302634039.14216.10.camel@dev.znau.edu.ua>
	<BANLkTi=0sM2+nPYyd09G=Uy9rcEvaFErnA@mail.gmail.com>
	<1302635550.14216.21.camel@dev.znau.edu.ua>
	<BANLkTi=8mB9ZDTjF4yds6mkx+PmM+B_6Cg@mail.gmail.com>
	<1302636861.14216.28.camel@dev.znau.edu.ua>
Date: Tue, 12 Apr 2011 21:46:05 +0200
Message-ID: <BANLkTi=7SiF=1XJYm_qQ0xYoGMK5QbGDuA@mail.gmail.com>
Subject: Re: [RFC][PATCH] axi: add AXI bus driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: George Kashperko <george@znau.edu.ua>
Cc: balbi@ti.com, linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        b43-dev@lists.infradead.org,
        =?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Arend van Spriel <arend@broadcom.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <rmk@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Andy Botting <andy@andybotting.com>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/12 George Kashperko <george@znau.edu.ua>:
>
>> 2011/4/12 George Kashperko <george@znau.edu.ua>:
>> >
>> >> 2011/4/12 George Kashperko <george@znau.edu.ua>:
>> >> >
>> >> >> Hi,
>> >> >>
>> >> >> On Tue, Apr 12, 2011 at 01:57:07AM +0200, Rafał Miłecki wrote:
>> >> >> > Cc: Michael Büsch <mb@bu3sch.de>
>> >> >> > Cc: Larry Finger <Larry.Finger@lwfinger.net>
>> >> >> > Cc: George Kashperko <george@znau.edu.ua>
>> >> >> > Cc: Arend van Spriel <arend@broadcom.com>
>> >> >> > Cc: linux-arm-kernel@lists.infradead.org
>> >> >> > Cc: Russell King <rmk@arm.linux.org.uk>
>> >> >> > Cc: Arnd Bergmann <arnd@arndb.de>
>> >> >> > Cc: Andy Botting <andy@andybotting.com>
>> >> >> > Cc: linuxdriverproject <devel@linuxdriverproject.org>
>> >> >> > Cc: linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>
>> >> >> > Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>> >> >> > ---
>> >> >> > V2: Rename to axi
>> >> >> >     Use DEFINE_PCI_DEVICE_TABLE in bridge
>> >> >> >     Make use of pr_fmt and pr_*
>> >> >> >     Store core class
>> >> >> >     Rename bridge to not b43 specific
>> >> >> >     Replace magic 0x1000 with BCMAI_CORE_SIZE
>> >> >> >     Remove some old "ssb" names and defines
>> >> >> >     Move BCMAI_ADDR_BASE def
>> >> >> >     Add drvdata field
>> >> >> > V3: Fix reloading (kfree issue)
>> >> >> >     Add 14e4:0x4331
>> >> >> >     Fix non-initialized struct issue
>> >> >> >     Drop useless inline functions wrappers for pci core drv
>> >> >> >     Proper pr_* usage
>> >> >> > V3.1: Include forgotten changes (pr_* and include related)
>> >> >> >     Explain why we dare to implement empty release function
>> >> >>
>> >> >> I'm not sure we need this. If you have an IP Core which talks AXI and
>> >> >> you want to put it on a PCI bus, you will have a PCI Bus wrapper around
>> >> >> that IP Core, so you should go and let the kernel know about that. See
>> >> >> [1] for a core IP which talks AXI and [2] for a PCI bus glue layer.
>> >> >>
>> >> >> Besides, if you introduce this bus layer, it'll be more difficult for
>> >> >> other licensees of the same core to re-use the same driver, since it's
>> >> >> now talking a PCI emulated on top of AXI. The same can be achieved with
>> >> >> the platform_bus which is more widely used, specially on ARM SoCs.
>> >> >>
>> >> >> [1] http://gitorious.org/usb/usb/blobs/dwc3/drivers/usb/dwc3/core.c
>> >> >> [2] http://gitorious.org/usb/usb/blobs/dwc3/drivers/usb/dwc3/dwc3-haps.c
>> >> >>
>> >> >
>> >> > Already noticed earlier that AXI isnt really good name for
>> >> > Broadcom-specific axi bus customization. As of tech docs available from
>> >> > arm, corelink AXI cores use own identification registers which feature
>> >> > different format and layout comparing to that we use for Broadcom cores.
>> >> >
>> >> > Maybe there is something "standartized" by the DMP specs? If so I'm
>> >> > curious if that DMP is obligatory for every axi bus ?
>> >> >
>> >> > Naming particular Broadcom's implementation just axi limits other
>> >> > licensees in reusing axi bus name/code or will require hacks/workarounds
>> >> > from them to fit Broadcom-like core scanning/identificating techniques.
>> >> > You use bus named AXI to group and manage Broadcom cores, while never
>> >> > even publish device records for native axi cores Broadcom use to talk to
>> >> > the interconnect through. Yet again, something like bcmb/bcmai looks
>> >> > like better name for this bus.
>> >>
>> >> I don't know, I'm really tired of this. Earlier I was told to not use
>> >> anything like bcmai, because it is not Broadcom specific. Now it seems
>> >> (and I'm afraid I agree) there is quite a lot of Broadcom specific
>> >> stuff.
>> > Well, _if_ that "magic" EROM core layout is arm's "standard" for axi
>> > ports identification _and_ _if_ that EROM core is obligatory axi
>> > component then sure axi name is good one as soon as you consider
>> > registering master port (agent) cores with device subsystem as well.
>> > I have no clue here about how resolve those _if_'s, hopefully Broadcom
>> > guys can enlighten us on the subject.
>>
>> Do you think that in my code only scanning is Broadcom specific? In
>> such a case we could keep it "axi", and just s/scan/bcmscan/. This is
>> only correct choice if the rest (addressing, core enabling, host
>> management) is AXI specific.
> We rely on core identification following its id/ven/rev/class layout
> from EROM. Corelink cores use different layout/location. Also core
> enabling/disabling are DMP related. Another _if_ here -- is DMP
> obligatory for all axi buses?

Why do you use "Corelink" name? Do you mean AMBA AXI cores? Please,
try to keep it simple, do not introduce more things we need to make
clear for this discussion.
What do you mean by DMP?


>> >> > Also can't figure out how is this implementation supposed to manage
>> >> > multicore devices.
>> >>
>> >> We have got ideas, but let's first find (wait for) such a device ;)
>> > bcm4716 usb host ? Don't really know if there are any other multicores.
>>
>> This is SoC, we do not have any problems supporting multiple cores on
>> SoCs. All cores are available at the same time, without any sliding
>> windows.
>>
> Multicores have multiple slave ports bound to single master port
> (agent). Individual core driver must be confident of its "partner"
> device/driver and both must know who is permitted to
> enable/disable/reset and who is not or there should be some other
> technique for agent management.

Let's leave that multi-core discussion for later, or I'll freak.

-- 
Rafał
