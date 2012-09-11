Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488Ab2IKIwI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 04:52:08 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:54589 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753932Ab2IKIwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 04:52:03 -0400
MIME-Version: 1.0
In-Reply-To: <20120910164323.GK7464@arwen.pp.htv.fi>
References: <1346943331-18120-1-git-send-email-kishon@ti.com>
	<1346943331-18120-2-git-send-email-kishon@ti.com>
	<5048C2A2.2020104@ti.com>
	<20120906171301.GC17754@arwen.pp.htv.fi>
	<20120906171803.GA30717@arwen.pp.htv.fi>
	<20120906195607.GB1303@atomide.com>
	<20120910155855.GE7464@arwen.pp.htv.fi>
	<504E127F.6020406@ti.com>
	<20120910164323.GK7464@arwen.pp.htv.fi>
Date: Tue, 11 Sep 2012 14:22:01 +0530
Message-ID: <CAAe_U6KgX7TcT9FSsJRHP62mMJ0hcg2cYJ8bX15wdpjCNzLukQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] arm: omap: hwmod: add a new addr space in otg for
 writing to control module
From: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
To: balbi@ti.com
Cc: Benoit Cousson <b-cousson@ti.com>, Tony Lindgren <tony@atomide.com>,
        Vaibhav Hiremath <hvaibhav@ti.com>, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, rob@landley.net, linux@arm.linux.org.uk,
        gregkh@linuxfoundation.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, Paul Walmsley <paul@pwsan.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Sep 10, 2012 at 10:13 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Mon, Sep 10, 2012 at 06:17:03PM +0200, Benoit Cousson wrote:
>> >>>>> On 9/6/2012 8:25 PM, Kishon Vijay Abraham I wrote:
>> >>>>>> The mailbox register for usb otg in omap is present in control module.
>> >>>>>> On detection of any events VBUS or ID, this register should be written
>> >>>>>> to send the notification to musb core.
>> >>>>>>
>> >>>>>> Till we have a separate control module driver to write to control module,
>> >>>>>> omap2430 will handle the register writes to control module by itself. So
>> >>>>>> a new address space to represent this control module register is added
>> >>>>>> to usb_otg_hs.
>> >>>>>>
>> >>>>>> Cc: Benoit Cousson <b-cousson@ti.com>
>> >>>>>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>> >>>>>> ---
>> >>>>>>  arch/arm/mach-omap2/omap_hwmod_44xx_data.c |    5 +++++
>> >>>>>>  1 file changed, 5 insertions(+)
>> >>>>>>
>> >>>>>> diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
>> >>>>>> index 242aee4..02341bc 100644
>> >>>>>> --- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
>> >>>>>> +++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
>> >>>>>> @@ -5890,6 +5890,11 @@ static struct omap_hwmod_addr_space omap44xx_usb_otg_hs_addrs[] = {
>> >>>>>>                .pa_end         = 0x4a0ab003,
>> >>>>>>                .flags          = ADDR_TYPE_RT
>> >>>>>>        },
>> >>>>>> +      {
>> >>>>>> +              .pa_start       = 0x4a00233c,
>> >>>>>> +              .pa_end         = 0x4a00233f,
>> >>>>>> +              .flags          = ADDR_TYPE_RT
>> >>>>>> +      },
>> >>>>>
>> >>>>> I do not have any objection/comment here, but I believe this is control
>> >>>>> module address space required for USB module, right?
>> >>>>> I am not sure this is right way of accessing control module space.
>> >>>>> Actually Control Module Access required for drivers is one of the
>> >>>>> blocking issue we have currently.
>> >>>>>
>> >>>>> Also there was some effort put up by 'Konstantine' to convert Control
>> >>>>> module to MFD driver, I haven't seen any further update on it. But it
>> >>>>> would be good to check with him.
>> >>>>
>> >>>> this was an agreement with Benoit since we already lost a couple merge
>> >>>> windows for this patchset. We agreed to wait until -rc4 for SCM driver
>> >>>> and if it wasn't ready, we'd go ahead with this and SCM author would fix
>> >>>> it up on a patch converting users to new SCM driver.
>> >>>
>> >>> Tony, can I get your Acked-by to this patch so I can take it together
>> >>> with the rest of the series ? Thanks
>> >>>
>> >>> ps: I'll apply this to my 'musb' branch which is immutable, so it's safe
>> >>> to merge it into your tree once I apply.
>> >>
>> >> It would be best if this got acked by Benoit and Paul as they may
>> >> have some other patches queued up. I'll ack if they ack ;)
>> >
>> > Benoit, care to ack this patch ???
>>
>> Gosh, that's hard to ack something like that :-)
>
> btw, that's not different than what's already in tree, the only
> difference is that now hwmod knows about it...
>
>> But considering that the control module driver is not there yet, I have
>> no choice but accepting that one if we want to have the functionality
>> we've been waiting for years.
>>
>> Could you just update the patch with a big disclaimer on top of the
>> address range to explain that this should not belong here and will be
>> removed ASAP, when the proper driver will be done.
>
> sure, that's doable... Kishon, can you do this ASAP ? I want to send my
> pull requests tomorrow at the latest.

Sure. Will send now.

Thanks
Kishon
