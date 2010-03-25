Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab0CYSYG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 14:24:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:51660 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644Ab0CYSYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 14:24:02 -0400
Subject: Re: [PATCH] Prevent nested interrupts when the IRQ stack is near
 overflowing v2
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
       x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
       jesse.brandeburg@intel.com, Arjan Van De Ven <arjan@infradead.org>
In-Reply-To: <1269541282.12097.106.camel@laptop>
References: <20100324190150.GA18803@basil.fritz.box>
	 <alpine.LFD.2.00.1003242125320.3147@localhost.localdomain>
	 <alpine.LFD.2.00.1003250001500.3147@localhost.localdomain>
	 <20100325003652.GG20695@one.firstfloor.org>
	 <alpine.LFD.2.00.1003250201370.3147@localhost.localdomain>
	 <20100325093744.GH20695@one.firstfloor.org>
	 <alpine.LFD.2.00.1003251133010.3147@localhost.localdomain>
	 <alpine.LFD.2.00.1003250842240.3721@i5.linux-foundation.org>
	 <1269539254.12097.100.camel@laptop>
	 <alpine.LFD.2.00.1003251054030.3721@i5.linux-foundation.org>
	 <1269541282.12097.106.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Mar 2010 19:23:58 +0100
Message-ID: <1269541438.12097.107.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-25 at 19:21 +0100, Peter Zijlstra wrote:
> On Thu, 2010-03-25 at 11:01 -0700, Linus Torvalds wrote:
> > Are there any cases around 
> > that still have busy-loop delays based on real-time in their irq handlers? 
> > I simply don't know. 
> 
> I recently found a few in drivers/net/ there's all kinds of funny stuff
> in there.. not sure how common the matching hardware is though.
> 
> One thing we could do is instrument jiffies to yell when its used from
> hardirq context and fix up these things.

Also, Arjan mentioned he wanted to sweep the kernel for jiffies users
and convert them to timer interfaces..

