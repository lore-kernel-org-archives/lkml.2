Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab2HOXDp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 19:03:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35901 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab2HOXDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 19:03:44 -0400
Date: Wed, 15 Aug 2012 16:03:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>, Mel Gorman <mgorman@suse.de>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch v2] hugetlb: correct page offset index for sharing pmd
Message-Id: <20120815160342.5b77bd3b.akpm@linux-foundation.org>
In-Reply-To: <CAJd=RBCuvpG49JcTUY+qw-tTdH_vFLgOfJDE3sW97+M04TR+hg@mail.gmail.com>
References: <CAJd=RBC9HhKh5Q0-yXi3W0x3guXJPFz4BNsniyOFmp0TjBdFqg@mail.gmail.com>
	<20120806132410.GA6150@dhcp22.suse.cz>
	<CAJd=RBCuvpG49JcTUY+qw-tTdH_vFLgOfJDE3sW97+M04TR+hg@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Aug 2012 21:37:45 +0800
Hillf Danton <dhillf@gmail.com> wrote:

> On Mon, Aug 6, 2012 at 9:24 PM, Michal Hocko <mhocko@suse.cz> wrote:
> > On Sat 04-08-12 14:08:31, Hillf Danton wrote:
> >> The computation of page offset index is incorrect to be used in scanning
> >> prio tree, as huge page offset is required, and is fixed with well
> >> defined routine.
> >>
> >> Changes from v1
> >>       o s/linear_page_index/linear_hugepage_index/ for clearer code
> >>       o hp_idx variable added for less change
> >>
> >>
> >> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> >> ---
> >>
> >> --- a/arch/x86/mm/hugetlbpage.c       Fri Aug  3 20:34:58 2012
> >> +++ b/arch/x86/mm/hugetlbpage.c       Fri Aug  3 20:40:16 2012
> >> @@ -62,6 +62,7 @@ static void huge_pmd_share(struct mm_str
> >>  {
> >>       struct vm_area_struct *vma = find_vma(mm, addr);
> >>       struct address_space *mapping = vma->vm_file->f_mapping;
> >> +     pgoff_t hp_idx;
> >>       pgoff_t idx = ((addr - vma->vm_start) >> PAGE_SHIFT) +
> >>                       vma->vm_pgoff;
> >
> > So we have two indexes now. That is just plain ugly!
> >
> 
> Two indexes result in less code change here and no change
> in page_table_shareable. Plus linear_hugepage_index tells
> clearly readers that hp_idx and idx are different.
> 
> Anyway I have no strong opinion to keep
> page_table_shareable unchanged, but prefer less changes.

Don't be too concerned about the size of a change - it's the end result
which matters.  If a larger patch results in a better end result, then
do the larger patch.

Also, please add some details to the changelog: the patch is fixing a
bug but we aren't told about the end-user-visible effects of that bug. 
This is important information.

