Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074Ab2AECSG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 21:18:06 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:44593 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757099Ab2AECSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 21:18:03 -0500
Date: Wed, 4 Jan 2012 18:17:58 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcu: Improve detection of illegal synchronize_rcu() call
 from RCU read side
Message-ID: <20120105021758.GS2448@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1324901803.31721.4.camel@lappy>
 <20111226163148.GC2435@linux.vnet.ibm.com>
 <20111226163734.GF28309@somewhere.redhat.com>
 <20111226195656.GD2435@linux.vnet.ibm.com>
 <20120104190336.GC1143@somewhere>
 <20120104213035.GF2448@linux.vnet.ibm.com>
 <20120105014518.GD1143@somewhere>
 <20120105020108.GQ2448@linux.vnet.ibm.com>
 <20120105020601.GE1143@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120105020601.GE1143@somewhere>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12010502-3270-0000-0000-000002FF2031
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 05, 2012 at 03:06:03AM +0100, Frederic Weisbecker wrote:
> On Wed, Jan 04, 2012 at 06:01:08PM -0800, Paul E. McKenney wrote:
> > On Thu, Jan 05, 2012 at 02:45:20AM +0100, Frederic Weisbecker wrote:
> > > On Wed, Jan 04, 2012 at 01:30:35PM -0800, Paul E. McKenney wrote:
> > > > On Wed, Jan 04, 2012 at 08:03:39PM +0100, Frederic Weisbecker wrote:
> > > > > Actually for the case of RCU, the wait_for_completion() called by synchronize_rcu()

[ . . . ]

> > > > > rcutiny seems to be fine with the cond_resched() call, but srcu needs
> > > > > a special treatment.
> > > > 
> > > > For the moment, I just applied rcu_lockdep_assert() everywhere -- zero
> > > > cost on non-lockdep kernels, and fully handles all of the RCU simple
> > > > self-deadlock cases.
> > > 
> > > So, for RCU I'm not sure this is useful given the might_sleep() things.
> > > But for srcu it is.
> > 
> > One nice thing about the lockdep approach is that it tracks where the
> > conflicting RCU read-side critical section started.  But I am planning
> > for these to be 3.4 material, so we do have some time to refine them.
> 
> Yeah sure. And in any case it's still good to keep might_sleep() early
> to spot other sources of illegal atomic sections (irqs disabled and co)

Agreed!

							Thanx, Paul

