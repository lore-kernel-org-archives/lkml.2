Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736Ab0IBMgn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 08:36:43 -0400
Received: from outbound.icp-qv1-irony-out4.iinet.net.au ([203.59.1.104]:22433
	"EHLO outbound.icp-qv1-irony-out4.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752157Ab0IBMgm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 08:36:42 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApEBAEo3f0zL2THn/2dsb2JhbAAH3mqFOwSNJw
X-IronPort-AV: E=Sophos;i="4.56,307,1280678400"; 
   d="scan'208";a="590822565"
Subject: Re: [UIO]  SMX UIO interface
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Ben Nizette <bn@niasdigital.com>
In-Reply-To: <4C7F78CA.3020506@steinhoff.de>
Date: Thu, 2 Sep 2010 21:45:37 +1000
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <59079FAE-8CF7-4E2F-B5C6-77B6A6D2B8F8@niasdigital.com>
References: <4C7DFF2C.8070709@steinhoff.de> <ABD0E28F-0839-4C6F-A0BD-999A28A6803A@niasdigital.com> <4C7F78CA.3020506@steinhoff.de>
To: Armin Steinhoff <armin@steinhoff.de>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 02/09/2010, at 8:13 PM, Armin Steinhoff wrote:

> Ben Nizette wrote:
>> On 01/09/2010, at 5:22 PM, Armin Steinhoff wrote:
>> 
>>> Hi Ben,
>>> 
>>> I have a question about the SMX UIO Interface.
>>> 
>>> In the SMX module you are reading the data of the platform resourses:
>>> 
>>>    regs = platform_get_resource(dev, IORESOURCE_MEM, 0);
>>>    if (!regs) {
>>>        dev_err(&dev->dev, "No memory resource specified\n");
>>>        goto out_free;
>>>    }
>>> 
>>> But who sets these data initially ?
>> Who ever sets up the platform device that will bind to this driver, usually the board code (eg on avr32 arch/avr32/boards/*/setup.c, ARM is somewhere under arch/arm/mach-*/ I think).
>> 
>> The board code would create an array of struct resource with the appropriate memory regions and an IRQ entry, create a struct platform_device with the right content to bind to that driver, set the platform_device .resource field to the previously created array then call platform_device_register() to kick things off.
>> 
> 
>  That means there is additionally an individual driver of the board and the UIO interface is just for open up the hardware interfaces ?

Um, sort of, I guess.. :-)

The board code isn't a driver, it's just code that gets run at startup whose job is to register all the devices on the board.  If your board only contains probe-able busses then you might not need any board code at all but if you've got busses which can't be automatically discovered then something else needs to tell the kernel what devices are where.

Maybe a good place to start would be to read up a bit more on the Linux device model and look through some example board code, you'll probably learn more than me just answering small bits like this :-)

	--Ben.

> 
>  Thanks
> 
> --Armin
> 
> 
>> 	--Ben.
>> 
>>> Cheers
>>> 
>>> --Armin
>>> 
>> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

