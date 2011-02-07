Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962Ab1BGVeB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 16:34:01 -0500
Received: from www.tglx.de ([62.245.132.106]:54711 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754917Ab1BGVd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 16:33:58 -0500
Date: Mon, 7 Feb 2011 22:33:50 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: LKML <linux-kernel@vger.kernel.org>,
        Ian Campbell <Ian.Campbell@citrix.com>
Subject: Re: [patch 0/4] XEN: Interrupt cleanups
In-Reply-To: <4D50641B.2090006@goop.org>
Message-ID: <alpine.LFD.2.00.1102072231220.31804@localhost6.localdomain6>
References: <20110205200108.921707839@linutronix.de> <4D50641B.2090006@goop.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy,

On Mon, 7 Feb 2011, Jeremy Fitzhardinge wrote:
> On 02/05/2011 12:08 PM, Thomas Gleixner wrote:
> > the following series converts the interrupt chips of XEN to the new
> > chip functions and the last patches replace the xen private resume
> > hackery.
> >
> > The first two patches have no dependencies.
> >
> > The last two need the modification to the generic interrupt layer. I
> > could either carry them through the genirq tree with your
> > acked-tested-whatever-by or I provide you a branch to pull that change
> > from. I need the genirq change local as it conflicts with other patches
> > in the pipeline. Either way works fine.
> 
> Hi Thomas,
> 
> Thanks very much for looking at this.  IanC also has some patches to
> clean up the Xen interrupt stuff to get rid of the local hacks, so I'll
> let him work out how to reconcile the two sets of work (ah, I see he's
> already replied).
> 
> [Read patches]
> 
> It doesn't look like there's any functional overlap at all, since his
> patches are concerned with using the core irq allocator rather than a
> private one, so that's OK.
> 
> Anyway, I'll let Ian do the ack.

Ok. The irq_chip conversion is mostly mechanical, but I'm really
concerned about that IRQ_SUSPENDED hackery. It'd be nice if you
resp. Ian could give that a test ride. That would allow me to cleanup
stuff in the core code.

Thanks,

	tglx
