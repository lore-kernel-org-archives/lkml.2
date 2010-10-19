Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215Ab0JSQMe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 12:12:34 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:54876 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754720Ab0JSQM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 12:12:29 -0400
Message-ID: <4CBDC361.70507@ti.com>
Date: Tue, 19 Oct 2010 21:42:17 +0530
From: Anand Gadiyar <gadiyar@ti.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Felipe Contreras <felipe.contreras@gmail.com>, linux-usb@vger.kernel.org,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>, Felipe Balbi <balbi@ti.com>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH v2 3/3] drivers: cleanup Kconfig stuff
References: <1287482608-11320-1-git-send-email-felipe.contreras@gmail.com> <1287482608-11320-4-git-send-email-felipe.contreras@gmail.com> <20101019155219.GI4589@kroah.com>
In-Reply-To: <20101019155219.GI4589@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2010 9:22 PM, Greg KH wrote:
> On Tue, Oct 19, 2010 at 01:03:28PM +0300, Felipe Contreras wrote:
>> Add missing dependencies, and remove redundant ones, and select sensible
>> defaults.
>>
>> Signed-off-by: Felipe Contreras<felipe.contreras@gmail.com>
>> ---
>>   drivers/mfd/Kconfig        |    3 ++-
>>   drivers/regulator/Kconfig  |    1 +
>>   drivers/usb/gadget/Kconfig |    3 +--
>>   drivers/usb/musb/Kconfig   |    6 ++----
>>   drivers/usb/otg/Kconfig    |    2 ++
>>   5 files changed, 8 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
>> index db51ea1..0bbaf01 100644
>> --- a/drivers/mfd/Kconfig
>> +++ b/drivers/mfd/Kconfig
>> @@ -156,6 +156,7 @@ config MENELAUS
>>   config TWL4030_CORE
>>   	bool "Texas Instruments TWL4030/TWL5030/TWL6030/TPS659x0 Support"
>>   	depends on I2C=y&&  GENERIC_HARDIRQS
>> +	default y if ARCH_OMAP3 || ARCH_OMAP4
>
> Sorry, but unless the driver is somehow required to keep the board from
> going up in a puff of smoke, a default should NEVER be y.
>
> Because of that, I can't take this patch.
>

This is the driver for the Power-management IC on the board. Without 
this IC being correctly configured, I'm guessing a lot of things will 
fail. Not so sure if anything will go up in smoke (sounds unlikely), or 
if the kernel will fail to boot - I'll check quickly - but for this one 
specific instance, I think it's reasonable to accept a default y.

Kevin/Tony can probably confirm.

Greg,

For other instances of unnecessary "default y", do you think they should 
be removed?

- Anand


