Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758540Ab0LNJqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 04:46:19 -0500
Received: from gir.skynet.ie ([193.1.99.77]:36521 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758489Ab0LNJqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 04:46:16 -0500
Date: Tue, 14 Dec 2010 09:45:56 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
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
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Chris Mason <chris.mason@oracle.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 55 of 66] select CONFIG_COMPACTION if
	TRANSPARENT_HUGEPAGE enabled
Message-ID: <20101214094556.GF13914@csn.ul.ie>
References: <patchbomb.1288798055@v2.random> <89a62752012298bb500c.1288798110@v2.random> <20101109151756.BC7B.A69D9226@jp.fujitsu.com> <20101109211145.GB6809@random.random> <20101118162245.GE8135@csn.ul.ie> <20101209190407.GJ19131@random.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20101209190407.GJ19131@random.random>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 09, 2010 at 08:04:07PM +0100, Andrea Arcangeli wrote:
> On Thu, Nov 18, 2010 at 04:22:45PM +0000, Mel Gorman wrote:
> > Just to confirm - by hang, you mean grinds to a slow pace as opposed to
> > coming to a complete stop and having to restart?
> 
> Hmm it's like if you're gigabytes in swap and apps hangs for a while
> and system is not really usable and it swaps for most new memory
> allocations despite there's plenty of memory free, but it's not a
> deadlock of course.
> 

Ok, but it's likely to be kswapd being very aggressive because it's
woken up frequently and tries to balance all zones. Once it's not
deadlocking entirely, there isn't a more fundamental bug hiding in there
somewhere.

> BTW, alternatively I could:
> 
>  unsigned long transparent_hugepage_flags __read_mostly =
>         (1<<TRANSPARENT_HUGEPAGE_FLAG)|
> +#ifdef CONFIG_COMPACTION
> +       (1<<TRANSPARENT_HUGEPAGE_DEFRAG_FLAG)|
> +#endif
>         (1<<TRANSPARENT_HUGEPAGE_DEFRAG_KHUGEPAGED_FLAG);
> 
> That would adds GFP_ATOMIC to THP allocation if compaction wasn't
> selected,

With GFP_NO_KSWAPD, it would stop trashing I suspect the success rate
would be extremely low as nothing will be defragmenting memory.

> but I think having compaction enabled diminish the risk of
> misconfigured kernels leading to unexpected measurements and behavior,
> so I feel much safer to keep the select COMPACTION in this patch.
> 

Agreed.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
