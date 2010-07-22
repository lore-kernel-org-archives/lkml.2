Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759226Ab0GVLij (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 07:38:39 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:57848 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554Ab0GVLig convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 07:38:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=tbcWGSWz/BNfWRrV1PKLdJJn880S2tHd5pYUEvdXoOFCjoqFqPXLDpqOzry2QTbuBs
         4dmH9FT+Iu7fcaKsXBh41uL2KxroumJDdAr2gkekitBa2sENplmxdvPLwtKU9n9cOPJi
         HtU8WCMrNocHMpqgqH+pTu7YWk3V401jUlHEk=
MIME-Version: 1.0
In-Reply-To: <20100722122111.4cf4ca2f@lxorguk.ukuu.org.uk>
References: <AANLkTikitTGpiE5Oe_P5a4f2OCOnlB9j_LVm5CQhQIno@mail.gmail.com>
	<20100722122111.4cf4ca2f@lxorguk.ukuu.org.uk>
Date: Thu, 22 Jul 2010 13:38:34 +0200
X-Google-Sender-Auth: BcK8YwL0nTXqq-22ZdUMHTWddMU
Message-ID: <AANLkTilKJx18oyc815DhKfPv-Yjdv8UmfJ4WTDxZxaab@mail.gmail.com>
Subject: Re: Introducing the LCD-Linux project
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Mattia Jona-Lasinio <mattia.jona@gmail.com>, linux-kernel@vger.kernel.org,
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

On Thu, Jul 22, 2010 at 13:21, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Wed, 21 Jul 2010 14:57:54 +0200
> Mattia Jona-Lasinio <mattia.jona@gmail.com> wrote:
>> this is to introduce the LCD-Linux project (http://lcd-linux.sourceforge.net/),
>> a kernel level implementation of a VT102 terminal emulator, optimized for small
>> alphanumeric and graphic displays.
>
> The kernel already has a console and that provides an abstract
> implementation that is used for everything from text mode displays to vga
> to assorted accelerated hardware platforms.
>
> Why do we need a VT102 as well ?
>
>> functions. A solution is therefore to provide a sort of minimal terminal
>> emulation in kernel space, that can be accessed through the standard character
>> device interface. In this way the problem of the display management is reduced
>
> If you use the existing kernel console interfaces then you don't need to
> worry about vt102 v console or having two terminal emulations running.

Indeed, the kernel already has the console abstraction.

I wrote a LCD console driver (for a HD44780 connected to the parallel
port) using
the standard console abstraction several years ago. As it used the standard
console abstraction, it supported multiple virtual consoles and co-operated with
the VGA text console out-of-the-box. Just use ALT-Fx to switch between different
VCs on the LCD or on VGA.

I never published the code, though. Will do so tonight when I get back
to the machine
that holds the code ;-)

Having a bigger virtual console where the LCD follows the region
surrounding the cursor
is indeed a nice extension to have.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
