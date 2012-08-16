Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622Ab2HPPLw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 11:11:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57932 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596Ab2HPPLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 11:11:51 -0400
Date: Thu, 16 Aug 2012 17:11:49 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Hillf Danton <dhillf@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] hugetlb: do not use vma_hugecache_offset for
 vma_prio_tree_foreach
Message-ID: <20120816151149.GF2817@dhcp22.suse.cz>
References: <1344866141-27906-1-git-send-email-mhocko@suse.cz>
 <CAJd=RBAwg0k0=8zmRh6jwAYe7Msmxw=HE8qs3YjwXrtsezr78Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJd=RBAwg0k0=8zmRh6jwAYe7Msmxw=HE8qs3YjwXrtsezr78Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 16-08-12 20:45:15, Hillf Danton wrote:
> On Mon, Aug 13, 2012 at 9:55 PM, Michal Hocko <mhocko@suse.cz> wrote:
> > 0c176d5 (mm: hugetlb: fix pgoff computation when unmapping page
> > from vma) fixed pgoff calculation but it has replaced it by
> > vma_hugecache_offset which is not approapriate for offsets used for
> > vma_prio_tree_foreach because that one expects index in page units
> > rather than in huge_page_shift.
> > Using vma_hugecache_offset is not incorrect because the pgoff will fit
> > into the same vmas but it is confusing so the standard PAGE_SHIFT based
> > index calculation is used instead.
> >
> > Cc: Hillf Danton <dhillf@gmail.com>
> > Cc: Mel Gorman <mel@csn.ul.ie>
> > Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > Cc: Andrea Arcangeli <aarcange@redhat.com>
> > Cc: David Rientjes <rientjes@google.com>
> > Signed-off-by: Michal Hocko <mhocko@suse.cz>
> > ---
> 
> Thanks
> 
> Acked-by: Hillf Danton <dhillf@gmail.com>

Thanks Hillf!

> >  mm/hugetlb.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> > index c39e4be..a74ea31 100644
> > --- a/mm/hugetlb.c
> > +++ b/mm/hugetlb.c
> > @@ -2462,7 +2462,8 @@ static int unmap_ref_private(struct mm_struct *mm, struct vm_area_struct *vma,
> >          * from page cache lookup which is in HPAGE_SIZE units.
> >          */
> >         address = address & huge_page_mask(h);
> > -       pgoff = vma_hugecache_offset(h, vma, address);
> > +       pgoff = ((address - vma->vm_start) >> PAGE_SHIFT) +
> > +                       vma->vm_pgoff;
> >         mapping = vma->vm_file->f_dentry->d_inode->i_mapping;
> >
> >         /*
> > --
> > 1.7.10.4
> >

-- 
Michal Hocko
SUSE Labs
