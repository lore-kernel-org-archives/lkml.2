Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132Ab0FXLUo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 07:20:44 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47536 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754952Ab0FXLUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 07:20:43 -0400
Date: Thu, 24 Jun 2010 13:20:41 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
       Ingo Molnar <mingo@elte.hu>, "H.PeterA" <"nvin hpa"@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] irq_work
Message-ID: <20100624112040.GD578@basil.fritz.box>
References: <1277363069.3947.30.camel@yhuang-dev.sh.intel.com>
 <1277363993.1875.847.camel@laptop>
 <1277364453.3947.64.camel@yhuang-dev.sh.intel.com>
 <1277364727.1875.857.camel@laptop>
 <20100624102725.GA578@basil.fritz.box>
 <1277375409.1875.943.camel@laptop>
 <20100624105254.GB578@basil.fritz.box>
 <1277377121.1875.948.camel@laptop>
 <20100624110830.GC578@basil.fritz.box>
 <1277377852.1875.950.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277377852.1875.950.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 24, 2010 at 01:10:52PM +0200, Peter Zijlstra wrote:
> On Thu, 2010-06-24 at 13:08 +0200, Andi Kleen wrote:
> > > And I really want hardirq context for perf callbacks, some code actually
> > > relies on it (I used to have the fallback in the timer softirq and that
> > 
> > Surely that could be fixed?  *requiring* hard irq context sounds weird.
> 
> possibly, but there is no reason what so ever to use softirq here.

Ok so going back to the original self-irq patchkit. Unfortunately the other
reviewer hated that. How to get out of that deadlock?


> > > broke thing at some point).
> > 
> > I have one case that needs to sleep (but only when interrupting user code)
> > They key thing in it really is to switch stacks back to process.
> 
> softirq can't sleep either, you need a trampoline anywa

Not true, when you interrupt ring 3 it can sleep. You just need to make
sure to run on the right stack and fix up any irq counters.

Anyways this can be solved in a different way too, it would just fit
in there too.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
