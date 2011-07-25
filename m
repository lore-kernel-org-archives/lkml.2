Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205Ab1GYQqZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 12:46:25 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:39309 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639Ab1GYQqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 12:46:23 -0400
Date: Mon, 25 Jul 2011 09:46:19 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Jason Baron <jbaron@redhat.com>
Subject: Re: [patch 00/18] CFS Bandwidth Control v7.2
Message-ID: <20110725164619.GK2327@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110721164325.231521704@google.com>
 <1311605881.24752.2.camel@twins>
 <1311606041.24752.3.camel@twins>
 <20110725162133.GI2327@linux.vnet.ibm.com>
 <1311611311.24752.5.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311611311.24752.5.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 06:28:31PM +0200, Peter Zijlstra wrote:
> On Mon, 2011-07-25 at 09:21 -0700, Paul E. McKenney wrote:
> > On Mon, Jul 25, 2011 at 05:00:41PM +0200, Peter Zijlstra wrote:
> > > On Mon, 2011-07-25 at 16:58 +0200, Peter Zijlstra wrote:
> > > > +               rcu_read_lock();
> > > > +               ret = walk_tg_tree_from(tg, tg_set_cfs_period_down, NULL, &period);
> > > > +               rcu_read_unlock(); 
> > > 
> > > rcu over a mutex doesn't really work in mainline, bah.. 
> > 
> > SRCU can handle that situation, FWIW.  But yes, blocking in an RCU
> > read-side critical section is a no-no.
> 
> Yeah, I know, but didn't notice until after I sent.. SRCU isn't useful
> though, way too slow due to lacking srcu_call().

Good point.  How frequently would a call_srcu() be invoked?

In other words, would a really crude hack involving a globally locked
per-srcu_struct callback list and a per-srcu_struct kernel thread be
helpful, or would a slightly less-crude hack involving a per-CPU callback
list be required?

							Thanx, Paul
