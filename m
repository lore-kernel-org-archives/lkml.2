Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597Ab0L1Roy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 12:44:54 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35404 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754343Ab0L1Row (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 12:44:52 -0500
Date: Tue, 28 Dec 2010 17:45:03 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Brownell <david-b@pacbell.net>
Cc: Felipe Balbi <balbi@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC/PATCH 1/2] mfd: twl6030-irq: move to threaded_irq
Message-ID: <20101228174503.GB3089@opensource.wolfsonmicro.com>
References: <20101228154617.GC14860@sirena.org.uk>
 <704478.32838.qm@web180316.mail.gq1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <704478.32838.qm@web180316.mail.gq1.yahoo.com>
X-Cookie: You will have a long and boring life.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 28, 2010 at 09:40:03AM -0800, David Brownell wrote:

> > What I'd expect to see from a conversion like this would be
> > that most of
> > the locking/IRQ management stuff would be dropped

> I'd expect that genirq solve all the issues and
> that its support be used.  That's not the same
> as dropping anything except the initial code to
> handle what genirq didn't ... some locking/etc
> would still mostly need doing, but where genirq
> now handles it, that'd be preferable.

It should solve everything - there's rather a lot of I2C/SPI connected
MFDs using genirq fully now without any hassle, the APIs are really
straightforward and easy to use.

>  and the
> > bus_lock() and
> > bus_sync_unlock() operations would be implemented.

> ISTR maybe four or five genirq updates in the
> area of threaded IRQ management, added so that
> issues the twl4030 driver needed to be solved
> could be solved in generic ways.

Yup - the main one on top of threaded IRQs was the bus_lock() and
bus_sync_unlock() methods.

> The first was just having threaded IRQ handlers,
> and another was I think removing the initial
> quick'n'dirty thread-per-irq restriction; there
> was no point in having a few dozen IRQ threads
> in e.g. a twl4030 driver, since two could never
> do constructive work concurrently.

The thread per IRQ thing is dealt with too, the secondary IRQs share the
thread used for demux.
