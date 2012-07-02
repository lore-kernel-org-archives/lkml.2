Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750818Ab2GBLgJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 07:36:09 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:48697 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab2GBLgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 07:36:07 -0400
Date: Mon, 2 Jul 2012 04:35:41 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sasha Levin <levinsasha928@gmail.com>, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: rcu: BUG: spinlock recursion on CPU#3, trinity-child19/5970
Message-ID: <20120702113541.GI2907@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1340964584.2936.40.camel@lappy>
 <20120629172320.GA2416@linux.vnet.ibm.com>
 <1341006040.26928.4.camel@lappy>
 <1341225139.23484.4.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341225139.23484.4.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12070211-4242-0000-0000-0000022F3110
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 02, 2012 at 12:32:19PM +0200, Peter Zijlstra wrote:
> On Fri, 2012-06-29 at 23:40 +0200, Sasha Levin wrote:
> > 
> > The bad news are that what you saw was a lockdep enabled run
> > (CONFIG_PROVE_RCU is enabled, and lockdep was enabled). There were no
> > lockdep warnings at any point while reproducing it. 
> 
> rcu_switch_from() -> rcu_preempt_note_context_switch() is called _after_
> the lockdep context switch annotation. Therefore lockdep things the prev
> task isn't holding any locks anymore.

In other words, moving rcu_preempt_note_context_switch() deeper into
the scheduler is totally bogus, and I need to move it back out into the
original rcu_note_context_switch(), reverting 616c310e (Move PREEMPT_RCU
preemption to switch_to() invocation), correct?

Sigh.  "It seemed like a good idea at the time."

							Thanx, Paul

