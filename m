Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858Ab1LBXN6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 18:13:58 -0500
Received: from gate.crashing.org ([63.228.1.57]:33248 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884Ab1LBXNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 18:13:55 -0500
Message-ID: <1322867573.11728.22.camel@pasglop>
Subject: Re: [PATCH] ata: Don't use NO_IRQ in pata_of_platform driver
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Martin <dave.martin@linaro.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        devicetree-discuss@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>, linux-next@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jgarzik@redhat.com>,
        Pawel Moll <pawel.moll@arm.com>, linux-arm-kernel@lists.infradead.org
Date: Sat, 03 Dec 2011 10:12:53 +1100
In-Reply-To: <CA+55aFwekNWz+V4440f=2iu_BfOxSg0NjVogv4cZZDFbJBNoAQ@mail.gmail.com>
References: <20111110162859.GA7088@oksana.dev.rtsoft.ru>
	 <20111202192618.GC3037@localhost.localdomain>
	 <CA+55aFwekNWz+V4440f=2iu_BfOxSg0NjVogv4cZZDFbJBNoAQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-02 at 11:28 -0800, Linus Torvalds wrote:
> On Fri, Dec 2, 2011 at 11:26 AM, Dave Martin <dave.martin@linaro.org> wrote:
> >
> > This is now broken on ARM where, for good or bad, NO_IRQ currently is
> > used and is -1.
> >
> > How do we resolve it?  If we are ready to eliminate NO_IRQ from
> > drivers/of/irq.c (or indeed, all code that uses it) and just use 0 for
> > that case, we should surely just do it... but I'm not confident I can
> > judge on that.
> 
> Just stop using NO_IRQ. First in drivers/of/irq.c, then in any drivers
> as you notice breakage.

Agreed. In fact the whole hack in drivers/of/irq.c was to accomodate ARM
which still uses -1, powerpc changed to 0 a long time ago.

Now that we have a generic remapper between HW and "linux" IRQ numbers,
there is no reason to stick to -1 even on ARM.

> Don't *change* NO_IRQ to zero (that whole #define is broken - leave it
> around as a marker of brokenness), just start removing it from all the
> ARM drivers that use the OF infrastructure. Which is presumably not
> all that many yet.
> 
> So whenever you find breakage, the fix now is to just remove NO_IRQ
> tests, and replace them with "!irq".

Cheers,
Ben.


