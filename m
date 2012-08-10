Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640Ab2HJMhY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 08:37:24 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:65387 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab2HJMhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 08:37:20 -0400
MIME-Version: 1.0
In-Reply-To: <20120810122730.GA1425@dhcp22.suse.cz>
References: <CAJd=RBB=jKD+9JcuBmBGC8R8pAQ-QoWHexMNMsXpb9zV548h5g@mail.gmail.com>
	<20120803133235.GA8434@dhcp22.suse.cz>
	<20120810094825.GA1440@dhcp22.suse.cz>
	<CAJd=RBDA3pLYDpryxafx6dLoy7Fk8PmY-EFkXCkuJTB2ywfsjA@mail.gmail.com>
	<20120810122730.GA1425@dhcp22.suse.cz>
Date: Fri, 10 Aug 2012 20:37:20 +0800
Message-ID: <CAJd=RBAvCd-QcyN9N4xWEiLeVqRypzCzbADvD1qTziRVCHjd4Q@mail.gmail.com>
Subject: Re: [patch] hugetlb: correct page offset index for sharing pmd
From: Hillf Danton <dhillf@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2012 at 8:27 PM, Michal Hocko <mhocko@suse.cz> wrote:
>
> I guess you mean unmap_ref_private and that has been changed by you
> (0c176d5 mm: hugetlb: fix pgoff computation when unmapping page from
> vma)...  I was wrong at that time when giving my Reviewed-by. The patch
> didn't break anything because you still find all relevant vmas because
> vma_hugecache_offset just provides a smaller index which is still within
> boundaries.

No, as shown by the log message of 0c176d52b,  that fix was
triggered by  (vma->vm_pgoff >> PAGE_SHIFT), thus I dont see
what you really want to revert.


> I think that 0c176d52 should be reverted because we do not have to refer
> to the head page in this case and as we can see it causes confusion.
>
