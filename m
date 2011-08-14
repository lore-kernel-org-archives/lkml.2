Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab1HNTcG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 15:32:06 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:64461 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754770Ab1HNTcD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 15:32:03 -0400
MIME-Version: 1.0
In-Reply-To: <20110814173816.GA10062@kroah.com>
References: <CAMuHMdVr9iAyqQJUgHq4gcLg+gp7GxF=sH+SBKBuqVWYymXs8Q@mail.gmail.com>
	<20110814173816.GA10062@kroah.com>
Date: Sun, 14 Aug 2011 21:32:01 +0200
X-Google-Sender-Auth: LEJDi2sSMavJBYSMn1PZJFYbDpg
Message-ID: <CAMuHMdUdJvqm+U7EY-p+vmkKyBd7urcRYEfV_6BWU8zqo+b_tA@mail.gmail.com>
Subject: Re: Driver framework: binding a driver to two devices?
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, "Linux/m68k" <linux-m68k@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 14, 2011 at 19:38, Greg KH <greg@kroah.com> wrote:
> On Sat, Aug 13, 2011 at 10:44:42PM +0200, Geert Uytterhoeven wrote:
>> As Amiga Zorro expansion boards have only one BAR (unlike PCI, which has
>> multiple BARs), several Amiga graphics cards show up as two Zorro devices:
>> one for the graphics memory and one for the graphics controller's registers.
>>
>> Traditionally, a driver for such a device used
>>
>>     dev1 = zorro_find_device(id1, ...)
>>     dev2 = zorro_find_device(id2, ...)
>>
>> to find the two devices and match them.
>>
>> With the "new" driver framework, the matching with device id1 is now
>> done using a
>> struct zorro_driver with a table of IDs, while the matching with device id2 is
>> still done by calling zorro_find_device(id2, ...).
>>
>> Recently (with cirrusfb) it turned out that the call to
>> zorro_find_device(id2, ...)
>> may fail to find the second device. I suspect this happens due to the second
>> device haven't been probed for at the time the zorro_driver for the
>> first device is
>> initialized.
>>
>> I expect this can be fixed by delaying all calls to device_register() in
>> amiga_zorro_probe() until all devices have been detected and added to the array
>> used by zorro_find_device(). But I was wondering whether there's a more generic
>> way in the driver framework to bind a driver to two devices?
>
> What you really want is the same "driver instance" bound to two devices,
> right?  That way the device would operate "knowing" about both physical
> devices so as to properly control the thing.

Yes, that's what I want.

> Right now, no, there's not a simple way to do this with the driver
> model.  USB does this on its own for some devices that need to have
> multiple "interfaces" (the USB equalivant for a "device") controlled at
> the same time, so you might want to look at how that happens (in the
> indivdual drivers, not in the USB core.)

Thanks, I'll have a look at the USB drivers.
Do you know which examples to look at?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
