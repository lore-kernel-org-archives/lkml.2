Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307Ab1LFVAt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 16:00:49 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50604 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457Ab1LFVAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 16:00:48 -0500
Date: Tue, 6 Dec 2011 21:59:55 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Dave Martin <dave.martin@linaro.org>, Pawel Moll <pawel.moll@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        devicetree-discuss@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>, Jeff Garzik <jgarzik@redhat.com>,
        linux-ide@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
        linux-next@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] ata: Don't use NO_IRQ in pata_of_platform driver
Message-ID: <20111206205955.GH4585@pengutronix.de>
References: <1322867573.11728.22.camel@pasglop>
 <20111205161157.GA27550@localhost.localdomain>
 <alpine.LFD.2.02.1112051236350.2357@xanadu.home>
 <20111205180253.GB29812@localhost.localdomain>
 <alpine.LFD.2.02.1112051310150.2357@xanadu.home>
 <20111205192605.GD29812@localhost.localdomain>
 <alpine.LFD.2.02.1112051443190.2357@xanadu.home>
 <20111206093709.GB2274@linaro.org>
 <20111206104654.GN14542@n2100.arm.linux.org.uk>
 <CA+55aFwZBr+3_S9kU-+m8zN8iwOvn2miuuAy-zt7sUjW_+abBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFwZBr+3_S9kU-+m8zN8iwOvn2miuuAy-zt7sUjW_+abBg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

On Tue, Dec 06, 2011 at 11:20:49AM -0800, Linus Torvalds wrote:
> On Tue, Dec 6, 2011 at 2:46 AM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> >
> > But.. let's make one thing clear: Alan Cox and Linus have been going on
> > about how IRQ0 should not be used.  Let's be crystal clear: even x86
> > uses IRQ0.
> 
> Not for any device driver, though.
> 
> It's used entirely internally, and it doesn't even use
> "request_irq()". It uses the magic internal "setup_irq()" and never
> *ever* exposes irq0 as anything that a driver can see.
> 
> That's what matters. You can use irq0 in ARM land all you like, AS
> LONG AS IT'S SOME HIDDEN INTERNAL USE. No drivers. No *nothing* that
> ever uses that absolutely *idiotic* NO_IRQ crap.
> 
> In fact, you may be *forced* to use what is "physically" irq0 - it's
> just that you should never expose it as such to drivers. And x86
> doesn't.
> 
> So Russell, if you think this has anything to do with NO_IRQ, and how
> x86 isn't doing things right, you're wrong. It's just like the
> internal exception thing, or the magical "cascade interrupt", or the
> "x87 exception mapped through the PIC". They are magic hidden
> interrupts that are set up in one place (well, one place *each*), and
> are never exposed anywhere else.
Well there is try_misrouted_irq in kernel/irq/spurious.c that assumes
irq0 to be something that it never is on ARM (and maybe all other
platforms apart from x86). So at least it's not internal to a single
(x86 specific) place.

I tried to patch that two years ago, but that only ended in people
saying "don't use irq0". I don't know if try_misrouted_irq sees hardware
irqs, but if it does it's a bug even on archs != X86 that use virtual
irqs.

(Note that this doesn't oppose to your statement that using NO_IRQ is
crap.)

> The problem with NO_IRQ is that stupid "we expose our mind-numbingly
> stupid interfaces across the whole kernel".
> 
> x86 never did that.  ARM still does. x86 doesn't have to fix anything. ARM does.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
