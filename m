Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751683Ab1LPLNp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 06:13:45 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:49932 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750981Ab1LPLNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 06:13:39 -0500
Date: Fri, 16 Dec 2011 11:13:19 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "frank.rowand@am.sony.com" <frank.rowand@am.sony.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>
Subject: Re: [PATCH] PREEMPT_RT_FULL: ARM context switch needs IRQs enabled
Message-ID: <20111216111319.GB6342@arm.com>
References: <4EEAB90D.3050504@am.sony.com>
 <1324029272.18942.73.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324029272.18942.73.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 16, 2011 at 09:54:32AM +0000, Peter Zijlstra wrote:
> On Thu, 2011-12-15 at 19:20 -0800, Frank Rowand wrote:
> > ARMv6 and later have VIPT caches and the TLBs are tagged with an ASID
> > (application specific ID). The number of ASIDs is limited to 256 and
> > the allocation algorithm requires IPIs when all the ASIDs have been
> > used.  The IPIs require interrupts enabled during context switch for
> > deadlock avoidance.
> > 
> > The RT patch mm-protect-activate-switch-mm.patch disables irqs around
> > activate_mm() and switch_mm(), which are the portion of the ARMv6
> > context switch that require interrupts enabled.
> > 
> > The solution for the ARMv6 processors could be to _not_ disable irqs.
> > A more conservative solution is to provide the same environment that
> > the scheduler provides, that is preempt_disable().  This is more
> > resilient for possible future changes to the ARM context switch code
> > that is not aware of the RT patches.
> > 
> > This patch will conflict slightly with Catalin's patch set to remove
> > __ARCH_WANT_INTERRUPTS_ON_CTXSW, when that is accepted:
> > 
> >    http://lkml.indiana.edu/hypermail/linux/kernel/1111.3/01893.html
> > 
> > When Catalin's patch set is accepted, this RT patch will need to reverse
> > the change in patch 6 to arch/arm/include/asm/system.h:
> 
> 
> We could just merge Catalin's stuff in -rt to give it a test ride and
> see if anything horrible happens.. :-)

Russell agreed for me to push this to -next (in case -rt uses that, not
sure) to get a bit more exposure. Otherwise testing the patches in -rt
would really help spotting bugs.

But we need to sort out the dangling switch_mm() calls (without a
corresponding post-switch hook call) that I mentioned in my reply to
Frank.

-- 
Catalin
