Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550Ab2JLJZd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 05:25:33 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43665 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438Ab2JLJZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 05:25:32 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpon4FZdPXFOXvVqExY=xrwozELYvNbE3_zHoRw2O0nszhw@mail.gmail.com>
References: <142ef9170a2c69657d8a05ac127a9970d7b04965.1350020375.git.viresh.kumar@linaro.org>
	<91e41b4cc972d298f714cbd6f400569a9710304c.1350020375.git.viresh.kumar@linaro.org>
	<1350030203.10584.139.camel@smile>
	<CAKohpon4FZdPXFOXvVqExY=xrwozELYvNbE3_zHoRw2O0nszhw@mail.gmail.com>
Date: Fri, 12 Oct 2012 12:25:30 +0300
Message-ID: <CAHp75Ve9uETO0Wx=bNbPxjOxO_MoE_bkFCHtwBZAA6+7m8fdMw@mail.gmail.com>
Subject: Re: [PATCH 2/3] dmaengine: dw_dmac: Enhance device tree support
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, vinod.koul@intel.com,
        linux-kernel@vger.kernel.org, spear-devel@list.st.com,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2012 at 11:34 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 12 October 2012 13:53, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
>> On Fri, 2012-10-12 at 11:14 +0530, Viresh Kumar wrote:

>>> diff --git a/Documentation/devicetree/bindings/dma/snps-dma.txt b/Documentation/devicetree/bindings/dma/snps-dma.txt
>>> @@ -14,4 +34,28 @@ Example:
>>>               reg = <0xfc000000 0x1000>;
>>>               interrupt-parent = <&vic1>;
>>>               interrupts = <12>;
>>> +
>>> +             nr_channels = <8>;
>>> +             chan_allocation_order = <1>;
>>> +             chan_priority = <1>;
>>> +             block_size = <0xfff>;
>>> +             nr_masters = <2>;
>>> +             data_width = <3 3 0 0>;
>>> +
>>> +             slave_info {
>>> +                     uart0-tx {
>>> +                             bus_id = "uart0-tx";
>>> +                             cfg_hi = <0x4000>;      /* 0x8 << 11 */
>>> +                             cfg_lo = <0>;
>>> +                             src_master = <0>;
>>> +                             dst_master = <1>;
>>> +                     };
>>> +                     spi0-tx {
>>> +                             bus_id = "spi0-tx";
>>> +                             cfg_hi = <0x2000>;      /* 0x4 << 11 */
>>> +                             cfg_lo = <0>;
>>> +                             src_master = <0>;
>>> +                             dst_master = <0>;
>>> +                     };
>>> +             };
>> Why do you locate slave information under DMA controller node? From my
>> point of view the slave info belongs to corresponding device. For
>> example, above sections belong to UART0 and SPI0.
>
> Consider one spi driver is used on 5 different platforms with
> different DMA controllers.
> So, 5 DMA drivers and so 5 DMA platform_data. Wherever we add this node, this
> data can't be processed by spi-driver, as we can't add DT processing routines
> for all DMA drivers in spi.
>
> The best place to process DT nodes is DW_DMAC driver, because it is
> dw_dmac's data.
> That's why i added them under DMA.
Fair enough.

>>> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c

>>> +static struct dw_dma_platform_data *
>>> +__devinit dw_dma_parse_dt(struct platform_device *pdev)
>>> +{
>
>>> +     for_each_child_of_node(sn, cn)
>>> +             count++;
>> Is there any other way to get amount of children?
>
> I tried my best to find one, referred to lots of drivers. And found
> this way in most of the places. ex: drivers/pinctrl/***
I understand your way of allocating memory, but what about using
linked list instead of array?

And one more thing. May be we could introduce backlink to the platform
data in the dw_dma structure instead of copying certain parameters?

-- 
With Best Regards,
Andy Shevchenko
