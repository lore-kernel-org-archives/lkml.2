Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081Ab1DLTxg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 15:53:36 -0400
Received: from server19320154104.serverpool.info ([193.201.54.104]:45711 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756894Ab1DLTxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 15:53:35 -0400
X-Greylist: delayed 361 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Apr 2011 15:53:34 EDT
Message-ID: <4DA4AC4B.90409@hauke-m.de>
Date: Tue, 12 Apr 2011 21:47:23 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: George Kashperko <george@znau.edu.ua>, balbi@ti.com,
        linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        b43-dev@lists.infradead.org,
        =?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <mb@bu3sch.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Arend van Spriel <arend@broadcom.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <rmk@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Andy Botting <andy@andybotting.com>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] axi: add AXI bus driver
References: <1302566227-23788-1-git-send-email-zajec5@gmail.com>	<20110412133633.GR15130@legolas.emea.dhcp.ti.com>	<1302634039.14216.10.camel@dev.znau.edu.ua>	<BANLkTi=0sM2+nPYyd09G=Uy9rcEvaFErnA@mail.gmail.com>	<1302635550.14216.21.camel@dev.znau.edu.ua> <BANLkTi=8mB9ZDTjF4yds6mkx+PmM+B_6Cg@mail.gmail.com>
In-Reply-To: <BANLkTi=8mB9ZDTjF4yds6mkx+PmM+B_6Cg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafał,

On 04/12/2011 09:27 PM, Rafał Miłecki wrote:
> 2011/4/12 George Kashperko <george@znau.edu.ua>:
>>
>>> 2011/4/12 George Kashperko <george@znau.edu.ua>:
>>>>
>>>>> Hi,
>>>>>
>>>>> On Tue, Apr 12, 2011 at 01:57:07AM +0200, Rafał Miłecki wrote:
>>>>>> Cc: Michael Büsch <mb@bu3sch.de>
>>>>>> Cc: Larry Finger <Larry.Finger@lwfinger.net>
>>>>>> Cc: George Kashperko <george@znau.edu.ua>
>>>>>> Cc: Arend van Spriel <arend@broadcom.com>
>>>>>> Cc: linux-arm-kernel@lists.infradead.org
>>>>>> Cc: Russell King <rmk@arm.linux.org.uk>
>>>>>> Cc: Arnd Bergmann <arnd@arndb.de>
>>>>>> Cc: Andy Botting <andy@andybotting.com>
>>>>>> Cc: linuxdriverproject <devel@linuxdriverproject.org>
>>>>>> Cc: linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>
>>>>>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>>>>>> ---
>>>>>> V2: Rename to axi
>>>>>>     Use DEFINE_PCI_DEVICE_TABLE in bridge
>>>>>>     Make use of pr_fmt and pr_*
>>>>>>     Store core class
>>>>>>     Rename bridge to not b43 specific
>>>>>>     Replace magic 0x1000 with BCMAI_CORE_SIZE
>>>>>>     Remove some old "ssb" names and defines
>>>>>>     Move BCMAI_ADDR_BASE def
>>>>>>     Add drvdata field
>>>>>> V3: Fix reloading (kfree issue)
>>>>>>     Add 14e4:0x4331
>>>>>>     Fix non-initialized struct issue
>>>>>>     Drop useless inline functions wrappers for pci core drv
>>>>>>     Proper pr_* usage
>>>>>> V3.1: Include forgotten changes (pr_* and include related)
>>>>>>     Explain why we dare to implement empty release function
>>>>>
>>>>> I'm not sure we need this. If you have an IP Core which talks AXI and
>>>>> you want to put it on a PCI bus, you will have a PCI Bus wrapper around
>>>>> that IP Core, so you should go and let the kernel know about that. See
>>>>> [1] for a core IP which talks AXI and [2] for a PCI bus glue layer.
>>>>>
>>>>> Besides, if you introduce this bus layer, it'll be more difficult for
>>>>> other licensees of the same core to re-use the same driver, since it's
>>>>> now talking a PCI emulated on top of AXI. The same can be achieved with
>>>>> the platform_bus which is more widely used, specially on ARM SoCs.
>>>>>
>>>>> [1] http://gitorious.org/usb/usb/blobs/dwc3/drivers/usb/dwc3/core.c
>>>>> [2] http://gitorious.org/usb/usb/blobs/dwc3/drivers/usb/dwc3/dwc3-haps.c
>>>>>
>>>>
>>>> Already noticed earlier that AXI isnt really good name for
>>>> Broadcom-specific axi bus customization. As of tech docs available from
>>>> arm, corelink AXI cores use own identification registers which feature
>>>> different format and layout comparing to that we use for Broadcom cores.
>>>>
>>>> Maybe there is something "standartized" by the DMP specs? If so I'm
>>>> curious if that DMP is obligatory for every axi bus ?
>>>>
>>>> Naming particular Broadcom's implementation just axi limits other
>>>> licensees in reusing axi bus name/code or will require hacks/workarounds
>>>> from them to fit Broadcom-like core scanning/identificating techniques.
>>>> You use bus named AXI to group and manage Broadcom cores, while never
>>>> even publish device records for native axi cores Broadcom use to talk to
>>>> the interconnect through. Yet again, something like bcmb/bcmai looks
>>>> like better name for this bus.
>>>
>>> I don't know, I'm really tired of this. Earlier I was told to not use
>>> anything like bcmai, because it is not Broadcom specific. Now it seems
>>> (and I'm afraid I agree) there is quite a lot of Broadcom specific
>>> stuff.
>> Well, _if_ that "magic" EROM core layout is arm's "standard" for axi
>> ports identification _and_ _if_ that EROM core is obligatory axi
>> component then sure axi name is good one as soon as you consider
>> registering master port (agent) cores with device subsystem as well.
>> I have no clue here about how resolve those _if_'s, hopefully Broadcom
>> guys can enlighten us on the subject.
> 
> Do you think that in my code only scanning is Broadcom specific? In
> such a case we could keep it "axi", and just s/scan/bcmscan/. This is
> only correct choice if the rest (addressing, core enabling, host
> management) is AXI specific.

The specification for the AMBA AXI Interface is available for free
download from ARM if you register to their website and accept their license:
http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.set.amba/index.html
I got it from there without any problems and the license does not look
too bad for me, by having a quick look at it. I do not know if it will
help you in any way or if it is completely unrelated.

Why is the existing support for the amba bus not extended or used in any
way for this? It exists for some time in drivers/amba/. There already
was a discussion about this in https://lkml.org/lkml/2011/3/30/186 , but
with no result as I see.

>>>> Also can't figure out how is this implementation supposed to manage
>>>> multicore devices.
>>>
>>> We have got ideas, but let's first find (wait for) such a device ;)
>> bcm4716 usb host ? Don't really know if there are any other multicores.
> 
> This is SoC, we do not have any problems supporting multiple cores on
> SoCs. All cores are available at the same time, without any sliding
> windows.
> 

Hauke
