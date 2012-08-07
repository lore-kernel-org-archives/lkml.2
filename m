Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101Ab2HGPWs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 11:22:48 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:53612 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab2HGPWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 11:22:46 -0400
MIME-Version: 1.0
In-Reply-To: <20120807115140.GH24257@flint.arm.linux.org.uk>
References: <20120806195352.GC16199@opensource.wolfsonmicro.com>
	<20120806213124.GB14594@flint.arm.linux.org.uk>
	<20120806220032.GD26698@opensource.wolfsonmicro.com>
	<CAN1soZzSz9Gs_SsTd_5BOFNjUviZgBjBiGCjt1EsAtkS5XquQA@mail.gmail.com>
	<20120807103851.GS16861@opensource.wolfsonmicro.com>
	<20120807111331.GC24257@flint.arm.linux.org.uk>
	<20120807112844.GZ16861@opensource.wolfsonmicro.com>
	<20120807113121.GD24257@flint.arm.linux.org.uk>
	<20120807113652.GA6282@flint.arm.linux.org.uk>
	<20120807114556.GC16861@opensource.wolfsonmicro.com>
	<20120807115140.GH24257@flint.arm.linux.org.uk>
Date: Tue, 7 Aug 2012 17:22:45 +0200
X-Google-Sender-Auth: l4slnzWmFor0NNx-QuKBEkInTMI
Message-ID: <CAMuHMdUezhMNL19JUK9-uSqTr3=bU7yAci0ovFd5dSdksW1etQ@mail.gmail.com>
Subject: Re: [PATCH 0/5] mfd: replace IORESOURCE_IO by IORESOURCE_MEM
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>, sameo@linux.intel.com,
        rpurdie@rpsys.net, bryan.wu@canonical.com,
        linux-kernel@vger.kernel.org, Bergmann Arnd <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 7, 2012 at 1:51 PM, Russell King <rmk@arm.linux.org.uk> wrote:
> How can:
>
> #define IORESOURCE_FOO 0x00000300
>
> in ioport.h be called "invasive" ?  The best chance of error is that the
> identifier is already in use.  So learn to use grep to check the whole
> sodding tree first to make sure that the identifier you're choosing to
> use isn't already in use somewhere.

Perhaps it's not invasive enough? :-)
Don't you need an extra file in /proc, too (cfr. /proc/ioports and /proc/iomem)?

And as Arnd pointed out, if resources will be used for various new buses,
"IORESOURCE_FOO" or "IORESOURCE_OTHER" is a bit vague.
What about conflicts where one driver means i2c addresses and another
one means gpio addresses? The resource system will reject them?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
