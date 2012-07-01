Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178Ab2GAHSN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 03:18:13 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:44139 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab2GAHSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 03:18:12 -0400
X-Originating-IP: 217.70.178.144
X-Originating-IP: 50.43.46.74
Date: Sun, 1 Jul 2012 00:17:58 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Rusty Russell <rusty@ozlabs.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 01/22] rcu: Control RCU_FANOUT_LEAF from
 boot-time parameter
Message-ID: <20120701071757.GA8749@leaf>
References: <20120622151655.GA6249@linux.vnet.ibm.com>
 <1340378241-6458-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <87y5n4xatd.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y5n4xatd.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 01, 2012 at 03:49:42PM +0930, Rusty Russell wrote:
> On Fri, 22 Jun 2012 08:17:00 -0700, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > 
> > Although making RCU_FANOUT_LEAF a kernel configuration parameter rather
> > than a fixed constant makes it easier for people to decrease cache-miss
> > overhead for large systems, it is of little help for people who must
> > run a single pre-built kernel binary.
> > 
> > This commit therefore allows the value of RCU_FANOUT_LEAF to be
> > increased (but not decreased!) via a boot-time parameter named
> > rcutree.rcu_fanout_leaf.
> ...
> > +static int rcu_fanout_leaf = CONFIG_RCU_FANOUT_LEAF;
> > +module_param(rcu_fanout_leaf, int, 0);
> 
> Maybe it's overkill, but 0400 or 0444 might be a nice touch.

I agree.  0 almost never makes sense; root should almost always have the
ability to read module parameters.  And in this case, I see no reason
not to make it 0444.

- Josh Triplett
