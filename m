Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758381Ab1F3HXu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 03:23:50 -0400
Received: from anubis.se.axis.com ([195.60.68.12]:51135 "EHLO
	anubis.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826Ab1F3HXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 03:23:44 -0400
X-Greylist: delayed 459 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Jun 2011 03:23:44 EDT
From: Mikael Starvik <mikael.starvik@axis.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Randy Dunlap <rdunlap@xenotime.net>
CC: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        Jesper Nilsson <jespern@axis.com>,
        linux-cris-kernel <linux-cris-kernel@axis.com>
Date: Thu, 30 Jun 2011 09:16:00 +0200
Subject: RE: Build regressions/improvements in v3.0-rc5 (ssize_t ???)
Thread-Topic: Build regressions/improvements in v3.0-rc5 (ssize_t ???)
Thread-Index: Acw29C8hgNnhPh6GRcqoIumElpXdogAATLig
Message-ID: <4BEA3FF3CAA35E408EA55C7BE2E61D055C63F4D597@xmail3.se.axis.com>
References: <alpine.DEB.2.00.1106291011400.10665@ayla.of.borg>
	<20110629140630.5aefdda8.rdunlap@xenotime.net>
 <BANLkTin80p6gh0+Kga_92=wNEoAr9gFR2Q@mail.gmail.com>
In-Reply-To: <BANLkTin80p6gh0+Kga_92=wNEoAr9gFR2Q@mail.gmail.com>
Accept-Language: sv-SE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: sv-SE
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p5U7NuBs027258

>The "long" should be "int".
>But probably it should just include <asm-generic/posix_types.h> instead.

Agreed. We wonÂ´t be able to test and push something like that before vacation but feel free to test
that change and commit it if it works. Otherwise we'll fix it after vacations.

/Mikael

-----Original Message-----
From: geert.uytterhoeven@gmail.com [mailto:geert.uytterhoeven@gmail.com] On Behalf Of Geert Uytterhoeven
Sent: den 30 juni 2011 08:59
To: Randy Dunlap
Cc: Linux Kernel Development; Mikael Starvik; Jesper Nilsson; linux-cris-kernel
Subject: Re: Build regressions/improvements in v3.0-rc5 (ssize_t ???)

On Wed, Jun 29, 2011 at 23:06, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On Wed, 29 Jun 2011 10:13:17 +0200 (CEST) Geert Uytterhoeven wrote:
>
>> *** WARNINGS ***
>>
>> 358 regressions:
>
>> Â  + drivers/net/wimax/i2400m/usb-fw.c: warning: format '%zd' expects type 'signed size_t', but argument 4 has type 'ssize_t': Â => 210
>> Â  + drivers/net/wimax/i2400m/usb-fw.c: warning: format '%zd' expects type 'signed size_t', but argument 8 has type 'ssize_t': Â => 222
>
>> Â  + drivers/staging/bcm/Bcmchar.c: warning: format '%zd' expects type 'signed size_t', but argument 2 has type 'ssize_t': Â => 146
>> Â  + drivers/staging/bcm/Bcmchar.c: warning: format '%zd' expects type 'signed size_t', but argument 3 has type 'ssize_t': Â => 146
>
>> Â  + net/sunrpc/auth_gss/auth_gss.c: warning: format '%Zd' expects type 'signed size_t', but argument 2 has type 'ssize_t': Â => 708
>> Â  + net/sunrpc/auth_gss/auth_gss.c: warning: format '%zd' expects type 'signed size_t', but argument 3 has type 'ssize_t': Â => 690
>
>
> Can someone explain these warnings, please? Â (signed size_t vs. ssize_t)
>
> Is gcc confused?
> Looks like a compiler issue to me.

Nope. Also only happens on cris, which has in
arch/cris/include/asm/posix_types.h:

typedef long            __kernel_ssize_t;

The "long" should be "int".
But probably it should just include <asm-generic/posix_types.h> instead.

Gr{oetje,eeting}s,

Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â Â  Â Â  -- Linus Torvalds
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
