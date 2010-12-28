Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab0L1RkK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 12:40:10 -0500
Received: from nm28.bullet.mail.sp2.yahoo.com ([98.139.91.98]:45449 "HELO
	nm28.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754526Ab0L1RkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 12:40:07 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 79619.5935.bm@omp1024.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=4xSl1DBBnbZ97AkI9EgT3hRMugWU6xwLHI+ZC4VO+bakgcENG633VJpqJ2hkCGytuvQZYMbfJl2HOLGG5nnb9mHKnsrRWcSh4nDBuTCwr5SXr0ejMiyaoVYCjyVTEYp+9HzgWiDw9wpbE84THcwxiCtLprP6GgKlAofsG1JMxU0=;
Message-ID: <704478.32838.qm@web180316.mail.gq1.yahoo.com>
X-YMail-OSG: 6D0h1kUVM1mxy1YxR8_zzyQjGVc1O4UBuxruT7LB7P0bCek
 3DEu5UoTP8d_faVi4_p6gB7yulnbDF5ZrzbTRySF1YBaDfSbEUhHz3rGU1h4
 NuPlAmY5qDdUxX8GaoEVYAI5Oej50.PDEdfK.iEJpckbBc0yAik64pVrN21W
 ft3DUxHGSvZ7TZ3z78UpB_nQ4zL1ua52VMzdaOnY7dnkgipggR7JRTh.msA2
 KZMduH03lY1LgzouEAY3hOXFU59xqS7hjCGcHCB.Ef.8_5Ndb4BIpuISlGBE
 kkgY_MA2G01qG1FROqfqMnS0yFua9p_M6yZFdzWtXMwKbKScTcwXh7tB8HXe
 sMhzuv3mjDAhQ_1CTlVf3_z5yBQyYggixRn0p0SNxLLmNWWeWPK28GQQSTcB
 2V.4qxHiMLEB_UXQx.4E0cA--
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.285259
Date: Tue, 28 Dec 2010 09:40:03 -0800 (PST)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [RFC/PATCH 1/2] mfd: twl6030-irq: move to threaded_irq
To: Felipe Balbi <balbi@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20101228154617.GC14860@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Tue, 12/28/10, Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> F

> You shouldn't need this any more; the driver used to be
> faffing around
> with this because it wasn't using genirq for
> this in the past.

Originally it couldn't, since genirq didn't
support threaded IRQ handling...

...

> 
> Simiarly here as far as I know; the original code predates
> genirq
> support for this so is doing some hairy stuff that is no
> longer
> required and may actually be harmful.
> 
> What I'd expect to see from a conversion like this would be
> that most of
> the locking/IRQ management stuff would be dropped

I'd expect that genirq solve all the issues and
that its support be used.  That's not the same
as dropping anything except the initial code to
handle what genirq didn't ... some locking/etc
would still mostly need doing, but where genirq
now handles it, that'd be preferable.
 and the
> bus_lock() and
> bus_sync_unlock() operations would be implemented.
h
ISTR maybe four or five genirq updates in the
area of threaded IRQ management, added so that
issues the twl4030 driver needed to be solved
could be solved in generic ways.

The first was just having threaded IRQ handlers,
and another was I think removing the initial
quick'n'dirty thread-per-irq restriction; there
was no point in having a few dozen IRQ threads
in e.g. a twl4030 driver, since two could never
do constructive work concurrently.

I'm glad to see this conversion finally start.
Even if all the threaded IRQ hooks don't get used
to best advantage, it'll be an improvement.

