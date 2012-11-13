Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab2KMXM6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 18:12:58 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:50749 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752680Ab2KMXM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 18:12:56 -0500
Date: Tue, 13 Nov 2012 15:04:47 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Darren Hart <darren@dvhart.com>
Cc: Nick Bowler <nbowler@elliptictech.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        Andrew Morton <akpm@linux-foundation.org>,
        mathieu.desnoyers@efficios.com, Josh Triplett <josh@joshtriplett.org>,
        Nivedita Singhvi <niv@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Valdis.Kletnieks@vt.edu,
        David Howells <dhowells@redhat.com>, edumazet@google.com,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        sbw@mit.edu, patches@linaro.org
Subject: Re: Does anyone use CONFIG_TINY_PREEMPT_RCU?
Message-ID: <20121113230446.GJ2489@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20121113004906.GA10557@linux.vnet.ibm.com>
 <20121113144620.GA27426@elliptictech.com>
 <20121113170804.GA2489@linux.vnet.ibm.com>
 <20121113175654.GA30119@elliptictech.com>
 <20121113211952.GC2489@linux.vnet.ibm.com>
 <20121113214720.GC13472@elliptictech.com>
 <20121113222521.GI2489@linux.vnet.ibm.com>
 <CAGChsmOBB1yFNP5xSa06v+CYn0A=AjcZTyAzL8npWRdNYYLBZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGChsmOBB1yFNP5xSa06v+CYn0A=AjcZTyAzL8npWRdNYYLBZA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12111323-9360-0000-0000-00000CC1B81E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 02:33:48PM -0800, Darren Hart wrote:
> On Tue, Nov 13, 2012 at 2:25 PM, Paul E. McKenney <
> paulmck@linux.vnet.ibm.com> wrote:
> 
> > On Tue, Nov 13, 2012 at 04:47:20PM -0500, Nick Bowler wrote:
> > > On 2012-11-13 13:19 -0800, Paul E. McKenney wrote:
> > > > On Tue, Nov 13, 2012 at 12:56:54PM -0500, Nick Bowler wrote:
> > > > > On 2012-11-13 09:08 -0800, Paul E. McKenney wrote:
> > > > > > Suppose that TREE_PREEMPT_RCU was available for !SMP && PREEMPT
> > builds.
> > > > > > Would that work for you?
> > > > >
> > > > > To be honest I don't really know what the difference is, other than
> > what
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
> >
> >
> In that case I don't have any reason to be concerned about it. It seems
> then as though "tiny" is meant to reduce memory usage on systems with a
> great deal of memory where the structures add up to consume significant
> amounts of memory?

The "tiny" is for extremely small systems.  The difference in memory
consumption is otherwise not all that big a deal.

CONFIG_TINY_PREEMPT_RCU:

   text	   data	    bss	    dec	    hex	filename
   1079	    173	      0	   1252	    4e4	/tmp/b/kernel/rcupdate.o
   3223	    105	      4	   3332	    d04	/tmp/b/kernel/rcutiny.o

CONFIG_TREE_PREEMPT_RCU, NR_CPUS=2:

   text	   data	    bss	    dec	    hex	filename
   1376	    197	      0	   1573	    625	/tmp/b/kernel/rcupdate.o
  16545	   2030	     12	  18587	   489b	/tmp/b/kernel/rcutree.o

So you get about 15Kbytes by using CONFIG_TINY_PREEMPT_RCU instead of
CONFIG_TREE_PREEMPT_RCU.  Actually you get a bit less than that, because
CONFIG_TREE_PREEMPT_RCU's data would be a bit smaller for NR_CPUS=1.

But people who -really- care about memory measured in kilobytes
usually go all the way to CONFIG_TINY_RCU:

CONFIG_TINY_RCU:

   text	   data	    bss	    dec	    hex	filename
    858	    173	      0	   1031	    407	/tmp/b/kernel/rcupdate.o
   1788	     47	      0	   1835	    72b	/tmp/b/kernel/rcutiny.o

This is about 2.5K better than CONFIG_TINY_PREEMPT_RCU.  Also, !PREEMPT
reduces the size of the rest of the kernel as well.

Hence my belief that CONFIG_TINY_PREEMPT_RCU isn't really helping much
here.

							Thanx, Paul

