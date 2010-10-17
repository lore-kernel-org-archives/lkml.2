Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751774Ab0JQXTM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 19:19:12 -0400
Received: from gate.crashing.org ([63.228.1.57]:56361 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217Ab0JQXTL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 19:19:11 -0400
Subject: RE: [PATCH] ARM: allow, but warn, when issuing ioremap() on RAM
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Woodruff, Richard" <r-woodruff2@ti.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Hannemann <arnd@arndnet.de>, "Pedanekar, Hemant" <hemantp@ti.com>,
        Greg KH <greg@kroah.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        linux-main <linux-kernel@vger.kernel.org>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Han Jonghun <jonghun79.han@gmail.com>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <13B9B4C6EF24D648824FF11BE896716203D76F71F4@dlee02.ent.ti.com>
References: <1286444662-16843-1-git-send-email-felipe.contreras@gmail.com>
	 <20101007192245.GC26435@n2100.arm.linux.org.uk>
	 <AANLkTikQKY7pOobD+==uT5Cy0poT=O5wDMKtbVyJVNbO@mail.gmail.com>
	 <20101008175308.GA10975@n2100.arm.linux.org.uk>
	 <1287196588.2370.1.camel@pasglop>
	 <13B9B4C6EF24D648824FF11BE896716203D76F71F4@dlee02.ent.ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Oct 2010 10:17:01 +1100
Message-ID: <1287357421.2370.19.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-10-17 at 08:05 -0500, Woodruff, Richard wrote:
> ARM has always been a rawer (and cheaper) environment than many other
> CPU architectures. Until maybe this year coherency was never even an
> option provided in the hardware. The vast majority of the systems
> currently in mass production in 2010 and before don't have coherency.
> The software has to handle all the details.
> 
> Starting today and onwards coherency options will start to be seen in
> high end. It seems likely some of the old external IP won't be
> compliant and likely have bugs undercutting it.
> 
> People from high ends like x86 and PPC have different expectations and
> problems. Your chip set nightmares are our standard in some areas. In
> my narrow experience PPC pioneered many techniques 15 years back which
> are now just coming into ARM. They are coming in at a much reduced
> power and cost footprint. 

This is all quite possible the the fact remains that at the end of the
day, if you're going to have a speculative memory model with prefetch
and your architecture (rightfully so) disallows aliasing of mappings
with different cache attributes, then you are screwed the minute your
devices do non-coherent DMA :-)

As Russell says, the only proper way to do that would be to set aside
memory at boot. That or provide a way to take chunks out of the linear
mapping, which may or may not be possible, I don't know how ARM does it
well enough. On some 32-bit powerpc's unfortunately, that would meant
taking whole 256M chunks out due to the way we implement it.

The main problem is usually related to the linear mapping using some
form of huge pages, I suppose this is the same for you here.

Now of course, you always have the un-satisfactory options of disabling
speculation/prefetch and/or disabling the use of such huge pages in the
linear mapping, which makes unmapping chunks of it a lot easier.

Cheers,
Ben.


