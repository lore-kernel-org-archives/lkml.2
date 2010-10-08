Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab0JHXTr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 19:19:47 -0400
Received: from kroah.org ([198.145.64.141]:54639 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751452Ab0JHXTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 19:19:46 -0400
Date: Fri, 8 Oct 2010 16:19:26 -0700
From: Greg KH <greg@kroah.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
        linux-main <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Arnd Hannemann <arnd@arndnet.de>,
        Han Jonghun <jonghun79.han@gmail.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Hemant Pedanekar <hemantp@ti.com>
Subject: Re: [PATCH] ARM: allow, but warn, when issuing ioremap() on RAM
Message-ID: <20101008231926.GA28235@kroah.com>
References: <1286444662-16843-1-git-send-email-felipe.contreras@gmail.com>
 <20101007192245.GC26435@n2100.arm.linux.org.uk>
 <AANLkTikQKY7pOobD+==uT5Cy0poT=O5wDMKtbVyJVNbO@mail.gmail.com>
 <20101008175308.GA10975@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101008175308.GA10975@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 06:53:08PM +0100, Russell King - ARM Linux wrote:
> On Fri, Oct 08, 2010 at 12:32:35PM +0300, Felipe Contreras wrote:
> > I think when _you_ remove functionality from the architecture, you
> > should provide a mechanism that drivers can migrate to. Since there's
> > nothing like that, not even a guideline, you are breaking the drivers
> > willingly, and expecting other people to fix a difficult problem that
> > you yourself have no idea how to fix properly.
> 
> We can either wait for people to complain about silent data corruption
> or we can be compliant with the architecture specification.  Which is
> better - to avoid data corruption and be correct, or allow a system to
> become flakey and corrupt people's data.
> 
> What I care about is system correctness and people's data - having
> multiple mappings with different attributes is documented in very clear
> terms as being 'unpredictable' and therefore it isn't permissible to
> allow the practice that worked with previous processors (inherently
> due to their cache architecture) to continue forward onto processors
> with a different cache architecture.
> 
> As already discussed, it's nigh on impossible to unmap the existing
> direct mapped region (read the previous discussions about why this is)
> - which is precisely why there is no direct alternative solution.

Wait, let me get this straight:
  - drivers used to work on 2.6.35
  - some ARM core code changed in .36-rc to fix this iomem problem that
    you found
  - no drivers are notified of the api change as it's a run-time change,
    so the build doesn't break.
  - drivers break when run as the api stops returning valid addresses
  - no known way is around to fix the broken drivers

Um, this doesn't sound like a valid thing to be doing, how do you expect
people to fix their code if they:
	- don't realize it as the api change doesn't break the build
	- there is no way to fix their code

This sounds like a huge regression that should be reverted, or am I
missing something here?

confused,

greg k-h
