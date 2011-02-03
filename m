Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016Ab1BCCPP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 21:15:15 -0500
Received: from one.firstfloor.org ([213.235.205.2]:50553 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579Ab1BCCPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 21:15:11 -0500
Date: Thu, 3 Feb 2011 03:15:10 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>
Subject: Re: [patch] x86, mm: avoid stale tlb entries by clearing prev mm_cpumask after switching mm
Message-ID: <20110203021510.GM15569@one.firstfloor.org>
References: <1296677247.4418.103.camel@sbsiddha-MOBL3.sc.intel.com> <m2d3n9ap1y.fsf@firstfloor.org> <1296698151.4418.464.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296698151.4418.464.camel@sbsiddha-MOBL3.sc.intel.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I thought "asm volatile" is going to take care of that.

asm volatile just prevents deletion:

>>
The `volatile' keyword indicates that the instruction has important
side-effects.  GCC will not delete a volatile `asm' if it is reachable.
(The instruction can still be deleted if GCC can prove that
control-flow will never reach the location of the instruction.)  Note
that even a volatile `asm' instruction can be moved relative to other
code, including across jump instructions.
<<

> If not, then we have issues even today. no?

Well yes. It depends on the compiler if it actually moves something.
So most likely nothing was reordered yet, but it's safer to prevent
it.

I normally go by the rule that if correctness requires a specific
order without explicit side effects I add memory barriers.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
