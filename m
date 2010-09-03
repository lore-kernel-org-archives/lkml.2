Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124Ab0ICIf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 04:35:29 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:50681 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756055Ab0ICIfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 04:35:24 -0400
Message-ID: <4C80B378.5060509@steinhoff.de>
Date: Fri, 03 Sep 2010 10:36:08 +0200
From: Armin Steinhoff <armin@steinhoff.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2 ThunderBrowse/3.3.2
MIME-Version: 1.0
To: Ben Nizette <bn@niasdigital.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [UIO]  SMX UIO interface
References: <4C7DFF2C.8070709@steinhoff.de> <ABD0E28F-0839-4C6F-A0BD-999A28A6803A@niasdigital.com> <4C7F78CA.3020506@steinhoff.de> <59079FAE-8CF7-4E2F-B5C6-77B6A6D2B8F8@niasdigital.com>
In-Reply-To: <59079FAE-8CF7-4E2F-B5C6-77B6A6D2B8F8@niasdigital.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:2SYFOGfyPs8cTYL4tW78DpuNgoEVA6vFlW9Md/eo0z7
 +dzUO+QlDruHTnvzfHuxvtMRde1H2qF9Bg65dYbFsfgCfpT+Jj
 o8sowpJOmKRnElFEut8Gtud4XyVSM5DboahBmqEn/b/3xF9zJ2
 WvRjE5vYtWGDxKDsUmnX+d7CJHBz+tgV+LaovDF3YOindPhMn1
 Z9HVtRFDi3/jATwCG4ROQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Ben Nizette wrote:
> On 02/09/2010, at 8:13 PM, Armin Steinhoff wrote:
>
>> Ben Nizette wrote:
>>> On 01/09/2010, at 5:22 PM, Armin Steinhoff wrote:
>>>
>>>> Hi Ben,
>>>>
>>>> I have a question about the SMX UIO Interface.
>>>>
>>>> In the SMX module you are reading the data of the platform resourses:
>>>>
>>>>     regs = platform_get_resource(dev, IORESOURCE_MEM, 0);
>>>>     if (!regs) {
>>>>         dev_err(&dev->dev, "No memory resource specified\n");
>>>>         goto out_free;
>>>>     }
>>>>
>>>> But who sets these data initially ?
>>> Who ever sets up the platform device that will bind to this driver, usually the board code (eg on avr32 arch/avr32/boards/*/setup.c, ARM is somewhere under arch/arm/mach-*/ I think).
>>>
>>> The board code would create an array of struct resource with the appropriate memory regions and an IRQ entry, create a struct platform_device with the right content to bind to that driver, set the platform_device .resource field to the previously created array then call platform_device_register() to kick things off.
>>>
>>   That means there is additionally an individual driver of the board and the UIO interface is just for open up the hardware interfaces ?
> Um, sort of, I guess.. :-)
>
> The board code isn't a driver, it's just code that gets run at startup whose job is to register all the devices on the board.  If your board only contains probe-able busses then you might not need any board code at all but if you've got busses which can't be automatically discovered then something else needs to tell the kernel what devices are where.
>
> Maybe a good place to start would be to read up a bit more on the Linux device model and look through some example board code, you'll probably learn more than me just answering small bits like this :-)

   Yes, you are right.  I'm currently learning a lot about the Linux 
driver model ... it's a real jungle :)

    Thanks for your small bits and bytes

--Armin




> 	--Ben.
>
>>   Thanks
>>
>> --Armin
>>
>>
>>> 	--Ben.
>>>
>>>> Cheers
>>>>
>>>> --Armin
>>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>

