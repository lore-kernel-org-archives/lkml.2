Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913Ab2KMVZP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 16:25:15 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:39844 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850Ab2KMVZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 16:25:12 -0500
Message-ID: <50A2BAA2.6090009@ahsoftware.de>
Date: Tue, 13 Nov 2012 22:24:50 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Till Harbaum <till@harbaum.org>
Subject: Re: [PATCH 1/2] i2c: Add possibility for user-defined (i2c-)devices
 for bus-drivers.
References: <1352829968-4908-1-git-send-email-holler@ahsoftware.de> <20121113195533.6db71716@endymion.delvare> <50A2AC28.7050304@ahsoftware.de> <20121113220835.111a178a@endymion.delvare>
In-Reply-To: <20121113220835.111a178a@endymion.delvare>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 13.11.2012 22:08, schrieb Jean Delvare:


>>> No, no, no. We did that 10 years ago, killed all the code 3 years ago

Btw. I wonder where all you kernel devs have learned that "No, no, no". 
Do you all attend the same rhetoric courses at some conferences? ;)

>>> [1], let's not do the same mistake again, please. We have a sysfs
>>> interface for instantiating clients dynamically from user-space, it's
>>> way more powerful and flexible than your proposal. Just try plugging two
>>
>> So how do I define a device, e.g. an RTC which I want to have alive
>> before userland starts? Currently imho not possible.
>
> If your system relies on a an RTC clock chip hanging off an USB-to-I2C
> adapter, I'd say your design is very wrong to start with. I can only
> suppose (hope!) you are doing that during some development phase and
> the final hardware design is totally different.
 >
> If you need I2C devices to be instantiated early in the boot process,
> this would typically be done by platform code. This is going to be a
> little difficult with i2c-tiny-usb as it was definitely not meant to
> host system-critical chips. But you can probably get it to work if you
> try hard enough (in particular by allowing i2c-tiny-usb to claim
> specific i2c bus number(s).) If you want your development system to
> mimic the final hardware as closely as possible, this is the best
> approach anyway.

I never would develop some hardware meant for usage with Linux which 
doesn't have a RTC. But there are several such boards available. E.g. 
that currently so much hyped Rasberry PI. So there are certainly some 
people which have a usage for such a parameter (including me).

Maybe you could forward your suggestion to those hw-devs which are 
responsible for linux-hw without an RTC. I don't know such poeple. ;)

> It probes in the sense "check if a device is present", not in the sense
> "check if the device there is really what the user told me." So very
> easy to get wrong. Plus there is no universal probe method on I2C,
> i2c_new_probed_device() uses a default heuristic which may not only
> fail to detect a device's presence, but may even heavily confuse the
> device in question. Usage of i2c_new_probed_device() should be limited
> to very specific cases.

I know about that too. But I prefer such a probe instead of doing it 
without an probe. Just try what happens if you add e.g. an pcf8563 (or 
ds1307) which is not available. The driver doesn't care and you will 
find an /dev/rtcN afterwards in your system. So probing is imho better 
than not.

> I am not questioning the quality of your code, I did not even look at
> it. I'm questioning the pertinence of adding yet another way to
> instantiate i2c devices when we already have 4 which made everybody
> else happy for the past 3 years AFAIK.

As said, currently there is no way to do that whithout either patching 
the kernel or working in userspace. And a RTC is just an example for a 
device you really want before userspace starts (but imho a very good).

Regards,

Alexander
