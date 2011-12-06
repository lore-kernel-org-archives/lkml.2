Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933354Ab1LFNZj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 08:25:39 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49460 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933233Ab1LFNZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 08:25:37 -0500
Date: Tue, 6 Dec 2011 13:25:27 +0000
From: Dave Martin <dave.martin@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Pawel Moll <pawel.moll@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        devicetree-discuss@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>, Jeff Garzik <jgarzik@redhat.com>,
        linux-ide@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
        linux-next@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] ata: Don't use NO_IRQ in pata_of_platform driver
Message-ID: <20111206132527.GA13780@linaro.org>
References: <20111205161157.GA27550@localhost.localdomain>
 <alpine.LFD.2.02.1112051236350.2357@xanadu.home>
 <20111205180253.GB29812@localhost.localdomain>
 <alpine.LFD.2.02.1112051310150.2357@xanadu.home>
 <20111205192605.GD29812@localhost.localdomain>
 <alpine.LFD.2.02.1112051443190.2357@xanadu.home>
 <20111206093709.GB2274@linaro.org>
 <20111206104654.GN14542@n2100.arm.linux.org.uk>
 <20111206113735.GC2274@linaro.org>
 <20111206114952.GS14542@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111206114952.GS14542@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 11:49:52AM +0000, Russell King - ARM Linux wrote:
> On Tue, Dec 06, 2011 at 11:37:35AM +0000, Dave Martin wrote:
> > 1) All OF code and drivers should be migrating to use 0 instead of NO_IRQ
> >    for the no-interrupt case.  Code which receives irq numbers directly
> >    from the OF framework and refers to NO_IRQ, or expects 0 to be a valid
> >    needs to be fixed.
> > 
> > 2) Where we hit a problem, board code needs to be adapted to remap HW IRQs
> >    0-15 to different software values.  (This could be done using irq
> >    domains, or not)
> 
> No AMBA driver I'm aware of ever uses an IRQ number 0 or is passed such
> an IRQ number.

OK, hopefully we can safely ignore that case, then.

But other than that, you're in agreement?

Cheers
---Dave
