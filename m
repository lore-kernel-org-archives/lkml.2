Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695Ab2AXPPO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 10:15:14 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37175 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750854Ab2AXPPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 10:15:13 -0500
Date: Tue, 24 Jan 2012 15:14:34 +0000
From: Will Deacon <will.deacon@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 0/6] ARM: Remove the __ARCH_WANT_INTERRUPTS_ON_CTXSW
 definition
Message-ID: <20120124151434.GL19798@mudshark.cambridge.arm.com>
References: <1327081352-13178-1-git-send-email-catalin.marinas@arm.com>
 <1327310131.2446.1.camel@twins>
 <20120123092624.GA11983@arm.com>
 <20120123094759.GU1068@n2100.arm.linux.org.uk>
 <20120123095338.GB11983@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120123095338.GB11983@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 09:53:38AM +0000, Catalin Marinas wrote:
> On Mon, Jan 23, 2012 at 09:47:59AM +0000, Russell King - ARM Linux wrote:
> > On Mon, Jan 23, 2012 at 09:26:24AM +0000, Catalin Marinas wrote:
> > > On Mon, Jan 23, 2012 at 09:15:31AM +0000, Peter Zijlstra wrote:
> > > > On Fri, 2012-01-20 at 17:42 +0000, Catalin Marinas wrote:
> > > > > This is version 3 of the set of patches removing
> > > > > __ARCH_WANT_INTERRUPTS_ON_CTXSW on ARM. The series was rebased on top of
> > > > > 3.3-rc1 and fixed the conflicts with the kernel/sched/ changes and the
> > > > > ARM LPAE patches. There are no functional changes from v2. I plan to
> > > > > push this to -next and get it ready for 3.4-rc1.
> > > > > 
> > > > > Question for Peter/Ingo - how do we merge the first patch that
> > > > > introduces finish_arch_post_lock_switch? Do you pick it up or I can
> > > > > merge it via rmk (with your ack)?
> > > > 
> > > > I'm fine either way, I'll probably ask Ingo to pull your tree so that I
> > > > can stack some other patches on top.
> > > 
> > > In which case I would need Russell's acked-by.
> > 
> > That depends on knowing what CPU architectures this has been tested on,
> > and whether anyone external has tested it.  It's definitely a change
> > which needs some tested-by tags on it.
> 
> I agree. On my side, I tested it on:
> 
> Versatile Express + Cortex-A9 (SMP configuration, ASIDs)
> Versatile PB926 (UP configuration, no ASIDs)

For what it's worth, I've also tested this on:

Realview PB1176 (UP, ASIDs)
Cortex-A5 (SMP, ASIDs)
Cortex-A7 (SMP, ASIDs)

and I haven't seen any problems with native, parallel kernel builds. I don't
have anything prior to ARMv5 available, but at least we seem to have covered
v5-v7.

Will
