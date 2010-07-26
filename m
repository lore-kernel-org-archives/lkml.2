Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186Ab0GZUIp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 16:08:45 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:37937 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754557Ab0GZUIn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 16:08:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=eUG66y4I0HNiRBfo1f4Gu54Kp+Ob/kpj5G3o2mY+yDz654QsQjFTwp5zZQjFR90XFc
         LJ5AC26W5B+3X3YefjfFoKuvBpquY9guXjqmvGtTzw902MhO7Y/zL4K+CssG4h7zTT8j
         nPiAczZ4WZ/U+4M/bl9JhK28hJKDY0mPAjm7I=
MIME-Version: 1.0
In-Reply-To: <AANLkTilKJx18oyc815DhKfPv-Yjdv8UmfJ4WTDxZxaab@mail.gmail.com>
References: <AANLkTikitTGpiE5Oe_P5a4f2OCOnlB9j_LVm5CQhQIno@mail.gmail.com>
	<20100722122111.4cf4ca2f@lxorguk.ukuu.org.uk>
	<AANLkTilKJx18oyc815DhKfPv-Yjdv8UmfJ4WTDxZxaab@mail.gmail.com>
Date: Mon, 26 Jul 2010 22:08:40 +0200
X-Google-Sender-Auth: NnVqhJJIESbSFaG7hUEFxEk79rE
Message-ID: <AANLkTimciy00nGiePXcMAcuiuoPLjB8AKb2jtHFPZ5rC@mail.gmail.com>
Subject: Re: Introducing the LCD-Linux project
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mattia Jona-Lasinio <mattia.jona@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        Miguel Ojeda Sandonis <miguel.ojeda.sandonis@gmail.com>,
        Willy Tarreau <w@1wt.eu>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <triad@df.lth.se>, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>, ivan.kuten@promwad.com,
        lcd-linux-users@lists.sourceforge.net,
        Viktar Palstsiuk <viktar.palstsiuk@promwad.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 13:38, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Thu, Jul 22, 2010 at 13:21, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> On Wed, 21 Jul 2010 14:57:54 +0200
>> Mattia Jona-Lasinio <mattia.jona@gmail.com> wrote:
>>> this is to introduce the LCD-Linux project (http://lcd-linux.sourceforge.net/),
>>> a kernel level implementation of a VT102 terminal emulator, optimized for small
>>> alphanumeric and graphic displays.
>>
>> The kernel already has a console and that provides an abstract
>> implementation that is used for everything from text mode displays to vga
>> to assorted accelerated hardware platforms.
>>
>> Why do we need a VT102 as well ?
>>
>>> functions. A solution is therefore to provide a sort of minimal terminal
>>> emulation in kernel space, that can be accessed through the standard character
>>> device interface. In this way the problem of the display management is reduced
>>
>> If you use the existing kernel console interfaces then you don't need to
>> worry about vt102 v console or having two terminal emulations running.
>
> Indeed, the kernel already has the console abstraction.
>
> I wrote a LCD console driver (for a HD44780 connected to the parallel
> port) using
> the standard console abstraction several years ago. As it used the standard
> console abstraction, it supported multiple virtual consoles and co-operated with
> the VGA text console out-of-the-box. Just use ALT-Fx to switch between different
> VCs on the LCD or on VGA.
>
> I never published the code, though. Will do so tonight when I get back
> to the machine that holds the code ;-)

And so I did, to prevent it from being lost for mankind:

    http://users.telenet.be/geertu/Download/hd44780.tar.gz

This is a Linux console driver for a HD44780 LCD connected to a PC-style
parallel port. It supports both 4-bit and 8-bit interface mode.

The code was developed and used with a 20x4 LCD connected to the parallel port
of a standard PC and a CHRP LongTrail PowerPC box, with Linux kernel 2.2
(early development) and 2.4, from 2000 until 2004. There's no guarantee it will
work with more recent kernels.

The console driver has a comment suggesting to use a 20x4 window on an 80x25
virtual screen, but this has never been implemented.

It consists of 4 modules:
  - hd44780: Mid-level HD44780 LCD driver, handling the HD44780 commands
             [kernel, user]
  - parlcd: Low-level HD44780 driver, defining how to talk to a HD44780 LCD
            connected to a PC-style parallel port [kernel, user]
  - lcdcon: Standard Linux console driver for a HD44780 LCD [kernel]
  - play: Interactive test program to talk to the HD44780 or to the raw
          parallel port [user]

Modules marked [kernel] are used inside the Linux kernel only.
Modules marked [user] are used with the userspace test program.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
