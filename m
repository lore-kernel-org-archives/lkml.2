Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334Ab0FXMiL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 08:38:11 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59379 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456Ab0FXMiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 08:38:09 -0400
Date: Thu, 24 Jun 2010 14:38:04 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
       Ingo Molnar <mingo@elte.hu>, "H.PeterA" <"nvin hpa"@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] irq_work
Message-ID: <20100624123804.GK578@basil.fritz.box>
References: <20100624105254.GB578@basil.fritz.box>
 <1277377121.1875.948.camel@laptop>
 <20100624110830.GC578@basil.fritz.box>
 <1277377852.1875.950.camel@laptop>
 <20100624112040.GD578@basil.fritz.box>
 <1277379204.1875.957.camel@laptop>
 <20100624115520.GF578@basil.fritz.box>
 <1277380649.1875.962.camel@laptop>
 <20100624120226.GH578@basil.fritz.box>
 <1277381887.1875.966.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277381887.1875.966.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 24, 2010 at 02:18:07PM +0200, Peter Zijlstra wrote:
> On Thu, 2010-06-24 at 14:02 +0200, Andi Kleen wrote:
> > On Thu, Jun 24, 2010 at 01:57:29PM +0200, Peter Zijlstra wrote:
> > > On Thu, 2010-06-24 at 13:55 +0200, Andi Kleen wrote:
> > > > > but we don't have anything else that does that.
> > > > 
> > > > Actually we do, audit in syscalls and scheduling in interrupts and signals 
> > > > all work this way. Probably more at some point adding more code to this
> > > > path was very popular. 
> > > 
> > > That's the return to user path, nothing to do with softirqs. Add a TIF
> > > flag and call your function there.
> > 
> > It does that, but there are some cases where it's not enough.
> 
> care to expand on that?

This is for execution context error recovery.

TIF works for user space, but it's a bit ugly because it requires adding
more data to the task_struct because CPUs can change. The sleepable 
soft irq would have avoided that (that's not a show stopper)

The other case was to recover from a *_user() error in the kernel.
I originally had some fancy code for preemptive kernels that 
exploited that you could sleep here

(it doesn't work for non preemptive unfortunately because we can't
know if locks are hold and some *_user are expected to 
never sleep) 

But there were still ugly special cases for switching stacks
and the sleepable softirqs could have avoided that.

Anyways the later is not fatal either, but it would have been
nice to solve that one.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
