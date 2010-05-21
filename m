Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676Ab0EUMdQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 08:33:16 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:5897 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223Ab0EUMdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 08:33:14 -0400
Subject: Re: [PATCH] online CPU before memory failed in pcpu_alloc_pages()
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       minskey guo <chaohong_guo@linux.intel.com>, linux-mm@kvack.org,
       prarit@redhat.com, andi.kleen@intel.com, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, stable@kernel.org
In-Reply-To: <20100521134424.45e0ee36.kamezawa.hiroyu@jp.fujitsu.com>
References: <1274163442-7081-1-git-send-email-chaohong_guo@linux.intel.com>
	 <20100520134359.fdfb397e.akpm@linux-foundation.org>
	 <20100521105512.0c2cf254.sfr@canb.auug.org.au>
	 <20100521134424.45e0ee36.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain
Organization: HP/LKTT
Date: Fri, 21 May 2010 08:32:09 -0400
Message-Id: <1274445129.9131.9.camel@useless.americas.hpqcorp.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-21 at 13:44 +0900, KAMEZAWA Hiroyuki wrote:
> On Fri, 21 May 2010 10:55:12 +1000
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> > Hi Andrew,
> > 
> > On Thu, 20 May 2010 13:43:59 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> > >
> > > > --- a/mm/percpu.c
> > > > +++ b/mm/percpu.c
> > > > @@ -714,13 +714,29 @@ static int pcpu_alloc_pages(struct pcpu_chunk *chunk,
> > > 
> > > In linux-next, Tejun has gone and moved pcpu_alloc_pages() into the new
> > > mm/percpu-vm.c.  So either
> > 
> > This has gone into Linus' tree today ...
> > 
> 
> Hmm, a comment here.
> 
> Recently, Lee Schermerhorn developed
> 
>  numa-introduce-numa_mem_id-effective-local-memory-node-id-fix2.patch
> 
> Then, you can use cpu_to_mem() instead of cpu_to_node() to find the
> nearest available node.
> I don't check cpu_to_mem() is synchronized with NUMA hotplug but
> using cpu_to_mem() rather than adding 
> =
> 
> +			if ((nid == -1) ||
> +			    !(node_zonelist(nid, GFP_KERNEL)->_zonerefs->zone))
> +				nid = numa_node_id();
> +
> ==
> 
> is better. 


Kame-san, all:

numa_mem_id() and cpu_to_mem() are not supported [yet] on x86 because
x86 hides all memoryless nodes and moves cpus to "nearby" [for some
definition thereof] nodes with memory.  So, these interfaces just return
numa_node_id() and cpu_to_node() for x86.  Perhaps that will change
someday...

Lee


> 
> Thanks,
> -Kame
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

