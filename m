Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759015Ab0HERnw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 13:43:52 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:54994 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756150Ab0HERnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 13:43:49 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6065"; a="49881223"
Message-ID: <4C5AF854.4020502@codeaurora.org>
Date: Thu, 05 Aug 2010 10:43:48 -0700
From: Patrick Pannuto <ppannuto@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12pre) Gecko/20100715 Shredder/3.0.7pre
MIME-Version: 1.0
To: Magnus Damm <magnus.damm@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "damm@opensource.se" <damm@opensource.se>,
        "lethal@linux-sh.org" <lethal@linux-sh.org>,
        "rjw@sisk.pl" <rjw@sisk.pl>,
        "eric.y.miao@gmail.com" <eric.y.miao@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, alan@lxorguk.ukuu.org.uk,
        zt.tmzt@gmail.com
Subject: Re: [PATCH] platform: Facilitate the creation of pseduo-platform
 	busses
References: <4C59E654.1090403@codeaurora.org> <AANLkTimkMy6_201XNGb41e7LivkvVHMkFZWVoA-7UmBo@mail.gmail.com>
In-Reply-To: <AANLkTimkMy6_201XNGb41e7LivkvVHMkFZWVoA-7UmBo@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2010 07:32 PM, Magnus Damm wrote:
> On Thu, Aug 5, 2010 at 7:14 AM, Patrick Pannuto <ppannuto@codeaurora.org> wrote:
>> Inspiration for this comes from:
>> http://www.mail-archive.com/linux-omap@vger.kernel.org/msg31161.html
>>
>> RFC: http://lkml.org/lkml/2010/8/3/496
>> Patch is unchanged from the RFC. Reviews seemed generally positive
>> and it seemed this was desired functionality.
> 
> Thanks for your patch, it's really nice to see work done in this area!
> I'd like to see something like this merged in the not so distant
> future. At this point I'm not so concerned about the details, so I'll
> restrict myself to this:
> 
>> /drivers/my_driver.c
>>        static struct platform_driver my_driver = {
>>                .driver = {
>>                        .name   = "my-driver",
>>                        .owner  = THIS_MODULE,
>>                        .bus    = &my_bus_type,
>>                },
>>        };
> 
> I would really prefer not to have the bus type in the here. I
> understand it's needed at this point, but I wonder if it's possible to
> adjust the device<->driver matching for platform devices to allow any
> type of pseudo-platform bus_type.
> 
> The reason why I'd like to avoid having the bus type in the driver is
> that I'd like to reuse the platform driver across multiple
> architectures and buses. For instance, on the SH architecture and

So would I :). That's where this was all heading eventually, I was just
originally doing it in two passes. I have some ideas for how to do this
and will try to send out a patchset either today or tomorrow.

> SH-Mobile ARM we have SoCs with SCIF hardware blocks driven by the
> sh-sci.c serial driver. The sh-sci.c platform driver supports a wide
> range of different SCI(F)(A)(B) hardware blocks, and on any given SoC
> there is a mix of SCIF blocks spread out on different buses.
> 
> At this point our SH platform drivers are unaware where their driver
> instanced are located on the SoC. The I/O address and IRQs are
> assigned via struct resource and clocks are managed through clkdev. I
> believe that adding the bus type in the driver will violate this
> abstraction and make it more difficult to just instantiate a driver
> somewhere on the SoC.
> 
>> /somewhere/my_device.c
>>        static struct platform_device my_device = {
>>                .name           = "my-device",
>>                .id             = -1,
>>                .dev.bus        = &my_bus_type,
>>                .dev.parent     = &sub_bus_1.dev,
>>        };
> 
> This I don't mind at all. Actually, this is the place where the
> topology should be defined IMO.
> 

Agreed.

> Cheers,
> 
> / magnus


-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum
