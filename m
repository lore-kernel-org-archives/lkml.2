Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422780Ab2KNMiw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 07:38:52 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:57647 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422749Ab2KNMiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 07:38:50 -0500
Message-ID: <50A390CC.9000208@ahsoftware.de>
Date: Wed, 14 Nov 2012 13:38:36 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Till Harbaum <till@harbaum.org>
Subject: Re: [PATCH 1/2] i2c: Add possibility for user-defined (i2c-)devices
 for bus-drivers.
References: <1352829968-4908-1-git-send-email-holler@ahsoftware.de> <20121113195533.6db71716@endymion.delvare> <50A2AC28.7050304@ahsoftware.de> <20121113220835.111a178a@endymion.delvare> <50A2BAA2.6090009@ahsoftware.de> <20121113224246.768bf734@endymion.delvare> <50A2DA0C.3090507@ahsoftware.de> <20121114104050.79df8cd9@endymion.delvare>
In-Reply-To: <20121114104050.79df8cd9@endymion.delvare>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Am 14.11.2012 10:40, schrieb Jean Delvare:

>> It isn't possible to do such, because the only ID available for
>> i2c-busses is given them at runtime. So people have to live with that
>> imho artificially problem, if they use my patch. I don't have any other
>> solution until the numbering is predictable. But I assume you already
>> know all that, otherwise you wouldn't have mentioned it.
>
> The problem is inherent to external, hot-plug I2C adapters. You can't
> predict their bus number, and actually you can't even always predict
> their name. In the case of usb-tiny-i2c, you may be able to look-up the
> bus number from the adapter name, but you won't be able to always
> differentiate between two adapters, if they are connected to paired USB
> ports.
>
> This is a design issue with the i2c-tiny-usb hardware in the first
> place. If it is needed to differentiate between adapters, their would
> need to be a locally unique ID in every adapter, which the kernel can
> query. I suppose this was not deemed necessary at design time, as most
> people will only connect one such adapter at a time to their system.

Actually many of the available USB devices (e.g. many usb-serials) don't 
offer a unique ID by themself. That isn't just a problem of the 
i2c-tiny-usb. But in contrast to other solutions, it shouldn't be very 
hard to give those adapters a unique ID. As the whole SUB solution is 
just software (and open source), one likely just would to write some 
small piece of additional code.

> I have already experienced this and yes, it is a pain. But I would
> think that a system designed without a RTC in the first place has
> another way of getting its time correct at boot time, for example NTP.
> As I understand it the RTC chip is only there to set the system time at
> boot, right, the actual timekeeping during run-time is still done by the
> CPU?

Whatever those people which want to us it decide. If I didn't want to 
help other people by offering them some small documentation about how to 
build such theirself, I wouldn't have taken the usual and almost 
unavoidable pain trying feed some silly patches into the kernel. ;)

Anyway, maybe Till Harbaum will like that solution and won't get blocked 
by you. And maybe in some years we will see how many other bus-drivers 
have adopted the same solution. In fact the in-driver solution was my 
first one and I've thought others might be interested too, so I've moved 
the few lines from the driver itself into the i2c-core before I sent the 
patches. Unfortunately a waste of time.

Regards,

Alexander

