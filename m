Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970Ab0CYQw3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 12:52:29 -0400
Received: from www.tglx.de ([62.245.132.106]:50888 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827Ab0CYQw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 12:52:28 -0400
Date: Thu, 25 Mar 2010 17:52:11 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
       LKML <linux-kernel@vger.kernel.org>, jesse.brandeburg@intel.com
Subject: Re: [PATCH] Prevent nested interrupts when the IRQ stack is near
 overflowing v2
In-Reply-To: <alpine.LFD.2.00.1003250842240.3721@i5.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1003251749260.3147@localhost.localdomain>
References: <20100324190150.GA18803@basil.fritz.box> <alpine.LFD.2.00.1003242125320.3147@localhost.localdomain> <alpine.LFD.2.00.1003250001500.3147@localhost.localdomain> <20100325003652.GG20695@one.firstfloor.org> <alpine.LFD.2.00.1003250201370.3147@localhost.localdomain>
 <20100325093744.GH20695@one.firstfloor.org> <alpine.LFD.2.00.1003251133010.3147@localhost.localdomain> <alpine.LFD.2.00.1003250842240.3721@i5.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Mar 2010, Linus Torvalds wrote:
> In particular, it's probably true that especially on modern hardware with 
> multiple cores, and especially when you do _not_ have irq sharing (which 
> is the common case these days for things like network drivers that can use 
> MSI), we really would be better off having the irq disabled over the whole 
> thing, and on some interrupt controllers it might even be worth it to do 
> the old optimization of not masking-and-acking, but just acking.
> 
> But see above. This is _not_ something that a driver can do any more. They 
> don't know whether the interrupt might end up being shared. Just blindly 
> setting IRAF_DISABLED in a driver is _not_ the answer. But being smarter 
> in the generic irq handler code might work.

For the MSI ones it definitely works as they can not be shared. I'm
just not sure whether we can just enforce that for MSI.
 
Thanks,

	tglx
