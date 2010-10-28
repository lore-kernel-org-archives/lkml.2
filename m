Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987Ab0J1KhZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 06:37:25 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40345 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757205Ab0J1KhW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 06:37:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HRcrsPVRTlIFT/sdrUMmXca6vFba/ouFVQlv84Ul+upTZLdkXa32ADiQaZSbyCoOvd
         bX0KALymSW0Y8xA+HAYzT675wC1S1msux0t4gtxUanVKNb7DpYMBXX/Xw0gyBHaWbQcK
         7U5t48yrU9bpoNrsXxK4akUOoBWDx3cROAHYA=
MIME-Version: 1.0
In-Reply-To: <20101022163359.5b22a61b@lxorguk.ukuu.org.uk>
References: <AANLkTi=XTUau_GbASJEUBgsZ_FYYmRAX6W43YtRdv2wS@mail.gmail.com>
	<20101022135130.617f0ce8@lxorguk.ukuu.org.uk>
	<AANLkTik-S50ZX6mFG+vWhBv0x_WmipP=t+4VqmAgssRC@mail.gmail.com>
	<20101022163359.5b22a61b@lxorguk.ukuu.org.uk>
Date: Thu, 28 Oct 2010 12:37:20 +0200
Message-ID: <AANLkTimpESWXt9i1R54fm7=Fmpd95bw6HAP1s1x1q5=n@mail.gmail.com>
Subject: Re: [PATCH 5/9] mfd: Add UART support for the ST-Ericsson CG2900.
From: Par-Gunnar Hjalmdahl <pghatwork@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linus.walleij@stericsson.com, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lukasz.Rymanowski@tieto.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks again for your comments Alan.

Next patch set will contain resolution to all your comments. See below.

/P-G

2010/10/22 Alan Cox <alan@lxorguk.ukuu.org.uk>:
>> The existence of the callback is checked in the function
>> uart_tty_open. If either break_ctl or tiocmget is NULL we do not allow
>> sleep and this code will never run.
>
> OK yes see this now.
>
>> >> +             CG2900_ERR("Failed to alloc memory for uart_work_struct!");
>> >
>> > Please use the standard dev_dbg etc functionality - or pr_err etc when
>> > you have no device pointer. The newest kernel tty object has a device
>> > pointer added so you could use that.
>> >
>>
>> OK. I like the debug system we have now (using module parameter to set
>> debug level in runtime), but I've received comments regarding this
>> before so I assume we will have to switch to standard printouts.
>> Is it OK to use defines or inline functions to add "CG2900" before and
>> '\n' after (as BT_INFO in include/net/bluetooth/bluetooth.h)?
>
> The pr_fmt bit will do what you want for a non dev_dbg type thing. See
> include/linux/kernel.h
>

OK. Added. I'm however using dev_err, dev_dbg, etc where possible.

>> >> + * unset_cts_irq() - Disable interrupt on CTS.
>> >> + */
>> >> +static void unset_cts_irq(void)
>> >
>> > And no ability to support multiple devices
>> >
>>
>> OK. We will try to fix this.
>
> That may go away when you clean up the device side. The line discipline
> can be attached to any device so must be multi-device aware, the hardware
> driver can certainly be single device only if you can only ever have one
>
> [Although its a good idea to design it so it can be fixed because you
>  never know when you'll find your sales team just sold someone a two
>  device solution ;) ]
>

OK. Design still ongoing, but will be fixed in some way.

>> >> +             set_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
>> >> +             len = tty->ops->write(tty, skb->data, skb->len);
>> >
>> > A tty isn't required to have a write function
>>
>> I don't quite understand your comment here. This particular code is
>> inspired of the Bluetooth ldisc code and there it is used like. It
>> seems to work fine so we do it the same way.
>
> You copied a security hole from the bluetooth driver which we found a
> couple of weeks ago
>
>> How would you prefer it to be?
>
> Check it is valid, in your case probably on open just refuse to attach to
> a read only port.
>

OK. Done.

>> OK. We will try to figure out a new design.
>> I'm not too happy about putting the ldisc part in Bluetooth though
>> since it is only partly Bluetooth, it is also GPS and FM. Better could
>> maybe be under char/?
>
> Works for me - there is an ongoing "we must move tty ldiscs and core tty
> code somewhere more sensible of their own" discussion, so if it is
> dropped into char, it'll move with them just fine.
>
> Alan
>

Again, thanks for the comments.

/P-G
