Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538Ab0KRNN5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 08:13:57 -0500
Received: from gir.skynet.ie ([193.1.99.77]:52501 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757020Ab0KRNN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 08:13:56 -0500
Date: Thu, 18 Nov 2010 13:13:40 +0000
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
Subject: Re: [PATCH 23 of 66] add pmd_huge_pte to mm_struct
Message-ID: <20101118131340.GQ8135@csn.ul.ie>
References: <patchbomb.1288798055@v2.random> <8497eaf69975ceba0c79.1288798078@v2.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <8497eaf69975ceba0c79.1288798078@v2.random>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 03, 2010 at 04:27:58PM +0100, Andrea Arcangeli wrote:
> From: Andrea Arcangeli <aarcange@redhat.com>
> 
> This increase the size of the mm struct a bit but it is needed to preallocate
> one pte for each hugepage so that split_huge_page will not require a fail path.
> Guarantee of success is a fundamental property of split_huge_page to avoid
> decrasing swapping reliability and to avoid adding -ENOMEM fail paths that
> would otherwise force the hugepage-unaware VM code to learn rolling back in the
> middle of its pte mangling operations (if something we need it to learn
> handling pmd_trans_huge natively rather being capable of rollback). When
> split_huge_page runs a pte is needed to succeed the split, to map the newly
> splitted regular pages with a regular pte.  This way all existing VM code
> remains backwards compatible by just adding a split_huge_page* one liner. The
> memory waste of those preallocated ptes is negligible and so it is worth it.
> 
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> Acked-by: Rik van Riel <riel@redhat.com>

Acked-by: Mel Gorman <mel@csn.ul.ie>

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
