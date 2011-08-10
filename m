Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855Ab1HJCgM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 22:36:12 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39403 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab1HJCgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 22:36:10 -0400
Message-ID: <4E41EE6C.9000200@gmail.com>
Date: Wed, 10 Aug 2011 12:35:24 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: "Murali K. Vemuri" <vemuri.muralikrishna@gmail.com>
CC: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: kernel panic with simple driver
References: <CAME+iufMQT-pWzxgc79NyZq-hW-6QU9FAJd1SV_UR+zR2erPOQ@mail.gmail.com>	<4E41D3FB.9080802@gmail.com>	<CAME+iuf=mNy=s16y6LFZ7MpFWFg26UxjTF64o6smtC3=WgERkw@mail.gmail.com>	<20110810021630.GA23748@kroah.com> <CAME+iucHOG+cvB2y9uLxwtLtas+E0nEfekgmN7gfj7YsT3kj+g@mail.gmail.com>
In-Reply-To: <CAME+iucHOG+cvB2y9uLxwtLtas+E0nEfekgmN7gfj7YsT3kj+g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/11 12:29, Murali K. Vemuri wrote:
> On Wed, Aug 10, 2011 at 11:16 AM, Greg KH<greg@kroah.com>  wrote:
>> On Wed, Aug 10, 2011 at 10:33:28AM +0900, Murali K. Vemuri wrote:
>>> There is no concurrent access to the timer. The design is that:
>>> 1.Driver provides an IOCTL for start / stop
>>> 2. when the driver receives START IOCTL, it toggles some GPIOs to ON / OFF.
>>> 3. the GPIOs will be ON for 500 MSec and OFF for 500 MSec.
>>> 4. Two successive START IOCTLs will not be honored.
>>> 5. There is only one application that uses these IOCTLs
>>> 6. When I receive a STOP IOCTL, I am doing :
>>> if (timer_pending (&my_timer))
>>> del_timer(&my_timer);
>> What kind of driver is this?  For what type of hardware?
>>
>> Can't you control the gpios from userspace with out any need to write a
>> kernel driver?
>>
> This driver is meant for controlling some LEDs. The CPU is OMAP 3530
> and the OS is Android.
>  From the user space, I could not control the GPIOs directly, and thus
> I ended up supporting in the form of a simple driver.
> I agree that these are better done from the user space, but as much as
> I google'd studied, I could not find any better way to implement this.
>
> If anyone has more info, that is also highly appreciated.

If you have CONFIG_GPIO_SYSFS enabled then you can access the gpios 
directly via sysfs. See Documentation/gpio.txt for details.

~Ryan

