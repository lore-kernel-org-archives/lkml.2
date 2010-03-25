Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab0CYSHf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 14:07:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39751 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753860Ab0CYSHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 14:07:33 -0400
Date: Thu, 25 Mar 2010 11:01:51 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
cc: Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
       x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
       jesse.brandeburg@intel.com
Subject: Re: [PATCH] Prevent nested interrupts when the IRQ stack is near
 overflowing v2
In-Reply-To: <1269539254.12097.100.camel@laptop>
Message-ID: <alpine.LFD.2.00.1003251054030.3721@i5.linux-foundation.org>
References: <20100324190150.GA18803@basil.fritz.box>  <alpine.LFD.2.00.1003242125320.3147@localhost.localdomain>  <alpine.LFD.2.00.1003250001500.3147@localhost.localdomain>  <20100325003652.GG20695@one.firstfloor.org>  <alpine.LFD.2.00.1003250201370.3147@localhost.localdomain>
  <20100325093744.GH20695@one.firstfloor.org>  <alpine.LFD.2.00.1003251133010.3147@localhost.localdomain>  <alpine.LFD.2.00.1003250842240.3721@i5.linux-foundation.org> <1269539254.12097.100.camel@laptop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 25 Mar 2010, Peter Zijlstra wrote:
> 
> FWIW lockdep forces IRQF_DISABLED and yells when anybody does
> local_irq_enable() while in hardirq context, I haven't seen any such
> splats in a long while, except from the ARM people who did funny things
> with building their own threaded interrupts or somesuch.

The thing is, that won't show the drivers that just simply _expect_ 
other interrupts to happen.

The SCSI situation, iirc, used to be that certain error conditions simply 
caused a delay loop (reset? I forget) that depended on 'jiffies'. So there 
was no 'local_irq_enable()' involved, nor did it even happen under any 
normal load - only in error situations.

Now, I think (and sincerely) that the SCSI situation is likely long since 
fixed, but we have thousands and thousands of drivers, and these kinds of 
things are very hard to notice automatically. Are there any cases around 
that still have busy-loop delays based on real-time in their irq handlers? 
I simply don't know.

			Linus
