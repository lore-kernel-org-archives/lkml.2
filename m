Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab1LFTLt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 14:11:49 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:57274 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab1LFTLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 14:11:47 -0500
Date: Tue, 6 Dec 2011 14:11:42 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Dave Martin <dave.martin@linaro.org>
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        devicetree-discuss@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>, linux-next@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jgarzik@redhat.com>,
        Pawel Moll <pawel.moll@arm.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ata: Don't use NO_IRQ in pata_of_platform driver
In-Reply-To: <20111206093709.GB2274@linaro.org>
Message-ID: <alpine.LFD.2.02.1112061408000.2357@xanadu.home>
References: <20111110162859.GA7088@oksana.dev.rtsoft.ru> <20111202192618.GC3037@localhost.localdomain> <CA+55aFwekNWz+V4440f=2iu_BfOxSg0NjVogv4cZZDFbJBNoAQ@mail.gmail.com> <1322867573.11728.22.camel@pasglop> <20111205161157.GA27550@localhost.localdomain>
 <alpine.LFD.2.02.1112051236350.2357@xanadu.home> <20111205180253.GB29812@localhost.localdomain> <alpine.LFD.2.02.1112051310150.2357@xanadu.home> <20111205192605.GD29812@localhost.localdomain> <alpine.LFD.2.02.1112051443190.2357@xanadu.home>
 <20111206093709.GB2274@linaro.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Dec 2011, Dave Martin wrote:

> On Mon, Dec 05, 2011 at 02:49:01PM -0500, Nicolas Pitre wrote:
> 
> > No need to convert everything.
> > 
> > First move is to make irq=0 meaning no IRQ.  That means making things 
> > like:
> > 
> > 	if (irq < 0)
> > 	if (irq >= 0)
> > 
> > into
> > 
> > 	if (irq <= 0)
> > 	if (irq > 0)
> > 
> > And replace NO_IRQ with 0.
> >
> > That change shouldn't break anything, except those drivers which are 1) 
> > being passed an actual IRQ #0 and 2) testing for no IRQ.  I suspect that 
> > those conditions aren't very common together.
> 
> To clarify, you're suggesting that the meanings of all other IRQ values
> would not change initially?

Initially, or even ever.

> (i.e., we remap HW irq 0, if there is one,
> to some other random number but have a 1:1 mapping for everything else).

Exact.

> That could make sense as an approach.

You might notice that a true IRQ #0 passed to generic drivers is not 
really frequent.


Nicolas
