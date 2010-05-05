Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758319Ab0EEVBa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 17:01:30 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:56241 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756420Ab0EEVB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 17:01:29 -0400
Date: Wed, 5 May 2010 14:01:21 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, eric.dumazet@gmail.com,
       Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH tip/core/rcu 36/48] nfs: __rcu annotations
Message-ID: <20100505210121.GC2439@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1273004398-19760-36-git-send-email-paulmck@linux.vnet.ibm.com>
 <20100504201934.GA19234@linux.vnet.ibm.com>
 <23175.1273054443@redhat.com>
 <1273063495.8329.4.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273063495.8329.4.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 08:44:55AM -0400, Trond Myklebust wrote:
> On Wed, 2010-05-05 at 11:14 +0100, David Howells wrote: 
> > Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > 
> > >  struct nfs_delegation {
> > >  	struct list_head super_list;
> > > -	struct rpc_cred *cred;
> > > +	struct rpc_cred __rcu *cred;
> > >  	struct inode *inode;
> > >  	nfs4_stateid stateid;
> > >  	fmode_t type;
> > 
> > That's unnecessary.  I posted a patch that removed the usage of RCU on that
> > pointer:
> > 
> > 	Date: Tue, 20 Apr 2010 11:26:13 +0100
> > 	Subject: NFS: Fix RCU issues in the NFSv4 delegation code
> > 
> > Did Trond take it?
> > 
> > David
> 
> Yes. I haven't pushed it to Linus yet, but I'm planning to do so in the
> next 2 days.

I have dropped this change from this commit.  Are the rest of the changes
in this commit (nfs_fs.h and auth_gss.h) OK?

							Thanx, Paul
