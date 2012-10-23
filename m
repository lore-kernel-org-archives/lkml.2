Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932498Ab2JWHT7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 03:19:59 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59710 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932177Ab2JWHT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 03:19:56 -0400
Date: Tue, 23 Oct 2012 08:19:51 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Dan Murphy <dmurphy@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nishanth Menon <nm@ti.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linus.walleij@stericsson.com,
        Jonas Aaberg <jonas.aberg@stericsson.com>,
        Will Deacon <will.deacon@arm.com>,
        Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>
Subject: Re: [PATCH] Boottime: A tool for automatic measurement of
 kernel/bootloader boot time
Message-ID: <20121023071951.GA2705@gmail.com>
References: <1349966545-19340-1-git-send-email-lee.jones@linaro.org>
 <20121012134542.GH12567@gmail.com>
 <20121012134813.GK21164@n2100.arm.linux.org.uk>
 <201210121353.16798.arnd@arndb.de>
 <20121012140149.GJ12567@gmail.com>
 <50784729.4030302@ti.com>
 <20121012164221.GN12567@gmail.com>
 <507C3125.70702@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <507C3125.70702@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a few answers for you.

> >>>>>>root@ME:/ cat /sys/kernel/debug/boottime/bootgraph
> >>>>>>[    0.185254] calling  splash+0x0/0x0
> >>>>>>[    2.984335] initcall splash+0x0/0x0 returned 0 after 2799 msecs.
> >>>>>>[    2.984335] calling  autoboot_delay+0x0/0x0
> >>>>>>[    4.089513] initcall autoboot_delay+0x0/0x0 returned 0 after 1105 msecs.
> >>>>>>[    4.089513] calling  load_kernel+0x0/0x0
> >>>>>>[    4.239174] initcall load_kernel+0x0/0x0 returned 0 after 149 msecs.
> >>>>>>[    4.239174] calling  boot_kernel+0x0/0x0
> >>>>>>[    4.276260] initcall boot_kernel+0x0/0x0 returned 0 after 37 msecs.
> >>>>>>[    4.276260] calling  uncompress_ll_init+0x0/0x0
> >>>>>>[    4.276260] initcall uncompress_ll_init+0x0/0x0 returned 0 after 0 msecs.
> >>>>>>[    4.276260] Freeing init memory: 0K

> OK So has this been validated and tested on any other IC then a ST part?

No, it has not. As I believe I mentioned before, this is a tool
written for and used by ST-Ericsson. Extending it to use on other
platforms sounds like a great idea, but won't be done by
ST-Ericsson due to a lack of hardware and software assets.

> This boottime_activate patch seems to be only for the dbx500.  If
> this is supposed to be a generic solution I would expect
> a generic patch for ARM to enable boot time activation.

Apparently a generic boottime extention would be fairly trivial
with the use of ktime_get().

> Have you profiled how much time the boot time logging has added to
> the over all boot?

This has not been completed, but the original author suspects
it would be <100ms.

> Also the boottime commit message should explain a little more what
> it is measuring.
> i.e.  This patch enables logging the boot time from point x to point
> y for the kernel only.  This does not include init.
> What about adding the boot time from the init sequence to init complete?

This sounds like a good idea, but again won't be extended upon by
us.

It appears that this driver is interesting and possibly very
useful for quite a lot of people out there. This patch should
therefore be seen as the foundations for other to then extend
in the ways alluded to above and ported to work on other more
generic platforms. I think these should be extra patches on
top of the one submitted here.

>From a personal perspective, I am happy to change a few bits
and pieces, but I don't have the time to satisfy all of the
suggestions made, or adapt the driver in any substantial
manor.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
