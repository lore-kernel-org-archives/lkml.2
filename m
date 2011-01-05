Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab1AEUhp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 15:37:45 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51040 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab1AEUhn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 15:37:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=MjV0FoomILGsGsx7t8G0El0m1xdH9JMI0hf5kGbMb14jZfR0pYgeeYXslNhE0tYeOH
         KSfh0XQ3ZnUnkBe/dCtVFHgdXPmPCaw2SsjuXR168fjHkBJtissInl0upa9UXvY+foaw
         ecAT7Q9674dV/u8jsm6fxKOn2lKeG+NHfEhyc=
MIME-Version: 1.0
In-Reply-To: <20110103.105827.112602895.davem@davemloft.net>
References: <1294072336.17576.7.camel@lithium>
	<20110103.105827.112602895.davem@davemloft.net>
Date: Wed, 5 Jan 2011 21:37:41 +0100
X-Google-Sender-Auth: 1I0tbqwR0mO6FoCyyeLdp5lIF6c
Message-ID: <AANLkTimW0xQ1F1d-_=jP_QKyQH=Yy6FZUbGD0Cm4JaBO@mail.gmail.com>
Subject: Re: Using s3virge card in Sun Blade 2000
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Miller <davem@davemloft.net>
Cc: alex.buell@munted.org.uk, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 3, 2011 at 19:58, David Miller <davem@davemloft.net> wrote:
> From: Alex Buell <alex.buell@munted.org.uk>
> Date: Mon, 03 Jan 2011 16:32:16 +0000
>
>> I'm aware the s3fb driver has big endian issues, I can help fix those
>> issues so I can get the card working. Or in other words, I'd welcome
>> advice on how to proceed with this.
>
> It's not endian issues, this driver has other problems.
>
> It uses the VGA register accessors with a NULL regbase, which is not
> going to work on sparc64.
>
> It needs to access the VGA register space relative to the I/O space
> of the PCI controller domain it is behind.
>
> Probably if you replace the NULL values passes to vga_r*() and
> vga_w*() with the I/O space resource base of the chip (should be
> resource "1") it might work.

Probably s3fb also relies on a card having been initialized by the VGA BIOS.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
