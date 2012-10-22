Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344Ab2JVW2f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 18:28:35 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:52168 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932281Ab2JVW2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 18:28:34 -0400
MIME-Version: 1.0
In-Reply-To: <873916h1yi.fsf@deeprootsystems.com>
References: <1350906877-19410-1-git-send-email-balbi@ti.com>
	<873916h1yi.fsf@deeprootsystems.com>
Date: Tue, 23 Oct 2012 00:28:32 +0200
Message-ID: <CACRpkdY6ox+iJAGdSD=e7Yj55TzDWqOmLqu2fSRXvKJxqwfkhQ@mail.gmail.com>
Subject: Re: [PATCH] arm: sched: stop sched_clock() during suspend
From: Linus Walleij <linus.walleij@linaro.org>
To: Kevin Hilman <khilman@deeprootsystems.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Felipe Balbi <balbi@ti.com>, Russell King <rmk+kernel@arm.linux.org.uk>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Walmsley <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Andrew Lunn <andrew@lunn.ch>, Daniel Walker <dwalker@fifo99.com>,
        Lennert Buytenhek <kernel@wantstofly.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ben Dooks <ben-linux@fluff.org>,
        Alexander Schulz <alex@shark-linux.de>,
        Andrew Victor <linux@maxim.org.za>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Sascha Hauer <kernel@pengutronix.de>, Olof Johansson <olof@lixom.net>,
        Colin Cross <ccross@android.com>, Barry Song <21cnbao@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 7:05 PM, Kevin Hilman
<khilman@deeprootsystems.com> wrote:

> However, in light of RT throttling, this a correctness issue for process
> accounting, so I agree that this should be done for all platforms
> instead of providing an optional 'needs suspend' version of the API,
> even though it means printk times no longer reflect time spent
> suspended.

Maybe we should get printk() to use the best clocksource
instead.

The reason AFAICT that printk() is using sched_clock() is that
it's supposed to be fast. But now it seems that it's not going
to return what printk() needs anymore.

(Dragging Stultz & Gleixner into this...)

Yours,
Linus Walleij
