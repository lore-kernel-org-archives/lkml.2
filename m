Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849Ab1EYAQM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 20:16:12 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:46073 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300Ab1EYAQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 20:16:11 -0400
Date: Tue, 24 May 2011 17:16:08 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        tglx@linutronix.de, mingo@elte.hu
Subject: Re: [tip:core/rcu] Revert "rcu: Decrease memory-barrier usage
 based on semi-formal proof"
Message-ID: <20110525001608.GA21060@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4DDAC01E.7050602@kernel.org>
 <20110523212530.GF7428@linux.vnet.ibm.com>
 <4DDAD934.9010603@kernel.org>
 <4DDAE5FA.2030303@kernel.org>
 <4DDAE6A5.6060701@kernel.org>
 <20110524011824.GL7428@linux.vnet.ibm.com>
 <4DDB093F.2060601@kernel.org>
 <20110524013523.GO7428@linux.vnet.ibm.com>
 <4DDC21E1.1070502@kernel.org>
 <20110525000530.GK2266@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110525000530.GK2266@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 05:05:30PM -0700, Paul E. McKenney wrote:
> On Tue, May 24, 2011 at 02:23:45PM -0700, Yinghai Lu wrote:
> > On 05/23/2011 06:35 PM, Paul E. McKenney wrote:

[ . . . ]

> > after:
> > commit bcd6e68330f893a81b3519ab3c5fc2bebbc9988c
> > Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Date:   Tue Sep 7 10:38:22 2010 -0700
> > 
> >     rcu: Decrease memory-barrier usage based on semi-formal proof
> > ...
> > 
> > got:
> > 
> > [   32.447936] cpu_dev_init done
> > [  111.027066] memory_dev_init done
> 
> So there is something nasty in this patch.
> 
> Not seeing it immediately, but it does give me some focus for both
> code inspection and possible diagnostic patches.

Actually, I already do have some debugfs stuff that should help me spot
the problem.

So could you please build both with and without this commit enabling
CONFIG_TRACE_RCU and send me the contents of the debugfs files rcu/rcuhier
and rcu/rcudata in both cases?

This will show me the results of the full boot path.  If this turns out to
drown out the differences, I will create a more focused diagnostic patch.

							Thanx, Paul
