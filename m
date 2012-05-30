Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913Ab2E3Vjb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 17:39:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47700 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754266Ab2E3Vja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 17:39:30 -0400
Date: Wed, 30 May 2012 14:39:28 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: "Luck, Tony" <tony.luck@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: Don't try allocating memory from offline nodes
In-Reply-To: <1338371057.26856.226.camel@twins>
Message-ID: <alpine.DEB.2.00.1205301438540.9716@chino.kir.corp.google.com>
References: <4fc507a211523c4a14@agluck-desktop.sc.intel.com> <alpine.DEB.2.00.1205292019560.14373@chino.kir.corp.google.com> <1338371057.26856.226.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2012, Peter Zijlstra wrote:

> On Tue, 2012-05-29 at 20:21 -0700, David Rientjes wrote:
> > On Tue, 29 May 2012, Luck, Tony wrote:
> > 
> > > Index: linux-2.6/kernel/sched/core.c
> > > ===================================================================
> > > --- linux-2.6.orig/kernel/sched/core.c
> > > +++ linux-2.6/kernel/sched/core.c
> > > @@ -6449,7 +6449,7 @@ static void sched_init_numa(void)
> > >  			return;
> > >  
> > >  		for (j = 0; j < nr_node_ids; j++) {
> > > -			struct cpumask *mask = kzalloc_node(cpumask_size(), GFP_KERNEL, j);
> > > +			struct cpumask *mask = kzalloc(cpumask_size(), GFP_KERNEL);
> > >  			if (!mask)
> > >  				return;
> > >  
> > 
> > It's definitely better if we can allocate on the node, though, so perhaps 
> > do the same thing that I did in 
> > http://marc.info/?l=linux-kernel&m=133778739503111 by doing
> > kzalloc_node(..., node_online(j) ? j : NUMA_NO_NODE)?
> 
> This data isn't used overly much, only when rebuilding the sched
> domains, so its not performance critical. I only used per-node
> allocations because it seemed the right thing to do. If it doesn't work,
> I wouldn't bother with making it more complex.
> 

Ok, if you don't think these cpumasks need locality for performance, then

Acked-by: David Rientjes <rientjes@google.com>
