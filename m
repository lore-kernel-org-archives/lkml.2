Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330Ab0LBFRC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 00:17:02 -0500
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:56239 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751680Ab0LBFRA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 00:17:00 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTik1o4Ka_UnwWvmjVhQGrPwrOpPGG4mmu4zSiH+U@mail.gmail.com>
References: <1291147139-23472-1-git-send-email-davidsin@ti.com>
 <1291147139-23472-2-git-send-email-davidsin@ti.com> <AANLkTi=q1HzYBpMH_pP+S5BtBQpHs62+zNfd_MtWHFuu@mail.gmail.com>
 <AANLkTi=YUYuxQE8pDZrN5-PJq1Q3jw7cP2yZKCXNAvPP@mail.gmail.com> <AANLkTik1o4Ka_UnwWvmjVhQGrPwrOpPGG4mmu4zSiH+U@mail.gmail.com>
From: "Varadarajan, Charulatha" <charu@ti.com>
Date: Thu, 2 Dec 2010 10:46:20 +0530
Message-ID: <AANLkTikEY+0gGB9dbVFZvhwWbd5jGEGo7oDNs_y5xL=s@mail.gmail.com>
Subject: Re: [RFC v2 1/8] TILER-DMM: DMM-PAT driver for TI TILER
To: "Kanigeri, Hari" <h-kanigeri2@ti.com>
Cc: David Sin <davidsin@ti.com>, Greg KH <greg@kroah.com>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Lajos Molnar <molnar@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 2, 2010 at 07:57, Kanigeri, Hari <h-kanigeri2@ti.com> wrote:
> On Wed, Dec 1, 2010 at 8:10 PM, Kanigeri, Hari <h-kanigeri2@ti.com> wrote:
>> On Wed, Dec 1, 2010 at 12:04 AM, Varadarajan, Charulatha <charu@ti.com> wrote:
>>> David,
>>
>>>
>>>> +               if (!oh)
>>>> +                       goto error;
>>>> +
>>>> +               data->base = oh->_mpu_rt_va;
>>>
>>> not required. Make use of platform_get APIs in probe to extract the
>>> base, dma and irq info using pdev.
>>
>> Not sure about using platform_get APIs. I think one has to use
>> omap_hwmod_get_mpu_rt_va to get the address, which internally returns
>> oh-<_mpu_rt_va.
> small correction... omap_device_get_rt_va and not omap_hwmod_get_mpu_rt_va.

To get the base address & irq, you need not have to use
omap_device_get_rt_va and pass it as
pdata and then use it during probe. Instead in probe, you may do
something like the following:

static int __devinit  dev_probe (*pdev) {
   struct resource *res;
   void __iomem *base;
   u16 irq;
   ....
   ....
   res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
   if (unlikely(!res)) {
              ....
              return -ENODEV;
   }

   base = ioremap(res->start, resource_size(res));
   if (base) {
               ....
               return -ENOMEM;
   }

   res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
   if (unlikely(!res)) {
               ....
               return -ENODEV;
   }
   irq = res->start;
   ....
   ....
}

-V Charulatha
