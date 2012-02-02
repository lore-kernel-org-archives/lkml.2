Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662Ab2BBLGe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 06:06:34 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51732 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755346Ab2BBLGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 06:06:33 -0500
Message-ID: <4F2A6DF1.8040505@mvista.com>
Date: Thu, 02 Feb 2012 15:05:21 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: "Gupta, Ajay Kumar" <ajay.gupta@ti.com>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Pasupathy, Visuvanadan" <vichu@ti.com>,
        "Balbi, Felipe" <balbi@ti.com>
Subject: Re: RFC: usb: musb: Changes proposed for adding CPPI4.1 DMA
References: <47CEF8C4B26E8C44B22B028A650E0EA9317C5B92@DBDE01.ent.ti.com> <4F22CC37.8010307@mvista.com> <47CEF8C4B26E8C44B22B028A650E0EA9317D2B9D@DBDE01.ent.ti.com> <4F27D011.8060203@mvista.com> <47CEF8C4B26E8C44B22B028A650E0EA9317D9346@DBDE01.ent.ti.com>
In-Reply-To: <47CEF8C4B26E8C44B22B028A650E0EA9317D9346@DBDE01.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 02-02-2012 8:57, Gupta, Ajay Kumar wrote:

>>>>> As a next step to dma-engine based cppi4.1 driver implementation
>>>>> this RFC has the overview of changes in the musb driver.
>>>>> RFC on CPPI slave driver changes will follow next.

>>>>> Overview of changes in the musb driver
>>>>> ======================================

>>>>> 1)Add a dma-engine.c file in the drivers/usb/musb folder
>>>>> 2)This file will host the current musb dma APIs and translates them to
>>>>>      dmaengine APIs.
>>>>> 3)This will help to keep the changes in drivers/usb/musb/musb* files
>>>>>      minimal and also to retain compatibility other DMA (Mentor etc.)
>>>>>      drivers which are yet to be moved to drivers/dma
>>>>> 4)drivers/usb/musb/dma-engine.c, will wrap the dmaengine APIs to
>>>>>      make existing musb APIs compatible.
>>>>> 5)drivers/usb/musb/dma-engine.c file will implement the filter
>>>>>      functions and also implement .dma_controller_create (allocates
>>>>>      &    provides "dma_controller" object) and .dma_controller_delete
>>>>> 6)CPPI4.1 DMA specific queue and buffer management will be internal
>>>>>      to slave CPPI DMA driver implementation.

>>>>       You mean drivers/dma/ driver?

>>> yes.

>>>> I think you are forgotting that CPPI 4.1 MUSB
>>>> has some registers controlling DMA/interrupts beside those of CPPI 4.1
>>>> controller and MUSB core itself. How do they fit in your scheme?

>>> We have been discussing on how to handle these in slave driver and

>>      These certainly cannot be handled in the slave driver because the
>> registers are different for every controller implementation and, the
>> main thing, they don't belong to CPPI 4.1 as such.

> Felipe suggested to use device tree for differences in register maps
> among different platforms.

    I don't see how the device tree would magically help here.

> I do see issues in reading wrapper interrupt status register and then
> calling musb_interrupt() [defined inside musb_core.c] from slave driver.

>>> would post our proposal in RFC for slave driver design. Do you have
>>> any proposal?

>>      I think this will need hooks from dma-engine.c to the glue layers. I
>> was going to implement such in my version of MUSB CPPI 4.1 driver (in order
>> to also support AM35x) but lacked time.

> That would mean a change in current drivers/dma API.

    No, it doesn't. I'm proposing hooks from dma-engine.c which is situated in 
drivers/usb/musb/ if I got you right. It just means that the calls to 
dma-engine.c as MUSB DMA driver won't map to the calls to the DMA slave driver 
as directly as you've presented before.

> Ajay

>>> Regards,
>>> Ajay

WBR, Sergei
