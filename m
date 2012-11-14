Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab2KNAZP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 19:25:15 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:56483 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756079Ab2KNAZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 19:25:13 -0500
Date: Tue, 13 Nov 2012 16:05:34 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: Re: Does anyone use CONFIG_TINY_PREEMPT_RCU?
Message-ID: <20121114000534.GM2489@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20121113004906.GA10557@linux.vnet.ibm.com>
 <20121113144620.GA27426@elliptictech.com>
 <20121113170804.GA2489@linux.vnet.ibm.com>
 <20121113175654.GA30119@elliptictech.com>
 <20121113211952.GC2489@linux.vnet.ibm.com>
 <20121113214720.GC13472@elliptictech.com>
 <20121113222521.GI2489@linux.vnet.ibm.com>
 <20121113224040.GA14594@elliptictech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121113224040.GA14594@elliptictech.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12111400-5806-0000-0000-00001BBD7C2C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 05:40:40PM -0500, Nick Bowler wrote:
> On 2012-11-13 14:25 -0800, Paul E. McKenney wrote:
> > On Tue, Nov 13, 2012 at 04:47:20PM -0500, Nick Bowler wrote:
> > > On 2012-11-13 13:19 -0800, Paul E. McKenney wrote:
> > > > On Tue, Nov 13, 2012 at 12:56:54PM -0500, Nick Bowler wrote:
> > > > > On 2012-11-13 09:08 -0800, Paul E. McKenney wrote:
> > > > > > Suppose that TREE_PREEMPT_RCU was available for !SMP && PREEMPT builds.
> > > > > > Would that work for you?
> > > > > 
> > > > > To be honest I don't really know what the difference is, other than what
> > > > > the help text says, which is:
> > > > > 
> > > > >   [TINY_PREEMPT_RCU] greatly reduces the memory footprint of RCU.
> > > > >   
> > > > > "Greatly reduced memory footprint" sounds pretty useful...
> > > > 
> > > > OK, so from your viewpoint, the only possible benefit is smaller
> > > > memory?
> > > 
> > > Well, I have no idea.  If I was given the choice between TREE_PREEMPT_RCU
> > > and TINY_PREEMPT_RCU, absent any information not in the description of
> > > these options, I would choose TINY.  The description suggests that the
> > > memory savings come at the expense of SMP support, which sounds like a
> > > great tradeoff to make for a UP system.
> > > 
> > > > How much memory does your device have, if I may ask?
> > > 
> > > It's a (pretty old!) desktop.  I recently had to upgrade it to two
> > > gigabytes due to unbearable thrashing with only one...
> > 
> > If you have two gigabytes (or even one gigabyte), you won't notice the
> > few kilobytes of difference between TINY_PREEMPT_RCU and TREE_PREEMPT_RCU.
> 
> Well then TINY_PREEMPT_RCU doesn't sound all that useful for me!
> Perhaps the help text could be improved... such as changing the words
> "greatly reduced" to "marginally reduced" as a first step?
> 
> Is there no significant cache impact due to the larger implementation?
> I don't really have the time or expertise to do measurements in this
> regard, but if TREE_PREEMPT_RCU was actually a selectable option I could
> at least choose it to see if anything explodes horribly...

Indeed, if I do this, the first step would be to re-introduce the
choice between CONFIG_TREE_PREEMPT_RCU and CONFIG_TINY_PREEMPT_RCU
so that you could check for horrible explosions.  If the past is
any guide, there would be at least a few.  ;-)

							Thanx, Paul

