Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087Ab2IJQRd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 12:17:33 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:48989 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754372Ab2IJQRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 12:17:30 -0400
Message-ID: <504E127F.6020406@ti.com>
Date: Mon, 10 Sep 2012 18:17:03 +0200
From: Benoit Cousson <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: <balbi@ti.com>
CC: Tony Lindgren <tony@atomide.com>, Vaibhav Hiremath <hvaibhav@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <rob@landley.net>, <linux@arm.linux.org.uk>,
        <gregkh@linuxfoundation.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCH 1/3] arm: omap: hwmod: add a new addr space in otg for
 writing to control module
References: <1346943331-18120-1-git-send-email-kishon@ti.com> <1346943331-18120-2-git-send-email-kishon@ti.com> <5048C2A2.2020104@ti.com> <20120906171301.GC17754@arwen.pp.htv.fi> <20120906171803.GA30717@arwen.pp.htv.fi> <20120906195607.GB1303@atomide.com> <20120910155855.GE7464@arwen.pp.htv.fi>
In-Reply-To: <20120910155855.GE7464@arwen.pp.htv.fi>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On 09/10/2012 05:58 PM, Felipe Balbi wrote:
> Hi,
> 
> On Thu, Sep 06, 2012 at 12:56:07PM -0700, Tony Lindgren wrote:
>> * Felipe Balbi <balbi@ti.com> [120906 10:23]:
>>> Hi,
>>>
>>> On Thu, Sep 06, 2012 at 08:13:03PM +0300, Felipe Balbi wrote:
>>>> Hi,
>>>>
>>>> On Thu, Sep 06, 2012 at 09:04:58PM +0530, Vaibhav Hiremath wrote:
>>>>>
>>>>>
>>>>> On 9/6/2012 8:25 PM, Kishon Vijay Abraham I wrote:
>>>>>> The mailbox register for usb otg in omap is present in control module.
>>>>>> On detection of any events VBUS or ID, this register should be written
>>>>>> to send the notification to musb core.
>>>>>>
>>>>>> Till we have a separate control module driver to write to control module,
>>>>>> omap2430 will handle the register writes to control module by itself. So
>>>>>> a new address space to represent this control module register is added
>>>>>> to usb_otg_hs.
>>>>>>
>>>>>> Cc: Benoit Cousson <b-cousson@ti.com>
>>>>>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>>>>>> ---
>>>>>>  arch/arm/mach-omap2/omap_hwmod_44xx_data.c |    5 +++++
>>>>>>  1 file changed, 5 insertions(+)
>>>>>>
>>>>>> diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
>>>>>> index 242aee4..02341bc 100644
>>>>>> --- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
>>>>>> +++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
>>>>>> @@ -5890,6 +5890,11 @@ static struct omap_hwmod_addr_space omap44xx_usb_otg_hs_addrs[] = {
>>>>>>  		.pa_end		= 0x4a0ab003,
>>>>>>  		.flags		= ADDR_TYPE_RT
>>>>>>  	},
>>>>>> +	{
>>>>>> +		.pa_start	= 0x4a00233c,
>>>>>> +		.pa_end		= 0x4a00233f,
>>>>>> +		.flags		= ADDR_TYPE_RT
>>>>>> +	},
>>>>>
>>>>> I do not have any objection/comment here, but I believe this is control
>>>>> module address space required for USB module, right?
>>>>> I am not sure this is right way of accessing control module space.
>>>>> Actually Control Module Access required for drivers is one of the
>>>>> blocking issue we have currently.
>>>>>
>>>>> Also there was some effort put up by 'Konstantine' to convert Control
>>>>> module to MFD driver, I haven't seen any further update on it. But it
>>>>> would be good to check with him.
>>>>
>>>> this was an agreement with Benoit since we already lost a couple merge
>>>> windows for this patchset. We agreed to wait until -rc4 for SCM driver
>>>> and if it wasn't ready, we'd go ahead with this and SCM author would fix
>>>> it up on a patch converting users to new SCM driver.
>>>
>>> Tony, can I get your Acked-by to this patch so I can take it together
>>> with the rest of the series ? Thanks
>>>
>>> ps: I'll apply this to my 'musb' branch which is immutable, so it's safe
>>> to merge it into your tree once I apply.
>>
>> It would be best if this got acked by Benoit and Paul as they may
>> have some other patches queued up. I'll ack if they ack ;)
> 
> Benoit, care to ack this patch ???

Gosh, that's hard to ack something like that :-)

But considering that the control module driver is not there yet, I have
no choice but accepting that one if we want to have the functionality
we've been waiting for years.

Could you just update the patch with a big disclaimer on top of the
address range to explain that this should not belong here and will be
removed ASAP, when the proper driver will be done.

Then you sign the patch with your blood and that should be fine for me :-).

Thanks,
Benoit

