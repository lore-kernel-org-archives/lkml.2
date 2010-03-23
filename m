Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812Ab0CWPeJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 11:34:09 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:55210 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754735Ab0CWPeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 11:34:05 -0400
Date: Tue, 23 Mar 2010 08:33:59 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Anton Blanchard <anton@samba.org>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Milton Miller <miltonm@bga.com>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] smp_call_function_many SMP race
Message-ID: <20100323153359.GM2517@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100323111556.GK24064@kryten>
 <1269347203.5279.1650.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269347203.5279.1650.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 23, 2010 at 01:26:43PM +0100, Peter Zijlstra wrote:
> On Tue, 2010-03-23 at 22:15 +1100, Anton Blanchard wrote:
> > 
> > It turns out commit c0f68c2fab4898bcc4671a8fb941f428856b4ad5 (generic-ipi:
> > cleanup for generic_smp_call_function_interrupt()) is at fault. It removes
> > locking from smp_call_function_many and in doing so creates a rather
> > complicated race. 
> 
> A rather simple question since my brain isn't quite ready processing the
> content here..
> 
> Isn't reverting that one patch a simpler solution than adding all that
> extra logic? If not, then the above statement seems false and we had a
> bug even with that preempt_enable/disable() pair.
> 
> Just wondering.. :-)

If I understand correctly, if you want to fix it by reverting patches,
you have to revert back to simple locking (up to and including
54fdade1c3332391948ec43530c02c4794a38172).  And I believe that the poor
performance of simple locking was whole reason for the series of patches.

							Thanx, Paul
