Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932422Ab1LETTV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 14:19:21 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:52112 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932335Ab1LETTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 14:19:18 -0500
Subject: Re: [PATCH] ata: Don't use NO_IRQ in pata_of_platform driver
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Dave Martin <dave.martin@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        devicetree-discuss@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>, linux-next@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jgarzik@redhat.com>,
        Pawel Moll <pawel.moll@arm.com>, linux-arm-kernel@lists.infradead.org
In-Reply-To: <20111205184522.316598de@lxorguk.ukuu.org.uk>
References: <20111110162859.GA7088@oksana.dev.rtsoft.ru>
	 <20111202192618.GC3037@localhost.localdomain>
	 <CA+55aFwekNWz+V4440f=2iu_BfOxSg0NjVogv4cZZDFbJBNoAQ@mail.gmail.com>
	 <1322867573.11728.22.camel@pasglop>
	 <20111205161157.GA27550@localhost.localdomain>
	 <alpine.LFD.2.02.1112051236350.2357@xanadu.home>
	 <20111205180253.GB29812@localhost.localdomain>
	 <alpine.LFD.2.02.1112051310150.2357@xanadu.home>
	 <20111205184522.316598de@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Dec 2011 13:19:14 -0600
Message-ID: <1323112754.7213.49.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-05 at 18:45 +0000, Alan Cox wrote:
> > But as you illustrated, there is a large number of drivers that already 
> > assume no IRQ is < 0, even if they don't use any IRQ #0 themselves.  
> > That is a much bigger problem to fix.
> 
> And a much larger number assuming the reverse is true which are hiding
> potential bugs on ARM.
> 
> Looking at the serial stuff the best checks appear to be looking at
> "irq", "-1" and NO_IRQ.
> 
> For migration stuff that's doing broken things like
> 
> 	if (irq < 0)
> 
> can be changed to
> 
> 	if (irq <= 0)
> 
> and that can be done before NO_IRQ itself is nailed on ARM and PA-RISC.

To be honest, we don't care very much.  Parisc interrupts are cascading
and mostly software assigned (except our EIEM which we keep internal).
We use a base offset at 16 or 64 (depending on GSC presence or not) so
IRQs 0-15 aren't legal on parisc either (we frob some of the hard coded
ISA interrupts on the WAX eisa bus).

We use NO_IRQ as an IRQ assignment error return and that's about it (and
that error shouldn't ever really occur).

James


