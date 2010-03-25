Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912Ab0CYU6W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 16:58:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51730 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754890Ab0CYU6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 16:58:20 -0400
Date: Thu, 25 Mar 2010 13:53:25 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
       x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
       jesse.brandeburg@intel.com
Subject: Re: [PATCH] Prevent nested interrupts when the IRQ stack is near
 overflowing v2
In-Reply-To: <alpine.LFD.2.00.1003251206550.3721@i5.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1003251349500.3721@i5.linux-foundation.org>
References: <20100324190150.GA18803@basil.fritz.box> <alpine.LFD.2.00.1003242125320.3147@localhost.localdomain> <alpine.LFD.2.00.1003250001500.3147@localhost.localdomain> <20100325003652.GG20695@one.firstfloor.org> <alpine.LFD.2.00.1003250201370.3147@localhost.localdomain>
 <20100325093744.GH20695@one.firstfloor.org> <alpine.LFD.2.00.1003251133010.3147@localhost.localdomain> <alpine.LFD.2.00.1003250842240.3721@i5.linux-foundation.org> <1269539254.12097.100.camel@laptop> <alpine.LFD.2.00.1003251054030.3721@i5.linux-foundation.org>
 <20100325182930.GA7709@elte.hu> <alpine.LFD.2.00.1003251206550.3721@i5.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 25 Mar 2010, Linus Torvalds wrote:
> 
> And I just checked: even the 8250 serial driver doesn't use IRQF_DISABLED 
> any more, so doing that shouldn't cause any latency issues (sure, the 
> serial driver may interrupt another irq, but another irq can also 
> interrupt the serial driver as things stand now, so the original latency 
> issue with fast irq handlers doesn't actually work these days _anyway_).

Btw, if we really do decide that everybody is IRQF_DISABLED, that really 
should make the whole mask-and-ack issue for the irq controllers go away.

We'd still need it, but only for the very special IDE controller case and 
others who _explicitly_ re-enable interrupts. Those would really have to 
cause the irq to be masked so that we don't get issues with recursive irqs 
of the same kind.

		Linus
