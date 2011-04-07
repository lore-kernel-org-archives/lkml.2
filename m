Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932Ab1DGMCr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 08:02:47 -0400
Received: from smtp.nokia.com ([147.243.128.26]:45473 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755832Ab1DGMCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 08:02:46 -0400
Date: Thu, 7 Apr 2011 14:59:48 +0300 (EEST)
From: Ilkka Koskinen <ikoskine@nokia.com>
X-X-Sender: ikoskine@tumpelo.nmp.nokia.com
To: ext Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
cc: Ilkka Koskinen <ilkka.koskinen@nokia.com>, eric.piel@tremplin-utc.net,
        mjg@redhat.com, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, samu.p.onkalo@nokia.com
Subject: Re: [RFC PATCHv2 4/5] hwmon: lis3: Remove the referencies to the
 global variable in core driver
In-Reply-To: <20110405155007.GB2454@nautilus.holoscopio.com>
Message-ID: <alpine.DEB.2.00.1104071448290.9511@tumpelo.nmp.nokia.com>
References: <1302014714-7334-1-git-send-email-ilkka.koskinen@nokia.com> <1302014714-7334-5-git-send-email-ilkka.koskinen@nokia.com> <20110405155007.GB2454@nautilus.holoscopio.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Thanks for the comments!

On Tue, 5 Apr 2011, ext Thadeu Lima de Souza Cascardo wrote:
> On Tue, Apr 05, 2011 at 05:45:13PM +0300, Ilkka Koskinen wrote:
>> Signed-off-by: Ilkka Koskinen <ilkka.koskinen@nokia.com>
>> ---
>>  drivers/misc/lis3lv02d/lis3lv02d.c |  237 ++++++++++++++++++++----------------
>>  drivers/misc/lis3lv02d/lis3lv02d.h |    3 +
>>  2 files changed, 135 insertions(+), 105 deletions(-)

>> @@ -980,14 +1003,18 @@ int lis3lv02d_init_device(struct lis3lv02d *lis3)
>>  				thread_fn,
>>  				IRQF_TRIGGER_RISING | IRQF_ONESHOT |
>>  				irq_flags,
>> -				DRIVER_NAME, &lis3_dev);
>> +				DRIVER_NAME, lis3);
>>
>>  	if (err < 0) {
>>  		pr_err("Cannot get IRQ\n");
>>  		goto out;
>>  	}
>>
>> -	if (misc_register(&lis3lv02d_misc_device))
>> +	lis3->miscdev.minor	= MISC_DYNAMIC_MINOR;
>> +	lis3->miscdev.name	= "freefall";
>> +	lis3->miscdev.fops	= &lis3lv02d_misc_fops;
>> +
>> +	if (misc_register(&lis3->miscdev))
>>  		pr_err("misc_register failed\n");
>
> You should not use miscdevice in case there will be multiple devices.
> First, it will fail. There cannot be more than one device with the same
> name. Second, current dynamic minor devices is restricted to 64 devices.
> Since this is reserved to one-shot devices, freefall was OK as a misc
> device until you fixed it to allow multiple freefall devices.  :-)

Ah, true :)

> So, I'd recommend switching to a new device class, and have freefall0,
> freefall1, etc.

I wonder if introducing a new class makes sense. I mean, I can figure out 
use cases for several accelerometers but for several free fall sensors? :/

Would it be better to add a mechanism to tell to the core module if the 
particular device is used for free fall detection or not?

Cheers, Ilkka

> Anyway, good job on this.
>
> Regards,
> Cascardo.

