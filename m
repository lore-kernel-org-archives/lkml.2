Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab0CYSol (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 14:44:41 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42754 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674Ab0CYSoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 14:44:39 -0400
Date: Thu, 25 Mar 2010 19:44:37 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
       x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
       jesse.brandeburg@intel.com, Arjan Van De Ven <arjan@infradead.org>
Subject: Re: [PATCH] Prevent nested interrupts when the IRQ stack is near overflowing v2
Message-ID: <20100325184437.GS20695@one.firstfloor.org>
References: <alpine.LFD.2.00.1003250001500.3147@localhost.localdomain> <20100325003652.GG20695@one.firstfloor.org> <alpine.LFD.2.00.1003250201370.3147@localhost.localdomain> <20100325093744.GH20695@one.firstfloor.org> <alpine.LFD.2.00.1003251133010.3147@localhost.localdomain> <alpine.LFD.2.00.1003250842240.3721@i5.linux-foundation.org> <1269539254.12097.100.camel@laptop> <alpine.LFD.2.00.1003251054030.3721@i5.linux-foundation.org> <1269541282.12097.106.camel@laptop> <1269541438.12097.107.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269541438.12097.107.camel@laptop>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 25, 2010 at 07:23:58PM +0100, Peter Zijlstra wrote:
> On Thu, 2010-03-25 at 19:21 +0100, Peter Zijlstra wrote:
> > On Thu, 2010-03-25 at 11:01 -0700, Linus Torvalds wrote:
> > > Are there any cases around 
> > > that still have busy-loop delays based on real-time in their irq handlers? 
> > > I simply don't know. 
> > 
> > I recently found a few in drivers/net/ there's all kinds of funny stuff
> > in there.. not sure how common the matching hardware is though.
> > 
> > One thing we could do is instrument jiffies to yell when its used from
> > hardirq context and fix up these things.
> 
> Also, Arjan mentioned he wanted to sweep the kernel for jiffies users
> and convert them to timer interfaces..

% linux-2.6> gid jiffies | wc -l
7569

Good luck.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
