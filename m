Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912Ab0CYS1K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 14:27:10 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54164 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315Ab0CYS1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 14:27:08 -0400
Date: Thu, 25 Mar 2010 19:27:02 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
       x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
       jesse.brandeburg@intel.com
Subject: Re: [PATCH] Prevent nested interrupts when the IRQ stack is near overflowing v2
Message-ID: <20100325182702.GR20695@one.firstfloor.org>
References: <20100324190150.GA18803@basil.fritz.box> <alpine.LFD.2.00.1003242125320.3147@localhost.localdomain> <alpine.LFD.2.00.1003250001500.3147@localhost.localdomain> <20100325003652.GG20695@one.firstfloor.org> <alpine.LFD.2.00.1003250201370.3147@localhost.localdomain> <20100325093744.GH20695@one.firstfloor.org> <alpine.LFD.2.00.1003251133010.3147@localhost.localdomain> <alpine.LFD.2.00.1003250842240.3721@i5.linux-foundation.org> <20100325162737.GA5276@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100325162737.GA5276@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think the patch as posted solves a real problem, but also perpetuates a bad 
> situation.
> 
> At minimum we should print a (one-time) warning that some badness occured. 
> That would push us either in the direction of improving drivers, or towards 
> improving the generic code.

What should a driver do to prevent that? I don't see what it could do
short of castrating itself (like refusing to use multiple ports)
As Linus says the driver doesn't know if setting IRQF_DISABLED is safe.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
