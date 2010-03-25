Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab0CYRro (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 13:47:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:57155 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488Ab0CYRrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 13:47:43 -0400
Subject: Re: [PATCH] Prevent nested interrupts when the IRQ stack is near
 overflowing v2
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
       x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
       jesse.brandeburg@intel.com
In-Reply-To: <alpine.LFD.2.00.1003250842240.3721@i5.linux-foundation.org>
References: <20100324190150.GA18803@basil.fritz.box>
	 <alpine.LFD.2.00.1003242125320.3147@localhost.localdomain>
	 <alpine.LFD.2.00.1003250001500.3147@localhost.localdomain>
	 <20100325003652.GG20695@one.firstfloor.org>
	 <alpine.LFD.2.00.1003250201370.3147@localhost.localdomain>
	 <20100325093744.GH20695@one.firstfloor.org>
	 <alpine.LFD.2.00.1003251133010.3147@localhost.localdomain>
	 <alpine.LFD.2.00.1003250842240.3721@i5.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Mar 2010 18:47:34 +0100
Message-ID: <1269539254.12097.100.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-25 at 09:13 -0700, Linus Torvalds wrote:
> But see above. This is _not_ something that a driver can do any more. They 
> don't know whether the interrupt might end up being shared. Just blindly 
> setting IRAF_DISABLED in a driver is _not_ the answer. But being smarter 
> in the generic irq handler code might work.
> 
> And then, what we could do, is to mark the drivers that absolutely _must_ 
> be able to nest specially. Like the IDE driver when in PIO mode. Or maybe 
> the SCSI drivers, if they still depend on that timer interrupt happening 
> while they are busy. 

FWIW lockdep forces IRQF_DISABLED and yells when anybody does
local_irq_enable() while in hardirq context, I haven't seen any such
splats in a long while, except from the ARM people who did funny things
with building their own threaded interrupts or somesuch.

So I'm sure there's some devices, like IDE PIO and the curious 8390, and
maybe some other drivers that aren't as common, but I don't think the
situation is quite as bad as some people paint it.



