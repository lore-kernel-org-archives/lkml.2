Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933812Ab1JDXPw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 19:15:52 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:60510 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933299Ab1JDXPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 19:15:51 -0400
Date: Tue, 4 Oct 2011 16:15:48 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Quick review of -rt RCU-related patches
Message-ID: <20111004231548.GH2223@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20111004174755.GA4762@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1110042322450.18778@ionos>
 <1317766355.32543.38.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317766355.32543.38.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 05, 2011 at 12:12:35AM +0200, Peter Zijlstra wrote:
> On Wed, 2011-10-05 at 00:05 +0200, Thomas Gleixner wrote:
> > > peter_zijlstra-frob-rcu.patch
> > > 
> > >       Looks OK.  Hmmm...  Should this one go to mainline?
> > >       Oh, looks equivalent, actually.  So why the change?
> > 
> > Peter ? 
> 
> -       if (in_irq() || in_serving_softirq()) {
> +       if (preempt_count() & (HARDIRQ_MASK | SOFTIRQ_OFFSET)) {
> 
> 
> For !rt its equivalent yes, for rt otoh its not:
> 
> int in_serving_softirq(void)
> {
>         int res;
> 
>         preempt_disable();
>         res = __get_cpu_var(local_softirq_runner) == current;
>         preempt_enable();
>         return res;
> }
> 
> However invoke_softirq() will still add SOFTIRQ_OFFSET so we need to
> look at that to avoid recursion issues.
> 
> The changelog describes this. So this change is a direct consequence of
> -rt frobbing the softirq stuff and thus isn't needed upstream. 

Ah, thank you for the explanation!

							Thanx, Paul
