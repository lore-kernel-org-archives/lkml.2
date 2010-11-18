Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759735Ab0KRQel (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 11:34:41 -0500
Received: from gir.skynet.ie ([193.1.99.77]:41473 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759457Ab0KRQej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 11:34:39 -0500
Date: Thu, 18 Nov 2010 16:34:24 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Rik van Riel <riel@redhat.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Chris Wright <chrisw@sous-sol.org>, bpicco@redhat.com,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Chris Mason <chris.mason@oracle.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 62 of 66] disable transparent hugepages by default on
	small systems
Message-ID: <20101118163424.GH8135@csn.ul.ie>
References: <patchbomb.1288798055@v2.random> <5791385d8111de4b5143.1288798117@v2.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <5791385d8111de4b5143.1288798117@v2.random>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 03, 2010 at 04:28:37PM +0100, Andrea Arcangeli wrote:
> From: Rik van Riel <riel@redhat.com>
> 
> On small systems, the extra memory used by the anti-fragmentation
> memory reserve and simply because huge pages are smaller than large
> pages can easily outweigh the benefits of less TLB misses.
> 

A less obvious concern is if run on a NUMA machine with asymmetric node sizes
and one of them is very small. The reserve could make the node unusable. I've
only seen it happen once in practice (via hugeadm) but it was also a <1G
machine with 4 nodes (don't ask me why).

> In case of the crashdump kernel, OOMs have been observed due to
> the anti-fragmentation memory reserve taking up a large fraction
> of the crashdump image.
> 
> This patch disables transparent hugepages on systems with less
> than 1GB of RAM, but the hugepage subsystem is fully initialized
> so administrators can enable THP through /sys if desired.
> 
> v2: reduce the limit to 512MB
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> Acked-by: Avi Kiviti <avi@redhat.com>
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>

Acked-by: Mel Gorman <mel@csn.ul.ie>

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
