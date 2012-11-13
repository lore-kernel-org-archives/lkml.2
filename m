Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab2KMXjJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 18:39:09 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:47191 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100Ab2KMXjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 18:39:08 -0500
Message-ID: <50A2DA0C.3090507@ahsoftware.de>
Date: Wed, 14 Nov 2012 00:38:52 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Till Harbaum <till@harbaum.org>
Subject: Re: [PATCH 1/2] i2c: Add possibility for user-defined (i2c-)devices
 for bus-drivers.
References: <1352829968-4908-1-git-send-email-holler@ahsoftware.de> <20121113195533.6db71716@endymion.delvare> <50A2AC28.7050304@ahsoftware.de> <20121113220835.111a178a@endymion.delvare> <50A2BAA2.6090009@ahsoftware.de> <20121113224246.768bf734@endymion.delvare>
In-Reply-To: <20121113224246.768bf734@endymion.delvare>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 13.11.2012 22:42, schrieb Jean Delvare:
> On Tue, 13 Nov 2012 22:24:50 +0100, Alexander Holler wrote:
>> Am 13.11.2012 22:08, schrieb Jean Delvare:
>>> It probes in the sense "check if a device is present", not in the sense
>>> "check if the device there is really what the user told me." So very
>>> easy to get wrong. Plus there is no universal probe method on I2C,
>>> i2c_new_probed_device() uses a default heuristic which may not only
>>> fail to detect a device's presence, but may even heavily confuse the
>>> device in question. Usage of i2c_new_probed_device() should be limited
>>> to very specific cases.
>>
>> I know about that too. But I prefer such a probe instead of doing it
>> without an probe. Just try what happens if you add e.g. an pcf8563 (or
>> ds1307) which is not available. The driver doesn't care and you will
>> find an /dev/rtcN afterwards in your system. So probing is imho better
>> than not.
>
> Question is, what will you do the day someone wants to instantiate a
> device for which the default probing mechanism doesn't work?

Do you solve all problems you and others might have in the future 
already now?

> Plus you don't address the main issues. Your syntax gives you no way to
> support two i2c-tiny-usb adapters with different chips at a specific
> address. The sysfs interface supports such a setup. Also instantiating

It isn't possible to do such, because the only ID available for 
i2c-busses is given them at runtime. So people have to live with that 
imho artificially problem, if they use my patch. I don't have any other 
solution until the numbering is predictable. But I assume you already 
know all that, otherwise you wouldn't have mentioned it.

> the wrong devices is worse than instating a device that doesn't exist
> at all. So the use of i2c_new_probed_device() here will randomly help
> in a limited number of cases and randomly be problematic in others.
> Hard to justify...

So would you be satisfied if I would make the syntax more complicated by 
adding something which would allow them to define if the devices gets 
probed? E.g. dev1@addr1,dev2@addr2.noprobe,... ?

> I am not familiar with RTC constraints. What is so important about it
> that it can't wait for user-space? It'll have to wait for the USB and
> I2C stacks to initialize anyway, so it won't be available at the very
> early stages of the boot.

Try playing with a system which does have the wrong time. There is so 
much stuff which depends on the correct time, it is just a pain if the 
time is wrong or even the same across multiple system starts. And even 
if you know that, you might e.g. forget it and will use git to send some 
email and patches with erroneous times. But that is just an example.

And as I said, there might some other devices you might want or need in 
the future before usespace starts, so it solves a problem as the one 
above which I didn't have solved. ;)

Alexander

