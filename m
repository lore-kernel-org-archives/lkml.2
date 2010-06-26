Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291Ab0FZKIw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 06:08:52 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33277 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389Ab0FZKIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 06:08:51 -0400
Date: Sat, 26 Jun 2010 12:08:46 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
       Ingo Molnar <mingo@elte.hu>, "H.PeterA" <"nvin hpa"@zytor.com>,
       linux-kernel@vger.kernel.org, tglx <tglx@linutronix.de>,
       davem <davem@davemloft.net>, paulus <paulus@samba.org>
Subject: Re: [RFC][PATCH] irq_work -v2
Message-ID: <20100626100846.GA20233@basil.fritz.box>
References: <1277348698-17311-1-git-send-email-ying.huang@intel.com>
 <1277361352.1875.838.camel@laptop>
 <1277490625.1875.986.camel@laptop>
 <20100625193031.GD13421@basil.fritz.box>
 <1277494784.1875.989.camel@laptop>
 <20100625222953.GE13421@basil.fritz.box>
 <1277541405.1875.993.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277541405.1875.993.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 26, 2010 at 10:36:45AM +0200, Peter Zijlstra wrote:
> On Sat, 2010-06-26 at 00:29 +0200, Andi Kleen wrote:
> 
> > Yes it would be good to separate that, because I doubt other users
> > will require similar hacks.
> 
> You're such a constructive critic..

Well I'm only adapting to your tone (FWIW I thought your original
description of Ying's patches was bordering to unfair, not quoting
the words back to you). I find it also always interesting when
people who always dish out with full hands are quite sensitive themselves...

But yes we can agree to not use such tone, if that's a mutual agreement.

> I would think every NMI user would need them since NMI can interrupt at
> any time, and if you have a limited number of irq_work structs (like 1
> per cpu) you'll end up with wanting to enqueue an already enqueued one
> at some point.

You could as well drop the excessive event. In fact it surprises me that you 
don't simply do that in perf. The state should be in the PMU registers 
anyways, so you'll pick it up from there (and if you get NMIs as quickly that 
you cannot process them you have to eventually throttle by dropping anyways)

With the reuse methology you end up with the same problem anyways, is
just shifts it slightly.

For fatal NMIs it's more like: if the error is fatal then the NMI handler
will stop and if it's non fatal it can be dropped on overload.
For overload situations there needs to be a dropping mechanism, spinning
is not ok because you don't know if the current owner isn't on your
own CPU.

Some of the other errors cannot drop, but these need other mechanisms
anyways.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
