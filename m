Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167Ab1ITJIL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 05:08:11 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54100 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744Ab1ITJIJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 05:08:09 -0400
MIME-Version: 1.0
X-Originating-IP: [93.173.55.223]
In-Reply-To: <1315846025-11453-1-git-send-email-ohad@wizery.com>
References: <1315846025-11453-1-git-send-email-ohad@wizery.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 20 Sep 2011 12:07:48 +0300
Message-ID: <CAK=Wgbam6u1bq8fG+oMUhxfWH1g3dU7q+VhPWFEZOLgFMV_3vQ@mail.gmail.com>
Subject: Re: [PATCH 00/10] hwspinlock-next
To: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Tony Lindgren <tony@atomide.com>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Nicolas Pitre <nico@fluxnic.net>, Thomas Gleixner <tglx@linutronix.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 12, 2011 at 7:46 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> This series includes a new u8500 hwspinlock driver from Mathieu,
> a core fix from Juan and several other cleanups/fixes
> (some of which were reported by Arnd while reviewing Mathieu's
> driver).
...
>  Documentation/hwspinlock.txt             |   74 +++++++-----
>  MAINTAINERS                              |   15 +++
>  arch/arm/mach-omap2/hwspinlock.c         |    8 +-
>  drivers/hwspinlock/Kconfig               |   27 +++--
>  drivers/hwspinlock/Makefile              |    2 +
>  drivers/hwspinlock/hwspinlock_core.c     |  204 +++++++++++++++++++-----------
>  drivers/hwspinlock/hwspinlock_internal.h |   40 ++++--
>  drivers/hwspinlock/omap_hwspinlock.c     |  127 +++++++------------
>  drivers/hwspinlock/u8500_hsem.c          |  198 +++++++++++++++++++++++++++++
>  include/linux/hwspinlock.h               |   46 +++++--
>  10 files changed, 516 insertions(+), 225 deletions(-)

I'm wondering how hwspinlock updates like this should go upstream.

The first hwspinlock batch was picked by Tony, because it involved a
bulk of OMAP changes.

Hwspinlock isn't OMAP-specific anymore though (we gained support for
STE's u8500) and the vast majority of changes are in drivers/. We're
still very much ARM-related, though this may change too at some point
(c6x has a similar "hardware semaphore" peripheral like the u8500
does).

Tony, if you're still willing to pick up these updates I'd be happy to
send you pull requests of course.

Otherwise, I'll appreciate if anyone has any suggestions ?

I'll of course set up a tree for this and ask Stephen to take it to
linux-next as expected (unless someone just prefers to pick up the
acked patches into his tree).

Thanks,
Ohad.
