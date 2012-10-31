Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760616Ab2JaTz1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 15:55:27 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56376 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760393Ab2JaTz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 15:55:26 -0400
Message-ID: <50918223.6080003@ti.com>
Date: Wed, 31 Oct 2012 20:55:15 +0100
From: Benoit Cousson <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Pantelis Antoniou <panto@antoniou-consulting.com>
CC: Tony Lindgren <tony@atomide.com>, <linux-kernel@vger.kernel.org>,
        Koen Kooi <koen@dominion.thruhere.net>, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, <linux-omap@vger.kernel.org>,
        Kevin Hilman <khilman@ti.com>, Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCH 0/3] capebus moving omap_devices to mach-omap2
References: <1351783082-11411-1-git-send-email-panto@antoniou-consulting.com> <20121031175219.GH12739@atomide.com> <C9715CB7-D3E2-4CA7-8A93-2B10E8B70640@antoniou-consulting.com> <20121031180935.GL12739@atomide.com>
In-Reply-To: <20121031180935.GL12739@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Panto,

On 10/31/2012 07:09 PM, Tony Lindgren wrote:
> * Pantelis Antoniou <panto@antoniou-consulting.com> [121031 11:05]:
>> Hi Tony,
>>
>> On Oct 31, 2012, at 7:52 PM, Tony Lindgren wrote:
>>
>>> * Pantelis Antoniou <panto@antoniou-consulting.com> [121031 10:26]:
>>>> It is painless to move the adapter DT devices to arch/arm/mach-omap2
>>>>
>>>> However I got bit by the __init at omap_build_device family functions.
>>>> If you don't remove it, crashes every time you instantiate a device
>>>> at runtime, or you load the cape driver as a module.
>>>
>>> Hmm I think you misunderstood me. You only need to create the
>>> platform_device under arch/arm/mach-omap2. The device creation
>>> happens only at __init, so omap_build_device can stay as __init.
>>> The driver itself should be under drivers.
>>>
>>> But is this bus on non-device-tree omaps? If not, just make it
>>> device tree only.
>>>
>>
>> I'm afraid that's not the case. The whole notion of capebus is that
>> instantiation of the devices doesn't just happen early at the boot
>> sequence.
>>
>> It is perfectly valid for a cape to be instantiated via loading
>> a module, or by making an override by writing a sysfs file.
>>
>> When having the __init there, the function has been long removed
>> and you get a crash by calling into the weeds.
>>
>> So the sequence is:
>>
>> <early boot>       Register the adapter driver.
> 
> OK this is always there for the hardware, and done during
> the __init and this one should have an omap_device..
>  
>> <user>             insmod bone-geiger-cape
>> <cape-is-matched>  call omap_build_device
>>
>> Please look into the capebus patches for the details. 
> 
> ..but it seems that the devices connected to capebus should
> not have anything to do with omap_device and hwmod?


Yeah, I do agree. I'm confused as well. Only OMAP IPs under PRCM control
could have an hwmod and thus must be handled by an omap_device.

Any devices that is created later cannot be omap_device. The DT core
will create regular platform_device for them.

Since cape is an external board, it should have nothing to do with
omap_device.

Looking at your patch:
 da8xx-dt: Create da8xx DT adapter device

I understand why you do that, but in fact that patch does not make sense
to me :-(

Why do you have to create an omap_device from the driver probe?


Regards,
Benoit

