Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481Ab1LPJzk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 04:55:40 -0500
Received: from casper.infradead.org ([85.118.1.10]:60310 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab1LPJzf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 04:55:35 -0500
Message-ID: <1324029272.18942.73.camel@twins>
Subject: Re: [PATCH] PREEMPT_RT_FULL: ARM context switch needs IRQs enabled
From: Peter Zijlstra <peterz@infradead.org>
To: frank.rowand@am.sony.com
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org, catalin.marinas@arm.com,
        rostedt@goodmis.org
Date: Fri, 16 Dec 2011 10:54:32 +0100
In-Reply-To: <4EEAB90D.3050504@am.sony.com>
References: <4EEAB90D.3050504@am.sony.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ now without loosing CC's ]

On Thu, 2011-12-15 at 19:20 -0800, Frank Rowand wrote:
> ARMv6 and later have VIPT caches and the TLBs are tagged with an ASID
> (application specific ID). The number of ASIDs is limited to 256 and
> the allocation algorithm requires IPIs when all the ASIDs have been
> used.  The IPIs require interrupts enabled during context switch for
> deadlock avoidance.
> 
> The RT patch mm-protect-activate-switch-mm.patch disables irqs around
> activate_mm() and switch_mm(), which are the portion of the ARMv6
> context switch that require interrupts enabled.
> 
> The solution for the ARMv6 processors could be to _not_ disable irqs.
> A more conservative solution is to provide the same environment that
> the scheduler provides, that is preempt_disable().  This is more
> resilient for possible future changes to the ARM context switch code
> that is not aware of the RT patches.
> 
> This patch will conflict slightly with Catalin's patch set to remove
> __ARCH_WANT_INTERRUPTS_ON_CTXSW, when that is accepted:
> 
>    http://lkml.indiana.edu/hypermail/linux/kernel/1111.3/01893.html
> 
> When Catalin's patch set is accepted, this RT patch will need to reverse
> the change in patch 6 to arch/arm/include/asm/system.h:


We could just merge Catalin's stuff in -rt to give it a test ride and
see if anything horrible happens.. :-)
