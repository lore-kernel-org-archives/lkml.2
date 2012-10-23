Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932814Ab2JWKLZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 06:11:25 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:51330 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756970Ab2JWKLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 06:11:23 -0400
MIME-Version: 1.0
In-Reply-To: <1350906877-19410-1-git-send-email-balbi@ti.com>
References: <1350906877-19410-1-git-send-email-balbi@ti.com>
Date: Tue, 23 Oct 2012 12:11:21 +0200
Message-ID: <CACRpkdYiMtriTaKG=nT=7Jg2g0wUN3+JeN90V3jRke0bP2EHrA@mail.gmail.com>
Subject: Re: [PATCH] arm: sched: stop sched_clock() during suspend
From: Linus Walleij <linus.walleij@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@ti.com>, Paul Walmsley <paul@pwsan.com>,
        Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 1:54 PM, Felipe Balbi <balbi@ti.com> wrote:

> The scheduler imposes a requirement to sched_clock()
> which is to stop the clock during suspend, if we don't
> do that IRQ threads will be rescheduled in the future
> which might cause transfers to timeout depending on
> how driver is written.
>
> This became an issue on OMAP when we converted omap-i2c.c
> to use threaded IRQs, it turned out that depending on how
> much time we spent on suspend, the I2C IRQ thread would
> end up being rescheduled so far in the future that I2C
> transfers would timeout and, because omap_hsmmc depends
> on an I2C-connected device to detect if an MMC card is
> inserted in the slot, our rootfs would just vanish.
>
> arch/arm/kernel/sched_clock.c already had an optional
> implementation (sched_clock_needs_suspend()) which would
> handle scheduler's requirement properly, what this patch
> does is simply to make that implementation non-optional.
>
> This has been tested with beagleboard XM (OMAP3630) and
> pandaboard rev A3 (OMAP4430). Suspend to RAM is now working
> after this patch.
>
> Signed-off-by: Felipe Balbi <balbi@ti.com>

After Russell explains so I get it:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
