Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311Ab0CZGKe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 02:10:34 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48842 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874Ab0CZGKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 02:10:33 -0400
Date: Fri, 26 Mar 2010 07:10:29 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
       x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
       jesse.brandeburg@intel.com
Subject: Re: [PATCH] Prevent nested interrupts when the IRQ stack is near overflowing v2
Message-ID: <20100326061029.GU20695@one.firstfloor.org>
References: <20100324190150.GA18803@basil.fritz.box> <alpine.LFD.2.00.1003242125320.3147@localhost.localdomain> <alpine.LFD.2.00.1003250001500.3147@localhost.localdomain> <20100325003652.GG20695@one.firstfloor.org> <alpine.LFD.2.00.1003250201370.3147@localhost.localdomain> <20100325093744.GH20695@one.firstfloor.org> <alpine.LFD.2.00.1003251133010.3147@localhost.localdomain> <alpine.LFD.2.00.1003250842240.3721@i5.linux-foundation.org> <1269539254.12097.100.camel@laptop> <alpine.LFD.2.00.1003251054030.3721@i5.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003251054030.3721@i5.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Now, I think (and sincerely) that the SCSI situation is likely long since 
> fixed, but we have thousands and thousands of drivers, and these kinds of 
> things are very hard to notice automatically. Are there any cases around 
> that still have busy-loop delays based on real-time in their irq handlers? 
> I simply don't know.

This case was already broken back when the x86-64 port used to run
with NMI watchdog on by default, because any IO exception handling
with interrupts off would trigger the NMI watchdog eventually.

I remember having to add bandaids to Fusion for this a long time ago.

Of course ISA drivers might still do it.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
