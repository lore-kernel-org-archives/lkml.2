Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab2HJM1d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 08:27:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38093 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908Ab2HJM1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 08:27:32 -0400
Date: Fri, 10 Aug 2012 14:27:30 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Hillf Danton <dhillf@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] hugetlb: correct page offset index for sharing pmd
Message-ID: <20120810122730.GA1425@dhcp22.suse.cz>
References: <CAJd=RBB=jKD+9JcuBmBGC8R8pAQ-QoWHexMNMsXpb9zV548h5g@mail.gmail.com>
 <20120803133235.GA8434@dhcp22.suse.cz>
 <20120810094825.GA1440@dhcp22.suse.cz>
 <CAJd=RBDA3pLYDpryxafx6dLoy7Fk8PmY-EFkXCkuJTB2ywfsjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJd=RBDA3pLYDpryxafx6dLoy7Fk8PmY-EFkXCkuJTB2ywfsjA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 10-08-12 20:07:12, Hillf Danton wrote:
> On Fri, Aug 10, 2012 at 5:48 PM, Michal Hocko <mhocko@suse.cz> wrote:
> > On Fri 03-08-12 15:32:35, Michal Hocko wrote:
> >> On Fri 03-08-12 20:56:45, Hillf Danton wrote:
> >> > The computation of page offset index is open coded, and incorrect, to
> >> > be used in scanning prio tree, as huge page offset is required, and is
> >> > fixed with the well defined routine.
> >>
> >> I guess that nobody reported this because if someone really wants to
> >> share he will use aligned address for mmap/shmat and so the index is 0.
> >> Anyway it is worth fixing. Thanks for pointing out!
> >
> > I have looked at the code again and I don't think there is any problem
> > at all. vma_prio_tree_foreach understands page units so it will find
> > appropriate svmas.
> > Or am I missing something?
> 
> Well, what if another case of vma_prio_tree_foreach used by hugetlb
> is correct?

I guess you mean unmap_ref_private and that has been changed by you
(0c176d5 mm: hugetlb: fix pgoff computation when unmapping page from
vma)...  I was wrong at that time when giving my Reviewed-by. The patch
didn't break anything because you still find all relevant vmas because
vma_hugecache_offset just provides a smaller index which is still within
boundaries.
I think that 0c176d52 should be reverted because we do not have to refer
to the head page in this case and as we can see it causes confusion.

> 
> Hillf

-- 
Michal Hocko
SUSE Labs
