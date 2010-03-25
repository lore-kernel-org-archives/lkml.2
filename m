Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709Ab0CYMAX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 08:00:23 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39258 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab0CYMAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 08:00:22 -0400
Date: Thu, 25 Mar 2010 13:00:21 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Andi Kleen <andi@firstfloor.org>,
       x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
       jesse.brandeburg@intel.com,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Prevent nested interrupts when the IRQ stack is near overflowing v2
Message-ID: <20100325120021.GN20695@one.firstfloor.org>
References: <20100324190150.GA18803@basil.fritz.box> <alpine.LFD.2.00.1003242125320.3147@localhost.localdomain> <alpine.LFD.2.00.1003250001500.3147@localhost.localdomain> <20100325003652.GG20695@one.firstfloor.org> <alpine.LFD.2.00.1003250201370.3147@localhost.localdomain> <20100325105033.35bceffd@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.1003251211350.3147@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003251211350.3147@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 25, 2010 at 12:16:17PM +0100, Thomas Gleixner wrote:
> > Pretty much the only 'core' driver today which enables IRQs in the irq
> > handlers and needs it is the old IDE layer. There are also a couple of
> > drivers which play games with disable/enable_irq in the IRQ paths for
> > other reasons (lack of irq threads when written and a hardware model thats
> > totally SMP unfriendly). 8390 is the obvious one here and it at least
> > would be far far saner using threaded IRQs and normal locking with IRQs
> > unmasked.
> 
> Right, but that's not the problem here. We talk about a (hopefully)
> well written interrupt handler which runs for a very short
> time. 

The NIC handlers can do quite some work under high traffic.
Even with interrupt mitigation and NAPI.

> What's the point of running it with interrupts enabled ?

Other interrupts.

> Nothing, we just run into stack overflow problems. So what's better:
> an unreliable and ugly hackaround

I don't think that's a accurate description of the patch at all.
Besides I believe it's reliable in all cases that matter.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
