Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab1DLUNP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 16:13:15 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:62573 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272Ab1DLUNO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 16:13:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oHLwQ1nmUv32U97tAs1zpc8v/AHOeWXiJNLFWUttZiMkRKTHCV7fgpxUqkjrp7fxNA
         MjT9OsExlr6D4XNbioSCfkb3lqQdVKjvJQlMoqFvr8H39HkynfyB1sjYy403kvUjAkVB
         X2tAOE879B0RuB3l/6kb3Dn40sHvmceRpR+2U=
MIME-Version: 1.0
In-Reply-To: <BANLkTiknRYWaDM1ThAxgXcdGqK8jeFaBPA@mail.gmail.com>
References: <1302566227-23788-1-git-send-email-zajec5@gmail.com>
	<20110412133633.GR15130@legolas.emea.dhcp.ti.com>
	<1302634039.14216.10.camel@dev.znau.edu.ua>
	<BANLkTi=0sM2+nPYyd09G=Uy9rcEvaFErnA@mail.gmail.com>
	<1302635550.14216.21.camel@dev.znau.edu.ua>
	<BANLkTi=8mB9ZDTjF4yds6mkx+PmM+B_6Cg@mail.gmail.com>
	<4DA4AC4B.90409@hauke-m.de>
	<BANLkTiknRYWaDM1ThAxgXcdGqK8jeFaBPA@mail.gmail.com>
Date: Tue, 12 Apr 2011 22:13:12 +0200
Message-ID: <BANLkTikqKtJuDS17mfFvxzMoXuBtJvCgTA@mail.gmail.com>
Subject: Re: [RFC][PATCH] axi: add AXI bus driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: George Kashperko <george@znau.edu.ua>, balbi@ti.com,
        linux-wireless@vger.kernel.org,
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

2011/4/12 Rafał Miłecki <zajec5@gmail.com>:
> 2011/4/12 Hauke Mehrtens <hauke@hauke-m.de>:
>> Hi Rafał,
>>
>> On 04/12/2011 09:27 PM, Rafał Miłecki wrote:
>>> 2011/4/12 George Kashperko <george@znau.edu.ua>:
>>>>
>>>>> 2011/4/12 George Kashperko <george@znau.edu.ua>:
>>>>>>
>>>>>>> Hi,
>>>>>>>
>>>>>>> On Tue, Apr 12, 2011 at 01:57:07AM +0200, Rafał Miłecki wrote:
>>>>>>>> Cc: Michael Büsch <mb@bu3sch.de>
>>>>>>>> Cc: Larry Finger <Larry.Finger@lwfinger.net>
>>>>>>>> Cc: George Kashperko <george@znau.edu.ua>
>>>>>>>> Cc: Arend van Spriel <arend@broadcom.com>
>>>>>>>> Cc: linux-arm-kernel@lists.infradead.org
>>>>>>>> Cc: Russell King <rmk@arm.linux.org.uk>
>>>>>>>> Cc: Arnd Bergmann <arnd@arndb.de>
>>>>>>>> Cc: Andy Botting <andy@andybotting.com>
>>>>>>>> Cc: linuxdriverproject <devel@linuxdriverproject.org>
>>>>>>>> Cc: linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>
>>>>>>>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>>>>>>>> ---
>>>>>>>> V2: Rename to axi
>>>>>>>>     Use DEFINE_PCI_DEVICE_TABLE in bridge
>>>>>>>>     Make use of pr_fmt and pr_*
>>>>>>>>     Store core class
>>>>>>>>     Rename bridge to not b43 specific
>>>>>>>>     Replace magic 0x1000 with BCMAI_CORE_SIZE
>>>>>>>>     Remove some old "ssb" names and defines
>>>>>>>>     Move BCMAI_ADDR_BASE def
>>>>>>>>     Add drvdata field
>>>>>>>> V3: Fix reloading (kfree issue)
>>>>>>>>     Add 14e4:0x4331
>>>>>>>>     Fix non-initialized struct issue
>>>>>>>>     Drop useless inline functions wrappers for pci core drv
>>>>>>>>     Proper pr_* usage
>>>>>>>> V3.1: Include forgotten changes (pr_* and include related)
>>>>>>>>     Explain why we dare to implement empty release function
>>>>>>>
>>>>>>> I'm not sure we need this. If you have an IP Core which talks AXI and
>>>>>>> you want to put it on a PCI bus, you will have a PCI Bus wrapper around
>>>>>>> that IP Core, so you should go and let the kernel know about that. See
>>>>>>> [1] for a core IP which talks AXI and [2] for a PCI bus glue layer.
>>>>>>>
>>>>>>> Besides, if you introduce this bus layer, it'll be more difficult for
>>>>>>> other licensees of the same core to re-use the same driver, since it's
>>>>>>> now talking a PCI emulated on top of AXI. The same can be achieved with
>>>>>>> the platform_bus which is more widely used, specially on ARM SoCs.
>>>>>>>
>>>>>>> [1] http://gitorious.org/usb/usb/blobs/dwc3/drivers/usb/dwc3/core.c
>>>>>>> [2] http://gitorious.org/usb/usb/blobs/dwc3/drivers/usb/dwc3/dwc3-haps.c
>>>>>>>
>>>>>>
>>>>>> Already noticed earlier that AXI isnt really good name for
>>>>>> Broadcom-specific axi bus customization. As of tech docs available from
>>>>>> arm, corelink AXI cores use own identification registers which feature
>>>>>> different format and layout comparing to that we use for Broadcom cores.
>>>>>>
>>>>>> Maybe there is something "standartized" by the DMP specs? If so I'm
>>>>>> curious if that DMP is obligatory for every axi bus ?
>>>>>>
>>>>>> Naming particular Broadcom's implementation just axi limits other
>>>>>> licensees in reusing axi bus name/code or will require hacks/workarounds
>>>>>> from them to fit Broadcom-like core scanning/identificating techniques.
>>>>>> You use bus named AXI to group and manage Broadcom cores, while never
>>>>>> even publish device records for native axi cores Broadcom use to talk to
>>>>>> the interconnect through. Yet again, something like bcmb/bcmai looks
>>>>>> like better name for this bus.
>>>>>
>>>>> I don't know, I'm really tired of this. Earlier I was told to not use
>>>>> anything like bcmai, because it is not Broadcom specific. Now it seems
>>>>> (and I'm afraid I agree) there is quite a lot of Broadcom specific
>>>>> stuff.
>>>> Well, _if_ that "magic" EROM core layout is arm's "standard" for axi
>>>> ports identification _and_ _if_ that EROM core is obligatory axi
>>>> component then sure axi name is good one as soon as you consider
>>>> registering master port (agent) cores with device subsystem as well.
>>>> I have no clue here about how resolve those _if_'s, hopefully Broadcom
>>>> guys can enlighten us on the subject.
>>>
>>> Do you think that in my code only scanning is Broadcom specific? In
>>> such a case we could keep it "axi", and just s/scan/bcmscan/. This is
>>> only correct choice if the rest (addressing, core enabling, host
>>> management) is AXI specific.
>>
>> The specification for the AMBA AXI Interface is available for free
>> download from ARM if you register to their website and accept their license:
>> http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.set.amba/index.html
>> I got it from there without any problems and the license does not look
>> too bad for me, by having a quick look at it. I do not know if it will
>> help you in any way or if it is completely unrelated.
>>
>> Why is the existing support for the amba bus not extended or used in any
>> way for this? It exists for some time in drivers/amba/. There already
>> was a discussion about this in https://lkml.org/lkml/2011/3/30/186 , but
>> with no result as I see.
>
> I can see exactly nothing I could use from whatever driver/amba is.
> What does it do from things we need? How do you imagine using that
> with out (non)Broadcom buses?

1) I checked for amba_device_register:
http://lxr.free-electrons.com/ident?i=amba_device_register
and do not understand that. There are a lot of drivers registering
some pre-defined devices. I could not find any driver scanning for
amba devices and registering them. Are we going to be the first driver
registering devices dynamically or do I get this totally wrong

2) amba_id contains only some interesting "id". How can we relate this
with our core id/rev/manuf/class?

3) There is no code for managing AMBA cores (enable, checking status,
disabling, resetting)...

That way I see really low (or not at all) relation between out
(not)Broadcom bus and present AMBA bus.

-- 
Rafał
