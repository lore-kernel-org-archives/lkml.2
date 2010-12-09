Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab0LIRQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 12:16:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64854 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754762Ab0LIRQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 12:16:17 -0500
Date: Thu, 9 Dec 2010 18:14:35 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Mel Gorman <mel@csn.ul.ie>
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
Subject: Re: [PATCH 33 of 66] madvise(MADV_HUGEPAGE)
Message-ID: <20101209171435.GD19131@random.random>
References: <patchbomb.1288798055@v2.random>
 <7193ff8e62fcf7885199.1288798088@v2.random>
 <20101118151935.GW8135@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101118151935.GW8135@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 03:19:35PM +0000, Mel Gorman wrote:
> On Wed, Nov 03, 2010 at 04:28:08PM +0100, Andrea Arcangeli wrote:
> > @@ -121,6 +122,11 @@ static inline int split_huge_page(struct
> >  #define wait_split_huge_page(__anon_vma, __pmd)	\
> >  	do { } while (0)
> >  #define PageTransHuge(page) 0
> > +static inline int hugepage_madvise(unsigned long *vm_flags)
> > +{
> > +	BUG_ON(0);
> 
> What's BUG_ON(0) in aid of?

When CONFIG_TRANSPARENT_HUGEPAGE is disabled, nothing must call that
function (madvise must return -EINVAL like older kernels instead). But
I guess you meant I should convert the BUG_ON(0) to a BUG() instead? (done)

> I should have said it at patch 4 but don't forget that Michael Kerrisk
> should be made aware of MADV_HUGEPAGE so it makes it to a manual page
> at some point.

Ok, I'll forward patch 4.

Thanks,
Andrea
