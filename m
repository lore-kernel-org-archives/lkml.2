Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015Ab0CYPiK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 11:38:10 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50050 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754875Ab0CYPiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 11:38:09 -0400
Date: Thu, 25 Mar 2010 16:38:05 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
       LKML <linux-kernel@vger.kernel.org>, jesse.brandeburg@intel.com,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Prevent nested interrupts when the IRQ stack is near overflowing v2
Message-ID: <20100325153805.GQ20695@one.firstfloor.org>
References: <alpine.LFD.2.00.1003242125320.3147@localhost.localdomain> <alpine.LFD.2.00.1003250001500.3147@localhost.localdomain> <20100325003652.GG20695@one.firstfloor.org> <alpine.LFD.2.00.1003250201370.3147@localhost.localdomain> <20100325093744.GH20695@one.firstfloor.org> <alpine.LFD.2.00.1003251133010.3147@localhost.localdomain> <20100325121141.GO20695@one.firstfloor.org> <alpine.LFD.2.00.1003251338130.3147@localhost.localdomain> <20100325133204.GP20695@one.firstfloor.org> <alpine.LFD.2.00.1003251441420.3147@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003251441420.3147@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Well it's simply the current state of affairs today. I'm merely
> > attempting to make the current state slightly safer without breaking
> > anything in the process.
> 
> Well, I'd agree if those stack overflows would be a massive reported
> problem. 

At least the people who reported it to me thought it was a massive
problem @)

> Right now they happen with a weird test case which points out a
> trouble spot. Multi vector NICs under heavy load. So why not go there
> and change the handful of drivers to run their handlers with irqs
> disabled?

Ok, but afaik it's not that small a number: MSI-X support is getting
more and more wide spread. It's pretty universal in the 10+GbitE space
for space and starts getting deployed for block too.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
