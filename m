Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871Ab0EUEsn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 00:48:43 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46848 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410Ab0EUEsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 00:48:42 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 21 May 2010 13:44:24 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       minskey guo <chaohong_guo@linux.intel.com>, linux-mm@kvack.org,
       prarit@redhat.com, andi.kleen@intel.com, linux-kernel@vger.kernel.org,
       minskey guo <chaohong.guo@intel.com>, Tejun Heo <tj@kernel.org>,
       stable@kernel.org
Subject: Re: [PATCH] online CPU before memory failed in pcpu_alloc_pages()
Message-Id: <20100521134424.45e0ee36.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100521105512.0c2cf254.sfr@canb.auug.org.au>
References: <1274163442-7081-1-git-send-email-chaohong_guo@linux.intel.com>
	<20100520134359.fdfb397e.akpm@linux-foundation.org>
	<20100521105512.0c2cf254.sfr@canb.auug.org.au>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 May 2010 10:55:12 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Andrew,
> 
> On Thu, 20 May 2010 13:43:59 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > > --- a/mm/percpu.c
> > > +++ b/mm/percpu.c
> > > @@ -714,13 +714,29 @@ static int pcpu_alloc_pages(struct pcpu_chunk *chunk,
> > 
> > In linux-next, Tejun has gone and moved pcpu_alloc_pages() into the new
> > mm/percpu-vm.c.  So either
> 
> This has gone into Linus' tree today ...
> 

Hmm, a comment here.

Recently, Lee Schermerhorn developed

 numa-introduce-numa_mem_id-effective-local-memory-node-id-fix2.patch

Then, you can use cpu_to_mem() instead of cpu_to_node() to find the
nearest available node.
I don't check cpu_to_mem() is synchronized with NUMA hotplug but
using cpu_to_mem() rather than adding 
=

+			if ((nid == -1) ||
+			    !(node_zonelist(nid, GFP_KERNEL)->_zonerefs->zone))
+				nid = numa_node_id();
+
==

is better. 

Thanks,
-Kame

