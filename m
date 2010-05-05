Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934701Ab0EEMpS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 08:45:18 -0400
Received: from mx2.netapp.com ([216.240.18.37]:29371 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934433Ab0EEMpQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 08:45:16 -0400
X-IronPort-AV: E=Sophos;i="4.52,333,1270450800"; 
   d="scan'208";a="354877262"
Subject: Re: [PATCH tip/core/rcu 36/48] nfs: __rcu annotations
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: David Howells <dhowells@redhat.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, eric.dumazet@gmail.com,
       Arnd Bergmann <arnd@arndb.de>
In-Reply-To: <23175.1273054443@redhat.com>
References: <1273004398-19760-36-git-send-email-paulmck@linux.vnet.ibm.com>
	 <20100504201934.GA19234@linux.vnet.ibm.com>  <23175.1273054443@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: NetApp
Date: Wed, 05 May 2010 08:44:55 -0400
Message-ID: <1273063495.8329.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
X-OriginalArrivalTime: 05 May 2010 12:44:55.0950 (UTC) FILETIME=[C3C532E0:01CAEC50]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-05 at 11:14 +0100, David Howells wrote: 
> Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> >  struct nfs_delegation {
> >  	struct list_head super_list;
> > -	struct rpc_cred *cred;
> > +	struct rpc_cred __rcu *cred;
> >  	struct inode *inode;
> >  	nfs4_stateid stateid;
> >  	fmode_t type;
> 
> That's unnecessary.  I posted a patch that removed the usage of RCU on that
> pointer:
> 
> 	Date: Tue, 20 Apr 2010 11:26:13 +0100
> 	Subject: NFS: Fix RCU issues in the NFSv4 delegation code
> 
> Did Trond take it?
> 
> David

Yes. I haven't pushed it to Linus yet, but I'm planning to do so in the
next 2 days.

Cheers
  Trond
