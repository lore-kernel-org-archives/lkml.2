Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968Ab1JTOnr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 10:43:47 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:36156 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755886Ab1JTOnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 10:43:45 -0400
Message-ID: <4EA03399.6080309@ti.com>
Date: Thu, 20 Oct 2011 16:43:37 +0200
From: "Cousson, Benoit" <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Paul Walmsley <paul@pwsan.com>
CC: "Kristo, Tero" <t-kristo@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv9 03/18] TEMP: OMAP3xxx: hwmod data: add PRM hwmod
References: <1316781986-30642-1-git-send-email-t-kristo@ti.com> <1316781986-30642-4-git-send-email-t-kristo@ti.com> <alpine.DEB.2.00.1110101320180.5205@utopia.booyaka.com> <4E934D79.4080000@ti.com> <alpine.DEB.2.00.1110101416530.5205@utopia.booyaka.com> <4E936F0E.9050203@ti.com> <alpine.DEB.2.00.1110101725140.5205@utopia.booyaka.com> <4E954CDA.10107@ti.com> <alpine.DEB.2.00.1110131033410.24155@utopia.booyaka.com>
In-Reply-To: <alpine.DEB.2.00.1110131033410.24155@utopia.booyaka.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Sorry, I kind of forgot to answer that email.

On 10/13/2011 6:38 PM, Paul Walmsley wrote:
> On Wed, 12 Oct 2011, Cousson, Benoit wrote:
>
>> On 10/11/2011 1:26 AM, Paul Walmsley wrote:
>>> On Tue, 11 Oct 2011, Cousson, Benoit wrote:
>>>
>>>> In fact the device name does not have to match the hwmod name. So we
>>>> can just create an "omap2_prm" omap_device for OMAP2, "omap3_prm"
>>>> omap_device for OMAP3... That will allow the relevant PRM driver to
>>>> be bound to the proper device.
>>>
>>> Incidentally, given that we would be using the hwmod name and the version
>>> number to determine the appropriate omap_device name, what IP version
>>> numbers should we assign to these PRM IP blocks for different SoCs?
>>
>> It can just be 1, 2 and 3... The idea is just to differentiate the IP for each
>> OMAP.
>
> So those are basically arbitrary?  Something is not clear here.

Yeah, for me too, I think I did not get your concern...

> In the current hwmod design, IP blocks with different interfaces were
> intended to be uniquely identified by the hwmod name alone.  That is why
> omap_hwmod_lookup() only takes a 'name' parameter.
>
> If I understand what you want to do, you wish to change this to uniquely
> identify them by a (name, interface version number) tuple.

No, not for the same OMAP. The version is different for different OMAP 
version. So far the only IP with 2 different hwmod name for the same 
functionality is the timer. We have timer and timer_1ms, and that's for 
that kind of IP that we introduced the class to still be able to 
identify the functionality for the driver.

> I don't have a problem with this in theory, but it implies some changes to
> the existing model.  Specifically:
>
> - we'll need to add an interface version number to the struct omap_hwmod
>
> - we'll need to modify omap_hwmod_lookup() to take an interface version
> number
>
> - the "ti,hwmod" DT binding that you proposed earlier will need to include
> an interface version number

I still do not understand why we need that for the PRM.
AFAIK, we do have only one version of the PRM at the time. It is not 
similar to the timer case.

I'm still a little bit confused by your usecase.

You have only one PRM instance per OMAP. So you just have to do 
omap_hwmod_lookup("prm") to retrieve the relevant hwmod for the SoC.

If you need to build a different device per SoC to allow different 
driver to be bound to it, you can just append the version number to the 
hwmod name to build the device name.

Am I still missing something?

Regards,
Benoit

