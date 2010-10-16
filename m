Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597Ab0JPChK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 22:37:10 -0400
Received: from gate.crashing.org ([63.228.1.57]:45808 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752352Ab0JPChI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 22:37:08 -0400
Subject: Re: [PATCH] ARM: allow, but warn, when issuing ioremap() on RAM
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
        Arnd Hannemann <arnd@arndnet.de>, Hemant Pedanekar <hemantp@ti.com>,
        Greg KH <greg@kroah.com>, linux-main <linux-kernel@vger.kernel.org>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Han Jonghun <jonghun79.han@gmail.com>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <20101008175308.GA10975@n2100.arm.linux.org.uk>
References: <1286444662-16843-1-git-send-email-felipe.contreras@gmail.com>
	 <20101007192245.GC26435@n2100.arm.linux.org.uk>
	 <AANLkTikQKY7pOobD+==uT5Cy0poT=O5wDMKtbVyJVNbO@mail.gmail.com>
	 <20101008175308.GA10975@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 16 Oct 2010 13:36:28 +1100
Message-ID: <1287196588.2370.1.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-08 at 18:53 +0100, Russell King - ARM Linux wrote:
> As already discussed, it's nigh on impossible to unmap the existing
> direct mapped region (read the previous discussions about why this is)
> - which is precisely why there is no direct alternative solution.
> 
> The only possible solution is to exclude some memory at boot time from
> the system direct map so that it never appears in the direct map, and
> use ioremap on _that_.  Another possible alternative is to use
> highmem,
> obtain highmem pages (making sure that it doesn't fall back to lowmem)
> and remap them using interfaces such as vmap.
> 
> So there are solutions to the problem, but it seems that _no one_ is
> willing to discuss it other than "we want our old way back".
> 
> If you want the old way back, apply pressure to silicon vendors and
> ARM Ltd to change the architecture to lift this restriction - which
> will probably mean doing away with aggressive speculative prefetching
> so that it's possible to predict what will be in the cache at any
> point in time. 

Note that we have the exact same problem on powerpc. The only sane
solution is that SoCs designed around such cores or versions of the
architecture should be fully DMA coherent to avoid the need for funky
mapping attributes. Anything else is garbage HW, but sadly, it looks
like way too many idiots still find jobs as HW designers.

Cheers,
Ben.


