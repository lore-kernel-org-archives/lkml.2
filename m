Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab2FTNYM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 09:24:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291Ab2FTNYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 09:24:10 -0400
Date: Wed, 20 Jun 2012 15:23:29 +0200
From: Jiri Pirko <jpirko@redhat.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: paulmck@linux.vnet.ibm.com, Fengguang Wu <wfg@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Subject: Re: [net-next:master 257/266]
 drivers/net/team/team_mode_loadbalance.c:99:30: sparse: incompatible types
 in comparison expression (different address spaces)
Message-ID: <20120620132329.GD1580@minipsycho.brq.redhat.com>
References: <20120620042743.GA7640@localhost>
 <20120620063607.GA1491@minipsycho>
 <20120620065055.GA5872@localhost>
 <20120620124913.GF2432@linux.vnet.ibm.com>
 <1340197909.4604.956.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340197909.4604.956.camel@edumazet-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wed, Jun 20, 2012 at 03:11:49PM CEST, eric.dumazet@gmail.com wrote:
>On Wed, 2012-06-20 at 05:49 -0700, Paul E. McKenney wrote:
>> On Wed, Jun 20, 2012 at 02:50:55PM +0800, Fengguang Wu wrote:
>> > [CC Paul, the RCU maintainer]
>> > 
>> > On Wed, Jun 20, 2012 at 08:36:07AM +0200, Jiri Pirko wrote:
>> > > Wed, Jun 20, 2012 at 06:27:43AM CEST, wfg@linux.intel.com wrote:
>> > > >Hi Jiri,
>> > > >
>> > > >There are new sparse warnings show up in
>> > > >
>> > > >tree:   git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git master
>> > > >head:   677a3d60fb3153f786a0d28fcf0287670e7bd3c2
>> > > >commit: ab8250d70063f77929fc404c02390a1f64d66416 [257/266] team: lb: introduce infrastructure for userspace driven tx loadbalancing
>> > > >
>> > > >All sparse warnings:
>> > > >
>> > > >drivers/net/team/team_mode_loadbalance.c:99:30: sparse: incompatible types in comparison expression (different address spaces)
>> > > >
>> > > >drivers/net/team/team_mode_loadbalance.c:99:
>> > > >    96			struct lb_port_mapping *pm;
>> > > >    97	
>> > > >    98			pm = &lb_priv->ex->tx_hash_to_port_mapping[i];
>> > > >  > 99			if (pm->port == port) {
>> > > 
>> > > This looks like your checker does not like
>> > > (struct team_port __rcu *) == (struct team_port *)
>> > > But I wonder why (or how should I fix that)
>> 
>> Because you said that it was an RCU-protected pointer, but then did
>> not use an RCU primitive to access it.  In this case, where you are
>> just using the value but not dereferencing it, you can use
>> rcu_access_pointer().
>
>Yes, and please Jiri change the 
>
>rcu_assign_pointer(pm->port, NULL);
>
>by
>
>RCU_INIT_POINTER(pm->port, NULL);

Will do.

>
>
>
