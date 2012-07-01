Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582Ab2GAMwz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 08:52:55 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:60609 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367Ab2GAMwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 08:52:54 -0400
Date: Sun, 1 Jul 2012 05:52:22 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Rusty Russell <rusty@ozlabs.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 01/22] rcu: Control RCU_FANOUT_LEAF from
 boot-time parameter
Message-ID: <20120701125222.GG2907@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120622151655.GA6249@linux.vnet.ibm.com>
 <1340378241-6458-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <87y5n4xatd.fsf@rustcorp.com.au>
 <20120701071757.GA8749@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120701071757.GA8749@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12070112-2398-0000-0000-0000080F753B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 01, 2012 at 12:17:58AM -0700, Josh Triplett wrote:
> On Sun, Jul 01, 2012 at 03:49:42PM +0930, Rusty Russell wrote:
> > On Fri, 22 Jun 2012 08:17:00 -0700, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> > > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > > 
> > > Although making RCU_FANOUT_LEAF a kernel configuration parameter rather
> > > than a fixed constant makes it easier for people to decrease cache-miss
> > > overhead for large systems, it is of little help for people who must
> > > run a single pre-built kernel binary.
> > > 
> > > This commit therefore allows the value of RCU_FANOUT_LEAF to be
> > > increased (but not decreased!) via a boot-time parameter named
> > > rcutree.rcu_fanout_leaf.
> > ...
> > > +static int rcu_fanout_leaf = CONFIG_RCU_FANOUT_LEAF;
> > > +module_param(rcu_fanout_leaf, int, 0);
> > 
> > Maybe it's overkill, but 0400 or 0444 might be a nice touch.
> 
> I agree.  0 almost never makes sense; root should almost always have the
> ability to read module parameters.  And in this case, I see no reason
> not to make it 0444.

Should I do the same for these parameters as well?

kernel/rcutree.c:module_param(blimit, int, 0);
kernel/rcutree.c:module_param(qhimark, int, 0);
kernel/rcutree.c:module_param(qlowmark, int, 0);

Cut-and-paste, it is a wonderful thing.  ;-)

							Thanx, Paul

