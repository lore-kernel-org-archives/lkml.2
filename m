Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277Ab1LESoZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 13:44:25 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47508 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754650Ab1LESoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 13:44:24 -0500
Date: Mon, 5 Dec 2011 18:45:22 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Dave Martin <dave.martin@linaro.org>,
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
Subject: Re: [PATCH] ata: Don't use NO_IRQ in pata_of_platform driver
Message-ID: <20111205184522.316598de@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.02.1112051310150.2357@xanadu.home>
References: <20111110162859.GA7088@oksana.dev.rtsoft.ru>
	<20111202192618.GC3037@localhost.localdomain>
	<CA+55aFwekNWz+V4440f=2iu_BfOxSg0NjVogv4cZZDFbJBNoAQ@mail.gmail.com>
	<1322867573.11728.22.camel@pasglop>
	<20111205161157.GA27550@localhost.localdomain>
	<alpine.LFD.2.02.1112051236350.2357@xanadu.home>
	<20111205180253.GB29812@localhost.localdomain>
	<alpine.LFD.2.02.1112051310150.2357@xanadu.home>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But as you illustrated, there is a large number of drivers that already 
> assume no IRQ is < 0, even if they don't use any IRQ #0 themselves.  
> That is a much bigger problem to fix.

And a much larger number assuming the reverse is true which are hiding
potential bugs on ARM.

Looking at the serial stuff the best checks appear to be looking at
"irq", "-1" and NO_IRQ.

For migration stuff that's doing broken things like

	if (irq < 0)

can be changed to

	if (irq <= 0)

and that can be done before NO_IRQ itself is nailed on ARM and PA-RISC.
