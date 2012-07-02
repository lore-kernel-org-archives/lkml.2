Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132Ab2GBPNQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 11:13:16 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:60537 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496Ab2GBPNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 11:13:12 -0400
Date: Mon, 2 Jul 2012 07:59:27 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: rcu: BUG: spinlock recursion on CPU#3, trinity-child19/5970
Message-ID: <20120702145927.GD2508@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1340964584.2936.40.camel@lappy>
 <20120629172320.GA2416@linux.vnet.ibm.com>
 <1341006040.26928.4.camel@lappy>
 <1341225139.23484.4.camel@twins>
 <20120702113541.GI2907@linux.vnet.ibm.com>
 <1341230352.23484.7.camel@twins>
 <1341234773.2958.4.camel@lappy>
 <20120702133334.GA2508@linux.vnet.ibm.com>
 <20120702142252.GA22868@linux.vnet.ibm.com>
 <1341239813.2958.7.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341239813.2958.7.camel@lappy>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12070215-1780-0000-0000-000007060155
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000284; HX=3.00000191; KW=3.00000007;
 PH=3.00000001; SC=3.00000004; SDB=6.00153145; UDB=6.00034617; UTC=2012-07-02
 15:13:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 02, 2012 at 04:36:53PM +0200, Sasha Levin wrote:
> On Mon, 2012-07-02 at 07:22 -0700, Paul E. McKenney wrote:
> > > OK, so it looks like the context-switch-time call into preemptible RCU
> > > needs to be outside of the runqueue-lock critical section.  One way
> > > to do this is be reverting 616c310e (Move PREEMPT_RCU preemption to
> > > switch_to() invocation).  Sasha, could you please try this out?
> > 
> > Hmmmm...  Here is a patch for this reversion on top of -rcu with
> > conflicts resolved. 
> 
> It looks like how I've resolved it.

Good show!!!

> Just for clarity, the only rcu related patch I have on top of -next is
> this reversal one. I've dropped anything we tested before.
> 
> Looks like its running fine for a bit now (~10 min). I'll ping if
> anything changes, but on the other tests it has usually failed at this
> point.

If testing goes well (both yours and mine), I will be submitting this
as urgent, since it is a 3.5 regression.  If they don't take it, I will
queue it for 3.6.

							Thanx, Paul

