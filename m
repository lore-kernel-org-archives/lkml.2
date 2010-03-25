Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab0CYQWR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 12:22:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35371 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752588Ab0CYQWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 12:22:15 -0400
Date: Thu, 25 Mar 2010 09:17:13 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
       LKML <linux-kernel@vger.kernel.org>, jesse.brandeburg@intel.com
Subject: Re: [PATCH] Prevent nested interrupts when the IRQ stack is near
 overflowing v2
In-Reply-To: <alpine.LFD.2.00.1003250842240.3721@i5.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1003250915410.3721@i5.linux-foundation.org>
References: <20100324190150.GA18803@basil.fritz.box> <alpine.LFD.2.00.1003242125320.3147@localhost.localdomain> <alpine.LFD.2.00.1003250001500.3147@localhost.localdomain> <20100325003652.GG20695@one.firstfloor.org> <alpine.LFD.2.00.1003250201370.3147@localhost.localdomain>
 <20100325093744.GH20695@one.firstfloor.org> <alpine.LFD.2.00.1003251133010.3147@localhost.localdomain> <alpine.LFD.2.00.1003250842240.3721@i5.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 25 Mar 2010, Linus Torvalds wrote:
> 
> NOTE! Historically, the "fast" handlers also had a much faster irq 
> response because they didn't do that whole MASK/ACK/END thing. So they'd 
> just keep the CPU interrupts disabled, and ACK at the end, and I think 
> we've even used AUTOEIO so that they didn't need any ACK at all, and we 
> never touched the interrupt controller itself for them.

Btw, it was even more extreme than that. The fast irq handlers got a 
totally separate kernel entry point, and wouldn't save all registers, only 
the compiler-clobbered ones. Which is why they then had no "struct 
pt_regs" etc.

And yes, it really mattered. Then later we got so bloated that it wasn't 
much of an issue - and just made everything more complicated.

		Linus
