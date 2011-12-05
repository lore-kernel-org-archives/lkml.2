Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932710Ab1LERkZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 12:40:25 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:60349 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932512Ab1LERkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 12:40:23 -0500
Date: Mon, 5 Dec 2011 12:40:16 -0500 (EST)
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
In-Reply-To: <20111205161157.GA27550@localhost.localdomain>
Message-ID: <alpine.LFD.2.02.1112051236350.2357@xanadu.home>
References: <20111110162859.GA7088@oksana.dev.rtsoft.ru> <20111202192618.GC3037@localhost.localdomain> <CA+55aFwekNWz+V4440f=2iu_BfOxSg0NjVogv4cZZDFbJBNoAQ@mail.gmail.com> <1322867573.11728.22.camel@pasglop> <20111205161157.GA27550@localhost.localdomain>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Dec 2011, Dave Martin wrote:
> On Sat, Dec 03, 2011 at 10:12:53AM +1100, Benjamin Herrenschmidt wrote:
> > On Fri, 2011-12-02 at 11:28 -0800, Linus Torvalds wrote:
> > > Don't *change* NO_IRQ to zero (that whole #define is broken - leave it
> > > around as a marker of brokenness), just start removing it from all the
> > > ARM drivers that use the OF infrastructure. Which is presumably not
> > > all that many yet.
> > > 
> > > So whenever you find breakage, the fix now is to just remove NO_IRQ
> > > tests, and replace them with "!irq".
> > 
> 
> Russell, do you know whether it would make sense to set a timeline for 
> removing NO_IRQ from ARM platforms and migrating to 0 for the no-interrupt
> case?  I'm assuming that this mainly involves migrating existing hard-wired
> code that deals with interrupt numbers to use irq domains.

How many drivers do use IRQ #0 to start with?  We might discover that in 
practice there is only a very few cases where this is an issue if 0 
would mean no IRQ.


Nicolas
