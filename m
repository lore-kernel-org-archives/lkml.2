Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758437Ab1F3G7f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 02:59:35 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44813 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab1F3G73 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 02:59:29 -0400
MIME-Version: 1.0
In-Reply-To: <20110629140630.5aefdda8.rdunlap@xenotime.net>
References: <alpine.DEB.2.00.1106291011400.10665@ayla.of.borg>
	<20110629140630.5aefdda8.rdunlap@xenotime.net>
Date: Thu, 30 Jun 2011 08:59:28 +0200
X-Google-Sender-Auth: ehX-SP2OUuCKvDo4L-fJUpDKAn4
Message-ID: <BANLkTin80p6gh0+Kga_92=wNEoAr9gFR2Q@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.0-rc5 (ssize_t ???)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 23:06, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On Wed, 29 Jun 2011 10:13:17 +0200 (CEST) Geert Uytterhoeven wrote:
>
>> *** WARNINGS ***
>>
>> 358 regressions:
>
>>   + drivers/net/wimax/i2400m/usb-fw.c: warning: format '%zd' expects type 'signed size_t', but argument 4 has type 'ssize_t':  => 210
>>   + drivers/net/wimax/i2400m/usb-fw.c: warning: format '%zd' expects type 'signed size_t', but argument 8 has type 'ssize_t':  => 222
>
>>   + drivers/staging/bcm/Bcmchar.c: warning: format '%zd' expects type 'signed size_t', but argument 2 has type 'ssize_t':  => 146
>>   + drivers/staging/bcm/Bcmchar.c: warning: format '%zd' expects type 'signed size_t', but argument 3 has type 'ssize_t':  => 146
>
>>   + net/sunrpc/auth_gss/auth_gss.c: warning: format '%Zd' expects type 'signed size_t', but argument 2 has type 'ssize_t':  => 708
>>   + net/sunrpc/auth_gss/auth_gss.c: warning: format '%zd' expects type 'signed size_t', but argument 3 has type 'ssize_t':  => 690
>
>
> Can someone explain these warnings, please?  (signed size_t vs. ssize_t)
>
> Is gcc confused?
> Looks like a compiler issue to me.

Nope. Also only happens on cris, which has in
arch/cris/include/asm/posix_types.h:

typedef long            __kernel_ssize_t;

The "long" should be "int".
But probably it should just include <asm-generic/posix_types.h> instead.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
