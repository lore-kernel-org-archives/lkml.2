Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab0LFVYg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 16:24:36 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:42872 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423Ab0LFVYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 16:24:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=BRW5JLR2Slh9elMSX4ZwrmL1eQdkptC1UYrmc5L6t0nYbNohwpVKwIXRYqpkIm9QIK
         rgc3tWk2OUjYi2XdsAxh0mn8Khg28vOOLhKWX8WmjfKSh7QOKhGCBNq1p1wKiPlt3EUi
         pXdtl9nNAxQwRfG6bhHctepz/JQ24TXdRYQTE=
MIME-Version: 1.0
In-Reply-To: <201012061754.44592.arnd@arndb.de>
References: <AANLkTi=XTUau_GbASJEUBgsZ_FYYmRAX6W43YtRdv2wS@mail.gmail.com>
	<201012061615.28093.arnd@arndb.de>
	<AANLkTi=upn_ieeW_OXzKaHsrEumH2F_fMn07P6-97qb1@mail.gmail.com>
	<201012061754.44592.arnd@arndb.de>
Date: Mon, 6 Dec 2010 22:24:34 +0100
Message-ID: <AANLkTin_VOjz=bGCnANgp8G2SFFFOkT3TKRh50p5L1Gj@mail.gmail.com>
Subject: Re: [PATCH 5/9] mfd: Add UART support for the ST-Ericsson CG2900.
From: Vitaly Wool <vitalywool@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Par-Gunnar Hjalmdahl <pghatwork@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linus.walleij@stericsson.com,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 6, 2010 at 5:54 PM, Arnd Bergmann <arnd@arndb.de> wrote:

>> But I was trying to make a different point here. On a basic level,
>> there's this cg2000 chip from STE that does BT, FM and GPS. There's
>> the chip from TI that does BT, FM and GPS, and there's the Broadcom
>> chip that does BT+FM. They all use HCI to access the other functions
>> of the combo chip and they do it in a really simiar way, with the
>> differences mostly in power management techniques. So I think it's
>> quite sensible to have some kind of framework that is suitable for
>> such devices.
>
> Yes, I agree 100% in principle. I could not find the code that
> Broadcom/TI FM and GPS stuff so far, can you point us to that?

Sure, the TI "shared transport" code is mostly at drivers/misc/ti-st.

Some Broadcom BCM43xx chips work in a similar way AFAIK but I'm not
sure about the mainline support for those.

> The cg2900 solution for this was to use MFD (plus another layer
> in the posted version, but that will go away I assume). Using
> MFD is not the only possibility here, but I could not see anything
> wrong with it either. Do you think we can move them all over to
> use MFD infrastructure?

I guess so but it's probably more of a detail than what I'm up to now :)

>> But generally speaking, isn't a line discipline/driver attached to a
>> tty? We can use dumb tty for e. g. SPI and still be able to use
>> hci_ll, right?
>
> I suggested that as well, but the point was made that this would
> add an unnecessary indirection for the SPI case, which is not
> really much like a serial port. It's certainly possible to do it
> like you say, but if we add a way to register the high-level
> protocols with an HCI-like multi-function device, we could
> also do it in a way that does not rely on tty-ldisc but keeps it
> as one of the options.

I actually don't think it's such a big indirection, I prefer to think
of it more as of the abstraction layer. If not use this, are we going
to have direct SPI device drivers? I'm afraid we might end up with a
huge duplication of code in that case.

Thanks,
   Vitaly
