Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab0CYUpu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 16:45:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48990 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752594Ab0CYUps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 16:45:48 -0400
Date: Thu, 25 Mar 2010 13:40:43 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>
cc: mingo@elte.hu, peterz@infradead.org, tglx@linutronix.de,
       andi@firstfloor.org, x86@kernel.org, linux-kernel@vger.kernel.org,
       jesse.brandeburg@intel.com
Subject: Re: [PATCH] Prevent nested interrupts when the IRQ stack is near
 overflowing v2
In-Reply-To: <20100325.124220.258885098.davem@davemloft.net>
Message-ID: <alpine.LFD.2.00.1003251339470.3721@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1003251054030.3721@i5.linux-foundation.org> <20100325182930.GA7709@elte.hu> <alpine.LFD.2.00.1003251206550.3721@i5.linux-foundation.org> <20100325.124220.258885098.davem@davemloft.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 25 Mar 2010, David Miller wrote:
> 
> FWIW, I'm currently using IRQF_DISABLED for virtual network
> device interrupts on sparc64 as a workaround for some stack
> overflow issues.
> 
> This change will just force me to work harder to find out a better way
> to fix the problem, so don't let my issue hold this back, it's just
> an FYI...

You missed the point of the patch.

It makes _all_ interrupts act like IRQF_DISABLED. So it actually fixes 
your issue, by making IRQF_DISABLE a no-op - not because it doesn't exist 
any more, but because the non-IRQF_DISABLED case would not exist any more.

		Linus
