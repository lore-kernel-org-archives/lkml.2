Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179Ab0KJAzj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 19:55:39 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:61416 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab0KJAzi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 19:55:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eTw7UAb6pO2dpSFlbsWiDvrGiuQ/PhVO6MtvvJbxWac6rs6dtRBAxF0Meg5huKXpD2
         NaNT7C49OIUtGg8zRrn9EaPR09zZNb3PG8/Crb0y32Gi5gf1a2HrqqMzEzmdpWcafSm6
         vzqANeTl+lblnyUpBcCuKvYmLS/99f8tzn8p8=
MIME-Version: 1.0
In-Reply-To: <20101011173649.GC7116@kroah.com>
References: <4C7CD95A.5040309@samsung.com>
	<20100917150731.f1f44f3c.akpm@linux-foundation.org>
	<AANLkTim2UhJAhOw1qHvZ9bbctR0tNSMvE61T=sxffHxO@mail.gmail.com>
	<4CB26931.5040105@samsung.com>
	<20101011173649.GC7116@kroah.com>
Date: Wed, 10 Nov 2010 09:55:34 +0900
Message-ID: <AANLkTi=vTkHJJ2dq5RZHHCwWYEBtY=Y7dPPh=Wzzx95f@mail.gmail.com>
Subject: Re: [PATCH v2] misc: adds support the FSA9480 USB Switch
From: Minkyu Kang <promsoft@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Minkyu Kang <mk7.kang@samsung.com>, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        kyungmin.park@samsung.com, Ben Dooks <ben-i2c@fluff.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Greg KH,

On 12 October 2010 02:36, Greg KH <greg@kroah.com> wrote:
> On Mon, Oct 11, 2010 at 10:32:33AM +0900, Minkyu Kang wrote:
>> The FSA9480 is a USB port accessory detector and switch.
>> This patch adds support the FSA9480 USB Switch.
>>
>> Signed-off-by: Minkyu Kang <mk7.kang@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>> v2:
>>  use the threaded irq
>>  fix the sysfs
>>
>>  drivers/misc/Kconfig    |    9 +
>>  drivers/misc/Makefile   |    1 +
>>  drivers/misc/fsa9480.c  |  544 +++++++++++++++++++++++++++++++++++++++++++++++
>>  include/linux/fsa9480.h |   40 ++++
>
> Why do you need a .h file here for a single driver?

Because of platform data.

>
> You are creating new sysfs files, so you are required to add a new
> Documentation/ABI file as well, please add that to this patch.

ok.

>
> And why are you exporting symbols from this driver, that should not be
> needed at all.

It's for other drivers.
For example.. When USB cable is connected, PMIC driver enable the
power for each device. (USB, uart, audio and so on..)
But if use the manual switch, PMIC driver can't know what device is enabled.
So, this function was exported.

>
>
>> +/*
>> + * fsa9480.c - FSA9480 micro USB switch device driver
>> + *
>> + * Copyright (C) 2010 Samsung Electronics
>> + * Minkyu Kang <mk7.kang@samsung.com>
>> + * Wonguk Jeong <wonguk.jeong@samsung.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>
> Are you positive about that "any later version" portion of this?

I will update the licence.

>
> thanks,
>
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Thanks
Minkyu Kang
-- 
from. prom.
www.promsoft.net
