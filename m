Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573Ab1DLS7f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 14:59:35 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:49414 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab1DLS7d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 14:59:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=shfoGF9q2uu9uuZEWdpQWBqmRdwWKNtXtrRfXNJrPheJ5ahp2NK/M/AKt84ItVSmzJ
         k7N8LOf1y0l9L6e3Fj5sTD73ceD6kfkr6rEP1TYVbFRAcNVf5/SHZI3jkI0eLiVv0Qqu
         wOsXbVs1II3/vrgX410Kn6vMIs2Q+2fiAjcSk=
MIME-Version: 1.0
In-Reply-To: <1302634039.14216.10.camel@dev.znau.edu.ua>
References: <1302566227-23788-1-git-send-email-zajec5@gmail.com>
	<20110412133633.GR15130@legolas.emea.dhcp.ti.com>
	<1302634039.14216.10.camel@dev.znau.edu.ua>
Date: Tue, 12 Apr 2011 20:59:32 +0200
Message-ID: <BANLkTi=0sM2+nPYyd09G=Uy9rcEvaFErnA@mail.gmail.com>
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
>> Hi,
>>
>> On Tue, Apr 12, 2011 at 01:57:07AM +0200, Rafał Miłecki wrote:
>> > Cc: Michael Büsch <mb@bu3sch.de>
>> > Cc: Larry Finger <Larry.Finger@lwfinger.net>
>> > Cc: George Kashperko <george@znau.edu.ua>
>> > Cc: Arend van Spriel <arend@broadcom.com>
>> > Cc: linux-arm-kernel@lists.infradead.org
>> > Cc: Russell King <rmk@arm.linux.org.uk>
>> > Cc: Arnd Bergmann <arnd@arndb.de>
>> > Cc: Andy Botting <andy@andybotting.com>
>> > Cc: linuxdriverproject <devel@linuxdriverproject.org>
>> > Cc: linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>
>> > Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>> > ---
>> > V2: Rename to axi
>> >     Use DEFINE_PCI_DEVICE_TABLE in bridge
>> >     Make use of pr_fmt and pr_*
>> >     Store core class
>> >     Rename bridge to not b43 specific
>> >     Replace magic 0x1000 with BCMAI_CORE_SIZE
>> >     Remove some old "ssb" names and defines
>> >     Move BCMAI_ADDR_BASE def
>> >     Add drvdata field
>> > V3: Fix reloading (kfree issue)
>> >     Add 14e4:0x4331
>> >     Fix non-initialized struct issue
>> >     Drop useless inline functions wrappers for pci core drv
>> >     Proper pr_* usage
>> > V3.1: Include forgotten changes (pr_* and include related)
>> >     Explain why we dare to implement empty release function
>>
>> I'm not sure we need this. If you have an IP Core which talks AXI and
>> you want to put it on a PCI bus, you will have a PCI Bus wrapper around
>> that IP Core, so you should go and let the kernel know about that. See
>> [1] for a core IP which talks AXI and [2] for a PCI bus glue layer.
>>
>> Besides, if you introduce this bus layer, it'll be more difficult for
>> other licensees of the same core to re-use the same driver, since it's
>> now talking a PCI emulated on top of AXI. The same can be achieved with
>> the platform_bus which is more widely used, specially on ARM SoCs.
>>
>> [1] http://gitorious.org/usb/usb/blobs/dwc3/drivers/usb/dwc3/core.c
>> [2] http://gitorious.org/usb/usb/blobs/dwc3/drivers/usb/dwc3/dwc3-haps.c
>>
>
> Already noticed earlier that AXI isnt really good name for
> Broadcom-specific axi bus customization. As of tech docs available from
> arm, corelink AXI cores use own identification registers which feature
> different format and layout comparing to that we use for Broadcom cores.
>
> Maybe there is something "standartized" by the DMP specs? If so I'm
> curious if that DMP is obligatory for every axi bus ?
>
> Naming particular Broadcom's implementation just axi limits other
> licensees in reusing axi bus name/code or will require hacks/workarounds
> from them to fit Broadcom-like core scanning/identificating techniques.
> You use bus named AXI to group and manage Broadcom cores, while never
> even publish device records for native axi cores Broadcom use to talk to
> the interconnect through. Yet again, something like bcmb/bcmai looks
> like better name for this bus.

I don't know, I'm really tired of this. Earlier I was told to not use
anything like bcmai, because it is not Broadcom specific. Now it seems
(and I'm afraid I agree) there is quite a lot of Broadcom specific
stuff.


> Also can't figure out how is this implementation supposed to manage
> multicore devices.

We have got ideas, but let's first find (wait for) such a device ;)


> Any plans on embeddables' support ?

Sure, if noone will come before me, I'll try to provide support for
embedded devices. However basic support for PCI host in higher on my
priority list. First I want to know it is working at all ;)

-- 
Rafał
