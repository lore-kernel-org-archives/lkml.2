Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab1HJC3M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 22:29:12 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:60969 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096Ab1HJC3K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 22:29:10 -0400
MIME-Version: 1.0
In-Reply-To: <20110810021630.GA23748@kroah.com>
References: <CAME+iufMQT-pWzxgc79NyZq-hW-6QU9FAJd1SV_UR+zR2erPOQ@mail.gmail.com>
	<4E41D3FB.9080802@gmail.com>
	<CAME+iuf=mNy=s16y6LFZ7MpFWFg26UxjTF64o6smtC3=WgERkw@mail.gmail.com>
	<20110810021630.GA23748@kroah.com>
Date: Wed, 10 Aug 2011 11:29:09 +0900
Message-ID: <CAME+iucHOG+cvB2y9uLxwtLtas+E0nEfekgmN7gfj7YsT3kj+g@mail.gmail.com>
Subject: Re: kernel panic with simple driver
From: "Murali K. Vemuri" <vemuri.muralikrishna@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Ryan Mallon <rmallon@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 11:16 AM, Greg KH <greg@kroah.com> wrote:
> On Wed, Aug 10, 2011 at 10:33:28AM +0900, Murali K. Vemuri wrote:
>> There is no concurrent access to the timer. The design is that:
>> 1.Driver provides an IOCTL for start / stop
>> 2. when the driver receives START IOCTL, it toggles some GPIOs to ON / OFF.
>> 3. the GPIOs will be ON for 500 MSec and OFF for 500 MSec.
>> 4. Two successive START IOCTLs will not be honored.
>> 5. There is only one application that uses these IOCTLs
>> 6. When I receive a STOP IOCTL, I am doing :
>> if (timer_pending (&my_timer))
>> del_timer(&my_timer);
>
> What kind of driver is this?  For what type of hardware?
>
> Can't you control the gpios from userspace with out any need to write a
> kernel driver?
>

This driver is meant for controlling some LEDs. The CPU is OMAP 3530
and the OS is Android.
>From the user space, I could not control the GPIOs directly, and thus
I ended up supporting in the form of a simple driver.
I agree that these are better done from the user space, but as much as
I google'd studied, I could not find any better way to implement this.

If anyone has more info, that is also highly appreciated.
Thanks
Murali

> thanks,
>
> greg k-h
>
