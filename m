Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758750Ab0KPV33 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 16:29:29 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:60134 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755444Ab0KPV32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 16:29:28 -0500
MIME-Version: 1.0
In-Reply-To: <20101116204906.29d840e9@lxorguk.ukuu.org.uk>
References: <1289922400.1253.3.camel@yio.site> <20101116155717.6671e484@lxorguk.ukuu.org.uk>
 <AANLkTimn7zyEjLhmOmUVQGnLDfM-A_uEgWETsM3nsyuY@mail.gmail.com>
 <20101116171447.29336514@lxorguk.ukuu.org.uk> <AANLkTi=ju4fON7Hz=j_tFtqFGD0b-c=-Ou+HQwfYDgOy@mail.gmail.com>
 <20101116195538.7fa66b97@lxorguk.ukuu.org.uk> <AANLkTinXy3pNhwqo5aqHrH9fN99JhJrBtnbbpnq2h_K-@mail.gmail.com>
 <20101116204906.29d840e9@lxorguk.ukuu.org.uk>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Tue, 16 Nov 2010 22:29:11 +0100
Message-ID: <AANLkTik3fdR4zzKq29THQjpW5sNoqFEQsq9vevF6diUi@mail.gmail.com>
Subject: Re: tty: add 'active' sysfs attribute to tty0 and console device
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
        Lennart Poettering <lennart@poettering.net>,
        Werner Fink <werner@suse.de>, Jiri Slaby <jslaby@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 21:49, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> > Stuff never stops changing until the machine shuts down, its undefined.
>>
>> Either you don't, or you just don't want to understand what all this
>> is about. :)
>
> At what point do you think the current tty stops changing ? The only
> cases I can think of are shutdown, and when your own processes locks vt
> changes.

Hmm, what do you mean? It's not the tty IO. It's only the VT switch,
and this changes only when someone actually does the switch, like
pressing Alt-F1,F2,...

>> > Except that it doesn't address things like the permissions side of things.
>> >
>> > NAK again
>>
>> Specifics please.
>
> /dev/tty* and sysfs nodes don't track permissions, owner with each other,
> so you are providing interfaces that either expose information they
> shouldn't (which screen is valuable info in some environments), or don't
> expose info they should.
>
> sysfs also lacks vhangup so you can't fix it right now either.

You think exposing the currently active VC is security relevant? We
don't expose anything from the VC itself. We have this information all
over the place in userspace. What exactly you think is the problem
here?

>> > "We have an interface that doesn't quite work for our case and we think
>> > that is a bug" is not the reasoning behind writing a new random one with
>> > a totally disconnected permission model that doesn't work either.
>> >
>> > Fix the one we have.
>>
>> So how do you think you'll fix it? I better don't get into your
>> ioctl() business.
>
> Start by explaining why the current interface doesn't work for you, but
> in detail.

The sleeping ioctl() requires a dedicated thread in a service. Now we
wake up and all the stuff that happens now is lost, so we have to
check with another ioctl(), between this ioctl() and going to sleep
again is a window we don't cover, we just go to sleep, even when
something has happened. Poll() solves that by queuing the notification
until it's retrieved.

Kay
