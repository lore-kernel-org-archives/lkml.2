Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab0C3RZq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 13:25:46 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:46417 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752673Ab0C3RZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 13:25:44 -0400
Date: Tue, 30 Mar 2010 10:25:42 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Howells <dhowells@redhat.com>, Trond.Myklebust@netapp.com,
       linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NFS: Fix RCU warnings in
 nfs_inode_return_delegation_noreclaim() [ver #2]
Message-ID: <20100330172542.GI2513@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100319022527.GC2894@linux.vnet.ibm.com>
 <20100318133302.29754.1584.stgit@warthog.procyon.org.uk>
 <19192.1269889348@redhat.com>
 <23274.1269893706@redhat.com>
 <25276.1269901350@redhat.com>
 <26760.1269903543@redhat.com>
 <20100329232636.GT2569@linux.vnet.ibm.com>
 <2440.1269967151@redhat.com>
 <20100330164912.GG2513@linux.vnet.ibm.com>
 <1269968671.10116.17.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1269968671.10116.17.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 30, 2010 at 07:04:31PM +0200, Eric Dumazet wrote:
> Le mardi 30 mars 2010 à 09:49 -0700, Paul E. McKenney a écrit :
> > On Tue, Mar 30, 2010 at 05:39:11PM +0100, David Howells wrote:
> > > Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > > 
> > > > Scrap this one -- Arnd has it covered, under the much better name
> > > > of rcu_dereference_const().
> > > 
> > > Not convinced of that name either.  That sounds like the RCU dereference of
> > > constant (R/O) data.
> > 
> > Which it is, as long as the lock is held.
> > 
> > But what name would you suggest?
> > 
> 
> Maybe use 'protected' word or something like that, or 'owned', ...
> 
> rcu_dereference_protected() or rcu_dereference_owned()

I do like rcu_dereference_protected() -- a bit longer than
rcu_dereference_locked(), but covers the initialization and cleanup
accesses that might be protected by privatization rather than by locking.

Other thoughts?

							Thanx, Paul
