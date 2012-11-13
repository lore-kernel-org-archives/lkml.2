Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459Ab2KMR47 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 12:56:59 -0500
Received: from mx.scalarmail.ca ([98.158.95.75]:45701 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111Ab2KMR45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 12:56:57 -0500
Date: Tue, 13 Nov 2012 12:56:54 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: Re: Does anyone use CONFIG_TINY_PREEMPT_RCU?
Message-ID: <20121113175654.GA30119@elliptictech.com>
References: <20121113004906.GA10557@linux.vnet.ibm.com>
 <20121113144620.GA27426@elliptictech.com>
 <20121113170804.GA2489@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121113170804.GA2489@linux.vnet.ibm.com>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-11-13 09:08 -0800, Paul E. McKenney wrote:
> On Tue, Nov 13, 2012 at 09:46:20AM -0500, Nick Bowler wrote:
> > On 2012-11-12 16:49 -0800, Paul E. McKenney wrote:
> > > Hello!
> > > 
> > > I know of people using TINY_RCU, TREE_RCU, and TREE_PREEMPT_RCU, but I
> > > have not heard of anyone using TINY_PREEMPT_RCU for whom TREE_PREEMPT_RCU
> > > was not a viable option (in contrast, the people running Linux on
> > > tiny-memmory systems typically use TINY_RCU).  Of course, if no one
> > > really needs it, the proper thing to do is to remove it.
> > > 
> > > So, if you need TINY_PREEMPT_RCU, please let me know.  Otherwise, I will
> > > remove it, probably in the 3.9 timeframe.
> > 
> > Yes, I use TINY_PREEMPT_RCU on my UP machines.  It is, in fact, the only
> > option.
> 
> Suppose that TREE_PREEMPT_RCU was available for !SMP && PREEMPT builds.
> Would that work for you?

To be honest I don't really know what the difference is, other than what
the help text says, which is:

  [TINY_PREEMPT_RCU] greatly reduces the memory footprint of RCU.
  
"Greatly reduced memory footprint" sounds pretty useful...

As a side note, I wonder why any of these RCU implementations are
user-seclectable options in the first place?  It looks like you will
only ever have one choice, since the dependencies all seem mutually
exclusive:

  TREE_RCU         depends on !PREEMPT &&  SMP
  TREE_PREEMPT_RCU depends on  PREEMPT &&  SMP
  TINY_RCU         depends on !PREEMPT && !SMP
  TINY_PREEMPT_RCU depends on  PREEMPT && !SMP

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
