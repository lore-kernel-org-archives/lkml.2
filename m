Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932566Ab2E3Jo0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 05:44:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:42415 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932430Ab2E3JoY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 05:44:24 -0400
Message-ID: <1338371057.26856.226.camel@twins>
Subject: Re: [PATCH] sched: Don't try allocating memory from offline nodes
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: David Rientjes <rientjes@google.com>
Cc: "Luck, Tony" <tony.luck@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Date: Wed, 30 May 2012 11:44:17 +0200
In-Reply-To: <alpine.DEB.2.00.1205292019560.14373@chino.kir.corp.google.com>
References: <4fc507a211523c4a14@agluck-desktop.sc.intel.com>
	 <alpine.DEB.2.00.1205292019560.14373@chino.kir.corp.google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-29 at 20:21 -0700, David Rientjes wrote:
> On Tue, 29 May 2012, Luck, Tony wrote:
> 
> > Index: linux-2.6/kernel/sched/core.c
> > ===================================================================
> > --- linux-2.6.orig/kernel/sched/core.c
> > +++ linux-2.6/kernel/sched/core.c
> > @@ -6449,7 +6449,7 @@ static void sched_init_numa(void)
> >  			return;
> >  
> >  		for (j = 0; j < nr_node_ids; j++) {
> > -			struct cpumask *mask = kzalloc_node(cpumask_size(), GFP_KERNEL, j);
> > +			struct cpumask *mask = kzalloc(cpumask_size(), GFP_KERNEL);
> >  			if (!mask)
> >  				return;
> >  
> 
> It's definitely better if we can allocate on the node, though, so perhaps 
> do the same thing that I did in 
> http://marc.info/?l=linux-kernel&m=133778739503111 by doing
> kzalloc_node(..., node_online(j) ? j : NUMA_NO_NODE)?

This data isn't used overly much, only when rebuilding the sched
domains, so its not performance critical. I only used per-node
allocations because it seemed the right thing to do. If it doesn't work,
I wouldn't bother with making it more complex.
