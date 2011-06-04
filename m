Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab1FDQDb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 12:03:31 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:47606 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314Ab1FDQDa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 12:03:30 -0400
Date: Sat, 4 Jun 2011 09:03:26 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <jaxboe@fusionio.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Mysterious CFQ crash and RCU
Message-ID: <20110604160326.GA6093@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110519222404.GG12600@redhat.com>
 <20110521210013.GJ2271@linux.vnet.ibm.com>
 <20110523152141.GB4019@redhat.com>
 <20110523153848.GC2310@linux.vnet.ibm.com>
 <1306401337.27271.3.camel@t41.thuisdomein>
 <20110603050724.GB2304@linux.vnet.ibm.com>
 <1307191830.23387.24.camel@t41.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307191830.23387.24.camel@t41.thuisdomein>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 04, 2011 at 02:50:17PM +0200, Paul Bolle wrote:
> On Thu, 2011-06-02 at 22:07 -0700, Paul E. McKenney wrote:
> > And please accept my apologies for being so slow to get to it.
> 
> Thanks, but it was just a week (ie, quite a quick response by my
> standards).
> 
> > Looks healthy to me...
> 
> How should I understand that? Something like: "As far as this hlist is
> used with RCU everything seems OK. Perhaps something is messing with the
> entries of this hlist outside of RCU. Perhaps additional locking is
> needed."

More like "based on these diagnostics, I see no evidence of the RCU
implementation misbehaving."  Which is of course different than "I can
prove that the RCU implementation is not misbehaving".  That said, the
fact that you are running on a single CPU makes it hard for me to see
any latitude for RCU-implementation misbehavior.

Clearly something is wrong somewhere.  Given the fact that on a single-CPU
system, synchronize_rcu() is a no-op, and given that you weren't able
to reproduce with CONFIG_TREE_PREEMPT_RCU=y, my guess is that there is
a synchronize_rcu() that occasionally (illegally) gets executed within
an RCU read-side critical section.

							Thanx, Paul
